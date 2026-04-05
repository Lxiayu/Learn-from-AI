class ApiTransportResponse {
  const ApiTransportResponse({
    required this.statusCode,
    required this.body,
  });

  final int statusCode;
  final String body;
}

abstract class ApiTransport {
  Future<ApiTransportResponse> get(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
  });

  Future<ApiTransportResponse> post(
    Uri uri, {
    Map<String, String> headers = const <String, String>{},
    String? body,
  });
}
