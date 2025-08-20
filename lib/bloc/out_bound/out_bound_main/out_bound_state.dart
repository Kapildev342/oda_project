part of 'out_bound_bloc.dart';

sealed class OutBoundState extends Equatable {
  const OutBoundState();
}

final class OutBoundLoading extends OutBoundState {
  @override
  List<Object> get props => [];
}

final class OutBoundTableLoading extends OutBoundState {
  @override
  List<Object> get props => [];
}

final class OutBoundLoaded extends OutBoundState {
  @override
  List<Object> get props => [];
}

final class OutBoundSuccess extends OutBoundState {
  @override
  List<Object> get props => [];
}

final class OutBoundFailure extends OutBoundState {
  final String message;
  const OutBoundFailure({required this.message});
  @override
  List<Object> get props => [message];
}

final class OutBoundError extends OutBoundState {
  final String message;
  const OutBoundError({required this.message});
  @override
  List<Object> get props => [message];
}

final class OutBoundDummy extends OutBoundState {
  @override
  List<Object> get props => [];
}
