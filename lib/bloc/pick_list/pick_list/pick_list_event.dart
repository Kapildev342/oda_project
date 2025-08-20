part of 'pick_list_bloc.dart';

sealed class PickListEvent extends Equatable {
  const PickListEvent();
}

class PickListInitialEvent extends PickListEvent {
  //final bool isRefreshing;
  const PickListInitialEvent(/*{required this.isRefreshing}*/);

  @override
  List<Object?> get props => [/*isRefreshing*/];
}

class PickListTabChangingEvent extends PickListEvent {
  final bool isLoading;
  const PickListTabChangingEvent({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class PickListSetStateEvent extends PickListEvent {
  final bool stillLoading;
  const PickListSetStateEvent({this.stillLoading=false});

  @override
  List<Object?> get props => [stillLoading];
}

class PickListLocationChangedEvent extends PickListEvent {
  const PickListLocationChangedEvent();

  @override
  List<Object?> get props => [];
}

class PickListLocalDataAddingEvent extends PickListEvent {
  const PickListLocalDataAddingEvent();

  @override
  List<Object?> get props => [];
}
