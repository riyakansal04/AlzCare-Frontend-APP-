import 'package:alzcare/mindmaze.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const CardMatchingApp());
}

class CardMatchingApp extends StatelessWidget {
  const CardMatchingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game',
      theme: ThemeData(primaryColor: Color(0xFF755B48) ),
      home: const MemoryGamePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CardModel {
  final String emoji;
  bool isFlipped = false;
  bool isMatched = false;

  CardModel({required this.emoji});
}

class MemoryGamePage extends StatefulWidget {
  const MemoryGamePage({Key? key}) : super(key: key);

  @override
  State<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage>
    with TickerProviderStateMixin {
  final List<String> _emojis = [
  '🍎', '🍏', '🍐', '🍊', '🍋', '🍌', '🍉', '🍇', '🍓', '🫐',
  '🍈', '🍒', '🍑', '🥭', '🍍', '🥥', '🥝', '🍅', '🍆', '🥑',
  '🥦', '🥬', '🥒', '🌶️', '🫑', '🌽', '🥕', '🫒', '🧄', '🧅',
  '🥔', '🍠', '🥐', '🥯', '🍞', '🥖', '🫓', '🥨', '🥞', '🧇',
  '🧀', '🍖', '🍗', '🥩', '🥓', '🍔', '🍟', '🍕', '🌭', '🥪',
  '🌮', '🌯', '🫔', '🥙', '🧆', '🥚', '🍳', '🥘', '🍲', '🫕',
  '🥣', '🥗', '🍿', '🧈', '🧂', '🥫', '🍱', '🍘', '🍙', '🍚',
  '🍛', '🍜', '🍝', '🍠', '🍢', '🍣', '🍤', '🍥', '🥮', '🍡',
  '🥟', '🦪', '🍦', '🍧', '🍨', '🍩', '🍪', '🎂', '🍰', '🧁',
  '🥧', '🍫', '🍬', '🍭', '🍮', '🍯', '🍼', '🥤', '🧃', '🧋',
  '☕', '🫖', '🍵', '🍶', '🍺', '🍻', '🥂', '🍷', '🥃', '🧉',
   '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐻‍❄️', '🐨',
  '🐯', '🦁', '🐮', '🐷', '🐽', '🐸', '🐵', '🙈', '🙉', '🙊',
  '🐒', '🦍', '🦧', '🐔', '🐤', '🐣', '🐥', '🦆', '🦅', '🦉',
  '🦇', '🐺', '🐗', '🐴', '🫏', '🫎', '🦄', '🐝', '🪱', '🐛',
  '🦋', '🐌', '🐞', '🐜', '🪰', '🪲', '🪳', '🕷️', '🕸️', '🦂',
  '🐢', '🐍', '🦎', '🦖', '🦕', '🐙', '🦑', '🦐', '🦞', '🦀',
  '🐡', '🐠', '🐟', '🐬', '🐳', '🐋', '🦈', '🐊', '🐅', '🐆',
  '🦓', '🦍', '🦧', '🦣', '🐘', '🦛', '🦏', '🐪', '🐫', '🦙',
  '🦒', '🐃', '🐂', '🐄', '🐎', '🐖', '🐏', '🐑', '🦌', '🐐',
  '🐓', '🦃', '🦚', '🦜', '🕊️', '🦢', '🦩', '🦤', '🪿', '🦝',
  '🦨', '🦡', '🦦', '🦥', '🦫', '🫐', '🪼', '🪸', '🪹', '🪺',
  '😀', '😃', '😄', '😁', '😆', '😅', '😂', '🤣', '😊', '😇',
  '🙂', '🙃', '😉', '😌', '😍', '🥰', '😘', '😗', '😙', '😚',
  '😋', '😛', '😝', '😜', '🤪', '🤨', '🧐', '🤓', '😎', '🥸',
  '🤩', '🥳', '😏', '😒', '😞', '😔', '😟', '😕', '🙁', '☹️',
  '😣', '😖', '😫', '😩', '🥺', '😢', '😭', '😤', '😠', '😡',
  '🤬', '🤯', '😳', '🥵', '🥶', '😱', '😨', '😰', '😥', '😓',
  '🤗', '🤔', '🤭', '🤫', '🤥', '😶', '😐', '😑', '😬', '🙄',
  '😯', '😦', '😧', '😮', '😲', '🥱', '😴', '🤤', '😪', '😵',
  '🤐', '🥴', '🤢', '🤮', '🤧', '😷', '🤒', '🤕', '🤑', '🤠',
  '😈', '👿', '👹', '👺', '💀', '☠️', '👻', '👽', '🤖', '😺',
  '😸', '😹', '😻', '😼', '😽', '🙀', '😿', '😾', '🙌', '👏',
  '☀️', '🌤️', '⛅', '🌥️', '🌦️', '🌧️', '⛈️', '🌩️', '🌨️', '❄️',
  '🌬️', '💨', '🌪️', '🌫️', '🌈', '☁️', '🌞', '🌝', '🌛', '🌜',
  '🌚', '🌕', '🌖', '🌗', '🌘', '🌑', '🌒', '🌓', '🌔', '🌙',
  '⭐', '🌟', '✨', '⚡', '🔥', '💧', '🌊', '🌫️', '🌋', '🗻',
  '🏔️', '⛰️', '🌍', '🌎', '🌏', '🌌', '🌠', '🌉', '🏞️', '🏕️',
  '🏖️', '🏜️', '🏝️', '🌳', '🌲', '🌴', '🌵', '🎋', '🎄', '🌿',
  '☘️', '🍀', '🎍', '🪴', '🍃', '🍂', '🍁', '🌾', '🌺', '🌻',
  '🌹', '🥀', '🌷', '🌼', '🌸', '💐', '🪷', '🪻', '🪹', '🪺',
  '🕸️', '🪨', '🪵', '🛤️', '🛣️', '🏡', '🏘️', '🏚️', '🪓', '🛖',
  '🐚', '🪼', '🦀', '🪸', '🪲', '🐛', '🦋', '🐌', '🪳', '🪰',
  '🪱', '🐜', '🐝', '🌻', '🌷', '🦗', '🪯', '🪷', '🧊', '🪙',
  '🥤', '🧃', '🧋', '🧉', '🍹', '🍸', '🍷', '🥂', '🍺', '🍻',
  '🍶', '🥃', '🍼', '☕', '🫖', '🧊', '🫗', '🧯', '🍵', '🥛',
  '🫙','⚽', '🏀', '🏈', '⚾', '🎾', '🏐', '🏉', '🥏', '🎱', '🏓',
  '🏸', '🥋', '🥊', '🥌', '⛸️', '🏒', '🥍', '⛷️', '🏂', '⛹️‍♂️',
  '⛹️‍♀️', '🚴', '🚵', '🏍️', '🏎️', '🏁', '⛷️', '🏄‍♂️', '🏄‍♀️', '🤾‍♂️',
  '🤾‍♀️', '🤸‍♂️', '🤸‍♀️', '🤼‍♂️', '🤼‍♀️', '🤽‍♂️', '🤽‍♀️', '🧘‍♂️', '🧘‍♀️',
  '🧗‍♂️', '🧗‍♀️', '🏋️‍♂️', '🏋️‍♀️', '🤺', '🤽', '🛶', '🚣‍♂️', '🚣‍♀️', '🚤',
  '🛥️', '⛴️', '⛵', '🚢', '🚀', '🛸', '⛹️‍♂️', '⛹️‍♀️', '🤖', '🎮',
  '🧩', '🎲', '🎯', '🧗', '🎨', '🎭', '🎬', '🎤', '🎧', '🎷',
  '🎺', '🎸', '🎻', '🎹', '🎼', '🎵', '🖌️', '🖼️', '🎞️', '📸',
  '🎥', '💃', '🕺', '🎶', '🪕', '🪘', '🪘', '🪓', '🏆', '🏅',
  '🥇', '🥈', '🥉', '🎖️', '🏅', '🧸', '🎁', '💌', '🧧', '🧯',
  '🪄', '🎪', '🎡', '🎠', '🎢', '🎳', '🎯', '🏀', '🎮', '🎲',
  '🌍', '🌎', '🌏', '🗺️', '🌍', '🌄', '🏞️', '🏖️', '🏝️', '🏜️',
  '🏕️', '⛰️', '🏔️', '🏘️', '🏙️', '🌆', '🌃', '🏙️', '🌁', '🗼',
  '🏰', '🏟️', '🏛️', '🕌', '⛩️', '🕍', '🗿', '🏡', '🏢', '🏬',
  '🏣', '🏠', '🏘️', '🏗️', '🌇', '🌉', '🛤️', '🌌', '🏞️', '🛣️',
  '🏦', '🎢', '🎡', '🎠', '⛲', '🛶', '🚢', '⛴️', '🛥️', '🚤',
  '⛵', '🚀', '✈️', '🛫', '🛬', '🛩️', '🚁', '🚂', '🚆', '🚄',
  '🚈', '🚊', '🚉', '🚝', '🚞', '🚋', '🚕', '🚗', '🚙', '🚓',
  '🚑', '🚐', '🚚', '🚛', '🚜', '🚍', '🚎', '🚘', '🚲', '🛴',
  '🛵', '🚨', '🏍️', '🚘', '🛺', '⛺', '🏠', '🏕️', '🛋️', '🚖',
  '🏄‍♂️', '🏄‍♀️', '🚴‍♂️', '🚴‍♀️', '🏇', '🏂', '🧗‍♂️', '🧗‍♀️', '🤽‍♂️',
  '🤽‍♀️', '⛷️', '🏌️‍♂️', '🏌️‍♀️', '🏏', '🏓', '🏸', '🎣', '⛳',
  '⛷️', '🏂', '🎤', '🎬', '🎧', '🎮', '🎯', '🎲', '🎮', '🎳',
   '📱', '💻', '💾', '🖥️', '🖨️', '⌨️', '🖱️', '🖲️', '💡', '🔦',
  '🔋', '🔌', '📡', '📺', '📻', '🎥', '📷', '📸', '📹', '📼',
  '💳', '💎', '🔑', '🔒', '🔓', '🗝️', '🔨', '🛠️', '⚙️', '🔧',
  '🔩', '⚙️', '🧰', '🔪', '⚒️', '🪓', '🧲', '🛡️', '⚖️', '⚔️',
  '🪓', '🛠️', '💼', '🗂️', '📂', '📚', '📖', '📝', '✏️', '📐',
  '📏', '🔍', '🔎', '🧮', '📌', '📍', '🔗', '📎', '📏', '🔏',
  '📅', '🗓️', '📆', '🗂️', '📇', '📈', '📉', '📊', '📋', '🧾',
  '✂️', '🖋️', '📝', '📇', '🔏', '🔓', '🗝️', '🧳', '⏳', '⌛',
  '🏷️', '🔖', '📎', '📏', '🛋️', '🛏️', '🖼️', '🖌️', '🖋️', '🧵',
  '🪡', '🔗', '🪙', '🎁', '🔮', '🪞', '🧿', '🛒', '🧺', '🧻',
  '🛀', '🧴', '🎒', '🧳', '🪑', '🛋️', '🪑', '🛏️', '🛀', '🎨',
  '🖼️', '🏺', '🧴', '🧷', '🧵', '🧰', '📋', '📜', '📌', '📝',
  '❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '🤍', '🤎', '💔',
  '❣️', '💖', '💗', '💓', '💝', '💞', '💕', '💌', '💋', '💘',
  '💌', '💍', '⚡', '🔥', '💥', '💨', '🌪️', '🌈', '✨', '🌟',
  '💫', '⭐', '🌙', '🌜', '🌛', '🌍', '🌎', '🌏', '🌕', '🌑',
  '🌘', '🌗', '🌖', '🌝', '🌞', '🌏', '💎', '🔮', '⚽', '🏀',
  '🏈', '⚾', '🎾', '🏐', '🏉', '🎱', '🏓', '🥅', '🎯', '🎮',
  '🕹️', '🎲', '🎯', '🎴', '🏆', '🥇', '🥈', '🥉', '🏅', '🥋',
  '🥅', '🧩', '🛸', '🪐', '🎶', '🎵', '🎶', '🎼', '🎤', '🎧',
  '🎷', '🎺', '🎸', '🎻', '🎬', '📸', '📷', '📹', '🎥', '🎬',
  '📽️', '📺', '🖥️', '💻', '⌨️', '🖱️', '📱', '📞', '📟', '📠',
  '📡', '🔋', '🔌', '💡', '🔦', '🔍', '🔎', '📚', '📖', '📰',
  '📃', '📜', '📝', '📑', '📋', '📂', '🗂️', '📠', '🔗', '🧷',
  '🔑', '🔒', '🔓', '🗝️', '📅', '🗓️', '📆', '📋', '📂', '📃',
  '🗳️', '🏁', '🚩', '🎌', '🏴', '🏳️'
  ];

  late List<CardModel> _cards;
  CardModel? _firstCard;
  CardModel? _secondCard;
  bool _waiting = false;
  int _score = 0;
  late List<AnimationController> _matchControllers;
  int _level = 1;

  static const int maxLevel = 4;

  @override
  void initState() {
    super.initState();
    _initializeCards();
  }

  void _initializeCards() {
    final availableEmojis = [..._emojis]..shuffle(Random());
    final selectedEmojis = availableEmojis.take(6).toList(); // Always 6 pairs
    final items = [...selectedEmojis, ...selectedEmojis];
    items.shuffle(Random());

    _cards = items.map((e) => CardModel(emoji: e)).toList();

    _matchControllers = List.generate(_cards.length, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
    });

    _score = 0;
  }

