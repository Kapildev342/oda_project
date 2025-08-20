part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

final class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

final class HomeLoading extends HomeState {
  @override
  List<Object> get props => [];
}

final class HomeLoaded extends HomeState {
  @override
  List<Object> get props => [];
}

final class HomeSuccess extends HomeState {
  final String message;
  const HomeSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

final class HomeFailure extends HomeState {
  final String errorMessage;
  const HomeFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

final class HomeError extends HomeState {
  @override
  List<Object> get props => [];
}

final class HomeDummy extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeDialogState extends HomeState {
  @override
  List<Object> get props => [];
}
