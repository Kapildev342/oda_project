part of 'pick_list_bloc.dart';

sealed class PickListState extends Equatable {
  const PickListState();
}

final class PickListLoading extends PickListState {
  @override
  List<Object> get props => [];
}

final class PickListTableLoading extends PickListState {
  @override
  List<Object> get props => [];
}

final class PickListLoaded extends PickListState {
  @override
  List<Object> get props => [];
}

final class PickListSuccess extends PickListState {
  @override
  List<Object> get props => [];
}

final class PickListFailure extends PickListState {
  final String message;
  const PickListFailure({required this.message});
  @override
  List<Object> get props => [message];
}

final class PickListError extends PickListState {
  final String message;
  const PickListError({required this.message});
  @override
  List<Object> get props => [message];
}

final class PickListDummy extends PickListState {
  @override
  List<Object> get props => [];
}

final class PickListDialogState extends PickListState {
  @override
  List<Object> get props => [];
}
