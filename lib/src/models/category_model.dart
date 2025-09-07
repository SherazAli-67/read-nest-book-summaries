class Category {
  final String id;
  final String title;
  final int totalSummaries;

  Category({
    required this.id,
    required this.title,
    required this.totalSummaries
  });


  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'title' : title,
      'totalSummaries' : totalSummaries
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      title: map['title'],
      totalSummaries: map['totalSummaries']
    );
  }
}