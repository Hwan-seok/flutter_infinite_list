import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:infinite_list_bloc/src/bloc/infinite_list_event.dart';
import 'package:infinite_list_bloc/src/bloc/infinite_list_state.dart';
import 'package:infinite_list_bloc/src/bloc_base/mutable.dart';
import 'package:infinite_list_bloc/src/bloc_base/queryable.dart';
import 'package:infinite_list_bloc/src/core/types.dart';
import 'package:meta/meta.dart';

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

    on<InfiniteListFetchNextEvent<ElementType>>(_fetchNext,
        transformer: droppable());
    on<InfiniteListReinitializeEvent<ElementType>>(_reinitialize,
        transformer: droppable());
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

  @override
  @visibleForTesting
  void addItem(ElementType item, {Emitter<State>? emitter}) =>
      super.addItem(item, emitter: emitter);

  @override
  @visibleForTesting
  void addItems(Iterable<ElementType> items, {Emitter<State>? emitter}) =>
      super.addItems(items, emitter: emitter);

  @override
  void replace(ElementType before, ElementType after,
          {Emitter<State>? emitter}) =>
      super.replace(before, after, emitter: emitter);

  @override
  @visibleForTesting
  void replaceAt(int idx, ElementType item, {Emitter<State>? emitter}) =>
      super.replaceAt(idx, item, emitter: emitter);

  @override
  @visibleForTesting
  void replaceWhere(
    bool Function(ElementType p1) test,
    ElementType Function(ElementType element) willReplacedItemGenerator, {
    Emitter<State>? emitter,
  }) =>
      super.replaceWhere(test, willReplacedItemGenerator, emitter: emitter);

  @override
  @visibleForTesting
  void insert(int idx, ElementType item, {Emitter<State>? emitter}) =>
      super.insert(idx, item, emitter: emitter);

  @override
  @visibleForTesting
  void remove(ElementType item, {Emitter<State>? emitter}) =>
      super.remove(item, emitter: emitter);

  @override
  @visibleForTesting
  void removeAt(int idx, {Emitter<State>? emitter}) =>
      super.removeAt(idx, emitter: emitter);

  @override
  @visibleForTesting
  void reset({Emitter<State>? emitter}) => super.reset(emitter: emitter);

  @override
  @visibleForTesting
  Future<void> fetchNext({bool reset = false, Emitter<State>? emitter}) =>
      super.fetchNext(reset: reset, emitter: emitter);

  @override
  @visibleForTesting
  Future<void> reinitialize({Emitter<State>? emitter}) =>
      super.reinitialize(emitter: emitter);

  void _addItem(
    InfiniteListAddItemEvent<ElementType> event,
    Emitter<State> emit,
  ) =>
      super.addItem(event.item);

  void _addItems(
    InfiniteListAddItemsEvent<ElementType> event,
    Emitter<State> emit,
  ) =>
      super.addItems(event.items);

  void _replace(
    InfiniteListReplaceEvent<ElementType> event,
    Emitter<State> emit,
  ) =>
      super.replace(event.before, event.after, emitter: emit);

  void _replaceAt(
    InfiniteListReplaceAtEvent<ElementType> event,
    Emitter<State> emit,
  ) =>
      super.replaceAt(event.idx, event.item, emitter: emit);

  void _replaceWhere(
    InfiniteListReplaceWhereEvent<ElementType> event,
    Emitter<State> emit,
  ) =>
      super.replaceWhere(event.test, event.willReplacedItemGenerator,
          emitter: emit);

  void _insert(
    InfiniteListInsertEvent<ElementType> event,
    Emitter<State> emit,
  ) =>
      super.insert(event.idx, event.item, emitter: emit);

  void _remove(
    InfiniteListRemoveEvent<ElementType> event,
    Emitter<State> emit,
  ) =>
      super.remove(event.item, emitter: emit);

  void _removeAt(
    InfiniteListRemoveAtEvent<ElementType> event,
    Emitter<State> emit,
  ) =>
      super.removeAt(event.idx, emitter: emit);

  Future<void> _fetchNext(
    InfiniteListFetchNextEvent<ElementType> event,
    Emitter<State> emit,
  ) =>
      fetchNext(emitter: emit);

  void _reset(
    InfiniteListResetEvent<ElementType> event,
    Emitter<State> emit,
  ) =>
      super.reset(emitter: emit);

  Future<void> _reinitialize(
    InfiniteListReinitializeEvent<ElementType> event,
    Emitter<State> emit,
  ) async {
    await fetchNext(reset: true, emitter: emit);
  }
}
