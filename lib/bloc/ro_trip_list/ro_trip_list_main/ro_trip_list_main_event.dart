part of 'ro_trip_list_main_bloc.dart';

sealed class RoTripListMainEvent extends Equatable {
  const RoTripListMainEvent();
}

class RoTripListMainInitialEvent extends RoTripListMainEvent {
  final bool isInitial;
  const RoTripListMainInitialEvent({required this.isInitial});

  @override
  List<Object?> get props => [isInitial];
}

class RoTripListMainSetStateEvent extends RoTripListMainEvent {
  final bool stillLoading;
  const RoTripListMainSetStateEvent({this.stillLoading=false});

  @override
  List<Object?> get props => [stillLoading];
}

class RoTripListMainTabChangingEvent extends RoTripListMainEvent {
  final bool isLoading;
  const RoTripListMainTabChangingEvent({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class RoTripListMainFilterEvent extends RoTripListMainEvent {
  const RoTripListMainFilterEvent();

  @override
  List<Object?> get props => [];
}
