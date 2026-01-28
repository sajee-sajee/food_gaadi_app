import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_food_item_page.dart';
import 'login_page.dart';

// --- Data Model ---
class MenuItem {
  final String id;
  final String name;
  final String desc;
  final double price;
  final String imageUrl;
  final String category;
  final bool isAvailable;
  final bool isPopular;

  MenuItem({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.isAvailable,
    this.isPopular = false,
  });

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'],
      name: map['name'] ?? '',
      desc: map['description'] ?? '',
      price: (map['price'] as num).toDouble(),
      imageUrl: map['image_url'] ?? '',
      category: map['category'] ?? 'Mains',
      isAvailable: map['is_available'] ?? true,
      isPopular: map['is_popular'] ?? false,
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool showActiveItems = true;
  final _supabase = Supabase.instance.client;

  Stream<List<MenuItem>> _menuStream() {
    return _supabase
        .from('menu_items')
        .stream(primaryKey: ['id'])
        .order('name', ascending: true)
        .map((data) => data.map((json) => MenuItem.fromMap(json)).toList());
  }

  Future<void> _logout() async {
    await _supabase.auth.signOut();
    if (mounted) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFFF5F6F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F6F1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.lunch_dining, color: Colors.orange, size: 20),
                SizedBox(width: 5),
                Text(
                  "FOOD GAADI",
                  style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const Text("Menu Management", style: TextStyle(color: Colors.black54, fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: StreamBuilder<List<MenuItem>>(
        stream: _menuStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.orange));
          
          final allItems = snapshot.data!;
          
          return Column(
            children: [
              _buildTabs(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildCategorySection("Mains", allItems),
                    const SizedBox(height: 20),
                    _buildCategorySection("Drinks", allItems),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddFoodItemPage(itemToEdit: null))),
        backgroundColor: const Color.fromRGBO(255, 152, 0, 1),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTabButton("Active Items", true),
          _buildTabButton("Drafts / Hidden", false),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isActiveTab) {
    bool isSelected = showActiveItems == isActiveTab;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => showActiveItems = isActiveTab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected ? [BoxShadow(color: const Color.fromARGB(255, 10, 223, 137).withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))] : [],
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? const Color.fromRGBO(255, 152, 0, 1) : Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(String category, List<MenuItem> allItems) {
    final filteredItems = allItems.where((item) {
      return item.category == category && (showActiveItems ? item.isAvailable : !item.isAvailable);
    }).toList();

    if (filteredItems.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
              Text("${filteredItems.length} ITEMS", style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        // Use the Animated Item Widget here
        ...filteredItems.map((item) => AnimatedMenuCard(
          key: ValueKey(item.id), // Important for animation to know which item is which
          item: item,
          onToggle: () => _toggleAvailabilityWithAnimation(item.id, item.isAvailable),
          onDelete: () => _deleteItem(item.id),
        )),
      ],
    );
  }

  // --- LOGIC FOR ANIMATION ---
  
  Future<void> _toggleAvailabilityWithAnimation(String id, bool currentStatus) async {
    // 1. Show Feedback
    final bool newStatus = !currentStatus;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(newStatus ? "Moved to Active" : "Moved to Drafts"),
      backgroundColor: Colors.orange,
      duration: const Duration(seconds: 1),
    ));

    // 2. Wait slightly so the user sees the switch move
    await Future.delayed(const Duration(milliseconds: 200));

    // 3. Update DB (The Stream will handle the removal, and the widget will animate out)
    await _supabase.from('menu_items').update({'is_available': newStatus}).match({'id': id});
  }

  Future<void> _deleteItem(String id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Item"),
        content: const Text("Are you sure? This cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (confirm) {
      await _supabase.from('menu_items').delete().match({'id': id});
    }
  }
}

// --- NEW ANIMATED WIDGET ---
class AnimatedMenuCard extends StatefulWidget {
  final MenuItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const AnimatedMenuCard({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  State<AnimatedMenuCard> createState() => _AnimatedMenuCardState();
}

class _AnimatedMenuCardState extends State<AnimatedMenuCard> {
  // We use this to trigger the slide-out animation before the item is actually removed from the list
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: _isVisible
          ? Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: 80, height: 80,
                      color: Colors.grey[100],
                      child: widget.item.imageUrl.isNotEmpty
                          ? Image.network(widget.item.imageUrl, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.fastfood, color: Colors.grey))
                          : const Icon(Icons.fastfood, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 15),

                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(widget.item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            if (widget.item.isPopular) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: Colors.orange[100], borderRadius: BorderRadius.circular(4)),
                                child: const Text("POPULAR", style: TextStyle(fontSize: 9, color: Colors.deepOrange, fontWeight: FontWeight.bold)),
                              )
                            ]
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.item.desc,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.3),
                        ),
                        const SizedBox(height: 8),
                        // --- CHANGED THIS LINE TO RUPEE ---
                        Text("₹${widget.item.price.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                  ),

                  // Actions
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: widget.item.isAvailable,
                          activeThumbColor: Colors.white,
                          activeTrackColor: const Color.fromRGBO(255, 152, 0, 1),
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey[300],
                          onChanged: (val) async {
                            // 1. Trigger Animation locally
                            setState(() => _isVisible = false);
                            
                            // 2. Wait for animation to finish visually
                            await Future.delayed(const Duration(milliseconds: 300));
                            
                            // 3. Call the actual logic
                            widget.onToggle();
                          },
                        ),
                      ),
                      if (!widget.item.isAvailable)
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0, bottom: 4),
                          child: Text("SOLD OUT", style: TextStyle(fontSize: 9, color: Colors.redAccent, fontWeight: FontWeight.bold)),
                        ),
                      
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.more_horiz, color: Colors.grey),
                        onSelected: (value) async {
                          if (value == 'edit') {
                             Navigator.push(context, MaterialPageRoute(builder: (_) => AddFoodItemPage(itemToEdit: widget.item)));
                          } else if (value == 'delete') {
                             setState(() => _isVisible = false);
                             await Future.delayed(const Duration(milliseconds: 300));
                             widget.onDelete();
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(children: [Icon(Icons.edit, size: 20), SizedBox(width: 8), Text('Edit')]),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(children: [Icon(Icons.delete, color: Colors.red, size: 20), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red))]),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          : const SizedBox.shrink(), // When hidden, shrink to zero size
    );
  }
}