part of 'ro_trip_list_detail_bloc.dart';

sealed class RoTripListDetailEvent extends Equatable {
  const RoTripListDetailEvent();
}

class RoTripListDetailInitialEvent extends RoTripListDetailEvent {
  const RoTripListDetailInitialEvent();

  @override
  List<Object?> get props => [];
}

class RoTripListDetailSetStateEvent extends RoTripListDetailEvent {
  final bool stillLoading;
  const RoTripListDetailSetStateEvent({this.stillLoading = false});

  @override
  List<Object?> get props => [stillLoading];
}

class RoTripListDetailTabChangingEvent extends RoTripListDetailEvent {
  final bool isLoading;
  const RoTripListDetailTabChangingEvent({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class RoTripListDetailFilterEvent extends RoTripListDetailEvent {
  const RoTripListDetailFilterEvent();

  @override
  List<Object?> get props => [];
}

class RoTripListDetailWidgetChangingEvent extends RoTripListDetailEvent {
  final String selectedWidget;
  const RoTripListDetailWidgetChangingEvent({required this.selectedWidget});

  @override
  List<Object?> get props => [selectedWidget];
}

class RoTripListDetailCompleteReturnEvent extends RoTripListDetailEvent {
  const RoTripListDetailCompleteReturnEvent();

  @override
  List<Object?> get props => [];
}

class RoTripListDetailAddNewEvent extends RoTripListDetailEvent {
  final bool isEdit;
  const RoTripListDetailAddNewEvent({required this.isEdit});

  @override
  List<Object?> get props => [isEdit];
}

class RoTripListDetailAddNewReturnItemEvent extends RoTripListDetailEvent {
  const RoTripListDetailAddNewReturnItemEvent();

  @override
  List<Object?> get props => [];
}

class RoTripListDetailCompleteReturnItemEvent extends RoTripListDetailEvent {
  const RoTripListDetailCompleteReturnItemEvent();

  @override
  List<Object?> get props => [];
}

class RoTripListDetailUpdateAssetsEvent extends RoTripListDetailEvent {
  const RoTripListDetailUpdateAssetsEvent();

  @override
  List<Object?> get props => [];
}

class RoTripListDetailUpdateCollectedAmountEvent extends RoTripListDetailEvent {
  const RoTripListDetailUpdateCollectedAmountEvent();

  @override
  List<Object?> get props => [];
}
