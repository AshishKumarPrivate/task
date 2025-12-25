import 'dart:io';
import 'package:demo_task/controller/auth_controller.dart';
import 'package:demo_task/controller/user_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _gstController = TextEditingController();
  final _panController = TextEditingController();

  // File variables
  PlatformFile? _panFile;
  PlatformFile? _gstFile;
  PlatformFile? _profilePhoto;

  Future<void> _pickFile(String type) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null) {
        setState(() {
          switch (type) {
            case 'pan':
              _panFile = result.files.first;
              break;
            case 'gst':
              _gstFile = result.files.first;
              break;
            case 'photo':
              _profilePhoto = result.files.first;
              break;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_profilePhoto == null || _panFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload Profile Photo and PAN')),
      );
      return;
    }

    final provider = Provider.of<AuthApiProvider>(context, listen: false);

    final formData = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'mobile': _mobileController.text.trim(),
      'gstNumber': _gstController.text.trim(),
      'panNumber': _panController.text.trim(),
    };

    provider.registerUser(
      context: context,
      formData: formData,
      panCardFile: _panFile,
      gstCertFile: _gstFile,
      passportPhotoFile: _profilePhoto,
      // Baaki optional files null bhej sakte ho
      registrationCertFile: null,
      fssaiCertFile: null,
      aadhaarCardFile: null,
      businessAddressProofFile: null,
      otherCertificatesFile: null,
      chequeFile: null,
      passbookFile: null,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _gstController.dispose();
    _panController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Registration'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<AuthApiProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: 30),

                      // Profile Photo
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: _profilePhoto != null
                                  ? (kIsWeb
                                  ? MemoryImage(_profilePhoto!.bytes!)
                                  : FileImage(File(_profilePhoto!.path!)))
                                  : null,
                              child: _profilePhoto == null
                                  ? const Icon(Icons.person, size: 60, color: Colors.grey)
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () => _pickFile('photo'),
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.green[700],
                                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Center(
                      //   child: Text(
                      //     _profilePhoto?.name ?? 'Upload Profile Photo *',
                      //     style: TextStyle(
                      //       color: _profilePhoto != null ? Colors.green : Colors.red,
                      //       fontSize: 14,
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 30),

                      // Name
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name *',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v?.trim().isEmpty ?? true ? 'Enter name' : null,
                      ),
                      const SizedBox(height: 20),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email *',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v?.trim().isEmpty ?? true) return 'Enter email';
                          if (!v!.contains('@')) return 'Invalid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Mobile
                      TextFormField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Mobile Number *',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v?.trim().isEmpty ?? true) return 'Enter mobile';
                          if (v!.length != 10) return '10 digits required';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // GST
                      TextFormField(
                        controller: _gstController,
                        decoration: const InputDecoration(
                          labelText: 'GST Number (Optional)',
                          prefixIcon: Icon(Icons.receipt),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // PAN
                      TextFormField(
                        controller: _panController,
                        decoration: const InputDecoration(
                          labelText: 'PAN Number *',
                          prefixIcon: Icon(Icons.credit_card),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v?.trim().isEmpty ?? true ? 'Enter PAN' : null,
                      ),
                      const SizedBox(height: 10),

                      // Upload PAN File
                      _buildFilePicker('PAN Document *', _panFile, () => _pickFile('pan')),
                      const SizedBox(height: 20),

                      // Upload GST File (Optional)
                      _buildFilePicker('GST Certificate (Optional)', _gstFile, () => _pickFile('gst')),
                      const SizedBox(height: 40),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: provider.isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            provider.isLoading ? 'Submitting...' : 'Register',
                            style: const TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Loading Overlay
              if (provider.isLoading)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilePicker(String label, PlatformFile? file, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: file != null ? Colors.green : Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: file != null ? Colors.green[50] : Colors.grey[50],
            ),
            child: Row(
              children: [
                Icon(file != null ? Icons.check_circle : Icons.upload_file, color: file != null ? Colors.green : Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    file?.name ?? 'Tap to upload',
                    style: TextStyle(color: file != null ? Colors.green[800] : Colors.grey[700]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}