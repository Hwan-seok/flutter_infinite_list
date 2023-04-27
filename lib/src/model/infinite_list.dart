import 'dart:math';

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

  /// The length of the [items].
  int get itemCount => items.length;

  /// Whether the [items] is empty.
  bool get isEmpty => items.isEmpty;

  /// Whether the [items] is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Determines current status will need to fetch next page or not.
  bool get isFetchNotNeeded =>
      status.isInitialLoading || status.isLoadCompleted || status.isLoading;

  /// Get index of the [item] in the [items].
  /// Returns `null` if the [item] is not found.
  int? indexOf(T item) {
    final result = items.indexOf(item);
    return result == _IDX_NOT_FOUND ? null : result;
  }

  /// Get index of the last [item] in the [items].
  /// If the [item] is found multiple times, the last index is returned.
  /// Returns `null` if the [item] is not found.
  ///
  /// If [item] is found only once, the result is the same as [indexOf].
  int? lastIndexOf(T item) {
    final result = items.lastIndexOf(item);
    return result == _IDX_NOT_FOUND ? null : result;
  }

  /// Get index of the first item that satisfies the [test].
  int? indexWhere(bool Function(T item) test) {
    final result = items.indexWhere(test);
    return result == _IDX_NOT_FOUND ? null : result;
  }

  /// Get index of the last item that satisfies the [test].
  int? lastIndexWhere(bool Function(T item) test) {
    final result = items.lastIndexWhere(test);
    return result == _IDX_NOT_FOUND ? null : result;
  }

  /// Get the first item that satisfies the [test].
  /// Returns `null` if no item satisfies the [test].
  T? firstWhereOrNull(bool Function(T item) test) =>
      items.firstWhereOrNull(test);

  /// Gets all items that satisfy the [test].
  Iterable<T> where(bool Function(T item) test) => items.where(test);

  /// Gets only single item that satisfies the [test].
  /// Returns `null` if no item satisfies the [test] or multiple items satisfy the [test].
  T? singleWhereOrNull(bool Function(T item) test) =>
      items.singleWhereOrNull(test);

  /// Whether the [items] contains the item that satisfies the [test].
  bool containsWhere(bool Function(T item) test) =>
      firstWhereOrNull(test) != null;

  /// Whether the [items] contains the [item].
  bool contains(T item) => items.contains(item);

  /// Get sub [Iterable] from the [items].
  /// `[start, end)`
  Iterable<T> getRange(int start, int end) => items.getRange(start, end);

  /// ------------------------------------------ End Queries

  /// ------------------------------------------ Mutations

  /// Returns a new [InfiniteList] with changed to the loading status.
  InfiniteList<T> copyToLoading() => copyWith(
        status: status.isInitial
            ? InfiniteListStatus.initialLoading
            : InfiniteListStatus.loading,
      );

  /// Returns a new [InfiniteList] with changed to the loaded status.
  InfiniteList<T> copyToLoaded() => copyWith(status: InfiniteListStatus.loaded);

  /// Returns a new [InfiniteList] with the item is inserted at the [idx].
  /// If the [idx] is greater than the [itemCount], the [item] is added to the end of the [items].
  InfiniteList<T> insert(int idx, T item) {
    final cappedIdx = min(idx, itemCount);
    return copyWith(
      items: [
        ...items.sublist(0, cappedIdx),
        item,
        ...items.sublist(cappedIdx),
      ],
    );
  }

  /// Returns a new [InfiniteList] with the [item] is added to the end of the [items].
  InfiniteList<T> addItem(T item) => copyWith(
        items: [...items, item],
      );

  /// Returns a new [InfiniteList] with the [newItems] is added to the end of the [items].
  InfiniteList<T> addItems(Iterable<T> newItems) => copyWith(
        items: [...items, ...newItems],
      );

  /// Returns a new [InfiniteList] that [before] in the list is replaced with [after].
  /// If the [before] is not found, the [items] is not changed.
  InfiniteList<T> replace(T before, T after) => copyWith(
        items: [
          for (var item in items)
            if (item == before) after else item,
        ],
      );

  /// Returns a new [InfiniteList] that the item at the [idx] is replaced with [item].
  /// If the [idx] is out of range, the [items] is not changed.
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
        items: [...items, ...slice.items],
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
        'InfiniteList<$T>{status: $status, items: $items, shouldFetchPage: $shouldFetchPage}$pageableProp';
    return s;
  }
}
