import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:bloc_infinite_list/src/bloc/infinite_list_event.dart';
import 'package:bloc_infinite_list/src/bloc/infinite_list_state.dart';
import 'package:bloc_infinite_list/src/bloc_base/mutable.dart';
import 'package:bloc_infinite_list/src/bloc_base/queryable.dart';
import 'package:bloc_infinite_list/src/core/completable.dart';
import 'package:bloc_infinite_list/src/core/types.dart';

abstract class InfiniteListBloc<
        ElementType,
        Event extends InfiniteListEvent<ElementType>,
        State extends InfiniteListState<ElementType, State>>
    extends Bloc<InfiniteListEvent<ElementType>, State>
    with
        InfiniteListQueryable<ElementType, State>,
        InfiniteListMutable<ElementType, State> {
  /// ------------------------------------------------- Constructor

  InfiniteListBloc({
    int? limit,
    required PagedSliceFetcher<ElementType, State> fetch,
    required State initialState,
  }) : super(initialState) {
    registerFetch(fetch);
    if (limit != null) {
      registerLimit(limit);
    }

    on<InfiniteListFetchNextEvent<ElementType>>(
      _fetchNext,
      transformer: droppable(),
    );
    on<InfiniteListReinitializeEvent<ElementType>>(
      _reinitialize,
      transformer: droppable(),
    );
    on<InfiniteListResetEvent<ElementType>>(_reset);

    on<InfiniteListAddItemEvent<ElementType>>(_addItem);
    on<InfiniteListAddItemsEvent<ElementType>>(_addItems);
    on<InfiniteListInsertEvent<ElementType>>(_insert);

    on<InfiniteListRemoveEvent<ElementType>>(_remove);
    on<InfiniteListRemoveAtEvent<ElementType>>(_removeAt);

    on<InfiniteListReplaceEvent<ElementType>>(_replace);
    on<InfiniteListReplaceAtEvent<ElementType>>(_replaceAt);
    on<InfiniteListReplaceWhereEvent<ElementType>>(_replaceWhere);
  }

  // -------------------------------------------------- Methods

  Future<void> triggerAdd(ElementType item) {
    final event = InfiniteListAddItemEvent(item);
    add(event);
    return event.completed;
  }

  Future<void> triggerAddAll(List<ElementType> items) {
    final event = InfiniteListAddItemsEvent(items);
    add(event);
    return event.completed;
  }

  Future<void> triggerReplace(ElementType before, ElementType after) {
    final event = InfiniteListReplaceEvent(before, after);
    add(event);
    return event.completed;
  }

  Future<void> triggerReplaceAt(int idx, ElementType item) {
    final event = InfiniteListReplaceAtEvent(idx, item);
    add(event);
    return event.completed;
  }

  Future<void> triggerReplaceWhere(
    bool Function(ElementType item) test,
    ElementType Function(ElementType element) itemGenerator,
  ) {
    final event = InfiniteListReplaceWhereEvent(test, itemGenerator);
    add(event);
    return event.completed;
  }

  Future<void> triggerInsert(int idx, ElementType item) {
    final event = InfiniteListInsertEvent(idx, item);
    add(event);
    return event.completed;
  }

  Future<void> triggerRemove(ElementType item) {
    final event = InfiniteListRemoveEvent(item);
    add(event);
    return event.completed;
  }

  Future<void> triggerRemoveAt(int idx) {
    final event = InfiniteListRemoveAtEvent<ElementType>(idx);
    add(event);
    return event.completed;
  }

  Future<void> triggerFetchNext() {
    final event = InfiniteListFetchNextEvent<ElementType>();
    add(event);
    return event.completed;
  }

  Future<void> triggerReset() {
    final event = InfiniteListResetEvent<ElementType>();
    add(event);
    return event.completed;
  }

  Future<void> triggerReinitialize() {
    final event = InfiniteListReinitializeEvent<ElementType>();
    add(event);
    return event.completed;
  }

  void _addItem(
    InfiniteListAddItemEvent<ElementType> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(event, () => addItem(event.item, emitter: emit));

  void _addItems(
    InfiniteListAddItemsEvent<ElementType> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(event, () => addItems(event.items, emitter: emit));

  void _replace(
    InfiniteListReplaceEvent<ElementType> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(
        event,
        () => replace(event.before, event.after, emitter: emit),
      );

  void _replaceAt(
    InfiniteListReplaceAtEvent<ElementType> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(
        event,
        () => replaceAt(event.idx, event.item, emitter: emit),
      );

  void _replaceWhere(
    InfiniteListReplaceWhereEvent<ElementType> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(
        event,
        () => replaceWhere(
          event.test,
          event.willReplacedItemGenerator,
          emitter: emit,
        ),
      );

  void _insert(
    InfiniteListInsertEvent<ElementType> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(
        event,
        () => insert(event.idx, event.item, emitter: emit),
      );

  void _remove(
    InfiniteListRemoveEvent<ElementType> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(event, () => remove(event.item, emitter: emit));

  void _removeAt(
    InfiniteListRemoveAtEvent<ElementType> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(event, () => removeAt(event.idx, emitter: emit));

  Future<void> _fetchNext(
    InfiniteListFetchNextEvent<ElementType> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(event, () => fetchNext(emitter: emit));

  void _reset(
    InfiniteListResetEvent<ElementType> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(event, () => reset(emitter: emit));

  Future<void> _reinitialize(
    InfiniteListReinitializeEvent<ElementType> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(event, () => fetchNext(reset: true, emitter: emit));

  Future<void> _wrapCompletable(
    Completable completable,
    FutureOr<void> Function() ops,
  ) async {
    try {
      final result = ops();
      if (result is Future) await result;

      completable.complete();
    } catch (e, st) {
      completable.completeError(e, st);
      rethrow;
    }
  }
}
