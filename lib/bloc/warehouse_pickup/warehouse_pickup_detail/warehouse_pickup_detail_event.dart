part of 'warehouse_pickup_detail_bloc.dart';

sealed class WarehousePickupDetailEvent extends Equatable {
  const WarehousePickupDetailEvent();
}

class WarehousePickupDetailInitialEvent extends WarehousePickupDetailEvent {
  const WarehousePickupDetailInitialEvent();

  @override
  List<Object?> get props => [];
}

class WarehousePickupDetailSetStateEvent extends WarehousePickupDetailEvent {
  final bool stillLoading;
  const WarehousePickupDetailSetStateEvent({this.stillLoading=false});

  @override
  List<Object?> get props => [stillLoading];
}

class WarehousePickupDetailTabChangingEvent extends WarehousePickupDetailEvent {
  final bool isLoading;
  const WarehousePickupDetailTabChangingEvent({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class WarehousePickupDetailFilterEvent extends WarehousePickupDetailEvent {
  const WarehousePickupDetailFilterEvent();

  @override
  List<Object?> get props => [];
}

class WarehousePickupDetailDeliveredEvent extends WarehousePickupDetailEvent {
  const WarehousePickupDetailDeliveredEvent();

  @override
  List<Object?> get props => [];
}

class WarehousePickupDetailUndoDeliveredEvent extends WarehousePickupDetailEvent {
  const WarehousePickupDetailUndoDeliveredEvent();

  @override
  List<Object?> get props => [];
}

class WarehousePickupDetailUnavailableEvent extends WarehousePickupDetailEvent {
  const WarehousePickupDetailUnavailableEvent();

  @override
  List<Object?> get props => [];
}
