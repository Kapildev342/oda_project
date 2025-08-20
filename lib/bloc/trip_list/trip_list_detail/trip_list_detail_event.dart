part of 'trip_list_detail_bloc.dart';

sealed class TripListDetailsEvent extends Equatable {
  const TripListDetailsEvent();
}

class TripListDetailsInitialEvent extends TripListDetailsEvent {
  const TripListDetailsInitialEvent();

  @override
  List<Object?> get props => [];
}

class TripListDetailsSetStateEvent extends TripListDetailsEvent {
  final bool stillLoading;
  const TripListDetailsSetStateEvent({this.stillLoading=false});

  @override
  List<Object?> get props => [stillLoading];
}

class TripListDetailsFilterEvent extends TripListDetailsEvent {
  const TripListDetailsFilterEvent();

  @override
  List<Object?> get props => [];
}

class TripListDetailsUndoSortedEvent extends TripListDetailsEvent {
  const TripListDetailsUndoSortedEvent();

  @override
  List<Object?> get props => [];
}

class TripListDetailsUnavailableEvent extends TripListDetailsEvent {
  const TripListDetailsUnavailableEvent();

  @override
  List<Object?> get props => [];
}

class TripListDetailsSortedEvent extends TripListDetailsEvent {
  final List<String> controllersList;
  const TripListDetailsSortedEvent({required this.controllersList});
  @override
  List<Object?> get props => [controllersList];
}

class TripListDetailsSessionCloseEvent extends TripListDetailsEvent {
  const TripListDetailsSessionCloseEvent();
  @override
  List<Object?> get props => [];
}

class TripListDetailsTabChangingEvent extends TripListDetailsEvent {
  const TripListDetailsTabChangingEvent();

  @override
  List<Object?> get props => [];
}

class TripListDetailsTimeLineEvent extends TripListDetailsEvent {
  const TripListDetailsTimeLineEvent();

  @override
  List<Object?> get props => [];
}
