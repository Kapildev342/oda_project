part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();
}

final class TaskLoading extends TaskState {
  @override
  List<Object> get props => [];
}

final class TaskLoaded extends TaskState {
  @override
  List<Object> get props => [];
}

final class TaskDummy extends TaskState {
  @override
  List<Object> get props => [];
}
