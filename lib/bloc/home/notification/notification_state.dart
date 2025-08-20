part of 'notification_bloc.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();
}

final class NotificationInitial extends NotificationState {
  @override
  List<Object> get props => [];
}

final class NotificationLoading extends NotificationState {
  @override
  List<Object> get props => [];
}

final class NotificationLoaded extends NotificationState {
  @override
  List<Object> get props => [];
}

final class NotificationSuccess extends NotificationState {
  final String message;
  const NotificationSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

final class NotificationFailure extends NotificationState {
  final String errorMessage;
  const NotificationFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

final class NotificationError extends NotificationState {
  @override
  List<Object> get props => [];
}

final class NotificationDummy extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationDialogState extends NotificationState {
  @override
  List<Object> get props => [];
}
