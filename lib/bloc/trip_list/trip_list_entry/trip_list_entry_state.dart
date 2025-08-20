part of 'trip_list_entry_bloc.dart';

sealed class TripListEntryState extends Equatable {
  const TripListEntryState();
}

final class TripListEntryLoading extends TripListEntryState {
  @override
  List<Object> get props => [];
}

final class TripListEntryTableLoading extends TripListEntryState {
  @override
  List<Object> get props => [];
}

final class TripListEntryLoaded extends TripListEntryState {
  @override
  List<Object> get props => [];
}

final class TripListEntryDummy extends TripListEntryState {
  @override
  List<Object> get props => [];
}

final class TripListEntrySuccess extends TripListEntryState {
  @override
  List<Object> get props => [];
}

final class TripListEntryFailure extends TripListEntryState {
  @override
  List<Object> get props => [];
}

final class TripListEntryError extends TripListEntryState {
  @override
  List<Object> get props => [];
}
