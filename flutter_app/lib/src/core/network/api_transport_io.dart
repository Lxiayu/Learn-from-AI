import 'dart:convert';
import 'dart:io';

import 'api_transport_base.dart';

ApiTransport createApiTransport() => _IoApiTransport();

class _IoApiTransport implements ApiTransport {
  @override
  Future<ApiTransportResponse> get(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
  }) {
    return _send('GET', uri, headers: headers);
  }

  @override
  Future<ApiTransportResponse> post(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? body,
  }) {
    return _send('POST', uri, headers: headers, body: body);
  }

  Future<ApiTransportResponse> _send(
    String method,
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? body,
  }) async {
    final client = HttpClient();

    try {
      final request = await client.openUrl(method, uri);
      headers.forEach(request.headers.set);

      if (body != null) {
        request.write(body);
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      return ApiTransportResponse(
        statusCode: response.statusCode,
        body: responseBody,
      );
    } finally {
      client.close(force: true);
    }
  }
}
