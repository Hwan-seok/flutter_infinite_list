import 'package:bloc_infinite_list/src/core/completable.dart';

abstract class InfiniteListEvent<T, State> with Completable {
  final State Function(State)? batch;

  InfiniteListEvent({this.batch});

  factory InfiniteListEvent.fetchNext() = InfiniteListFetchNextEvent;
  factory InfiniteListEvent.reinitialize() = InfiniteListReinitializeEvent;
  factory InfiniteListEvent.reset() = InfiniteListResetEvent;

  factory InfiniteListEvent.addItem(T item) = InfiniteListAddItemEvent;
  factory InfiniteListEvent.addItems(List<T> items) = InfiniteListAddItemsEvent;
  factory InfiniteListEvent.insert(int idx, T item) = InfiniteListInsertEvent;

  factory InfiniteListEvent.remove(T item) = InfiniteListRemoveEvent;
  factory InfiniteListEvent.removeAt(int idx) = InfiniteListRemoveAtEvent;

  factory InfiniteListEvent.replace(T before, T after) =
      InfiniteListReplaceEvent;
  factory InfiniteListEvent.replaceAt(int idx, T item) =
      InfiniteListReplaceAtEvent;
  factory InfiniteListEvent.replaceWhere(
    bool Function(T) test,
    T Function(T element) willReplacedItemGenerator,
  ) = InfiniteListReplaceWhereEvent;
}

class InfiniteListItemRelatedEvent<T, State>
    extends InfiniteListEvent<T, State> {
  InfiniteListItemRelatedEvent({super.batch});
}

class InfiniteListFetchNextEvent<T, State>
    extends InfiniteListItemRelatedEvent<T, State> {
  InfiniteListFetchNextEvent({
    super.batch,
  });
}

class InfiniteListResetEvent<T, State>
    extends InfiniteListItemRelatedEvent<T, State> {
  InfiniteListResetEvent({
    super.batch,
  });
}

class InfiniteListReinitializeEvent<T, State>
    extends InfiniteListItemRelatedEvent<T, State> {
  InfiniteListReinitializeEvent({
    super.batch,
  });
}

class InfiniteListReplaceEvent<T, State>
    extends InfiniteListItemRelatedEvent<T, State> {
  InfiniteListReplaceEvent(
    this.before,
    this.after, {
    super.batch,
  });
  final T before;
  final T after;
}

class InfiniteListReplaceAtEvent<T, State>
    extends InfiniteListItemRelatedEvent<T, State> {
  InfiniteListReplaceAtEvent(this.idx, this.item, {super.batch});
  final int idx;
  final T item;
}

class InfiniteListReplaceWhereEvent<T, State>
    extends InfiniteListItemRelatedEvent<T, State> {
  InfiniteListReplaceWhereEvent(
    this.test,
    this.willReplacedItemGenerator, {
    super.batch,
  });
  final bool Function(T) test;
  final T Function(T element) willReplacedItemGenerator;
}

class InfiniteListAddItemEvent<T, State>
    extends InfiniteListItemRelatedEvent<T, State> {
  InfiniteListAddItemEvent(this.item, {super.batch});
  final T item;
}

class InfiniteListAddItemsEvent<T, State>
    extends InfiniteListItemRelatedEvent<T, State> {
  InfiniteListAddItemsEvent(this.items, {super.batch});
  final List<T> items;
}

class InfiniteListInsertEvent<T, State>
    extends InfiniteListItemRelatedEvent<T, State> {
  InfiniteListInsertEvent(this.idx, this.item, {super.batch});
  final int idx;
  final T item;
}

class InfiniteListRemoveEvent<T, State>
    extends InfiniteListItemRelatedEvent<T, State> {
  InfiniteListRemoveEvent(this.item, {super.batch});
  final T item;
}

class InfiniteListRemoveAtEvent<T, State>
    extends InfiniteListItemRelatedEvent<T, State> {
  InfiniteListRemoveAtEvent(this.idx, {super.batch});
  final int idx;
}
