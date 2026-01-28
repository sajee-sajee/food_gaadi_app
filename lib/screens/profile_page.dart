import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart'; // Needed for Logout navigation

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  String _truckName = "Loading...";
  String _email = "Loading...";
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  Future<void> _getProfile() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user != null) {
        setState(() {
          _email = user.email ?? "No Email";
        });

        final data = await supabase
            .from('profiles')
            .select('full_name, avatar_url')
            .eq('id', user.id)
            .single();

        if (mounted) {
          setState(() {
            _truckName = data['full_name'] ?? "Food Truck";
            _avatarUrl = data['avatar_url'];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _truckName = "Error loading profile";
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          // LOGOUT BUTTON (Top Right as requested)
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // --- 1. PROFILE HEADER ---
                  Center(
                    child: Column(
                      children: [
                        // Avatar with Camera Icon
                        Stack(
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade200, width: 4),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: _avatarUrl != null && _avatarUrl!.isNotEmpty
                                      ? NetworkImage(_avatarUrl!)
                                      : const NetworkImage(
                                          'https://img.freepik.com/free-vector/food-truck-illustrated_23-2148596634.jpg'), // Placeholder
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        
                        // Names
                        Text(
                          _truckName,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Owner: $_email", // Using email as placeholder for owner name
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                        const SizedBox(height: 20),

                        // Edit Button
                        SizedBox(
                          width: 150,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Edit Profile Coming Soon!"))
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            child: const Text("Edit Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- 2. SETTINGS LIST ---
                  _buildProfileOption(Icons.store, "Business Details", "Name, Category, Bio", Colors.orange.shade100, Colors.orange),
                  _buildProfileOption(Icons.access_time, "Operating Hours", "Manage your weekly schedule", Colors.brown.shade100, Colors.brown),
                  _buildProfileOption(Icons.map, "Location Management", "Default spots and live GPS", Colors.blue.shade100, Colors.blue),
                  _buildProfileOption(Icons.account_balance_wallet, "Bank Account & Payouts", "Manage earnings and transfers", Colors.green.shade100, Colors.green),
                  _buildProfileOption(Icons.settings, "App Settings", "Notifications, Language, Privacy", Colors.grey.shade200, Colors.grey.shade700),
                  
                  const SizedBox(height: 30),
                  
                  // Version Text
                  Text(
                    "Version 2.4.0 (Food Gaadi Vendor)",
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, String subtitle, Color bgColor, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white, // Or Colors.grey[50] if you want a slight background
        borderRadius: BorderRadius.circular(15),
        // Optional shadow if you want the card look from screenshot
        // boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(
          title, 
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          subtitle, 
          style: TextStyle(color: Colors.grey[500], fontSize: 13),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}