# bloc_infinite_list

# Motivation

As a `flutter_bloc` user, you may have some experience about struggling with boilerplate especially to `list`.
Various of apps are have infinite list scrolling features in their app.  Even though every applications are have different business requirements, infinite list from all of them are built by just three main points. 

1. Having a list
2. Query item(s) from the list
3. Mutate item(s) from the list

But we always build them manually from the scratch😂. This is incredibly time-consuming and wasting the time.
Also, the methods you made every day could have some bugs if you don't thoroughly test them.

To solve those annoying problems, **`bloc_infinite_list`** made a various features for you!

> Tell your **PM** that the scrolling feature would be take intensive time and have your own time drinking coffee😎.


## Examples
This repo contains basic example app in the [example](https://github.com/Hwan-seok/flutter_infinite_list/tree/main/example) folder.


## Installation

```dart
dependencies:
  bloc_infinite_list: ^0.6.0
```



# Usage

## Cubit
### Default state
```dart
class PlayerCubit extends DefaultInfiniteListCubit<Player> {
  PlayerCubit(
    PlayerRepository playerRepository,
  ) : super(
    initialState: DefaultInfiniteListState(),
    fetch: (page, size, state, cancelToken) => 
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
    fetch: (page, size, state, cancelToken) => 
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
