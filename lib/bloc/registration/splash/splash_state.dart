part of 'splash_bloc.dart';

sealed class SplashState extends Equatable {
  const SplashState();
}

class SplashLoading extends SplashState {
  @override
  List<Object> get props => [];
}

class SplashFailure extends SplashState {
  final String message;
  const SplashFailure({required this.message});
  @override
  List<Object> get props => [message];
}

class SplashSuccess extends SplashState {
  @override
  List<Object> get props => [];
}

class SplashLoaded extends SplashState {
  @override
  List<Object> get props => [];
}
