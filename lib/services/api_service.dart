import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ApiService {
  // بورت https الحالي للباك (شوفيه من رابط Swagger، مثلاً https://localhost:7006/swagger)
  static const int _httpsPort = 7006;

  // بورت http للمحاكي (من Properties/launchSettings.json بالباك)
  static const int _httpPort = 5000;

  // ويب / ويندوز: https://localhost:<_httpsPort>
  // محاكي أندرويد: http://10.0.2.2:<_httpPort>
  static String get _host {
    if (kIsWeb) return 'https://localhost:$_httpsPort';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:$_httpPort';
    }
    return 'https://localhost:$_httpsPort';
  }

  static String get baseUrl => '$_host/api';

  static const _storage = FlutterSecureStorage();

  // =========================================================
  // LOOKUPS  (عربي <-> كود الباك إند)
  // =========================================================

  static const Map<String, String> serviceCodes = {
    'قاعات الأفراح': 'wedding_hall',
    'صالونات التجميل': 'beauty_salon',
    'التزيين والديكور': 'decor',
    'تأجير السيارات': 'car_rental',
    'قاعات الفنادق': 'hotel_hall',
  };

  static const Map<String, String> locationCodes = {
    'رام الله': 'ramallah',
    'نابلس': 'nablus',
    'القدس': 'jerusalem',
    'بيت لحم': 'bethlehem',
    'الخليل': 'hebron',
  };

  static String serviceLabel(String code) => _labelFor(serviceCodes, code);
  static String locationLabel(String code) => _labelFor(locationCodes, code);

  static String _labelFor(Map<String, String> map, String code) {
    for (final e in map.entries) {
      if (e.value == code) return e.key;
    }
    return code;
  }

  // =========================================================
  // AUTH
  // =========================================================

  static Future<Map<String, dynamic>> register(
    Map<String, dynamic> body,
  ) async {
    return _asMap(await _request('POST', '/auth/register', body: body));
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    return _asMap(
      await _request(
        'POST',
        '/auth/login',
        body: {'email': email, 'password': password},
      ),
    );
  }

  static Future<String?> getToken() => _storage.read(key: 'token');
  static Future<String?> getRole() => _storage.read(key: 'role');

  static Future<void> logout() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'role');
  }

  // =========================================================
  // PROVIDER PROFILE  (للمزود فقط - يحتاج تسجيل دخول)
  // =========================================================

  /// يرجع البيانات بنفس الشكل اللي بتستخدمه الشاشات (عربي + نصوص للأسعار)
  static Future<Map<String, dynamic>> getMyProviderProfile() async {
    final d = _asMap(await _request('GET', '/provider/profile', auth: true));

    return {
      'providerName': d['fullName'] ?? '',
      'providerPhone': d['phone'] ?? '',
      'providerEmail': d['email'] ?? '',
      'businessName': d['serviceName'] ?? '',
      'serviceType': serviceLabel('${d['serviceType'] ?? ''}'),
      'location': locationLabel('${d['location'] ?? ''}'),
      'address': d['address'] ?? '',
      'description': d['description'] ?? '',
      'licensedOperatorNumber': d['licenseNumber'] ?? '',
      'halls': hallsFromApi(d['halls'] as List? ?? []),
    };
  }

  static Future<void> saveProviderProfile({
    required String providerName,
    required String providerPhone,
    required String businessName,
    required String serviceType, // عربي
    required String location, // عربي
    required String address,
    required String description,
    required String licenseNumber,
    required List<Map<String, dynamic>> halls,
  }) async {
    await _request(
      'PUT',
      '/provider/profile',
      auth: true,
      body: {
        'fullName': providerName,
        'phone': providerPhone,
        'serviceName': businessName,
        'serviceType': serviceCodes[serviceType] ?? serviceType,
        'location': locationCodes[location] ?? location,
        'address': address,
        'description': description,
        'licenseNumber': licenseNumber,
        'halls': hallsToApi(halls),
      },
    );
  }

  // =========================================================
  // PUBLIC SERVICES  (للمستخدم - عرض المزودين)
  // =========================================================

  static Future<List<Map<String, dynamic>>> getServices({
    required String serviceType, // عربي
    String? location, // عربي
  }) async {
    final query = <String, String>{
      'type': serviceCodes[serviceType] ?? serviceType,
      if (location != null) 'location': locationCodes[location] ?? location,
    };
    final qs = Uri(queryParameters: query).query;

    final data = await _request('GET', '/services?$qs');
    return (data as List? ?? [])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  static Future<Map<String, dynamic>> getServiceDetails(int id) async {
    return _asMap(await _request('GET', '/services/$id'));
  }

  // =========================================================
  // HALLS  (تحويل بين شكل الشاشة وشكل الباك إند)
  // =========================================================

  static String _priceText(dynamic v) {
    if (v == null) return '';
    if (v is num) {
      return v == v.roundToDouble() ? v.toInt().toString() : v.toString();
    }
    return v.toString();
  }

  static num _priceNum(dynamic v) => num.tryParse('${v ?? ''}'.trim()) ?? 0;

  static List<Map<String, dynamic>> _pricesToApi(dynamic list) {
    return (list as List? ?? [])
        .whereType<Map>()
        .map(
          (p) => <String, dynamic>{
            'peopleRange': '${p['peopleRange'] ?? ''}',
            'price': _priceNum(p['price']),
          },
        )
        .toList();
  }

  static List<Map<String, dynamic>> _pricesFromApi(dynamic list) {
    return (list as List? ?? [])
        .whereType<Map>()
        .map(
          (p) => <String, dynamic>{
            'peopleRange': '${p['peopleRange'] ?? ''}',
            'price': _priceText(p['price']),
          },
        )
        .toList();
  }

  static List<Map<String, dynamic>> hallsToApi(
    List<Map<String, dynamic>> halls,
  ) {
    return halls.map((h) {
      return <String, dynamic>{
        'name': '${h['name'] ?? ''}',
        'pricing': _pricesToApi(h['pricing']),
        'includedItems': (h['includedItems'] as List? ?? [])
            .map((e) => '$e')
            .toList(),
        'services':
            (h['services'] as List? ?? []).map((e) => '$e').toList(),
        'occasions': (h['occasions'] as List? ?? []).map((o) {
          if (o is Map) {
            return <String, dynamic>{
              'name': '${o['name'] ?? ''}',
              'price': _priceNum(o['price']),
            };
          }
          return <String, dynamic>{'name': '$o', 'price': 0};
        }).toList(),
        'hospitality': (h['hospitality'] as List? ?? [])
            .whereType<Map>()
            .map(
              (x) => <String, dynamic>{
                'name': '${x['name'] ?? ''}',
                'pricing': _pricesToApi(x['pricing']),
              },
            )
            .toList(),
      };
    }).toList();
  }

  static List<Map<String, dynamic>> hallsFromApi(List raw) {
    return raw.whereType<Map>().map((h) {
      return <String, dynamic>{
        'name': '${h['name'] ?? ''}',
        'pricing': _pricesFromApi(h['pricing']),
        'includedItems': List<String>.from(
          (h['includedItems'] as List? ?? []).map((e) => '$e'),
        ),
        'services': List<String>.from(
          (h['services'] as List? ?? []).map((e) => '$e'),
        ),
        'occasions': (h['occasions'] as List? ?? [])
            .whereType<Map>()
            .map(
              (o) => <String, dynamic>{
                'name': '${o['name'] ?? ''}',
                'price': _priceText(o['price']),
              },
            )
            .toList(),
        'hospitality': (h['hospitality'] as List? ?? [])
            .whereType<Map>()
            .map(
              (x) => <String, dynamic>{
                'name': '${x['name'] ?? ''}',
                'pricing': _pricesFromApi(x['pricing']),
              },
            )
            .toList(),
      };
    }).toList();
  }

  // =========================================================
  // LOW LEVEL
  // =========================================================

  static Map<String, dynamic> _asMap(dynamic v) {
    if (v is Map) return Map<String, dynamic>.from(v);
    return {};
  }

  static Future<dynamic> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (auth) {
      final token = await getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }

    final uri = Uri.parse('$baseUrl$path');
    final encoded = body == null ? null : jsonEncode(body);

    late final http.Response res;
    switch (method) {
      case 'GET':
        res = await http.get(uri, headers: headers);
        break;
      case 'PUT':
        res = await http.put(uri, headers: headers, body: encoded);
        break;
      default:
        res = await http.post(uri, headers: headers, body: encoded);
    }

    final rawBody = utf8.decode(res.bodyBytes).trim();
    debugPrint('API ${res.statusCode} $method $path => $rawBody');

    dynamic decoded;
    try {
      decoded = rawBody.isEmpty ? null : jsonDecode(rawBody);
    } catch (_) {}

    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (decoded is Map<String, dynamic>) {
        final token = decoded['token'];
        if (token is String) {
          await _storage.write(key: 'token', value: token);
        }
        final role = decoded['role'];
        if (role is String) {
          await _storage.write(key: 'role', value: role);
        }
      }
      return decoded;
    }

    if (res.statusCode == 401 && auth) {
      throw ApiException('انتهت الجلسة، سجّلي الدخول من جديد', 401);
    }
    if (res.statusCode == 403) {
      throw ApiException('ليس لديك صلاحية لهذه العملية', 403);
    }

    String message = 'حدث خطأ في السيرفر (${res.statusCode})';
    if (decoded is Map) {
      if (decoded['message'] is String) {
        message = decoded['message'];
      } else if (decoded['errors'] is Map &&
          (decoded['errors'] as Map).isNotEmpty) {
        final first = (decoded['errors'] as Map).values.first;
        message =
            first is List && first.isNotEmpty ? '${first.first}' : '$first';
      }
    } else if (decoded == null && rawBody.isNotEmpty) {
      message = rawBody; // رد نصي عادي من الباك
    }

    throw ApiException(message, res.statusCode);
  }
}