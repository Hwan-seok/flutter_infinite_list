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

  @internal
  void registerLimit(int limit) => this.limit = limit;

  void cancelRequest() => cancelToken?.cancel();

  @internal
  void addItem(ElementType item, {Emitter<State>? emitter}) {
    final emitCall = emitter?.call ?? emit;
    emitCall(
      state.copyWith(
        infList: state.infList.addItem(item),
      ),
    );
  }

  @internal
  void addItems(Iterable<ElementType> items, {Emitter<State>? emitter}) {
    final emitCall = emitter?.call ?? emit;
    emitCall(
      state.copyWith(
        infList: state.infList.addItems(items),
      ),
    );
  }

  @internal
  void replace(
    ElementType before,
    ElementType after, {
    Emitter<State>? emitter,
  }) {
    final emitCall = emitter?.call ?? emit;
    emitCall(
      state.copyWith(
        infList: state.infList.replace(before, after),
      ),
    );
  }

  @internal
  void replaceAt(int idx, ElementType item, {Emitter<State>? emitter}) {
    final emitCall = emitter?.call ?? emit;
    emitCall(
      state.copyWith(
        infList: state.infList.replaceAt(idx, item),
      ),
    );
  }

  @internal
  void replaceWhere(
    bool Function(ElementType) test,
    ElementType Function(ElementType element) willReplacedItemGenerator, {
    Emitter<State>? emitter,
  }) {
    final emitCall = emitter?.call ?? emit;
    emitCall(
      state.copyWith(
        infList: state.infList.replaceWhere(test, willReplacedItemGenerator),
      ),
    );
  }

  @internal
  void insert(int idx, ElementType item, {Emitter<State>? emitter}) {
    final emitCall = emitter?.call ?? emit;
    emitCall(
      state.copyWith(
        infList: state.infList.insert(idx, item),
      ),
    );
  }

  @internal
  void remove(ElementType item, {Emitter<State>? emitter}) {
    final emitCall = emitter?.call ?? emit;
    emitCall(
      state.copyWith(
        infList: state.infList.remove(item),
      ),
    );
  }

  @internal
  void removeAt(int idx, {Emitter<State>? emitter}) {
    final emitCall = emitter?.call ?? emit;
    emitCall(
      state.copyWith(
        infList: state.infList.removeAt(idx),
      ),
    );
  }

  @internal
  void reset({Emitter<State>? emitter}) {
    final emitCall = emitter?.call ?? emit;
    cancelRequest();
    emitCall(
      state.copyWith(
        infList: state.infList.reset(),
      ),
    );
  }

  @internal
  Future<void> fetchNext({bool reset = false, Emitter<State>? emitter}) async {
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

  @internal
  Future<void> reinitialize({Emitter<State>? emitter}) async {
    await fetchNext(reset: true, emitter: emitter);
  }
}
