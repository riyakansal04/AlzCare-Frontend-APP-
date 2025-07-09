import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConsequenceTap extends StatefulWidget {
  @override
  _ConsequenceTapState createState() => _ConsequenceTapState();
}

class _ConsequenceTapState extends State<ConsequenceTap> {
  late List<int> sequenceToMemorize;
  late List<int> shuffledSequence;
  int currentIndex = 0;
  int score = 0;
  bool showSequence = true;
  final int sequenceLength = 8;
  final int showDurationSeconds = 20;
  late int remainingSeconds;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    final random = Random();
    sequenceToMemorize = List.generate(sequenceLength, (_) => random.nextInt(20) + 1);
    shuffledSequence = List.from(sequenceToMemorize)..shuffle();
    currentIndex = 0;
    score = 0;
    showSequence = true;
    remainingSeconds = showDurationSeconds;

    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        remainingSeconds--;
        if (remainingSeconds <= 0) {
          showSequence = false;
          countdownTimer?.cancel();
        }
      });
    });

    setState(() {});
  }

  void handleTap(int value) {
    if (value == sequenceToMemorize[currentIndex]) {
      setState(() {
        score += 10;
        currentIndex++;
      });
    } else {
      setState(() {
        score = max(0, score - 10);
      });
    }

    if (score == 0) {
      showGameOverDialog();
    }

    if (currentIndex >= sequenceToMemorize.length) {
      showWinDialog();
    }
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: Color(0xFFEACCA9),
        title: Text('Game Over!!', style: GoogleFonts.lora(fontSize: 24, color: Color(0xFF755b48), fontWeight: FontWeight.bold)),
        content: Text('Your score dropped to 0.\nRestarting game.', style: GoogleFonts.lora(fontSize: 22, color: Color(0xFF755b48), fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {
               Navigator.of(dialogContext).pop();
              startNewGame();
            },
            child: Text('OK', style: GoogleFonts.lora(fontSize: 20, color: Color(0xFF755b48), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void showWinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: Color(0xFFEACCA9),
        title: Text('Well Done!', style: GoogleFonts.lora(fontSize: 24, color: Color(0xFF755b48), fontWeight: FontWeight.bold),),
        content: Text('You remembered the full sequence!\nFinal Score: $score', style: GoogleFonts.lora(fontSize: 24, color: Color(0xFF755b48), fontWeight: FontWeight.bold),),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              startNewGame();
            },
            child: Text('Play Again',style: GoogleFonts.lora(fontSize: 20, color: Color(0xFF755b48), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEACCA9),
      appBar: AppBar(
        backgroundColor: Color(0xFF755b48),
        title: Text(
          'Sequence Tap',
          style: GoogleFonts.merriweather(
            fontSize: 32,
            color: Color(0xFFEACCA9),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: showSequence
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Memorize this sequence:', 
                      style: GoogleFonts.merriweather(fontSize: 22, color: Color(0xFF755b48), fontWeight: FontWeight.bold ), 
                    ),
                    SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: sequenceToMemorize
                          .map((num) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF755b48),
                                    foregroundColor: Color(0xFFEACCA9),
                                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                                    textStyle: GoogleFonts.lora(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: () => handleTap(num),
                                  child: Text(num.toString()),
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '$remainingSeconds seconds to memorize',
                      style: GoogleFonts.lora(
                        fontSize: 24,
                        color: Color.fromARGB(255, 161, 128, 104),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Score: $score',
                      style: GoogleFonts.lora(fontSize: 32, color: Color(0xFF755b48), fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: shuffledSequence
                          .map((num) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF755b48),
                                    foregroundColor: Color(0xFFEACCA9),
                                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                    textStyle: GoogleFonts.lora(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () => handleTap(num),
                                  child: Text(num.toString()),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
