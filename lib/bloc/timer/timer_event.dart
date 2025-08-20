part of 'timer_bloc.dart';

sealed class TimerEvent extends Equatable {
  const TimerEvent();
}

class TimerInitialEvent extends TimerEvent {
  const TimerInitialEvent();

  @override
  List<Object?> get props => [];
}
