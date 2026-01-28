import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import your screens
import 'menu_page.dart';
import 'Orders_page.dart'; // Make sure this matches your filename
import 'profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  // Function to switch tabs programmatically (used by DashboardView)
  void _switchTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // We pass the _switchTab function down to the DashboardView
    final List<Widget> pages = [
      DashboardView(onProfileTap: () => _switchTab(3), onMenuTap: () => _switchTab(1)),
      const MenuPage(),
      const OrdersPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light grey background matches design
      body: SafeArea(
        child: pages[_selectedIndex], 
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFE88B0D), // Brand Orange
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: "Menu"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profile"),
        ],
      ),
    );
  }
}

// --- DASHBOARD CONTENT ---
class DashboardView extends StatefulWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onMenuTap;

  const DashboardView({
    super.key, 
    required this.onProfileTap, 
    required this.onMenuTap
  });

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool isOnline = true;
  String truckName = "Loading..."; 

  @override
  void initState() {
    super.initState();
    _fetchVendorDetails();
  }

  Future<void> _fetchVendorDetails() async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser!.id;
      final data = await supabase.from('profiles').select('full_name').eq('id', userId).single();
      if (mounted) setState(() => truckName = data['full_name'] ?? "Food Gaadi");
    } catch (e) {
      if (mounted) setState(() => truckName = "Food Gaadi Vendor");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome back", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(truckName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              // Profile Icon with Tap Action
              GestureDetector(
                onTap: widget.onProfileTap, // <--- Switches to Profile Tab
                child: Container(
                  padding: const EdgeInsets.all(2), // Border width
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xFFE88B0D), // Orange bg if no image
                    child: Icon(Icons.store, color: Colors.white),
                    // backgroundImage: NetworkImage('...'), // Add image here later
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 2. ONLINE STATUS CARD
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("You are Online", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("Shop is currently accepting orders", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
                Transform.scale(
                  scale: 0.9,
                  child: Switch(
                    value: isOnline,
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xFFE88B0D),
                    onChanged: (val) => setState(() => isOnline = val),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 3. OVERVIEW GRID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Today's Overview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(20)),
                child: const Row(
                  children: [
                    Icon(Icons.account_balance_wallet, size: 14, color: Color(0xFFE88B0D)),
                    SizedBox(width: 4),
                    Text("Wallet", style: TextStyle(color: Color(0xFFE88B0D), fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          
          // Stats Row 1
          Row(
            children: [
              // Revenue Card (Orange)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  height: 140,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE88B0D),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Revenue", style: TextStyle(color: Colors.white70, fontSize: 13)),
                          Icon(Icons.monetization_on_outlined, color: Colors.white30),
                        ],
                      ),
                      Text("₹12,450", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Orders Card
              Expanded(
                child: _buildStatCard("Total Orders", "42", Icons.shopping_bag_outlined, badgeColor: null),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Stats Row 2
          Row(
            children: [
              Expanded(child: _buildStatCard("Pending", "5", null, badgeCount: "5")),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard("Rating", "4.8", Icons.star, isRating: true)),
            ],
          ),

          const SizedBox(height: 24),

          // 4. QUICK ACTIONS
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: widget.onMenuTap, // Goes to Menu Tab
                  child: _buildActionButton("Update\nMenu", Icons.restaurant_menu),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionButton("Settings", Icons.store),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 5. RECENT ORDERS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Recent Orders", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(onPressed: () {}, child: const Text("View All", style: TextStyle(color: Color(0xFFE88B0D))))
            ],
          ),
          
          // Sample Order Card 1
          _buildOrderCard(
            id: "#2035", 
            price: "₹120", 
            items: "1x Veg Whopper Burger\nExtra Cheese, No Onion",
            time: "2 mins ago",
            isNew: true
          ),
          // Sample Order Card 2
          _buildOrderCard(
            id: "#2034", 
            price: "₹450", 
            items: "2x Spicy Chicken Wrap, 1x Large Coke...",
            time: "10:45 AM",
            status: "PREPARING",
            isNew: false
          ),
          
          const SizedBox(height: 80), // Bottom padding
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildStatCard(String title, String value, IconData? icon, {String? badgeCount, bool isRating = false, Color? badgeColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              if (icon != null) Icon(icon, color: isRating ? Colors.amber : Colors.grey[400], size: 20),
              if (badgeCount != null) 
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: const Color(0xFFFFF3E0), shape: BoxShape.circle),
                  child: Text(badgeCount, style: const TextStyle(color: Color(0xFFE88B0D), fontWeight: FontWeight.bold, fontSize: 12)),
                )
            ],
          ),
          Row(
            children: [
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              if (isRating) Text("/5.0", style: TextStyle(fontSize: 12, color: Colors.grey[400])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFFFF3E0),
            radius: 18,
            child: Icon(icon, color: const Color(0xFFE88B0D), size: 18),
          ),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildOrderCard({required String id, required String price, required String items, required String time, bool isNew = false, String? status}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isNew ? Border(left: BorderSide(color: const Color(0xFFE88B0D), width: 4)) : null,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(width: 10),
                  if (isNew)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(6)),
                      child: const Text("NEW ORDER", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  if (status != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(6)),
                      child: Text(status, style: const TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
              Text(price, style: const TextStyle(color: Color(0xFFE88B0D), fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 6),
          Text("Incoming • $time", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),
          
          Text(items, style: TextStyle(color: Colors.grey[800], height: 1.4)),
          
          if (isNew) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE88B0D),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Accept", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Decline", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )
          ]
        ],
      ),
    );
  }
}