import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AlzCareApp());
}

class AlzCareApp extends StatelessWidget {
  const AlzCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEACCA9),
        textTheme: GoogleFonts.merriweatherTextTheme(),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return const AutoImageSlider();
        } else {
          return const AuthPage();
        }
      },
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _obscurePassword = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF755b48),
        centerTitle: true,
        title: Text('AlzCare', style: GoogleFonts.merriweather(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFEACCA9),)),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              TabBar(
                controller: _tabController,
                labelColor: Color(0xFF755b48),
                unselectedLabelColor: Color(0xFFfcefdc),
                indicatorColor: Color(0xFFfcefdc),
                labelStyle: GoogleFonts.merriweather(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                tabs: const [
                  Tab(text: 'Sign In'),
                  Tab(text: 'Sign Up'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildForm('Sign In'),
                    _buildForm('Sign Up'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(String action) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              "Let's get started by filling out the form below.",
              style: GoogleFonts.merriweather(fontSize: 14, color: Color(0xFF755b48), fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Email', style: GoogleFonts.merriweather(fontSize: 14, color: Color(0xFF755b48), fontWeight: FontWeight.bold),),
            const SizedBox(height: 4),
            TextField(
              controller: emailController,
              style: GoogleFonts.merriweather(),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFfcefdc),
                hintText: 'Enter your email',
                hintStyle: GoogleFonts.merriweather(fontSize: 14, color: Color(0xFF755b48), fontWeight: FontWeight.bold),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            const SizedBox(height: 16),
            Text('Password', style: GoogleFonts.merriweather(fontSize: 14, color: Color(0xFF755b48), fontWeight: FontWeight.bold),),
            const SizedBox(height: 4),
            TextField(
              controller: passwordController,
              obscureText: _obscurePassword,
              style: GoogleFonts.merriweather(),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFfcefdc),
                hintText: 'Password',
                hintStyle: GoogleFonts.merriweather(fontSize: 14, color: Color(0xFF755b48), fontWeight: FontWeight.bold),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF755b48),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();

                try {
                  if (action == 'Sign Up') {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Account created successfully!')),
                    );
                  } else {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Signed in successfully!')),
                    );
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AutoImageSlider()),
                  );
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('❌ ${e.message ?? 'Auth error'}')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFfcefdc),
                foregroundColor: const Color(0xFF755b48),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(action, style: GoogleFonts.merriweather(fontSize: 16, color: Color(0xFF755b48), fontWeight: FontWeight.bold), ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () async {
                final email = emailController.text.trim();
                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('⚠ Please enter your email to reset password')),
                  );
                  return;
                }

                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('📧 Password reset email sent!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('❌ Failed to send reset email: ${e.toString()}')),
                  );
                }
              },
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.merriweather(
                  color: const Color(0xFF755b48),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(child: Text("Or sign up with", style: GoogleFonts.merriweather(fontSize: 14, color: Color(0xFF755b48), fontWeight: FontWeight.bold),)),
            const SizedBox(height: 10),
            _socialButton("Continue with Google", Icons.g_mobiledata),
            const SizedBox(height: 10),
            _socialButton("Continue with Apple", Icons.apple),
          ],
        ),
      ),
    );
  }

  Widget _socialButton(String text, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠ Social sign-in not implemented yet')),
        );
      },
      icon: Icon(icon, size: 28, color: const Color(0xFF755b48)),
      label: Text(
        text,
        style: GoogleFonts.merriweather(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: const Color(0xFF755b48),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFfcefdc),
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
