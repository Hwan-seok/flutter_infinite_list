import 'package:bloc/bloc.dart';
import 'package:infinite_list_bloc/src/bloc/infinite_list_state.dart';
import 'package:infinite_list_bloc/src/bloc_base/mutable.dart';
import 'package:infinite_list_bloc/src/bloc_base/queryable.dart';
import 'package:infinite_list_bloc/src/core/types.dart';

abstract class InfiniteListCubit<ElementType,
        State extends InfiniteListState<ElementType, State>>
    extends Cubit<State>
    with
        InfiniteListQueryable<ElementType, State>,
        InfiniteListMutable<ElementType, State> {
  /// ------------------------------------------------- Constructor

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
