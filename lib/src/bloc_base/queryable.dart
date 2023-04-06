import 'package:bloc/bloc.dart';
import 'package:bloc_infinite_list/bloc_infinite_list.dart';

/// A mixin that provides query methods for [InfiniteListState].

mixin InfiniteListQueryable<ElementType,
    State extends InfiniteListState<ElementType, State>> on BlocBase<State> {
  /// Gets the element at the given [index].
  ElementType operator [](int index) => state.infList[index];

  /// Gets the sub list of the given `[start, end)` range.
  /// This returns half-open range which means that
  /// [start] is included but the the item of [end] index is not included.
  Iterable<ElementType> getRange(int start, int end) =>
      state.infList.getRange(start, end);

  /// Finds the index of the given [item].
  /// Returns `null` if the item is not found.
  /// Port of `Iterable.indexOf`.
  int? indexOf(ElementType item) => state.infList.indexOf(item);

  /// Finds the index of given [item] that starts searching from the end.
  /// Returns `null` if the item is not found.
  /// Port of [InfiniteList.lastIndexOf].
  int? lastIndexOf(ElementType item) => state.infList.lastIndexOf(item);

  /// Finds the index of the first element that satisfies the [test].
  /// Returns `null` if no element satisfies the [test].
  /// Port of `Iterable.indexWhere`.
  int? indexWhere(bool Function(ElementType item) test) =>
      state.infList.indexWhere(test);

  /// Finds the index of the last element that satisfies the [test].
  /// Returns `null` if no element satisfies the [test].
  int? lastIndexWhere(bool Function(ElementType item) test) =>
      state.infList.lastIndexWhere(test);

  /// Finds the first element that satisfies the [test].
  /// Returns `null` if no element satisfies the [test].
  ///
  /// Port of [InfiniteList.firstWhereOrNull].
  ElementType? firstWhereOrNull(bool Function(ElementType item) test) =>
      state.infList.firstWhereOrNull(test);

  /// Finds all elements that satisfy the [test].
  /// Port of `Iterable.where`.
  Iterable<ElementType> where(bool Function(ElementType item) test) =>
      state.infList.where(test);

  /// Finds the single element that satisfies the [test].
  ///
  /// If there is no element that satisfies the [test], or if there is more than
  /// one element that satisfies the [test], this returns `null`.
  ///
  /// Port of [InfiniteList.singleWhereOrNull].
  ElementType? singleWhereOrNull(bool Function(ElementType item) test) =>
      state.infList.singleWhereOrNull(test);

  /// Inspects whether there is an element that satisfies the [test].
  bool containsWhere(bool Function(ElementType item) test) =>
      state.infList.containsWhere(test);

  /// Inspects whether the [item] is contained in the list.
  ///
  /// Port of [InfiniteList.contains].
  bool contains(ElementType item) => state.infList.contains(item);
}
