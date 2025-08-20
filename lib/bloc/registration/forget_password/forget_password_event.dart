part of 'forget_password_bloc.dart';

sealed class ForgetPasswordEvent extends Equatable {
  const ForgetPasswordEvent();
}

class ForgetPasswordSetStateEvent extends ForgetPasswordEvent {
  const ForgetPasswordSetStateEvent();

  @override
  List<Object?> get props => [];
}

class ForgetPasswordCallEvent extends ForgetPasswordEvent {
  final TextEditingController controller;
  const ForgetPasswordCallEvent({required this.controller});

  @override
  List<Object?> get props => [controller];
}
