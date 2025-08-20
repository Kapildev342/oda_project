// Dart imports:
import 'dart:async';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:oda/local_database/pick_list_box/pick_list.dart';
import 'package:oda/local_database/trip_box/trip_list.dart';

// Project imports:
import 'package:oda/local_database/user_box/user.dart';
import 'package:oda/repository/api_end_points.dart';
import 'package:oda/repository_model/general/filter_options_model.dart';
import 'package:oda/repository_model/general/initial_function_response_model.dart';
import 'package:oda/repository_model/general/languages.dart';
import 'package:oda/repository_model/login/login_response_model.dart';
import 'package:oda/repository_model/pick_list/floor_list_model.dart';
import 'package:oda/repository_model/settings/profile_response_model.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginLoaded()) {
    on<LoginInitialEvent>(loginInitialFunction);
    on<LoginButtonEvent>(loginFunction);
    on<LoginSetStateEvent>(loginSetStateFunction);
  }

  FutureOr<void> loginInitialFunction(LoginInitialEvent event, Emitter<LoginState> emit) async {
    getIt<Variables>().generalVariables.loginRouteList.clear();
    if (getIt<Variables>().generalVariables.initialSetupValues.appMode != "production") {
      emit(LoginDialogState());
    }
  }

  FutureOr<void> loginFunction(LoginButtonEvent event, Emitter<LoginState> emit) async {
    await getIt<Variables>().repoImpl.getLogin(
      query: {"login_id": event.userId, "password": event.password},
      method: "post",
    ).onError((e, stackTrace) {
      emit(LoginFailure(message: e.toString()));
      emit(const LoginLoaded());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          getIt<Variables>().generalVariables.isLoggedIn = true;
          LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(value);
          getIt<Functions>().sharedSetValue(type: "string", key: "userToken", value: loginResponseModel.response.token);
          getIt<Variables>().generalVariables.loggedHeaders.authorization = loginResponseModel.response.token;
          await getIt<Variables>().repoImpl.getInitialFunction(query: {}, method: "get").onError((error, stacktrace) {
            emit(LoginFailure(message: error.toString()));
            emit(const LoginLoaded());
          }).then((value) async {
            if (value != null) {
              if (value["status"] == "1") {
                InitialFunctionResponseModel initialFunctionResponseModel = InitialFunctionResponseModel.fromJson(value);
                getIt<Variables>().generalVariables.initialSetupValues = initialFunctionResponseModel.response;
                getIt<Variables>().generalVariables.loggedHeaders.lang = initialFunctionResponseModel.response.lang;
                await getIt<Variables>().repoImpl.getProfile(query: {}, method: "get").then((value) async {
                  if (value != null) {
                    if (value["status"] == "1") {
                      ProfileResponseModel profileResponseModel = ProfileResponseModel.fromJson(value);
                      getIt<Variables>().generalVariables.profileValues = profileResponseModel.response.profile;
                      var response = await http.get(Uri.parse(profileResponseModel.response.profile.image));
                      if (response.statusCode == 200) {
                        getIt<Variables>().generalVariables.profileNetworkImage = response.bodyBytes;
                      }
                      if (response.statusCode == 200) {
                        List<FilterOptionsResponse> optionsTempData = [];
                        List<FilterOptionsResponse> optionsItemData = [];
                        List<String> typesList = ["items_list", "customers", "users"];
                        for (int j = 0; j < typesList.length; j++) {
                          optionsItemData.clear();
                          int i = 0;
                          do {
                            await getIt<Variables>()
                                .repoImpl
                                .getFiltersOption(query: {"filter_type": typesList[j], "page": i}, method: "post").then((value) {
                              if (value != null) {
                                if (value["status"] == "1") {
                                  optionsTempData.clear();
                                  FilterOptionsModel filterOptionsModel = FilterOptionsModel.fromJson(value);
                                  optionsTempData = filterOptionsModel.response;
                                  optionsItemData.addAll(optionsTempData);
                                }
                              }
                            });
                            i++;
                          } while (optionsTempData.isNotEmpty);
                          switch (typesList[j]) {
                            case "items_list":
                              {
                                getIt<Variables>().generalVariables.filterItemsListOptions.clear();
                                getIt<Variables>().generalVariables.filterItemsListOptions.addAll(optionsItemData);
                              }
                            case "customers":
                              {
                                getIt<Variables>().generalVariables.filterCustomersOptions.clear();
                                getIt<Variables>().generalVariables.filterCustomersOptions.addAll(optionsItemData);
                              }
                            case "users":
                              {
                                getIt<Variables>().generalVariables.usersList.clear();
                                getIt<Variables>().generalVariables.usersList.addAll(optionsItemData);
                              }
                            default:
                              {
                                getIt<Variables>().generalVariables.filterItemsListOptions.clear();
                                getIt<Variables>().generalVariables.filterItemsListOptions.addAll(optionsItemData);
                              }
                          }
                        }
                        await getIt<Variables>().repoImpl.getLocations(query: {"type": "floor"}, method: "get").then((value) async {
                          if (value != null) {
                            if (value["status"] == "1") {
                              FloorListModel floorListModel = FloorListModel.fromJson(value);
                              await Hive.box<FloorLocation>('floor_location').clear();
                              Box<FloorLocation> floorLocationData = Hive.box<FloorLocation>('floor_location');
                              floorLocationData.addAll(floorListModel.response.locations);
                            }
                          }
                        });
                        await getIt<Variables>().repoImpl.getLocations(query: {"type": "staging"}, method: "get").then((value) async {
                          if (value != null) {
                            if (value["status"] == "1") {
                              FloorListModel floorListModel = FloorListModel.fromJson(value);
                              await Hive.box<StagingLocation>('staging_location').clear();
                              Box<StagingLocation> stagingLocationData = Hive.box<StagingLocation>('staging_location');
                              stagingLocationData.addAll(
                                  List<StagingLocation>.from(floorListModel.response.locations.map((x) => StagingLocation.fromJson(x.toJson()))));
                            }
                          }
                        });
                        await getIt<Variables>().repoImpl.getLocations(query: {"type": "return_loading"}, method: "get").then((value) async {
                          if (value != null) {
                            if (value["status"] == "1") {
                              FloorListModel floorListModel = FloorListModel.fromJson(value);
                              await Hive.box<LoadingLocation>('loading_location').clear();
                              Box<LoadingLocation> loadingLocationData = Hive.box<LoadingLocation>('loading_location');
                              loadingLocationData.addAll(
                                  List<LoadingLocation>.from(floorListModel.response.locations.map((x) => LoadingLocation.fromJson(x.toJson()))));
                            }
                          }
                        });
                        await getIt<Variables>()
                            .repoImpl
                            .getPicklistUnavailableReasons(query: {}, method: "get", module: ApiEndPoints().pickListModule).then((value) async {
                          if (value != null) {
                            if (value["status"] == "1") {
                              await Hive.box<UnavailableReason>('unavailable_reason').clear();
                              Box<UnavailableReason> unavailableReasonData = Hive.box<UnavailableReason>('unavailable_reason');
                              unavailableReasonData
                                  .addAll(List<UnavailableReason>.from(value["response"]['reasons'].map((x) => UnavailableReason.fromJson(x))));
                            }
                          }
                        });
                        await getIt<Variables>()
                            .repoImpl
                            .getPicklistCompleteReasons(query: {}, method: "get", module: ApiEndPoints().pickListModule).then((value) async {
                          if (value != null) {
                            if (value["status"] == "1") {
                              await Hive.box<UnavailableReason>('complete_reason').clear();
                              Box<UnavailableReason> completeReasonData = Hive.box<UnavailableReason>('complete_reason');
                              completeReasonData
                                  .addAll(List<UnavailableReason>.from(value["response"]['reasons'].map((x) => UnavailableReason.fromJson(x))));
                            }
                          }
                        });
                        getIt<Variables>().generalVariables.userBox!.clear();
                        getIt<Variables>().generalVariables.userBox!.add(UserResponse(
                            loggedHeaders: getIt<Variables>().generalVariables.loggedHeaders,
                            bottomItemsList: getIt<Variables>().generalVariables.initialSetupValues.bottomNav,
                            sideItemsList: getIt<Variables>().generalVariables.initialSetupValues.sideNav,
                            userProfile: UserProfile.fromJson(getIt<Variables>().generalVariables.profileValues.toJson()),
                            profileNetworkImage: response.bodyBytes,
                            filterItemsListOptions: getIt<Variables>().generalVariables.filterItemsListOptions,
                            filterCustomersOptions: getIt<Variables>().generalVariables.filterCustomersOptions,
                            usersList: getIt<Variables>().generalVariables.usersList,
                            s3: getIt<Variables>().generalVariables.initialSetupValues.s3));
                        getIt<Variables>().generalVariables.userData = getIt<Variables>().generalVariables.userBox!.values.first;
                        getIt<Variables>().generalVariables.userDataEmployeeCode = getIt<Variables>()
                            .generalVariables
                            .userData
                            .userProfile
                            .userCode; //getIt<Variables>().generalVariables.userData.userProfile.data[1]/*.singleWhere((element)=>element.label=="Emp Code")*/.value;
                        getIt<Variables>().generalVariables.languageList = getIt<Variables>().generalVariables.languageData.languageList;
                        Map<String, dynamic> currentLanguageData = getIt<Variables>()
                            .generalVariables
                            .languageData
                            .languageValueString
                            .singleWhere((element) => element["lang_code"] == getIt<Variables>().generalVariables.loggedHeaders.lang);
                        getIt<Variables>().generalVariables.currentLanguage = Languages.fromJson(currentLanguageData);
                        getIt<Variables>().generalVariables.bottomNavigateDrawerList[0].name =
                            getIt<Variables>().generalVariables.currentLanguage.home;
                        getIt<Variables>().generalVariables.bottomNavigateDrawerList[1].name =
                            getIt<Variables>().generalVariables.currentLanguage.picklist;
                        getIt<Variables>().generalVariables.bottomNavigateDrawerList[2].name =
                            getIt<Variables>().generalVariables.currentLanguage.catchWeight;
                        getIt<Variables>().generalVariables.bottomNavigateDrawerList[3].name =
                            getIt<Variables>().generalVariables.currentLanguage.bts;
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
                        getIt<Variables>().generalVariables.bottomNavigateDrawerList[9].name =
                            getIt<Variables>().generalVariables.currentLanguage.roTripList;
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
                         //await getIt<RabbitMQService>().connect();
                        emit(const LoginSuccess());
                        emit(const LoginLoaded());
                        /* if (getIt<Variables>().generalVariables.initialSetupValues.appMode != "production") {
                          await getIt<Variables>().repoImpl.getLanguageList(query: {}, method: "get").onError((error, stackTrace) {
                            emit(LoginFailure(message: error.toString()));
                            emit(const LoginLoaded());
                          }).then((value) async {
                            if (value != null) {
                              if (value["status"] == "1") {
                                LanguageListApiModel languageListApiModel = LanguageListApiModel.fromJson(value);
                                await getIt<Variables>().repoImpl.getLanguageValueString(query: {}, method: "get").onError((error, stackTrace) {
                                  emit(LoginFailure(message: error.toString()));
                                  emit(const LoginLoaded());
                                }).then((value) async {
                                  if (value != null) {
                                    if (value["status"] == "1") {
                                      Map<String, dynamic> languageValueStringData = value["response"]["strings"];
                                      List<Map<String, dynamic>> languageListStringData = [];
                                      for (String outerMap in languageValueStringData.keys) {
                                        languageListStringData.add(languageValueStringData[outerMap]);
                                        languageListStringData[languageListStringData.length - 1]["lang_code"] = outerMap;
                                      }
                                      await getIt<Variables>().generalVariables.languageBox!.clear();
                                      getIt<Variables>().generalVariables.languageBox!.add(LanguageData(languageList: languageListApiModel.response.languages, languageValueString: languageListStringData));
                                      LanguageData languageData = getIt<Variables>().generalVariables.languageBox!.values.first;
                                      getIt<Variables>().generalVariables.languageList = languageData.languageList;
                                      Map<String, dynamic> currentLanguageData = languageData.languageValueString.singleWhere((element) => element["lang_code"] == getIt<Variables>().generalVariables.loggedHeaders.lang);
                                      getIt<Variables>().generalVariables.currentLanguage = Languages.fromJson(currentLanguageData);
                                      getIt<Variables>().generalVariables.bottomNavigateDrawerList[0].name=getIt<Variables>().generalVariables.currentLanguage.home;
                                      getIt<Variables>().generalVariables.bottomNavigateDrawerList[1].name=getIt<Variables>().generalVariables.currentLanguage.picklist;
                                      getIt<Variables>().generalVariables.bottomNavigateDrawerList[2].name=getIt<Variables>().generalVariables.currentLanguage.catchWeight;
                                      getIt<Variables>().generalVariables.bottomNavigateDrawerList[3].name=getIt<Variables>().generalVariables.currentLanguage.bts;
                                      getIt<Variables>().generalVariables.bottomNavigateDrawerList[4].name=getIt<Variables>().generalVariables.currentLanguage.dispute;
                                      getIt<Variables>().generalVariables.bottomNavigateDrawerList[5].name=getIt<Variables>().generalVariables.currentLanguage.settings;
                                      getIt<Variables>().generalVariables.bottomNavigateDrawerList[6].name=getIt<Variables>().generalVariables.currentLanguage.tripList;
                                      getIt<Variables>().generalVariables.bottomNavigateDrawerList[7].name=getIt<Variables>().generalVariables.currentLanguage.outBound;
                                      getIt<Variables>().generalVariables.bottomNavigateDrawerList[8].name=getIt<Variables>().generalVariables.currentLanguage.warehousePickUp;
                                      getIt<Variables>().generalVariables.bottomNavigateDrawerList[9].name = getIt<Variables>().generalVariables.currentLanguage.roTripList;
                                      getIt<Variables>().generalVariables.currentUserBottomNavigationList.clear();
                                      getIt<Variables>().generalVariables.currentUserSideDrawerList.clear();
                                      getIt<Variables>().generalVariables.currentUserBottomNavigationList=List.generate(getIt<Variables>().generalVariables.initialSetupValues.bottomNav.length, (i)=>getIt<Variables>().generalVariables.bottomNavigateDrawerList[0]);
                                      getIt<Variables>().generalVariables.currentUserSideDrawerList=List.generate(getIt<Variables>().generalVariables.initialSetupValues.sideNav.length, (i)=>getIt<Variables>().generalVariables.bottomNavigateDrawerList[0]);
                                      for(int i=0;i<getIt<Variables>().generalVariables.bottomNavigateDrawerList.length;i++){
                                        for(int j=0;j<getIt<Variables>().generalVariables.initialSetupValues.bottomNav.length;j++){
                                          if(getIt<Variables>().generalVariables.initialSetupValues.bottomNav[j]==getIt<Variables>().generalVariables.bottomNavigateDrawerList[i].id){
                                            getIt<Variables>().generalVariables.currentUserBottomNavigationList[j]=getIt<Variables>().generalVariables.bottomNavigateDrawerList[i];
                                          }
                                        }
                                        for(int k=0;k<getIt<Variables>().generalVariables.initialSetupValues.sideNav.length;k++){
                                          if(getIt<Variables>().generalVariables.initialSetupValues.sideNav[k]==getIt<Variables>().generalVariables.bottomNavigateDrawerList[i].id){
                                            getIt<Variables>().generalVariables.currentUserSideDrawerList[k]=getIt<Variables>().generalVariables.bottomNavigateDrawerList[i];
                                          }
                                        }
                                      }
                                      emit(const LoginSuccess());
                                      emit(const LoginLoaded());
                                    } else {
                                      emit(LoginFailure(message: value["response"]??getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
                                      emit(const LoginLoaded());
                                    }
                                  }
                                });
                              } else {
                                emit(LoginFailure(message: value["response"]??getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
                                emit(const LoginLoaded());
                              }
                            }
                          });
                        }
                        else {
                          LanguageData languageData = getIt<Variables>().generalVariables.languageBox!.values.first;
                          getIt<Variables>().generalVariables.languageList = languageData.languageList;
                          Map<String, dynamic> currentLanguageData = languageData.languageValueString.singleWhere((element) => element["lang_code"] == getIt<Variables>().generalVariables.loggedHeaders.lang);
                          getIt<Variables>().generalVariables.currentLanguage = Languages.fromJson(currentLanguageData);
                          getIt<Variables>().generalVariables.bottomNavigateDrawerList[0].name=getIt<Variables>().generalVariables.currentLanguage.home;
                          getIt<Variables>().generalVariables.bottomNavigateDrawerList[1].name=getIt<Variables>().generalVariables.currentLanguage.picklist;
                          getIt<Variables>().generalVariables.bottomNavigateDrawerList[2].name=getIt<Variables>().generalVariables.currentLanguage.catchWeight;
                          getIt<Variables>().generalVariables.bottomNavigateDrawerList[3].name=getIt<Variables>().generalVariables.currentLanguage.bts;
                          getIt<Variables>().generalVariables.bottomNavigateDrawerList[4].name=getIt<Variables>().generalVariables.currentLanguage.dispute;
                          getIt<Variables>().generalVariables.bottomNavigateDrawerList[5].name=getIt<Variables>().generalVariables.currentLanguage.settings;
                          getIt<Variables>().generalVariables.bottomNavigateDrawerList[6].name=getIt<Variables>().generalVariables.currentLanguage.tripList;
                          getIt<Variables>().generalVariables.bottomNavigateDrawerList[7].name=getIt<Variables>().generalVariables.currentLanguage.outBound;
                          getIt<Variables>().generalVariables.bottomNavigateDrawerList[8].name=getIt<Variables>().generalVariables.currentLanguage.warehousePickUp;
                          getIt<Variables>().generalVariables.bottomNavigateDrawerList[9].name = getIt<Variables>().generalVariables.currentLanguage.roTripList;
                          getIt<Variables>().generalVariables.currentUserBottomNavigationList.clear();
                          getIt<Variables>().generalVariables.currentUserSideDrawerList.clear();
                          getIt<Variables>().generalVariables.currentUserBottomNavigationList=List.generate(getIt<Variables>().generalVariables.initialSetupValues.bottomNav.length, (i)=>getIt<Variables>().generalVariables.bottomNavigateDrawerList[0]);
                          getIt<Variables>().generalVariables.currentUserSideDrawerList=List.generate(getIt<Variables>().generalVariables.initialSetupValues.sideNav.length, (i)=>getIt<Variables>().generalVariables.bottomNavigateDrawerList[0]);
                          for(int i=0;i<getIt<Variables>().generalVariables.bottomNavigateDrawerList.length;i++){
                            for(int j=0;j<getIt<Variables>().generalVariables.initialSetupValues.bottomNav.length;j++){
                              if(getIt<Variables>().generalVariables.initialSetupValues.bottomNav[j]==getIt<Variables>().generalVariables.bottomNavigateDrawerList[i].id){
                                getIt<Variables>().generalVariables.currentUserBottomNavigationList[j]=getIt<Variables>().generalVariables.bottomNavigateDrawerList[i];
                              }
                            }
                            for(int k=0;k<getIt<Variables>().generalVariables.initialSetupValues.sideNav.length;k++){
                              if(getIt<Variables>().generalVariables.initialSetupValues.sideNav[k]==getIt<Variables>().generalVariables.bottomNavigateDrawerList[i].id){
                                getIt<Variables>().generalVariables.currentUserSideDrawerList[k]=getIt<Variables>().generalVariables.bottomNavigateDrawerList[i];
                              }
                            }
                          }
                          emit(const LoginSuccess());
                          emit(const LoginLoaded());
                        }*/
                      }
                    } else {
                      emit(LoginFailure(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
                      emit(const LoginLoaded());
                    }
                  }
                });
              } else {
                emit(LoginFailure(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
                emit(const LoginLoaded());
              }
            }
          });
        } else {
          emit(LoginFailure(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(const LoginLoaded());
        }
      }
    });
  }

  FutureOr<void> loginSetStateFunction(LoginSetStateEvent event, Emitter<LoginState> emit) {
    emit(const LoginDummy());
    emit(const LoginLoaded());
  }
}
