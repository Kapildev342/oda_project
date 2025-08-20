part of 'warehouse_pickup_bloc.dart';

sealed class WarehousePickupEvent extends Equatable {
  const WarehousePickupEvent();
}

class WarehousePickupInitialEvent extends WarehousePickupEvent {
  const WarehousePickupInitialEvent();

  @override
  List<Object?> get props => [];
}

class WarehousePickupSetStateEvent extends WarehousePickupEvent {
  final bool stillLoading;
  const WarehousePickupSetStateEvent({this.stillLoading=false});

  @override
  List<Object?> get props => [stillLoading];
}

class WarehousePickupTabChangingEvent extends WarehousePickupEvent {
  final bool isLoading;
  const WarehousePickupTabChangingEvent({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class WarehousePickupFilterEvent extends WarehousePickupEvent {
  const WarehousePickupFilterEvent();
  @override
  List<Object?> get props => [];
}
