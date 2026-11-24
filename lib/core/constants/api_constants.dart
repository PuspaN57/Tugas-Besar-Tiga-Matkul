class ApiConstants {
  // Emulator Android → host PC = 10.0.2.2
  // Ganti ke IP LAN Laragon jika memakai device fisik.
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String tokenKey = 'ecocycle_token';
}