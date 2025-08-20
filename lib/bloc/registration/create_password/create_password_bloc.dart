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

part 'create_password_event.dart';
part 'create_password_state.dart';

class CreatePasswordBloc extends Bloc<CreatePasswordEvent, CreatePasswordState> {
  bool loader = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isVisible = true;
  bool isConfirmVisible = true;
  bool isPasswordEmpty = false;
  bool isPasswordNotValid = false;
  bool isPasswordNotMatched = false;

  CreatePasswordBloc() : super(CreatePasswordLoading()) {
    on<CreatePasswordSetStateEvent>(createPasswordSetStateFunction);
    on<ResetPasswordEvent>(resetPasswordFunction);
  }

  FutureOr<void> createPasswordSetStateFunction(CreatePasswordSetStateEvent event, Emitter<CreatePasswordState> emit) {
    emit(CreatePasswordDummy());
    emit(CreatePasswordLoaded());
  }

  FutureOr<void> resetPasswordFunction(ResetPasswordEvent event, Emitter<CreatePasswordState> emit) async {
    await getIt<Variables>().repoImpl.getCreatePassword(query: {
      "id": getIt<Variables>().generalVariables.tempIdForOtp,
      "password": event.controller.text,
    }, method: "post").onError((error, stackTrace) {
      emit(CreatePasswordFailure(message: error.toString()));
      emit(CreatePasswordLoaded());
    }).then((value) {
      if (value != null) {
        if (value["status"] == "1") {
          emit(CreatePasswordSuccess());
          emit(CreatePasswordLoaded());
        } else {
          emit(CreatePasswordFailure(message: value["response"]??getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(CreatePasswordLoaded());
        }
      }
    });
  }
}
