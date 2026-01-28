import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  // 0 = Active, 1 = History
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. HEADER ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Manage", style: TextStyle(color: Colors.grey, fontSize: 14)),
                      Text("Orders", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.orange.shade100),
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.orange.shade50,
                      child: const Icon(Icons.person, color: Colors.orange),
                    ),
                  )
                ],
              ),
            ),

            // --- 2. TABS ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  _buildTabButton("Active (3)", 0),
                  _buildTabButton("History", 1),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Colors.black12),
            const SizedBox(height: 20),

            // --- 3. DYNAMIC CONTENT ---
            // This checks which tab is selected and changes the view
            Expanded(
              child: _selectedTab == 0 
                  ? _buildActiveOrdersList() // Show Orders if Tab 0
                  : _buildEmptyHistoryView(), // Show "No Orders" if Tab 1
            ),
          ],
        ),
      ),
    );
  }

  // --- VIEW 1: ACTIVE ORDERS LIST ---
  Widget _buildActiveOrdersList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildOrderCard(
          id: "#2035",
          time: "Incoming • 2 mins ago",
          statusText: "NEW ORDER",
          statusColor: Colors.green,
          price: "₹120",
          paymentStatus: "Prepaid",
          items: "1x Paneer Tikka Burger\nExtra Spice, No Onion",
          showActions: true,
        ),
        _buildOrderCard(
          id: "#2034",
          time: "Started 8 mins ago",
          statusText: "PREPARING",
          statusColor: Colors.orange,
          price: "₹450",
          items: "2x Spicy Chicken Wrap, 1x Large Coke",
          primaryButtonText: "Mark as Ready",
        ),
        _buildOrderCard(
          id: "#2030",
          time: "Waiting for Valet",
          statusText: "READY FOR PICKUP",
          statusColor: Colors.blue,
          price: "₹310",
          items: "1x Maharaja Meal",
          valetName: "Rohan K.",
          valetTime: "2m",
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  // --- VIEW 2: EMPTY HISTORY VIEW ---
  Widget _buildEmptyHistoryView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
            ),
            child: Icon(Icons.history_toggle_off, size: 50, color: Colors.grey[400]),
          ),
          const SizedBox(height: 20),
          Text(
            "No Past Orders",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
          ),
          const SizedBox(height: 8),
          Text(
            "Completed orders will appear here.",
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 50), // Push it up slightly
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildTabButton(String text, int index) {
    bool isActive = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? const Color(0xFFE88B0D) : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? const Color(0xFFE88B0D) : Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard({
    required String id,
    required String time,
    required String statusText,
    required Color statusColor,
    required String price,
    String? paymentStatus,
    required String items,
    bool showActions = false,
    String? primaryButtonText,
    String? valetName,
    String? valetTime,
  }) {
    bool isNewOrder = statusText == "NEW ORDER";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            children: [
              if (isNewOrder)
                Container(width: 6, color: const Color(0xFFE88B0D)),
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(id, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  statusText,
                                  style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE88B0D))),
                              if (paymentStatus != null)
                                Text(paymentStatus, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                            ],
                          )
                        ],
                      ),
                      
                      const SizedBox(height: 6),
                      Text(time, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                      
                      const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),
                      
                      Text(items, style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.4)),
                      
                      const SizedBox(height: 20),

                      if (showActions)
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE88B0D),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: const Text("Reject", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),

                      if (primaryButtonText != null)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE88B0D),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(primaryButtonText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),

                      if (valetName != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.delivery_dining, size: 20, color: Colors.black54),
                                  const SizedBox(width: 10),
                                  Text("$valetName arriving in $valetTime", style: const TextStyle(color: Colors.black54, fontSize: 13)),
                                ],
                              ),
                              const Text("Contact", style: TextStyle(color: Color(0xFFE88B0D), fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}