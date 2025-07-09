import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

Future<void> sendEmergencyAlert({
  required String emergencyPhone,
  required String emergencyEmail,
  required String userName,
}) async {
  final message = '🚨 Emergency Alert!\n$userName might need your help. Please contact immediately.';

  // Launch SMS
  final Uri smsUri = Uri.parse("sms:$emergencyPhone?body=${Uri.encodeComponent(message)}");
  if (await canLaunchUrl(smsUri)) {
    await launchUrl(smsUri);
  } else {
    print("❌ Could not launch SMS.");
  }

  // Send Email via Python server
  final response = await http.post(
    Uri.parse('http://YOUR_LOCALHOST_OR_HOST/send_email'),
    headers: {'Content-Type': 'application/json'},
    body: '{"to": "$emergencyEmail", "subject": "Emergency Alert!", "message": "$message"}',
  );

  if (response.statusCode == 200) {
    print("✅ Email sent");
  } else {
    print("❌ Email failed: ${response.body}");
  }
}
