import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmotionMatchGame extends StatefulWidget {
  @override
  _EmotionMatchGameState createState() => _EmotionMatchGameState();
}

class _EmotionMatchGameState extends State<EmotionMatchGame> {
  int currentLevel = 0;
  List<Map<String, dynamic>> currentBatch = [];

  final List<Map<String, dynamic>> allLevels = [
    {"image": "assets/happy.jpg", "correct": "Happy", "options": ["Happy", "Sad", "Scared"]},
    {"image": "assets/sad.jpg", "correct": "Sad", "options": ["Excited", "Sad", "Angry"]},
    {"image": "assets/angry.jpg", "correct": "Angry", "options": ["Angry", "Proud", "Silly"]},
    {"image": "assets/surpised.jpg", "correct": "Surprised", "options": ["Confused", "Surprised", "Shy"]},
    {"image": "assets/scared.jpg", "correct": "Scared", "options": ["Scared", "Bored", "Happy"]},
    {"image": "assets/excited.jpg", "correct": "Excited", "options": ["Excited", "Tired", "Jealous"]},
    {"image": "assets/shy.jpg", "correct": "Shy", "options": ["Angry", "Shy", "Joyful"]},
    {"image": "assets/lonely.jpg", "correct": "Lonely", "options": ["Lonely", "Happy", "Silly"]},
    {"image": "assets/love.jpg", "correct": "Loved", "options": ["Loved", "Grumpy", "Scared"]},
    {"image": "assets/sleepy.jpg", "correct": "Sleepy", "options": ["Excited", "Sleepy", "Worried"]},
    {"image": "assets/hungry.jpg", "correct": "Hungry", "options": ["Hungry", "Proud", "Embarrassed"]},
    {"image": "assets/thirsty.jpg", "correct": "Thirsty", "options": ["Sad", "Thirsty", "Nervous"]},
    {"image": "assets/nervous.jpg", "correct": "Nervous", "options": ["Nervous", "Silly", "Tired"]},
    {"image": "assets/tired.jpg", "correct": "Tired", "options": ["Tired", "Happy", "Proud"]},
    {"image": "assets/curious.jpg", "correct": "Curious", "options": ["Curious", "Angry", "Jealous"]},
    {"image": "assets/proud.jpg", "correct": "Proud", "options": ["Proud", "Sad", "Calm"]},
    {"image": "assets/jealous.jpg", "correct": "Jealous", "options": ["Excited", "Jealous", "Bored"]},
    {"image": "assets/bored.jpg", "correct": "Bored", "options": ["Bored", "Surprised", "Joyful"]},
    {"image": "assets/calm.jpg", "correct": "Calm", "options": ["Calm", "Mad", "Lonely"]},
    {"image": "assets/worried.jpg", "correct": "Worried", "options": ["Worried", "Silly", "Loved"]},
    {"image": "assets/hopeful.jpg", "correct": "Hopeful", "options": ["Scared", "Hopeful", "Sleepy"]},
    {"image": "assets/confused.jpg", "correct": "Confused", "options": ["Confused", "Proud", "Angry"]},
    {"image": "assets/grumpy.jpg", "correct": "Grumpy", "options": ["Grumpy", "Tired", "Curious"]},
    {"image": "assets/embarassed.jpg", "correct": "Embarrassed", "options": ["Embarrassed", "Shy", "Scared"]},
    {"image": "assets/silly.jpg", "correct": "Silly", "options": ["Silly", "Bored", "Sad"]},
    {"image": "assets/joyful.jpg", "correct": "Joyful", "options": ["Joyful", "Jealous", "Worried"]},
    {"image": "assets/thankful.jpg", "correct": "Thankful", "options": ["Thankful", "Sleepy", "Excited"]},
    {"image": "assets/brave.jpg", "correct": "Brave", "options": ["Brave", "Nervous", "Shy"]},
    {"image": "assets/friendly.jpg", "correct": "Friendly", "options": ["Angry", "Friendly", "Tired"]},
    {"image": "assets/annoyed.jpg", "correct": "Annoyed", "options": ["Annoyed", "Happy", "Joyful"]},
    {"image": "assets/smug.jpg", "correct": "Smug", "options": ["Smug", "Scared", "Hopeful"]},
    {"image": "assets/peaceful.png", "correct": "Peaceful", "options": ["Peaceful", "Jealous", "Worried"]},
    {"image": "assets/sorry.jpg", "correct": "Sorry", "options": ["Sorry", "Excited", "Shy"]},
    {"image": "assets/playful.jpg", "correct": "Playful", "options": ["Playful", "Tired", "Sad"]},
    {"image": "assets/sick.jpg", "correct": "Sick", "options": ["Sick", "Angry", "Nervous"]},
    {"image": "assets/upset.jpg", "correct": "Upset", "options": ["Upset", "Proud", "Sleepy"]},
    {"image": "assets/lazy.jpg", "correct": "Lazy", "options": ["Lazy", "Excited", "Thankful"]},
    {"image": "assets/caring.jpg", "correct": "Caring", "options": ["Caring", "Nervous", "Grumpy"]},
    {"image": "assets/lucky.jpg", "correct": "Lucky", "options": ["Lucky", "Jealous", "Sad"]},
    {"image": "assets/creative.jpg", "correct": "Creative", "options": ["Creative", "Silly", "Scared"]},
    {"image": "assets/quiet.jpg", "correct": "Quiet", "options": ["Quiet", "Excited", "Lonely"]},
    {"image": "assets/cheerful.jpg", "correct": "Cheerful", "options": ["Cheerful", "Confused", "Shy"]},
    {"image": "assets/thinking.jpg", "correct": "Thinking", "options": ["Thinking", "Angry", "Joyful"]}
  ];

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    final random = Random();
    List<Map<String, dynamic>> shuffled = List.from(allLevels)..shuffle(random);
    List<Map<String, dynamic>> newBatch = shuffled.take(4).map((level) {
      var options = List<String>.from(level['options'])..shuffle(random);
      return {
        'image': level['image'],
        'correct': level['correct'],
        'options': options,
      };
    }).toList();

