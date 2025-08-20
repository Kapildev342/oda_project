part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();
}

class TaskInitialEvent extends TaskEvent {
  const TaskInitialEvent();

  @override
  List<Object?> get props => [];
}

class TaskSetStateEvent extends TaskEvent {
  final bool stillLoading;
  const TaskSetStateEvent({this.stillLoading=false});

  @override
  List<Object?> get props => [stillLoading];
}
