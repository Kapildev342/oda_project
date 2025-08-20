
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  bool searchBarEnabled=false;
  TaskBloc() : super(TaskLoading()) {
    on<TaskInitialEvent>(taskInitialFunction);
    on<TaskSetStateEvent>(taskSetStateFunction);
  }

  FutureOr<void> taskSetStateFunction(TaskSetStateEvent event, Emitter<TaskState> emit) async{
    emit(TaskDummy());
    event.stillLoading?emit(TaskLoading()):emit(TaskLoaded());
  }

  FutureOr<void> taskInitialFunction(TaskInitialEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    emit(TaskLoaded());
  }
}
