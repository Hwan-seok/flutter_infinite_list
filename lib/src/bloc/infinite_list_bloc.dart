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
        Event extends InfiniteListEvent<ElementType, State>,
        State extends InfiniteListState<ElementType, State>>
    extends Bloc<InfiniteListEvent<ElementType, State>, State>
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

    on<InfiniteListFetchNextEvent<ElementType, State>>(
      _fetchNext,
      transformer: droppable(),
    );
    on<InfiniteListReinitializeEvent<ElementType, State>>(
      _reinitialize,
      transformer: droppable(),
    );
    on<InfiniteListResetEvent<ElementType, State>>(_reset);

    on<InfiniteListAddItemEvent<ElementType, State>>(_addItem);
    on<InfiniteListAddItemsEvent<ElementType, State>>(_addItems);
    on<InfiniteListInsertEvent<ElementType, State>>(_insert);

    on<InfiniteListRemoveEvent<ElementType, State>>(_remove);
    on<InfiniteListRemoveAtEvent<ElementType, State>>(_removeAt);

    on<InfiniteListReplaceEvent<ElementType, State>>(_replace);
    on<InfiniteListReplaceAtEvent<ElementType, State>>(_replaceAt);
    on<InfiniteListReplaceWhereEvent<ElementType, State>>(_replaceWhere);
  }

  // -------------------------------------------------- Methods

  Future<void> triggerAdd(
    ElementType item, {
    State Function(State)? batch,
  }) {
    final event =
        InfiniteListAddItemEvent<ElementType, State>(item, batch: batch);
    add(event);
    return event.completed;
  }

  Future<void> triggerAddAll(
    List<ElementType> items, {
    State Function(State)? batch,
  }) {
    final event =
        InfiniteListAddItemsEvent<ElementType, State>(items, batch: batch);
    add(event);
    return event.completed;
  }

  Future<void> triggerReplace(
    ElementType before,
    ElementType after, {
    State Function(State)? batch,
  }) {
    final event = InfiniteListReplaceEvent<ElementType, State>(
      before,
      after,
      batch: batch,
    );
    add(event);
    return event.completed;
  }

  Future<void> triggerReplaceAt(
    int idx,
    ElementType item, {
    State Function(State)? batch,
  }) {
    final event =
        InfiniteListReplaceAtEvent<ElementType, State>(idx, item, batch: batch);
    add(event);
    return event.completed;
  }

  Future<void> triggerReplaceWhere(
    bool Function(ElementType item) test,
    ElementType Function(ElementType element) itemGenerator, {
    State Function(State)? batch,
  }) {
    final event = InfiniteListReplaceWhereEvent<ElementType, State>(
      test,
      itemGenerator,
      batch: batch,
    );
    add(event);
    return event.completed;
  }

  Future<void> triggerInsert(
    int idx,
    ElementType item, {
    State Function(State)? batch,
  }) {
    final event =
        InfiniteListInsertEvent<ElementType, State>(idx, item, batch: batch);
    add(event);
    return event.completed;
  }

  Future<void> triggerRemove(
    ElementType item, {
    State Function(State)? batch,
  }) {
    final event =
        InfiniteListRemoveEvent<ElementType, State>(item, batch: batch);
    add(event);
    return event.completed;
  }

  Future<void> triggerRemoveAt(
    int idx, {
    State Function(State)? batch,
  }) {
    final event =
        InfiniteListRemoveAtEvent<ElementType, State>(idx, batch: batch);
    add(event);
    return event.completed;
  }

  Future<void> triggerFetchNext({
    State Function(State)? batch,
  }) {
    final event = InfiniteListFetchNextEvent<ElementType, State>(batch: batch);
    add(event);
    return event.completed;
  }

  Future<void> triggerReset({
    State Function(State)? batch,
  }) {
    final event = InfiniteListResetEvent<ElementType, State>(batch: batch);
    add(event);
    return event.completed;
  }

  Future<void> triggerReinitialize({
    State Function(State)? batch,
  }) {
    final event =
        InfiniteListReinitializeEvent<ElementType, State>(batch: batch);
    add(event);
    return event.completed;
  }

  void _addItem(
    InfiniteListAddItemEvent<ElementType, State> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(
        event,
        () => addItem(event.item, emitter: emit, batch: event.batch),
      );

  void _addItems(
    InfiniteListAddItemsEvent<ElementType, State> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(
        event,
        () => addItems(event.items, emitter: emit, batch: event.batch),
      );

  void _replace(
    InfiniteListReplaceEvent<ElementType, State> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(
        event,
        () => replace(
          event.before,
          event.after,
          emitter: emit,
          batch: event.batch,
        ),
      );

  void _replaceAt(
    InfiniteListReplaceAtEvent<ElementType, State> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(
        event,
        () =>
            replaceAt(event.idx, event.item, emitter: emit, batch: event.batch),
      );

  void _replaceWhere(
    InfiniteListReplaceWhereEvent<ElementType, State> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(
        event,
        () => replaceWhere(
          event.test,
          event.willReplacedItemGenerator,
          emitter: emit,
          batch: event.batch,
        ),
      );

  void _insert(
    InfiniteListInsertEvent<ElementType, State> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(
        event,
        () => insert(event.idx, event.item, emitter: emit, batch: event.batch),
      );

  void _remove(
    InfiniteListRemoveEvent<ElementType, State> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(
        event,
        () => remove(event.item, emitter: emit, batch: event.batch),
      );

  void _removeAt(
    InfiniteListRemoveAtEvent<ElementType, State> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(
        event,
        () => removeAt(event.idx, emitter: emit, batch: event.batch),
      );

  Future<void> _fetchNext(
    InfiniteListFetchNextEvent<ElementType, State> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(
        event,
        () => fetchNext(emitter: emit, batch: event.batch),
      );

  void _reset(
    InfiniteListResetEvent<ElementType, State> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(event, () => reset(emitter: emit, batch: event.batch));

  Future<void> _reinitialize(
    InfiniteListReinitializeEvent<ElementType, State> event,
    Emitter<State> emit,
  ) =>
      _wrapCompletable(
        event,
        () => fetchNext(reset: true, emitter: emit, batch: event.batch),
      );

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

class DefaultInfiniteListBloc<T> extends InfiniteListBloc<
    T,
    InfiniteListEvent<T, DefaultInfiniteListState<T>>,
    DefaultInfiniteListState<T>> {
  DefaultInfiniteListBloc({
    required super.fetch,
    required super.initialState,
    super.limit,
  });

  DefaultInfiniteListBloc.empty({
    required super.fetch,
    super.limit,
  }) : super(
          initialState: DefaultInfiniteListState<T>.empty(),
        );
}
