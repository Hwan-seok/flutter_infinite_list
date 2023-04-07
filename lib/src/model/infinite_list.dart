import 'package:bloc_infinite_list/src/model/pageable.dart';
import 'package:bloc_infinite_list/src/model/slice.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// Represents current status of the [InfiniteList]
enum InfiniteListStatus {
  /// [initial] indicates the initial status as itself.
  initial,

  /// [initialLoading] is loading status at the first load.
  initialLoading,
  loaded,
  loading,
  loadCompleted,
  ;

  bool get isInitial => this == initial;
  bool get isInitialLoading => this == initialLoading;
  bool get isLoading => this == loading;
  bool get isLoaded => this == loaded;
  bool get isLoadCompleted => this == loadCompleted;
}

const _IDX_NOT_FOUND = -1;

class InfiniteList<T> extends Equatable {
  const InfiniteList({
    this.items = const [],
    this.shouldFetchPage = 0,
    this.status = InfiniteListStatus.initial,
    this.itemCountIncludeNotFetched,
  });

  factory InfiniteList.fromSlice({
    required Slice<T> slice,
  }) =>
      InfiniteList<T>().addSlice(slice);

  final List<T> items;
  final int shouldFetchPage;

  final InfiniteListStatus status;

  final int? itemCountIncludeNotFetched;

  InfiniteList<T> copyWith({
    List<T>? items,
    int? shouldFetchPage,
    InfiniteListStatus? status,
    int? Function()? itemCountIncludeNotFetched,
  }) {
    return InfiniteList(
      items: items ?? this.items,
      shouldFetchPage: shouldFetchPage ?? this.shouldFetchPage,
      status: status ?? this.status,
      itemCountIncludeNotFetched: itemCountIncludeNotFetched != null
          ? itemCountIncludeNotFetched()
          : this.itemCountIncludeNotFetched,
    );
  }

  /// ------------------------------------------ Queries

  T operator [](int index) => items[index];

  int get itemCount => items.length;

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => !isEmpty;

  bool get isFetchNotNeeded => status.isLoadCompleted || status.isLoading;

  int? indexOf(T item) {
    final result = items.indexOf(item);
    return result == _IDX_NOT_FOUND ? null : result;
  }

  int? lastIndexOf(T item) {
    final result = items.lastIndexOf(item);
    return result == _IDX_NOT_FOUND ? null : result;
  }

  int? indexWhere(bool Function(T item) test) {
    final result = items.indexWhere(test);
    return result == _IDX_NOT_FOUND ? null : result;
  }

  int? lastIndexWhere(bool Function(T item) test) {
    final result = items.lastIndexWhere(test);
    return result == _IDX_NOT_FOUND ? null : result;
  }

  T? firstWhereOrNull(bool Function(T item) test) =>
      items.firstWhereOrNull(test);

  Iterable<T> where(bool Function(T item) test) => items.where(test);

  /// Port of `Iterable.singleWhereOrNull`.
  T? singleWhereOrNull(bool Function(T item) test) =>
      items.singleWhereOrNull(test);

  bool containsWhere(bool Function(T item) test) =>
      firstWhereOrNull(test) != null;

  bool contains(T item) => items.contains(item);

  Iterable<T> getRange(int start, int end) => items.getRange(start, end);

  /// ------------------------------------------ End Queries

  InfiniteList<T> copyToLoading() => copyWith(
        status: status.isInitial
            ? InfiniteListStatus.initialLoading
            : InfiniteListStatus.loading,
      );

  InfiniteList<T> copyToLoaded() => copyWith(status: InfiniteListStatus.loaded);

  InfiniteList<T> insert(int idx, T item) => copyWith(
        items: [
          ...items.sublist(0, idx),
          item,
          ...items.sublist(idx),
        ],
      );

  InfiniteList<T> addItem(T item) => copyWith(
        items: [...items, item],
      );

  InfiniteList<T> addItems(Iterable<T> newItems) => copyWith(
        items: [...items, ...newItems],
      );

  InfiniteList<T> replace(T before, T after) => copyWith(
        items: [
          for (var item in items)
            if (item == before) after else item,
        ],
      );

  InfiniteList<T> replaceAt(int idx, T item) => copyWith(
        items: [
          for (var j = 0; j < items.length; j++)
            if (j == idx) item else items[j],
        ],
      );

  InfiniteList<T> replaceWhere(
    bool Function(T) test,
    T Function(T element) willReplacedItemGenerator,
  ) =>
      copyWith(
        items: [
          for (var item in items)
            if (test(item)) willReplacedItemGenerator(item) else item,
        ],
      );

  InfiniteList<T> remove(T item) {
    return copyWith(
      items: [
        for (final s in items)
          if (s != item) s,
      ],
    );
  }

  InfiniteList<T> removeAt(int idx) {
    return copyWith(
      items: [
        for (var j = 0; j < items.length; j++)
          if (j != idx) items[j],
      ],
    );
  }

  InfiniteList<T> reset() => copyWith(
        items: [],
        status: InfiniteListStatus.initial,
        shouldFetchPage: 0,
        itemCountIncludeNotFetched: () => null,
      );

  InfiniteList<T> addSlice(Slice<T> slice) => copyWith(
        items: [...items, ...slice.content],
        status: slice.hasNext
            ? InfiniteListStatus.loaded
            : InfiniteListStatus.loadCompleted,
        shouldFetchPage: shouldFetchPage + 1,
        itemCountIncludeNotFetched:
            slice is Pageable<T> ? () => slice.totalElements : null,
      );

  @override
  List<Object?> get props =>
      [status, items, shouldFetchPage, itemCountIncludeNotFetched];

  @override
  String toString() {
    final pageableProp = itemCountIncludeNotFetched != null
        ? ', itemCountIncludeNotFetched: $itemCountIncludeNotFetched'
        : '';
    final s =
        'InfiniteList<T>{status: $status, items: $items, shouldFetchPage: $shouldFetchPage}$pageableProp';
    return s;
  }
}
