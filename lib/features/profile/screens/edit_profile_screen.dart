import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const EditProfileScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // State variables to hold editable user data
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  // Placeholder for the actual image path/URL.
  // In a real app, this would be a URL or a file path from image_picker.
  String _profileImagePath = 'assets/images/employee.jpg';

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the data passed from the widget
    _nameController = TextEditingController(text: widget.userName);
    _emailController = TextEditingController(text: widget.userEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Placeholder function for image picking (requires image_picker package)
  void _changePicture() async {
    // --- Implementation using image_picker package (if installed) ---
    // final ImagePicker picker = ImagePicker();
    // final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    // if (image != null) {
    //   setState(() {
    //     _profileImagePath = image.path; // Update state with new local path
    //   });
    // }

    // For now, we'll just log a message to show the function is called
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image picker functionality placeholder.')),
    );
  }

  // Function to simulate saving the changes
  void _saveChanges() {
    // 1. Get the current values from controllers
    final newName = _nameController.text.trim();
    final newEmail = _emailController.text.trim();

    // 2. Perform validation (e.g., check if email is valid, fields are not empty)
    if (newName.isEmpty || newEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and Email cannot be empty.')),
      );
      return;
    }

    // 3. Logic to update backend/provider (e.g., calling an AuthService/Provider method)
    print(
      'Saving profile: Name=$newName, Email=$newEmail, Image=$_profileImagePath',
    );

    // In a real app, you'd update a Provider or make an API call here.
    // Assuming success:
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );

    // 4. Navigate back
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Determine the image source based on whether it's a local file path (from image_picker)
    // or the default asset.
    final ImageProvider imageProvider;
    if (_profileImagePath.startsWith('assets/')) {
      imageProvider = AssetImage(_profileImagePath);
    } else {
      // Placeholder for FileImage or NetworkImage if image_picker were used
      imageProvider = const AssetImage('assets/images/employee.jpg');
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile Information')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // User Avatar
            CircleAvatar(radius: 50, backgroundImage: imageProvider),
            TextButton.icon(
              onPressed: _changePicture, // Calls the placeholder function
              icon: const Icon(Icons.edit),
              label: const Text('Change Picture'),
            ),

            const SizedBox(height: 20),

            // Name Input
            TextFormField(
              controller: _nameController, // Use controller for editable state
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),

            // Email Input
            TextFormField(
              controller: _emailController, // Use controller for editable state
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveChanges, // Calls the saving logic
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
