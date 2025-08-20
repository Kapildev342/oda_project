part of 'pick_list_details_bloc.dart';

sealed class PickListDetailsState extends Equatable {
  const PickListDetailsState();
}

final class PickListDetailsInitial extends PickListDetailsState {
  @override
  List<Object> get props => [];
}

final class PickListDetailsLoading extends PickListDetailsState {
  @override
  List<Object> get props => [];
}

final class PickListDetailsListLoading extends PickListDetailsState {
  @override
  List<Object> get props => [];
}

final class PickListDetailsLoaded extends PickListDetailsState {
  @override
  List<Object> get props => [];
}

final class PickListDetailsDummy extends PickListDetailsState {
  @override
  List<Object> get props => [];
}

final class PickListDetailsSuccess extends PickListDetailsState {
  final bool isUndo;
  final String message;
  const PickListDetailsSuccess({required this.isUndo,required this.message});
  @override
  List<Object> get props => [isUndo,message];
}

final class PickListDetailsFailure extends PickListDetailsState {
  @override
  List<Object> get props => [];
}

final class PickListDetailsError extends PickListDetailsState {
  final String message;
  const PickListDetailsError({required this.message});
  @override
  List<Object> get props => [message];
}
