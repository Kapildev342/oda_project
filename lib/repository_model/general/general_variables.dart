// Dart imports:
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';

// Project imports:
import 'package:oda/local_database/language_box/language.dart';
import 'package:oda/local_database/pick_list_box/pick_list.dart';
import 'package:oda/local_database/trip_box/trip_list.dart';
import 'package:oda/local_database/user_box/user.dart';
import 'package:oda/repository_model/general/initial_function_response_model.dart';
import 'package:oda/repository_model/general/languages.dart';
import 'package:oda/screens/back_to_store/back_to_store_screen.dart';
import 'package:oda/screens/catch_weight/catch_weight_screen.dart';
import 'package:oda/screens/dispute/dispute_screen.dart';
import 'package:oda/screens/out_bound/out_bound_screen.dart';
import 'package:oda/screens/pick_list/pick_list_screen.dart';
import 'package:oda/screens/ro_trip_list/ro_trip_list_screen.dart';
import 'package:oda/screens/settings/settings_screen.dart';
import 'package:oda/screens/tasks/task_screen.dart';
import 'package:oda/screens/trip_list/trip_list_screen.dart';
import 'package:oda/screens/warehouse_pickup/warehouse_pickup_screen.dart';

class GeneralVariables {
  double height;
  double width;
  TextScaler? text;
  bool isNetworkOffline;
  bool isBottomSheetOpen;
  bool isDeviceTablet;
  DateTime? popUpTime;
  String disputeTab;
  String packageVersion;
  String indexName;
  List<String> loginRouteList;
  List<String> homeRouteList;
  List<String> pickListRouteList;
  List<String> catchWeightRouteList;
  List<String> btsRouteList;
  List<String> disputeRouteList;
  List<String> settingsRouteList;
  List<String> tripListRouteList;
  List<String> roTripListRouteList;
  List<String> outBoundRouteList;
  List<String> warehouseRouteList;
  List<String> taskRouteList;
  bool isLoggedIn;
  bool isConfirmLoggedIn;
  String tempCurrentPassword;
  String tempLoginIdForOtp;
  String tempIdForOtp;
  AppBar mainAppBar;
  Widget mainWidget;
  Widget popUpWidget;
  RemoteMessage? backgroundMessage;
  HeadersLoggedData loggedHeaders;
  int selectedIndex;
  InitialFunctionResponse initialSetupValues;
  UserProfile profileValues;
  List<BottomBarDrawerResponse> bottomNavigateDrawerList;
  List<BottomBarDrawerResponse> currentUserBottomNavigationList;
  List<BottomBarDrawerResponse> currentUserSideDrawerList;
  List<BackGroundColorModel> backGroundChangesList;
  BackGroundColorModel currentBackGround;
  List<LanguageListModel> languageList;
  Languages currentLanguage;
  Uint8List? profileNetworkImage;
  Box<UserResponse>? userBox;
  Box<LanguageData>? languageBox;
  UserResponse userData;
  String userDataEmployeeCode;
  LanguageData languageData;
  List<Filter> filters;
  List<FilterOptionsResponse> filterItemsListOptions;
  List<FilterOptionsResponse> filterCustomersOptions;
  List<FilterOptionsResponse> usersList;
  int filterSelectedMainIndex;
  List<SelectedFilterModel> selectedFilters;
  List<String> selectedFiltersName;
  List<FilterOptionsResponse> searchedResultFilterOption;
  TextEditingController filterSearchController;
  TextEditingController filterStartDateController;
  TextEditingController filterEndDateController;
  DateTime? selectedFilterStartDate;
  DateTime? selectedFilterEndDate;
  bool isStatusDrawer;
  bool atLeastOneDateEmpty;
  TextEditingController filterSingleDateController;
  DateTime? selectedFilterSingleDate;
  PicklistItem picklistItemData;
  TripList tripListMainIdData;
  SoList soListMainIdData;
  RoTripList roTripListMainIdData;
  //socket
  String picklistSocketTempId;
  String picklistSocketTempStatus;
  List<TimelineInfo> timelineInfo;
  String socketMessageId;

