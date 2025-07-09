import 'package:alzcare/alzheimers_news_page.dart';
import 'package:alzcare/lifestyle_tips_page.dart';
import 'package:alzcare/motivationalstoriespage.dart';
import 'package:alzcare/tips_of_the_day.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LiveFeedServicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<_FeedSection> feedSections = [
      _FeedSection(
        title: "Lifestyle Tips & Health Advice",
        subtitle: "Learn about Alzheimer, healthy living, and brain care",
        icon: Icons.favorite,
        page: LifestyleTipsPage(),
      ),
      _FeedSection(
        title: "Tips of the Day",
        subtitle: "Daily inspiration and wellness suggestions",
        icon: Icons.lightbulb,
        page: TipsOfTheDayPage(),
      ),
      _FeedSection(
        title: "Latest News on Alzheimer's",
        subtitle: "Stay updated with the latest news and research",
        icon: Icons.newspaper,
        page: AlzheimersNewsPage(),
      ),
      _FeedSection(
        title: "Blogs & Stories",
        subtitle: "Real-life experiences and caregiver stories",
        icon: Icons.article,
        page: MotivationalStoriesPage(),
      ),
    ];

    return Scaffold(
      backgroundColor: Color(0xFFEACCA9), 
      // Scaffold background
      appBar: AppBar(
        backgroundColor: Color(0xFF755b48),
        foregroundColor:Color(0xFFEACCA9), // AppBar background
        title: Text(
          "Live Feed Services",
          style: GoogleFonts.merriweather(
            color: Color(0xFFEACCA9),
            fontWeight: FontWeight.bold, 
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: feedSections.length,
        itemBuilder: (context, index) {
          final section = feedSections[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            color: Color(0xFFfcefdc), // Card background
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Icon(section.icon, size: 40, color: Color(0xFF755b48)), // Icon color
              title: Text(
                section.title,
                style: GoogleFonts.lora(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF755b48),
                ),
              ),
              subtitle: Text(
                section.subtitle,
                style: GoogleFonts.lora(
                  fontSize: 14,
                  color: Color(0xFF755b48),
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFF755b48)),
              onTap: () {
                _navigateToPage(context, section.page);
              },
            ),
          );
        },
      ),
    );
  }

  // Navigation helper
  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

class _FeedSection {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget page;

  _FeedSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.page,
  });
}
