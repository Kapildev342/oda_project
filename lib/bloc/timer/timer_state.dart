part of 'timer_bloc.dart';

sealed class TimerState extends Equatable {
  const TimerState();
}

final class TimerInitial extends TimerState {
  @override
  List<Object> get props => [];
}

final class TimerLoaded extends TimerState {
  @override
  List<Object> get props => [];
}
