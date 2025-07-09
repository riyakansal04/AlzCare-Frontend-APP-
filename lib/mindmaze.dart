import 'package:alzcare/emotionmatch.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'matchgame.dart';
import 'onsequencetap.dart';

class MindMazePage extends StatelessWidget {
  const MindMazePage({super.key});

  final List<Map<String, String>> _games = const [
    {'title': 'Match the Pairs'},
    {'title': 'Sequence Tap Game'},
    {'title': 'Emotion Match'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MindMaze',
          style: GoogleFonts.merriweather(
            fontWeight: FontWeight.bold, color:Color(0xFFeacca9)
          ),
        ),
        backgroundColor: const Color(0xFF755B48),
        foregroundColor: Color(0xFFeacca9),
      ),
      backgroundColor: const Color(0xFFeacca9),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _games.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFFfcefdc),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                _games[index]['title']!,
                style: GoogleFonts.lora(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: const Color(0xFF755B48),
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF755B48)),
              onTap: () {
  if (_games[index]['title'] == 'Match the Pairs') {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) => const CardMatchingApp(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ));
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        }
      ),
    );
  } else if (_games[index]['title'] == 'Sequence Tap Game') {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) => ConsequenceTap(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ));
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        }
      ),
    );
  } else if (_games[index]['title'] == 'Emotion Match') {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) => EmotionMatchGame(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ));
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        }
      ),
    );
  }else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_games[index]['title']} tapped')),
    );
  }
},
            ),
          );
        },
      ),
    );
  }
}
