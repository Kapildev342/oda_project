part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class NotificationInitialEvent extends NotificationEvent {
  const NotificationInitialEvent();

  @override
  List<Object?> get props => [];
}

class NotificationSetStateEvent extends NotificationEvent {
  final bool stillLoading;
  const NotificationSetStateEvent({this.stillLoading=false});

  @override
  List<Object?> get props => [stillLoading];
}
