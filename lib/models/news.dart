class News {
  final String title;
  final String content;
  final String imageUrl;
  final String category;
  final DateTime date;
  bool isFavorite = false;

  News({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.category,
    required this.date,
  });

  static News fromJson(Map<String, dynamic> jsonData) {
    return News(
      title: jsonData["title"],
      content: jsonData["description"],
      imageUrl: jsonData["imageUrl"],
      category: jsonData["category"],
      date: DateTime.parse(jsonData["date"]),
    );
  }
}
