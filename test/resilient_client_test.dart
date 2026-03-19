import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:resilient_client_api/src/models/resilient_options_model.dart';
import 'package:resilient_client_api/src/resilient_client_impl.dart';
import 'package:test/test.dart';

void main() {
  test('Deve tentar 3 vezes e retornar sucesso na ultima ', () async {
    int chamadas = 0;

    final mockclient = MockClient((request) async {
      chamadas++;

      if (chamadas < 3) {
        return http.Response('Erro', 500);
      }
      return http.Response('sucesso', 200);
    });

    var client = IResilientClientImpl(
      mockclient,
      options: const ResilientOptionsModel(
        maxRetries: 3,
        retryDelay: Duration(milliseconds: 300),
      ),
    );

    final response = await client.get('https//teste.com');

    expect(response.statusCode, 200);
    expect(chamadas, 3);
  });
}
