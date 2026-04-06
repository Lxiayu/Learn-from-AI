// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:html' as html;

import 'api_transport_base.dart';

ApiTransport createApiTransport() => _WebApiTransport();

class _WebApiTransport implements ApiTransport {
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
    final request = html.HttpRequest();
    final completer = Completer<ApiTransportResponse>();

    request
      ..open(method, uri.toString(), async: true)
      ..responseType = 'text';

    headers.forEach(request.setRequestHeader);

    request.onLoadEnd.first.then((_) {
      if (!completer.isCompleted) {
        completer.complete(
          ApiTransportResponse(
            statusCode: request.status ?? 0,
            body: request.responseText ?? '',
          ),
        );
      }
    });

    request.onError.first.then((_) {
      if (!completer.isCompleted) {
        completer.complete(
          ApiTransportResponse(
            statusCode: request.status ?? 0,
            body: request.responseText ?? '',
          ),
        );
      }
    });

    request.send(body);
    return completer.future;
  }
}
