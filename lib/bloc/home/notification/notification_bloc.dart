// Dart imports:
import 'dart:async';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<NotificationInitialEvent>(notificationInitialFunction);
    on<NotificationSetStateEvent>(notificationSetStateFunction);
  }

  FutureOr<void> notificationInitialFunction(NotificationInitialEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    emit(NotificationLoaded());
  }

  FutureOr<void> notificationSetStateFunction(NotificationSetStateEvent event, Emitter<NotificationState> emit) async{
    emit(NotificationDummy());
    event.stillLoading?emit(NotificationLoading()):emit(NotificationLoaded());
  }
}
