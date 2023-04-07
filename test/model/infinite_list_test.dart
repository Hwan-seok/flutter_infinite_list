// ignore_for_file: cascade_invocations

import 'package:bloc_infinite_list/bloc_infinite_list.dart';
import 'package:test/test.dart';

void main() {
  test('itemCount reflects correctly', () {
    const list = InfiniteList<int>(items: [1, 2, 3]);

    expect(list.itemCount, 3);
    expect(list.addItem(6).itemCount, 4);
  });

  test('isEmpty', () {
    const list = InfiniteList<int>();
    expect(list.isEmpty, isTrue);
  });

  test('removeAt()', () {
    const list = InfiniteList<int>(items: [1, 2, 3]);

    expect(list.removeAt(1).items, [1, 3]);
  });

  test('addItems()', () {
    const list = InfiniteList<int>();

    list.addItems([1, 2, 3, 4, 5]);

    expect(list.removeAt(1).items, [1, 3]);
  });

  group('reset()', () {
    test('clears all state to initial', () {
      const list = InfiniteList<int>(
        items: [1, 2, 3, 4, 5],
        shouldFetchPage: 1,
        status: InfiniteListStatus.loaded,
        itemCountIncludeNotFetched: 10,
      );

      expect(list.reset(), const InfiniteList<int>());
    });
  });
}
