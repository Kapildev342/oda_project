part of 'view_task_bloc.dart';

sealed class ViewTaskState extends Equatable {
  const ViewTaskState();
}

final class ViewTaskLoading extends ViewTaskState {
  @override
  List<Object> get props => [];
}
final class ViewTaskLoaded extends ViewTaskState {
  @override
  List<Object> get props => [];
}
final class ViewTaskDummy extends ViewTaskState {
  @override
  List<Object> get props => [];
}
