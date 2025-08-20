part of 'view_task_bloc.dart';

sealed class ViewTaskEvent extends Equatable {
  const ViewTaskEvent();
}

class ViewTaskSetStateEvent extends ViewTaskEvent {
  final bool stillLoading;
  const ViewTaskSetStateEvent({this.stillLoading=false});

  @override
  List<Object?> get props => [stillLoading];
}
