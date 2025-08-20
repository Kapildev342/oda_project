part of 'splash_bloc.dart';

sealed class SplashEvent extends Equatable {
  const SplashEvent();
}

class SplashInitialEvent extends SplashEvent {
  const SplashInitialEvent();

  @override
  List<Object?> get props => [];
}
