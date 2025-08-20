part of 'out_bound_bloc.dart';

sealed class OutBoundEvent extends Equatable {
  const OutBoundEvent();
}

class OutBoundInitialEvent extends OutBoundEvent {
  final bool isInitial;
  const OutBoundInitialEvent({required this.isInitial});

  @override
  List<Object?> get props => [isInitial];
}

class OutBoundSetStateEvent extends OutBoundEvent {
  final bool stillLoading;
  const OutBoundSetStateEvent({this.stillLoading=false});

  @override
  List<Object?> get props => [stillLoading];
}

class OutBoundTabChangingEvent extends OutBoundEvent {
  final bool isLoading;
  const OutBoundTabChangingEvent({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class OutBoundFilterEvent extends OutBoundEvent {
  const OutBoundFilterEvent();

  @override
  List<Object?> get props => [];
}
