part of 'create_password_bloc.dart';

sealed class CreatePasswordEvent extends Equatable {
  const CreatePasswordEvent();
}

class CreatePasswordSetStateEvent extends CreatePasswordEvent {
  const CreatePasswordSetStateEvent();

  @override
  List<Object?> get props => [];
}

class ResetPasswordEvent extends CreatePasswordEvent {
  final TextEditingController controller;
  const ResetPasswordEvent({required this.controller});

  @override
  List<Object?> get props => [controller];
}
