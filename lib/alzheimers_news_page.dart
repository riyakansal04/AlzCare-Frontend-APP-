import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class AlzheimersNewsPage extends StatefulWidget {
  @override
  _AlzheimersNewsPageState createState() => _AlzheimersNewsPageState();
}

class _AlzheimersNewsPageState extends State<AlzheimersNewsPage> {
  List<dynamic> articles = [];

  @override
  void initState() {
    super.initState();
    fetchLatestNews();
  }

  Future<void> fetchLatestNews() async {
    final String url = 'https://newsapi.org/v2/everything?q=alzheimers&apiKey=59e7de6c79ea4dc29cf5e5110de675e0';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        articles = data['articles'];
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEACCA9), // Scaffold background
      appBar: AppBar(
        foregroundColor: Color(0xFFEACCA9),
        backgroundColor: Color(0xFF755b48), // AppBar background
        title: Text(
          "Latest News on Alzheimer's",
          style: GoogleFonts.merriweather(
            fontWeight: FontWeight.bold,
            fontSize: 21,
            color: Color(0xFFEACCA9),
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xFFEACCA9)),
      ),
      body: articles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: articles.length,
              padding: EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final article = articles[index];
                return Card(
                  color: Color(0xFFfcefdc), // Card background color
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
                          article['title'] ?? 'No Title',
                          style: GoogleFonts.merriweather(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF755b48),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          article['description'] ?? 'No Description',
                          style: GoogleFonts.merriweather(
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
                              style: GoogleFonts.merriweather(
                                color: Color(0xFF755b48),
                              ),
                            ),
                            onPressed: () {
                              final url = article['url'];
                              if (url != null) {
                                _launchUrl(url);
                              }
                            },
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

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
    } else {
      throw 'Could not launch $url';
    }
  }
}
