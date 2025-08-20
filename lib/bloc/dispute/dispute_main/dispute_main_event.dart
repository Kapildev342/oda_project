part of 'dispute_main_bloc.dart';

sealed class DisputeMainEvent extends Equatable {
  const DisputeMainEvent();
}

class DisputeMainInitialEvent extends DisputeMainEvent {
  const DisputeMainInitialEvent();
  @override
  List<Object?> get props => [];
}

class DisputeMainTabChangingEvent extends DisputeMainEvent {
  final bool isLoading;
  const DisputeMainTabChangingEvent({required this.isLoading});
  @override
  List<Object?> get props => [isLoading];
}

class DisputeMainSetStateEvent extends DisputeMainEvent {
  final bool stillLoading;
  const DisputeMainSetStateEvent({this.stillLoading=false});

  @override
  List<Object?> get props => [stillLoading];
}

class DisputeMainUpdateEvent extends DisputeMainEvent {
  final String type;
  const DisputeMainUpdateEvent({required this.type});

  @override
  List<Object?> get props => [type];
}
