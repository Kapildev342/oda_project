// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oda/bloc/pick_list/pick_list_details/pick_list_details_bloc.dart';

// Project imports:
import 'package:oda/bloc/trip_list/trip_list_detail/trip_list_detail_bloc.dart';
import 'package:oda/bloc/warehouse_pickup/warehouse_pickup_summary/warehouse_pickup_summary_bloc.dart';
import 'package:oda/local_database/language_box/language.dart';
import 'package:oda/my_app.dart';
import 'package:oda/repository_model/general/languages.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/screens/back_to_store/add_back_store_screen.dart';
import 'package:oda/screens/back_to_store/back_to_store_screen.dart';
import 'package:oda/screens/catch_weight/catch_weight_screen.dart';
import 'package:oda/screens/dispute/dispute_detail_screen.dart';
import 'package:oda/screens/dispute/dispute_screen.dart';
import 'package:oda/screens/home/home_screen.dart';
import 'package:oda/screens/home/notification_screen.dart';
import 'package:oda/screens/out_bound/out_bound_detail_screen.dart';
import 'package:oda/screens/out_bound/out_bound_entry_screen.dart';
import 'package:oda/screens/out_bound/out_bound_screen.dart';
import 'package:oda/screens/pick_list/pick_list_details_screen.dart';
import 'package:oda/screens/pick_list/pick_list_screen.dart';
import 'package:oda/screens/registration/create_password_screen.dart';
import 'package:oda/screens/registration/forget_password_screen.dart';
import 'package:oda/screens/registration/login_screen.dart';
import 'package:oda/screens/registration/otp_screen.dart';
import 'package:oda/screens/registration/splash_screen.dart';
import 'package:oda/screens/ro_trip_list/ro_trip_list_detail_screen.dart';
import 'package:oda/screens/ro_trip_list/ro_trip_list_screen.dart';
import 'package:oda/screens/settings/settings_screen.dart';
import 'package:oda/screens/tasks/add_task_screen.dart';
import 'package:oda/screens/tasks/task_screen.dart';
import 'package:oda/screens/tasks/view_task_screen.dart';
import 'package:oda/screens/trip_list/trip_list_detail_screen.dart';
import 'package:oda/screens/trip_list/trip_list_entry_screen.dart';
import 'package:oda/screens/trip_list/trip_list_screen.dart';
import 'package:oda/screens/warehouse_pickup/warehouse_pickup_detail_screen.dart';
import 'package:oda/screens/warehouse_pickup/warehouse_pickup_screen.dart';
import 'package:oda/screens/warehouse_pickup/warehouse_pickup_summary_screen.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationLoaded()) {
    on<NavigationInitialEvent>(initialFunction);
    on<BottomNavigationEvent>(bottomNavigationFunction);
    on<SideDrawerNavigationEvent>(sideDrawerNavigationFunction);
    on<LanguageChangingEvent>(languageChangingFunction);
    on<NavigationSetStateEvent>(navigationSetStateFunction);
    on<ListenConnectivity>(listenConnectivityFunction);
  }

  FutureOr<void> initialFunction(NavigationInitialEvent event, Emitter<NavigationState> emit) async {
    switch (getIt<Variables>().generalVariables.indexName) {
      case SplashScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const SplashScreen();
        }
      case LoginScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const LoginScreen();
        }
      case ForgetPasswordScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const ForgetPasswordScreen();
        }
      case OtpScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const OtpScreen();
        }
      case CreatePasswordScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const CreatePasswordScreen();
        }
      case HomeScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const HomeScreen();
        }
      case PickListScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const PickListScreen();
        }
      case PickListDetailsScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const PickListDetailsScreen();
        }
      case CatchWeightScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const CatchWeightScreen();
        }
      case BackToStoreScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const BackToStoreScreen();
        }
      case AddBackStoreScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const AddBackStoreScreen();
        }
      case DisputeScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const DisputeScreen();
        }
      case DisputeDetailScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const DisputeDetailScreen();
        }
      case TripListScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const TripListScreen();
        }
      case TripListEntryScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const TripListEntryScreen();
        }
      case TripListDetailScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const TripListDetailScreen();
        }
      case OutBoundScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const OutBoundScreen();
        }
      case OutBoundEntryScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const OutBoundEntryScreen();
        }
      case OutBoundDetailScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const OutBoundDetailScreen();
        }
      case WarehousePickupScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const WarehousePickupScreen();
        }
      case WarehousePickupDetailScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const WarehousePickupDetailScreen();
        }
      case WarehousePickupSummaryScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const WarehousePickupSummaryScreen();
        }
      case SettingsScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const SettingsScreen();
        }
      case NotificationScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const NotificationScreen();
        }
      case RoTripListScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const RoTripListScreen();
        }
      case RoTripListDetailScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const RoTripListDetailScreen();
        }
      case TaskScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const TaskScreen();
        }
        case AddTaskScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const AddTaskScreen();
        }
      case ViewTaskScreen.id:
        {
          getIt<Variables>().generalVariables.mainWidget = const ViewTaskScreen();
        }
      default:
        {
          getIt<Variables>().generalVariables.mainWidget = const HomeScreen();
        }
    }
    emit(NavigationConfirm());
    emit(NavigationLoaded());
  }

  FutureOr<void> bottomNavigationFunction(BottomNavigationEvent event, Emitter<NavigationState> emit) async {
    if (getIt<Variables>().generalVariables.selectedIndex != event.index) {
      getIt<Variables>().generalVariables.homeRouteList.clear();
      getIt<Variables>().generalVariables.pickListRouteList.clear();
      getIt<Variables>().generalVariables.catchWeightRouteList.clear();
      getIt<Variables>().generalVariables.btsRouteList.clear();
      getIt<Variables>().generalVariables.disputeRouteList.clear();
      getIt<Variables>().generalVariables.tripListRouteList.clear();
      getIt<Variables>().generalVariables.settingsRouteList.clear();
      getIt<Variables>().generalVariables.roTripListRouteList.clear();
      if (getIt<Variables>().generalVariables.isNetworkOffline) {
        getIt<Variables>().generalVariables.bottomNavigateDrawerList[0].name =
            getIt<Variables>().generalVariables.currentLanguage.home;
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
        getIt<Variables>().generalVariables.bottomNavigateDrawerList[9].name =
            getIt<Variables>().generalVariables.currentLanguage.roTripList;
        getIt<Variables>().generalVariables.currentUserBottomNavigationList.clear();
        getIt<Variables>().generalVariables.currentUserSideDrawerList.clear();
        getIt<Variables>().generalVariables.currentUserBottomNavigationList = List.generate(
            getIt<Variables>().generalVariables.userData.bottomItemsList.length,
            (i) => getIt<Variables>().generalVariables.bottomNavigateDrawerList[0]);
        getIt<Variables>().generalVariables.currentUserSideDrawerList = List.generate(
            getIt<Variables>().generalVariables.userData.sideItemsList.length,
            (i) => getIt<Variables>().generalVariables.bottomNavigateDrawerList[0]);
        for (int i = 0; i < getIt<Variables>().generalVariables.bottomNavigateDrawerList.length; i++) {
          for (int j = 0; j < getIt<Variables>().generalVariables.userData.bottomItemsList.length; j++) {
            if (getIt<Variables>().generalVariables.userData.bottomItemsList[j] ==
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[i].id) {
              getIt<Variables>().generalVariables.currentUserBottomNavigationList[j] =
                  getIt<Variables>().generalVariables.bottomNavigateDrawerList[i];
            }
          }
          for (int k = 0; k < getIt<Variables>().generalVariables.userData.sideItemsList.length; k++) {
            if (getIt<Variables>().generalVariables.userData.sideItemsList[k] ==
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[i].id) {
              getIt<Variables>().generalVariables.currentUserSideDrawerList[k] =
                  getIt<Variables>().generalVariables.bottomNavigateDrawerList[i];
            }
          }
        }
        getIt<Variables>().generalVariables.selectedIndex = getIt<Variables>()
            .generalVariables
            .userData
            .bottomItemsList
            .indexOf(getIt<Variables>().generalVariables.currentUserBottomNavigationList[event.index].id);
      } else {
        getIt<Variables>().generalVariables.bottomNavigateDrawerList[0].name =
            getIt<Variables>().generalVariables.currentLanguage.home;
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
        getIt<Variables>().generalVariables.selectedIndex = getIt<Variables>()
            .generalVariables
            .initialSetupValues
            .bottomNav
            .indexOf(getIt<Variables>().generalVariables.currentUserBottomNavigationList[event.index].id);
      }
      getIt<Variables>().generalVariables.indexName =
          getIt<Variables>().generalVariables.currentUserBottomNavigationList[event.index].navigateTo;
    } else {
      if (getIt<Variables>().generalVariables.indexName !=
          getIt<Variables>().generalVariables.currentUserBottomNavigationList[event.index].navigateTo) {
        getIt<Variables>().generalVariables.homeRouteList.clear();
        getIt<Variables>().generalVariables.pickListRouteList.clear();
        getIt<Variables>().generalVariables.catchWeightRouteList.clear();
        getIt<Variables>().generalVariables.btsRouteList.clear();
        getIt<Variables>().generalVariables.disputeRouteList.clear();
        getIt<Variables>().generalVariables.tripListRouteList.clear();
        getIt<Variables>().generalVariables.settingsRouteList.clear();
        getIt<Variables>().generalVariables.roTripListRouteList.clear();
        getIt<Variables>().generalVariables.indexName =
            getIt<Variables>().generalVariables.currentUserBottomNavigationList[event.index].navigateTo;
      }
    }
  }

  FutureOr<void> sideDrawerNavigationFunction(SideDrawerNavigationEvent event, Emitter<NavigationState> emit) {
    if (getIt<Variables>().generalVariables.selectedIndex != event.index) {
      getIt<Variables>().generalVariables.homeRouteList.clear();
      getIt<Variables>().generalVariables.pickListRouteList.clear();
      getIt<Variables>().generalVariables.catchWeightRouteList.clear();
      getIt<Variables>().generalVariables.btsRouteList.clear();
      getIt<Variables>().generalVariables.disputeRouteList.clear();
      getIt<Variables>().generalVariables.tripListRouteList.clear();
      getIt<Variables>().generalVariables.settingsRouteList.clear();
      getIt<Variables>().generalVariables.roTripListRouteList.clear();
      if (getIt<Variables>().generalVariables.isNetworkOffline) {
        getIt<Variables>().generalVariables.bottomNavigateDrawerList[0].name =
            getIt<Variables>().generalVariables.currentLanguage.home;
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
        getIt<Variables>().generalVariables.bottomNavigateDrawerList[9].name =
            getIt<Variables>().generalVariables.currentLanguage.roTripList;
        getIt<Variables>().generalVariables.currentUserBottomNavigationList.clear();
        getIt<Variables>().generalVariables.currentUserSideDrawerList.clear();
        getIt<Variables>().generalVariables.currentUserBottomNavigationList = List.generate(
            getIt<Variables>().generalVariables.userData.bottomItemsList.length,
            (i) => getIt<Variables>().generalVariables.bottomNavigateDrawerList[0]);
        getIt<Variables>().generalVariables.currentUserSideDrawerList = List.generate(
            getIt<Variables>().generalVariables.userData.sideItemsList.length,
            (i) => getIt<Variables>().generalVariables.bottomNavigateDrawerList[0]);
        for (int i = 0; i < getIt<Variables>().generalVariables.bottomNavigateDrawerList.length; i++) {
          for (int j = 0; j < getIt<Variables>().generalVariables.userData.bottomItemsList.length; j++) {
            if (getIt<Variables>().generalVariables.userData.bottomItemsList[j] ==
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[i].id) {
              getIt<Variables>().generalVariables.currentUserBottomNavigationList[j] =
                  getIt<Variables>().generalVariables.bottomNavigateDrawerList[i];
            }
          }
          for (int k = 0; k < getIt<Variables>().generalVariables.userData.sideItemsList.length; k++) {
            if (getIt<Variables>().generalVariables.userData.sideItemsList[k] ==
                getIt<Variables>().generalVariables.bottomNavigateDrawerList[i].id) {
              getIt<Variables>().generalVariables.currentUserSideDrawerList[k] =
                  getIt<Variables>().generalVariables.bottomNavigateDrawerList[i];
            }
          }
        }
        getIt<Variables>().generalVariables.selectedIndex = getIt<Variables>()
            .generalVariables
            .userData
            .sideItemsList
            .indexOf(getIt<Variables>().generalVariables.currentUserSideDrawerList[event.index].id);
      } else {
        getIt<Variables>().generalVariables.bottomNavigateDrawerList[0].name =
            getIt<Variables>().generalVariables.currentLanguage.home;
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
        getIt<Variables>().generalVariables.selectedIndex = getIt<Variables>()
            .generalVariables
            .initialSetupValues
            .sideNav
            .indexOf(getIt<Variables>().generalVariables.currentUserSideDrawerList[event.index].id);
      }
      getIt<Variables>().generalVariables.indexName =
          getIt<Variables>().generalVariables.currentUserSideDrawerList[event.index].navigateTo;
    }
  }

  FutureOr<void> languageChangingFunction(LanguageChangingEvent event, Emitter<NavigationState> emit) async {
    getIt<Variables>().generalVariables.loggedHeaders.lang = getIt<Variables>().generalVariables.languageList[event.index].code;
    var usersBoxList = getIt<Variables>().generalVariables.userBox!;
    for (var model in usersBoxList.values) {
      model.loggedHeaders.lang = getIt<Variables>().generalVariables.languageList[event.index].code;
      await model.save();
    }
    LanguageData languageData = getIt<Variables>().generalVariables.languageBox!.values.first;
    getIt<Variables>().generalVariables.languageList = languageData.languageList;
    Map<String, dynamic> currentLanguageData = languageData.languageValueString
        .singleWhere((element) => element["lang_code"] == getIt<Variables>().generalVariables.loggedHeaders.lang);
    getIt<Variables>().generalVariables.currentLanguage = Languages.fromJson(currentLanguageData);
    emit(LanguageChanged());
    emit(NavigationLoaded());
  }

  FutureOr<void> navigationSetStateFunction(NavigationSetStateEvent event, Emitter<NavigationState> emit) async {
    emit(LanguageDummy());
    emit(NavigationLoaded());
  }

  FutureOr<void> listenConnectivityFunction(ListenConnectivity event, Emitter<NavigationState> emit) async {
    await Connectivity().checkConnectivity();
    Connectivity().onConnectivityChanged.listen((event) {
      getIt<Variables>().generalVariables.isNetworkOffline = event.contains(ConnectivityResult.none);
      if (getIt<Variables>().generalVariables.isNetworkOffline) {
        getIt<Variables>().generalVariables.isBottomSheetOpen = true;
        scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: Text(getIt<Variables>().generalVariables.currentLanguage.offlineConnection),
          duration: const Duration(seconds: 10),
        ));
      } else {
        if (getIt<Variables>().generalVariables.isBottomSheetOpen) {
          scaffoldKey.currentState
              ?.showSnackBar(SnackBar(content: Text(getIt<Variables>().generalVariables.currentLanguage.connectionRestore)));
          getIt<Variables>().generalVariables.isBottomSheetOpen = false;
        }
        WarehousePickupSummaryBloc().networkApiCalls();
        TripListDetailsBloc().networkApiCalls();
        PickListDetailsBloc().networkApiCalls();
      }
    });
  }
}
