import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import all your service pages here
import 'track.dart';
import 'mindmaze.dart';
import 'journal.dart';
import 'livefeedservicespage.dart';
import 'event.dart';
// import your Remind page if you have it, or comment for now

class ServicesPage extends StatelessWidget {
  final List<Map<String, String>> services = [
    {'icon': 'assets/icons/icon 1-removebg-preview.jpg', 'label': 'Track'},
    {'icon': 'assets/icons/icon 11-removebg-preview.jpg', 'label': 'Alerts'},
    {'icon': 'assets/icons/icon 3-removebg-preview.jpg', 'label': 'MindMaze'},
    {'icon': 'assets/icons/icon 4-removebg-preview.jpg', 'label': 'Journal'},
    {'icon': 'assets/icons/icon 5-removebg-preview.jpg', 'label': 'Remind'},
    {'icon': 'assets/icons/Call-removebg-preview.jpg', 'label': 'Connect'},
    {'icon': 'assets/icons/icon 12-removebg-preview.jpg', 'label': 'EventTracker'},
    {'icon': 'assets/icons/icon 14-removebg-preview.jpg', 'label': 'Feed'},
  ];

  void _navigateToService(BuildContext context, String label) {
    Widget? destination;

    switch (label) {
      case 'Track':
        destination = const TrackWidget();
        break;
      case 'MindMaze':
        destination = const MindMazePage();
        break;
      case 'Journal':
        destination = const JournalPage();
        break;
      case 'EventTracker':
        destination = EventFormPage();
        break;
      case 'Feed':
        destination = LiveFeedServicesPage();
        break;
      case 'Remind':
        // destination = RemindPage(); // uncomment if you have RemindPage
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Remind feature coming soon!')),
        );
        return;
      case 'Alerts':
      case 'Connect':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label feature coming soon!')),
        );
        return;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tapped on $label')),
        );
        return;
    }

    if (destination != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEACCA9),
      appBar: AppBar(
        title: Text('All Services', style: GoogleFonts.merriweather(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFEACCA9))),
        backgroundColor: const Color(0xFF755b48), foregroundColor: const Color(0xFFEACCA9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: services.map((service) {
            return GestureDetector(
              onTap: () => _navigateToService(context, service['label']!),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(service['icon']!, width: 70, height: 70),
                  const SizedBox(height: 8),
                  Text(
                    service['label']!,
                    style: GoogleFonts.lora(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: const Color(0xFF755B48),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
