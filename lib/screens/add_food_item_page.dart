import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// We need to import the MenuItem class (ensure this path matches where your MenuPage is)
import 'menu_page.dart'; 

class AddFoodItemPage extends StatefulWidget {
  final MenuItem? itemToEdit; // If this is null, we are Adding. If not, we are Editing.

  const AddFoodItemPage({super.key, this.itemToEdit});

  @override
  State<AddFoodItemPage> createState() => _AddFoodItemPageState();
}

class _AddFoodItemPageState extends State<AddFoodItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController(text: 'Mains');

  File? _imageFile;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // If we are editing, fill the text boxes with existing data
    if (widget.itemToEdit != null) {
      _nameCtrl.text = widget.itemToEdit!.name;
      _priceCtrl.text = widget.itemToEdit!.price.toString();
      _descCtrl.text = widget.itemToEdit!.desc;
      _categoryCtrl.text = widget.itemToEdit!.category;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source, maxWidth: 600, imageQuality: 80);
      if (pickedFile != null) setState(() => _imageFile = File(pickedFile.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final supabase = Supabase.instance.client;

    try {
      String imageUrl = widget.itemToEdit?.imageUrl ?? '';

      // 1. Upload NEW Image (if selected)
      if (_imageFile != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final path = 'uploads/$fileName';
        await supabase.storage.from('food-images').upload(path, _imageFile!, fileOptions: const FileOptions(contentType: 'image/jpeg'));
        imageUrl = supabase.storage.from('food-images').getPublicUrl(path);
      }

      final data = {
        'name': _nameCtrl.text,
        'price': double.parse(_priceCtrl.text),
        'description': _descCtrl.text,
        'category': _categoryCtrl.text,
        'image_url': imageUrl,
      };

      if (widget.itemToEdit == null) {
        // --- CREATE NEW ---
        await supabase.from('menu_items').insert({
          ...data,
          'is_available': true,
        });
      } else {
        // --- UPDATE EXISTING ---
        await supabase.from('menu_items').update(data).match({'id': widget.itemToEdit!.id});
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved Successfully!')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if we have an existing image URL to show in preview
    final existingImage = widget.itemToEdit?.imageUrl;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itemToEdit == null ? "Add New Item" : "Edit Item"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () => _showImageSourceDialog(),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                    image: _imageFile != null
                        ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                        : (existingImage != null && existingImage.isNotEmpty)
                            ? DecorationImage(image: NetworkImage(existingImage), fit: BoxFit.cover)
                            : null,
                  ),
                  child: (_imageFile == null && (existingImage == null || existingImage.isEmpty))
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                            Text("Tap to add/change Photo", style: TextStyle(color: Colors.grey)),
                          ],
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: "Food Name", border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Price", prefixText: "\$ ", border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _categoryCtrl, decoration: const InputDecoration(labelText: "Category", border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextFormField(controller: _descCtrl, maxLines: 3, decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder())),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: _isLoading ? null : _saveItem,
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Save Item", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(children: [
          ListTile(leading: const Icon(Icons.photo_library), title: const Text('Gallery'), onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); }),
          ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Camera'), onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); }),
        ]),
      ),
    );
  }
}