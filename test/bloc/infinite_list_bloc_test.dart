// ignore_for_file: unnecessary_lambdas

import 'dart:async';

import 'package:bloc_infinite_list/bloc_infinite_list.dart';
import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';

import '../helpers/custom_event.dart';
import '../helpers/custom_state.dart';

Future<Slice<int>> _fetch<State>(
  int page,
  int limit,
  State state, [
  dynamic cancelToken,
]) async {
  await Future.delayed(const Duration(seconds: 1));
  return Slice(
    List.generate(limit, (index) => page * limit + index),
    false,
  );
}

class CustomInfiniteListBloc
    extends InfiniteListBloc<int, CustomEvent, CustomState> {
  CustomInfiniteListBloc()
      : super(
          fetch: _fetch<CustomState>,
          initialState: CustomState(
            infList: const InfiniteList(),
            value: '0',
          ),
        );
}

void main() {
  late CustomInfiniteListBloc bloc;

  CustomInfiniteListBloc setBloc() =>
      bloc = CustomInfiniteListBloc()..registerLimit(5);

  setUp(setBloc);

  CustomState incrementBatch(CustomState state) =>
      state.copyWith(value: (int.parse(state.value) + 1).toString());

  group('add', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      unawaited(bloc.triggerAdd(1, batch: incrementBatch));

      expect(bloc.state.items, <int>[]);
      await Future.microtask(() => null);

      expect(bloc.state.items, [1]);
      expect(bloc.state.value, '1');
    });

    test('can be awaited', () async {
      await bloc.triggerAdd(1, batch: incrementBatch);
      expect(bloc.state.items, [1]);
      expect(bloc.state.value, '1');
    });
  });

  group('addAll', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      unawaited(bloc.triggerAddAll([1, 2, 3], batch: incrementBatch));
      expect(bloc.state.items, <int>[]);
      await Future.microtask(() => null);
      expect(bloc.state.items, [1, 2, 3]);
      expect(bloc.state.value, '1');
    });

    test('can be awaited', () async {
      await bloc.triggerAddAll([1, 2, 3], batch: incrementBatch);
      expect(bloc.state.items, [1, 2, 3]);
      expect(bloc.state.value, '1');
    });
  });

  group('replace', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      await bloc.triggerAddAll([1, 2, 3]);

      unawaited(bloc.triggerReplace(2, 4, batch: incrementBatch));
      expect(bloc.state.items, [1, 2, 3]);
      await Future.microtask(() => null);
      expect(bloc.state.items, [1, 4, 3]);
      expect(bloc.state.value, '1');
    });

    test('can be awaited', () async {
      await bloc.triggerAddAll([1, 2, 3]);
      await bloc.triggerReplace(2, 4, batch: incrementBatch);
      expect(bloc.state.items, [1, 4, 3]);
      expect(bloc.state.value, '1');
    });
  });

  group('replaceAt', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      await bloc.triggerAddAll([1, 2, 3]);

      unawaited(bloc.triggerReplaceAt(2, 4, batch: incrementBatch));
      expect(bloc.state.items, [1, 2, 3]);
      await Future.microtask(() => null);
      expect(bloc.state.items, [1, 2, 4]);
    });

    test('can be awaited', () async {
      await bloc.triggerAddAll([1, 2, 3]);
      await bloc.triggerReplaceAt(2, 4, batch: incrementBatch);
      expect(bloc.state.items, [1, 2, 4]);
      expect(bloc.state.value, '1');
    });
  });

  group('replaceWhere', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      await bloc.triggerAddAll([1, 2, 3]);

      unawaited(
        bloc.triggerReplaceWhere(
          (item) => item == 1,
          (element) => 4,
          batch: incrementBatch,
        ),
      );
      expect(bloc.state.items, [1, 2, 3]);
      await Future.microtask(() => null);
      expect(bloc.state.items, [4, 2, 3]);
      expect(bloc.state.value, '1');
    });

    test('can be awaited', () async {
      await bloc.triggerAddAll([1, 2, 3]);

      await bloc.triggerReplaceWhere(
        (item) => item == 1,
        (element) => 4,
        batch: incrementBatch,
      );
      expect(bloc.state.items, [4, 2, 3]);
      expect(bloc.state.value, '1');
    });
  });

  group('insert', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      bloc.emit(CustomState.list([1, 2, 3]));

      unawaited(bloc.triggerInsert(1, 4, batch: incrementBatch));
      expect(bloc.state.items, [1, 2, 3]);
      await Future.microtask(() => null);
      expect(bloc.state.items, [1, 4, 2, 3]);
      expect(bloc.state.value, '1');
    });

    test('can be awaited', () async {
      bloc.emit(CustomState.list([1, 2, 3]));

      await bloc.triggerInsert(1, 4, batch: incrementBatch);
      expect(bloc.state.items, [1, 4, 2, 3]);
      expect(bloc.state.value, '1');
    });
  });

  group('remove', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      bloc.emit(CustomState.list([1, 2, 3]));

      unawaited(bloc.triggerRemove(1, batch: incrementBatch));
      expect(bloc.state.items, [1, 2, 3]);
      await Future.microtask(() => null);
      expect(bloc.state.items, [2, 3]);
      expect(bloc.state.value, '1');
    });

    test('can be awaited', () async {
      bloc.emit(CustomState.list([1, 2, 3]));

      await bloc.triggerRemove(1, batch: incrementBatch);
      expect(bloc.state.items, [2, 3]);
      expect(bloc.state.value, '1');
    });
  });

  group('removeAt', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      bloc.emit(CustomState.list([1, 2, 3]));
      unawaited(bloc.triggerRemoveAt(1, batch: incrementBatch));

      expect(bloc.state.items, [1, 2, 3]);
      await Future.microtask(() => null);

      expect(bloc.state.items, [1, 3]);
      expect(bloc.state.value, '1');
    });

    test('can be awaited', () async {
      bloc.emit(CustomState.list([1, 2, 3]));

      await bloc.triggerRemoveAt(1, batch: incrementBatch);
      expect(bloc.state.items, [1, 3]);
      expect(bloc.state.value, '1');
    });
  });

  group('fetchNext', () {
    test('needs waiting for microtask to ensure ops to be completed', () {
      fakeAsync((async) {
        // Bloc should be set within the fakeAsync bloc because
        // FakeAsync is internally uses a zone and it affects only in the callback closure but not in [setup]
        bloc = setBloc()..triggerFetchNext(batch: incrementBatch);
        expect(bloc.state.items, <int>[]);
        async.elapse(const Duration(seconds: 5));

        expect(bloc.state.items, [0, 1, 2, 3, 4]);
        expect(bloc.state.value, '1');
      });
    });

    test('can be awaited', () async {
      await bloc.triggerFetchNext(batch: incrementBatch);
      expect(bloc.state.items, [0, 1, 2, 3, 4]);
      expect(bloc.state.value, '1');
    });
  });

  group('reset', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      bloc.emit(CustomState.list([1, 2, 3]));
      unawaited(bloc.triggerReset(batch: incrementBatch));
      expect(bloc.state.items, [1, 2, 3]);
      await Future.microtask(() => null);
      expect(bloc.state.items, <int>[]);
      expect(bloc.state.value, '1');
    });

    test('can be awaited', () async {
      bloc.emit(CustomState.list([1, 2, 3]));

      await bloc.triggerReset(batch: incrementBatch);
      expect(bloc.state.items, <int>[]);
      expect(bloc.state.value, '1');
    });
  });

  group('reinitialize', () {
    test('needs waiting for microtask to ensure ops to be completed', () {
      fakeAsync((async) {
        bloc = setBloc()..emit(CustomState.list([5, 6, 7]));
        async.flushMicrotasks();

        bloc.triggerReinitialize(batch: incrementBatch);
        expect(bloc.state.items, [5, 6, 7]);

        async.elapse(const Duration(seconds: 5));
        expect(bloc.state.items, [0, 1, 2, 3, 4]);
        expect(bloc.state.value, '1');
      });
    });

    test('can be awaited', () async {
      bloc.emit(CustomState.list([5, 6, 7]));

      await bloc.triggerReinitialize(batch: incrementBatch);
      expect(bloc.state.items, [0, 1, 2, 3, 4]);
      expect(bloc.state.value, '1');
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
