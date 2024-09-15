class Event {
  final String title;
  final double rating;
  final int reviews;
  final int duration;
  final int price;
  final String imageUrl;
  bool isFavorite = false;

  Event({
    required this.title,
    required this.rating,
    required this.reviews,
    required this.duration,
    required this.price,
    required this.imageUrl,
  });

  static Event fromJson(Map<String, dynamic> jsonData) {
    return Event(
      imageUrl: jsonData["imageUrl"],
      title: jsonData["title"],
      rating: jsonData["rating"],
      reviews: jsonData["reviews"],
      duration: jsonData["duration"],
      price: jsonData["price"],
    );
  }
}
