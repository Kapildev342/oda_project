part of 'add_task_bloc.dart';

sealed class AddTaskState extends Equatable {
  const AddTaskState();
}

final class AddTaskLoading extends AddTaskState {
  @override
  List<Object> get props => [];
}

final class AddTaskLoaded extends AddTaskState {
  @override
  List<Object> get props => [];
}

final class AddTaskDummy extends AddTaskState {
  @override
  List<Object> get props => [];
}
