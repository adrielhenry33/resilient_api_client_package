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
    int tentativas = 0;
    final Map<String, String> activeHeaders = headers ?? {};

    while (tentativas < options.maxRetries) {
      try {
        tentativas++;

        final result = await _client
            .get(Uri.parse(url), headers: activeHeaders)
            .timeout(options.timeout);

        if (result.statusCode < 400) return result;

        throw ResilientStatusException(
          'Erro de statuss: ${result.statusCode}',
          result.statusCode,
          responsyBody: result.body,
        );
      } catch (e) {
        if (tentativas >= options.maxRetries) {
          if (e is ResilientStatusException) rethrow;
          throw RetryLimitExceededException(
            'Falha após $tentativas. Último erro: $e',
          );
        }
        await Future.delayed(options.retryDelay);
      }
    }
    throw ResilientException('Falha inesperada no fluxo de repetição');
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
    // TODO: implement post
    throw UnimplementedError();
  }

  Future<http.Response> _sendWithRetry(
    Future<http.Response> Function() action,
  ) async {
    
  }
}
