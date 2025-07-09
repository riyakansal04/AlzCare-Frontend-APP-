import 'dart:convert';
import 'package:alzcare/model/feed_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class LifestyleTipsPage extends StatelessWidget {
  Future<List<FeedItem>> loadTips() async {
    final String jsonString = await rootBundle.loadString('assets/data/lifestyle_tips.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((item) => FeedItem.fromJson(item)).toList();
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
          "Lifestyle Tips",
          style: GoogleFonts.merriweather(
            color: Color(0xFFEACCA9),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<FeedItem>>(
        future: loadTips(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final tips = snapshot.data!;
          return ListView.builder(
            itemCount: tips.length,
            itemBuilder: (context, index) {
              final item = tips[index];
              return Card(
                margin: EdgeInsets.all(12),
                elevation: 4,
                color: Color(0xFFfcefdc),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.lora(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF755b48),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        item.summary,
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
                          onPressed: () => _launchLink(item.link),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
