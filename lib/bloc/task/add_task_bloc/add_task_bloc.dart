
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_task_event.dart';
part 'add_task_state.dart';

class AddTaskBloc extends Bloc<AddTaskEvent, AddTaskState> {
  AddTaskBloc() : super(AddTaskLoading()) {
    on<AddTaskSetStateEvent>(addTaskSetStateFunction);
  }

  FutureOr<void> addTaskSetStateFunction(AddTaskSetStateEvent event, Emitter<AddTaskState> emit)async {
    emit(AddTaskDummy());
    event.stillLoading?emit(AddTaskLoading()): emit(AddTaskLoaded());
  }
}
