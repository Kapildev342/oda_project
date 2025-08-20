part of 'out_bound_entry_bloc.dart';

sealed class OutBoundEntryEvent extends Equatable {
  const OutBoundEntryEvent();
}

class OutBoundEntryInitialEvent extends OutBoundEntryEvent {
  const OutBoundEntryInitialEvent();

  @override
  List<Object?> get props => [];
}

class OutBoundEntrySetStateEvent extends OutBoundEntryEvent {
  final bool stillLoading;
  const OutBoundEntrySetStateEvent({this.stillLoading=false});

  @override
  List<Object?> get props => [stillLoading];
}

class OutBoundEntryTabChangingEvent extends OutBoundEntryEvent {
  final bool isLoading;
  const OutBoundEntryTabChangingEvent({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class OutBoundEntryFilterEvent extends OutBoundEntryEvent {
  const OutBoundEntryFilterEvent();
  @override
  List<Object?> get props => [];
}

class OutBoundEntryTimeLineEvent extends OutBoundEntryEvent {
  const OutBoundEntryTimeLineEvent();
  @override
  List<Object?> get props => [];
}
