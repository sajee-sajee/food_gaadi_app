// File: lib/screens/otp_page.dart
import 'package:flutter/material.dart';
import 'success_qr_page.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0, backgroundColor: Colors.white, leading: const BackButton(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const Text("VENDOR LOGIN", style: TextStyle(color: Colors.grey, letterSpacing: 1.2, fontSize: 12)),
            const SizedBox(height: 30),
            const Text("Enter Verification Code", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 12),
            const Text("We've sent a 4-digit code to your registered\nmobile number +91 ***** 8899", textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey)),
            const SizedBox(height: 40),
            
            // OTP Input Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => _buildOtpField(index == 0 ? "5" : "")),
            ),
            
            const SizedBox(height: 30),
            const Text.rich(TextSpan(text: "Didn't receive the code? ", children: [
              TextSpan(text: "Resend", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
              TextSpan(text: " (00:30)", style: TextStyle(color: Colors.grey)),
            ])),
            const Spacer(),
            
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SuccessQrPage())),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text("Verify", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpField(String digit) {
    return Container(
      width: 70, height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: digit.isNotEmpty ? Colors.orange : Colors.grey.shade200, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(digit, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
    );
  }
}