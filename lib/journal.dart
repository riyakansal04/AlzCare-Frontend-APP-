import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({Key? key}) : super(key: key);

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  bool isNewEntry = true;
  List<Map<String, String>> savedEntries = [];
  TextEditingController entryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadEntries();
  }

  void saveEntry() async {
    final now = DateTime.now();
    final formattedDate =
        "${now.day}-${now.month}-${now.year} ${now.hour}:${now.minute}";
    if (entryController.text.trim().isEmpty) return;

    savedEntries.insert(0, {
      'date': formattedDate,
      'text': entryController.text.trim(),
    });
    entryController.clear();
    await saveEntriesToPrefs();
    setState(() {
      isNewEntry = false;
    });
  }

  void deleteEntry(int index) async {
    setState(() {
      savedEntries.removeAt(index);
    });
    await saveEntriesToPrefs();
  }

  Future<void> saveEntriesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = jsonEncode(savedEntries);
    await prefs.setString('journal_entries', entriesJson);
  }

  Future<void> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getString('journal_entries');
    if (entriesJson != null) {
      final List decoded = jsonDecode(entriesJson);
      savedEntries = decoded.map((e) => Map<String, String>.from(e)).toList();
      setState(() {});
    }
  }

  Widget buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: Text("New Entry", style: GoogleFonts.lora(fontWeight: FontWeight.bold, color:Color(0xFF755b48) ),  selectionColor: Color(0xFF755b48),),
          selected: isNewEntry,
          onSelected: (_) {
            setState(() {
              isNewEntry = true;
            });
          },
          selectedColor: const Color(0xFFfcefdc),
        ),
        const SizedBox(width: 10),
        ChoiceChip(
          label: Text("Saved Entries", style: GoogleFonts.lora(fontWeight: FontWeight.bold, color:Color(0xFF755b48)), selectionColor: Color(0xFF755b48),),
          selected: !isNewEntry,
          onSelected: (_) {
            setState(() {
              isNewEntry = false;
            });
          },
          selectedColor: const Color(0xFFfcefdc),
        ),
      ],
    );
  }

  Widget buildNewEntryView() {
    final now = DateTime.now();
    final formattedDate =
        "${now.day}-${now.month}-${now.year} ${now.hour}:${now.minute}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formattedDate,
          style: GoogleFonts.lora(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF755b48)),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFfcefdc),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Color(0xFFfcefdc), blurRadius: 6)],
            ),
            child: TextField(
              controller: entryController,
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              style: GoogleFonts.merriweather(fontSize: 18, color: Color(0xFF755b48)),
              decoration: const InputDecoration.collapsed(
                hintText: "Write your thoughts here...", focusColor: Color(0xFF755b48),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: saveEntry,
            icon: const Icon(Icons.save),
            label: Text("Save Entry", style: GoogleFonts.lora(fontSize: 16, fontWeight: FontWeight.bold), selectionColor:  Color(0xFF755b48)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFfcefdc),
              foregroundColor: Color(0xFF755b48),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSavedEntriesView() {
    if (savedEntries.isEmpty) {
      return Center(
        child: Text(
          "No past entries yet.",
          style: GoogleFonts.lora(fontSize: 16, color: Color(0xFF755b48)),
        ),
      );
    }

    return ListView.builder(
      itemCount: savedEntries.length,
      itemBuilder: (_, index) {
        final entry = savedEntries[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFfcefdc),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.brown.withOpacity(0.2), blurRadius: 6, offset: Offset(0, 3)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry['date']!,
                style: GoogleFonts.lora(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF755b48)),
              ),
              const SizedBox(height: 8),
              Text(
                entry['text']!,
                style: GoogleFonts.lora(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF755b48)),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Color(0xFF755b48)),
                  tooltip: "Delete this entry",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: const Color(0xFFfcefdc),
                        title: Text('Delete Entry', style: GoogleFonts.merriweather(fontWeight: FontWeight.bold, color: Color(0xFF755b48,))),
                        content: Text('Are you sure you want to delete this entry?',
                            style: GoogleFonts.merriweather(color: Color(0xFF755b48))),
                        actions: [
                          TextButton(
                            child: Text('Cancel', style: GoogleFonts.lora(fontSize:18, fontWeight: FontWeight.bold, color: Color(0xFF755b48))),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: Text('Delete', style: GoogleFonts.lora(fontSize:18, fontWeight: FontWeight.bold, color: Color(0xFF755b48))),
                            onPressed: () {
                              deleteEntry(index);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEACCA9),
      appBar: AppBar(
        title: Text(
          "My Diary",
          style: GoogleFonts.merriweather(color: Color(0xFFEACCA9), fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: const Color(0xFF755b48),
        iconTheme: const IconThemeData(color: Color(0xFFEACCA9)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildToggleButtons(),
            const SizedBox(height: 16),
            Expanded(
              child: isNewEntry ? buildNewEntryView() : buildSavedEntriesView(),
            ),
          ],
        ),
      ),
    );
  }
}
