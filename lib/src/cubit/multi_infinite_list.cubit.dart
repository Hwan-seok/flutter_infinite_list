import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_infinite_list/src/bloc/infinite_list_state.dart';
import 'package:bloc_infinite_list/src/bloc_base/mutable.dart';
import 'package:bloc_infinite_list/src/core/types.dart';
import 'package:bloc_infinite_list/src/model/infinite_list.dart';
import 'package:bloc_infinite_list/src/model/slice.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

abstract class MultiInfiniteListCubit<KeyType, ElementType,
        State extends MultiInfiniteListState<KeyType, ElementType, State>>
    extends Cubit<State> {
  MultiInfiniteListCubit({
    required State initialState,
  }) : super(initialState);

  @visibleForTesting
  final keyToFetches = <KeyType, PagedSliceFetcher<ElementType, State>>{};

  @visibleForTesting
  final keyToLimits = <KeyType, int>{};

  @visibleForTesting
  final keyToCancelTokens = <KeyType, CancelToken>{};

  void registerFetch(
    KeyType key,
    PagedSliceFetcher<ElementType, State> fetch,
  ) =>
      keyToFetches[key] = fetch;

  void registerLimit(KeyType key, int limit) => keyToLimits[key] = limit;

  void addSlice(KeyType key, Slice<ElementType> slice) {
    final list = state.keysToInfLists[key];
    assert(list != null);
    if (list == null) return;
    emit(
      state.copyWith(
        keysToInfLists: {
          ...state.keysToInfLists,
          key: list.addSlice(slice),
        },
      ),
    );
  }

  Future<void> fetchNext(KeyType key) async {
    final currentList = state.keysToInfLists[key];
    if (currentList == null || currentList.isFetchNotNeeded) return;
    emit(
      state.copyWith(
        keysToInfLists: {
          ...state.keysToInfLists,
          key: currentList.copyToLoading()
        },
      ),
    );
    try {
      final fetch = keyToFetches[key],
          limit = keyToLimits[key],
          list = state.keysToInfLists[key];
      assert(fetch != null, '[$key] registerFetch is missing');
      assert(limit != null, '[$key] registerLimit is missing');
      assert(list != null, '[$key] list is missing');
      if (fetch == null || limit == null || list == null) return;

      final cancelToken =
          keyToCancelTokens[key] = InfiniteListMutable.createCancelToken();
      final fetchedResult = await fetch.call(
        list.shouldFetchPage,
        limit,
        cancelToken,
        state,
      );
      addSlice(key, fetchedResult);
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            keysToInfLists: {
              ...state.keysToInfLists,
              key: state.keysToInfLists[key]!.copyToLoaded(),
            },
          ),
        );
      }
      if (InfiniteListMutable.isErrorCanceled?.call(e) ?? false) {
        return log('InfiniteList just canceled fetching next content');
      }
      rethrow;
    }
  }

  @mustCallSuper
  void reset(KeyType key) {
    keyToCancelTokens[key]?.cancel();
    emit(
      state.copyWith(
        keysToInfLists: {
          ...state.keysToInfLists,
          key: state.keysToInfLists[key]!.reset(),
        },
      ),
    );
  }

  @mustCallSuper
  void resetAll() {
    final keys = state.keysToInfLists.keys;
    for (final token in keyToCancelTokens.values) {
      token.cancel();
    }
    emit(
      state.copyWith(
        keysToInfLists: {
          for (var key in keys) key: const InfiniteList(),
        },
      ),
    );
  }

  @mustCallSuper
  Future<void> reinitialize(KeyType key) async {
    reset(key);
    await fetchNext(key);
  }

  @mustCallSuper
  Future<void> reinitializeAll() async {
    resetAll();
    await Future.wait(state.keysToInfLists.keys.map(fetchNext));
  }
}
