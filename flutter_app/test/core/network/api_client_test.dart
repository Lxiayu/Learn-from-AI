import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/src/core/network/api_client.dart';

void main() {
  test('api client decodes a successful JSON response', () async {
    final client = ApiClient(
      baseUrl: 'http://localhost:8000/api/v1',
      transport: _FakeTransport(
        responses: <String, ApiTransportResponse>{
          'GET http://localhost:8000/api/v1/health': ApiTransportResponse(
            statusCode: 200,
            body: jsonEncode(<String, String>{'status': 'ok'}),
          ),
        },
      ),
    );

    final response = await client.getJson('/health');

    expect(response['status'], 'ok');
  });

  test('api client throws ApiException for non-success status', () async {
    final client = ApiClient(
      baseUrl: 'http://localhost:8000/api/v1',
      transport: _FakeTransport(
        responses: <String, ApiTransportResponse>{
          'GET http://localhost:8000/api/v1/roadmaps/current':
              const ApiTransportResponse(
                statusCode: 404,
                body: '{"detail":"active_roadmap_not_found"}',
              ),
        },
      ),
    );

    expect(
      () => client.getJson('/roadmaps/current'),
      throwsA(
        isA<ApiException>().having(
          (ApiException error) => error.statusCode,
          'statusCode',
          404,
        ),
      ),
    );
  });
}

class _FakeTransport implements ApiTransport {
  _FakeTransport({required this.responses});

  final Map<String, ApiTransportResponse> responses;

  @override
  Future<ApiTransportResponse> get(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
  }) async {
    return responses['GET ${uri.toString()}']!;
  }

  @override
  Future<ApiTransportResponse> post(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? body,
  }) async {
    return responses['POST ${uri.toString()}']!;
  }
}
