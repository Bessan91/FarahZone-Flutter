import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  // منفذ الـ API الخاص بـ FarahZoneBackend (يمكنك تعديل المنفذ حسب إعدادات Swagger/Backend لديك)
  static const String baseUrl = 'https://localhost:7006/api';

  // 1. إدارة التوكن (JWT Token)
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  // 2. تسجيل الدخول (Login)
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['token'] != null) {
          await saveToken(data['token']);
        }
        return data;
      } else {
        throw ApiException(data['message'] ?? 'فشل تسجيل الدخول');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('تعذر الاتصال بالسيرفر. تأكدي من تشغيل الباك إند.');
    }
  }

  // 3. إنشاء حساب جديد (Register)
  static Future<Map<String, dynamic>> register(Map<String, dynamic> bodyData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['token'] != null) {
          await saveToken(data['token']);
        }
        return data;
      } else {
        throw ApiException(data['message'] ?? 'فشل إنشاء الحساب');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('تعذر الاتصال بالسيرفر. تأكدي من تشغيل الباك إند.');
    }
  }

  // 4. جلب بروفايل مزود الخدمة (Get Provider Profile)
  static Future<Map<String, dynamic>> getMyProviderProfile() async {
    try {
      final token = await getToken();
      if (token == null) throw ApiException('يرجى تسجيل الدخول أولاً');

      final response = await http.get(
        Uri.parse('$baseUrl/Auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw ApiException(data['message'] ?? 'تعذر جلب بيانات البروفايل');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('تعذر جلب بيانات البروفايل');
    }
  }
}