import 'package:bloc_infinite_list/bloc_infinite_list.dart';
import 'package:test/test.dart';

void main() {
  test('Slice can be mapped with other type', () {
    const slice = Slice<String>(items: ['1', '2', '3'], didFetchedAll: false);
    final mappedSlice = slice.map(int.parse);

    expect(
      mappedSlice,
      const Slice<int>(items: [1, 2, 3], didFetchedAll: false),
    );
  });
}
