import 'package:meta/meta.dart';

@immutable
class ResilientOptionsModel {
  final Duration timeout;
  final int maxRetries;
  final Duration retryDelay;

  const ResilientOptionsModel({
    this.timeout = const Duration(seconds: 30),
    this.maxRetries = 3,
    this.retryDelay = const Duration(microseconds: 500),
  });
}
