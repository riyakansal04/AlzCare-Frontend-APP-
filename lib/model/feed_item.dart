class FeedItem {
  final String title;
  final String summary;
  final String imageUrl;
  final String link;

  FeedItem({
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.link,
  });

  factory FeedItem.fromJson(Map<String, dynamic> json) {
    return FeedItem(
      title: json['title'],
      summary: json['summary'],
      imageUrl: json['imageUrl'],
      link: json['link'],
    );
  }
}