// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:oda/bloc/ro_trip_list/ro_trip_list_main/ro_trip_list_main_bloc.dart';
import 'package:oda/bloc/warehouse_pickup/warehouse_pickup_detail/warehouse_pickup_detail_bloc.dart';
import 'package:oda/bloc/warehouse_pickup/warehouse_pickup_main/warehouse_pickup_bloc.dart';
import 'package:oda/screens/ro_trip_list/ro_trip_list_screen.dart';
import 'package:oda/screens/warehouse_pickup/warehouse_pickup_detail_screen.dart';
import 'package:oda/screens/warehouse_pickup/warehouse_pickup_screen.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// Project imports:
import 'package:oda/bloc/back_to_store/back_to_store/back_to_store_bloc.dart';
import 'package:oda/bloc/catch_weight/catch_weight_bloc.dart';
import 'package:oda/bloc/dispute/dispute_main/dispute_main_bloc.dart';
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/bloc/out_bound/out_bound_detail/out_bound_detail_bloc.dart';
import 'package:oda/bloc/out_bound/out_bound_entry/out_bound_entry_bloc.dart';
import 'package:oda/bloc/out_bound/out_bound_main/out_bound_bloc.dart';
import 'package:oda/bloc/pick_list/pick_list/pick_list_bloc.dart';
import 'package:oda/bloc/pick_list/pick_list_details/pick_list_details_bloc.dart';
import 'package:oda/bloc/trip_list/trip_list_detail/trip_list_detail_bloc.dart';
import 'package:oda/bloc/trip_list/trip_list_entry/trip_list_entry_bloc.dart';
import 'package:oda/bloc/trip_list/trip_list_main/trip_list_bloc.dart';
import 'package:oda/edited_packages/title_bottom_navigation/titled_navigation_bar.dart';
import 'package:oda/local_database/user_box/user.dart';
import 'package:oda/repository_model/general/general_variables.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/screens/back_to_store/back_to_store_screen.dart';
import 'package:oda/screens/catch_weight/catch_weight_screen.dart';
import 'package:oda/screens/dispute/dispute_screen.dart';
import 'package:oda/screens/home/home_screen.dart';
import 'package:oda/screens/out_bound/out_bound_detail_screen.dart';
import 'package:oda/screens/out_bound/out_bound_entry_screen.dart';
import 'package:oda/screens/out_bound/out_bound_screen.dart';
import 'package:oda/screens/pick_list/pick_list_details_screen.dart';
import 'package:oda/screens/pick_list/pick_list_screen.dart';
import 'package:oda/screens/settings/settings_screen.dart';
import 'package:oda/screens/trip_list/trip_list_detail_screen.dart';
import 'package:oda/screens/trip_list/trip_list_entry_screen.dart';
import 'package:oda/screens/trip_list/trip_list_screen.dart';

