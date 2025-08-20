part of 'out_bound_entry_bloc.dart';

sealed class OutBoundEntryState extends Equatable {
  const OutBoundEntryState();
}

final class OutBoundEntryLoading extends OutBoundEntryState {
  @override
  List<Object> get props => [];
}

final class OutBoundEntryTableLoading extends OutBoundEntryState {
  @override
  List<Object> get props => [];
}

final class OutBoundEntryLoaded extends OutBoundEntryState {
  @override
  List<Object> get props => [];
}

final class OutBoundEntryDummy extends OutBoundEntryState {
  @override
  List<Object> get props => [];
}

final class OutBoundEntrySuccess extends OutBoundEntryState {
  @override
  List<Object> get props => [];
}

final class OutBoundEntryFailure extends OutBoundEntryState {
  @override
  List<Object> get props => [];
}

final class OutBoundEntryError extends OutBoundEntryState {
  @override
  List<Object> get props => [];
}
