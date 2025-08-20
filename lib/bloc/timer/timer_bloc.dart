// Dart imports:
import 'dart:async';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc() : super(TimerInitial()) {
    on<TimerInitialEvent>(timerInitialFunction);
  }

  FutureOr<void>timerInitialFunction(TimerInitialEvent event, Emitter<TimerState> emit)async{
    emit(TimerInitial());
    emit(TimerLoaded());
  }
}
