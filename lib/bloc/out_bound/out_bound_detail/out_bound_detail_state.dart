part of 'out_bound_detail_bloc.dart';

sealed class OutBoundDetailState extends Equatable {
  const OutBoundDetailState();
}

final class OutBoundDetailLoading extends OutBoundDetailState {
  @override
  List<Object> get props => [];
}

final class OutBoundDetailLoaded extends OutBoundDetailState {
  @override
  List<Object> get props => [];
}

final class OutBoundDetailDummy extends OutBoundDetailState {
  @override
  List<Object> get props => [];
}

final class OutBoundDetailSuccess extends OutBoundDetailState {
  final String message;
  const OutBoundDetailSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

final class OutBoundDetailFailure extends OutBoundDetailState {
  final String message;
  const OutBoundDetailFailure({required this.message});
  @override
  List<Object> get props => [message];
}

final class OutBoundDetailError extends OutBoundDetailState {
  final String message;
  const OutBoundDetailError({required this.message});
  @override
  List<Object> get props => [message];
}
