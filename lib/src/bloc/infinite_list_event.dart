abstract class InfiniteListEvent<T> {
  const InfiniteListEvent();

  const factory InfiniteListEvent.fetchNext() = InfiniteListFetchNextEvent;
  const factory InfiniteListEvent.reinitialize() = InfiniteListReinitializeEvent;
  const factory InfiniteListEvent.reset() = InfiniteListResetEvent;

  const factory InfiniteListEvent.addItem(T item) = InfiniteListAddItemEvent;
  const factory InfiniteListEvent.addItems(List<T> items) = InfiniteListAddItemsEvent;
  const factory InfiniteListEvent.insert(int idx, T item) = InfiniteListInsertEvent;

  const factory InfiniteListEvent.remove(T item) = InfiniteListRemoveEvent;
  const factory InfiniteListEvent.removeAt(int idx) = InfiniteListRemoveAtEvent;

  const factory InfiniteListEvent.replace(T before, T after) = InfiniteListReplaceEvent;
  const factory InfiniteListEvent.replaceAt(int idx, T item) = InfiniteListReplaceAtEvent;
  const factory InfiniteListEvent.replaceWhere(
    bool Function(T) test,
    T Function(T element) willReplacedItemGenerator,
  ) = InfiniteListReplaceWhereEvent;
}

class InfiniteListItemRelatedEvent<T> extends InfiniteListEvent<T> {
  const InfiniteListItemRelatedEvent();
}

class InfiniteListFetchNextEvent<T> extends InfiniteListItemRelatedEvent<T> {
  const InfiniteListFetchNextEvent();
}

class InfiniteListResetEvent<T> extends InfiniteListItemRelatedEvent<T> {
  const InfiniteListResetEvent();
}

class InfiniteListReinitializeEvent<T> extends InfiniteListItemRelatedEvent<T> {
  const InfiniteListReinitializeEvent();
}

class InfiniteListReplaceEvent<T> extends InfiniteListItemRelatedEvent<T> {
  final T before;
  final T after;

  const InfiniteListReplaceEvent(this.before, this.after);
}

class InfiniteListReplaceAtEvent<T> extends InfiniteListItemRelatedEvent<T> {
  final int idx;
  final T item;

  const InfiniteListReplaceAtEvent(this.idx, this.item);
}

class InfiniteListReplaceWhereEvent<T> extends InfiniteListItemRelatedEvent<T> {
  final bool Function(T) test;
  final T Function(T element) willReplacedItemGenerator;

  const InfiniteListReplaceWhereEvent(this.test, this.willReplacedItemGenerator);
}

class InfiniteListAddItemEvent<T> extends InfiniteListItemRelatedEvent<T> {
  final T item;

  const InfiniteListAddItemEvent(this.item);
}

class InfiniteListAddItemsEvent<T> extends InfiniteListItemRelatedEvent<T> {
  final List<T> items;

  const InfiniteListAddItemsEvent(this.items);
}

class InfiniteListInsertEvent<T> extends InfiniteListItemRelatedEvent<T> {
  final int idx;
  final T item;
  const InfiniteListInsertEvent(this.idx, this.item);
}

class InfiniteListRemoveEvent<T> extends InfiniteListItemRelatedEvent<T> {
  final T item;

  const InfiniteListRemoveEvent(this.item);
}

class InfiniteListRemoveAtEvent<T> extends InfiniteListItemRelatedEvent<T> {
  final int idx;

  const InfiniteListRemoveAtEvent(this.idx);
}
