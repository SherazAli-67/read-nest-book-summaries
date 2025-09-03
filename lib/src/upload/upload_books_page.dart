import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/book_model.dart';
import '../models/section_model.dart';

class UploadBooksPage extends StatelessWidget {
  const UploadBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: ElevatedButton(
          onPressed: uploadBooksFromCsv, child: Text("Upload Books"))),
    );
  }

  /// Helper: trim and normalize nulls
  String _clean(dynamic v) => (v == null) ? '' : v.toString().trim();

  /// Reads assets/csv/test_accounts.csv and uploads to Firestore.
  /// REQUIRE: pubspec.yaml includes the asset path.
  Future<void> uploadBooksFromCsv() async {
    debugPrint("On tap occurred");
    // 1) Load CSV from assets (don’t use manual split — use csv package)
    final raw = await rootBundle.loadString('assets/csv/books.csv');

    // Keep everything as strings; handle quotes/commas
    final rows = const CsvToListConverter(
      shouldParseNumbers: false,
    ).convert(raw);

    debugPrint("Rows: ${rows.length}");
    if (rows.isEmpty) return;


    // 2) Header map
    final headers = rows.first.map((h) => _clean(h)).toList();
    final idx = <String, int>{};
    for (var i = 0; i < headers.length; i++) {
      idx[headers[i]] = i;
    }

    // Helper to read by exact header name
    String cell(Map<String, int> m, List row, String key) {
      final i = m[key];
      if (i == null || i >= row.length) return '';
      return _clean(row[i]);
    }

    final booksCol = FirebaseFirestore.instance.collection('books');

    // 3) Iterate data rows
    for (var r = 1; r < rows.length; r++) {
      final row = rows[r];

      // Required core fields (use exact CSV headers from your file)
      final author = cell(idx, row, 'author');
      final bookName = cell(idx, row, 'bookName');
      if (author.isEmpty && bookName.isEmpty) continue; // skip blank rows

      final aboutAuthor = cell(idx, row, 'aboutAuthor');
      final introTitle = cell(idx, row, 'introTitle');
      final introLink = cell(idx, row, 'introLink');
      final shortSummary = cell(idx, row, 'shortSummary');
      final shortSummaryLink = cell(idx, row, 'shortSummaryLink');
      final time = cell(idx, row, 'time');
      final introduction = cell(idx, row, 'introduction');
      final introductionLink = cell(idx, row, 'introductionLink');
      final image = cell(idx, row, 'image');
      final keyIdeas = cell(idx, row, 'keyIdeas');
      final parts = time.trim().split(' ');
      int timeInMinutes= int.tryParse(parts[0]) ?? 15;
      // Categories: category1..category5 (lowercase)
      final categories = <String>[];
      for (var i = 1; i <= 5; i++) {
        final c = cell(idx, row, 'category$i');
        if (c.isNotEmpty) categories.add(c);
      }

      // Sections: "Section N", "Section N Link", "Section N Title"
      final sections = <Section>[];
      for (var i = 1; i <= 20; i++) {
        final content = cell(idx, row, 'Section $i');
        final contentLink = cell(idx, row, 'Section $i Link');
        final title = cell(idx, row, 'Section $i Title');

        // Only add if any part is non-empty
        if (content.isNotEmpty || title.isNotEmpty || contentLink.isNotEmpty) {
          sections.add(Section(
            content: content,
            title: title,
            contentLink: contentLink,
          ));
        }
      }

      // Prefer computing keyIdeas from sections length to avoid mismatch
      // final computedKeyIdeas = sections.length;

      debugPrint("Uploading book");
      // Create doc with ID, and also store bookId inside document
      final docRef = booksCol.doc();
      final book = Book(
        bookID: docRef.id,
        author: author,
        bookName: bookName,
        aboutAuthor: aboutAuthor,
        introTitle: introTitle,
        introLink: introLink,
        shortSummary: shortSummary,
        shortSummaryLink: shortSummaryLink,
        time: time,
        keyIdeas: keyIdeas,
        categories: categories,
        introduction: introduction,
        introductionLink: introductionLink,
        sections: sections,
        image: image,
        timeInMinutes: timeInMinutes
      );

      await docRef.set(book.toMap());

      // Optional debug logs
      debugPrint('Uploaded: $bookName — sections: ${sections.length}, categories: ${categories.length}, timeStr: $time, timeInt: $timeInMinutes');
    }
  }

  Future<void> updateTimeInBooks()async{
    debugPrint("On tap");
    final firestore = FirebaseFirestore.instance.collection('books');
    QuerySnapshot querySnapshot = await firestore.get();
    for(int i=0;i<2;i++){
      final map = querySnapshot.docs[i].data() as Map<String,dynamic>;
      // Split by space and take the first part
      final parts = map['time'].trim().split(' ');
      int time= int.tryParse(parts[0]) ?? 15;

      querySnapshot.docs.forEach((doc) async {
        await firestore.doc(doc.id).update({
          'timeInMinutes' : time
        });
        debugPrint("Time in str: ${map['time']}, in int: $time, updated for: ${doc.id}");
      });
    }

  }
}