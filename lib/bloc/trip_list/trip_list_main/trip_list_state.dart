part of 'trip_list_bloc.dart';

sealed class TripListState extends Equatable {
  const TripListState();
}

final class TripListLoading extends TripListState {
  @override
  List<Object> get props => [];
}

final class TripListTableLoading extends TripListState {
  @override
  List<Object> get props => [];
}

final class TripListLoaded extends TripListState {
  @override
  List<Object> get props => [];
}

final class TripListSuccess extends TripListState {
  @override
  List<Object> get props => [];
}

final class TripListFailure extends TripListState {
  final String message;
  const TripListFailure({required this.message});
  @override
  List<Object> get props => [message];
}

final class TripListError extends TripListState {
  final String message;
  const TripListError({required this.message});
  @override
  List<Object> get props => [message];
}

final class TripListDummy extends TripListState {
  @override
  List<Object> get props => [];
}
