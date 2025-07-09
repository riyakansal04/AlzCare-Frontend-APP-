import 'dart:async'; // For the timer
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DevelopersInfoPage extends StatefulWidget {
  const DevelopersInfoPage({Key? key}) : super(key: key);

  @override
  _DevelopersInfoPageState createState() => _DevelopersInfoPageState();
}

class _DevelopersInfoPageState extends State<DevelopersInfoPage> {
  // Controller for automatic scrolling
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Function to handle automatic page scroll
  void _startAutoScroll() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentIndex == 1) {
        // If it's at the second developer, go back to the first
        _currentIndex = 0;
      } else {
        // Otherwise, move to the next developer
        _currentIndex = 1;
      }

      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _startAutoScroll(); // Start the auto-scroll when the page loads
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEACCA9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF755b48),
        foregroundColor: Color(0xFFEACCA9),
        iconTheme: const IconThemeData(color: Color(0xFFEACCA9)),
        title: Text(
          'About AlzCare',
          style: GoogleFonts.merriweather(
            color: const Color(0xFFEACCA9),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'AlzCare',
              style: GoogleFonts.merriweather(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF755b48),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Version: v1.0.0',
              style: GoogleFonts.merriweather(
                fontSize: 16,
                color: const Color(0xFF755b48),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Developed by:',
              style: GoogleFonts.merriweather(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF755b48),
              ),
            ),
            const SizedBox(height: 16),

            // PageView for automatic scrolling
            SizedBox(
              height: 400, // Set height for scrolling container
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: const [
                  DeveloperCard(
                    name: 'Riya Kansal',
                    role: 'Lead Developer',
                    imagePath: 'assets/dev 2.jpg',
                  ),
                  DeveloperCard(
                    name: 'Jappanjot Kaur',
                    role: 'Backend Engineer',
                    imagePath: 'assets/dev 1.jpg',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              '© 2025 AlzCare Team\nAll rights reserved.',
              textAlign: TextAlign.center,
              style: GoogleFonts.merriweather(
                fontSize: 14,
                color: const Color(0xFF755b48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeveloperCard extends StatelessWidget {
  final String name;
  final String role;
  final String imagePath;

  const DeveloperCard({
    Key? key,
    required this.name,
    required this.role,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFfcefdc),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF755b48).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 100,
            backgroundImage: AssetImage(imagePath),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: GoogleFonts.merriweather(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: const Color(0xFF755b48),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            role,
            style: GoogleFonts.merriweather(
              color: const Color(0xFF755b48).withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
