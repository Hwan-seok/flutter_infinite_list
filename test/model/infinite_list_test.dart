import 'package:bloc_infinite_list/bloc_infinite_list.dart';
import 'package:test/test.dart';

void main() {
  test('removeAt()', () {
    const list = InfiniteList<int>(items: [1, 2, 3]);

    expect(list.removeAt(2).items, [1, 2]);
  });
}
