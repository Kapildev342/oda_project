part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeInitialEvent extends HomeEvent {
  const HomeInitialEvent();

  @override
  List<Object?> get props => [];
}

class HomeSetStateEvent extends HomeEvent {
  final bool stillLoading;
  const HomeSetStateEvent({this.stillLoading=false});

  @override
  List<Object?> get props => [stillLoading];
}