class Widgets {
  final GlobalKey flushBarKey = GlobalKey();
  Widget primaryContainerWidget({required Widget body, required BuildContext context}) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: drawerWidget(context: context),
      endDrawer: endDrawerWidget(context: context),
      onEndDrawerChanged: (value) {
        if (!value) {
          getIt<Variables>().generalVariables.isStatusDrawer = false;
          getIt<Variables>().generalVariables.filterSearchController.clear();
          getIt<Variables>().generalVariables.filterSelectedMainIndex = 0;
          getIt<Variables>().generalVariables.searchedResultFilterOption =
              getIt<Variables>().generalVariables.filters[getIt<Variables>().generalVariables.filterSelectedMainIndex].options;
          for (int i = 0; i < getIt<Variables>().generalVariables.filters.length; i++) {
            getIt<Variables>().generalVariables.filters[i].status = false;
            if (getIt<Variables>().generalVariables.filters[i].type == "date_range") {
              getIt<Variables>().generalVariables.filterStartDateController.clear();
              getIt<Variables>().generalVariables.filterEndDateController.clear();
              getIt<Variables>().generalVariables.selectedFilterStartDate = null;
              getIt<Variables>().generalVariables.selectedFilterEndDate = null;
            } else if (getIt<Variables>().generalVariables.filters[i].type == "business_dt") {
              getIt<Variables>().generalVariables.filterSingleDateController.clear();
              getIt<Variables>().generalVariables.selectedFilterSingleDate = null;
            } else if (getIt<Variables>().generalVariables.filters[i].type == "locations") {
              for (int j = 0; j < getIt<Variables>().generalVariables.filters[i].options.length; j++) {
                getIt<Variables>().generalVariables.filters[i].options[j].status = false;
                for (int k = 0; k < (getIt<Variables>().generalVariables.filters[i].options[j].room).length; k++) {
                  getIt<Variables>().generalVariables.filters[i].options[j].room[k].status = false;
                  for (int l = 0; l < getIt<Variables>().generalVariables.filters[i].options[j].room[k].zone.length; l++) {
                    getIt<Variables>().generalVariables.filters[i].options[j].room[k].zone[l].status = false;
                  }
                }
              }
            } else {
              for (int j = 0; j < getIt<Variables>().generalVariables.filters[i].options.length; j++) {
                getIt<Variables>().generalVariables.filters[i].options[j].status = false;
              }
            }
          }
          List<String> tempSelectedMainFilterList = List.generate(
              getIt<Variables>().generalVariables.selectedFilters.length, (i) => getIt<Variables>().generalVariables.selectedFilters[i].type);
          for (int i = 0; i < getIt<Variables>().generalVariables.filters.length; i++) {
            if (tempSelectedMainFilterList.contains(getIt<Variables>().generalVariables.filters[i].type)) {
              getIt<Variables>().generalVariables.filters[i].status = true;
              SelectedFilterModel tempSelectedFilterOption = getIt<Variables>()
                  .generalVariables
                  .selectedFilters
                  .singleWhere((element) => element.type == getIt<Variables>().generalVariables.filters[i].type);
              if (getIt<Variables>().generalVariables.filters[i].type == "date_range") {
                getIt<Variables>().generalVariables.filterStartDateController.text = tempSelectedFilterOption.options[0];
                getIt<Variables>().generalVariables.filterEndDateController.text = tempSelectedFilterOption.options[1];
                List<String> tempStartTime = tempSelectedFilterOption.options[0].split("/");
                List<String> tempEndTime = tempSelectedFilterOption.options[1].split("/");
                getIt<Variables>().generalVariables.selectedFilterStartDate = getIt<Variables>().generalVariables.filterStartDateController.text == ""
                    ? null
                    : DateTime(int.parse(tempStartTime[2]), int.parse(tempStartTime[1]), int.parse(tempStartTime[0]));
                getIt<Variables>().generalVariables.selectedFilterEndDate = getIt<Variables>().generalVariables.filterEndDateController.text == ""
                    ? null
                    : DateTime(int.parse(tempEndTime[2]), int.parse(tempEndTime[1]), int.parse(tempEndTime[0]));
              } else if (getIt<Variables>().generalVariables.filters[i].type == "business_dt") {
                getIt<Variables>().generalVariables.filterSingleDateController.text = tempSelectedFilterOption.options[0];
                List<String> tempSingleTime = tempSelectedFilterOption.options[0].split("/");
                getIt<Variables>().generalVariables.selectedFilterSingleDate =
                    DateTime(int.parse(tempSingleTime[2]), int.parse(tempSingleTime[1]), int.parse(tempSingleTime[0]));
              } else if (getIt<Variables>().generalVariables.filters[i].type == "locations") {
                for (int j = 0; j < getIt<Variables>().generalVariables.filters[i].options.length; j++) {
                  if (tempSelectedFilterOption.options.contains(getIt<Variables>().generalVariables.filters[i].options[j].id)) {
                    getIt<Variables>().generalVariables.filters[i].options[j].status = true;
                    for (int k = 0; k < getIt<Variables>().generalVariables.filters[i].options[j].room.length; k++) {
                      if (tempSelectedFilterOption.subOptions != null) {
                        for (int l = 0; l < tempSelectedFilterOption.subOptions!.length; l++) {
                          if (getIt<Variables>().generalVariables.filters[i].options[j].room[k].id == tempSelectedFilterOption.subOptions![l].room) {
                            getIt<Variables>().generalVariables.filters[i].options[j].room[k].status = true;
                            for (int m = 0; m < getIt<Variables>().generalVariables.filters[i].options[j].room[k].zone.length; m++) {
                              if (tempSelectedFilterOption.subOptions![l].zone
                                  .contains(getIt<Variables>().generalVariables.filters[i].options[j].room[k].zone[m].id)) {
                                getIt<Variables>().generalVariables.filters[i].options[j].room[k].zone[m].status = true;
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              } else {
                for (int j = 0; j < getIt<Variables>().generalVariables.filters[i].options.length; j++) {
                  if (tempSelectedFilterOption.options.contains(getIt<Variables>().generalVariables.filters[i].options[j].id)) {
                    getIt<Variables>().generalVariables.filters[i].options[j].status = true;
                  }
                }
              }
            }
          }
        } else {
          getIt<Variables>().generalVariables.filterSearchController.clear();
          getIt<Variables>().generalVariables.filterSelectedMainIndex = 0;
          getIt<Variables>().generalVariables.searchedResultFilterOption =
              getIt<Variables>().generalVariables.filters[getIt<Variables>().generalVariables.filterSelectedMainIndex].options;
          for (int i = 0; i < getIt<Variables>().generalVariables.filters.length; i++) {
            getIt<Variables>().generalVariables.filters[i].status = false;
            if (getIt<Variables>().generalVariables.filters[i].type == "date_range") {
              getIt<Variables>().generalVariables.filterStartDateController.clear();
              getIt<Variables>().generalVariables.filterEndDateController.clear();
              getIt<Variables>().generalVariables.selectedFilterStartDate = null;
              getIt<Variables>().generalVariables.selectedFilterEndDate = null;
            } else if (getIt<Variables>().generalVariables.filters[i].type == "business_dt") {
              getIt<Variables>().generalVariables.filterSingleDateController.clear();
              getIt<Variables>().generalVariables.selectedFilterSingleDate = null;
            } else if (getIt<Variables>().generalVariables.filters[i].type == "locations") {
              for (int j = 0; j < getIt<Variables>().generalVariables.filters[i].options.length; j++) {
                getIt<Variables>().generalVariables.filters[i].options[j].status = false;
                for (int k = 0; k < getIt<Variables>().generalVariables.filters[i].options[j].room.length; k++) {
                  getIt<Variables>().generalVariables.filters[i].options[j].room[k].status = false;
                  for (int l = 0; l < getIt<Variables>().generalVariables.filters[i].options[j].room[k].zone.length; l++) {
                    getIt<Variables>().generalVariables.filters[i].options[j].room[k].zone[l].status = false;
                  }
                }
              }
            } else {
              for (int j = 0; j < getIt<Variables>().generalVariables.filters[i].options.length; j++) {
                getIt<Variables>().generalVariables.filters[i].options[j].status = false;
              }
            }
          }
          List<String> tempSelectedMainFilterList = List.generate(
              getIt<Variables>().generalVariables.selectedFilters.length, (i) => getIt<Variables>().generalVariables.selectedFilters[i].type);
          for (int i = 0; i < getIt<Variables>().generalVariables.filters.length; i++) {
            if (tempSelectedMainFilterList.contains(getIt<Variables>().generalVariables.filters[i].type)) {
              getIt<Variables>().generalVariables.filters[i].status = true;
              SelectedFilterModel tempSelectedFilterOption = getIt<Variables>()
                  .generalVariables
                  .selectedFilters
                  .singleWhere((element) => element.type == getIt<Variables>().generalVariables.filters[i].type);
              if (getIt<Variables>().generalVariables.filters[i].type == "date_range") {
                getIt<Variables>().generalVariables.filterStartDateController.text = tempSelectedFilterOption.options[0];
                getIt<Variables>().generalVariables.filterEndDateController.text = tempSelectedFilterOption.options[1];
                List<String> tempStartTime = tempSelectedFilterOption.options[0].split("/");
                List<String> tempEndTime = tempSelectedFilterOption.options[1].split("/");
                getIt<Variables>().generalVariables.selectedFilterStartDate = getIt<Variables>().generalVariables.filterStartDateController.text == ""
                    ? null
                    : DateTime(int.parse(tempStartTime[2]), int.parse(tempStartTime[1]), int.parse(tempStartTime[0]));
                getIt<Variables>().generalVariables.selectedFilterEndDate = getIt<Variables>().generalVariables.filterEndDateController.text == ""
                    ? null
                    : DateTime(int.parse(tempEndTime[2]), int.parse(tempEndTime[1]), int.parse(tempEndTime[0]));
              } else if (getIt<Variables>().generalVariables.filters[i].type == "business_dt") {
                getIt<Variables>().generalVariables.filterSingleDateController.text = tempSelectedFilterOption.options[0];
                List<String> tempSingleTime = tempSelectedFilterOption.options[0].split("/");
                getIt<Variables>().generalVariables.selectedFilterSingleDate =
                    DateTime(int.parse(tempSingleTime[2]), int.parse(tempSingleTime[1]), int.parse(tempSingleTime[0]));
              } else if (getIt<Variables>().generalVariables.filters[i].type == "locations") {
                for (int j = 0; j < getIt<Variables>().generalVariables.filters[i].options.length; j++) {
                  if (tempSelectedFilterOption.options.contains(getIt<Variables>().generalVariables.filters[i].options[j].id)) {
                    getIt<Variables>().generalVariables.filters[i].options[j].status = true;
                    for (int k = 0; k < getIt<Variables>().generalVariables.filters[i].options[j].room.length; k++) {
                      if (tempSelectedFilterOption.subOptions != null) {
                        for (int l = 0; l < tempSelectedFilterOption.subOptions!.length; l++) {
                          if (getIt<Variables>().generalVariables.filters[i].options[j].room[k].id == tempSelectedFilterOption.subOptions![l].room) {
                            getIt<Variables>().generalVariables.filters[i].options[j].room[k].status = true;
                            for (int m = 0; m < getIt<Variables>().generalVariables.filters[i].options[j].room[k].zone.length; m++) {
                              if (tempSelectedFilterOption.subOptions![l].zone
                                  .contains(getIt<Variables>().generalVariables.filters[i].options[j].room[k].zone[m].id)) {
                                getIt<Variables>().generalVariables.filters[i].options[j].room[k].zone[m].status = true;
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              } else {
                for (int j = 0; j < getIt<Variables>().generalVariables.filters[i].options.length; j++) {
                  if (tempSelectedFilterOption.options.contains(getIt<Variables>().generalVariables.filters[i].options[j].id)) {
                    getIt<Variables>().generalVariables.filters[i].options[j].status = true;
                  }
                }
              }
            }
          }
        }
      },
      body: body,
      bottomNavigationBar: getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer" ||
              getIt<Variables>().generalVariables.userData.userProfile.employeeType == "logistics_executive"
          ? getIt<Variables>().generalVariables.isLoggedIn &&
                  getIt<Variables>().generalVariables.isConfirmLoggedIn &&
                  getIt<Variables>().generalVariables.currentUserBottomNavigationList.length > 2
              ? bottomWidget(context: context)
              : const SizedBox()
          : getIt<Variables>().generalVariables.isLoggedIn &&
                  getIt<Variables>().generalVariables.isConfirmLoggedIn &&
                  getIt<Variables>().generalVariables.indexName != SettingsScreen.id &&
                  getIt<Variables>().generalVariables.currentUserBottomNavigationList.length > 2
              ? bottomWidget(context: context)
              : const SizedBox(),
    );
  }

  Future flushBarWidget({required BuildContext context, required String message}) async {
    return Flushbar(
      key: flushBarKey,
      messageText: Text(
        message,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: getIt<Functions>().getTextSize(fontSize: 14),
          color: Colors.black,
        ),
      ),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      isDismissible: true,
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 15), top: getIt<Functions>().getWidgetHeight(height: 15)),
      borderRadius: BorderRadius.circular(15),
      backgroundColor: Colors.grey.shade300,
      animationDuration: const Duration(milliseconds: 1000),
      maxWidth: getIt<Variables>().generalVariables.isDeviceTablet ? 350 : 300,
    ).show(context);
  }

  Widget bottomWidget({required BuildContext context}) {
    return TitledBottomNavigationBar(
      currentIndex: getIt<Variables>().generalVariables.selectedIndex,
      onTap: (index) {
        if (index != getIt<Variables>().generalVariables.selectedIndex) {
          context.read<NavigationBloc>().add(BottomNavigationEvent(index: index));
          context.read<NavigationBloc>().add(const NavigationInitialEvent());
        } else {
          if (getIt<Variables>().generalVariables.indexName !=
              getIt<Variables>().generalVariables.currentUserBottomNavigationList[index].navigateTo) {
            context.read<NavigationBloc>().add(BottomNavigationEvent(index: index));
            context.read<NavigationBloc>().add(const NavigationInitialEvent());
          }
        }
      },
      indicatorColor: const Color(0xff34C759),
      indicatorHeight: 0,
      inactiveStripColor: const Color(0xff0060B4),
      items: List.generate(
        getIt<Variables>().generalVariables.currentUserBottomNavigationList.length,
        (index) => TitledNavigationBarItem(
          backgroundColor:
              getIt<Variables>().generalVariables.selectedIndex == index ? const Color(0xffEEF4FF).withOpacity(0.20) : const Color(0xff0060B4),
          icon: SvgPicture.asset(
            getIt<Variables>().generalVariables.selectedIndex == index
                ? getIt<Variables>().generalVariables.currentUserBottomNavigationList[index].selectedImage
                : getIt<Variables>().generalVariables.currentUserBottomNavigationList[index].defaultImage,
            height: getIt<Functions>().getWidgetHeight(height: 22),
            width: getIt<Functions>().getWidgetWidth(width: 22),
            fit: BoxFit.fill,
          ),
          title: Text(
            getIt<Variables>().generalVariables.currentUserBottomNavigationList[index].name,
            maxLines: 1,
            style: TextStyle(
                color: Colors.white,
                fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
    );
  }

  Widget drawerWidget({required BuildContext context}) {
    return getIt<Variables>().generalVariables.isLoggedIn &&
            getIt<Variables>().generalVariables.isConfirmLoggedIn &&
            getIt<Variables>().generalVariables.indexName != SettingsScreen.id
        ? Drawer(
            backgroundColor: Colors.white,
            width: getIt<Functions>().getWidgetWidth(width: 350),
            child: Stack(
              children: <Widget>[
                Image.asset(
                  "assets/general/settings_background.png",
                  height: getIt<Functions>().getWidgetHeight(height: 184),
                  width: getIt<Functions>().getWidgetWidth(width: 798),
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 110)),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: getIt<Functions>().getWidgetHeight(height: 100),
                              width: getIt<Functions>().getWidgetWidth(width: 100),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade100,
                                  border: Border.all(color: Colors.grey.shade400),
                                  image: DecorationImage(
                                    image: getIt<Variables>().generalVariables.profileNetworkImage == null
                                        ? const NetworkImage(
                                            "https://images.pexels.com/photos/2899097/pexels-photo-2899097.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500")
                                        : MemoryImage(getIt<Variables>().generalVariables.profileNetworkImage!),
                                  )),
                            ),
                            SizedBox(
                              width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 15 : 6),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 15 : 12)),
                                Text(
                                  getIt<Variables>().generalVariables.userData.userProfile.userName,
                                  style: TextStyle(
                                      fontSize: getIt<Functions>().getTextSize(fontSize: 20),
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff282F3A)),
                                ),
                                SizedBox(
                                  height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 2 : 0),
                                ),
                                Text(
                                  getIt<Variables>().generalVariables.userData.userProfile.employeeType,
                                  style: TextStyle(
                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff007AFF)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: getIt<Variables>().generalVariables.currentUserSideDrawerList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Scaffold.of(context).closeDrawer();
                                    context.read<NavigationBloc>().add(SideDrawerNavigationEvent(index: index));
                                    context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                  },
                                  leading: SvgPicture.asset(
                                    getIt<Variables>().generalVariables.currentUserSideDrawerList[index].drawerImage,
                                    height: getIt<Functions>().getWidgetHeight(height: 22),
                                    width: getIt<Functions>().getWidgetWidth(width: 22),
                                    fit: BoxFit.fill,
                                  ),
                                  title: Text(
                                    getIt<Variables>().generalVariables.currentUserSideDrawerList[index].name,
                                    style: TextStyle(
                                        fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff1A202C)),
                                  ),
                                  trailing: getIt<Variables>().generalVariables.selectedIndex == index
                                      ? const Icon(Icons.check, color: Colors.green)
                                      : const SizedBox(),
                                ),
                                const Divider(
                                  color: Color(0xffE0E7EC),
                                  height: 0,
                                  thickness: 0.73,
                                ),
                                SizedBox(
                                    height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 20 : 0)),
                              ],
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            height: getIt<Functions>().getWidgetHeight(height: 2),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0xffFFFFFF),
                                Color(0xffBBC6CD),
                              ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                            ),
                          )),
                          SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                          Text("Version ${getIt<Variables>().generalVariables.packageVersion}"),
                          SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                          Expanded(
                              child: Container(
                            height: getIt<Functions>().getWidgetHeight(height: 2),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0xffBBC6CD),
                                Color(0xffFFFFFF),
                              ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                            ),
                          )),
                        ],
                      ),
                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 70)),
                    ],
                  ),
                )
              ],
            ),
          )
        : const SizedBox();
  }

  Widget endDrawerWidget({required BuildContext context}) {
    return BlocConsumer<NavigationBloc, NavigationState>(
      listenWhen: (NavigationState previous, NavigationState current) => previous != current,
      buildWhen: (NavigationState previous, NavigationState current) => previous != current,
      listener: (BuildContext context, NavigationState state) {},
      builder: (BuildContext context, NavigationState state) {
        return GestureDetector(
          onHorizontalDragEnd: (v) {},
          child: Drawer(
            backgroundColor: const Color(0xffffffff),
            width: getIt<Functions>().getWidgetWidth(width: 480),
            child: getIt<Variables>().generalVariables.isStatusDrawer
                ? Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getIt<Functions>().getWidgetWidth(width: 28), vertical: getIt<Functions>().getWidgetHeight(height: 25)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              getIt<Variables>().generalVariables.currentLanguage.timeLine,
                              style: TextStyle(
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 26),
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff282F3A)),
                            ),
                            InkWell(
                                onTap: () {
                                  Scaffold.of(context).closeEndDrawer();
                                },
                                child: SvgPicture.asset(
                                  "assets/catch_weight/close-circle.svg",
                                  height: getIt<Functions>().getWidgetHeight(height: 32),
                                  width: getIt<Functions>().getWidgetWidth(width: 32),
                                  fit: BoxFit.fill,
                                ))
                          ],
                        ),
                      ),
                      const Divider(color: Color(0xffE0E7EC), height: 0, thickness: 1),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: getIt<Functions>().getWidgetHeight(height: 30),
                              left: getIt<Functions>().getWidgetWidth(width: 27),
                              right: getIt<Functions>().getWidgetWidth(width: 27)),
                          child: FutureBuilder(
                              future: getIt<Functions>().timelineInfoFunction(pageRoute: getIt<Variables>().generalVariables.indexName),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: getIt<Variables>().generalVariables.timelineInfo.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/pick_list/timeline_image.svg",
                                                  height: getIt<Functions>().getWidgetHeight(height: 20),
                                                  width: getIt<Functions>().getWidgetWidth(width: 20),
                                                ),
                                                index == getIt<Variables>().generalVariables.timelineInfo.length - 1
                                                    ? const SizedBox()
                                                    : SizedBox(
                                                        height: getIt<Functions>().getWidgetHeight(height: 65),
                                                        child: const VerticalDivider(
                                                          color: Color(0xff007838),
                                                        )),
                                              ],
                                            ),
                                            SizedBox(width: getIt<Functions>().getWidgetHeight(height: 15)),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    getIt<Variables>().generalVariables.timelineInfo[index].description,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                        color: const Color(0xff282F3A)),
                                                  ),
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)),
                                                  Text(
                                                    getIt<Variables>().generalVariables.timelineInfo[index].time,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                        color: const Color(0xff8F9BB3)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                } else {
                                  return const Center(child: CircularProgressIndicator());
                                }
                              }),
                        ),
                      ),
                      const Divider(color: Color(0xffE0E7EC), height: 0, thickness: 1),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getIt<Functions>().getWidgetWidth(width: 28), vertical: getIt<Functions>().getWidgetHeight(height: 20)),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff007838),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: Size(
                              getIt<Functions>().getWidgetWidth(width: 480),
                              getIt<Functions>().getWidgetHeight(height: 50),
                            ),
                          ),
                          onPressed: () {
                            Scaffold.of(context).closeEndDrawer();
                          },
                          child: Text(
                            getIt<Variables>().generalVariables.currentLanguage.close,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 16), color: const Color(0xffffffff)),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getIt<Functions>().getWidgetWidth(width: 28), vertical: getIt<Functions>().getWidgetHeight(height: 25)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              getIt<Variables>().generalVariables.currentLanguage.filters,
                              style: TextStyle(
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 26),
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff282F3A)),
                            ),
                            InkWell(
                                onTap: () {
                                  Scaffold.of(context).closeEndDrawer();
                                },
                                child: SvgPicture.asset(
                                  "assets/catch_weight/close-circle.svg",
                                  height: getIt<Functions>().getWidgetHeight(height: 32),
                                  width: getIt<Functions>().getWidgetWidth(width: 32),
                                  fit: BoxFit.fill,
                                ))
                          ],
                        ),
                      ),
                      const Divider(color: Color(0xffE0E7EC), height: 0, thickness: 1),
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: getIt<Functions>().getWidgetWidth(width: 175),
                              color: const Color(0xffEEF4FF),
                              child: Column(
                                children: [
                                  ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      itemCount: getIt<Variables>().generalVariables.filters.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            FocusManager.instance.primaryFocus!.unfocus();
                                            getIt<Variables>().generalVariables.filterSearchController.clear();
                                            getIt<Variables>().generalVariables.filterSelectedMainIndex = index;
                                            getIt<Variables>().generalVariables.searchedResultFilterOption = getIt<Variables>()
                                                .generalVariables
                                                .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                .options;
                                            context.read<NavigationBloc>().add(const NavigationSetStateEvent());
                                          },
                                          child: Container(
                                            height: getIt<Functions>().getWidgetHeight(height: 50),
                                            width: getIt<Functions>().getWidgetWidth(width: 175),
                                            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 15)),
                                            decoration: BoxDecoration(
                                                color: getIt<Variables>().generalVariables.filterSelectedMainIndex == index
                                                    ? Colors.green.shade100
                                                    : Colors.transparent),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    // maxFontSize: getIt<Functions>().getTextSize(fontSize: 15),
                                                    // minFontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                    maxLines: 1,
                                                    getIt<Variables>().generalVariables.filters[index].label,
                                                    style: const TextStyle(color: Color(0xff282F3A), fontWeight: FontWeight.w600),
                                                  ),
                                                ),
                                                getIt<Variables>().generalVariables.filters[index].status
                                                    ? const Icon(
                                                        Icons.check,
                                                        color: Color(0xff007838),
                                                        size: 22,
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            ),
                            const VerticalDivider(
                              color: Color(0xffE0E7EC),
                              thickness: 1,
                              width: 0,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: getIt<Functions>().getWidgetWidth(width: 20),
                                    vertical: getIt<Functions>().getWidgetHeight(height: 20)),
                                child: Column(
                                  children: [
                                    getIt<Variables>()
                                                    .generalVariables
                                                    .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                    .selection ==
                                                "date" ||
                                            getIt<Variables>()
                                                    .generalVariables
                                                    .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                    .selection ==
                                                "single_date" ||
                                            getIt<Variables>()
                                                    .generalVariables
                                                    .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                    .type ==
                                                "locations"
                                        ? const SizedBox()
                                        : SizedBox(
                                            height: getIt<Functions>().getWidgetHeight(height: 36),
                                            child: TextFormField(
                                              onChanged: (value) {
                                                if (value.isNotEmpty) {
                                                  getIt<Variables>().generalVariables.searchedResultFilterOption = (getIt<Variables>()
                                                      .generalVariables
                                                      .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                      .options
                                                      .where((element) => element.label.toLowerCase().contains(value.toLowerCase()))).toList();
                                                } else {
                                                  getIt<Variables>().generalVariables.searchedResultFilterOption = getIt<Variables>()
                                                      .generalVariables
                                                      .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                      .options;
                                                }
                                                context.read<NavigationBloc>().add(const NavigationSetStateEvent());
                                              },
                                              controller: getIt<Variables>().generalVariables.filterSearchController,
                                              cursorColor: Colors.black,
                                              keyboardType: getIt<Variables>()
                                                          .generalVariables
                                                          .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                          .type ==
                                                      "so_number"
                                                  ? const TextInputType.numberWithOptions(decimal: true)
                                                  : TextInputType.text,
                                              style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 15),
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                  fillColor: const Color(0xffFFFFFF),
                                                  filled: true,
                                                  contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 15)),
                                                  border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(4),
                                                      borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(4),
                                                      borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                                  disabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(4),
                                                      borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                                  errorBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(4),
                                                      borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(4),
                                                      borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                                  focusedErrorBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(4),
                                                      borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                                  prefixIcon: const Icon(Icons.search, color: Color(0xff8F9BB3)),
                                                  suffixIcon: getIt<Variables>().generalVariables.filterSearchController.text.isNotEmpty
                                                      ? IconButton(
                                                          onPressed: () {
                                                            getIt<Variables>().generalVariables.filterSearchController.clear();
                                                            getIt<Variables>().generalVariables.searchedResultFilterOption = getIt<Variables>()
                                                                .generalVariables
                                                                .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                                .options;
                                                            context.read<NavigationBloc>().add(const NavigationSetStateEvent());
                                                          },
                                                          icon: const Icon(Icons.clear, color: Colors.black, size: 15))
                                                      : const SizedBox(),
                                                  hintText: getIt<Variables>().generalVariables.currentLanguage.search,
                                                  hintStyle: TextStyle(
                                                      color: const Color(0xff8F9BB3),
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 15))),
                                            ),
                                          ),
                                    getIt<Variables>()
                                                    .generalVariables
                                                    .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                    .selection ==
                                                "date" ||
                                            getIt<Variables>()
                                                    .generalVariables
                                                    .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                    .selection ==
                                                "single_date" ||
                                            getIt<Variables>()
                                                    .generalVariables
                                                    .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                    .type ==
                                                "locations"
                                        ? const SizedBox()
                                        : SizedBox(height: getIt<Functions>().getWidgetHeight(height: 28)),
                                    Expanded(
                                      child: getIt<Variables>()
                                                  .generalVariables
                                                  .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                  .selection ==
                                              "date"
                                          ? Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.startDate.toUpperCase(),
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xff282F3A)),
                                                ),
                                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                                TextFormField(
                                                  readOnly: true,
                                                  onTap: () {
                                                    showCalenderDialog(
                                                        context: context,
                                                        isStartDate: true,
                                                        controller: getIt<Variables>().generalVariables.filterStartDateController);
                                                  },
                                                  keyboardType: TextInputType.none,
                                                  controller: getIt<Variables>().generalVariables.filterStartDateController,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff282F3A)),
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 15)),
                                                    prefixIcon: Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: getIt<Functions>().getWidgetWidth(width: 10),
                                                          vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                                      child: SvgPicture.asset("assets/catch_weight/calendar.svg",
                                                          height: getIt<Functions>().getWidgetHeight(height: 22),
                                                          width: getIt<Functions>().getWidgetWidth(width: 22),
                                                          fit: BoxFit.fill),
                                                    ),
                                                    suffixIcon: getIt<Variables>().generalVariables.filterStartDateController.text.isNotEmpty
                                                        ? IconButton(
                                                            onPressed: () {
                                                              getIt<Variables>().generalVariables.filterStartDateController.clear();
                                                              getIt<Variables>().generalVariables.selectedFilterStartDate = null;
                                                              if (getIt<Variables>().generalVariables.selectedFilterStartDate != null ||
                                                                  getIt<Variables>().generalVariables.selectedFilterEndDate != null) {
                                                                getIt<Variables>()
                                                                    .generalVariables
                                                                    .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                                    .status = true;
                                                              } else {
                                                                getIt<Variables>()
                                                                    .generalVariables
                                                                    .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                                    .status = false;
                                                              }
                                                              context.read<NavigationBloc>().add(const NavigationSetStateEvent());
                                                            },
                                                            icon: Icon(Icons.clear, size: 20, color: Colors.grey.shade500))
                                                        : const SizedBox(),
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey)),
                                                    errorBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey)),
                                                    focusedErrorBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey)),
                                                    disabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey)),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey)),
                                                    hintText: getIt<Variables>().generalVariables.currentLanguage.startDate.toLowerCase(),
                                                    hintStyle: TextStyle(
                                                        color: const Color(0xff8A8D8E),
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                  ),
                                                ),
                                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.endDate.toUpperCase(),
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xff282F3A)),
                                                ),
                                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                                TextFormField(
                                                  readOnly: true,
                                                  onTap: () {
                                                    showCalenderDialog(
                                                        context: context,
                                                        isStartDate: false,
                                                        controller: getIt<Variables>().generalVariables.filterEndDateController);
                                                  },
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff282F3A)),
                                                  keyboardType: TextInputType.none,
                                                  controller: getIt<Variables>().generalVariables.filterEndDateController,
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 15)),
                                                    prefixIcon: Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: getIt<Functions>().getWidgetWidth(width: 10),
                                                          vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                                      child: SvgPicture.asset("assets/catch_weight/calendar.svg",
                                                          height: getIt<Functions>().getWidgetHeight(height: 22),
                                                          width: getIt<Functions>().getWidgetWidth(width: 22),
                                                          fit: BoxFit.fill),
                                                    ),
                                                    suffixIcon: getIt<Variables>().generalVariables.filterEndDateController.text.isNotEmpty
                                                        ? IconButton(
                                                            onPressed: () {
                                                              getIt<Variables>().generalVariables.filterEndDateController.clear();
                                                              getIt<Variables>().generalVariables.selectedFilterEndDate = null;
                                                              if (getIt<Variables>().generalVariables.selectedFilterStartDate != null ||
                                                                  getIt<Variables>().generalVariables.selectedFilterEndDate != null) {
                                                                getIt<Variables>()
                                                                    .generalVariables
                                                                    .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                                    .status = true;
                                                              } else {
                                                                getIt<Variables>()
                                                                    .generalVariables
                                                                    .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                                    .status = false;
                                                              }
                                                              context.read<NavigationBloc>().add(const NavigationSetStateEvent());
                                                            },
                                                            icon: Icon(Icons.clear, size: 20, color: Colors.grey.shade500))
                                                        : const SizedBox(),
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey)),
                                                    errorBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey)),
                                                    focusedErrorBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey)),
                                                    disabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey)),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey)),
                                                    hintText: getIt<Variables>().generalVariables.currentLanguage.endDate.toLowerCase(),
                                                    hintStyle: TextStyle(
                                                        color: const Color(0xff8A8D8E),
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                  ),
                                                )
                                              ],
                                            )
                                          : getIt<Variables>()
                                                      .generalVariables
                                                      .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                      .selection ==
                                                  "single_date"
                                              ? Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.selectDate.toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                          fontWeight: FontWeight.w600,
                                                          color: const Color(0xff282F3A)),
                                                    ),
                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                                    TextFormField(
                                                      readOnly: true,
                                                      onTap: () {
                                                        showCalenderSingleDialog(
                                                          context: context,
                                                          controller: getIt<Variables>().generalVariables.filterSingleDateController,
                                                          isFilter: true,
                                                        );
                                                      },
                                                      keyboardType: TextInputType.none,
                                                      controller: getIt<Variables>().generalVariables.filterSingleDateController,
                                                      style: TextStyle(
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                          fontWeight: FontWeight.w500,
                                                          color: const Color(0xff282F3A)),
                                                      decoration: InputDecoration(
                                                        contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 15)),
                                                        prefixIcon: Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: getIt<Functions>().getWidgetWidth(width: 10),
                                                              vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                                          child: SvgPicture.asset("assets/catch_weight/calendar.svg",
                                                              height: getIt<Functions>().getWidgetHeight(height: 22),
                                                              width: getIt<Functions>().getWidgetWidth(width: 22),
                                                              fit: BoxFit.fill),
                                                        ),
                                                        suffixIcon: getIt<Variables>().generalVariables.filterSingleDateController.text.isNotEmpty
                                                            ? IconButton(
                                                                onPressed: () {
                                                                  getIt<Variables>().generalVariables.filterSingleDateController.clear();
                                                                  getIt<Variables>().generalVariables.selectedFilterSingleDate = null;
                                                                  if (getIt<Variables>().generalVariables.selectedFilterSingleDate != null) {
                                                                    getIt<Variables>()
                                                                        .generalVariables
                                                                        .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                                        .status = true;
                                                                  } else {
                                                                    getIt<Variables>()
                                                                        .generalVariables
                                                                        .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                                        .status = false;
                                                                  }
                                                                  context.read<NavigationBloc>().add(const NavigationSetStateEvent());
                                                                },
                                                                icon: Icon(Icons.clear, size: 20, color: Colors.grey.shade500))
                                                            : const SizedBox(),
                                                        border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                        errorBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                        focusedErrorBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                        disabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                        hintText: getIt<Variables>().generalVariables.currentLanguage.selectDate.toLowerCase(),
                                                        hintStyle: TextStyle(
                                                            color: const Color(0xff8A8D8E),
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : getIt<Variables>()
                                                          .generalVariables
                                                          .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                          .type ==
                                                      "locations"
                                                  ? getIt<Variables>().generalVariables.searchedResultFilterOption.isNotEmpty
                                                      ? ListView.builder(
                                                          padding: EdgeInsets.zero,
                                                          shrinkWrap: true,
                                                          physics: const ScrollPhysics(),
                                                          itemCount: getIt<Variables>().generalVariables.searchedResultFilterOption.length,
                                                          itemBuilder: (BuildContext context, int idx) {
                                                            return Column(
                                                              children: [
                                                                CheckboxListTile(
                                                                  value: getIt<Variables>().generalVariables.searchedResultFilterOption[idx].status,
                                                                  onChanged: (value) {
                                                                    for (int i = 0;
                                                                        i < getIt<Variables>().generalVariables.searchedResultFilterOption.length;
                                                                        i++) {
                                                                      getIt<Variables>().generalVariables.searchedResultFilterOption[i].status =
                                                                          false;
                                                                      for (int j = 0;
                                                                          j <
                                                                              getIt<Variables>()
                                                                                  .generalVariables
                                                                                  .searchedResultFilterOption[i]
                                                                                  .room
                                                                                  .length;
                                                                          j++) {
                                                                        getIt<Variables>()
                                                                            .generalVariables
                                                                            .searchedResultFilterOption[i]
                                                                            .room[j]
                                                                            .status = false;
                                                                        for (int k = 0;
                                                                            k <
                                                                                getIt<Variables>()
                                                                                    .generalVariables
                                                                                    .searchedResultFilterOption[i]
                                                                                    .room[j]
                                                                                    .zone
                                                                                    .length;
                                                                            k++) {
                                                                          getIt<Variables>()
                                                                              .generalVariables
                                                                              .searchedResultFilterOption[i]
                                                                              .room[j]
                                                                              .zone[k]
                                                                              .status = false;
                                                                        }
                                                                      }
                                                                    }
                                                                    getIt<Variables>().generalVariables.searchedResultFilterOption[idx].status =
                                                                        value!;
                                                                    getIt<Variables>()
                                                                            .generalVariables
                                                                            .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                                            .options[getIt<Variables>()
                                                                                .generalVariables
                                                                                .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                                                .options
                                                                                .indexWhere((element) =>
                                                                                    element.id ==
                                                                                    getIt<Variables>()
                                                                                        .generalVariables
                                                                                        .searchedResultFilterOption[idx]
                                                                                        .id)]
                                                                            .status =
                                                                        getIt<Variables>().generalVariables.searchedResultFilterOption[idx].status;
                                                                    List<FilterOptionsResponse> optionsList = getIt<Variables>()
                                                                        .generalVariables
                                                                        .searchedResultFilterOption
                                                                        .where((element) => element.status == true)
                                                                        .toList();
                                                                    getIt<Variables>()
                                                                        .generalVariables
                                                                        .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                                        .status = optionsList.isNotEmpty;
                                                                    context.read<NavigationBloc>().add(const NavigationSetStateEvent());
                                                                  },
                                                                  contentPadding: EdgeInsets.zero,
                                                                  activeColor: const Color(0xff007838),
                                                                  checkColor: const Color(0xffffffff),
                                                                  checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                                  controlAffinity: ListTileControlAffinity.leading,
                                                                  title: Text(
                                                                    "FLOOR ${getIt<Variables>().generalVariables.searchedResultFilterOption[idx].label.toUpperCase()}",
                                                                    style: TextStyle(
                                                                        color: const Color(0xff282F3A),
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 15),
                                                                        fontWeight: FontWeight.w700),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 25)),
                                                                  child: getIt<Variables>().generalVariables.searchedResultFilterOption[idx].status
                                                                      ? getIt<Variables>()
                                                                              .generalVariables
                                                                              .searchedResultFilterOption[idx]
                                                                              .room
                                                                              .isNotEmpty
                                                                          ? ListView.builder(
                                                                              padding: EdgeInsets.zero,
                                                                              shrinkWrap: true,
                                                                              physics: const ScrollPhysics(),
                                                                              itemCount: getIt<Variables>()
                                                                                  .generalVariables
                                                                                  .searchedResultFilterOption[idx]
                                                                                  .room
                                                                                  .length,
                                                                              itemBuilder: (BuildContext context, int roomIndex) {
                                                                                return Column(
                                                                                  children: [
                                                                                    CheckboxListTile(
                                                                                      value: getIt<Variables>()
                                                                                          .generalVariables
                                                                                          .searchedResultFilterOption[idx]
                                                                                          .room[roomIndex]
                                                                                          .status,
                                                                                      onChanged: (value) {
                                                                                        getIt<Variables>()
                                                                                                .generalVariables
                                                                                                .searchedResultFilterOption[idx]
                                                                                                .room[roomIndex]
                                                                                                .status =
                                                                                            !getIt<Variables>()
                                                                                                .generalVariables
                                                                                                .searchedResultFilterOption[idx]
                                                                                                .room[roomIndex]
                                                                                                .status;
                                                                                        if (!value!) {
                                                                                          for (int k = 0;
                                                                                              k <
                                                                                                  getIt<Variables>()
                                                                                                      .generalVariables
                                                                                                      .searchedResultFilterOption[idx]
                                                                                                      .room[roomIndex]
                                                                                                      .zone
                                                                                                      .length;
                                                                                              k++) {
                                                                                            getIt<Variables>()
                                                                                                .generalVariables
                                                                                                .searchedResultFilterOption[idx]
                                                                                                .room[roomIndex]
                                                                                                .zone[k]
                                                                                                .status = false;
                                                                                          }
                                                                                        }
                                                                                        for (int i = 0;
                                                                                            i <
                                                                                                getIt<Variables>()
                                                                                                    .generalVariables
                                                                                                    .searchedResultFilterOption[idx]
                                                                                                    .room
                                                                                                    .length;
                                                                                            i++) {
                                                                                          getIt<Variables>()
                                                                                                  .generalVariables
                                                                                                  .filters[getIt<Variables>()
                                                                                                      .generalVariables
                                                                                                      .filterSelectedMainIndex]
                                                                                                  .options[idx]
                                                                                                  .room[i]
                                                                                                  .status =
                                                                                              getIt<Variables>()
                                                                                                  .generalVariables
                                                                                                  .searchedResultFilterOption[idx]
                                                                                                  .room[i]
                                                                                                  .status;
                                                                                        }
                                                                                        context
                                                                                            .read<NavigationBloc>()
                                                                                            .add(const NavigationSetStateEvent());
                                                                                      },
                                                                                      contentPadding: EdgeInsets.zero,
                                                                                      activeColor: const Color(0xff007838),
                                                                                      checkColor: const Color(0xffffffff),
                                                                                      checkboxShape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(5)),
                                                                                      controlAffinity: ListTileControlAffinity.leading,
                                                                                      title: Text(
                                                                                        "ROOM ${getIt<Variables>().generalVariables.searchedResultFilterOption[idx].room[roomIndex].label.toUpperCase()}",
                                                                                        style: TextStyle(
                                                                                            color: const Color(0xff282F3A),
                                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 15),
                                                                                            fontWeight: FontWeight.w600),
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.only(
                                                                                          left: getIt<Functions>().getWidgetWidth(width: 25)),
                                                                                      child: getIt<Variables>()
                                                                                              .generalVariables
                                                                                              .searchedResultFilterOption[idx]
                                                                                              .room[roomIndex]
                                                                                              .status
                                                                                          ? getIt<Variables>()
                                                                                                  .generalVariables
                                                                                                  .searchedResultFilterOption[idx]
                                                                                                  .room[roomIndex]
                                                                                                  .zone
                                                                                                  .isNotEmpty
                                                                                              ? ListView.builder(
                                                                                                  padding: EdgeInsets.zero,
                                                                                                  shrinkWrap: true,
                                                                                                  physics: const ScrollPhysics(),
                                                                                                  itemCount: getIt<Variables>()
                                                                                                      .generalVariables
                                                                                                      .searchedResultFilterOption[idx]
                                                                                                      .room[roomIndex]
                                                                                                      .zone
                                                                                                      .length,
                                                                                                  itemBuilder: (BuildContext context, int zoneIndex) {
                                                                                                    return CheckboxListTile(
                                                                                                      value: getIt<Variables>()
                                                                                                          .generalVariables
                                                                                                          .searchedResultFilterOption[idx]
                                                                                                          .room[roomIndex]
                                                                                                          .zone[zoneIndex]
                                                                                                          .status,
                                                                                                      onChanged: (value) {
                                                                                                        getIt<Variables>()
                                                                                                                .generalVariables
                                                                                                                .searchedResultFilterOption[idx]
                                                                                                                .room[roomIndex]
                                                                                                                .zone[zoneIndex]
                                                                                                                .status =
                                                                                                            !getIt<Variables>()
                                                                                                                .generalVariables
                                                                                                                .searchedResultFilterOption[idx]
                                                                                                                .room[roomIndex]
                                                                                                                .zone[zoneIndex]
                                                                                                                .status;
                                                                                                        for (int i = 0;
                                                                                                            i <
                                                                                                                getIt<Variables>()
                                                                                                                    .generalVariables
                                                                                                                    .searchedResultFilterOption[idx]
                                                                                                                    .room[roomIndex]
                                                                                                                    .zone
                                                                                                                    .length;
                                                                                                            i++) {
                                                                                                          getIt<Variables>()
                                                                                                                  .generalVariables
                                                                                                                  .filters[getIt<Variables>()
                                                                                                                      .generalVariables
                                                                                                                      .filterSelectedMainIndex]
                                                                                                                  .options[idx]
                                                                                                                  .room[roomIndex]
                                                                                                                  .zone[i]
                                                                                                                  .status =
                                                                                                              getIt<Variables>()
                                                                                                                  .generalVariables
                                                                                                                  .searchedResultFilterOption[idx]
                                                                                                                  .room[roomIndex]
                                                                                                                  .zone[i]
                                                                                                                  .status;
                                                                                                        }
                                                                                                        context
                                                                                                            .read<NavigationBloc>()
                                                                                                            .add(const NavigationSetStateEvent());
                                                                                                      },
                                                                                                      contentPadding: EdgeInsets.zero,
                                                                                                      activeColor: const Color(0xff007838),
                                                                                                      checkColor: const Color(0xffffffff),
                                                                                                      checkboxShape: RoundedRectangleBorder(
                                                                                                          borderRadius: BorderRadius.circular(5)),
                                                                                                      controlAffinity:
                                                                                                          ListTileControlAffinity.leading,
                                                                                                      title: Text(
                                                                                                        "ZONE ${getIt<Variables>().generalVariables.searchedResultFilterOption[idx].room[roomIndex].zone[zoneIndex].label.toUpperCase()}",
                                                                                                        style: TextStyle(
                                                                                                            color: const Color(0xff282F3A),
                                                                                                            fontSize: getIt<Functions>()
                                                                                                                .getTextSize(fontSize: 15),
                                                                                                            fontWeight: FontWeight.w500),
                                                                                                      ),
                                                                                                    );
                                                                                                  })
                                                                                              : Text(getIt<Variables>()
                                                                                                  .generalVariables
                                                                                                  .currentLanguage
                                                                                                  .noDataFound)
                                                                                          : const SizedBox(),
                                                                                    )
                                                                                  ],
                                                                                );
                                                                              })
                                                                          : const SizedBox()
                                                                      : const SizedBox(),
                                                                )
                                                              ],
                                                            );
                                                          })
                                                      : Text(getIt<Variables>().generalVariables.currentLanguage.noDataFound)
                                                  : getIt<Variables>().generalVariables.searchedResultFilterOption.isNotEmpty
                                                      ? ListView.builder(
                                                          padding: EdgeInsets.zero,
                                                          shrinkWrap: true,
                                                          physics: const ScrollPhysics(),
                                                          itemCount: getIt<Variables>().generalVariables.searchedResultFilterOption.length,
                                                          itemBuilder: (BuildContext context, int idx) {
                                                            return CheckboxListTile(
                                                              value: getIt<Variables>().generalVariables.searchedResultFilterOption[idx].status,
                                                              onChanged: (value) {
                                                                if (getIt<Variables>()
                                                                        .generalVariables
                                                                        .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                                        .selection ==
                                                                    "single") {
                                                                  for (int i = 0;
                                                                      i < getIt<Variables>().generalVariables.searchedResultFilterOption.length;
                                                                      i++) {
                                                                    getIt<Variables>().generalVariables.searchedResultFilterOption[i].status = false;
                                                                  }
                                                                  getIt<Variables>().generalVariables.searchedResultFilterOption[idx].status = value!;
                                                                  getIt<Variables>()
                                                                          .generalVariables
                                                                          .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                                          .options[getIt<Variables>()
                                                                              .generalVariables
                                                                              .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                                              .options
                                                                              .indexWhere(
                                                                                  (element) =>
                                                                                      element.id ==
                                                                                      getIt<Variables>()
                                                                                          .generalVariables
                                                                                          .searchedResultFilterOption[idx]
                                                                                          .id)]
                                                                          .status =
                                                                      getIt<Variables>().generalVariables.searchedResultFilterOption[idx].status;
                                                                  List<FilterOptionsResponse> optionsList = getIt<Variables>()
                                                                      .generalVariables
                                                                      .searchedResultFilterOption
                                                                      .where((element) => element.status == true)
                                                                      .toList();
                                                                  getIt<Variables>()
                                                                      .generalVariables
                                                                      .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                                      .status = optionsList.isNotEmpty;
                                                                  context.read<NavigationBloc>().add(const NavigationSetStateEvent());
                                                                } else {
                                                                  getIt<Variables>().generalVariables.searchedResultFilterOption[idx].status =
                                                                      !getIt<Variables>().generalVariables.searchedResultFilterOption[idx].status;
                                                                  getIt<Variables>()
                                                                          .generalVariables
                                                                          .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                                          .options[getIt<Variables>()
                                                                              .generalVariables
                                                                              .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                                              .options
                                                                              .indexWhere(
                                                                                  (element) =>
                                                                                      element.id ==
                                                                                      getIt<Variables>()
                                                                                          .generalVariables
                                                                                          .searchedResultFilterOption[idx]
                                                                                          .id)]
                                                                          .status =
                                                                      getIt<Variables>().generalVariables.searchedResultFilterOption[idx].status;
                                                                  List<FilterOptionsResponse> optionsList = getIt<Variables>()
                                                                      .generalVariables
                                                                      .searchedResultFilterOption
                                                                      .where((element) => element.status == true)
                                                                      .toList();
                                                                  getIt<Variables>()
                                                                      .generalVariables
                                                                      .filters[getIt<Variables>().generalVariables.filterSelectedMainIndex]
                                                                      .status = optionsList.isNotEmpty;
                                                                  context.read<NavigationBloc>().add(const NavigationSetStateEvent());
                                                                }
                                                              },
                                                              contentPadding: EdgeInsets.zero,
                                                              activeColor: const Color(0xff007838),
                                                              checkColor: const Color(0xffffffff),
                                                              checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                              controlAffinity: ListTileControlAffinity.leading,
                                                              title: Text(
                                                                getIt<Variables>()
                                                                    .generalVariables
                                                                    .searchedResultFilterOption[idx]
                                                                    .label
                                                                    .toUpperCase(),
                                                                style: TextStyle(
                                                                    color: const Color(0xff282F3A),
                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 15),
                                                                    fontWeight: FontWeight.w500),
                                                              ),
                                                            );
                                                          })
                                                      : Text(getIt<Variables>().generalVariables.currentLanguage.noDataFound),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: Color(0xffE0E7EC), height: 0, thickness: 1),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 28 : 10),
                            vertical: getIt<Functions>().getWidgetHeight(height: 20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    minimumSize: Size(getIt<Functions>().getWidgetWidth(width: 173), getIt<Functions>().getWidgetHeight(height: 50))),
                                onPressed: () {
                                  if (getIt<Variables>().generalVariables.selectedFilters.isNotEmpty) {
                                    for (int i = 0; i < getIt<Variables>().generalVariables.filters.length; i++) {
                                      getIt<Variables>().generalVariables.filters[i].status = false;
                                      if (getIt<Variables>().generalVariables.filters[i].type == "date_range") {
                                        getIt<Variables>().generalVariables.filterStartDateController.clear();
                                        getIt<Variables>().generalVariables.filterEndDateController.clear();
                                        getIt<Variables>().generalVariables.selectedFilterStartDate = null;
                                        getIt<Variables>().generalVariables.selectedFilterEndDate = null;
                                      } else if (getIt<Variables>().generalVariables.filters[i].type == "business_dt") {
                                        getIt<Variables>().generalVariables.filterSingleDateController.clear();
                                        getIt<Variables>().generalVariables.selectedFilterSingleDate = null;
                                      } else if (getIt<Variables>().generalVariables.filters[i].type == "locations") {
                                        for (int j = 0; j < getIt<Variables>().generalVariables.filters[i].options.length; j++) {
                                          getIt<Variables>().generalVariables.filters[i].options[j].status = false;
                                          for (int k = 0; k < getIt<Variables>().generalVariables.filters[i].options[j].room.length; k++) {
                                            getIt<Variables>().generalVariables.filters[i].options[j].room[k].status = false;
                                            for (int l = 0; l < getIt<Variables>().generalVariables.filters[i].options[j].room[k].zone.length; l++) {
                                              getIt<Variables>().generalVariables.filters[i].options[j].room[k].zone[l].status = false;
                                            }
                                          }
                                        }
                                      } else {
                                        for (int j = 0; j < getIt<Variables>().generalVariables.filters[i].options.length; j++) {
                                          getIt<Variables>().generalVariables.filters[i].options[j].status = false;
                                        }
                                      }
                                    }
                                    getIt<Variables>().generalVariables.selectedFilters.clear();
                                    getIt<Variables>().generalVariables.selectedFiltersName.clear();
                                    switch (getIt<Variables>().generalVariables.indexName) {
                                      case PickListScreen.id:
                                        {
                                          context.read<PickListBloc>().pageIndex = 1;
                                          context.read<PickListBloc>().add(const PickListTabChangingEvent(isLoading: false));
                                        }
                                      case PickListDetailsScreen.id:
                                        {
                                          context.read<PickListBloc>().pageIndex = 1;
                                          context.read<PickListDetailsBloc>().add(const PickListDetailsTabChangingEvent(isLoading: false));
                                        }
                                      case CatchWeightScreen.id:
                                        {
                                          context.read<CatchWeightBloc>().pageIndex = 1;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: false));
                                        }
                                      case BackToStoreScreen.id:
                                        {
                                          context.read<BackToStoreBloc>().pageIndex = 1;
                                          context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: false));
                                        }
                                      case DisputeScreen.id:
                                        {
                                          context.read<BackToStoreBloc>().pageIndex = 1;
                                          context.read<DisputeMainBloc>().add(const DisputeMainTabChangingEvent(isLoading: false));
                                        }
                                      case TripListScreen.id:
                                        {
                                          context.read<TripListBloc>().add(const TripListFilterEvent());
                                        }
                                      case TripListEntryScreen.id:
                                        {
                                          context.read<TripListEntryBloc>().add(const TripListEntryFilterEvent());
                                        }
                                      case TripListDetailScreen.id:
                                        {
                                          context.read<TripListDetailsBloc>().add(const TripListDetailsFilterEvent());
                                        }
                                      case OutBoundScreen.id:
                                        {
                                          context.read<OutBoundBloc>().add(const OutBoundFilterEvent());
                                        }
                                      case OutBoundEntryScreen.id:
                                        {
                                          context.read<OutBoundEntryBloc>().add(const OutBoundEntryFilterEvent());
                                        }
                                      case OutBoundDetailScreen.id:
                                        {
                                          context.read<OutBoundDetailBloc>().add(const OutBoundDetailFilterEvent());
                                        }
                                      case WarehousePickupScreen.id:
                                        {
                                          context.read<WarehousePickupBloc>().add(const WarehousePickupFilterEvent());
                                        }
                                      case WarehousePickupDetailScreen.id:
                                        {
                                          context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailFilterEvent());
                                        }
                                      case RoTripListScreen.id:
                                        {
                                          context.read<RoTripListMainBloc>().add(const RoTripListMainFilterEvent());
                                        }
                                      default:
                                        {
                                          context.read<CatchWeightBloc>().pageIndex = 1;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: false));
                                        }
                                    }
                                    Scaffold.of(context).closeEndDrawer();
                                  }
                                  else {
                                    getIt<Variables>().generalVariables.selectedFilters.clear();
                                    getIt<Variables>().generalVariables.selectedFiltersName.clear();
                                    switch (getIt<Variables>().generalVariables.indexName) {
                                      case PickListScreen.id:
                                        {
                                          context.read<PickListBloc>().pageIndex = 1;
                                          context.read<PickListBloc>().add(const PickListTabChangingEvent(isLoading: false));
                                        }
                                      case PickListDetailsScreen.id:
                                        {
                                          context.read<PickListBloc>().pageIndex = 1;
                                          context.read<PickListDetailsBloc>().add(const PickListDetailsTabChangingEvent(isLoading: false));
                                        }
                                      case CatchWeightScreen.id:
                                        {
                                          context.read<CatchWeightBloc>().pageIndex = 1;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: false));
                                        }
                                      case BackToStoreScreen.id:
                                        {
                                          context.read<BackToStoreBloc>().pageIndex = 1;
                                          context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: false));
                                        }
                                      case DisputeScreen.id:
                                        {
                                          context.read<BackToStoreBloc>().pageIndex = 1;
                                          context.read<DisputeMainBloc>().add(const DisputeMainTabChangingEvent(isLoading: false));
                                        }
                                      case TripListScreen.id:
                                        {
                                          context.read<TripListBloc>().add(const TripListFilterEvent());
                                        }
                                      case TripListEntryScreen.id:
                                        {
                                          context.read<TripListEntryBloc>().add(const TripListEntryFilterEvent());
                                        }
                                      case TripListDetailScreen.id:
                                        {
                                          context.read<TripListDetailsBloc>().add(const TripListDetailsFilterEvent());
                                        }
                                      case OutBoundScreen.id:
                                        {
                                          context.read<OutBoundBloc>().add(const OutBoundFilterEvent());
                                        }
                                      case OutBoundEntryScreen.id:
                                        {
                                          context.read<OutBoundEntryBloc>().add(const OutBoundEntryFilterEvent());
                                        }
                                      case OutBoundDetailScreen.id:
                                        {
                                          context.read<OutBoundDetailBloc>().add(const OutBoundDetailFilterEvent());
                                        }
                                      case WarehousePickupScreen.id:
                                        {
                                          context.read<WarehousePickupBloc>().add(const WarehousePickupFilterEvent());
                                        }
                                      case WarehousePickupDetailScreen.id:
                                        {
                                          context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailFilterEvent());
                                        }
                                      case RoTripListScreen.id:
                                        {
                                          context.read<RoTripListMainBloc>().add(const RoTripListMainFilterEvent());
                                        }
                                      default:
                                        {
                                          context.read<CatchWeightBloc>().pageIndex = 1;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: false));
                                        }
                                    }
                                    Scaffold.of(context).closeEndDrawer();
                                  }
                                },
                                child: FittedBox(
                                  child: Text(
                                    getIt<Variables>().generalVariables.currentLanguage.clearFilter,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                        color: const Color(0xff007AFF)),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff007838),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  minimumSize: Size(
                                    getIt<Functions>().getWidgetWidth(width: 173),
                                    getIt<Functions>().getWidgetHeight(height: 50),
                                  ),
                                ),
                                onPressed: () {
                                  getIt<Variables>().generalVariables.atLeastOneDateEmpty = false;
                                  getIt<Variables>().generalVariables.selectedFilters.clear();
                                  getIt<Variables>().generalVariables.selectedFiltersName.clear();
                                  for (int i = 0; i < getIt<Variables>().generalVariables.filters.length; i++) {
                                    if (getIt<Variables>().generalVariables.filters[i].status) {
                                      if (getIt<Variables>().generalVariables.filters[i].type == "date_range") {
                                        if ((getIt<Variables>().generalVariables.filterStartDateController.text == "") !=
                                            (getIt<Variables>().generalVariables.filterEndDateController.text == "")) {
                                          getIt<Variables>().generalVariables.atLeastOneDateEmpty = true;
                                        } else {
                                          getIt<Variables>().generalVariables.selectedFilters.add(SelectedFilterModel(
                                                type: getIt<Variables>().generalVariables.filters[i].type,
                                                options: [
                                                  getIt<Variables>().generalVariables.filterStartDateController.text,
                                                  getIt<Variables>().generalVariables.filterEndDateController.text,
                                                ],
                                              ));
                                          getIt<Variables>().generalVariables.selectedFiltersName.add(
                                              "${getIt<Variables>().generalVariables.filterStartDateController.text}-${getIt<Variables>().generalVariables.filterEndDateController.text}");
                                          getIt<Variables>().generalVariables.atLeastOneDateEmpty = false;
                                        }
                                      } else if (getIt<Variables>().generalVariables.filters[i].type == "business_dt") {
                                        getIt<Variables>().generalVariables.selectedFilters.add(SelectedFilterModel(
                                              type: getIt<Variables>().generalVariables.filters[i].type,
                                              options: [
                                                getIt<Variables>().generalVariables.filterSingleDateController.text,
                                              ],
                                            ));
                                        getIt<Variables>()
                                            .generalVariables
                                            .selectedFiltersName
                                            .add(getIt<Variables>().generalVariables.filterSingleDateController.text);
                                      } else if (getIt<Variables>().generalVariables.filters[i].type == "locations") {
                                        List<FilterOptionsResponse> optionsList =
                                            getIt<Variables>().generalVariables.filters[i].options.where((e) => e.status == true).toList();
                                        List<SubOption> subOptions = [];
                                        for (int i = 0; i < optionsList.length; i++) {
                                          List<Room> roomsList = optionsList[i].room.where((e) => e.status == true).toList();
                                          subOptions.addAll(List<SubOption>.generate(
                                              roomsList.length,
                                              (j) => SubOption(
                                                  room: roomsList[j].id,
                                                  zone: List.generate((roomsList[j].zone.where((e) => e.status == true)).toList().length,
                                                      (k) => ((roomsList[j].zone.where((e) => e.status == true)).toList())[k].id))));
                                        }
                                        getIt<Variables>().generalVariables.selectedFilters.add(SelectedFilterModel(
                                            type: getIt<Variables>().generalVariables.filters[i].type,
                                            options: List.generate(optionsList.length, (idx) => optionsList[idx].id),
                                            subOptions: subOptions));
                                        getIt<Variables>().generalVariables.selectedFiltersName.add("FLOOR ${optionsList[0].label}");
                                        context.read<PickListBloc>().selectedLocation = optionsList[0].label;
                                        context.read<PickListBloc>().selectedLocationId = optionsList[0].id;
                                      } else {
                                        List<FilterOptionsResponse> optionsList =
                                            getIt<Variables>().generalVariables.filters[i].options.where((e) => e.status == true).toList();
                                        getIt<Variables>().generalVariables.selectedFilters.add(SelectedFilterModel(
                                            type: getIt<Variables>().generalVariables.filters[i].type,
                                            options: List.generate(optionsList.length, (idx) => optionsList[idx].id)));
                                        getIt<Variables>().generalVariables.selectedFiltersName.add(optionsList[0].label);
                                      }
                                    }
                                  }
                                  if (getIt<Variables>().generalVariables.atLeastOneDateEmpty) {
                                    Flushbar(
                                      messageText: Text(
                                        getIt<Variables>().generalVariables.filterStartDateController.text == ""
                                            ? "Please select start date"
                                            : "Please select end date",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                          color: Colors.white,
                                        ),
                                      ),
                                      flushbarPosition: FlushbarPosition.BOTTOM,
                                      flushbarStyle: FlushbarStyle.FLOATING,
                                      isDismissible: true,
                                      duration: const Duration(seconds: 2),
                                      margin: EdgeInsets.only(
                                          left:
                                              getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 300 : 15),
                                          right: getIt<Functions>().getWidgetWidth(width: 15),
                                          bottom: getIt<Functions>().getWidgetHeight(height: 90)),
                                      borderRadius: BorderRadius.circular(15),
                                      backgroundColor: Colors.black,
                                      animationDuration: const Duration(milliseconds: 1000),
                                      maxWidth: getIt<Variables>().generalVariables.isDeviceTablet ? 480 : 400,
                                    ).show(context);
                                  } else {
                                    switch (getIt<Variables>().generalVariables.indexName) {
                                      case PickListScreen.id:
                                        {
                                          context.read<PickListBloc>().pageIndex = 1;
                                          context.read<PickListBloc>().add(const PickListTabChangingEvent(isLoading: false));
                                        }
                                      case PickListDetailsScreen.id:
                                        {
                                          context.read<PickListBloc>().pageIndex = 1;
                                          context.read<PickListDetailsBloc>().add(const PickListDetailsTabChangingEvent(isLoading: false));
                                        }
                                      case CatchWeightScreen.id:
                                        {
                                          context.read<CatchWeightBloc>().pageIndex = 1;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: false));
                                        }
                                      case BackToStoreScreen.id:
                                        {
                                          context.read<BackToStoreBloc>().pageIndex = 1;
                                          context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: false));
                                        }
                                      case DisputeScreen.id:
                                        {
                                          context.read<BackToStoreBloc>().pageIndex = 1;
                                          context.read<DisputeMainBloc>().add(const DisputeMainTabChangingEvent(isLoading: false));
                                        }
                                      case TripListScreen.id:
                                        {
                                          context.read<TripListBloc>().add(const TripListFilterEvent());
                                        }
                                      case TripListEntryScreen.id:
                                        {
                                          context.read<TripListEntryBloc>().add(const TripListEntryFilterEvent());
                                        }
                                      case TripListDetailScreen.id:
                                        {
                                          context.read<TripListDetailsBloc>().add(const TripListDetailsFilterEvent());
                                        }
                                      case OutBoundScreen.id:
                                        {
                                          context.read<OutBoundBloc>().add(const OutBoundFilterEvent());
                                        }
                                      case OutBoundEntryScreen.id:
                                        {
                                          context.read<OutBoundEntryBloc>().add(const OutBoundEntryFilterEvent());
                                        }
                                      case OutBoundDetailScreen.id:
                                        {
                                          context.read<OutBoundDetailBloc>().add(const OutBoundDetailFilterEvent());
                                        }
                                      case WarehousePickupScreen.id:
                                        {
                                          context.read<WarehousePickupBloc>().add(const WarehousePickupFilterEvent());
                                        }
                                      case WarehousePickupDetailScreen.id:
                                        {
                                          context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailFilterEvent());
                                        }
                                      case RoTripListScreen.id:
                                        {
                                          context.read<RoTripListMainBloc>().add(const RoTripListMainFilterEvent());
                                        }
                                      default:
                                        {
                                          context.read<CatchWeightBloc>().pageIndex = 1;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: false));
                                        }
                                    }
                                    for (int i = 0; i < getIt<Variables>().generalVariables.filters.length; i++) {
                                      for (int j = 0; j < getIt<Variables>().generalVariables.filters[i].options.length; j++) {
                                        for (int k = 0; k < getIt<Variables>().generalVariables.filters[i].options[j].room.length; k++) {
                                          getIt<Variables>().generalVariables.filters[i].options[j].room[k].zone.sort((a, b) {
                                            if (a.status == b.status) return 0;
                                            return a.status == true ? -1 : 1;
                                          });
                                        }
                                        getIt<Variables>().generalVariables.filters[i].options[j].room.sort((a, b) {
                                          if (a.status == b.status) return 0;
                                          return a.status == true ? -1 : 1;
                                        });
                                      }
                                      getIt<Variables>().generalVariables.filters[i].options.sort((a, b) {
                                        if (a.status == b.status) return 0;
                                        return a.status == true ? -1 : 1;
                                      });
                                    }
                                    Scaffold.of(context).closeEndDrawer();
                                  }
                                },
                                child: FittedBox(
                                  child: Text(
                                    getIt<Variables>().generalVariables.currentLanguage.apply,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                        color: const Color(0xffffffff)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  void showAnimatedDialog({required BuildContext context, required double height, required double width, required Widget child, bool? isLogout}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: isLogout == true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
        return Center(
          child: Container(
            height: getIt<Functions>().getWidgetHeight(height: height),
            width: getIt<Functions>().getWidgetWidth(width: width),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Material(
              type: MaterialType.transparency,
              child: child,
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: isLogout == true ? const Offset(0, -1) : const Offset(0, 1),
            end: getIt<Variables>().generalVariables.isDeviceTablet
                ? Offset.zero
                : isLogout == true
                    ? const Offset(0, 0)
                    : const Offset(0, -0.15),
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  void showAlertDialog({required BuildContext context, required Widget content, required bool isDismissible}) {
    showDialog(
      barrierDismissible: isDismissible,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          backgroundColor: const Color(0xffE5E7EB),
          contentPadding: EdgeInsets.zero,
          content: content,
        );
      },
    );
  }

  showCalenderDialog({required BuildContext context, required bool isStartDate, required TextEditingController controller}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(color: const Color(0xffF5F5F5), borderRadius: BorderRadius.circular(15)),
            clipBehavior: Clip.hardEdge,
            height: getIt<Functions>().getWidgetHeight(height: 450),
            width: getIt<Functions>().getWidgetWidth(width: 450),
            padding: EdgeInsets.symmetric(
                horizontal: getIt<Functions>().getWidgetWidth(width: 8), vertical: getIt<Functions>().getWidgetHeight(height: 8)),
            child: SfDateRangePicker(
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.single,
              initialSelectedDate: isStartDate
                  ? getIt<Variables>().generalVariables.selectedFilterStartDate ?? DateTime.now()
                  : getIt<Variables>().generalVariables.selectedFilterEndDate ?? DateTime.now(),
              minDate: isStartDate ? DateTime.now().subtract(const Duration(days: 365)) : getIt<Variables>().generalVariables.selectedFilterStartDate,
              maxDate: isStartDate ? getIt<Variables>().generalVariables.selectedFilterEndDate ?? DateTime.now() : DateTime.now(),
              headerHeight: getIt<Functions>().getWidgetHeight(height: 38),
              backgroundColor: const Color(0xffF5F5F5),
              showNavigationArrow: true,
              showActionButtons: true,
              selectionShape: DateRangePickerSelectionShape.rectangle,
              selectionColor: const Color(0xff007AFF),
              selectionTextStyle: TextStyle(
                  fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
              headerStyle: const DateRangePickerHeaderStyle(textAlign: TextAlign.center, backgroundColor: Color(0xffF5F5F5)),
              monthCellStyle: DateRangePickerMonthCellStyle(
                textStyle:
                    TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w600, color: const Color(0xff8F9BB3)),
                todayTextStyle:
                    TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w600, color: const Color(0xff8F9BB3)),
                cellDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: const Color(0xff000E33).withOpacity(0.05), blurRadius: 7)],
                ),
              ),
              monthViewSettings: DateRangePickerMonthViewSettings(
                viewHeaderHeight: getIt<Functions>().getWidgetHeight(height: 38),
                firstDayOfWeek: 1,
              ),
              onSubmit: (value) {
                Navigator.pop(context);
                if (isStartDate) {
                  getIt<Variables>().generalVariables.selectedFilterStartDate = value as DateTime;
                  controller.text = DateFormat('dd/MM/yyyy').format(getIt<Variables>().generalVariables.selectedFilterStartDate!);
                  context.read<NavigationBloc>().add(const NavigationSetStateEvent());
                } else {
                  getIt<Variables>().generalVariables.selectedFilterEndDate = value as DateTime;
                  controller.text = DateFormat('dd/MM/yyyy').format(getIt<Variables>().generalVariables.selectedFilterEndDate!);
                  context.read<NavigationBloc>().add(const NavigationSetStateEvent());
                }
                if (getIt<Variables>().generalVariables.selectedFilterStartDate != null ||
                    getIt<Variables>().generalVariables.selectedFilterEndDate != null) {
                  getIt<Variables>().generalVariables.filters[getIt<Variables>().generalVariables.filterSelectedMainIndex].status = true;
                } else {
                  getIt<Variables>().generalVariables.filters[getIt<Variables>().generalVariables.filterSelectedMainIndex].status = false;
                }
              },
              onCancel: () {
                Navigator.pop(context);
              },
              cancelText: "Cancel",
              confirmText: "OK",
            ),
          ),
        );
      },
    );
  }

  showCalenderSingleDialog({required BuildContext context, required TextEditingController controller, required bool isFilter}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(color: const Color(0xffF5F5F5), borderRadius: BorderRadius.circular(15)),
            clipBehavior: Clip.hardEdge,
            height: getIt<Functions>().getWidgetHeight(height: 450),
            width: getIt<Functions>().getWidgetWidth(width: 450),
            padding: EdgeInsets.symmetric(
                horizontal: getIt<Functions>().getWidgetWidth(width: 8), vertical: getIt<Functions>().getWidgetHeight(height: 8)),
            child: SfDateRangePicker(
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.single,
              initialSelectedDate: getIt<Variables>().generalVariables.selectedFilterSingleDate ?? DateTime.now(),
              minDate: isFilter ? DateTime.now().subtract(const Duration(days: 1)) : DateTime(1900),
              maxDate: isFilter ? DateTime.now().add(const Duration(days: 1)) : DateTime.now(),
              headerHeight: getIt<Functions>().getWidgetHeight(height: 38),
              backgroundColor: const Color(0xffF5F5F5),
              showNavigationArrow: true,
              showActionButtons: true,
              selectionShape: DateRangePickerSelectionShape.rectangle,
              selectionColor: const Color(0xff007AFF),
              selectionTextStyle: TextStyle(
                  fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
              headerStyle: const DateRangePickerHeaderStyle(textAlign: TextAlign.center, backgroundColor: Color(0xffF5F5F5)),
              monthCellStyle: DateRangePickerMonthCellStyle(
                textStyle:
                    TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w600, color: const Color(0xff8F9BB3)),
                todayTextStyle:
                    TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w600, color: const Color(0xff8F9BB3)),
                cellDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: const Color(0xff000E33).withOpacity(0.05), blurRadius: 7)],
                ),
              ),
              monthViewSettings: DateRangePickerMonthViewSettings(
                viewHeaderHeight: getIt<Functions>().getWidgetHeight(height: 38),
                firstDayOfWeek: 1,
              ),
              onSubmit: (value) {
                Navigator.pop(context);
                getIt<Variables>().generalVariables.selectedFilterSingleDate = value as DateTime;
                controller.text = DateFormat('dd/MM/yyyy').format(getIt<Variables>().generalVariables.selectedFilterSingleDate!);
                context.read<NavigationBloc>().add(const NavigationSetStateEvent());
                if (getIt<Variables>().generalVariables.selectedFilterSingleDate != null) {
                  getIt<Variables>().generalVariables.filters[getIt<Variables>().generalVariables.filterSelectedMainIndex].status = true;
                } else {
                  getIt<Variables>().generalVariables.filters[getIt<Variables>().generalVariables.filterSelectedMainIndex].status = false;
                }
              },
              onCancel: () {
                Navigator.pop(context);
              },
              cancelText: "Cancel",
              confirmText: "OK",
            ),
          ),
        );
      },
    );
  }
}

