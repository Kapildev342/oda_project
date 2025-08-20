part of 'ro_trip_list_detail_bloc.dart';

sealed class RoTripListDetailState extends Equatable {
  const RoTripListDetailState();
}

final class RoTripListDetailLoading extends RoTripListDetailState {
  @override
  List<Object> get props => [];
}

final class RoTripListDetailTableLoading extends RoTripListDetailState {
  @override
  List<Object> get props => [];
}

final class RoTripListDetailLoaded extends RoTripListDetailState {
  @override
  List<Object> get props => [];
}

final class RoTripListDetailSuccess extends RoTripListDetailState {
  final String message;
  const RoTripListDetailSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

final class RoTripListDetailFailure extends RoTripListDetailState {
  final String message;
  const RoTripListDetailFailure({required this.message});
  @override
  List<Object> get props => [message];
}

final class RoTripListDetailError extends RoTripListDetailState {
  final String message;
  const RoTripListDetailError({required this.message});
  @override
  List<Object> get props => [message];
}

final class RoTripListDetailDummy extends RoTripListDetailState {
  @override
  List<Object> get props => [];
}

final class RoTripListDetailConfirm extends RoTripListDetailState {
  @override
  List<Object> get props => [];
}
