// ignore_for_file: unnecessary_lambdas

import 'dart:async';

import 'package:bloc_infinite_list/bloc_infinite_list.dart';
import 'package:dio/dio.dart';
import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';

Future<Slice<int>> _fetch(
  int page,
  int limit,
  CancelToken? cancelToken,
  DefaultInfiniteListState<int> state,
) async {
  await Future.delayed(const Duration(seconds: 1));
  return Slice(
    List.generate(limit, (index) => page * limit + index),
    false,
  );
}

class MyInfiniteListBloc extends DefaultInfiniteListBloc<int> {
  MyInfiniteListBloc()
      : super(
          fetch: _fetch,
          initialState: DefaultInfiniteListState(),
        );
}

void main() {
  late MyInfiniteListBloc bloc;

  MyInfiniteListBloc setBloc() => bloc = MyInfiniteListBloc()..registerLimit(5);

  setUp(setBloc);

  group('add', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      unawaited(bloc.triggerAdd(1));
      expect(bloc.state.items, []);
      await Future.microtask(() => null);
      expect(bloc.state.items, [1]);
    });

    test('can be awaited', () async {
      await bloc.triggerAdd(1);
      expect(bloc.state.items, [1]);
    });
  });

  group('addAll', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      unawaited(bloc.triggerAddAll([1, 2, 3]));
      expect(bloc.state.items, []);
      await Future.microtask(() => null);
      expect(bloc.state.items, [1, 2, 3]);
    });

    test('can be awaited', () async {
      await bloc.triggerAddAll([1, 2, 3]);
      expect(bloc.state.items, [1, 2, 3]);
    });
  });

  group('replace', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      await bloc.triggerAddAll([1, 2, 3]);

      unawaited(bloc.triggerReplace(2, 4));
      expect(bloc.state.items, [1, 2, 3]);
      await Future.microtask(() => null);
      expect(bloc.state.items, [1, 4, 3]);
    });

    test('can be awaited', () async {
      await bloc.triggerAddAll([1, 2, 3]);
      await bloc.triggerReplace(2, 4);
      expect(bloc.state.items, [1, 4, 3]);
    });
  });

  group('replaceAt', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      await bloc.triggerAddAll([1, 2, 3]);

      unawaited(bloc.triggerReplaceAt(2, 4));
      expect(bloc.state.items, [1, 2, 3]);
      await Future.microtask(() => null);
      expect(bloc.state.items, [1, 2, 4]);
    });

    test('can be awaited', () async {
      await bloc.triggerAddAll([1, 2, 3]);
      await bloc.triggerReplaceAt(2, 4);
      expect(bloc.state.items, [1, 2, 4]);
    });
  });

  group('replaceWhere', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      await bloc.triggerAddAll([1, 2, 3]);

      unawaited(bloc.triggerReplaceWhere((item) => item == 1, (element) => 4));
      expect(bloc.state.items, [1, 2, 3]);
      await Future.microtask(() => null);
      expect(bloc.state.items, [4, 2, 3]);
    });

    test('can be awaited', () async {
      await bloc.triggerAddAll([1, 2, 3]);

      await bloc.triggerReplaceWhere((item) => item == 1, (element) => 4);
      expect(bloc.state.items, [4, 2, 3]);
    });
  });

  group('insert', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      await bloc.triggerAddAll([1, 2, 3]);

      unawaited(bloc.triggerInsert(1, 4));
      expect(bloc.state.items, [1, 2, 3]);
      await Future.microtask(() => null);
      expect(bloc.state.items, [1, 4, 2, 3]);
    });

    test('can be awaited', () async {
      await bloc.triggerAddAll([1, 2, 3]);

      await bloc.triggerInsert(1, 4);
      expect(bloc.state.items, [1, 4, 2, 3]);
    });
  });

  group('remove', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      await bloc.triggerAddAll([1, 2, 3]);

      unawaited(bloc.triggerRemove(1));
      expect(bloc.state.items, [1, 2, 3]);
      await Future.microtask(() => null);
      expect(bloc.state.items, [2, 3]);
    });

    test('can be awaited', () async {
      await bloc.triggerAddAll([1, 2, 3]);

      await bloc.triggerRemove(1);
      expect(bloc.state.items, [2, 3]);
    });
  });

  group('removeAt', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      await bloc.triggerAddAll([1, 2, 3]);

      unawaited(bloc.triggerRemoveAt(1));
      expect(bloc.state.items, [1, 2, 3]);
      await Future.microtask(() => null);
      expect(bloc.state.items, [1, 3]);
    });

    test('can be awaited', () async {
      await bloc.triggerAddAll([1, 2, 3]);

      await bloc.triggerRemoveAt(1);
      expect(bloc.state.items, [1, 3]);
    });
  });

  group('fetchNext', () {
    test('needs waiting for microtask to ensure ops to be completed', () {
      fakeAsync((async) {
        // Bloc should be set within the fakeAsync bloc because
        // FakeAsync is internally uses a zone and it affects only in the callback closure but not in [setup]
        bloc = setBloc()..triggerFetchNext();
        expect(bloc.state.items, []);
        async.elapse(const Duration(seconds: 5));

        expect(bloc.state.items, [0, 1, 2, 3, 4]);
      });
    });

    test('can be awaited', () async {
      await bloc.triggerFetchNext();
      expect(bloc.state.items, [0, 1, 2, 3, 4]);
    });
  });

  group('reset', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      await bloc.triggerAddAll([1, 2, 3]);
      unawaited(bloc.triggerReset());
      expect(bloc.state.items, [1, 2, 3]);
      await Future.microtask(() => null);
      expect(bloc.state.items, []);
    });

    test('can be awaited', () async {
      await bloc.triggerAddAll([1, 2, 3]);

      await bloc.triggerReset();
      expect(bloc.state.items, []);
    });
  });

  group('reinitialize', () {
    test('needs waiting for microtask to ensure ops to be completed', () {
      fakeAsync((async) {
        bloc = setBloc()..triggerAddAll([5, 6, 7]);
        async.flushMicrotasks();

        bloc.triggerReinitialize();
        expect(bloc.state.items, [5, 6, 7]);

        async.elapse(const Duration(seconds: 5));
        expect(bloc.state.items, [0, 1, 2, 3, 4]);
      });
    });

    test('can be awaited', () async {
      await bloc.triggerAddAll([5, 6, 7]);

      await bloc.triggerReinitialize();
      expect(bloc.state.items, [0, 1, 2, 3, 4]);
    });
  });

  test('Any method cannot be used with', () {
    final bloc = setBloc();
    expect(() => bloc.addItem(1), throwsA(isA<AssertionError>()));
    expect(() => bloc.addItems([1]), throwsA(isA<AssertionError>()));
    expect(() => bloc.replace(1, 2), throwsA(isA<AssertionError>()));
    expect(() => bloc.replaceAt(1, 2), throwsA(isA<AssertionError>()));
    expect(
      () => bloc.replaceWhere((p0) => true, (element) => element),
      throwsA(isA<AssertionError>()),
    );
    expect(() => bloc.insert(1, 2), throwsA(isA<AssertionError>()));
    expect(() => bloc.remove(1), throwsA(isA<AssertionError>()));
    expect(() => bloc.removeAt(1), throwsA(isA<AssertionError>()));
    expect(() => bloc.fetchNext(), throwsA(isA<AssertionError>()));
    expect(() => bloc.reinitialize(), throwsA(isA<AssertionError>()));
  });
}
