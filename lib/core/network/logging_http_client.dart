import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LoggingHttpClient extends http.BaseClient {
  final http.Client _inner;

  LoggingHttpClient([http.Client? inner]) : _inner = inner ?? http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final startTime = DateTime.now();
    final requestId = startTime.millisecondsSinceEpoch.toString().substring(8);
    
    // Log Request
    debugPrint('--> [REQ-$requestId] ${request.method} ${request.url}');
    if (request.headers.isNotEmpty) {
      debugPrint('Headers: ${request.headers}');
    }
    
    if (request is http.Request && request.body.isNotEmpty) {
      debugPrint('Body: ${request.body}');
    } else if (request.contentLength != null && request.contentLength! > 0) {
      debugPrint('Body Size: ${request.contentLength} bytes');
    }

    try {
      final response = await _inner.send(request);
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      debugPrint('<-- [RES-$requestId] ${response.statusCode} (${duration}ms) ${request.method} ${request.url}');
      
      final bytes = await response.stream.toBytes();
      final bodyString = utf8.decode(bytes, allowMalformed: true);
      
      if (bodyString.isNotEmpty) {
        debugPrint('Response Body: $bodyString');
      }

      // Re-create the StreamedResponse so it can be read by Supabase
      return http.StreamedResponse(
        Stream.value(bytes),
        response.statusCode,
        contentLength: bytes.length,
        request: request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    } catch (e, stack) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('<-- [ERR-$requestId] (${duration}ms) Exception: $e');
      debugPrint('StackTrace: $stack');
      rethrow;
    }
  }
}
