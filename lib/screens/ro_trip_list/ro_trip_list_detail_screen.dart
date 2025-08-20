// Flutter imports:
import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';

// Project imports:
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/bloc/ro_trip_list/ro_trip_list_detail/ro_trip_list_detail_bloc.dart';
import 'package:oda/local_database/user_box/user.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/resources/widgets.dart';
import 'package:oda/screens/ro_trip_list/widgets/entry_widget.dart';
import 'package:oda/screens/ro_trip_list/widgets/return_items_widget.dart';
import 'package:oda/screens/ro_trip_list/widgets/total_assets_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RoTripListDetailScreen extends StatefulWidget {
  static const String id = "ro_trip_list_detail_screen";

  const RoTripListDetailScreen({super.key});

  @override
  State<RoTripListDetailScreen> createState() => _RoTripListDetailScreenState();
}

class _RoTripListDetailScreenState extends State<RoTripListDetailScreen> {
  TextEditingController searchBar = TextEditingController();
  TextEditingController productController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  Timer? timer;

  @override
  void initState() {
   //context.read<RoTripListDetailBloc>().add(const RoTripListDetailWidgetChangingEvent(selectedWidget: EntryWidget.id));
    context.read<RoTripListDetailBloc>().add(const RoTripListDetailInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        if (Scaffold.of(context).isDrawerOpen || Scaffold.of(context).isEndDrawerOpen) {
          Scaffold.of(context).closeEndDrawer();
          Scaffold.of(context).closeDrawer();
        } else {
          if (context.read<RoTripListDetailBloc>().detailPageId == EntryWidget.id) {
            getIt<Variables>().generalVariables.indexName =
                getIt<Variables>().generalVariables.roTripListRouteList[getIt<Variables>().generalVariables.roTripListRouteList.length - 1];
            context.read<NavigationBloc>().add(const NavigationInitialEvent());
            getIt<Variables>().generalVariables.roTripListRouteList.removeAt(getIt<Variables>().generalVariables.roTripListRouteList.length - 1);
          } else {
            context.read<RoTripListDetailBloc>().searchBarEnabled = false;
            context.read<RoTripListDetailBloc>().detailPageId = EntryWidget.id;
            context.read<RoTripListDetailBloc>().add(const RoTripListDetailWidgetChangingEvent(selectedWidget: EntryWidget.id));
          }
        }
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 480) {
            return Container(
              color: const Color(0xffEEF4FF),
              child: Stack(
                children: [
                  Container(
                    height: getIt<Functions>().getWidgetHeight(height: 152),
                    width: getIt<Variables>().generalVariables.width,
                    color: const Color(0xff2C334D),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<RoTripListDetailBloc, RoTripListDetailState>(
                        builder: (BuildContext context, RoTripListDetailState state) {
                          return AppBar(
                            backgroundColor: const Color(0xff2C334D),
                            leading: IconButton(
                              onPressed: () {
                                if (context.read<RoTripListDetailBloc>().detailPageId == EntryWidget.id) {
                                  getIt<Variables>().generalVariables.indexName = getIt<Variables>()
                                      .generalVariables
                                      .roTripListRouteList[getIt<Variables>().generalVariables.roTripListRouteList.length - 1];
                                  context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                  getIt<Variables>()
                                      .generalVariables
                                      .roTripListRouteList
                                      .removeAt(getIt<Variables>().generalVariables.roTripListRouteList.length - 1);
                                } else {
                                  context.read<RoTripListDetailBloc>().searchBarEnabled = false;
                                  context.read<RoTripListDetailBloc>().detailPageId = EntryWidget.id;
                                  context
                                      .read<RoTripListDetailBloc>()
                                      .add(const RoTripListDetailWidgetChangingEvent(selectedWidget: EntryWidget.id));
                                }
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Color(0xffffffff),
                              ),
                            ),
                            titleSpacing: 0,
                            title: Text(
                              "${getIt<Variables>().generalVariables.currentLanguage.trip} # ${getIt<Variables>().generalVariables.roTripListMainIdData.tripNum} - ${getIt<Variables>().generalVariables.roTripListMainIdData.tripRoute}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 20),
                                  color: const Color(0xffffffff)),
                            ),
                            actions: [
                              AnimatedCrossFade(
                                firstChild: const SizedBox(),
                                secondChild: textBars(controller: searchBar),
                                crossFadeState:
                                    context.read<RoTripListDetailBloc>().searchBarEnabled ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                duration: const Duration(milliseconds: 100),
                              ),
                              SizedBox(
                                width: getIt<Functions>().getWidgetWidth(width: 15),
                              ),
                              if (getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer" &&
                                  context.read<RoTripListDetailBloc>().roTripDetailModel.response.tripInfo.tripReturnStatus.toLowerCase() !=
                                      "completed")
                                context.read<RoTripListDetailBloc>().detailPageId == ReturnItemsWidget.id
                                    ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                            minimumSize: const Size(100, 36),
                                            maximumSize: const Size(100, 36)),
                                        onPressed: () {
                                          getIt<Variables>().generalVariables.popUpWidget = closeSessionContent(contextNew: context);
                                          getIt<Functions>().showAnimatedDialog(context: context, isFromTop: true, isCloseDisabled: false);
                                        },
                                        child: const Text(
                                          "Submit",
                                          style: TextStyle(color: Colors.black),
                                        ))
                                    : const SizedBox(),
                              if (getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer" &&
                                  context.read<RoTripListDetailBloc>().roTripDetailModel.response.tripInfo.tripReturnStatus.toLowerCase() !=
                                      "completed")
                                SizedBox(width: getIt<Functions>().getWidgetWidth(width: 15)),
                              if (getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer" &&
                                  context.read<RoTripListDetailBloc>().roTripDetailModel.response.tripInfo.tripReturnStatus.toLowerCase() !=
                                      "completed")
                                context.read<RoTripListDetailBloc>().detailPageId == ReturnItemsWidget.id
                                    ? InkWell(
                                        onTap: () {
                                          getIt<Variables>().generalVariables.popUpWidget = addNewContent();
                                          getIt<Functions>().showAnimatedDialog(context: context, isFromTop: true, isCloseDisabled: false);
                                        },
                                        child: Container(
                                          height: getIt<Functions>().getWidgetHeight(height: 37),
                                          width: getIt<Functions>().getWidgetWidth(width: 37),
                                          decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFFFFFFF).withOpacity(0.2)),
                                          child: const Center(
                                              child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          )),
                                        ),
                                      )
                                    : const SizedBox(),
                              if (getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer" &&
                                  context.read<RoTripListDetailBloc>().roTripDetailModel.response.tripInfo.tripReturnStatus.toLowerCase() !=
                                      "completed")
                                SizedBox(width: getIt<Functions>().getWidgetWidth(width: 15)),
                              context.read<RoTripListDetailBloc>().detailPageId == ReturnItemsWidget.id ||
                                      context.read<RoTripListDetailBloc>().detailPageId == TotalAssetsWidget.id
                                  ? InkWell(
                                      onTap: state is RoTripListDetailLoading
                                          ? () {}
                                          : () {
                                              context.read<RoTripListDetailBloc>().searchBarEnabled =
                                                  !context.read<RoTripListDetailBloc>().searchBarEnabled;
                                              if (!context.read<RoTripListDetailBloc>().searchBarEnabled) {
                                                searchBar.clear();
                                                FocusManager.instance.primaryFocus!.unfocus();
                                                context.read<RoTripListDetailBloc>().searchText = "";
                                              }
                                              context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                                            },
                                      child: Container(
                                        height: getIt<Functions>().getWidgetHeight(height: 37),
                                        width: getIt<Functions>().getWidgetWidth(width: 37),
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFFFFFFF).withOpacity(0.2)),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            'assets/warehouse_list/search_icon.svg',
                                            height: getIt<Functions>().getWidgetHeight(height: 15.5),
                                            width: getIt<Functions>().getWidgetWidth(width: 15.5),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              SizedBox(width: getIt<Functions>().getWidgetWidth(width: 15)),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 13)),
                      BlocBuilder<RoTripListDetailBloc, RoTripListDetailState>(
                        builder: (BuildContext context, RoTripListDetailState state) {
                          if (state is RoTripListDetailLoading) {
                            return Skeletonizer(
                              enabled: true,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 15)),
                                decoration: BoxDecoration(
                                  color: const Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: getIt<Functions>().getWidgetHeight(height: 110),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 11)),
                                        child: InputDecorator(
                                          decoration: InputDecoration(
                                            labelText: getIt<Variables>().generalVariables.currentLanguage.stops.toUpperCase(),
                                            labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xff8A8D8E)),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(3.7),
                                                borderSide: BorderSide(color: const Color(0xff282F3A).withOpacity(0.37), width: 0.53)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "0",
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                        fontWeight: FontWeight.w600,
                                                        color: const Color(0xff282F3A)),
                                                  ),
                                                  Text(
                                                    getIt<Variables>().generalVariables.currentLanguage.total,
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                        fontWeight: FontWeight.w500,
                                                        color: const Color(0xff8A8D8E)),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "0",
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                        fontWeight: FontWeight.w600,
                                                        color: const Color(0xff29B473)),
                                                  ),
                                                  Text(
                                                    getIt<Variables>().generalVariables.currentLanguage.completed,
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                        fontWeight: FontWeight.w500,
                                                        color: const Color(0xff8A8D8E)),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "0",
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                        fontWeight: FontWeight.w600,
                                                        color: const Color(0xffFE6250)),
                                                  ),
                                                  Text(
                                                    getIt<Variables>().generalVariables.currentLanguage.remaining,
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                        fontWeight: FontWeight.w500,
                                                        color: const Color(0xff8A8D8E)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: getIt<Functions>().getWidgetWidth(width: 20),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 11)),
                                        child: InputDecorator(
                                          decoration: InputDecoration(
                                            labelText: getIt<Variables>().generalVariables.currentLanguage.invoice.toUpperCase(),
                                            labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xff8A8D8E)),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(3.7),
                                                borderSide: BorderSide(color: const Color(0xff8A8D8E).withOpacity(0.37), width: 0.53)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "0",
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                        fontWeight: FontWeight.w600,
                                                        color: const Color(0xff282F3A)),
                                                  ),
                                                  Text(
                                                    getIt<Variables>().generalVariables.currentLanguage.total,
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                        fontWeight: FontWeight.w500,
                                                        color: const Color(0xff8A8D8E)),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "0",
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                        fontWeight: FontWeight.w600,
                                                        color: const Color(0xff29B473)),
                                                  ),
                                                  Text(
                                                    getIt<Variables>().generalVariables.currentLanguage.completed,
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                        fontWeight: FontWeight.w500,
                                                        color: const Color(0xff8A8D8E)),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "0",
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                        fontWeight: FontWeight.w600,
                                                        color: const Color(0xffFE6250)),
                                                  ),
                                                  Text(
                                                    getIt<Variables>().generalVariables.currentLanguage.remaining,
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                        fontWeight: FontWeight.w500,
                                                        color: const Color(0xff8A8D8E)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: getIt<Functions>().getWidgetWidth(width: 20),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 11)),
                                        child: InputDecorator(
                                          decoration: InputDecoration(
                                            labelText: getIt<Variables>().generalVariables.currentLanguage.takeBack.toUpperCase(),
                                            labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xff8A8D8E)),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(3.7),
                                                borderSide: BorderSide(color: const Color(0xff8A8D8E).withOpacity(0.37), width: 0.53)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "0",
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                        fontWeight: FontWeight.w600,
                                                        color: const Color(0xff282F3A)),
                                                  ),
                                                  Text(
                                                    getIt<Variables>().generalVariables.currentLanguage.total,
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                        fontWeight: FontWeight.w500,
                                                        color: const Color(0xff8A8D8E)),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "0",
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                        fontWeight: FontWeight.w600,
                                                        color: const Color(0xff29B473)),
                                                  ),
                                                  Text(
                                                    getIt<Variables>().generalVariables.currentLanguage.completed,
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                        fontWeight: FontWeight.w500,
                                                        color: const Color(0xff8A8D8E)),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "0",
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                        fontWeight: FontWeight.w600,
                                                        color: const Color(0xffFE6250)),
                                                  ),
                                                  Text(
                                                    getIt<Variables>().generalVariables.currentLanguage.remaining,
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                        fontWeight: FontWeight.w500,
                                                        color: const Color(0xff8A8D8E)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (state is RoTripListDetailLoaded) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 15)),
                              decoration: BoxDecoration(
                                color: const Color(0xffffffff),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: getIt<Functions>().getWidgetHeight(height: 110),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 11)),
                                      child: InputDecorator(
                                        decoration: InputDecoration(
                                          labelText: getIt<Variables>().generalVariables.currentLanguage.stops.toUpperCase(),
                                          labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xff8A8D8E)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(3.7),
                                              borderSide: BorderSide(color: const Color(0xff282F3A).withOpacity(0.37), width: 0.53)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  context.read<RoTripListDetailBloc>().roTripDetailModel.response.tripInfo.stopsCount,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xff282F3A)),
                                                ),
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.total,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff8A8D8E)),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  context
                                                      .read<RoTripListDetailBloc>()
                                                      .roTripDetailModel
                                                      .response
                                                      .tripInfo
                                                      .completedStopsCount
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xff29B473)),
                                                ),
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.completed,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff8A8D8E)),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  context
                                                      .read<RoTripListDetailBloc>()
                                                      .roTripDetailModel
                                                      .response
                                                      .tripInfo
                                                      .remainingStopsCount
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xffFE6250)),
                                                ),
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.remaining,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff8A8D8E)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: getIt<Functions>().getWidgetWidth(width: 20),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 11)),
                                      child: InputDecorator(
                                        decoration: InputDecoration(
                                          labelText: getIt<Variables>().generalVariables.currentLanguage.invoice.toUpperCase(),
                                          labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xff8A8D8E)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(3.7),
                                              borderSide: BorderSide(color: const Color(0xff8A8D8E).withOpacity(0.37), width: 0.53)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  context
                                                      .read<RoTripListDetailBloc>()
                                                      .roTripDetailModel
                                                      .response
                                                      .tripInfo
                                                      .totalInvoiceCount
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xff282F3A)),
                                                ),
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.total,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff8A8D8E)),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  context
                                                      .read<RoTripListDetailBloc>()
                                                      .roTripDetailModel
                                                      .response
                                                      .tripInfo
                                                      .completedInvoiceCount
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xff29B473)),
                                                ),
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.completed,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff8A8D8E)),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  context
                                                      .read<RoTripListDetailBloc>()
                                                      .roTripDetailModel
                                                      .response
                                                      .tripInfo
                                                      .remainingInvoiceCount
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xffFE6250)),
                                                ),
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.remaining,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff8A8D8E)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: getIt<Functions>().getWidgetWidth(width: 20),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 11)),
                                      child: InputDecorator(
                                        decoration: InputDecoration(
                                          labelText: getIt<Variables>().generalVariables.currentLanguage.takeBack.toUpperCase(),
                                          labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xff8A8D8E)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(3.7),
                                              borderSide: BorderSide(color: const Color(0xff8A8D8E).withOpacity(0.37), width: 0.53)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  context
                                                      .read<RoTripListDetailBloc>()
                                                      .roTripDetailModel
                                                      .response
                                                      .tripInfo
                                                      .totalTakeBackCount
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xff282F3A)),
                                                ),
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.total,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff8A8D8E)),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  context
                                                      .read<RoTripListDetailBloc>()
                                                      .roTripDetailModel
                                                      .response
                                                      .tripInfo
                                                      .completedTakeBackCount
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xff29B473)),
                                                ),
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.completed,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff8A8D8E)),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  context
                                                      .read<RoTripListDetailBloc>()
                                                      .roTripDetailModel
                                                      .response
                                                      .tripInfo
                                                      .remainingTakeBackCount
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xffFE6250)),
                                                ),
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.remaining,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff8A8D8E)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 28)),
                      BlocConsumer<RoTripListDetailBloc, RoTripListDetailState>(
                        buildWhen: (RoTripListDetailState previous, RoTripListDetailState current) {
                          return previous != current;
                        },
                        listenWhen: (RoTripListDetailState previous, RoTripListDetailState current) {
                          return previous != current;
                        },
                        listener: (BuildContext context, RoTripListDetailState state) {
                          if (state is RoTripListDetailConfirm) {
                            context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent(stillLoading: false));
                            FocusManager.instance.primaryFocus!.unfocus();
                          }
                        },
                        builder: (BuildContext context, RoTripListDetailState state) {
                          if (state is RoTripListDetailLoaded) {
                            return Expanded(child: context.read<RoTripListDetailBloc>().detailPageWidget);
                          } else if (state is RoTripListDetailLoading) {
                            return const Expanded(
                                child: Center(
                              child: CircularProgressIndicator(),
                            ));
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Container(
              color: const Color(0xffEEF4FF),
              child: Stack(
                children: [
                  Container(
                    height: getIt<Functions>().getWidgetHeight(height: 152),
                    width: getIt<Variables>().generalVariables.width,
                    color: const Color(0xff2C334D),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<RoTripListDetailBloc, RoTripListDetailState>(
                        builder: (BuildContext context, RoTripListDetailState state) {
                          return AppBar(
                            backgroundColor: const Color(0xff2C334D),
                            leading: IconButton(
                              onPressed: () {
                                if (context.read<RoTripListDetailBloc>().detailPageId == EntryWidget.id) {
                                  getIt<Variables>().generalVariables.indexName = getIt<Variables>()
                                      .generalVariables
                                      .roTripListRouteList[getIt<Variables>().generalVariables.roTripListRouteList.length - 1];
                                  context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                  getIt<Variables>()
                                      .generalVariables
                                      .roTripListRouteList
                                      .removeAt(getIt<Variables>().generalVariables.roTripListRouteList.length - 1);
                                } else {
                                  context.read<RoTripListDetailBloc>().searchBarEnabled = false;
                                  context.read<RoTripListDetailBloc>().detailPageId = EntryWidget.id;
                                  context
                                      .read<RoTripListDetailBloc>()
                                      .add(const RoTripListDetailWidgetChangingEvent(selectedWidget: EntryWidget.id));
                                }
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Color(0xffffffff),
                              ),
                            ),
                            titleSpacing: 0,
                            title: AnimatedCrossFade(
                              firstChild: Text(
                                "${getIt<Variables>().generalVariables.currentLanguage.trip} # ${getIt<Variables>().generalVariables.roTripListMainIdData.tripNum} - ${getIt<Variables>().generalVariables.roTripListMainIdData.tripRoute}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                    color: const Color(0xffffffff)),
                              ),
                              secondChild: textBars(controller: searchBar),
                              crossFadeState:
                                  context.read<RoTripListDetailBloc>().searchBarEnabled ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 100),
                            ),
                            actions: [
                              SizedBox(
                                width: getIt<Functions>().getWidgetWidth(width: 8),
                              ),
                              if (getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer" &&
                                  context.read<RoTripListDetailBloc>().roTripDetailModel.response.tripInfo.tripReturnStatus.toLowerCase() !=
                                      "completed")
                                context.read<RoTripListDetailBloc>().detailPageId == ReturnItemsWidget.id
                                    ? InkWell(
                                        onTap: () {
                                          getIt<Variables>().generalVariables.popUpWidget = closeSessionContent(contextNew: context);
                                          getIt<Functions>().showAnimatedDialog(context: context, isFromTop: true, isCloseDisabled: false);
                                        },
                                        child: Container(
                                          height: getIt<Functions>().getWidgetHeight(height: 28),
                                          width: getIt<Functions>().getWidgetWidth(width: 70),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Text(
                                              getIt<Variables>().generalVariables.currentLanguage.submit.toUpperCase(),
                                              style: TextStyle(color: Colors.black, fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                            ),
                                          ),
                                        ))
                                    : const SizedBox(),
                              if (getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer" &&
                                  context.read<RoTripListDetailBloc>().roTripDetailModel.response.tripInfo.tripReturnStatus.toLowerCase() !=
                                      "completed")
                                SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                              if (getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer" &&
                                  context.read<RoTripListDetailBloc>().roTripDetailModel.response.tripInfo.tripReturnStatus.toLowerCase() !=
                                      "completed")
                                context.read<RoTripListDetailBloc>().detailPageId == ReturnItemsWidget.id
                                    ? InkWell(
                                        onTap: () {
                                          getIt<Variables>().generalVariables.popUpWidget = addNewContent();
                                          getIt<Functions>().showAnimatedDialog(context: context, isFromTop: true, isCloseDisabled: false);
                                        },
                                        child: Container(
                                          height: getIt<Functions>().getWidgetHeight(height: 37),
                                          width: getIt<Functions>().getWidgetWidth(width: 37),
                                          decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFFFFFFF).withOpacity(0.2)),
                                          child: const Center(
                                              child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          )),
                                        ),
                                      )
                                    : const SizedBox(),
                              if (getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer" &&
                                  context.read<RoTripListDetailBloc>().roTripDetailModel.response.tripInfo.tripReturnStatus.toLowerCase() !=
                                      "completed")
                                SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                              context.read<RoTripListDetailBloc>().detailPageId == ReturnItemsWidget.id ||
                                      context.read<RoTripListDetailBloc>().detailPageId == TotalAssetsWidget.id
                                  ? InkWell(
                                      onTap: state is RoTripListDetailLoading
                                          ? () {}
                                          : () {
                                              context.read<RoTripListDetailBloc>().searchBarEnabled =
                                                  !context.read<RoTripListDetailBloc>().searchBarEnabled;
                                              if (!context.read<RoTripListDetailBloc>().searchBarEnabled) {
                                                searchBar.clear();
                                                FocusManager.instance.primaryFocus!.unfocus();
                                                context.read<RoTripListDetailBloc>().searchText = "";
                                              }
                                              context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                                            },
                                      child: Container(
                                        height: getIt<Functions>().getWidgetHeight(height: 37),
                                        width: getIt<Functions>().getWidgetWidth(width: 37),
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFFFFFFF).withOpacity(0.2)),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            'assets/warehouse_list/search_icon.svg',
                                            height: getIt<Functions>().getWidgetHeight(height: 15.5),
                                            width: getIt<Functions>().getWidgetWidth(width: 15.5),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)),
                      BlocBuilder<RoTripListDetailBloc, RoTripListDetailState>(
                        builder: (BuildContext context, RoTripListDetailState state) {
                          if (state is RoTripListDetailLoading) {
                            return Skeletonizer(
                              enabled: true,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: getIt<Functions>().getWidgetWidth(width: 15),
                                    vertical: getIt<Functions>().getWidgetHeight(height: 15)),
                                decoration: BoxDecoration(
                                  color: const Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: getIt<Functions>().getWidgetHeight(height: 148),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: InputDecorator(
                                        decoration: InputDecoration(
                                          labelText: getIt<Variables>().generalVariables.currentLanguage.stops.toUpperCase(),
                                          labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xff8A8D8E)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(3.7),
                                              borderSide: BorderSide(color: const Color(0xff8A8D8E).withOpacity(0.37), width: 0.53)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.total,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff8A8D8E)),
                                                ),
                                                Text(
                                                  "0",
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xff282F3A)),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.completed,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff8A8D8E)),
                                                ),
                                                Text(
                                                  "0",
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xff29B473)),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.remaining,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff8A8D8E)),
                                                ),
                                                Text(
                                                  "0",
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xffFE6250)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: getIt<Functions>().getWidgetWidth(width: 6),
                                    ),
                                    Expanded(
                                      child: InputDecorator(
                                        decoration: InputDecoration(
                                          labelText: getIt<Variables>().generalVariables.currentLanguage.invoice.toUpperCase(),
                                          labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xff8A8D8E)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(3.7),
                                              borderSide: BorderSide(color: const Color(0xff8A8D8E).withOpacity(0.37), width: 0.53)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.total,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff8A8D8E)),
                                                ),
                                                Text(
                                                  "0",
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xff282F3A)),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.completed,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff8A8D8E)),
                                                ),
                                                Text(
                                                  "0",
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xff29B473)),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.remaining,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff8A8D8E)),
                                                ),
                                                Text(
                                                  "0",
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xffFE6250)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: getIt<Functions>().getWidgetWidth(width: 6),
                                    ),
                                    Expanded(
                                      child: InputDecorator(
                                        decoration: InputDecoration(
                                          labelText: getIt<Variables>().generalVariables.currentLanguage.takeBack.toUpperCase(),
                                          labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xff8A8D8E)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(3.7),
                                              borderSide: BorderSide(color: const Color(0xff8A8D8E).withOpacity(0.37), width: 0.53)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.total,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff8A8D8E)),
                                                ),
                                                Text(
                                                  "0",
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xff282F3A)),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.completed,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff8A8D8E)),
                                                ),
                                                Text(
                                                  "0",
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xff29B473)),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.remaining,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff8A8D8E)),
                                                ),
                                                Text(
                                                  "0",
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xffFE6250)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (state is RoTripListDetailLoaded) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: getIt<Functions>().getWidgetWidth(width: 15), vertical: getIt<Functions>().getWidgetHeight(height: 15)),
                              decoration: BoxDecoration(
                                color: const Color(0xffffffff),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: getIt<Functions>().getWidgetHeight(height: 148),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        labelText: getIt<Variables>().generalVariables.currentLanguage.stops.toUpperCase(),
                                        labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xff8A8D8E)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(3.7),
                                            borderSide: BorderSide(color: const Color(0xff8A8D8E).withOpacity(0.37), width: 0.53)),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                getIt<Variables>().generalVariables.currentLanguage.total,
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(0xff8A8D8E)),
                                              ),
                                              Text(
                                                context.read<RoTripListDetailBloc>().roTripDetailModel.response.tripInfo.stopsCount.toString(),
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(0xff282F3A)),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                getIt<Variables>().generalVariables.currentLanguage.completed,
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(0xff8A8D8E)),
                                              ),
                                              Text(
                                                context
                                                    .read<RoTripListDetailBloc>()
                                                    .roTripDetailModel
                                                    .response
                                                    .tripInfo
                                                    .completedStopsCount
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(0xff29B473)),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                getIt<Variables>().generalVariables.currentLanguage.remaining,
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(0xff8A8D8E)),
                                              ),
                                              Text(
                                                context
                                                    .read<RoTripListDetailBloc>()
                                                    .roTripDetailModel
                                                    .response
                                                    .tripInfo
                                                    .remainingStopsCount
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(0xffFE6250)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: getIt<Functions>().getWidgetWidth(width: 6),
                                  ),
                                  Expanded(
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        labelText: getIt<Variables>().generalVariables.currentLanguage.invoice.toUpperCase(),
                                        labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xff8A8D8E)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(3.7),
                                            borderSide: BorderSide(color: const Color(0xff8A8D8E).withOpacity(0.37), width: 0.53)),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                getIt<Variables>().generalVariables.currentLanguage.total,
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(0xff8A8D8E)),
                                              ),
                                              Text(
                                                context.read<RoTripListDetailBloc>().roTripDetailModel.response.tripInfo.totalInvoiceCount.toString(),
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(0xff282F3A)),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                getIt<Variables>().generalVariables.currentLanguage.completed,
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(0xff8A8D8E)),
                                              ),
                                              Text(
                                                context
                                                    .read<RoTripListDetailBloc>()
                                                    .roTripDetailModel
                                                    .response
                                                    .tripInfo
                                                    .completedInvoiceCount
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(0xff29B473)),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                getIt<Variables>().generalVariables.currentLanguage.remaining,
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(0xff8A8D8E)),
                                              ),
                                              Text(
                                                context
                                                    .read<RoTripListDetailBloc>()
                                                    .roTripDetailModel
                                                    .response
                                                    .tripInfo
                                                    .remainingInvoiceCount
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(0xffFE6250)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: getIt<Functions>().getWidgetWidth(width: 6),
                                  ),
                                  Expanded(
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        labelText: getIt<Variables>().generalVariables.currentLanguage.takeBack.toUpperCase(),
                                        labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xff8A8D8E)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(3.7),
                                            borderSide: BorderSide(color: const Color(0xff8A8D8E).withOpacity(0.37), width: 0.53)),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                getIt<Variables>().generalVariables.currentLanguage.total,
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(0xff8A8D8E)),
                                              ),
                                              Text(
                                                context
                                                    .read<RoTripListDetailBloc>()
                                                    .roTripDetailModel
                                                    .response
                                                    .tripInfo
                                                    .totalTakeBackCount
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(0xff282F3A)),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                getIt<Variables>().generalVariables.currentLanguage.completed,
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(0xff8A8D8E)),
                                              ),
                                              Text(
                                                context
                                                    .read<RoTripListDetailBloc>()
                                                    .roTripDetailModel
                                                    .response
                                                    .tripInfo
                                                    .completedTakeBackCount
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(0xff29B473)),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                getIt<Variables>().generalVariables.currentLanguage.remaining,
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(0xff8A8D8E)),
                                              ),
                                              Text(
                                                context
                                                    .read<RoTripListDetailBloc>()
                                                    .roTripDetailModel
                                                    .response
                                                    .tripInfo
                                                    .remainingTakeBackCount
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(0xffFE6250)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 16)),
                      BlocConsumer<RoTripListDetailBloc, RoTripListDetailState>(
                        buildWhen: (RoTripListDetailState previous, RoTripListDetailState current) {
                          return previous != current;
                        },
                        listenWhen: (RoTripListDetailState previous, RoTripListDetailState current) {
                          return previous != current;
                        },
                        listener: (BuildContext context, RoTripListDetailState state) {
                          if (state is RoTripListDetailConfirm) {
                            context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent(stillLoading: false));
                            FocusManager.instance.primaryFocus!.unfocus();
                          }
                        },
                        builder: (BuildContext context, RoTripListDetailState state) {
                          if (state is RoTripListDetailLoaded) {
                            return Expanded(child: context.read<RoTripListDetailBloc>().detailPageWidget);
                          } else if (state is RoTripListDetailLoading) {
                            return const Expanded(
                                child: Center(
                              child: CircularProgressIndicator(),
                            ));
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget textBars({required TextEditingController controller}) {
    return BlocBuilder<RoTripListDetailBloc, RoTripListDetailState>(
      builder: (BuildContext context, RoTripListDetailState state) {
        return SizedBox(
          height: getIt<Functions>().getWidgetHeight(height: 36),
          width: getIt<Functions>().getWidgetWidth(width: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: getIt<Functions>().getWidgetHeight(height: 36),
                child: TextFormField(
                  onChanged: (value) {
                    context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                    if (timer?.isActive ?? false) timer?.cancel();
                    timer = Timer(const Duration(milliseconds: 500), () {
                      if (value.isNotEmpty) {
                        context.read<RoTripListDetailBloc>().searchText = value;
                        context.read<RoTripListDetailBloc>().add(const RoTripListDetailFilterEvent());
                      } else {
                        FocusManager.instance.primaryFocus!.unfocus();
                        context.read<RoTripListDetailBloc>().searchText = "";
                        context.read<RoTripListDetailBloc>().add(const RoTripListDetailFilterEvent());
                      }
                    });
                  },
                  controller: controller,
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 15), fontWeight: FontWeight.w500, color: Colors.white),
                  decoration: InputDecoration(
                      fillColor: const Color(0xff767680).withOpacity(0.12),
                      filled: true,
                      contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 15)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xffffffff), width: 0.68)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xffffffff), width: 0.68)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xffffffff), width: 0.68)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xffffffff), width: 0.68)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xffffffff), width: 0.68)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xffffffff), width: 0.68)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xffffffff)),
                      suffixIcon: controller.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                controller.clear();
                                FocusManager.instance.primaryFocus!.unfocus();
                                context.read<RoTripListDetailBloc>().searchText = "";
                                context.read<RoTripListDetailBloc>().add(const RoTripListDetailFilterEvent());
                              },
                              icon: const Icon(Icons.clear, color: Colors.white, size: 15))
                          : const SizedBox(),
                      hintText: getIt<Variables>().generalVariables.currentLanguage.search,
                      hintStyle: TextStyle(
                          color: const Color(0xffffffff).withOpacity(0.75),
                          fontWeight: FontWeight.w400,
                          fontSize: getIt<Functions>().getTextSize(fontSize: 15))),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget addNewContent() {
    context.read<RoTripListDetailBloc>().updateLoader = false;
    context.read<RoTripListDetailBloc>().selectedProductEmpty = false;
    context.read<RoTripListDetailBloc>().selectedQuantityEmpty = false;
    context.read<RoTripListDetailBloc>().productText = null;
    context.read<RoTripListDetailBloc>().quantityText = null;
    productController.clear();
    quantityController.clear();
    return BlocConsumer<RoTripListDetailBloc, RoTripListDetailState>(
      listenWhen: (RoTripListDetailState previous, RoTripListDetailState current) {
        return previous != current;
      },
      buildWhen: (RoTripListDetailState previous, RoTripListDetailState current) {
        return previous != current;
      },
      listener: (BuildContext context, RoTripListDetailState state) {
        if (state is RoTripListDetailSuccess) {
          context.read<RoTripListDetailBloc>().updateLoader = false;
          Navigator.pop(context);
          ScaffoldMessenger.of(context).clearSnackBars();
          if (state.message != "") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        }
        if (state is RoTripListDetailFailure) {
          context.read<RoTripListDetailBloc>().updateLoader = false;
          context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
        }
        if (state is RoTripListDetailError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          getIt<Widgets>().flushBarWidget(context: context, message: state.message);
        }
      },
      builder: (BuildContext context, RoTripListDetailState state) {
        return SizedBox(
          width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 600 : 415),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: context.read<RoTripListDetailBloc>().updateLoader ? () {} : () {},
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xff292D32),
                        )),
                    SizedBox(
                      width: getIt<Functions>().getWidgetWidth(width: 10),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              getIt<Variables>().generalVariables.currentLanguage.addExpenses,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 18 : 14),
                                  color: const Color(0xff282F3A)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: getIt<Functions>().getWidgetHeight(height: 24),
              ),
              const Divider(
                height: 0,
                thickness: 1,
                color: Color(0xffE0E7EC),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 25),
                    ),
                    SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 75),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getIt<Variables>().generalVariables.currentLanguage.addProduct,
                            style: TextStyle(
                                color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 45),
                            child: buildDropButton(isLoading: context.read<RoTripListDetailBloc>().updateLoader),
                          )
                        ],
                      ),
                    ),
                    context.read<RoTripListDetailBloc>().selectedProductEmpty
                        ? Text(
                            getIt<Variables>().generalVariables.currentLanguage.selectItem,
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 10)),
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 15),
                    ),
                    SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 75),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getIt<Variables>().generalVariables.currentLanguage.quantity,
                            style: TextStyle(
                                color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 45),
                            child: TextFormField(
                              controller: quantityController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                context.read<RoTripListDetailBloc>().selectedQuantityEmpty = value.isEmpty ? true : false;
                                context.read<RoTripListDetailBloc>().quantityText = value.isEmpty ? "" : value;
                                context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                              },
                              decoration: InputDecoration(
                                fillColor: const Color(0xffffffff),
                                filled: true,
                                contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 15)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                hintText: getIt<Variables>().generalVariables.currentLanguage.enterQuantity,
                                hintStyle: TextStyle(
                                  color: const Color(0xff8A8D8E),
                                  fontWeight: FontWeight.w400,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                ),
                              ),
                              validator: (value) => value!.isEmpty ? getIt<Variables>().generalVariables.currentLanguage.pleaseEnterQuantity : null,
                            ),
                          )
                        ],
                      ),
                    ),
                    context.read<RoTripListDetailBloc>().selectedQuantityEmpty
                        ? Text(
                            getIt<Variables>().generalVariables.currentLanguage.pleaseEnterQuantity,
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 10)),
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 45),
                    ),
                  ],
                ),
              ),
              context.read<RoTripListDetailBloc>().updateLoader
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 15),
                          ),
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        if (context.read<RoTripListDetailBloc>().productText == null || context.read<RoTripListDetailBloc>().quantityText == null) {
                          if (context.read<RoTripListDetailBloc>().productText == null) {
                            context.read<RoTripListDetailBloc>().selectedProductEmpty = true;
                            context.read<RoTripListDetailBloc>().selectedQuantityEmpty = false;
                            context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                          } else if (context.read<RoTripListDetailBloc>().quantityText == null) {
                            context.read<RoTripListDetailBloc>().selectedProductEmpty = false;
                            context.read<RoTripListDetailBloc>().selectedQuantityEmpty = true;
                            context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                          } else {}
                        } else {
                          context.read<RoTripListDetailBloc>().updateLoader = true;
                          context.read<RoTripListDetailBloc>().productText = productController.text;
                          context.read<RoTripListDetailBloc>().quantityText = quantityController.text;
                          FocusManager.instance.primaryFocus!.unfocus();
                          context.read<RoTripListDetailBloc>().selectedProductEmpty = false;
                          context.read<RoTripListDetailBloc>().selectedQuantityEmpty = false;
                          context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                          context.read<RoTripListDetailBloc>().add(const RoTripListDetailAddNewReturnItemEvent());
                        }
                      },
                      child: Container(
                        height: getIt<Functions>().getWidgetHeight(height: 50),
                        decoration: const BoxDecoration(
                          color: Color(0xff29B473),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                        ),
                        child: Center(
                          child: Text(
                            getIt<Variables>().generalVariables.currentLanguage.add.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: const Color(0xffffffff), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget buildDropButton({required bool isLoading}) {
    return Container(
      height: getIt<Functions>().getWidgetHeight(height: 45),
      decoration: BoxDecoration(
          color: const Color(0xffffffff), borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffE0E7EC), width: 0.73)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: isLoading == false ? changeAltItem : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  context.read<RoTripListDetailBloc>().productText ?? getIt<Variables>().generalVariables.currentLanguage.chooseItem,
                  style: TextStyle(
                      fontSize: context.read<RoTripListDetailBloc>().productText == null ? 12 : 15,
                      color: context.read<RoTripListDetailBloc>().productText == null ? Colors.grey.shade500 : Colors.black),
                ),
              ),
              context.read<RoTripListDetailBloc>().productText != null
                  ? InkWell(
                      onTap: () {
                        context.read<RoTripListDetailBloc>().productText = null;
                        context.read<RoTripListDetailBloc>().selectedProductEmpty = false;
                        context.read<RoTripListDetailBloc>().productTextId = "";
                        context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent(stillLoading: false));
                      },
                      child: const Icon(
                        Icons.close,
                        size: 15,
                        color: Color(0xff8A8D8E),
                      ))
                  : const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: Color(0xff8A8D8E),
                      size: 15,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> changeAltItem() async {
    List<FilterOptionsResponse> searchItems = getIt<Variables>().generalVariables.userData.filterItemsListOptions;
    await showModalBottomSheet(
        backgroundColor: Colors.white,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, modelSetState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        getIt<Variables>().generalVariables.currentLanguage.chooseItem,
                        style: TextStyle(
                            fontSize: getIt<Functions>().getTextSize(fontSize: 26), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                            "assets/catch_weight/close-circle.svg",
                            height: getIt<Functions>().getWidgetHeight(height: 32),
                            width: getIt<Functions>().getWidgetWidth(width: 32),
                            fit: BoxFit.fill,
                          ))
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        fillColor: const Color(0xffffffff),
                        filled: true,
                        contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 15)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        hintText: getIt<Variables>().generalVariables.currentLanguage.chooseItem,
                        hintStyle: TextStyle(
                            color: const Color(0xff8A8D8E), fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                    onChanged: (value) async {
                      Box<UserResponse>? responseData = await Hive.openBox<UserResponse>('boxData');
                      List<FilterOptionsResponse> searchReasons = responseData.getAt(0)!.filterItemsListOptions;
                      searchItems = searchReasons.where((element) => element.label.toLowerCase().contains(value.toLowerCase())).toList();
                      if (mounted) modelSetState(() {});
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.separated(
                      itemCount: searchItems.length,
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                      itemBuilder: (ctx, index) => ListTile(
                        title: Text(
                          searchItems[index].label,
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.read<RoTripListDetailBloc>().product = searchItems[index];
                          context.read<RoTripListDetailBloc>().productText = searchItems[index].label;
                          context.read<RoTripListDetailBloc>().selectedProductEmpty = false;
                          context.read<RoTripListDetailBloc>().productTextId = searchItems[index].id;
                          context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent(stillLoading: false));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
    if (mounted) setState(() {});
  }

  Widget closeSessionContent({required BuildContext contextNew}) {
    context.read<RoTripListDetailBloc>().allFieldsEmpty = false;
    context.read<RoTripListDetailBloc>().selectedLocation = null;
    context.read<RoTripListDetailBloc>().selectedLocationId = "";
    context.read<RoTripListDetailBloc>().updateLoader = false;
    return BlocConsumer<RoTripListDetailBloc, RoTripListDetailState>(
      listenWhen: (RoTripListDetailState previous, RoTripListDetailState current) {
        return previous != current;
      },
      buildWhen: (RoTripListDetailState previous, RoTripListDetailState current) {
        return previous != current;
      },
      listener: (BuildContext context, RoTripListDetailState state) {
        if (state is RoTripListDetailSuccess) {
          context.read<RoTripListDetailBloc>().updateLoader = false;
          Navigator.pop(context);
          ScaffoldMessenger.of(context).clearSnackBars();
          getIt<Variables>().generalVariables.indexName =
              getIt<Variables>().generalVariables.roTripListRouteList[getIt<Variables>().generalVariables.roTripListRouteList.length - 1];
          context.read<NavigationBloc>().add(const NavigationInitialEvent());
          getIt<Variables>().generalVariables.roTripListRouteList.removeAt(getIt<Variables>().generalVariables.roTripListRouteList.length - 1);
          if (state.message != "") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        }
        if (state is RoTripListDetailFailure) {
          context.read<RoTripListDetailBloc>().updateLoader = false;
          context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
        }
        if (state is RoTripListDetailError) {
          context.read<RoTripListDetailBloc>().updateLoader = false;
          ScaffoldMessenger.of(context).clearSnackBars();
          getIt<Widgets>().flushBarWidget(context: context, message: state.message);
        }
      },
      builder: (BuildContext context, RoTripListDetailState state) {
        return SizedBox(
          width: getIt<Functions>().getWidgetWidth(width: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
              SvgPicture.asset("assets/pick_list/close_session.svg",
                  height: getIt<Functions>().getWidgetHeight(height: 70), width: getIt<Functions>().getWidgetWidth(width: 70), fit: BoxFit.fill),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
              Text(
                "${getIt<Variables>().generalVariables.currentLanguage.trip} # ${getIt<Variables>().generalVariables.roTripListMainIdData.tripNum}",
                style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 26), color: const Color(0xff282F3A), fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              Text(
                getIt<Variables>().generalVariables.roTripListMainIdData.tripRoute,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: const Color(0xff282F3A)),
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 27)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Container(
                    height: getIt<Functions>().getWidgetHeight(height: 1),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xffFFFFFF),
                        Color(0xffBBC6CD),
                      ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                    ),
                  )),
                  Container(
                    width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 400 : 275),
                    padding: EdgeInsets.symmetric(
                        horizontal: getIt<Functions>().getWidgetWidth(width: 3), vertical: getIt<Functions>().getWidgetHeight(height: 9)),
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xffBBC6CD), width: 0.5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          context.read<RoTripListDetailBloc>().collectedQuantity.toString(),
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 28 : 17),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff007AFF)),
                        ),
                        Center(
                          child: Text(
                            getIt<Variables>().generalVariables.currentLanguage.returnQty.toUpperCase(),
                            style: TextStyle(
                                fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 12 : 11),
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff282F3A)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    height: getIt<Functions>().getWidgetHeight(height: 1),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xffBBC6CD),
                        Color(0xffFFFFFF),
                      ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                    ),
                  )),
                ],
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 37)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                child: SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: 75),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getIt<Variables>().generalVariables.currentLanguage.selectLocation,
                        style: TextStyle(
                            color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                      ),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 45),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: Text(
                              getIt<Variables>().generalVariables.currentLanguage.chooseLocation,
                              style: TextStyle(
                                  color: const Color(0xff8A8D8E),
                                  fontWeight: FontWeight.w400,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                            ),
                            items: context
                                .read<RoTripListDetailBloc>()
                                .loadingDataList
                                .map((element) => DropdownMenuItem<String>(
                                      value: element.label,
                                      child: Text(
                                        element.label,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            value: context.read<RoTripListDetailBloc>().selectedLocation,
                            onChanged: (String? suggestion) async {
                              context.read<RoTripListDetailBloc>().allFieldsEmpty = false;
                              context.read<RoTripListDetailBloc>().selectedLocation = suggestion;
                              context.read<RoTripListDetailBloc>().selectedLocationId =
                                  context.read<RoTripListDetailBloc>().loadingDataList.singleWhere((element) => element.label == suggestion).id;
                              context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                            },
                            iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                ),
                                iconSize: 24,
                                iconEnabledColor: Color(0xff8A8D8E),
                                iconDisabledColor: Color(0xff8A8D8E)),
                            buttonStyleData: ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 15)),
                              decoration: BoxDecoration(
                                  color: const Color(0xffE0E7EC),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: const Color(0xffE0E7EC), width: 0.73)),
                              width: getIt<Functions>().getWidgetWidth(width: 600),
                            ),
                            menuItemStyleData: const MenuItemStyleData(height: 40),
                            dropdownStyleData: DropdownStyleData(
                                maxHeight: 200,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: const Color(0xffffffff)),
                                elevation: 8,
                                offset: const Offset(0, 0)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: context.read<RoTripListDetailBloc>().allFieldsEmpty ? 12 : 0)),
              context.read<RoTripListDetailBloc>().allFieldsEmpty
                  ? Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20.0)),
                          child: Text(
                            getIt<Variables>().generalVariables.currentLanguage.pleaseSelectStagingArea,
                            style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 10), color: Colors.red, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 70)),
              context.read<RoTripListDetailBloc>().updateLoader
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 15),
                          ),
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        if (context.read<RoTripListDetailBloc>().selectedLocation == null) {
                          context.read<RoTripListDetailBloc>().updateLoader = false;
                          context.read<RoTripListDetailBloc>().allFieldsEmpty = true;
                          context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                        } else {
                          context.read<RoTripListDetailBloc>().updateLoader = true;
                          context.read<RoTripListDetailBloc>().allFieldsEmpty = false;
                          FocusManager.instance.primaryFocus!.unfocus();
                          context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                          context.read<RoTripListDetailBloc>().add(const RoTripListDetailCompleteReturnEvent());
                        }
                      },
                      child: Container(
                        height: getIt<Functions>().getWidgetHeight(height: 50),
                        decoration: const BoxDecoration(
                          color: Color(0xff007838),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                        ),
                        child: Center(
                          child: Text(
                            getIt<Variables>().generalVariables.currentLanguage.completeReturn.toUpperCase(),
                            style: TextStyle(
                                color: const Color(0xffffffff), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
