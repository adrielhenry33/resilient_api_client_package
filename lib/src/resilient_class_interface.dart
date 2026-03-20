/// O contrato(interface) que define como a classe ira se comportar
///
/// Seguindo o padrão do SOLID dependemos de abstrações não de implmentações.

library;

import 'package:http/http.dart';

import 'models/resilient_options_model.dart';

abstract class ResilientClassInterface {
  ResilientOptionsModel get options;

  /// Realiza uma requisição GET resilitente bruta de baixo nivlle
  Future<Response> get(String url, {Map<String, String>? headers});

  ///Metodo de alto nivel: ja retorna o objeto [T] convertido.
  ///[decoder] é uma função que transforma a String jso  no seu modelo

  Future<T> getTyped<T>(
    String url, {
    required T Function(String) decoder,
    Map<String, String>? headers,
  });

  /// realiza uma requisição POST  resiliente
  Future<Response> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  });

}
