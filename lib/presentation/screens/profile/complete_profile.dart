import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:rollin_user/presentation/authentication/login.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';

class CompleteProfile extends StatefulWidget {
  final String name;
  final String email;

  const CompleteProfile({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final TextEditingController _phoneController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDateOfBirth;
  bool _isSaving = false;

  File? _profileImage;
  String? _profileImageUrl;

  final ImagePicker _picker = ImagePicker();

  // Cloudinary details
  final String cloudName = "drrb3q6nl";
  final String uploadPreset = "rollin_theatre";

  final List<String> _genders = [
    'Female',
    'Male',
    'Other',
    'Prefer not to say'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
  }

  //  Pick Image
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  //  Upload to Cloudinary
  Future<String?> _uploadToCloudinary(File file, String userId) async {
    final url =
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    final request = http.MultipartRequest("POST", url)
      ..fields['upload_preset'] = uploadPreset
      ..fields['folder'] = "users/$userId"
      ..files.add(await http.MultipartFile.fromPath("file", file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return json.decode(respStr)['secure_url'];
    }
    return null;
  }

  //  Save Profile
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedGender == null || _selectedDateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select gender and date of birth')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (_profileImage != null) {
          _profileImageUrl =
              await _uploadToCloudinary(_profileImage!, user.uid);
        }

        await FirebaseFirestore.instance
            .collection('rollin_user_profile')
            .doc(user.uid)
            .set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'gender': _selectedGender,
          'dob': _selectedDateOfBirth,
          'profileImage': _profileImageUrl,
          'createdAt': FieldValue.serverTimestamp(),
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => UserLoginScreen()),
          (_) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                          child: _profileImage == null
                              ? const Icon(Icons.camera_alt, size: 32)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 30),

                      TextFormField(
                        controller: _nameController,
                        decoration:
                            const InputDecoration(labelText: 'Name*'),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Enter name' : null,
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _emailController,
                        decoration:
                            const InputDecoration(labelText: 'Email*'),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Enter email' : null,
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration:
                            const InputDecoration(labelText: 'Phone*'),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Enter phone' : null,
                      ),
                      const SizedBox(height: 20),

                      DropdownButtonFormField<String>(
                        decoration:
                            const InputDecoration(labelText: 'Gender*'),
                        value: _selectedGender,
                        items: _genders
                            .map((g) => DropdownMenuItem(
                                  value: g,
                                  child: Text(g),
                                ))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _selectedGender = v),
                        validator: (v) =>
                            v == null ? 'Select gender' : null,
                      ),
                      const SizedBox(height: 20),

                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(
                                () => _selectedDateOfBirth = picked);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Date of Birth*',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            _selectedDateOfBirth == null
                                ? 'Select'
                                : '${_selectedDateOfBirth!.day}/${_selectedDateOfBirth!.month}/${_selectedDateOfBirth!.year}',
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColours.primaryColor,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text(
                        'Save Profile',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
