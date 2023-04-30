import 'package:bloc_infinite_list/bloc_infinite_list.dart';
import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';

import '../helpers/custom_state.dart';

Future<Slice<int>> _fetch<State>(
  int page,
  int limit,
  State state,
  dynamic cancelToken,
) async {
  await Future.delayed(const Duration(seconds: 1));
  return Slice(
    items: List.generate(limit, (index) => page * limit + index),
    didFetchedAll: false,
  );
}

class CustomInfiniteListCubit extends InfiniteListCubit<int, CustomState> {
  CustomInfiniteListCubit()
      : super(
          fetch: _fetch,
          initialState: CustomState(
            infList: const InfiniteList(),
            value: '0',
          ),
        );
}

void main() {
  late CustomInfiniteListCubit bloc;

  CustomInfiniteListCubit setBloc() =>
      bloc = CustomInfiniteListCubit()..registerLimit(5);

  setUp(setBloc);

  CustomState incrementBatch(CustomState state) =>
      state.copyWith(value: (int.parse(state.value) + 1).toString());

  group('add', () {
    test('runs fine with batch', () async {
      bloc.addItem(1, batch: incrementBatch);
      expect(bloc.state.items, [1]);
      expect(bloc.state.value, '1');
    });
  });

  group('addAll', () {
    test('runs fine with batch', () async {
      bloc.addItems([1, 2, 3], batch: incrementBatch);
      expect(bloc.state.items, [1, 2, 3]);
      expect(bloc.state.value, '1');
    });
  });

  group('replace', () {
    test('runs fine with batch', () async {
      bloc
        ..addItems([1, 2, 3])
        ..replace(2, 4, batch: incrementBatch);
      expect(bloc.state.items, [1, 4, 3]);
      expect(bloc.state.value, '1');
    });
  });

  group('replaceAt', () {
    test('runs fine with batch', () async {
      bloc
        ..addItems([1, 2, 3])
        ..replaceAt(2, 4, batch: incrementBatch);
      expect(bloc.state.items, [1, 2, 4]);
      expect(bloc.state.value, '1');
    });
  });

  group('replaceWhere', () {
    test('runs fine with batch', () async {
      bloc
        ..addItems([1, 2, 3])
        ..replaceWhere(
          (item) => item == 1,
          (element) => 4,
          batch: incrementBatch,
        );
      expect(bloc.state.items, [4, 2, 3]);
      expect(bloc.state.value, '1');
    });
  });

  group('insert', () {
    test('runs fine with batch', () async {
      bloc
        ..addItems([1, 2, 3])
        ..insert(1, 4, batch: incrementBatch);
      expect(bloc.state.items, [1, 4, 2, 3]);
      expect(bloc.state.value, '1');
    });
  });

  group('remove', () {
    test('runs fine with batch', () async {
      bloc
        ..addItems([1, 2, 3])
        ..remove(1, batch: incrementBatch);
      expect(bloc.state.items, [2, 3]);
      expect(bloc.state.value, '1');
    });
  });

  group('removeAt', () {
    test('runs fine with batch', () async {
      bloc
        ..addItems([1, 2, 3])
        ..removeAt(1, batch: incrementBatch);
      expect(bloc.state.items, [1, 3]);
      expect(bloc.state.value, '1');
    });
  });

  group('fetchNext', () {
    test('runs fine with batch', () {
      fakeAsync((async) {
        // Bloc should be set within the fakeAsync bloc because
        // FakeAsync is internally uses a zone and it affects only in the callback closure but not in [setup]
        bloc = setBloc()..fetchNext(batch: incrementBatch);
        expect(bloc.state.items, []);

        async.elapse(const Duration(seconds: 5));

        expect(bloc.state.items, [0, 1, 2, 3, 4]);
        expect(bloc.state.value, '1');
      });
    });

    test('can be awaited', () async {
      await bloc.fetchNext(batch: incrementBatch);
      expect(bloc.state.items, [0, 1, 2, 3, 4]);
      expect(bloc.state.value, '1');
    });
  });

  group('reset', () {
    test('runs fine with batch', () async {
      bloc
        ..addItems([1, 2, 3])
        ..reset(batch: incrementBatch);
      expect(bloc.state.items, []);
      expect(bloc.state.value, '1');
    });
  });

  group('reinitialize', () {
    test('runs fine with batch', () {
      fakeAsync((async) {
        bloc = setBloc()
          ..addItems([5, 6, 7])
          ..reinitialize(batch: incrementBatch);
        expect(bloc.state.items, [5, 6, 7]);

        async.elapse(const Duration(seconds: 5));
        expect(bloc.state.items, [0, 1, 2, 3, 4]);
        expect(bloc.state.value, '1');
      });
    });

    test('can be awaited', () async {
      bloc.addItems([5, 6, 7]);

      await bloc.reinitialize(batch: incrementBatch);
      expect(bloc.state.items, [0, 1, 2, 3, 4]);
      expect(bloc.state.value, '1');
    });
  });
}
