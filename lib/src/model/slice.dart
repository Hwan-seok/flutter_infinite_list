import 'package:equatable/equatable.dart';

class Slice<T> extends Equatable {
  final List<T> items;
  final bool didFetchedAll;

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  bool get hasNext => !didFetchedAll;

  const Slice({
    required this.items,
    required this.didFetchedAll,
  });

  const Slice.empty()
      : items = const [],
        didFetchedAll = false;

  Slice<R> map<R>(R Function(T element) mapper) => Slice<R>(
        items: items.map(mapper).toList(),
        didFetchedAll: didFetchedAll,
      );

  @override
  List<Object?> get props => [items, didFetchedAll];
}
