part of 'trip_list_bloc.dart';

sealed class TripListEvent extends Equatable {
  const TripListEvent();
}

class TripListInitialEvent extends TripListEvent {
  final bool isInitial;
  const TripListInitialEvent({required this.isInitial});

  @override
  List<Object?> get props => [isInitial];
}

class TripListSetStateEvent extends TripListEvent {
  final bool stillLoading;
  const TripListSetStateEvent({this.stillLoading=false});

  @override
  List<Object?> get props => [stillLoading];
}

class TripListTabChangingEvent extends TripListEvent {
  final bool isLoading;
  const TripListTabChangingEvent({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class TripListFilterEvent extends TripListEvent {
  const TripListFilterEvent();

  @override
  List<Object?> get props => [];
}

class CsvUploadEvent extends TripListEvent {
  const CsvUploadEvent();

  @override
  List<Object?> get props => [];
}
