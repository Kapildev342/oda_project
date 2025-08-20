// ignore_for_file: unused_import

// Dart imports:
import 'dart:async';
import 'dart:io';

// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import 'package:oda/local_database/language_box/language.dart';
import 'package:oda/local_database/user_box/user.dart';
import 'package:oda/repository_model/general/general_variables.dart';
import 'package:oda/repository_model/general/initial_function_response_model.dart';
import 'package:oda/repository_model/general/language_list.dart';
import 'package:oda/repository_model/general/languages.dart';
import 'package:oda/repository_model/settings/profile_response_model.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/rabbit_service.dart';
import 'package:oda/resources/variables.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashLoaded()) {
    on<SplashInitialEvent>(splashInitialFunction);
  }

  FutureOr<void> splashInitialFunction(SplashInitialEvent event, Emitter<SplashState> emit) async {
    String? userToken = await getIt<Functions>().sharedGetValue(key: "userToken");
    await Connectivity().checkConnectivity().then((value) {
      getIt<Variables>().generalVariables.isNetworkOffline = value.contains(ConnectivityResult.none);
    });
    if (userToken != null) {
      if (getIt<Variables>().generalVariables.isNetworkOffline) {
        getIt<Variables>().generalVariables.userData = getIt<Variables>().generalVariables.userBox!.values.first;
        getIt<Variables>().generalVariables.userDataEmployeeCode = getIt<Variables>().generalVariables.userData.userProfile.userCode;//getIt<Variables>().generalVariables.userData.userProfile.data[1]/*.singleWhere((element)=>element.label=="Emp Code")*/.value;
        getIt<Variables>().generalVariables.languageData = getIt<Variables>().generalVariables.languageBox!.values.first;
        getIt<Variables>().generalVariables.languageList = getIt<Variables>().generalVariables.languageData.languageList;
        getIt<Variables>().generalVariables.loggedHeaders = HeadersLoggedData.fromJson(getIt<Variables>().generalVariables.userData.loggedHeaders.toJson());
        getIt<Variables>().generalVariables.isLoggedIn = true;
        getIt<Variables>().generalVariables.profileValues = UserProfile.fromJson(getIt<Variables>().generalVariables.userData.userProfile.toJson());
        getIt<Variables>().generalVariables.initialSetupValues.bottomNav = getIt<Variables>().generalVariables.userData.bottomItemsList;
        getIt<Variables>().generalVariables.initialSetupValues.sideNav = getIt<Variables>().generalVariables.userData.sideItemsList;
        getIt<Variables>().generalVariables.initialSetupValues.s3 = getIt<Variables>().generalVariables.userData.s3;
        getIt<Variables>().generalVariables.profileNetworkImage = getIt<Variables>().generalVariables.userData.profileNetworkImage;
        getIt<Variables>().generalVariables.filterItemsListOptions = getIt<Variables>().generalVariables.userData.filterItemsListOptions;
        getIt<Variables>().generalVariables.filterCustomersOptions = getIt<Variables>().generalVariables.userData.filterCustomersOptions;
        Map<String, dynamic> currentLanguageData = getIt<Variables>()
            .generalVariables
            .languageData
            .languageValueString
            .singleWhere((element) => element["lang_code"] == getIt<Variables>().generalVariables.loggedHeaders.lang);
        getIt<Variables>().generalVariables.currentLanguage = Languages.fromJson(currentLanguageData);
        getIt<Variables>().generalVariables.bottomNavigateDrawerList[0].name = getIt<Variables>().generalVariables.currentLanguage.home;
        getIt<Variables>().generalVariables.bottomNavigateDrawerList[1].name = getIt<Variables>().generalVariables.currentLanguage.picklist;
        getIt<Variables>().generalVariables.bottomNavigateDrawerList[2].name = getIt<Variables>().generalVariables.currentLanguage.catchWeight;
        getIt<Variables>().generalVariables.bottomNavigateDrawerList[3].name = getIt<Variables>().generalVariables.currentLanguage.bts;
        getIt<Variables>().generalVariables.bottomNavigateDrawerList[4].name = getIt<Variables>().generalVariables.currentLanguage.dispute;
        getIt<Variables>().generalVariables.bottomNavigateDrawerList[5].name = getIt<Variables>().generalVariables.currentLanguage.settings;
        getIt<Variables>().generalVariables.bottomNavigateDrawerList[6].name = getIt<Variables>().generalVariables.currentLanguage.tripList;
        getIt<Variables>().generalVariables.bottomNavigateDrawerList[7].name = getIt<Variables>().generalVariables.currentLanguage.outBound;
        getIt<Variables>().generalVariables.bottomNavigateDrawerList[8].name = getIt<Variables>().generalVariables.currentLanguage.wareHouseList;
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
              getIt<Variables>().generalVariables.currentUserBottomNavigationList[j] = getIt<Variables>().generalVariables.bottomNavigateDrawerList[i];
            }
          }
          for (int k = 0; k < getIt<Variables>().generalVariables.initialSetupValues.sideNav.length; k++) {
            if (getIt<Variables>().generalVariables.initialSetupValues.sideNav[k] ==
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[i].id) {
              getIt<Variables>().generalVariables.currentUserSideDrawerList[k] = getIt<Variables>().generalVariables.bottomNavigateDrawerList[i];
            }
          }
        }
        emit(SplashSuccess());
        emit(SplashLoaded());
      }
      else {
        //await getIt<RabbitMQService>().connect();
        getIt<Variables>().generalVariables.userData = getIt<Variables>().generalVariables.userBox!.values.first;
        getIt<Variables>().generalVariables.userDataEmployeeCode = getIt<Variables>().generalVariables.userData.userProfile.userCode;//getIt<Variables>().generalVariables.userData.userProfile.data[1]/*.singleWhere((element)=>element.label=="Emp Code")*/.value;
        getIt<Variables>().generalVariables.languageData = getIt<Variables>().generalVariables.languageBox!.values.first;
        getIt<Variables>().generalVariables.loggedHeaders = HeadersLoggedData.fromJson(getIt<Variables>().generalVariables.userData.loggedHeaders.toJson());
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
        firebaseMessaging.requestPermission();
        await firebaseMessaging.getToken().then((token) async {
          getIt<Variables>().generalVariables.loggedHeaders.pushKey = token ?? "";
        });
        getIt<Variables>().generalVariables.isLoggedIn = true;
        getIt<Variables>().generalVariables.loggedHeaders.authorization = userToken;
        if (Platform.isIOS) {
          IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
          getIt<Variables>().generalVariables.loggedHeaders.deviceId = iosDeviceInfo.name;
          getIt<Variables>().generalVariables.loggedHeaders.deviceMaker = iosDeviceInfo.systemName;
          getIt<Variables>().generalVariables.loggedHeaders.deviceModel = iosDeviceInfo.model;
          getIt<Variables>().generalVariables.loggedHeaders.deviceType = "ios";
          getIt<Variables>().generalVariables.loggedHeaders.firmware = iosDeviceInfo.systemVersion;
          getIt<Variables>().generalVariables.loggedHeaders.appVersion = packageInfo.version;
        } else {
          AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
          getIt<Variables>().generalVariables.loggedHeaders.deviceId = androidDeviceInfo.id;
          getIt<Variables>().generalVariables.loggedHeaders.deviceMaker = androidDeviceInfo.manufacturer;
          getIt<Variables>().generalVariables.loggedHeaders.deviceModel = androidDeviceInfo.model;
          getIt<Variables>().generalVariables.loggedHeaders.deviceType = "android";
          getIt<Variables>().generalVariables.loggedHeaders.firmware = androidDeviceInfo.version.release;
          getIt<Variables>().generalVariables.loggedHeaders.appVersion = packageInfo.version;
        }
        await getIt<Variables>().repoImpl.getInitialFunction(query: {}, method: "get")
            .onError((error, stackTrace) {
          emit(SplashFailure(message: error.toString()));
          emit(SplashLoaded());
        })
            .then((value) async {
          if (value != null) {
            if (value["status"] == "1") {
              InitialFunctionResponseModel initialFunctionResponseModel = InitialFunctionResponseModel.fromJson(value);
              getIt<Variables>().generalVariables.initialSetupValues = initialFunctionResponseModel.response;
              getIt<Variables>().generalVariables.loggedHeaders.lang = initialFunctionResponseModel.response.lang;
              getIt<Variables>().generalVariables.languageList = getIt<Variables>().generalVariables.languageData.languageList;
              getIt<Variables>().generalVariables.profileNetworkImage = getIt<Variables>().generalVariables.userData.profileNetworkImage;
              Map<String, dynamic> currentLanguageData = getIt<Variables>().generalVariables.languageData.languageValueString.singleWhere((element) => element["lang_code"] == getIt<Variables>().generalVariables.loggedHeaders.lang);
              getIt<Variables>().generalVariables.currentLanguage = Languages.fromJson(currentLanguageData);
              getIt<Variables>().generalVariables.bottomNavigateDrawerList[0].name = getIt<Variables>().generalVariables.currentLanguage.home;
              getIt<Variables>().generalVariables.bottomNavigateDrawerList[1].name = getIt<Variables>().generalVariables.currentLanguage.picklist;
              getIt<Variables>().generalVariables.bottomNavigateDrawerList[2].name = getIt<Variables>().generalVariables.currentLanguage.catchWeight;
              getIt<Variables>().generalVariables.bottomNavigateDrawerList[3].name = getIt<Variables>().generalVariables.currentLanguage.bts;
              getIt<Variables>().generalVariables.bottomNavigateDrawerList[4].name = getIt<Variables>().generalVariables.currentLanguage.dispute;
              getIt<Variables>().generalVariables.bottomNavigateDrawerList[5].name = getIt<Variables>().generalVariables.currentLanguage.settings;
              getIt<Variables>().generalVariables.bottomNavigateDrawerList[6].name = getIt<Variables>().generalVariables.currentLanguage.tripList;
              getIt<Variables>().generalVariables.bottomNavigateDrawerList[7].name = getIt<Variables>().generalVariables.currentLanguage.outBound;
              getIt<Variables>().generalVariables.bottomNavigateDrawerList[8].name = getIt<Variables>().generalVariables.currentLanguage.wareHouseList;
              getIt<Variables>().generalVariables.bottomNavigateDrawerList[9].name = getIt<Variables>().generalVariables.currentLanguage.roTripList;
              getIt<Variables>().generalVariables.currentUserBottomNavigationList.clear();
              getIt<Variables>().generalVariables.currentUserSideDrawerList.clear();
              getIt<Variables>().generalVariables.currentUserBottomNavigationList = List.generate(getIt<Variables>().generalVariables.initialSetupValues.bottomNav.length, (i) => getIt<Variables>().generalVariables.bottomNavigateDrawerList[0]);
              getIt<Variables>().generalVariables.currentUserSideDrawerList = List.generate(getIt<Variables>().generalVariables.initialSetupValues.sideNav.length, (i) => getIt<Variables>().generalVariables.bottomNavigateDrawerList[0]);
              for (int i = 0; i < getIt<Variables>().generalVariables.bottomNavigateDrawerList.length; i++) {
                for (int j = 0; j < getIt<Variables>().generalVariables.initialSetupValues.bottomNav.length; j++) {
                  if (getIt<Variables>().generalVariables.initialSetupValues.bottomNav[j] == getIt<Variables>().generalVariables.bottomNavigateDrawerList[i].id) {
                    getIt<Variables>().generalVariables.currentUserBottomNavigationList[j] = getIt<Variables>().generalVariables.bottomNavigateDrawerList[i];
                  }
                }
                for (int k = 0; k < getIt<Variables>().generalVariables.initialSetupValues.sideNav.length; k++) {
                  if (getIt<Variables>().generalVariables.initialSetupValues.sideNav[k] == getIt<Variables>().generalVariables.bottomNavigateDrawerList[i].id) {
                    getIt<Variables>().generalVariables.currentUserSideDrawerList[k] = getIt<Variables>().generalVariables.bottomNavigateDrawerList[i];
                  }
                }
              }
              emit(SplashSuccess());
              emit(SplashLoaded());
              /*await getIt<Variables>().repoImpl.getProfile(query: {}, method: "get").then((value) async {
                if (value != null) {
                  if (value["status"] == "1") {
                    getIt<Variables>().generalVariables.filterItemsListOptions.clear();
                    getIt<Variables>().generalVariables.filterCustomersOptions.clear();
                    ProfileResponseModel profileResponseModel = ProfileResponseModel.fromJson(value);
                    getIt<Variables>().generalVariables.profileValues = profileResponseModel.response.profile;
                    var response = await http.get(Uri.parse(profileResponseModel.response.profile.image));
                    if (response.statusCode == 200) {
                      getIt<Variables>().generalVariables.profileNetworkImage = response.bodyBytes;
                    }
                    if (response.statusCode == 200) {
                      List<FilterOptionsResponse> optionsTempData = [];
                      List<FilterOptionsResponse> optionsItemData = [];
                      List<String> typesList=["items_list","customers"];
                      for (int j = 0; j < typesList.length; j++) {
                        optionsItemData.clear();
                        int i = 0;
                        do {
                          await getIt<Variables>().repoImpl.getFiltersOption(query: {"filter_type": typesList[j], "page": i}, method: "post").then((value) {
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
                        switch(typesList[j]){
                          case "items_list":{
                            getIt<Variables>().generalVariables.filterItemsListOptions.clear();
                            getIt<Variables>().generalVariables.filterItemsListOptions.addAll(optionsItemData);
                          }
                          case "customers":{
                            getIt<Variables>().generalVariables.filterCustomersOptions.clear();
                            getIt<Variables>().generalVariables.filterCustomersOptions.addAll(optionsItemData);
                          }
                          default:{
                            getIt<Variables>().generalVariables.filterItemsListOptions.clear();
                            getIt<Variables>().generalVariables.filterItemsListOptions.addAll(optionsItemData);
                          }
                        }
                      }
                      getIt<Variables>().generalVariables.userBox!.putAt(0,UserResponse(
                          loggedHeaders: HeadersLoggedData.fromJson(getIt<Variables>().generalVariables.loggedHeaders.toJson()),
                          bottomItemsList: getIt<Variables>().generalVariables.initialSetupValues.bottomNav,
                          sideItemsList: getIt<Variables>().generalVariables.initialSetupValues.sideNav,
                          userProfile: UserProfile.fromJson(getIt<Variables>().generalVariables.profileValues.toJson()),
                          profileNetworkImage: response.bodyBytes,
                          filterItemsListOptions: getIt<Variables>().generalVariables.filterItemsListOptions,
                          filterCustomersOptions: getIt<Variables>().generalVariables.filterCustomersOptions));
                      if (getIt<Variables>().generalVariables.initialSetupValues.appMode != "production") {
                        await getIt<Variables>().repoImpl.getLanguageList(query: {}, method: "get").onError((error, stackTrace) {
                          emit(SplashFailure(message: error.toString()));
                          emit(SplashLoaded());
                        }).then((value) async {
                          if (value != null) {
                            if (value["status"] == "1") {
                              LanguageListApiModel languageListApiModel = LanguageListApiModel.fromJson(value);
                              await getIt<Variables>().repoImpl.getLanguageValueString(query: {}, method: "get").onError((error, stackTrace) {
                                emit(SplashFailure(message: error.toString()));
                                emit(SplashLoaded());
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
                                    getIt<Variables>().generalVariables.languageBox!.add(LanguageData(
                                        languageList: languageListApiModel.response.languages, languageValueString: languageListStringData));
                                    LanguageData languageData = getIt<Variables>().generalVariables.languageBox!.values.first;
                                    getIt<Variables>().generalVariables.languageList = languageData.languageList;
                                    Map<String, dynamic> currentLanguageData = languageData.languageValueString
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
                                        getIt<Variables>().generalVariables.currentLanguage.warehousePickUp;
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
                                    emit(SplashSuccess());
                                    emit(SplashLoaded());
                                  }
                                  else {
                                    emit(SplashFailure(message: value["response"]));
                                    emit(SplashLoaded());
                                  }
                                }
                              });
                            } else {
                              emit(SplashFailure(message: value["response"]));
                              emit(SplashLoaded());
                            }
                          }
                        });
                      } else {
                        LanguageData languageData = getIt<Variables>().generalVariables.languageBox!.values.first;
                        getIt<Variables>().generalVariables.languageList = languageData.languageList;
                        Map<String, dynamic> currentLanguageData = languageData.languageValueString
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
                            getIt<Variables>().generalVariables.currentLanguage.warehousePickUp;
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
                        emit(SplashSuccess());
                        emit(SplashLoaded());
                      }
                    }
                  }
                }
              });*/
            } else {
              emit(SplashFailure(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
              emit(SplashLoaded());
            }
          }
        });
      }
    } else {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      await firebaseMessaging.getToken().then((token) async {
        getIt<Variables>().generalVariables.loggedHeaders.pushKey = token ?? "";
      });
      getIt<Variables>().generalVariables.isLoggedIn = false;
      if (Platform.isIOS) {
        IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
        getIt<Variables>().generalVariables.loggedHeaders.deviceId = iosDeviceInfo.name;
        getIt<Variables>().generalVariables.loggedHeaders.deviceMaker = iosDeviceInfo.systemName;
        getIt<Variables>().generalVariables.loggedHeaders.deviceModel = iosDeviceInfo.model;
        getIt<Variables>().generalVariables.loggedHeaders.deviceType = "ios";
        getIt<Variables>().generalVariables.loggedHeaders.firmware = iosDeviceInfo.systemVersion;
        getIt<Variables>().generalVariables.loggedHeaders.appVersion = packageInfo.version;
      }
      else {
        AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
        getIt<Variables>().generalVariables.loggedHeaders.deviceId = androidDeviceInfo.id;
        getIt<Variables>().generalVariables.loggedHeaders.deviceMaker = androidDeviceInfo.manufacturer;
        getIt<Variables>().generalVariables.loggedHeaders.deviceModel = androidDeviceInfo.model;
        getIt<Variables>().generalVariables.loggedHeaders.deviceType = "android";
        getIt<Variables>().generalVariables.loggedHeaders.firmware = androidDeviceInfo.version.release;
        getIt<Variables>().generalVariables.loggedHeaders.appVersion = packageInfo.version;
      }
      await getIt<Variables>().repoImpl.getInitialFunction(query: {}, method: "get")
          .onError((error, stackTrace) {
        emit(SplashFailure(message: error.toString()));
        emit(SplashLoaded());
      })
          .then((value) async {
        if (value != null) {
          if (value["status"] == "1") {
            InitialFunctionResponseModel initialFunctionResponseModel = InitialFunctionResponseModel.fromJson(value);
            getIt<Variables>().generalVariables.initialSetupValues = initialFunctionResponseModel.response;
            getIt<Variables>().generalVariables.loggedHeaders.lang = initialFunctionResponseModel.response.lang;
            await getIt<Variables>().repoImpl.getLanguageList(query: {}, method: "get").onError((error, stackTrace) {
              emit(SplashFailure(message: error.toString()));
              emit(SplashLoaded());
            }).then((value) async {
              if (value != null) {
                if (value["status"] == "1") {
                  LanguageListApiModel languageListApiModel = LanguageListApiModel.fromJson(value);
                  await getIt<Variables>().repoImpl.getLanguageValueString(query: {}, method: "get").onError((error, stackTrace) {
                    emit(SplashFailure(message: error.toString()));
                    emit(SplashLoaded());
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
                        getIt<Variables>()
                            .generalVariables
                            .languageBox!
                            .add(LanguageData(languageList: languageListApiModel.response.languages, languageValueString: languageListStringData));
                        getIt<Variables>().generalVariables.languageData = getIt<Variables>().generalVariables.languageBox!.values.first;
                        getIt<Variables>().generalVariables.languageList = getIt<Variables>().generalVariables.languageData.languageList;
                        Map<String, dynamic> currentLanguageData = getIt<Variables>().generalVariables.languageData.languageValueString
                            .singleWhere((element) => element["lang_code"] == getIt<Variables>().generalVariables.loggedHeaders.lang);
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
                        emit(SplashSuccess());
                        emit(SplashLoaded());
                      } else {
                        emit(SplashFailure(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
                        emit(SplashLoaded());
                      }
                    }
                  });
                } else {
                  emit(SplashFailure(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
                  emit(SplashLoaded());
                }
              }
            });
          } else {
            emit(SplashFailure(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
            emit(SplashLoaded());
          }
        }
      });
    }
  }
}
