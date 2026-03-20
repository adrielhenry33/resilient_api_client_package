import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:resilient_client_api/src/models/resilient_options_model.dart';
import 'package:resilient_client_api/src/resilient_client_impl.dart';
import 'package:test/test.dart';

class UserModel {
  final String name;

  UserModel(this.name);
}

void main() {
  group('IResilientClientImpl - Suíte de testes ', () {
    group('Métodos Brutos (http.response) ', () {
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
      group('Métodos tipados (Generics)', () {
        test('Deve converter JSON para UserModel com sucesso', () async {
          final jsonMockado = jsonEncode({'name': 'Adriel Henry'});

          final mockClient = MockClient((request) async {
            return http.Response(jsonMockado, 200);
          });

          final client = IResilientClientImpl(
            mockClient,
            options: const ResilientOptionsModel(maxRetries: 1),
          );

          final userRetornado = await client.getTyped<UserModel>(
            'https://teste.com',
            decoder: (bodyBruto) {
              final mapa = jsonDecode(bodyBruto);
              return UserModel(mapa['name']);
            },
          );

          expect(userRetornado, isA<UserModel>());
          expect(userRetornado.name, 'Adriel Henry');
        });
      });
    });
  });
}
