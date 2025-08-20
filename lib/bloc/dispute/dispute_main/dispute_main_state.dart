part of 'dispute_main_bloc.dart';

sealed class DisputeMainState extends Equatable {
  const DisputeMainState();
}

final class DisputeMainLoading extends DisputeMainState {
  @override
  List<Object> get props => [];
}

final class DisputeMainLoaded extends DisputeMainState {
  @override
  List<Object> get props => [];
}

final class DisputeMainSuccess extends DisputeMainState {
  final String message;
  const DisputeMainSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

final class DisputeMainFailure extends DisputeMainState {
  @override
  List<Object> get props => [];
}

final class DisputeMainError extends DisputeMainState {
  final String message;
  const DisputeMainError({required this.message});
  @override
  List<Object> get props => [message];
}

final class DisputeMainDummy extends DisputeMainState {
  @override
  List<Object> get props => [];
}
