part of 'warehouse_pickup_bloc.dart';

sealed class WarehousePickupState extends Equatable {
  const WarehousePickupState();
}

final class WarehousePickupLoading extends WarehousePickupState {
  @override
  List<Object> get props => [];
}

final class WarehousePickupTableLoading extends WarehousePickupState {
  @override
  List<Object> get props => [];
}

final class WarehousePickupLoaded extends WarehousePickupState {
  @override
  List<Object> get props => [];
}

final class WarehousePickupDummy extends WarehousePickupState {
  @override
  List<Object> get props => [];
}

final class WarehousePickupSuccess extends WarehousePickupState {
  @override
  List<Object> get props => [];
}

final class WarehousePickupFailure extends WarehousePickupState {
  @override
  List<Object> get props => [];
}

final class WarehousePickupError extends WarehousePickupState {
  final String message;
  const WarehousePickupError({required this.message});
  @override
  List<Object> get props => [message];
}
