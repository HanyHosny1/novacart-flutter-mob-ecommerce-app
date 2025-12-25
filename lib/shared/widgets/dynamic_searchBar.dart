import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:novacart/shared/widgets/product_search_delegate.dart';

class DynamicSearchBar extends StatefulWidget {
  const DynamicSearchBar({super.key});

  @override
  State<DynamicSearchBar> createState() => _DynamicSearchBarState();
}

class _DynamicSearchBarState extends State<DynamicSearchBar> {
  final List<String> _suggestions = [
    "Electronics",
    "Jewelery",
    "Men's Clothing",
    "Women's Clothing",
  ];
  int _index = 0;
  late Timer _timer;
  final ImagePicker _picker = ImagePicker(); // Initialize Picker

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _index = (_index + 1) % _suggestions.length;
        });
      }
    });
  }

  // --- NEW: Method to pick image ---
  Future<void> _pickImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    if (selectedImage != null) {
      // For now, we just print the path.
      // Later, you can send this file to an API for Visual Search.
      print("Image selected: ${selectedImage.path}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selected: ${selectedImage.name}")),
      );
    }
  }

  // --- NEW: Show Options Dialog ---
  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          showSearch(context: context, delegate: ProductSearchDelegate()),
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 10),
            const Text(
              "Search ",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Text(
                  _suggestions[_index],
                  key: ValueKey(_suggestions[_index]),
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),
            Container(
              height: 20,
              width: 1,
              color: Colors.grey.shade400,
              margin: const EdgeInsets.symmetric(horizontal: 10),
            ),
            // Updated: Wrap Icon in IconButton to make it clickable
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.black87,
              ),
              onPressed: _showPickerOptions, // Trigger the menu
            ),
          ],
        ),
      ),
    );
  }
}
