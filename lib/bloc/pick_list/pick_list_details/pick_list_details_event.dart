part of 'pick_list_details_bloc.dart';

sealed class PickListDetailsEvent extends Equatable {
  const PickListDetailsEvent();
}

class PickListDetailsInitialEvent extends PickListDetailsEvent {
  const PickListDetailsInitialEvent();

  @override
  List<Object?> get props => [];
}

class PickListDetailsSetStateEvent extends PickListDetailsEvent {
  final bool stillLoading;

  const PickListDetailsSetStateEvent({this.stillLoading = false});

  @override
  List<Object?> get props => [stillLoading];
}

class PickListDetailsTabChangingEvent extends PickListDetailsEvent {
  final bool isLoading;

  const PickListDetailsTabChangingEvent({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class PickListDetailsPickedEvent extends PickListDetailsEvent {
  final List<String> controllersList;

  const PickListDetailsPickedEvent({required this.controllersList});

  @override
  List<Object?> get props => [controllersList];
}

class PickListDetailsUndoPickedEvent extends PickListDetailsEvent {
  const PickListDetailsUndoPickedEvent();

  @override
  List<Object?> get props => [];
}

class PickListDetailsUnavailableEvent extends PickListDetailsEvent {
  const PickListDetailsUnavailableEvent();

  @override
  List<Object?> get props => [];
}

class PickListDetailsSessionCloseEvent extends PickListDetailsEvent {
  const PickListDetailsSessionCloseEvent();

  @override
  List<Object?> get props => [];
}

class PickListDetailsLocationUpdateEvent extends PickListDetailsEvent {
  final String floor;
  final String room;
  final String zone;

  const PickListDetailsLocationUpdateEvent({required this.floor, required this.room, required this.zone});

  @override
  List<Object?> get props => [floor, room, zone];
}

class PickListDetailsCompleteEvent extends PickListDetailsEvent {
  const PickListDetailsCompleteEvent();

  @override
  List<Object?> get props => [];
}

class PickListDetailsRefreshEvent extends PickListDetailsEvent {
  final SocketMessageResponse socketMessage;

  const PickListDetailsRefreshEvent({required this.socketMessage});

  @override
  List<Object?> get props => [socketMessage];
}
