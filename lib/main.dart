import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

// Imports
import 'screens/login_page.dart';
import 'screens/dashboard_page.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(

    url: 'https://cpccxdysbtsfqpvfsfph.supabase.co',
    anonKey: 'sb_publishable_hH0ZFPqleNAUXz9osQniLg_5Q7zOfPb', 
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Gaadi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            

            Image.asset(
              'lib/assets/favicon.png', 
              width: 250, 
              height: 250,

              errorBuilder: (context, error, stackTrace) {
                return const Column(
                  children: [
                    Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    Text("Image Not Found", style: TextStyle(color: Colors.red)),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),
            

            Hero(
              tag: 'title',
              child: Material(
                color: Colors.transparent,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 45, color: Colors.black),
                    children: [
                      const TextSpan(
                        text: 'Food',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                      TextSpan(
                        text: 'Gaadi',
                        style: GoogleFonts.pacifico(
                          color: const Color(0xFF1B5E20),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),


            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 1.2),
                children: [
                  TextSpan(
                    text: 'Fuel your ',
                    style: TextStyle(color: Colors.orange),
                  ),
                  TextSpan(
                    text: 'Hunger',
                    style: TextStyle(color: Color(0xFF1B5E20)),
                  ),
                ],
              ),
            ),

            const Spacer(),
            const CircularProgressIndicator(color: Colors.orange), 
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
