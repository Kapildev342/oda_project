part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginInitialEvent extends LoginEvent {
  const LoginInitialEvent();

  @override
  List<Object?> get props => [];
}

class LoginSetStateEvent extends LoginEvent {
  const LoginSetStateEvent();

  @override
  List<Object?> get props => [];
}

class LoginButtonEvent extends LoginEvent {
  final String userId;
  final String password;
  const LoginButtonEvent({required this.userId, required this.password});

  @override
  List<Object?> get props => [userId, password];
}
