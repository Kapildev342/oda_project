part of 'warehouse_pickup_summary_bloc.dart';

sealed class WarehousePickupSummaryEvent extends Equatable {
  const WarehousePickupSummaryEvent();
}

class WarehousePickupSummaryInitialEvent extends WarehousePickupSummaryEvent {
  const WarehousePickupSummaryInitialEvent();

  @override
  List<Object?> get props => [];
}

class WarehousePickupSummarySetStateEvent extends WarehousePickupSummaryEvent {
  final bool stillLoading;
  const WarehousePickupSummarySetStateEvent({this.stillLoading=false});

  @override
  List<Object?> get props => [stillLoading];
}

class WarehousePickupCompleteEvent extends WarehousePickupSummaryEvent {
  final bool isLoading;
  const WarehousePickupCompleteEvent({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}
