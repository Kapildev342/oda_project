part of 'add_back_to_store_bloc.dart';

sealed class AddBackToStoreState extends Equatable {
  const AddBackToStoreState();
}

final class AddBackToStoreLoading extends AddBackToStoreState {
  @override
  List<Object> get props => [];
}

final class AddBackToStoreLoaded extends AddBackToStoreState {
  @override
  List<Object> get props => [];
}

final class AddBackToStoreDummy extends AddBackToStoreState {
  @override
  List<Object> get props => [];
}

final class AddBackToStoreSuccess extends AddBackToStoreState {
  final String message;
  const AddBackToStoreSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

final class AddBackToStoreFailure extends AddBackToStoreState {
  @override
  List<Object> get props => [];
}

final class AddBackToStoreError extends AddBackToStoreState {
  final String message;
  const AddBackToStoreError({required this.message});
  @override
  List<Object> get props => [message];
}
