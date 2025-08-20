part of 'trip_list_detail_bloc.dart';

sealed class TripListDetailsState extends Equatable {
  const TripListDetailsState();
}

final class TripListDetailsLoading extends TripListDetailsState {
  @override
  List<Object> get props => [];
}

final class TripListDetailsLoaded extends TripListDetailsState {
  @override
  List<Object> get props => [];
}

final class TripListDetailsDummy extends TripListDetailsState {
  @override
  List<Object> get props => [];
}

final class TripListDetailsSuccess extends TripListDetailsState {
  final String message;
  const TripListDetailsSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

final class TripListDetailsFailure extends TripListDetailsState {
  final String message;
  const TripListDetailsFailure({required this.message});
  @override
  List<Object> get props => [message];
}

final class TripListDetailsError extends TripListDetailsState {
  final String message;
  const TripListDetailsError({required this.message});
  @override
  List<Object> get props => [message];
}
