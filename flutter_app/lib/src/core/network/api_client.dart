import 'dart:convert';

import 'api_transport.dart';

export 'api_transport_base.dart';

class ApiException implements Exception {
  const ApiException({
    required this.statusCode,
    required this.message,
  });

  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  ApiClient({
    required this.baseUrl,
    ApiTransport? transport,
  }) : transport = transport ?? createDefaultApiTransport();

  final String baseUrl;
  final ApiTransport transport;

  Future<Map<String, dynamic>> getJson(String path) async {
    final response = await transport.get(
      _resolve(path),
      headers: _jsonHeaders,
    );
    return _decodeMap(response);
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final response = await transport.post(
      _resolve(path),
      headers: _jsonHeaders,
      body: body == null ? null : jsonEncode(body),
    );
    return _decodeMap(response);
  }

  Uri _resolve(String path) {
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    final normalizedBase = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    return Uri.parse('$normalizedBase$normalizedPath');
  }

  Map<String, dynamic> _decodeMap(ApiTransportResponse response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        statusCode: response.statusCode,
        message: _extractErrorMessage(response.body),
      );
    }

    final dynamic decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Expected JSON object response',
      );
    }
    return decoded;
  }

  String _extractErrorMessage(String body) {
    if (body.isEmpty) {
      return 'empty_response';
    }

    try {
      final dynamic decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final detail = decoded['detail'];
        if (detail is String && detail.isNotEmpty) {
          return detail;
        }
      }
    } catch (_) {
      return body;
    }

    return body;
  }

  static const Map<String, String> _jsonHeaders = <String, String>{
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
