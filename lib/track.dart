import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;




class TrackWidget extends StatefulWidget {
  const TrackWidget({super.key});

  static String routeName = 'Track';
  static String routePath = '/track';

  @override
  State<TrackWidget> createState() => _TrackWidgetState();
}

class _TrackWidgetState extends State<TrackWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  CameraController? controller;
  List<CameraDescription>? cameras;
  bool isDetecting = false;
  bool isDetectionActive = true; // NEW: Flag to control detection
  Timer? timer;
  String detectedActivity = 'No activity detected yet';

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras![0], ResolutionPreset.medium);
    await controller!.initialize();
    setState(() {});

    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      captureAndSend();
    });
  }

  Future<void> captureAndSend() async {
    if (!isDetectionActive || controller == null || isDetecting || !controller!.value.isInitialized) return;

    setState(() {
      isDetecting = true;
    });

    try {
      final XFile file = await controller!.takePicture();
      final activity = await ApiService.sendFrame(file);

      if (activity != null) {
        setState(() {
          detectedActivity = activity;
        });
      } else {
        setState(() {
          detectedActivity = 'Error detecting activity';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        detectedActivity = 'Error detecting activity';
        
      });
    } finally {
      setState(() {
        isDetecting = false;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFEACCA9);
    final Color secondaryColor = const Color(0xFF755b48);
    final TextStyle headlineMedium = GoogleFonts.merriweather(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      color: secondaryColor,
    );

    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

     return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          automaticallyImplyLeading: false,
          elevation: 2,
          title: Row(
            children: [ // NEW: Back button added
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF755B48)),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              Text('Live Activity Detection', style: headlineMedium),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: CameraPreview(controller!)),
              const SizedBox(height: 10),
              Text(
                'Detected Activity:\n$detectedActivity',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF755B48)),
              ),
              const SizedBox(height: 20),
              isDetecting
                  ? const CircularProgressIndicator(color: Color(0xFF755B48))
                  : const SizedBox.shrink(),
              const SizedBox(height: 20),
              
              // NEW: Start/Stop Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isDetectionActive = true;
                      });
                    },
                    icon: const Icon(Icons.play_arrow,
                    color: Color(0xFFeacca9),
                    size: 30),
                    label: Text(
                      "Start",
                      style: GoogleFonts.lora(
                        color: Color(0xFFeacca9),
                        fontSize: 30,               // Font size (adjust as needed)
                        fontWeight: FontWeight.bold, // Font weight (optional) // 👈 Text color here
                      ),
                      ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF755B48),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isDetectionActive = false;
                      });
                    },
                    icon: const Icon(Icons.stop,
                    color: Color(0xFFeacca9),
                    size: 30),
                    label: Text("Stop",
                    style: GoogleFonts.lora(
                        color: Color(0xFFeacca9),
                        fontSize: 30,               // Font size (adjust as needed)
                        fontWeight: FontWeight.bold, // Font weight (optional) // 👈 Text color here
                      ),
                      ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF755B48),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Space below buttons
            ],
          ),
        ),
      ),
    );
  }
}




class DetectionResult extends StatelessWidget {
  final String activity;
  const DetectionResult({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity Result')),
      body: Center(
        child: Text(
          'Detected Activity:\n$activity',
          style: const TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}



class ApiService {
  static Future<String?> sendFrame(XFile file) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.23.93:5000/predict_activity'), // Change this
    );

    request.files.add(
      await http.MultipartFile.fromPath('frame', file.path),
    );

    var response = await request.send();
    if (response.statusCode == 200) {
      var respStr = await response.stream.bytesToString();
      var decoded = jsonDecode(respStr);
      return decoded['activity'];
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  }
}

