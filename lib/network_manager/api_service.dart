import 'package:dio/dio.dart';

class ApiService {
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
}
