part of 'catch_weight_bloc.dart';

sealed class CatchWeightState extends Equatable {
  const CatchWeightState();
}

final class CatchWeightLoading extends CatchWeightState {
  @override
  List<Object> get props => [];
}

final class CatchWeightLoaded extends CatchWeightState {
  @override
  List<Object> get props => [];
}

final class CatchWeightSuccess extends CatchWeightState {
  final String message;
  const CatchWeightSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

final class CatchWeightFailure extends CatchWeightState {
  @override
  List<Object> get props => [];
}

final class CatchWeightError extends CatchWeightState {
  final String message;
  const CatchWeightError({required this.message});
  @override
  List<Object> get props => [message];
}

final class CatchWeightDummy extends CatchWeightState {
  @override
  List<Object> get props => [];
}