  GeneralVariables({
    required this.mainAppBar,
    required this.mainWidget,
    required this.height,
    required this.width,
    required this.text,
    required this.indexName,
    required this.loginRouteList,
    required this.homeRouteList,
    required this.pickListRouteList,
    required this.catchWeightRouteList,
    required this.btsRouteList,
    required this.disputeRouteList,
    required this.settingsRouteList,
    required this.tripListRouteList,
    required this.roTripListRouteList,
    required this.outBoundRouteList,
    required this.warehouseRouteList,
    required this.taskRouteList,
    required this.selectedIndex,
    required this.isLoggedIn,
    required this.isNetworkOffline,
    required this.isConfirmLoggedIn,
    required this.isBottomSheetOpen,
    required this.isDeviceTablet,
    required this.loggedHeaders,
    required this.initialSetupValues,
    required this.profileValues,
    required this.tempCurrentPassword,
    required this.tempLoginIdForOtp,
    required this.tempIdForOtp,
    required this.bottomNavigateDrawerList,
    required this.currentUserBottomNavigationList,
    required this.currentUserSideDrawerList,
    required this.userBox,
    required this.languageBox,
    required this.userData,
    required this.userDataEmployeeCode,
    required this.languageData,
    required this.languageList,
    required this.currentLanguage,
    required this.profileNetworkImage,
    required this.filters,
    required this.filterItemsListOptions,
    required this.filterCustomersOptions,
    required this.usersList,
    required this.filterSelectedMainIndex,
    required this.popUpWidget,
    required this.popUpTime,
    required this.disputeTab,
    required this.packageVersion,
    required this.backgroundMessage,
    required this.selectedFilters,
    required this.selectedFiltersName,
    required this.searchedResultFilterOption,
    required this.filterSearchController,
    required this.filterStartDateController,
    required this.filterEndDateController,
    required this.selectedFilterStartDate,
    required this.selectedFilterEndDate,
    required this.backGroundChangesList,
    required this.currentBackGround,
    required this.isStatusDrawer,
    required this.atLeastOneDateEmpty,
    required this.filterSingleDateController,
    required this.selectedFilterSingleDate,
    required this.picklistItemData,
    required this.tripListMainIdData,
    required this.soListMainIdData,
    required this.roTripListMainIdData,
    required this.picklistSocketTempId,
    required this.picklistSocketTempStatus,
    required this.timelineInfo,
    required this.socketMessageId,
  });

