import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_infinite_list/src/bloc/infinite_list_state.dart';
import 'package:bloc_infinite_list/src/core/types.dart';
import 'package:bloc_infinite_list/src/model/infinite_list.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

mixin InfiniteListMutable<ElementType,
    State extends InfiniteListState<ElementType, State>> on BlocBase<State> {
  static CancelToken Function() createCancelToken = CancelToken.new;
  static bool Function(Object e)? isErrorCanceled;

  @protected
  int limit = 10;

  @internal
  PagedSliceFetcher<ElementType, State>? fetch;

  @internal
  CancelToken? cancelToken;

  @override
  Future<void> close() async {
    cancelRequest();
    return super.close();
  }

  @internal
  void registerFetch(PagedSliceFetcher<ElementType, State>? fetch) =>
      this.fetch = fetch;

  @protected
  void registerLimit(int limit) => this.limit = limit;

  void cancelRequest() => cancelToken?.cancel();

  void addItem(ElementType item, {Emitter<State>? emitter}) {
    assert(
      this is Cubit || (this is Bloc && emitter != null),
      'You should not use this directly with Bloc. Use triggerAdd() instead.',
    );
    final emitCall = emitter?.call ?? emit;
    emitCall(
      state.copyWith(
        infList: state.infList.addItem(item),
      ),
    );
  }

  void addItems(Iterable<ElementType> items, {Emitter<State>? emitter}) {
    assert(
      this is Cubit || (this is Bloc && emitter != null),
      'You should not use this directly with Bloc. Use triggerAddAll() instead.',
    );
    final emitCall = emitter?.call ?? emit;
    emitCall(
      state.copyWith(
        infList: state.infList.addItems(items),
      ),
    );
  }

  void replace(
    ElementType before,
    ElementType after, {
    Emitter<State>? emitter,
  }) {
    assert(
      this is Cubit || (this is Bloc && emitter != null),
      'You should not use this directly with Bloc. Use triggerReplace() instead.',
    );
    final emitCall = emitter?.call ?? emit;
    emitCall(
      state.copyWith(
        infList: state.infList.replace(before, after),
      ),
    );
  }

  void replaceAt(int idx, ElementType item, {Emitter<State>? emitter}) {
    assert(
      this is Cubit || (this is Bloc && emitter != null),
      'You should not use this directly with Bloc. Use triggerReplaceAt() instead.',
    );
    final emitCall = emitter?.call ?? emit;
    emitCall(
      state.copyWith(
        infList: state.infList.replaceAt(idx, item),
      ),
    );
  }

  void replaceWhere(
    bool Function(ElementType) test,
    ElementType Function(ElementType element) willReplacedItemGenerator, {
    Emitter<State>? emitter,
  }) {
    assert(
      this is Cubit || (this is Bloc && emitter != null),
      'You should not use this directly with Bloc. Use triggerReplaceWhere() instead.',
    );
    final emitCall = emitter?.call ?? emit;
    emitCall(
      state.copyWith(
        infList: state.infList.replaceWhere(test, willReplacedItemGenerator),
      ),
    );
  }

  void insert(int idx, ElementType item, {Emitter<State>? emitter}) {
    assert(
      this is Cubit || (this is Bloc && emitter != null),
      'You should not use this directly with Bloc. Use triggerInsert() instead.',
    );
    final emitCall = emitter?.call ?? emit;
    emitCall(
      state.copyWith(
        infList: state.infList.insert(idx, item),
      ),
    );
  }

  void remove(ElementType item, {Emitter<State>? emitter}) {
    assert(
      this is Cubit || (this is Bloc && emitter != null),
      'You should not use this directly with Bloc. Use triggerRemove() instead.',
    );
    final emitCall = emitter?.call ?? emit;
    emitCall(
      state.copyWith(
        infList: state.infList.remove(item),
      ),
    );
  }

  void removeAt(int idx, {Emitter<State>? emitter}) {
    assert(
      this is Cubit || (this is Bloc && emitter != null),
      'You should not use this directly with Bloc. Use triggerRemoveAt() instead.',
    );
    final emitCall = emitter?.call ?? emit;
    emitCall(
      state.copyWith(
        infList: state.infList.removeAt(idx),
      ),
    );
  }

  void reset({Emitter<State>? emitter}) {
    assert(
      this is Cubit || (this is Bloc && emitter != null),
      'You should not use this directly with Bloc. Use triggerReset() instead.',
    );
    final emitCall = emitter?.call ?? emit;
    cancelRequest();
    emitCall(
      state.copyWith(
        infList: state.infList.reset(),
      ),
    );
  }

  Future<void> fetchNext({bool reset = false, Emitter<State>? emitter}) async {
    assert(
      this is Cubit || (this is Bloc && emitter != null),
      'You should not use this directly with Bloc. Use triggerFetchNext() instead.',
    );
    final emitCall = emitter?.call ?? emit;

    if (state.infList.isFetchNotNeeded && !reset) return;
    emitCall(state.copyWith(infList: state.infList.copyToLoading()));
    cancelToken = createCancelToken();

    try {
      final fetchedResult = await fetch!.call(
        reset ? 0 : state.infList.shouldFetchPage,
        limit,
        cancelToken,
        state,
      );

      if (reset) {
        emitCall(
          state.copyWith(
            infList: InfiniteList.fromSlice(slice: fetchedResult),
          ),
        );
      } else {
        emitCall(
          state.copyWith(
            infList: state.infList.addSlice(fetchedResult),
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(infList: state.infList.copyToLoaded()));
      }
      if (isErrorCanceled?.call(e) ?? false) {
        log('InfiniteList just canceled fetching next content');
      }
      rethrow;
    }
  }

  Future<void> reinitialize({Emitter<State>? emitter}) async {
    assert(
      this is Cubit || (this is Bloc && emitter != null),
      'You should not use this directly with Bloc. Use triggerReinitialize() instead.',
    );
    await fetchNext(reset: true, emitter: emitter);
  }
}
