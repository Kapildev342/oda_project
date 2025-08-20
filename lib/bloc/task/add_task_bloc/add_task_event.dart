part of 'add_task_bloc.dart';

sealed class AddTaskEvent extends Equatable {
  const AddTaskEvent();
}

class AddTaskSetStateEvent extends AddTaskEvent {
  final bool stillLoading;
  const AddTaskSetStateEvent({this.stillLoading=false});

  @override
  List<Object?> get props => [stillLoading];
}
