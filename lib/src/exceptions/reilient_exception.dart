/// Classe base abstrata para todas as exceções do [ResilientApiClient]
///
/// Ao herdar de [Exception], garantimos que o erro possa ser capturado
///em blocos try-catch espcíficos.

library;

abstract class ResilientException implements Exception {
  final String message;

  final int? statusCode;

  ResilientException(this.message, [this.statusCode]);

  @override
  String toString() => '$runtimeType: $message (Status: $statusCode)';
}

/// Lançada quando o número máximo de tentativas (retries) é esgotado.
class RetryLimitExceededException extends ResilientException {
  RetryLimitExceededException(super.message, [super.statusCode]);
}

/// Lançada quando o servidor retorna um erro de status (ex.: 4xx , 5xx)
class ResilientStatusException extends ResilientException {
  final String? responsyBody;

  ResilientStatusException(super.message,super.statusCode, {this.responsyBody});
    
}
