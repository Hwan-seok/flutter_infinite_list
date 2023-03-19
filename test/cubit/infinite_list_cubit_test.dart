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

class MyInfiniteListBloc extends DefaultInfiniteListCubit<int> {
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
      bloc.addItem(1);
      expect(bloc.state.items, [1]);
    });
  });

  group('addAll', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      bloc.addItems([1, 2, 3]);
      expect(bloc.state.items, [1, 2, 3]);
    });
  });

  group('replace', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      bloc
        ..addItems([1, 2, 3])
        ..replace(2, 4);
      expect(bloc.state.items, [1, 4, 3]);
    });
  });

  group('replaceAt', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      bloc
        ..addItems([1, 2, 3])
        ..replaceAt(2, 4);
      expect(bloc.state.items, [1, 2, 4]);
    });
  });

  group('replaceWhere', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      bloc
        ..addItems([1, 2, 3])
        ..replaceWhere((item) => item == 1, (element) => 4);
      expect(bloc.state.items, [4, 2, 3]);
    });
  });

  group('insert', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      bloc
        ..addItems([1, 2, 3])
        ..insert(1, 4);
      expect(bloc.state.items, [1, 4, 2, 3]);
    });
  });

  group('remove', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      bloc
        ..addItems([1, 2, 3])
        ..remove(1);
      expect(bloc.state.items, [2, 3]);
    });
  });

  group('removeAt', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      bloc
        ..addItems([1, 2, 3])
        ..removeAt(1);
      expect(bloc.state.items, [1, 3]);
    });
  });

  group('fetchNext', () {
    test('needs waiting for microtask to ensure ops to be completed', () {
      fakeAsync((async) {
        // Bloc should be set within the fakeAsync bloc because
        // FakeAsync is internally uses a zone and it affects only in the callback closure but not in [setup]
        bloc = setBloc()..fetchNext();
        expect(bloc.state.items, []);
        async.elapse(const Duration(seconds: 5));

        expect(bloc.state.items, [0, 1, 2, 3, 4]);
      });
    });

    test('can be awaited', () async {
      await bloc.fetchNext();
      expect(bloc.state.items, [0, 1, 2, 3, 4]);
    });
  });

  group('reset', () {
    test('needs waiting for microtask to ensure ops to be completed', () async {
      bloc
        ..addItems([1, 2, 3])
        ..reset();
      expect(bloc.state.items, []);
    });
  });

  group('reinitialize', () {
    test('needs waiting for microtask to ensure ops to be completed', () {
      fakeAsync((async) {
        bloc = setBloc()
          ..addItems([5, 6, 7])
          ..reinitialize();
        expect(bloc.state.items, [5, 6, 7]);

        async.elapse(const Duration(seconds: 5));
        expect(bloc.state.items, [0, 1, 2, 3, 4]);
      });
    });

    test('can be awaited', () async {
      bloc.addItems([5, 6, 7]);

      await bloc.reinitialize();
      expect(bloc.state.items, [0, 1, 2, 3, 4]);
    });
  });
}
