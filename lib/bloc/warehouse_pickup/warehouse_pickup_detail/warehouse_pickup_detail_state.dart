part of 'warehouse_pickup_detail_bloc.dart';

sealed class WarehousePickupDetailState extends Equatable {
  const WarehousePickupDetailState();
}

final class WarehousePickupDetailLoading extends WarehousePickupDetailState {
  @override
  List<Object> get props => [];
}

final class WarehousePickupDetailLoaded extends WarehousePickupDetailState {
  @override
  List<Object> get props => [];
}

final class WarehousePickupDetailDummy extends WarehousePickupDetailState {
  @override
  List<Object> get props => [];
}

final class WarehousePickupDetailSuccess extends WarehousePickupDetailState {
  final String message;
  const WarehousePickupDetailSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

final class WarehousePickupDetailFailure extends WarehousePickupDetailState {
  @override
  List<Object> get props => [];
}

final class WarehousePickupDetailError extends WarehousePickupDetailState {
  final String message;
  const WarehousePickupDetailError({required this.message});
  @override
  List<Object> get props => [message];
}
