import 'dart:io';

import 'models/resilient_options_model.dart';
import 'package:http/http.dart';

/// O contrato(interface) que define como a classe ira se comportar
/// 
/// Seguindo o padrão do SOLID dependemos de abstrações não de implmentações.

library;

abstract class ResilientClassInterface {
  ResilientOptionsModel get options;

  /// Realiza uma requisição GET resilitente bruta de baixo nivlle 
  Future<Response> get(String url,{Map<String, dynamic> headers});


  ///Metodo de alto nivel: ja retorna o objeto [T] convertido.
  ///[decoder] é uma função que transforma a String jso  no seu modelo
  
  Future<Response> getTyped<T>(String url, {required T Function(String) decoder, Map<String,dynamic>? headers});

  /// realiza uma requisição POST  resiliente
  Future<Response> post(String url,{Map<String, dynamic> data, Object? body} );




}

