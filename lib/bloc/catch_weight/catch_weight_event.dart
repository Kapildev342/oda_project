part of 'catch_weight_bloc.dart';

sealed class CatchWeightEvent extends Equatable {
  const CatchWeightEvent();
}

class CatchWeightInitialEvent extends CatchWeightEvent {
  const CatchWeightInitialEvent();

  @override
  List<Object?> get props => [];
}

class CatchWeightSetStateEvent extends CatchWeightEvent {
  final bool stillLoading;
  const CatchWeightSetStateEvent({this.stillLoading=false});

  @override
  List<Object?> get props => [stillLoading];
}

class CatchWeightUpdateEvent extends CatchWeightEvent {
  final bool isAvailable;
  const CatchWeightUpdateEvent({required this.isAvailable});

  @override
  List<Object?> get props => [isAvailable];
}

class CatchWeightUndoEvent extends CatchWeightEvent {
  const CatchWeightUndoEvent();

  @override
  List<Object?> get props => [];
}

class CatchWeightTabChangingEvent extends CatchWeightEvent {
  final bool isLoading;
  const CatchWeightTabChangingEvent({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class CatchWeightRefreshEvent extends CatchWeightEvent {
  final SocketMessageResponse socketMessage;
  const CatchWeightRefreshEvent({required this.socketMessage});

  @override
  List<Object?> get props => [socketMessage];
}
