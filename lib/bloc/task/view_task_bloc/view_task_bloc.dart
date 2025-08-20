
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'view_task_event.dart';
part 'view_task_state.dart';

class ViewTaskBloc extends Bloc<ViewTaskEvent, ViewTaskState> {
  ViewTaskBloc() : super(ViewTaskLoading()) {
    on<ViewTaskSetStateEvent>(viewTaskSetStateFunction);
  }

  FutureOr<void> viewTaskSetStateFunction(ViewTaskSetStateEvent event, Emitter<ViewTaskState> emit)async {
    emit(ViewTaskDummy());
    event.stillLoading?emit(ViewTaskLoading()): emit(ViewTaskLoaded());
  }
}
