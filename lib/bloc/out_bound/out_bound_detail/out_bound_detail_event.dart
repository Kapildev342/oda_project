part of 'out_bound_detail_bloc.dart';

sealed class OutBoundDetailEvent extends Equatable {
  const OutBoundDetailEvent();
}

class OutBoundDetailInitialEvent extends OutBoundDetailEvent {
  const OutBoundDetailInitialEvent();

  @override
  List<Object?> get props => [];
}

class OutBoundDetailSetStateEvent extends OutBoundDetailEvent {
  final bool stillLoading;
  const OutBoundDetailSetStateEvent({this.stillLoading=false});

  @override
  List<Object?> get props => [stillLoading];
}

class OutBoundDetailFilterEvent extends OutBoundDetailEvent {
  const OutBoundDetailFilterEvent();

  @override
  List<Object?> get props => [];
}

class OutBoundDetailUndoSortedEvent extends OutBoundDetailEvent {
  const OutBoundDetailUndoSortedEvent();

  @override
  List<Object?> get props => [];
}

class OutBoundDetailUnavailableEvent extends OutBoundDetailEvent {
  const OutBoundDetailUnavailableEvent();

  @override
  List<Object?> get props => [];
}

class OutBoundDetailSortedEvent extends OutBoundDetailEvent {
  final List<String> controllersList;
  const OutBoundDetailSortedEvent({required this.controllersList});
  @override
  List<Object?> get props => [controllersList];
}

class OutBoundDetailSessionCloseEvent extends OutBoundDetailEvent {
  const OutBoundDetailSessionCloseEvent();
  @override
  List<Object?> get props => [];
}

class OutBoundDetailTabChangingEvent extends OutBoundDetailEvent {
  const OutBoundDetailTabChangingEvent();

  @override
  List<Object?> get props => [];
}

class OutBoundDetailTimeLineEvent extends OutBoundDetailEvent {
  const OutBoundDetailTimeLineEvent();

  @override
  List<Object?> get props => [];
}