  factory GeneralVariables.fromJson(Map<String, dynamic> json) => GeneralVariables(
        mainAppBar: json["main_app_bar"] ?? AppBar(),
        mainWidget: json["main_widget"] ?? const SizedBox(),
        height: json["kHeight"] ?? 0.0,
        width: json["kWidth"] ?? 0.0,
        text: json["kText"],
        indexName: json["index_name"] ?? "",
        loginRouteList: List<String>.from((json["login_route_list"] ?? []).map((x) => x)),
        homeRouteList: List<String>.from((json["home_route_list"] ?? []).map((x) => x)),
        pickListRouteList: List<String>.from((json["pick_list_route_list"] ?? []).map((x) => x)),
        catchWeightRouteList: List<String>.from((json["catch_weight_route_list"] ?? []).map((x) => x)),
        btsRouteList: List<String>.from((json["bts_route_list"] ?? []).map((x) => x)),
        disputeRouteList: List<String>.from((json["dispute_route_list"] ?? []).map((x) => x)),
        tripListRouteList: List<String>.from((json["trip_list_route_list"] ?? []).map((x) => x)),
        roTripListRouteList: List<String>.from((json["ro_trip_list_route_list"] ?? []).map((x) => x)),
        settingsRouteList: List<String>.from((json["settings_route_list"] ?? []).map((x) => x)),
        outBoundRouteList: List<String>.from((json["out_bound_route_list"] ?? []).map((x) => x)),
        warehouseRouteList: List<String>.from((json["warehouse_route_list"] ?? []).map((x) => x)),
    taskRouteList: List<String>.from((json["task_route_list"] ?? []).map((x) => x)),
        selectedIndex: json["selected_index"] ?? -1,
        isLoggedIn: json["is_logged_in"] ?? false,
        isNetworkOffline: json["is_network_offline"] ?? false,
        isConfirmLoggedIn: json["is_confirm_logged_in"] ?? false,
        isBottomSheetOpen: json["is_bottom_sheet_open"] ?? false,
        isDeviceTablet: json["is_device_tablet"] ?? false,
        loggedHeaders: HeadersLoggedData.fromJson(json["logged_headers"] ?? {}),
        initialSetupValues: InitialFunctionResponse.fromJson(json["initial_setup_values"] ?? {}),
        profileValues: UserProfile.fromJson(json["profile_values"] ?? {}),
        tempCurrentPassword: json["temp_current_password"] ?? "",
        tempLoginIdForOtp: json["temp_login_id_for_otp"] ?? "",
        tempIdForOtp: json["temp_id_for_otp"] ?? "",
        bottomNavigateDrawerList: List<BottomBarDrawerResponse>.from(((json["bottom_navigate_drawer"] ??
                [
                  {
                    "id": "dashboard",
                    "name": "Home",
                    "selected_image": "assets/bottom_navigation/home_filled.svg",
                    "default_image": "assets/bottom_navigation/home_default.svg",
                    "drawer_image": "assets/drawer/home_drawer.svg",
                    "navigate_to": TaskScreen.id
                  },
                  {
                    "id": "picklist",
                    "name": "Pick List",
                    "selected_image": "assets/bottom_navigation/picklist_filled.svg",
                    "default_image": "assets/bottom_navigation/pick_list_default.svg",
                    "drawer_image": "assets/drawer/pick_list_drawer.svg",
                    "navigate_to": PickListScreen.id
                  },
                  {
                    "id": "catchweight",
                    "name": "Catch Weight",
                    "selected_image": "assets/bottom_navigation/catch_weight_filled.svg",
                    "default_image": "assets/bottom_navigation/catch_weight_default.svg",
                    "drawer_image": "assets/drawer/catch_weight_drawer.svg",
                    "navigate_to": CatchWeightScreen.id
                  },
                  {
                    "id": "bts",
                    "name": "BTS",
                    "selected_image": "assets/bottom_navigation/bts_filled.svg",
                    "default_image": "assets/bottom_navigation/bts_default.svg",
                    "drawer_image": "assets/drawer/bts_drawer.svg",
                    "navigate_to": BackToStoreScreen.id
                  },
                  {
                    "id": "dispute",
                    "name": "Dispute",
                    "selected_image": "assets/bottom_navigation/dispute_filled.svg",
                    "default_image": "assets/bottom_navigation/dispute_default.svg",
                    "drawer_image": "assets/drawer/dispute_drawer.svg",
                    "navigate_to": DisputeScreen.id
                  },
                  {
                    "id": "settings",
                    "name": "Settings",
                    "selected_image": "assets/bottom_navigation/settings_filled.svg",
                    "default_image": "assets/bottom_navigation/settings_default.svg",
                    "drawer_image": "assets/drawer/settings_drawer.svg",
                    "navigate_to": SettingsScreen.id
                  },
                  {
                    "id": "triplist",
                    "name": "Trip List",
                    "selected_image": "assets/bottom_navigation/trip_list_filled.svg",
                    "default_image": "assets/bottom_navigation/trip_list_default.svg",
                    "drawer_image": "assets/drawer/trip_list_drawer.svg",
                    "navigate_to": TripListScreen.id
                  },
                  {
                    "id": "outbound",
                    "name": "Out Bound",
                    "selected_image": "assets/bottom_navigation/trip_list_filled.svg",
                    "default_image": "assets/bottom_navigation/trip_list_default.svg",
                    "drawer_image": "assets/drawer/trip_list_drawer.svg",
                    "navigate_to": OutBoundScreen.id
                  },
                  {
                    "id": "storepickup",
                    "name": "Warehouse Pickup",
                    "selected_image": "assets/bottom_navigation/ware_house_filled.svg",
                    "default_image": "assets/bottom_navigation/ware_house_default.svg",
                    "drawer_image": "assets/drawer/warehouse_drawer.svg",
                    "navigate_to": WarehousePickupScreen.id
                  },
                  {
                    "id": "ro_trip",
                    "name": "Trip details",
                    "selected_image": "assets/bottom_navigation/trip_list_filled.svg",
                    "default_image": "assets/bottom_navigation/trip_list_default.svg",
                    "drawer_image": "assets/drawer/trip_list_drawer.svg",
                    "navigate_to": RoTripListScreen.id
                  },
                  {
                    "id": "task",
                    "name": "Tasks",
                    "selected_image": "assets/drawer/tasks.svg",
                    "default_image": "assets/drawer/tasks.svg",
                    "drawer_image": "assets/drawer/tasks.svg",
                    "navigate_to": TaskScreen.id
                  },
                ])
            .map((x) => BottomBarDrawerResponse.fromJson(x)))),
        currentUserBottomNavigationList:
            List<BottomBarDrawerResponse>.from(((json["current_user_navigation_list"] ?? []).map((x) => BottomBarDrawerResponse.fromJson(x)))),
        currentUserSideDrawerList:
            List<BottomBarDrawerResponse>.from(((json["current_user_side_drawer_list"] ?? []).map((x) => BottomBarDrawerResponse.fromJson(x)))),
        userBox: json["user_box"],
        languageBox: json["language_box"],
        userData: json["user_data"] ?? UserResponse.fromJson({}),
        userDataEmployeeCode: json["user_data_employee_code"] ?? "",
        languageData: json["language_data"] ?? LanguageData.fromJson({}),
        languageList: List<LanguageListModel>.from(((json["language_list"] ?? [])).map((x) => LanguageListModel.fromJson(x))),
        currentLanguage: Languages.fromJson(json["current_language"] ?? {}),
        profileNetworkImage: json["profile_network_image"],
        popUpWidget: json["pop_up_widget"] ?? const SizedBox(),
        filters: List<Filter>.from((json["filters"] ?? []).map((x) => Filter.fromJson(x))),
        filterItemsListOptions:
            List<FilterOptionsResponse>.from((json["filters_items_list_options"] ?? []).map((x) => FilterOptionsResponse.fromJson(x))),
        filterCustomersOptions:
            List<FilterOptionsResponse>.from((json["filters_customers_options"] ?? []).map((x) => FilterOptionsResponse.fromJson(x))),
        usersList: List<FilterOptionsResponse>.from((json["users_list"] ?? []).map((x) => FilterOptionsResponse.fromJson(x))),
        filterSelectedMainIndex: json["filter_selected_main_index"] ?? 0,
        popUpTime: json["pop_up_time"],
        disputeTab: json["dispute_tab"] ?? "",
        packageVersion: json["package_version"] ?? "",
        backgroundMessage: json["background_message"],
        filterStartDateController: json["filter_start_date_controller"] ?? TextEditingController(),
        filterEndDateController: json["filter_end_date_controller"] ?? TextEditingController(),
        selectedFilterStartDate: json["selected_filter_start_date"],
        selectedFilterEndDate: json["selected_filter_end_date"],
        filterSearchController: json["filter_search_controller"] ?? TextEditingController(),
        selectedFilters: List<SelectedFilterModel>.from(((json["selected_filters"] ?? [])).map((x) => SelectedFilterModel.fromJson(x))),
        selectedFiltersName: List<String>.from(((json["selected_filters_name"] ?? [])).map((x) => x)),
        searchedResultFilterOption:
            List<FilterOptionsResponse>.from(((json["searched_result_filter_option"] ?? [])).map((x) => FilterOptionsResponse.fromJson(x))),
        backGroundChangesList: List<BackGroundColorModel>.from(((json["back_ground_changes_list"] ??
                [
                  {
                    "id": "all",
                    "symbol": "B",
                    "color": const Color(0xff8135A1),
                    "bg_color1": const Color(0xff3C2247),
                    "bg_color2": const Color(0xff8135A1),
                    "font_color": const Color(0xff5AC8FA)
                  },
                  {
                    "id": "dry",
                    "symbol": "D",
                    "color": const Color(0xffB25000),
                    "bg_color1": const Color(0xff4A2607),
                    "bg_color2": const Color(0xffBB8A62),
                    "font_color": const Color(0xff50D464)
                  },
                  {
                    "id": "frozen",
                    "symbol": "F",
                    "color": const Color(0xff7876D9),
                    "bg_color1": const Color(0xff1B1A47),
                    "bg_color2": const Color(0xff7876D9),
                    "font_color": const Color(0xff5AC8FA)
                  }
                ]))
            .map((x) => BackGroundColorModel.fromJson(x))),
        currentBackGround: BackGroundColorModel.fromJson(json["current_back_ground"] ?? {}),
        isStatusDrawer: json["is_status_drawer"] ?? false,
        atLeastOneDateEmpty: json["at_least_one_date_empty"] ?? false,
        filterSingleDateController: json["filter_single_date_controller"] ?? TextEditingController(),
        selectedFilterSingleDate: json["selected_filter_single_date"],
        picklistItemData: json["pick_list_item_id_data"] ?? PicklistItem.fromJson({}),
        tripListMainIdData: json["trip_list_main_id_data"] ?? TripList.fromJson({}),
        soListMainIdData: json["so_list_main_id_data"] ?? SoList.fromJson({}),
        roTripListMainIdData: json["ro_trip_list_main_id_data"] ?? RoTripList.fromJson({}),
        picklistSocketTempId: json["picklist_socket_temp_id"] ?? '',
        picklistSocketTempStatus: json["picklist_socket_temp_status"] ?? '',
        timelineInfo: List.from((json["time_line_info"] ?? []).map((x) => TimelineInfo.fromJson(x))),
    socketMessageId: json["socket_message_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "main_app_bar": mainAppBar,
        "main_widget": mainWidget,
        "kHeight": height,
        "kWidth": width,
        "kText": text,
        "index_name": indexName,
        "login_route_list": loginRouteList,
        "home_route_list": homeRouteList,
        "pick_list_route_list": pickListRouteList,
        "catch_weight_route_list": catchWeightRouteList,
        "bts_route_list": btsRouteList,
        "settings_route_list": settingsRouteList,
        "dispute_route_list": disputeRouteList,
        "trip_list_route_list": tripListRouteList,
        "ro_trip_list_route_list": roTripListRouteList,
        "out_bound_route_list": outBoundRouteList,
        "warehouse_route_list": warehouseRouteList,
        "task_route_list": taskRouteList,
        "selected_index": selectedIndex,
        "is_logged_in": isLoggedIn,
        "is_network_offline": isNetworkOffline,
        "is_confirm_logged_in": isConfirmLoggedIn,
        "is_bottom_sheet_open": isBottomSheetOpen,
        "is_device_tablet": isDeviceTablet,
        "logged_headers": loggedHeaders.toJson(),
        "initial_setup_values": initialSetupValues.toJson(),
        "profile_values": profileValues.toJson(),
        "temp_current_password": tempCurrentPassword,
        "temp_login_id_for_otp": tempLoginIdForOtp,
        "temp_id_for_otp": tempIdForOtp,
        "bottom_navigate_drawer": bottomNavigateDrawerList,
        "current_user_navigation_list": currentUserBottomNavigationList,
        "current_user_side_drawer_list": currentUserSideDrawerList,
        "user_box": userBox,
        "language_box": languageBox,
        "user_data": userData,
        "user_data_employee_code": userDataEmployeeCode,
        "language_data": languageData,
        "language_list": languageList,
        "current_language": currentLanguage.toJson(),
        "profile_network_image": profileNetworkImage,
        "filters": filters,
        "filters_items_list_options": filterItemsListOptions,
        "filters_customers_options": filterCustomersOptions,
        "users_list": usersList,
        "filter_selected_main_index": filterSelectedMainIndex,
        "pop_up_widget": popUpWidget,
        "pop_up_time": popUpTime,
        "dispute_tab": disputeTab,
        "package_version": packageVersion,
        "background_message": backgroundMessage,
        "selected_filters": selectedFilters,
        "selected_filters_name": selectedFiltersName,
        "searched_result_filter_option": searchedResultFilterOption,
        "filter_search_controller": filterSearchController,
        "filter_start_date_controller": filterStartDateController,
        "filter_end_date_controller": filterEndDateController,
        "selected_filter_start_date": selectedFilterStartDate,
        "selected_filter_end_date": selectedFilterEndDate,
        "back_ground_changes_list": backGroundChangesList,
        "current_back_ground": currentBackGround.toJson(),
        "is_status_drawer": isStatusDrawer,
        "at_least_one_date_empty": atLeastOneDateEmpty,
        "filter_single_date_controller": filterSingleDateController,
        "selected_filter_single_date": selectedFilterSingleDate,
        "pick_list_item_id_data": picklistItemData,
        "trip_list_main_id_data": tripListMainIdData,
        "so_list_main_id_data": soListMainIdData,
        "ro_trip_list_main_id_data": roTripListMainIdData,
        "picklist_socket_temp_id": picklistSocketTempId,
        "picklist_socket_temp_status": picklistSocketTempStatus,
        "time_line_info": timelineInfo,
        "socket_message_id": socketMessageId,
      };
}

class BottomBarDrawerResponse {
  String id;
  String name;
  String selectedImage;
  String defaultImage;
  String drawerImage;
  String navigateTo;

