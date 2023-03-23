import 'package:bloc_infinite_list/src/model/infinite_list.dart';
import 'package:equatable/equatable.dart';

abstract class InfiniteListState<T, R> with EquatableMixin {
  final InfiniteList<T> infList;

  InfiniteListState({InfiniteList<T>? infList})
      : infList = infList ?? InfiniteList<T>();

  T operator [](int index) => infList.items[index];

  List<T> get items => infList.items;

  int get itemCount => infList.itemCount;

  int get itemCountWithLoading => infList.itemCount + (isLoading ? 1 : 0);

  int get loadingIndicatorIdx => itemCount;

  InfiniteListStatus get status => infList.status;

  bool get hasNext => !status.isLoadCompleted;

  bool get isInitialLoading => status.isInitialLoading;

  bool get isLoading => status.isLoading;

  bool get isReady =>
      status.isLoaded || status.isLoading || status.isLoadCompleted;

  bool get isEmpty => infList.items.isEmpty;

  bool get isNotEmpty => !isEmpty;

  bool get isFetchNotNeeded => infList.isFetchNotNeeded;

  int? get itemCountIncludeNotFetched => infList.itemCountIncludeNotFetched;

  R copyWith({InfiniteList<T>? infList});
}

abstract class MultiInfiniteListState<KT, T, Out> with EquatableMixin {
  final Map<KT, InfiniteList<T>> keysToInfLists;

  MultiInfiniteListState({required this.keysToInfLists});

  Out copyWith({Map<KT, InfiniteList<T>>? keysToInfLists});
}

abstract class DefaultMultiInfiniteListState<KT, T>
    extends MultiInfiniteListState<KT, T,
        DefaultMultiInfiniteListState<KT, T>> {
  DefaultMultiInfiniteListState({required super.keysToInfLists});

  @override
  DefaultMultiInfiniteListState<KT, T> copyWith({
    Map<KT, InfiniteList<T>>? keysToInfLists,
  });
}

class DefaultInfiniteListState<T>
    extends InfiniteListState<T, DefaultInfiniteListState<T>> {
  DefaultInfiniteListState({super.infList});

  @override
  DefaultInfiniteListState<T> copyWith({InfiniteList<T>? infList}) {
    return DefaultInfiniteListState(infList: infList);
  }

  @override
  List<Object?> get props => [infList];
}
