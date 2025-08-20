part of 'otp_bloc.dart';

sealed class OtpState extends Equatable {
  const OtpState();
}

final class OtpLoading extends OtpState {
  @override
  List<Object> get props => [];
}

final class OtpLoaded extends OtpState {
  @override
  List<Object> get props => [];
}

final class OtpSuccess extends OtpState {
  @override
  List<Object> get props => [];
}

final class OtpFailure extends OtpState {
  final String message;
  const OtpFailure({required this.message});
  @override
  List<Object> get props => [message];
}

final class OtpError extends OtpState {
  @override
  List<Object> get props => [];
}

final class OtpDummy extends OtpState {
  @override
  List<Object> get props => [];
}