  BottomBarDrawerResponse({
    required this.id,
    required this.name,
    required this.selectedImage,
    required this.defaultImage,
    required this.drawerImage,
    required this.navigateTo,
  });

  factory BottomBarDrawerResponse.fromJson(Map<String, dynamic> json) => BottomBarDrawerResponse(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        selectedImage: json["selected_image"] ?? "",
        defaultImage: json["default_image"] ?? "",
        drawerImage: json["drawer_image"] ?? "",
        navigateTo: json["navigate_to"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "selected_image": selectedImage,
        "default_image": defaultImage,
        "drawer_image": drawerImage,
        "navigate_to": navigateTo,
      };
}

class SelectedFilterModel {
  final String type;
  final List<String> options;
  final List<SubOption>? subOptions;

  SelectedFilterModel({
    required this.type,
    required this.options,
    this.subOptions,
  });

  factory SelectedFilterModel.fromJson(Map<String, dynamic> json) => SelectedFilterModel(
        type: json["type"] ?? "",
        options: List<String>.from((json["options"] ?? []).map((x) => x)),
        subOptions: List<SubOption>.from((json["sub_options"]).map((x) => SubOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => subOptions != null
      ? {
          "type": type,
          "options": List<dynamic>.from(options.map((x) => x)),
          "sub_options": List<dynamic>.from(subOptions!.map((x) => x.toJson())),
        }
      : {
          "type": type,
          "options": List<dynamic>.from(options.map((x) => x)),
        };
}

class SubOption {
  String room;
  List<String> zone;

  SubOption({
    required this.room,
    required this.zone,
  });

  factory SubOption.fromJson(Map<String, dynamic> json) => SubOption(
        room: json["room"] ?? "",
        zone: List<String>.from((json["zone"] ?? []).map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "room": room,
        "zone": List<dynamic>.from(zone.map((x) => x)),
      };
}

class BackGroundColorModel {
  final String id;
  final String symbol;
  final Color color;
  final Color bgColor1;
  final Color bgColor2;
  final Color fontColor;

  BackGroundColorModel({
    required this.id,
    required this.symbol,
    required this.color,
    required this.bgColor1,
    required this.bgColor2,
    required this.fontColor,
  });

  factory BackGroundColorModel.fromJson(Map<String, dynamic> json) => BackGroundColorModel(
        id: json["id"] ?? "",
        symbol: json["symbol"] ?? "",
        color: json["color"] ?? Colors.white,
        bgColor1: json["bg_color1"] ?? Colors.white,
        bgColor2: json["bg_color2"] ?? Colors.white,
        fontColor: json["font_color"] ?? Colors.white,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "symbol": symbol,
        "color": color,
        "bg_color1": bgColor1,
        "bg_color2": bgColor2,
        "font_color": fontColor,
      };
}