    setState(() {
      currentBatch = newBatch;
      currentLevel = 0;
    });
  }

  void checkAnswer(String selected) {
    final correct = currentBatch[currentLevel]['correct'];

    if (selected == correct) {
      if (currentLevel == 3) {
        _showWinDialog();
      } else {
        setState(() {
          currentLevel++;
        });
      }
    } else {
      _showWrongDialog();
    }
  }

  void _showWrongDialog() {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) => AlertDialog(
      backgroundColor: Color(0xFFEACCA9),
      title: Text('Oops!', style: GoogleFonts.lora(fontSize: 24, color: Color(0xFF755b48), fontWeight: FontWeight.bold),),
      content: Text('Wrong answer. Restarting from level 1.', style: GoogleFonts.lora(fontSize: 22, color: Color(0xFF755b48), fontWeight: FontWeight.bold),),
      actions: [
        TextButton(
          onPressed: () {
             Navigator.of(dialogContext).pop(); // Close the dialog
            _startNewGame(); // Immediately restart game
          },
          child: Text('Try Again', style: GoogleFonts.lora(fontSize: 20, color: Color(0xFF755b48), fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}

void _showWinDialog() {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) => AlertDialog(
      backgroundColor: Color(0xFFEACCA9),
      title: Text('🎉 You Finished!', style: GoogleFonts.lora(fontSize: 24, color: Color(0xFF755b48), fontWeight: FontWeight.bold),),
      content: Text('Great job recognizing emotions! Want to play again?', style: GoogleFonts.lora(fontSize: 24, color: Color(0xFF755b48), fontWeight: FontWeight.bold),),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(dialogContext).pop(); // only dismiss the dialog
            _startNewGame(); // restart the game
          },
          child: Text('Play Again', style: GoogleFonts.lora(fontSize: 20, color: Color(0xFF755b48), fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final currentData = currentBatch[currentLevel];

    return Scaffold(
      backgroundColor: Color(0xFFEACCA9),
      appBar: AppBar(title: Text('Emotion Match', style: GoogleFonts.merriweather(fontSize: 30 , fontWeight: FontWeight.bold, color: Color(0xFFEACCA9))), foregroundColor:Color(0xFFEACCA9), backgroundColor:const Color(0xFF755b48) ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
         mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Level ${currentLevel + 1} of 4',
                style: GoogleFonts.lora(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF755b48))),
            SizedBox(height: 20),
            Image.asset(
              currentData['image'],
              height: 200,
              width: 600,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.image, size: 200, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text('What emotion is this?', style: GoogleFonts.lora(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF755b48))),
            SizedBox(height: 20),
            ...currentData['options'].map<Widget>((option) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF755b48),
                                    foregroundColor: Color(0xFFEACCA9),
                                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 24),
                                    textStyle: GoogleFonts.lora(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: () => checkAnswer(option),
                                  child: Text(option),
                                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
