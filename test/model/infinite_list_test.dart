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

  group('insert()', () {
    test('inserts a item at the idx', () {
      const list = InfiniteList<int>(items: [1, 2, 3]);
      expect(list.insert(1, 0).items, [1, 0, 2, 3]);
    });

    test('inserts at the end if idx is greater than the length', () {
      const list = InfiniteList<int>(items: [1, 2, 3]);
      expect(list.insert(10, 0).items, [1, 2, 3, 0]);

      const list2 = InfiniteList<int>(items: [1, 2, 3]);
      expect(list2.insert(3, 1).items, [1, 2, 3, 1]);
    });
  });

  test('addItem()', () {
    const list = InfiniteList<int>(items: [1, 2, 3]);
    expect(list.addItem(5).items, [1, 2, 3, 5]);
  });

  test('addItems()', () {
    const list = InfiniteList<int>(items: [1, 2, 3]);
    expect(list.addItems([7, 8, 9]).items, [1, 2, 3, 7, 8, 9]);
  });

  group('replace()', () {
    test('replaces `before` to an `after`', () {
      const list = InfiniteList<int>(items: [1, 2, 3]);
      expect(list.replace(2, 4).items, [1, 4, 3]);
    });

    test('affects nothing if there is no `before` in the list', () {
      const list = InfiniteList<int>(items: [1, 2, 3]);
      expect(list.replace(4, 5).items, [1, 2, 3]);
    });
  });

  group('replaceAt()', () {
    test('replaces an item at the idx with the `item`', () {
      const list = InfiniteList<int>(items: [1, 2, 3]);
      expect(list.replaceAt(1, 4).items, [1, 4, 3]);
    });

    test('happens nothing if idx is not bound with items', () {
      const list = InfiniteList<int>(items: [1, 2, 3]);
      expect(list.replaceAt(10, 4).items, [1, 2, 3]);
      expect(list.replaceAt(-1, 4).items, [1, 2, 3]);
    });
  });

  test('removeAt()', () {
    const list = InfiniteList<int>(items: [1, 2, 3]);

    expect(list.removeAt(1).items, [1, 3]);
  });
}
