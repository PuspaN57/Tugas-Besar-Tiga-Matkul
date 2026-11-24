import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../errors/failures.dart';
import '../services/token_storage.dart';

class ApiClient {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  ApiClient(this._dio, this._tokenStorage) {
    _dio.options
      ..baseUrl = ApiConstants.baseUrl
      ..connectTimeout = ApiConstants.connectTimeout
      ..receiveTimeout = ApiConstants.receiveTimeout;

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> get(String path,
      {Map<String, dynamic>? query}) async {
    try {
      final res = await _dio.get(path, queryParameters: query);
      return _asMap(res.data);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<Map<String, dynamic>> post(String path,
      {Object? data, bool multipart = false}) async {
    try {
      final res = await _dio.post(path, data: data);
      return _asMap(res.data);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<Map<String, dynamic>> put(String path,
      {Object? data}) async {
    try {
      final res = await _dio.put(path, data: data);
      return _asMap(res.data);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Map<String, dynamic> _asMap(dynamic body) {
    if (body is Map<String, dynamic>) return body;
    throw const ServerFailure('Format respons tidak valid');
  }

  Failure _mapError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const NetworkFailure();
    }
    final msg = e.response?.data is Map
        ? (e.response!.data['message']?.toString() ??
            'Permintaan gagal (${e.response?.statusCode})')
        : 'Permintaan gagal (${e.response?.statusCode ?? e.type.name})';
    if (e.response?.statusCode == 401) return AuthFailure(msg);
    return ServerFailure(msg);
  }
}