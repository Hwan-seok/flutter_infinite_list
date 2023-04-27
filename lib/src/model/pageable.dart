import 'package:bloc_infinite_list/src/model/slice.dart';

class Pageable<T> extends Slice<T> {
  final int totalElements;

  const Pageable({
    required super.items,
    required super.didFetchedAll,
    required this.totalElements,
  });

  const Pageable.empty()
      : totalElements = 0,
        super.empty();

  @override
  Pageable<R> map<R>(R Function(T element) mapper) => Pageable<R>(
        items: items.map(mapper).toList(),
        didFetchedAll: didFetchedAll,
        totalElements: totalElements,
      );

  @override
  List<Object?> get props => [items, didFetchedAll, totalElements];
}
