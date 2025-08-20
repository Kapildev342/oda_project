// ignore_for_file: unused_import

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:oda/local_database/pick_list_box/pick_list.dart';
import 'package:oda/local_database/trip_box/trip_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:oda/local_database/language_box/language.dart';
import 'package:oda/local_database/user_box/user.dart';
import 'package:oda/repository_model/general/general_variables.dart';
import 'package:oda/repository_model/general/initial_function_response_model.dart';
import 'package:oda/repository_model/general/languages.dart';
import 'package:oda/repository_model/settings/profile_response_model.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/rabbit_service.dart';
import 'package:oda/resources/variables.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isCurrentPasswordVisible = true;
  bool isNewPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  bool isPasswordEmpty = false;
  bool isNewPasswordEmpty = false;
  bool isConfirmPasswordEmpty = false;
  bool buttonLoader = false;
  bool isPasswordChanged = false;

  SettingsBloc() : super(SettingsLoading()) {
    on<SettingsInitialEvent>(settingsInitialFunction);
    on<SettingsChangeLanguageEvent>(settingsChangeLanguageFunction);
    on<SettingsLogoutEvent>(settingsLogoutFunction);
    on<SettingsSetStateEvent>(settingsSetStateFunction);
    on<SettingsCurrentPasswordValidationEvent>(settingsCurrentPasswordValidationFunction);
    on<SettingsChangePasswordEvent>(settingsChangePasswordFunction);
  }

  FutureOr<void> settingsInitialFunction(SettingsInitialEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    if (getIt<Variables>().generalVariables.isNetworkOffline) {
      getIt<Variables>().generalVariables.loggedHeaders = HeadersLoggedData.fromJson(getIt<Variables>().generalVariables.userData.loggedHeaders.toJson());
      getIt<Variables>().generalVariables.profileValues = UserProfile.fromJson(getIt<Variables>().generalVariables.userData.userProfile.toJson());
      getIt<Variables>().generalVariables.profileNetworkImage = getIt<Variables>().generalVariables.userData.profileNetworkImage;
      getIt<Variables>().generalVariables.userDataEmployeeCode = getIt<Variables>().generalVariables.profileValues.data[1]/*.singleWhere((element)=>element.label=="Emp Code")*/.value;
      emit(SettingsSuccess());
      emit(SettingsLoaded());
    }
    else {
      await getIt<Variables>().repoImpl.getProfile(query: {}, method: "get").onError((error, stackTrace) {
        emit(SettingsFailure(message: error.toString()));
        emit(SettingsLoading());
      }).then((value) async {
        if (value != null) {
          if (value["status"] == "1") {
            ProfileResponseModel profileResponseModel = ProfileResponseModel.fromJson(value);
            getIt<Variables>().generalVariables.profileValues = profileResponseModel.response.profile;
            getIt<Variables>().generalVariables.userDataEmployeeCode = getIt<Variables>().generalVariables.profileValues.data[1]/*.singleWhere((element)=>element.label=="Emp Code")*/.value;
            var response = await http.get(Uri.parse(profileResponseModel.response.profile.image));
            if (response.statusCode == 200) {
              getIt<Variables>().generalVariables.profileNetworkImage = response.bodyBytes;
            }
            emit(SettingsSuccess());
            emit(SettingsLoaded());
          } else {
            emit(SettingsFailure(message: value["response"]??getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
            emit(SettingsLoading());
          }
        }
      });
    }
  }

  FutureOr<void> settingsLogoutFunction(SettingsLogoutEvent event, Emitter<SettingsState> emit) async {
    await getIt<Variables>().repoImpl.getLogout(query: {}, method: "post").onError((error, stackTrace) {
      emit(SettingsFailure(message: error.toString()));
      emit(SettingsLoaded());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.clear();
          getIt<Variables>().generalVariables.loggedHeaders.authorization = "";
          getIt<Variables>().generalVariables.isLoggedIn = false;
          getIt<Variables>().generalVariables.profileValues = UserProfile.fromJson({});
          await getIt<Variables>().repoImpl.getInitialFunction(query: {}, method: "get").onError((error, stacktrace) {
            emit(SettingsFailure(message: error.toString()));
            emit(SettingsLoaded());
          }).then((value) async {
            if (value != null) {
              if (value["status"] == "1") {
                InitialFunctionResponseModel initialFunctionResponseModel = InitialFunctionResponseModel.fromJson(value);
                getIt<Variables>().generalVariables.initialSetupValues = initialFunctionResponseModel.response;
                getIt<Variables>().generalVariables.loggedHeaders.lang = initialFunctionResponseModel.response.lang;
               //getIt<RabbitMQService>().close();
                getIt<Variables>().generalVariables.userBox!.clear();
                //await Hive.box<PickListMainData>('pick_list_main_data').clear();
                await Hive.box<PickListMainResponse>('pick_list_main_response').clear();
                await Hive.box<PicklistItem>('pick_list_item').clear();
                await Hive.box<HandledByPickList>('handled_by_pick_list').clear();
                await Hive.box<PickListDetailsResponse>('pick_list_details_response').clear();
                await Hive.box<PickListDetailsItem>('pick_list_details_item').clear();
                await Hive.box<PickListBatchesList>('pick_list_batches_list').clear();
                await Hive.box<CatchWeightItem>('catch_weight_item').clear();
                await Hive.box<LocationDisputeInfo>('location_dispute_info').clear();
                await Hive.box<PickListSessionInfo>('pick_list_session_info').clear();
                await Hive.box<TimelineInfo>('time_line_info').clear();
                await Hive.box<Filter>('filter').clear();
                await Hive.box<FloorLocation>('floor_location').clear();
                await Hive.box<StagingLocation>('staging_location').clear();
                await Hive.box<LoadingLocation>('loading_location').clear();
                await Hive.box<PartialPickListDetailsItem>('partial_pick_list_details_item').clear();
                await Hive.box<LocalTempDataPickList>('local_temp_data_pick_list').clear();
                await Hive.box<UnavailableReason>('unavailable_reason').clear();
                await Hive.box<TripList>('trip_list').clear();
                await Hive.box<SoList>('so_list').clear();
                await Hive.box<ItemsList>('items_list').clear();
                await Hive.box<BatchesList>('batches_list').clear();
                await Hive.box<PartialItemsList>('partial_items_list').clear();
                await Hive.box<LocalTempDataList>('local_temp_data_list').clear();
                await Hive.box<LocalTempDataList>('local_temp_data_list_pickup').clear();
                await Hive.box<LocalTempDataList>('local_temp_data_list_out_bound').clear();
                await Hive.box<TripList>('trip_list_pickup').clear();
                await Hive.box<SoList>('so_list_pickup').clear();
                await Hive.box<ItemsList>('items_list_pickup').clear();
                await Hive.box<BatchesList>('batches_list_pickup').clear();
                await Hive.box<InvoiceData>('invoice_data_list_pickup').clear();
                getIt<Variables>().generalVariables.popUpTime = null;
                LanguageData languageData = getIt<Variables>().generalVariables.languageBox!.values.first;
                getIt<Variables>().generalVariables.languageList = languageData.languageList;
                Map<String, dynamic> currentLanguageData = languageData.languageValueString.singleWhere((element) => element["lang_code"] == getIt<Variables>().generalVariables.loggedHeaders.lang);
                getIt<Variables>().generalVariables.currentLanguage = Languages.fromJson(currentLanguageData);
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[0].name = getIt<Variables>().generalVariables.currentLanguage.home;
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[1].name =
                    getIt<Variables>().generalVariables.currentLanguage.picklist;
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[2].name =
                    getIt<Variables>().generalVariables.currentLanguage.catchWeight;
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[3].name = getIt<Variables>().generalVariables.currentLanguage.bts;
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[4].name =
                    getIt<Variables>().generalVariables.currentLanguage.dispute;
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[5].name =
                    getIt<Variables>().generalVariables.currentLanguage.settings;
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[6].name =
                    getIt<Variables>().generalVariables.currentLanguage.tripList;
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[7].name =
                    getIt<Variables>().generalVariables.currentLanguage.outBound;
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[8].name =
                    getIt<Variables>().generalVariables.currentLanguage.wareHouseList;
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[9].name = getIt<Variables>().generalVariables.currentLanguage.roTripList;
                getIt<Variables>().generalVariables.currentUserBottomNavigationList.clear();
                getIt<Variables>().generalVariables.currentUserSideDrawerList.clear();
                getIt<Variables>().generalVariables.currentUserBottomNavigationList = List.generate(
                    getIt<Variables>().generalVariables.initialSetupValues.bottomNav.length,
                        (i) => getIt<Variables>().generalVariables.bottomNavigateDrawerList[0]);
                getIt<Variables>().generalVariables.currentUserSideDrawerList = List.generate(
                    getIt<Variables>().generalVariables.initialSetupValues.sideNav.length,
                        (i) => getIt<Variables>().generalVariables.bottomNavigateDrawerList[0]);
                for (int i = 0; i < getIt<Variables>().generalVariables.bottomNavigateDrawerList.length; i++) {
                  for (int j = 0; j < getIt<Variables>().generalVariables.initialSetupValues.bottomNav.length; j++) {
                    if (getIt<Variables>().generalVariables.initialSetupValues.bottomNav[j] ==
                        getIt<Variables>().generalVariables.bottomNavigateDrawerList[i].id) {
                      getIt<Variables>().generalVariables.currentUserBottomNavigationList[j] =
                      getIt<Variables>().generalVariables.bottomNavigateDrawerList[i];
                    }
                  }
                  for (int k = 0; k < getIt<Variables>().generalVariables.initialSetupValues.sideNav.length; k++) {
                    if (getIt<Variables>().generalVariables.initialSetupValues.sideNav[k] ==
                        getIt<Variables>().generalVariables.bottomNavigateDrawerList[i].id) {
                      getIt<Variables>().generalVariables.currentUserSideDrawerList[k] =
                      getIt<Variables>().generalVariables.bottomNavigateDrawerList[i];
                    }
                  }
                }
                emit(SettingsLogoutSuccess());
                emit(SettingsLoaded());
              } else {
                emit(SettingsFailure(message: value["response"]??getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
                emit(SettingsLoaded());
              }
            }
          });
        } else {
          emit(SettingsFailure(message: value["response"]??getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(SettingsLoaded());
        }
      }
    });
  }

  FutureOr<void> settingsSetStateFunction(SettingsSetStateEvent event, Emitter<SettingsState> emit) {
    emit(SettingsDummy());
    event.stillLoading ? emit(SettingsLoading()) : emit(SettingsLoaded());
  }

  FutureOr<void> settingsCurrentPasswordValidationFunction(SettingsCurrentPasswordValidationEvent event, Emitter<SettingsState> emit) async {
    await getIt<Variables>().repoImpl.getCheckPassword(query: {"current_password": currentPasswordController.text}, method: "post").onError((error, stackTrace) {
      emit(SettingsFailure(message: error.toString()));
      emit(SettingsLoaded());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          getIt<Variables>().generalVariables.tempCurrentPassword = currentPasswordController.text;
          emit(SettingsDialogSuccess());
          emit(SettingsLoaded());
        } else {
          emit(SettingsFailure(message: value["response"]??getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(SettingsLoaded());
        }
      }
    });
  }

  FutureOr<void> settingsChangePasswordFunction(SettingsChangePasswordEvent event, Emitter<SettingsState> emit) async {
    await getIt<Variables>()
        .repoImpl
        .getChangePassword(query: {"current_password": getIt<Variables>().generalVariables.tempCurrentPassword, "password": newPasswordController.text}, method: "post").onError((error, stackTrace) {
      emit(SettingsFailure(message: error.toString()));
      emit(SettingsLoaded());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          getIt<Variables>().generalVariables.tempCurrentPassword = "";
          emit(SettingsDialogSuccess());
          emit(SettingsLoading());
        } else {
          emit(SettingsFailure(message: value["response"]??getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(SettingsLoaded());
        }
      }
    });
  }

  FutureOr<void> settingsChangeLanguageFunction(SettingsChangeLanguageEvent event, Emitter<SettingsState> emit) async {
    await getIt<Variables>().repoImpl.getChangeLanguage(query: {"lang_code": getIt<Variables>().generalVariables.loggedHeaders.lang}, method: "patch").onError((error, stackTrace) {
      emit(SettingsFailure(message: error.toString()));
      emit(SettingsLoaded());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          emit(SettingsSuccess());
          emit(SettingsLoaded());
        } else {
          emit(SettingsFailure(message: value["response"]??getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(SettingsLoaded());
        }
      }
    });
  }
}
