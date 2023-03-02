import 'package:bloc_infinite_list/src/core/completable.dart';

abstract class InfiniteListEvent<T> with Completable {
  InfiniteListEvent();

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

class InfiniteListItemRelatedEvent<T> extends InfiniteListEvent<T> {
  InfiniteListItemRelatedEvent();
}

class InfiniteListFetchNextEvent<T> extends InfiniteListItemRelatedEvent<T> {
  InfiniteListFetchNextEvent();
}

class InfiniteListResetEvent<T> extends InfiniteListItemRelatedEvent<T> {
  InfiniteListResetEvent();
}

class InfiniteListReinitializeEvent<T> extends InfiniteListItemRelatedEvent<T> {
  InfiniteListReinitializeEvent();
}

class InfiniteListReplaceEvent<T> extends InfiniteListItemRelatedEvent<T> {
  InfiniteListReplaceEvent(this.before, this.after);
  final T before;
  final T after;
}

class InfiniteListReplaceAtEvent<T> extends InfiniteListItemRelatedEvent<T> {
  InfiniteListReplaceAtEvent(this.idx, this.item);
  final int idx;
  final T item;
}

class InfiniteListReplaceWhereEvent<T> extends InfiniteListItemRelatedEvent<T> {
  InfiniteListReplaceWhereEvent(
    this.test,
    this.willReplacedItemGenerator,
  );
  final bool Function(T) test;
  final T Function(T element) willReplacedItemGenerator;
}

class InfiniteListAddItemEvent<T> extends InfiniteListItemRelatedEvent<T> {
  InfiniteListAddItemEvent(this.item);
  final T item;
}

class InfiniteListAddItemsEvent<T> extends InfiniteListItemRelatedEvent<T> {
  InfiniteListAddItemsEvent(this.items);
  final List<T> items;
}

class InfiniteListInsertEvent<T> extends InfiniteListItemRelatedEvent<T> {
  InfiniteListInsertEvent(this.idx, this.item);
  final int idx;
  final T item;
}

class InfiniteListRemoveEvent<T> extends InfiniteListItemRelatedEvent<T> {
  InfiniteListRemoveEvent(this.item);
  final T item;
}

class InfiniteListRemoveAtEvent<T> extends InfiniteListItemRelatedEvent<T> {
  InfiniteListRemoveAtEvent(this.idx);
  final int idx;
}
