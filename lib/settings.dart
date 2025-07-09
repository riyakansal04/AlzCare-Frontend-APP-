import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'developers_info_page.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isAppLockEnabled = false;
  bool isDarkModeEnabled = false;
  int sessionTimeout = 5;

  void _showSessionTimeoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: const Color(0xFF755b48),
          title: Text('Select Session Timeout', style: GoogleFonts.merriweather(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFEACCA9))),
          children: [1, 5, 10, 15, 30].map((int value) {
            return SimpleDialogOption(
              onPressed: () {
                setState(() {
                  sessionTimeout = value;
                });
                Navigator.pop(context);
              },
              child: Text('$value minutes', style: GoogleFonts.merriweather(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFEACCA9))),
            );
          }).toList(),
        );
      },
    );
  }

  void _showComingSoonMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEACCA9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF755b48),
        foregroundColor: Color(0xFFEACCA9) ,
        title: Text('Settings', style: GoogleFonts.merriweather(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFEACCA9))),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Theme', style: GoogleFonts.lora(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF755b48) )),
            value: isDarkModeEnabled,
            onChanged: (val) {
              _showComingSoonMessage();
              setState(() {
                isDarkModeEnabled = val;
              });
            },
            activeColor: Color(0xFFEACCA9),       // Thumb color when ON
  activeTrackColor: Color(0xFF755b48),  // Track color when ON
          ),
          SwitchListTile(
            title: Text('App Lock', style: GoogleFonts.lora(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF755b48) )),
            value: isAppLockEnabled,
            onChanged: (val) {
              _showComingSoonMessage();
              setState(() {
                isAppLockEnabled = val;
              });
            },
            activeColor: Color(0xFFEACCA9),       // Thumb color when ON
  activeTrackColor: Color(0xFF755b48),  
          ),
          ListTile(
            title: Text('Session Timeout', style: GoogleFonts.lora(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF755b48) )),
            subtitle: Text('$sessionTimeout minutes', style: GoogleFonts.lora(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF755b48) )),
            trailing: const Icon(Icons.timer,color: Color(0xFF755b48),),
            onTap: _showSessionTimeoutDialog,
          ),
          const Divider(color: Color(0xFF755b48)),
          ExpansionTile(
            leading: const Icon(Icons.support, color: Color(0xFF755b48)),
            iconColor: Color(0xFF755b48),         // Color when expanded
  collapsedIconColor: Color(0xFF755b48), // Color when collapsed
            title:Text('Contact Support', style: GoogleFonts.lora(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF755b48) )),
            children: [
              ListTile(
                title: Text('Email: support@alzcare.com', style: GoogleFonts.lora(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF755b48) )),
              ),
              ListTile(
                title: Text('Phone: +1 800 123 4567', style: GoogleFonts.lora(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF755b48) )),
              ),
            ],
          ),
          const Divider(color: Color(0xFF755b48)),
          ListTile(
            title: Text('Check for Updates', style: GoogleFonts.lora(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF755b48) )),
            leading: const Icon(Icons.system_update, color: Color(0xFF755b48)),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("You're on the latest version.")),
              );
            },
          ),
          const Divider(color: Color(0xFF755b48)),
          // License section added as an ExpansionTile dropdown
          ExpansionTile(
            iconColor: Color(0xFF755b48),         // Color when expanded
  collapsedIconColor: Color(0xFF755b48), // Color when collapsed
            leading: const Icon(Icons.verified_user, color: Color(0xFF755b48)),
            title: Text('License', style: GoogleFonts.lora(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF755b48) )),
            children: [
              ListTile(
                title: Text(
                  'MIT License\n\nYou may use, copy, modify, merge, publish, distribute this software freely.\n\n© 2025 AlzCare Team.',style: GoogleFonts.lora(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF755b48) )
                ),
              ),
            ],
          ),
          const Divider(color: Color(0xFF755b48)),
          ListTile(
            leading: const Icon(Icons.info, color: Color(0xFF755b48),),
            title: Text('About', style: GoogleFonts.lora(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF755b48) )),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF755b48)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DevelopersInfoPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
