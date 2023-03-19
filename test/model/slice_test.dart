import 'package:bloc_infinite_list/bloc_infinite_list.dart';
import 'package:test/test.dart';

void main() {
  test('Slice can be mapped with other type', () {
    const slice = Slice<String>(['1', '2', '3'], false);
    final mappedSlice = slice.map(int.parse);

    expect(mappedSlice, const Slice<int>([1, 2, 3], false));
  });
}
