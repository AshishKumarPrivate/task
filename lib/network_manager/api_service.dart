import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';


class ApiService {
  static const String baseUrl = "https://9h0vjqq5-5000.inc1.devtunnels.ms/api";
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://randomuser.me/api/'));

  Future<Map<String, dynamic>> fetchUsers({
    required int page, required int results,
    String? gender,}) async {

    final queryParameters = {
      'page': page,
      'results': results,
      if (gender != null) 'gender': gender,
    };

    final response = await _dio.get('', queryParameters: queryParameters);

    return response.data;
  }

  Future<Map<String, dynamic>> registerVendor({
    required Map<String, dynamic> formData,
    required PlatformFile? registrationCertFile,
    required PlatformFile? fssaiCertFile,
    required PlatformFile? gstCertFile,
    required PlatformFile? panCardFile,
    required PlatformFile? aadhaarCardFile,
    required PlatformFile? passportPhotoFile,
    required PlatformFile? businessAddressProofFile,
    required PlatformFile? otherCertificatesFile,
    required PlatformFile? chequeFile,
    required PlatformFile? passbookFile,
  }) async {
    try {
      FormData dioFormData = FormData();

      formData.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          dioFormData.fields.add(MapEntry(key, value.toString()));
        }
      });

      Future<void> addFile(String key, PlatformFile? file) async {
        if (file != null && file.path != null) {
          dioFormData.files.add(MapEntry(
            key,
            await MultipartFile.fromFile(
              file.path!,
              filename: file.name,
              contentType: MediaType(file.extension == 'pdf' ? 'application' : 'image', file.extension ?? 'jpg'),
            ),
          ));
        }
      }

      await addFile('PassportPhoto', passportPhotoFile);
      await addFile('PANCard', panCardFile);
      await addFile('GSTCertificate', gstCertFile);
      // Add more as needed

      final response = await _dio.post('${baseUrl}/admin/vendorregistration', data: dioFormData);
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data ?? {'message': e.message ?? 'Network error'};
    }
  }


}
