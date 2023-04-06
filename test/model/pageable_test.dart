import 'package:bloc_infinite_list/bloc_infinite_list.dart';
import 'package:test/test.dart';

void main() {
  test('Mapper works well', () {
    const pageable = Pageable(
      [1, 2, 3],
      false,
      10,
    );

    final mappedPageable = pageable.map((element) => element.toString());

    expect(mappedPageable.content, ['1', '2', '3']);
    expect(mappedPageable.last, false);
    expect(mappedPageable.totalElements, 10);
    expect(mappedPageable, isA<Pageable<String>>());
  });
}
