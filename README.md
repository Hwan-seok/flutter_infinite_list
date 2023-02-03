
# How to use

## Cubit
### Default state
```dart
class PlayerCubit extends DefaultInfiniteListCubit<Player> {
  PlayerCubit(
    PlayerRepository playerRepository,
  ) : super(
    initialState: DefaultInfiniteListState(),
    fetch: (page, size, cancelToken, state) => 
                                  playerRepository.getAll(
                                    page: page,
                                    size: size,
                                    cancelToken: cancelToken,
                                  ),
    );
}
```

### Custom state
```dart
class PlayerState extends InfiniteListState<Player, PlayerState> {
  final int id;

  PlayerState({
    super.infList,
    required this.id,
  });

  ...
}

class PlayerCubit extends InfiniteListCubit<Player, PlayerState> {
  PlayerCubit(
    PlayerRepository playerRepository,
  ) : super(
    initialState: DefaultInfiniteListState(),
    fetch: (page, size, cancelToken, state) => 
                                  playerRepository.getAll(
                                    page: page,
                                    size: size,
                                    cancelToken: cancelToken,
                                  ),
    );
}
```

## Bloc

### Default event & state

```dart
class FoodBloc extends DefaultInfiniteListBloc<Food> {
    ...same as cubit
}

add(InfiniteListEvent.fetchNext());
```

### Custom event & state

```dart

abstract class FoodEvent extends InfiniteListEvent<Food> {
  const FoodEvent();
}

abstract class FoodEventHadForLaunch extends InfiniteListEvent<Food> {
  const FoodEventHadForLaunch();
}

---

class FoodBloc extends InfiniteListBloc<Food, FoodEvent, FoodState> {
  FoodBloc(){
    ... other default events are automatically registered by library.
    on<FoodEventHadForLaunch>(_onHadForLaunch)
  }

  _onHadForLaunch(event, emit);
}

add(InfiniteListEvent.fetchNext());
add(FoodEventHadForLaunch());
```
