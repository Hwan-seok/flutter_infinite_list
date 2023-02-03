import 'package:bloc/bloc.dart';
import 'package:bloc_infinite_list/src/bloc/infinite_list_state.dart';
import 'package:collection/collection.dart';

mixin InfiniteListQueryable<ElementType,
    State extends InfiniteListState<ElementType, State>> on BlocBase<State> {
  ElementType operator [](int index) => state.infList[index];

  int indexOf(ElementType item) => state.infList.indexOf(item);

  int indexWhere(bool Function(ElementType item) test) =>
      state.infList.indexWhere(test);

  Iterable<ElementType> where(bool Function(ElementType item) test) =>
      state.infList.where(test);

  ElementType? singleWhereOrNull(bool Function(ElementType item) test) =>
      state.infList.items.singleWhereOrNull(test);

  bool containsWhere(bool Function(ElementType item) test) =>
      singleWhereOrNull(test) != null;

  bool contains(ElementType item) => state.infList.items.contains(item);
}
