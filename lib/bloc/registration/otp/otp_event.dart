part of 'otp_bloc.dart';

sealed class OtpEvent extends Equatable {
  const OtpEvent();
}

class OtpValidateEvent extends OtpEvent {
  final TextEditingController controller;
  const OtpValidateEvent({required this.controller});

  @override
  List<Object?> get props => [controller];
}

class OtpSetStateEvent extends OtpEvent {
  const OtpSetStateEvent();

  @override
  List<Object?> get props => [];
}

class OtpResendEvent extends OtpEvent {
  const OtpResendEvent();

  @override
  List<Object?> get props => [];
}
