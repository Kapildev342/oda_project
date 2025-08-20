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

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc() : super(OtpLoaded()) {
    on<OtpValidateEvent>(otpValidateFunction);
    on<OtpSetStateEvent>(otpSetStateFunction);
    on<OtpResendEvent>(otpResendFunction);
  }

  FutureOr<void> otpValidateFunction(OtpValidateEvent event, Emitter<OtpState> emit) async {
    await getIt<Variables>().repoImpl.getValidateOtp(query: {"otp": event.controller.text, "id": getIt<Variables>().generalVariables.tempIdForOtp}, method: "post").onError((error, stackTrace) {
      emit(OtpFailure(message: error.toString()));
      emit(OtpLoaded());
    }).then((value) {
      if (value != null) {
        if (value["status"] == "1") {
          emit(OtpSuccess());
          emit(OtpLoaded());
        } else {
          emit(OtpFailure(message: value["response"]));
          emit(OtpLoaded());
        }
      }
    });
  }

  FutureOr<void> otpSetStateFunction(OtpSetStateEvent event, Emitter<OtpState> emit) {
    emit(OtpDummy());
    emit(OtpLoaded());
  }

  FutureOr<void> otpResendFunction(OtpResendEvent event, Emitter<OtpState> emit) async {
    await getIt<Variables>().repoImpl.getForgetPassword(query: {"login": getIt<Variables>().generalVariables.tempLoginIdForOtp}, method: "post").onError((error, stackTrace) {
      emit(OtpFailure(message: error.toString()));
      emit(OtpLoaded());
    }).then((value) {
      if (value != null) {
        if (value["status"] == "1") {
          getIt<Variables>().generalVariables.tempIdForOtp = value["response"]["id"];
          emit(OtpFailure(message: value["response"]["message"]??getIt<Variables>().generalVariables.currentLanguage.pleaseEnterOtp));
          emit(OtpLoaded());
        } else {
          emit(OtpFailure(message: value["response"]??getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(OtpLoaded());
        }
      }
    });
  }
}
