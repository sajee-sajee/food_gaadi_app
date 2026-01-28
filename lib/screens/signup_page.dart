// File: lib/screens/signup_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/food_gaadi_logo.dart'; 
import 'otp_page.dart'; 
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              // 1. SMALL TOP LOGO
              const FoodGaadiLogo(size: 80),
              
              const SizedBox(height: 10),

              // 2. LOGO TEXT
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 24, color: Colors.black),
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

              const SizedBox(height: 20),

              // 3. HEADLINES
              const Text(
                "Vendor Sign Up",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Join our food truck community and start\nserving delicious meals!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 30),

              // 4. THE FORM FIELDS
              _buildLabel("Owner Name"),
              _buildTextField(hint: "Ex. Rajesh Kumar", icon: Icons.person),

              _buildLabel("Food Truck Name"),
              _buildTextField(hint: "Ex. Spice Wheels", icon: Icons.storefront),

              _buildLabel("Email Address"),
              _buildTextField(hint: "hello@example.com", icon: Icons.email_outlined),

              _buildLabel("Mobile Number"),
              _buildTextField(hint: "+91 98765 43210", icon: Icons.phone),

              _buildLabel("Base Location"),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Set truck location",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(4),
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.location_on, color: Colors.orange),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40), // Spacing before the button

              // --- 5. THE NEW "NEXT" BUTTON ---
              SizedBox(
                width: double.infinity, // Makes it full width
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OtpPage()),
                      );// Action for Next button goes here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor:const Color(0xFFF5F6F1),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 6. FOOTER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.black87),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Goes back to Login
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget for Labels
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B5E20),
          ),
        ),
      ),
    );
  }

  // Helper Widget for Text Fields
  Widget _buildTextField({required String hint, required IconData icon}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.orange.shade300),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.orange, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}