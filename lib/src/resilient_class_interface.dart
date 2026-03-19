import 'models/resilient_options_model.dart';
import 'resilient_client_api_base.dart';


/// O contrato(interface) que define como a classe ira se comportar
/// 
/// Seguindo o padrão do SOLID dependemos de abstrações não de implmentações.

library;

abstract class ResilientClassInterface {
  ResilientOptionsModel get options;

  /// Realiza uma requisição GET resilitente
  Future<dynamic> get(String url, {Map<String, dynamic> headers});

  /// realiza uma requisição POST  resiliente
  Future<dynamic> post(String url,{Map<String, dynamic> data, Object? body} );




}

