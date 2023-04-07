import 'package:bloc/bloc.dart';
import 'package:bloc_infinite_list/src/bloc/infinite_list_state.dart';
import 'package:bloc_infinite_list/src/bloc_base/mutable.dart';
import 'package:bloc_infinite_list/src/bloc_base/queryable.dart';
import 'package:bloc_infinite_list/src/core/types.dart';

abstract class InfiniteListCubit<ElementType,
        State extends InfiniteListState<ElementType, State>>
    extends Cubit<State>
    with
        InfiniteListQueryable<ElementType, State>,
        InfiniteListMutable<ElementType, State> {
  InfiniteListCubit({
    int? limit,
    required PagedSliceFetcher<ElementType, State> fetch,
    required State initialState,
  }) : super(initialState) {
    registerFetch(fetch);
    if (limit != null) {
      registerLimit(limit);
    }
  }
}

class DefaultInfiniteListCubit<T>
    extends InfiniteListCubit<T, DefaultInfiniteListState<T>> {
  DefaultInfiniteListCubit({
    required super.fetch,
    required super.initialState,
    super.limit,
  });

  DefaultInfiniteListCubit.empty({
    required super.fetch,
    super.limit,
  }) : super(
          initialState: DefaultInfiniteListState<T>.empty(),
        );
}
