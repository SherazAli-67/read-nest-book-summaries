import 'package:read_nest/src/models/section_model.dart';

class Book {
  final String bookID;
  final String author;
  final String bookName;
  final String aboutAuthor;
  final String introTitle;
  final String introLink;
  final String shortSummary;
  final String shortSummaryLink;
  final String time;
  final String keyIdeas;
  final List<String> categories;
  final String introduction;
  final String introductionLink;
  final List<Section> sections;
  final String image;
  final int timeInMinutes;


  Book({
    required this.bookID,
    required this.author,
    required this.bookName,
    required this.aboutAuthor,
    required this.introTitle,
    required this.introLink,
    required this.shortSummary,
    required this.shortSummaryLink,
    required this.time,
    required this.keyIdeas,
    required this.categories,
    required this.introduction,
    required this.introductionLink,
    required this.sections,
    required this.image,
    required this.timeInMinutes
  });

  Map<String, dynamic> toMap() {
    return {
      'bookID' : bookID,
      'author': author,
      'bookName': bookName,
      'aboutAuthor': aboutAuthor,
      'introTitle': introTitle,
      'introLink': introLink,
      'shortSummary': shortSummary,
      'shortSummaryLink': shortSummaryLink,
      'time': time,
      'keyIdeas': keyIdeas,
      'categories': categories,
      'introduction': introduction,
      'introductionLink': introductionLink,
      'sections': sections.map((s) => s.toMap()).toList(),
      'image': image,
      'timeInMinutes' : timeInMinutes,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      bookID: map['bookID'] ?? '',
      author: map['author'] ?? '',
      bookName: map['bookName'] ?? '',
      aboutAuthor: map['aboutAuthor'] ?? '',
      introTitle: map['introTitle'] ?? '',
      introLink: map['introLink'] ?? '',
      shortSummary: map['shortSummary'] ?? '',
      shortSummaryLink: map['shortSummaryLink'] ?? '',
      time: map['time'] ?? '',
      keyIdeas: map['keyIdeas'] ?? '',
      categories: List<String>.from(map['categories'] ?? []),
      introduction: map['introduction'] ?? '',
      introductionLink: map['introductionLink'] ?? '',
      sections: (map['sections'] as List<dynamic>? ?? [])
          .map((s) => Section.fromMap(s as Map<String, dynamic>))
          .toList(),
      image: map['image'] ?? '',
      timeInMinutes: map['timeInMinutes'] ?? 999,
    );
  }
}
