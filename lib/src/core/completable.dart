import 'dart:async';

mixin Completable {
  final _completer = Completer<void>();

  Future<void> get completed => _completer.future;

  void complete() => _completer.complete();

  void completeError(Object error, StackTrace stackTrace) =>
      _completer.completeError(error, stackTrace);
}