  void _flipCard(int index) {
    if (_waiting || _cards[index].isFlipped || _cards[index].isMatched) return;

    setState(() {
      _cards[index].isFlipped = true;
    });

    if (_firstCard == null) {
      _firstCard = _cards[index];
    } else {
      _secondCard = _cards[index];
      _waiting = true;

      Future.delayed(const Duration(milliseconds: 700), () {
        setState(() {
          if (_firstCard!.emoji == _secondCard!.emoji) {
            final firstIndex = _cards.indexOf(_firstCard!);
            final secondIndex = _cards.indexOf(_secondCard!);

            _cards[firstIndex].isMatched = true;
            _cards[secondIndex].isMatched = true;

            _matchControllers[firstIndex].forward();
            _matchControllers[secondIndex].forward();

            _score += 10;
          } else {
            _firstCard!.isFlipped = false;
            _secondCard!.isFlipped = false;
          }

          _firstCard = null;
          _secondCard = null;
          _waiting = false;
        });
      });
    }
  }

  void _resetGame() {
    for (var controller in _matchControllers) {
      controller.dispose();
    }
    setState(() {
      _level = 1;
      _initializeCards();
      _firstCard = null;
      _secondCard = null;
      _waiting = false;
    });
  }

  void _nextLevel() {
    for (var controller in _matchControllers) {
      controller.dispose();
    }
    setState(() {
      _level++;
      _initializeCards();
      _firstCard = null;
      _secondCard = null;
      _waiting = false;
    });
  }

