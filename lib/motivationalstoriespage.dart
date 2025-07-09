import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

// Model for a motivational story
class StoryItem {
  final String title;
  final String summary;
  final String imageUrl;
  final String link;

  StoryItem({
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.link,
  });

  factory StoryItem.fromJson(Map<String, dynamic> json) {
    return StoryItem(
      title: json['title'],
      summary: json['summary'],
      imageUrl: json['imageUrl'],
      link: json['link'],
    );
  }
}

class MotivationalStoriesPage extends StatefulWidget {
  @override
  _MotivationalStoriesPageState createState() => _MotivationalStoriesPageState();
}

class _MotivationalStoriesPageState extends State<MotivationalStoriesPage> {
  List<StoryItem> stories = [];

  @override
  void initState() {
    super.initState();
    loadStories();
  }

  Future<void> loadStories() async {
    final String jsonString = await rootBundle.loadString('assets/data/motivational_stories.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      stories = jsonData.map((item) => StoryItem.fromJson(item)).toList();
    });
  }

  void _launchLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEACCA9),
      appBar: AppBar(
        backgroundColor: Color(0xFF755b48),
        foregroundColor: Color(0xFFEACCA9),
        title: Text(
          "Motivational Stories",
          style: GoogleFonts.merriweather(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: stories.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: stories.length,
              padding: EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final story = stories[index];
                return Card(
                  color: Color(0xFFfcefdc),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story.title,
                          style: GoogleFonts.lora(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF755b48),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          story.summary,
                          style: GoogleFonts.lora(
                            fontSize: 14,
                            color: Color(0xFF755b48),
                          ),
                        ),
                        SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            icon: Icon(Icons.open_in_new, color: Color(0xFF755b48)),
                            label: Text(
                              "Read More",
                              style: GoogleFonts.lora(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF755b48),
                              ),
                            ),
                            onPressed: () => _launchLink(story.link),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
