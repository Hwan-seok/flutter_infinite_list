import 'package:bloc_infinite_list/bloc_infinite_list.dart';
import 'package:test/test.dart';

void main() {
  test('itemCount reflects correctly', () {
    const list = InfiniteList<int>(items: [1, 2, 3]);

    expect(list.itemCount, 3);
    list.addItem(6);
    expect(list.itemCount, 4);
  });

  test('isEmpty', () {
    const list = InfiniteList<int>(items: []);
    expect(list.isEmpty, isTrue);
  });

  test('removeAt()', () {
    const list = InfiniteList<int>(items: [1, 2, 3]);

    expect(list.removeAt(1).items, [1, 3]);
  });
}