  @override
  void dispose() {
    for (var controller in _matchControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isGameOver = _cards.where((c) => c.isMatched).length == _cards.length;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;

    final cardWidth = (screenWidth - 64) / 3;
    final cardHeight = (screenHeight - 200) / 4;

    return Scaffold(
      backgroundColor: Color(0xFFEACCA9),
      appBar: AppBar(
        title: Text('Level $_level | Score: $_score',
        style: GoogleFonts.merriweather(
          color: Color(0xFFEACCA9),         // Text color
          fontSize: 24,                // Font size
          fontWeight: FontWeight.bold, // Font weight        // Font family (optional)
          ),
          ),
        backgroundColor: Color(0xFF755b48),
        leading: IconButton(
          icon: const Icon((Icons.arrow_back), color: Color(0xFFEACCA9), size: 32),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MindMazePage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon((Icons.refresh), color: Color(0xFFEACCA9), size: 32),
            onPressed: _resetGame,
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            isGameOver ? '🎉 All cards matched! 🎉' : 'Find all matching pairs!',
            style: GoogleFonts.lora(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF755B48)),
          ),
          const SizedBox(height: 8),
          Text('Level $_level', style: GoogleFonts.lora(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF755B48)) ),
          const SizedBox(height: 20),
          if (isGameOver && _level < maxLevel)
            ElevatedButton.icon(
              onPressed: _nextLevel,
              style:ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF755B48), // Change to your desired color
                foregroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.skip_next, color: Color(0xFFEACCA9), size: 28, ),
              label: Text(("Next Level"), style: GoogleFonts.lora(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFEACCA9)) ),
            ),
          if (isGameOver && _level == maxLevel)
            ElevatedButton.icon(
              onPressed: _resetGame,
              style:ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF755B48), // Change to your desired color
                foregroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.replay, color: Color(0xFFEACCA9), size: 28),
              label: Text(("Play Again"), style: GoogleFonts.lora(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFEACCA9))),
            ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                final controller = _matchControllers[index];

                return AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    final scale = 1.0 - controller.value;
                    final opacity = 1.0 - controller.value;

                    return Opacity(
                      opacity: opacity,
                      child: Transform.scale(
                        scale: scale,
                        child: GestureDetector(
                          onTap: () => _flipCard(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: cardWidth,
                            height: cardHeight,
                            decoration: BoxDecoration(
                              color: card.isFlipped || card.isMatched
                                  ? Colors.white
                                  : Color(0xFF755B48),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(2, 2),
                                )
                              ],
                            ),
                            alignment: Alignment.center,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, anim) => ScaleTransition(
                                scale: anim,
                                child: child,
                              ),
                              child: Text(
                                card.isFlipped || card.isMatched ? card.emoji : '',
                                key: ValueKey(card.isFlipped || card.isMatched),
                                style: const TextStyle(fontSize: 70),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

