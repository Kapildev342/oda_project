part of 'trip_list_entry_bloc.dart';

sealed class TripListEntryEvent extends Equatable {
  const TripListEntryEvent();
}

class TripListEntryInitialEvent extends TripListEntryEvent {
  const TripListEntryInitialEvent();

  @override
  List<Object?> get props => [];
}

class TripListEntrySetStateEvent extends TripListEntryEvent {
  final bool stillLoading;
  const TripListEntrySetStateEvent({this.stillLoading=false});

  @override
  List<Object?> get props => [stillLoading];
}

class TripListEntryTabChangingEvent extends TripListEntryEvent {
  final bool isLoading;
  const TripListEntryTabChangingEvent({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class TripListEntryFilterEvent extends TripListEntryEvent {
  const TripListEntryFilterEvent();
  @override
  List<Object?> get props => [];
}

class TripListEntryTimeLineEvent extends TripListEntryEvent {
  const TripListEntryTimeLineEvent();
  @override
  List<Object?> get props => [];
}
