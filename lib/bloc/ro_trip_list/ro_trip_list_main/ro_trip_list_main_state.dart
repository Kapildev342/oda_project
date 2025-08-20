part of 'ro_trip_list_main_bloc.dart';

sealed class RoTripListMainState extends Equatable {
  const RoTripListMainState();
}

final class RoTripListMainLoading extends RoTripListMainState {
  @override
  List<Object> get props => [];
}

final class RoTripListMainTableLoading extends RoTripListMainState {
  @override
  List<Object> get props => [];
}

final class RoTripListMainLoaded extends RoTripListMainState {
  @override
  List<Object> get props => [];
}

final class RoTripListMainSuccess extends RoTripListMainState {
  @override
  List<Object> get props => [];
}

final class RoTripListMainFailure extends RoTripListMainState {
  final String message;
  const RoTripListMainFailure({required this.message});
  @override
  List<Object> get props => [message];
}

final class RoTripListMainError extends RoTripListMainState {
  final String message;
  const RoTripListMainError({required this.message});
  @override
  List<Object> get props => [message];
}

final class RoTripListMainDummy extends RoTripListMainState {
  @override
  List<Object> get props => [];
}
