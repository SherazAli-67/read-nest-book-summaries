class Section {
  final String title;
  final String content;
  final String contentLink;

  Section({
    required this.title,
    required this.content,
    required this.contentLink,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'contentLink': contentLink,
    };
  }

  factory Section.fromMap(Map<String, dynamic> map) {
    return Section(
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      contentLink: map['contentLink'] ?? '',
    );
  }
}