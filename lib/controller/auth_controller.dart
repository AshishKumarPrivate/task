// lib/providers/registration_provider.dart

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:demo_task/network_manager/api_service.dart';

class AuthApiProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String? _successMessage;
  String? get successMessage => _successMessage;

  Future<void> registerUser({
    required BuildContext context,
    required Map<String, dynamic> formData,
    required PlatformFile? passportPhotoFile,
    required PlatformFile? panCardFile,
    required PlatformFile? gstCertFile,
    PlatformFile? registrationCertFile,
    PlatformFile? fssaiCertFile,
    PlatformFile? aadhaarCardFile,
    PlatformFile? businessAddressProofFile,
    PlatformFile? otherCertificatesFile,
    PlatformFile? chequeFile,
    PlatformFile? passbookFile,
  }) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.registerVendor(
        formData: formData,
        passportPhotoFile: passportPhotoFile,
        panCardFile: panCardFile,
        gstCertFile: gstCertFile,
        registrationCertFile: registrationCertFile,
        fssaiCertFile: fssaiCertFile,
        aadhaarCardFile: aadhaarCardFile,
        businessAddressProofFile: businessAddressProofFile,
        otherCertificatesFile: otherCertificatesFile,
        chequeFile: chequeFile,
        passbookFile: passbookFile,
      );

      _successMessage = response['message'] ?? 'Vendor registered successfully!';
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_successMessage!),
          backgroundColor: Colors.green,
        ),
      );

      // Optional: Navigate to login or home
      // Navigator.pop(context);
    } catch (e) {
      _error = (e is Map) ? e['message'] : e.toString();
      if (_error == null || _error!.isEmpty) _error = 'Registration failed';

      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_error!),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }
}