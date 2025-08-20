part of 'create_password_bloc.dart';

sealed class CreatePasswordState extends Equatable {
  const CreatePasswordState();
}

final class CreatePasswordLoading extends CreatePasswordState {
  @override
  List<Object> get props => [];
}

final class CreatePasswordLoaded extends CreatePasswordState {
  @override
  List<Object> get props => [];
}

final class CreatePasswordSuccess extends CreatePasswordState {
  @override
  List<Object> get props => [];
}

final class CreatePasswordFailure extends CreatePasswordState {
  final String message;
  const CreatePasswordFailure({required this.message});
  @override
  List<Object> get props => [message];
}

final class CreatePasswordError extends CreatePasswordState {
  @override
  List<Object> get props => [];
}

final class CreatePasswordDummy extends CreatePasswordState {
  @override
  List<Object> get props => [];
}
