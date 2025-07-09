class StoryItem {
    final String title;
  final String summary;
  final String imageUrl;
  final String link;
  StoryItem({required this.title,
    required this.summary,
    required this.imageUrl,
    required this.link,});

  factory StoryItem.fromJson(Map<String, dynamic> json) {
    return StoryItem(
      title: json['title'],
      summary: json['summary'],
      imageUrl: json['imageUrl'],
      link: json['link'],
    );
  }
}
