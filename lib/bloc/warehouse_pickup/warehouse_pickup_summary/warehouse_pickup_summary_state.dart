part of 'warehouse_pickup_summary_bloc.dart';

sealed class WarehousePickupSummaryState extends Equatable {
  const WarehousePickupSummaryState();
}

final class WarehousePickupSummaryLoading extends WarehousePickupSummaryState {
  @override
  List<Object> get props => [];
}

final class WarehousePickupSummaryLoaded extends WarehousePickupSummaryState {
  @override
  List<Object> get props => [];
}

final class WarehousePickupSummaryDummy extends WarehousePickupSummaryState {
  @override
  List<Object> get props => [];
}

final class WarehousePickupSummaryDialog extends WarehousePickupSummaryState {
  @override
  List<Object> get props => [];
}

final class WarehousePickupSummaryError extends WarehousePickupSummaryState {
  final String message;
  const WarehousePickupSummaryError({required this.message});
  @override
  List<Object> get props => [message];
}
