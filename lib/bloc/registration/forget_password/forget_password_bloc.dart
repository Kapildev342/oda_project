// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/variables.dart';

part 'forget_password_event.dart';
part 'forget_password_state.dart';

class ForgetPasswordBloc extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  ForgetPasswordBloc() : super(ForgetPasswordLoading()) {
    on<ForgetPasswordSetStateEvent>(forgetPasswordSetStateFunction);
    on<ForgetPasswordCallEvent>(forgetPasswordCallFunction);
  }

  FutureOr<void> forgetPasswordSetStateFunction(ForgetPasswordSetStateEvent event, Emitter<ForgetPasswordState> emit) async {
    emit(ForgetPasswordDummy());
    emit(ForgetPasswordLoaded());
  }

  FutureOr<void> forgetPasswordCallFunction(ForgetPasswordCallEvent event, Emitter<ForgetPasswordState> emit) async {
    await getIt<Variables>().repoImpl.getForgetPassword(query: {"login": event.controller.text}, method: "post").onError((error, stackTrace) {
      emit(ForgetPasswordFailure(message: getIt<Variables>().generalVariables.currentLanguage.enterValidLoginId));
      emit(ForgetPasswordLoaded());
    }).then((value) {
      if (value != null) {
        if (value["status"] == "1") {
          getIt<Variables>().generalVariables.tempLoginIdForOtp = event.controller.text;
          getIt<Variables>().generalVariables.tempIdForOtp = value["response"]["id"];
          emit(ForgetPasswordSuccess());
          emit(ForgetPasswordLoaded());
        } else {
          emit(ForgetPasswordFailure(message: getIt<Variables>().generalVariables.currentLanguage.enterValidLoginId));
          emit(ForgetPasswordLoaded());
        }
      }
    });
  }
}