class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.status,
    required this.onTap,
    required this.text,
    this.height,
    this.width,
    this.fontSize,
    this.margin,
    this.padding,
    this.extraWidget,
  });

  final bool status;

  final String text;

  final double? fontSize;

  final double? width;

  final double? height;

  final EdgeInsetsGeometry? margin;

  final EdgeInsetsGeometry? padding;

  final VoidCallback onTap;

  final Widget? extraWidget;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: status ? null : onTap,
        child: Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          child: AnimatedContainer(
            width: status ? getIt<Functions>().getWidgetWidth(width: 45) : width ?? getIt<Functions>().getWidgetWidth(width: 200),
            height: status ? getIt<Functions>().getWidgetWidth(width: 45) : height ?? getIt<Functions>().getWidgetHeight(height: 58),
            alignment: Alignment.center,
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(5),
            margin: margin,
            decoration: BoxDecoration(color: const Color(0xFFE0E6EE), shape: status ? BoxShape.circle : BoxShape.rectangle),
            child: status
                ? const CircularProgressIndicator(color: Color(0xff323CF0), strokeWidth: 3)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      extraWidget ?? const SizedBox(),
                      extraWidget == null
                          ? const SizedBox()
                          : SizedBox(
                              width: getIt<Functions>().getWidgetWidth(width: 5),
                            ),
                      Text(
                        text.trim(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xff282F3A),
                          fontSize: getIt<Functions>().getTextSize(fontSize: fontSize ?? 22),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class AnimatedAlertDialog extends StatefulWidget {
  final bool isFromTop;
  final bool isCloseDisabled;
  final bool isBackEnabled;
  const AnimatedAlertDialog({super.key, required this.isFromTop, required this.isCloseDisabled, this.isBackEnabled = false});

  @override
  State<AnimatedAlertDialog> createState() => AnimatedAlertDialogState();
}

class AnimatedAlertDialogState extends State<AnimatedAlertDialog> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    slideAnimation = Tween<Offset>(begin: widget.isFromTop ? const Offset(0, -1) : const Offset(0, 1), end: Offset.zero).animate(controller);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.isCloseDisabled,
      child: Center(
        child: SlideTransition(
            position: slideAnimation,
            child: getIt<Variables>().generalVariables.isDeviceTablet
                ? AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    content: SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: getIt<Functions>().getWidgetHeight(height: 10),
                            ),
                            widget.isCloseDisabled
                                ? widget.isBackEnabled
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: getIt<Functions>().getWidgetWidth(width: 10),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              controller.reverse();
                                              Navigator.pop(context);
                                              context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 0));
                                              getIt<Variables>().generalVariables.indexName = HomeScreen.id;
                                              context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                            },
                                            child: SizedBox(
                                              height: getIt<Functions>().getWidgetHeight(height: 26),
                                              width: getIt<Functions>().getWidgetWidth(width: 26),
                                              child: const Icon(
                                                Icons.arrow_back,
                                                size: 20,
                                                color: Color(0xff282F3A),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: getIt<Functions>().getWidgetHeight(height: 26),
                                            width: getIt<Functions>().getWidgetWidth(width: 26),
                                          ),
                                          SizedBox(
                                            width: getIt<Functions>().getWidgetWidth(width: 10),
                                          ),
                                        ],
                                      )
                                : InkWell(
                                    onTap: () {
                                      if (getIt<Widgets>().flushBarKey.currentWidget != null) {
                                        (getIt<Widgets>().flushBarKey.currentWidget as Flushbar).dismiss();
                                      }
                                      controller.reverse();
                                      Navigator.pop(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/catch_weight/close-circle.svg",
                                          height: getIt<Functions>().getWidgetHeight(height: 26),
                                          width: getIt<Functions>().getWidgetWidth(width: 26),
                                          fit: BoxFit.fill,
                                        ),
                                        SizedBox(
                                          width: getIt<Functions>().getWidgetWidth(width: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                            getIt<Variables>().generalVariables.popUpWidget,
                          ],
                        ),
                      ),
                    ),
                  )
                : Dialog(
                    insetPadding: EdgeInsets.zero,
                    child: SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: getIt<Functions>().getWidgetHeight(height: 10),
                            ),
                            widget.isCloseDisabled
                                ? widget.isBackEnabled
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: getIt<Functions>().getWidgetWidth(width: 10),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              controller.reverse();
                                              Navigator.pop(context);
                                              context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 0));
                                              getIt<Variables>().generalVariables.indexName = HomeScreen.id;
                                              context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                            },
                                            child: SizedBox(
                                              height: getIt<Functions>().getWidgetHeight(height: 26),
                                              width: getIt<Functions>().getWidgetWidth(width: 26),
                                              child: const Icon(
                                                Icons.arrow_back,
                                                size: 20,
                                                color: Color(0xff282F3A),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: getIt<Functions>().getWidgetHeight(height: 26),
                                            width: getIt<Functions>().getWidgetWidth(width: 26),
                                          ),
                                          SizedBox(
                                            width: getIt<Functions>().getWidgetWidth(width: 10),
                                          ),
                                        ],
                                      )
                                : InkWell(
                                    onTap: () {
                                      if (getIt<Widgets>().flushBarKey.currentWidget != null) {
                                        (getIt<Widgets>().flushBarKey.currentWidget as Flushbar).dismiss();
                                      }
                                      controller.reverse();
                                      Navigator.pop(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/catch_weight/close-circle.svg",
                                          height: getIt<Functions>().getWidgetHeight(height: 26),
                                          width: getIt<Functions>().getWidgetWidth(width: 26),
                                          fit: BoxFit.fill,
                                        ),
                                        SizedBox(
                                          width: getIt<Functions>().getWidgetWidth(width: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                            getIt<Variables>().generalVariables.popUpWidget,
                          ],
                        ),
                      ),
                    ),
                  )),
      ),
    );
  }
}

class NumberInputFormatter extends TextInputFormatter {
  final Function(bool error) onError;

  NumberInputFormatter({required this.onError});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String newText = newValue.text;
    final RegExp regex = RegExp(r'^\d{0,4}(\.\d{0,3})?$');
    if (!regex.hasMatch(newText)) {
      onError(true);
      return oldValue;
    } else {
      onError(false);
    }

    return newValue;
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  final int maxDigitsBeforeDecimal;
  final int maxDigitsAfterDecimal;

  DecimalTextInputFormatter({
    required this.maxDigitsBeforeDecimal,
    required this.maxDigitsAfterDecimal,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Allow empty input
    if (text.isEmpty) {
      return newValue;
    }

    final regex = RegExp(r'^\d*\.?\d*$');
    if (!regex.hasMatch(text)) {
      return oldValue; // block invalid characters
    }

    final parts = text.split('.');
    final beforeDecimal = parts[0];
    final afterDecimal = parts.length > 1 ? parts[1] : '';

    if (beforeDecimal.length > maxDigitsBeforeDecimal || afterDecimal.length > maxDigitsAfterDecimal) {
      return oldValue; // prevent update if limits exceeded
    }

    return newValue;
  }
}
