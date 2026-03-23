import 'package:http/http.dart' as http;
import 'package:resilient_client_api/resilient_client_api.dart';

class IResilientClientImpl implements ResilientClassInterface {
  final http.Client _client;

  @override
  final ResilientOptionsModel options;

  IResilientClientImpl(
    this._client, {
    this.options = const ResilientOptionsModel(),
  });

  @override
  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    return _sendWithRetry(() => _client.get(Uri.parse(url), headers: headers));
  }

  @override
  Future<T> getTyped<T>(
    String url, {
    required T Function(String) decoder,
    Map<String, String>? headers,
  }) async {
    final response = await get(url, headers: headers);
    return decoder(response.body);
  }

  @override
  Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return _sendWithRetry(() => _client.post(Uri.parse(url), headers: headers));
  }

  Future<http.Response> _sendWithRetry(
    Future<http.Response> Function() action,
  ) async {
    int tentativas = 0;

    while (tentativas < options.maxRetries) {
      try {
        tentativas++;
        final response = await action().timeout(options.timeout);
        if (response.statusCode < 400) return response;

        throw ResilientStatusException(
          'Erro ${response.statusCode}',
          response.statusCode,
          responsyBody: response.body,
        );
      } catch (e) {
        if (tentativas >= options.maxRetries) {
          if (e is ResilientStatusException) rethrow;
          throw RetryLimitExceededException('Limite de Retrys atingido');
        }
        await Future.delayed(options.retryDelay);
      }
    }
    throw ResilientException('Falha inesperada no fluxo de repetição');
  }
}
