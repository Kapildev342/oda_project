part of 'back_to_store_bloc.dart';

sealed class BackToStoreState extends Equatable {
  const BackToStoreState();
}

final class BackToStoreLoading extends BackToStoreState {
  @override
  List<Object> get props => [];
}

final class BackToStoreLoaded extends BackToStoreState {
  @override
  List<Object> get props => [];
}

final class BackToStoreDummy extends BackToStoreState {
  @override
  List<Object> get props => [];
}

final class BackToStoreSuccess extends BackToStoreState {
  final String message;
  const BackToStoreSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

final class BackToStoreFailure extends BackToStoreState {
  final String message;
  const BackToStoreFailure({required this.message});
  @override
  List<Object> get props => [message];
}

final class BackToStoreError extends BackToStoreState {
  final String message;
  const BackToStoreError({required this.message});
  @override
  List<Object> get props => [message];
}
