part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();
}

class LoginDialogState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoaded extends LoginState {
  const LoginLoaded();
  @override
  List<Object> get props => [];
}

class LoginDummy extends LoginState {
  const LoginDummy();
  @override
  List<Object> get props => [];
}

class LoginSuccess extends LoginState {
  const LoginSuccess();
  @override
  List<Object> get props => [];
}

class LoginFailure extends LoginState {
  final String message;
  const LoginFailure({required this.message});
  @override
  List<Object> get props => [message];
}

class LoginError extends LoginState {
  const LoginError();
  @override
  List<Object> get props => [];
}
