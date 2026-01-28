// File: lib/screens/success_qr_page.dart
import 'package:flutter/material.dart';
import 'dashboard_page.dart';

class SuccessQrPage extends StatelessWidget {
  const SuccessQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Center(child: CircleAvatar(radius: 30, backgroundColor: Color(0xFFFEF3C7), child: Icon(Icons.check_circle, color: Colors.orange, size: 40))),
            const SizedBox(height: 20),
            const Text("Success!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              child: Text("Your unique Food Gaadi QR code for this location has been generated.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            ),
            
            // The Card UI
            Container(
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
              ),
              child: Column(
                children: [
                  Container(height: 8, decoration: const BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.vertical(top: Radius.circular(20)))),
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text("Tasty Tacos", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        Text("Downtown • ID #FG-88291", style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 30),
                        // Replace with your actual QR Widget or Image
                        Icon(Icons.qr_code_2, size: 200, color: Colors.black87),
                        SizedBox(height: 20),
                        Text("SCAN FOR MENU & PAY", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                        Text("Powered by Food Gaadi", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            
            // Buttons
            _actionButton("Download Image", Colors.orange, Colors.white, Icons.download),
            _actionButton("Print Poster", Colors.white, Colors.black87, Icons.print, hasBorder: true),
            
            TextButton(
              onPressed: () {
                // THIS IS THE FIX: Clear all history and go to Dashboard
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardPage()),
                  (route) => false,
                );
              },
              child: const Text("Go to Home", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(String title, Color bg, Color text, IconData icon, {bool hasBorder = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: SizedBox(
        width: double.infinity, height: 50,
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(icon, size: 18),
          label: Text(title),
          style: ElevatedButton.styleFrom(
            backgroundColor: bg, foregroundColor: text,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: hasBorder ? const BorderSide(color: Colors.grey) : BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}