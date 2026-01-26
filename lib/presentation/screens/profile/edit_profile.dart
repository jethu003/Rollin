import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() => _isLoading = true);
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc =
            await _firestore
                .collection('rollin_user_profile')
                .doc(user.uid)
                .get();
        if (doc.exists) {
          _userData = doc.data();
        }
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const Divider(height: 16),
        ],
      ),
    );
  }

  void _navigateToEditProfile() async {
    if (_userData == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(userData: _userData!),
      ),
    );

    // Refresh profile if edited
    if (result == true) {
      _fetchUserProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.shineBlack,
      appBar: AppBar(
  automaticallyImplyLeading: false,
  backgroundColor: AppColours.shineBlack,
  title: const Text('Profile'),

  leading: IconButton(
    icon: const Icon(
      Icons.arrow_back_ios, 
      size: 22,
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  ),

  actions: [
    IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: _navigateToEditProfile,
    ),
  ],
),

      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _userData == null
              ? const Center(child: Text('No profile data found'))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFFFFCC33),
                      backgroundImage:
                          _userData!['profileImage'] != null &&
                                  _userData!['profileImage']
                                      .toString()
                                      .isNotEmpty
                              ? NetworkImage(_userData!['profileImage'])
                              : null,
                      child:
                          (_userData!['profileImage'] == null ||
                                  _userData!['profileImage'].toString().isEmpty)
                              ? const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              )
                              : null,
                    ),

                    const SizedBox(height: 16),
                    Text(
                      _userData!['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Member since ${_userData!['createdAt'] != null ? (_userData!['createdAt'] as Timestamp).toDate().toLocal().toString().split(' ')[0] : '-'}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    _buildDetailRow('Phone', _userData!['phone'] ?? '-'),
                    _buildDetailRow('Email', _userData!['email'] ?? '-'),
                    _buildDetailRow('Gender', _userData!['gender'] ?? '-'),
                    _buildDetailRow(
                      'Date of Birth',
                      _userData!['dob'] != null
                          ? (_userData!['dob'] as Timestamp)
                              .toDate()
                              .toLocal()
                              .toString()
                              .split(' ')[0]
                          : '-',
                    ),
                    const SizedBox(height: 40),
                    // TextButton(
                    //   onPressed: () async {
                    //     // Delete account
                    //     final user = _auth.currentUser;
                    //     if (user != null) {
                    //       try {
                    //         await _firestore.collection('rollin_user_profile').doc(user.uid).delete();
                    //         await user.delete();
                    //         Navigator.pop(context);
                    //       } catch (e) {
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           SnackBar(content: Text('Error deleting account: $e')),
                    //         );
                    //       }
                    //     }
                    //   },
                    //   child: const Text(
                    //     'Delete Account',
                    //     style: TextStyle(
                    //       color: Colors.red,
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
    );
  }
}

// ------------------ EDIT PROFILE SCREEN ------------------

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  String? _selectedGender;
  DateTime? _selectedDOB;

  bool _isSaving = false;

  File? _newProfileImage;
  String? _profileImageUrl;

  final ImagePicker _picker = ImagePicker();

  //  Cloudinary
  final String cloudName = "drrb3q6nl";
  final String uploadPreset = "rollin_theatre";

  final List<String> _genders = [
    'Female',
    'Male',
    'Other',
    'Prefer not to say',
  ];

  @override
  void initState() {
    super.initState();
    final data = widget.userData;

    _nameController = TextEditingController(text: data['name'] ?? '');
    _emailController = TextEditingController(text: data['email'] ?? '');
    _phoneController = TextEditingController(text: data['phone'] ?? '');

    _selectedGender = data['gender'];
    _profileImageUrl = data['profileImage'];

    _selectedDOB =
        data['dob'] != null ? (data['dob'] as Timestamp).toDate() : null;
  }

  //  Pick Image
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _newProfileImage = File(picked.path));
    }
  }

  //  Upload to Cloudinary
  Future<String?> _uploadToCloudinary(File file, String userId) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request =
        http.MultipartRequest("POST", url)
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

  //  Save profile
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() ||
        _selectedGender == null ||
        _selectedDOB == null) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (_newProfileImage != null) {
          _profileImageUrl = await _uploadToCloudinary(
            _newProfileImage!,
            user.uid,
          );
        }

        await FirebaseFirestore.instance
            .collection('rollin_user_profile')
            .doc(user.uid)
            .update({
              'name': _nameController.text.trim(),
              'email': _emailController.text.trim(),
              'phone': _phoneController.text.trim(),
              'gender': _selectedGender,
              'dob': _selectedDOB,
              'profileImage': _profileImageUrl,
              'updatedAt': FieldValue.serverTimestamp(),
            });

        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.shineBlack,
      appBar:AppBar(
  backgroundColor: AppColours.shineBlack,

  leading: IconButton(
    icon: const Icon(
      Icons.arrow_back_ios_new, // looks like <
      color: AppColours.shineWhite,
      size: 22, // 👈 normal size
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  ),

  title: const Text(
    'Edit Profile',
    style: TextStyle(color: AppColours.shineWhite),
  ),
),
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
                          backgroundImage:
                              _newProfileImage != null
                                  ? FileImage(_newProfileImage!)
                                  : (_profileImageUrl != null
                                          ? NetworkImage(_profileImageUrl!)
                                          : null)
                                      as ImageProvider?,
                          child:
                              (_newProfileImage == null &&
                                      _profileImageUrl == null)
                                  ? const Icon(Icons.camera_alt, size: 30)
                                  : null,
                        ),
                      ),
                      const SizedBox(height: 30),

                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name*'),
                        validator:
                            (v) => v == null || v.isEmpty ? 'Enter name' : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email*'),
                        validator:
                            (v) =>
                                v == null || v.isEmpty ? 'Enter email' : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(labelText: 'Phone*'),
                        validator:
                            (v) =>
                                v == null || v.isEmpty ? 'Enter phone' : null,
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Gender*'),
                        value: _selectedGender,
                        items:
                            _genders
                                .map(
                                  (g) => DropdownMenuItem(
                                    value: g,
                                    child: Text(g),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) => setState(() => _selectedGender = v),
                        validator: (v) => v == null ? 'Select gender' : null,
                      ),
                      const SizedBox(height: 16),

                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDOB ?? DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => _selectedDOB = picked);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Date of Birth*',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            _selectedDOB == null
                                ? 'Select'
                                : '${_selectedDOB!.day}/${_selectedDOB!.month}/${_selectedDOB!.year}',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColours.primaryColor,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      _isSaving
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black87,
                            ),
                          )
                          : const Text(
                            'Save',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
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





