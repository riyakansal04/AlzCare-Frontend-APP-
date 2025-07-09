import 'dart:async';
import 'package:alzcare/event.dart';
import 'package:alzcare/journal.dart';
import 'package:alzcare/profile_page.dart';
import 'package:alzcare/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'track.dart';
import 'mindmaze.dart';
import 'livefeedservicespage.dart';
import 'settings.dart';
import 'login.dart';

class AutoImageSlider extends StatefulWidget {
  const AutoImageSlider({Key? key}) : super(key: key);

  @override
  State<AutoImageSlider> createState() => _AutoImageSliderState();
}

class ServiceIcon extends StatefulWidget {
  final String imagePath;
  final String label;

  const ServiceIcon({super.key, required this.imagePath, required this.label});

  @override
  State<ServiceIcon> createState() => _ServiceIconState();
}

class _ServiceIconState extends State<ServiceIcon> with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.95);
  void _onTapUp(_) => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: () {
        setState(() => _scale = 1.0); // Reset scale
        

        if (widget.label == 'Track' || widget.label == 'MindMaze' || widget.label == 'Feed' || widget.label == 'EventTracker' || widget.label == 'Journal') {
          Widget destination;

          if (widget.label == 'Track') {
            destination = const TrackWidget();
          } else if (widget.label == 'MindMaze') {
            destination = const MindMazePage();
            }else if (widget.label == 'EventTracker'){
              destination = EventFormPage();
          }  else if (widget.label == 'Journal') {
            destination = const JournalPage();
}else {
            destination = LiveFeedServicesPage();
          }

          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 600),
              pageBuilder: (context, animation, secondaryAnimation) => destination,
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                final offsetAnimation = Tween<Offset>(
                  begin: const Offset(1.0, 0.0), // Slide in from right
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ));

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        } else if (widget.label == 'Alerts' || widget.label == 'Connect') {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('${widget.label} feature coming soon!')),
  );
}else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tapped on ${widget.label}')),
          );
        }
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(widget.imagePath, width: 70, height: 70),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: GoogleFonts.lora(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFF755B48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AutoImageSliderState extends State<AutoImageSlider> {
  final PageController _controller = PageController();
  final List<String> _images = [
    'assets/images/slider 1.jpg',
    'assets/images/slider 2.jpg',
    'assets/images/slider 3.jpg',
    'assets/images/slider 4.jpg',
    'assets/images/slider 5.jpg',
  ];
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

  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildQuickAction(IconData icon, String label) {
  return GestureDetector(
    onTap: () {
      if (label == 'Settings') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
      } else if (label == 'Profile') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
      } else if (label == 'Services') {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ServicesPage()),
  );
}else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label tapped')),
        );
      }
    },
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFeacca9),
            child: Icon(
              icon,
              color: Color(0xFF755B48),
              size: 32,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.lora(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF755B48),
            ),
          ),
        ],
      ),
    );
  }
@override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      backgroundColor: const Color(0xFFeacca9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFeacca9),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Welcome to AlzCare',
          style: GoogleFonts.merriweather(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF755B48),
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                color: const Color(0xFF755B48).withAlpha(102),
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF755B48)),
            tooltip: 'Sign Out',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AuthPage()),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Removed the old Center widget with welcome text and SizedBox here

                  SizedBox(
                    height: 260,
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(_images[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Services',
                    style: GoogleFonts.merriweather(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF755B48),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: services
                        .map((service) => ServiceIcon(
                              imagePath: service['icon']!,
                              label: service['label']!,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFfcefdc),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          '#Always Watching, Always Caring',
                          style: GoogleFonts.lora(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF755B48),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Supporting Every Step • Crafted in Mohali',
                          style: GoogleFonts.lora(
                            fontSize: 14,
                            color: Color(0xFF755B48),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickAction(Icons.person, 'Profile'),
                _buildQuickAction(Icons.settings, 'Settings'),
                _buildQuickAction(Icons.notifications, 'Notifications'),
                _buildQuickAction(Icons.apps, 'Services'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
