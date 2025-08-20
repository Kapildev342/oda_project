// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// Project imports:
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/bloc/trip_list/trip_list_entry/trip_list_entry_bloc.dart';
import 'package:oda/edited_packages/image_stack_library.dart';
import 'package:oda/local_database/trip_box/trip_list.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/screens/trip_list/trip_list_detail_screen.dart';

class TripListEntryScreen extends StatefulWidget {
  static const String id = "trip_list_entry_screen";

  const TripListEntryScreen({super.key});

  @override
  State<TripListEntryScreen> createState() => _TripListEntryScreenState();
}

class _TripListEntryScreenState extends State<TripListEntryScreen> {
  TextEditingController searchBar = TextEditingController();
  Timer? timer;
  DataGridController dataGridController = DataGridController();

  @override
  void initState() {
    context.read<TripListEntryBloc>().soListDummy = [
      SoList(
          soId: "10363",
          soNum: "24439633",
          soCustomerName: "CEYVISTA LEISURE [PRIVATE] LIMITED.-(ME COLOMBO)",
          soCustomerCode: "CEY-004877",
          soDeliveryInstruction: "",
          soStatus: "Pending",
          soNoOfItems: "2",
          soType: "STORE PICKUP",
          soStops: "3",
          disputeStatus: false,
          soHandledBy: [],
          soItemType: "B",
          tripId: "24439633",
          isSelected: false,
          soNoOfSortedItems: '0',
          soNoOfLoadedItems: '',
          sessionInfo: SessionInfo.fromJson({}),
          soCreatedTime: '26/11/2024, 04:21 PM',
          doDelivery: false,
          tripLoadingBayDryName: '',
          tripLoadingBayFrozenName: '',
          stopId: '')
    ];
    context.read<TripListEntryBloc>().add(const TripListEntryInitialEvent());
    super.initState();
  }

  List<GridColumn> get getColumns {
    return <GridColumn>[
      GridColumn(
        columnName: 'SalesOrder',
        width: getIt<Functions>().getWidgetWidth(width: 275),
        label: Container(
            decoration: const BoxDecoration(color: Color(0xffE0E7EC)),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    activeColor: const Color(0xff007838),
                    checkColor: const Color(0xffffffff),
                    value: context.read<TripListEntryBloc>().isAllSelected,
                    onChanged: (value) {
                      if (value!) {
                        context.read<TripListEntryBloc>().isAllSelected = true;
                        context.read<TripListEntryBloc>().selectedSoList.clear();
                        for (int i = 0; i < context.read<TripListEntryBloc>().searchedSoList.length; i++) {
                          context.read<TripListEntryBloc>().searchedSoList[i].isSelected = true;
                        }
                        context.read<TripListEntryBloc>().selectedSoList.addAll(context.read<TripListEntryBloc>().searchedSoList);
                        context.read<TripListEntryBloc>().add(const TripListEntrySetStateEvent());
                      } else {
                        context.read<TripListEntryBloc>().isAllSelected = false;
                        for (int i = 0; i < context.read<TripListEntryBloc>().searchedSoList.length; i++) {
                          context.read<TripListEntryBloc>().searchedSoList[i].isSelected = false;
                        }
                        context.read<TripListEntryBloc>().selectedSoList.clear();
                        context.read<TripListEntryBloc>().add(const TripListEntrySetStateEvent());
                      }
                    }),
                SizedBox(
                  width: getIt<Functions>().getWidgetWidth(width: 5),
                ),
                Text(getIt<Variables>().generalVariables.currentLanguage.salesOrder,
                    style: TextStyle(
                        color: const Color(0xff282F3A),
                        fontWeight: FontWeight.w700,
                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                        fontFamily: "Figtree")),
              ],
            )),
      ),
      GridColumn(
          columnName: 'Status',
          label: Container(
              decoration: const BoxDecoration(color: Color(0xffE0E7EC)),
              alignment: Alignment.center,
              child: Text(
                getIt<Variables>().generalVariables.currentLanguage.status,
                style: TextStyle(
                    fontFamily: "Figtree",
                    color: const Color(0xff282F3A),
                    fontWeight: FontWeight.w700,
                    fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
              ))),
      GridColumn(
          columnName: 'NoOfItems',
          label: Container(
              decoration: const BoxDecoration(color: Color(0xffE0E7EC)),
              alignment: Alignment.center,
              child: Text(
                getIt<Variables>().generalVariables.currentLanguage.numberOfItems,
                style: TextStyle(
                    fontFamily: "Figtree",
                    color: const Color(0xff282F3A),
                    fontWeight: FontWeight.w700,
                    fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
              ))),
      GridColumn(
          columnName: 'Type',
          label: Container(
              decoration: const BoxDecoration(color: Color(0xffE0E7EC)),
              alignment: Alignment.center,
              child: Text(
                getIt<Variables>().generalVariables.currentLanguage.type,
                style: TextStyle(
                    fontFamily: "Figtree",
                    color: const Color(0xff282F3A),
                    fontWeight: FontWeight.w700,
                    fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
              ))),
      GridColumn(
          columnName: 'Stop',
          label: Container(
              decoration: const BoxDecoration(color: Color(0xffE0E7EC)),
              alignment: Alignment.center,
              child: Text(
                getIt<Variables>().generalVariables.currentLanguage.stop,
                style: TextStyle(
                    fontFamily: "Figtree",
                    color: const Color(0xff282F3A),
                    fontWeight: FontWeight.w700,
                    fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
              ))),
      GridColumn(
          columnName: 'Handled',
          label: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(getIt<Variables>().generalVariables.isDeviceTablet ? 4 : 0),
                      bottomRight: Radius.circular(getIt<Variables>().generalVariables.isDeviceTablet ? 4 : 0)),
                  color: const Color(0xffE0E7EC)),
              alignment: Alignment.center,
              child: Text(
                getIt<Variables>().generalVariables.currentLanguage.handled,
                style: TextStyle(
                    fontFamily: "Figtree",
                    color: const Color(0xff282F3A),
                    fontWeight: FontWeight.w700,
                    fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
              ))),
    ];
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
          getIt<Variables>().generalVariables.indexName =
              getIt<Variables>().generalVariables.tripListRouteList[getIt<Variables>().generalVariables.tripListRouteList.length - 1];
          context.read<NavigationBloc>().add(const NavigationInitialEvent());
          getIt<Variables>().generalVariables.tripListRouteList.removeAt(getIt<Variables>().generalVariables.tripListRouteList.length - 1);
        }
      },
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 480) {
          return Container(
            color: const Color(0xffEEF4FF),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                BlocBuilder<TripListEntryBloc, TripListEntryState>(
                  builder: (BuildContext context, TripListEntryState state) {
                    return SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 194),
                      child: AppBar(
                        backgroundColor: const Color(0xffEEF4FF),
                        leading: IconButton(
                          onPressed: () {
                            getIt<Variables>().generalVariables.indexName = getIt<Variables>()
                                .generalVariables
                                .tripListRouteList[getIt<Variables>().generalVariables.tripListRouteList.length - 1];
                            context.read<NavigationBloc>().add(const NavigationInitialEvent());
                            getIt<Variables>()
                                .generalVariables
                                .tripListRouteList
                                .removeAt(getIt<Variables>().generalVariables.tripListRouteList.length - 1);
                          },
                          icon: const Icon(Icons.arrow_back, color: Color(0xffffffff)),
                        ),
                        titleSpacing: 0,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  "${getIt<Variables>().generalVariables.currentLanguage.sortingTrip} # ${getIt<Variables>().generalVariables.tripListMainIdData.tripNum}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: getIt<Functions>().getTextSize(fontSize: 22),
                                      color: const Color(0xffffffff)),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: getIt<Functions>().getWidgetWidth(width: 7),
                            ),
                          ],
                        ),
                        flexibleSpace: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: const Alignment(0.00, 1.00),
                              end: const Alignment(0, -1),
                              colors: [
                                getIt<Variables>().generalVariables.currentBackGround.bgColor1,
                                getIt<Variables>().generalVariables.currentBackGround.bgColor2
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          AnimatedCrossFade(
                            firstChild: const SizedBox(),
                            secondChild: textBars(controller: searchBar),
                            crossFadeState: context.read<TripListEntryBloc>().searchBarEnabled ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 100),
                          ),
                          SizedBox(
                            width: getIt<Functions>().getWidgetWidth(width: 14),
                          ),
                          Container(
                            height: getIt<Functions>().getWidgetHeight(height: 35),
                            width: getIt<Functions>().getWidgetWidth(width: 118),
                            decoration: BoxDecoration(
                              color: const Color(0xffFFFFFF),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: state is TripListEntryLoading || state is TripListEntryTableLoading
                                      ? () {}
                                      : () {
                                          getIt<Variables>().generalVariables.currentBackGround =
                                              getIt<Variables>().generalVariables.backGroundChangesList[0];
                                          context.read<TripListEntryBloc>().currentListIndex = 0;
                                          context.read<TripListEntryBloc>().add(const TripListEntryFilterEvent());
                                        },
                                  child: context.read<TripListEntryBloc>().currentListIndex == 0
                                      ? Container(
                                          height: getIt<Functions>().getWidgetHeight(height: 29),
                                          width: getIt<Functions>().getWidgetWidth(width: 28),
                                          margin: EdgeInsets.only(
                                              top: getIt<Functions>().getWidgetHeight(height: 3),
                                              bottom: getIt<Functions>().getWidgetHeight(height: 3),
                                              left: getIt<Functions>().getWidgetWidth(width: 3)),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              color: getIt<Variables>().generalVariables.backGroundChangesList[0].color),
                                          child: Center(
                                              child: Text(getIt<Variables>().generalVariables.backGroundChangesList[0].symbol,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                      color: Colors.white))),
                                        )
                                      : Center(
                                          child: Padding(
                                          padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 11)),
                                          child: Text(getIt<Variables>().generalVariables.backGroundChangesList[0].symbol,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                  color: Colors.black)),
                                        )),
                                ),
                                InkWell(
                                  onTap: state is TripListEntryLoading || state is TripListEntryTableLoading
                                      ? () {}
                                      : () {
                                          getIt<Variables>().generalVariables.currentBackGround =
                                              getIt<Variables>().generalVariables.backGroundChangesList[1];
                                          context.read<TripListEntryBloc>().currentListIndex = 1;
                                          context.read<TripListEntryBloc>().add(const TripListEntryFilterEvent());
                                        },
                                  child: context.read<TripListEntryBloc>().currentListIndex == 1
                                      ? Container(
                                          height: getIt<Functions>().getWidgetHeight(height: 29),
                                          width: getIt<Functions>().getWidgetWidth(width: 28),
                                          margin: EdgeInsets.only(
                                              top: getIt<Functions>().getWidgetHeight(height: 3),
                                              bottom: getIt<Functions>().getWidgetHeight(height: 3)),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              color: getIt<Variables>().generalVariables.backGroundChangesList[1].color),
                                          child: Center(
                                              child: Text(getIt<Variables>().generalVariables.backGroundChangesList[1].symbol,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                      color: Colors.white))),
                                        )
                                      : Center(
                                          child: Text(getIt<Variables>().generalVariables.backGroundChangesList[1].symbol,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                  color: Colors.black))),
                                ),
                                InkWell(
                                  onTap: state is TripListEntryLoading || state is TripListEntryTableLoading
                                      ? () {}
                                      : () {
                                          getIt<Variables>().generalVariables.currentBackGround =
                                              getIt<Variables>().generalVariables.backGroundChangesList[2];
                                          context.read<TripListEntryBloc>().currentListIndex = 2;
                                          context.read<TripListEntryBloc>().add(const TripListEntryFilterEvent());
                                        },
                                  child: context.read<TripListEntryBloc>().currentListIndex == 2
                                      ? Container(
                                          height: getIt<Functions>().getWidgetHeight(height: 29),
                                          width: getIt<Functions>().getWidgetWidth(width: 28),
                                          margin: EdgeInsets.only(
                                              top: getIt<Functions>().getWidgetHeight(height: 3),
                                              bottom: getIt<Functions>().getWidgetHeight(height: 3),
                                              right: getIt<Functions>().getWidgetWidth(width: 3)),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              color: getIt<Variables>().generalVariables.backGroundChangesList[2].color),
                                          child: Center(
                                              child: Text(getIt<Variables>().generalVariables.backGroundChangesList[2].symbol,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                      color: Colors.white))),
                                        )
                                      : Center(
                                          child: Padding(
                                          padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 11)),
                                          child: Text(getIt<Variables>().generalVariables.backGroundChangesList[2].symbol,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                  color: Colors.black)),
                                        )),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: getIt<Functions>().getWidgetWidth(width: 14),
                          ),
                          InkWell(
                            onTap: state is TripListEntryLoading || state is TripListEntryTableLoading
                                ? () {}
                                : () {
                                    context.read<TripListEntryBloc>().searchBarEnabled = !context.read<TripListEntryBloc>().searchBarEnabled;
                                    if (!context.read<TripListEntryBloc>().searchBarEnabled) {
                                      searchBar.clear();
                                      FocusManager.instance.primaryFocus!.unfocus();
                                      context.read<TripListEntryBloc>().searchText = "";
                                    }
                                    context.read<TripListEntryBloc>().add(const TripListEntryFilterEvent());
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
                          ),
                          SizedBox(
                            width: getIt<Functions>().getWidgetWidth(width: 14),
                          ),
                          InkWell(
                            onTap: state is TripListEntryLoading || state is TripListEntryTableLoading
                                ? () {}
                                : () {
                                    getIt<Variables>().generalVariables.filterSelectedMainIndex = 0;
                                    Scaffold.of(context).openEndDrawer();
                                  },
                            child: Badge(
                              backgroundColor: const Color(0xff007AFF),
                              smallSize: getIt<Variables>().generalVariables.selectedFilters.isEmpty ? 0 : 8,
                              child: Container(
                                height: getIt<Functions>().getWidgetHeight(height: 37),
                                width: getIt<Functions>().getWidgetWidth(width: 37),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFFFFFFF).withOpacity(0.2)),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/warehouse_list/filter_icon.svg',
                                    height: getIt<Functions>().getWidgetHeight(height: 18),
                                    width: getIt<Functions>().getWidgetWidth(width: 18),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: getIt<Functions>().getWidgetWidth(width: 26),
                          ),
                        ],
                        bottom: PreferredSize(
                          preferredSize: Size(
                              getIt<Functions>().getWidgetWidth(
                                  width: Orientation.portrait == MediaQuery.of(context).orientation
                                      ? getIt<Variables>().generalVariables.width
                                      : getIt<Variables>().generalVariables.height),
                              getIt<Functions>().getWidgetHeight(height: 104)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: getIt<Functions>().getWidgetHeight(height: 45),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: getIt<Variables>().generalVariables.isNetworkOffline
                                            ? () {}
                                            : () {
                                                getIt<Variables>().generalVariables.isStatusDrawer = true;
                                                Scaffold.of(context).openEndDrawer();
                                              },
                                        child: Center(
                                          child: SvgPicture.asset(
                                            "assets/pick_list/status_image.svg",
                                            height: getIt<Functions>().getWidgetHeight(height: 30),
                                            width: getIt<Functions>().getWidgetWidth(width: 30),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: getIt<Variables>().generalVariables.isNetworkOffline
                                            ? () {}
                                            : () {
                                                getIt<Variables>().generalVariables.isStatusDrawer = true;
                                                Scaffold.of(context).openEndDrawer();
                                              },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              getIt<Variables>().generalVariables.currentLanguage.status.toUpperCase(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                  color: const Color(0xffffffff)),
                                            ),
                                            Text(
                                              //getIt<Variables>().generalVariables.tripListMainIdData.tripStatus.toUpperCase(),
                                              getIt<Variables>().generalVariables.tripListMainIdData.tripStatus == "Pending"
                                                  ? getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase()
                                                  : getIt<Variables>().generalVariables.tripListMainIdData.tripStatus == "Partial"
                                                      ? getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase()
                                                      : getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                  color: const Color(0xffF8B11D)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const VerticalDivider(color: Colors.white, width: 18),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.route.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                color: const Color(0xffffffff)),
                                          ),
                                          Text(
                                            getIt<Variables>().generalVariables.tripListMainIdData.tripRoute,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                color: getIt<Variables>().generalVariables.currentBackGround.fontColor),
                                          ),
                                        ],
                                      ),
                                      const VerticalDivider(color: Colors.white, width: 18),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.createdTime.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                color: const Color(0xffffffff)),
                                          ),
                                          Text(
                                            getIt<Variables>().generalVariables.tripListMainIdData.tripCreatedTime,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                color: getIt<Variables>().generalVariables.currentBackGround.fontColor),
                                          ),
                                        ],
                                      ),
                                      const VerticalDivider(color: Colors.white, width: 18),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.total.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                color: const Color(0xffffffff)),
                                          ),
                                          Text(
                                            "${getIt<Variables>().generalVariables.tripListMainIdData.tripOrders} Orders",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                color: getIt<Variables>().generalVariables.currentBackGround.fontColor),
                                          ),
                                        ],
                                      ),
                                      const VerticalDivider(color: Colors.white, width: 18),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.totalStops.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                color: const Color(0xffffffff)),
                                          ),
                                          Text(
                                            "# ${getIt<Variables>().generalVariables.tripListMainIdData.tripStops}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                color: getIt<Variables>().generalVariables.currentBackGround.fontColor),
                                          ),
                                        ],
                                      ),
                                      const VerticalDivider(color: Colors.white, width: 18),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.loadingBay.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                color: const Color(0xffffffff)),
                                          ),
                                          Text(
                                            "${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayDryName} / ${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayFrozenName}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                color: getIt<Variables>().generalVariables.currentBackGround.fontColor),
                                          ),
                                        ],
                                      ),
                                      const VerticalDivider(color: Colors.white, width: 18),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.vehicleNo.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                color: const Color(0xffffffff)),
                                          ),
                                          Text(
                                            getIt<Variables>().generalVariables.tripListMainIdData.tripVehicle,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                color: getIt<Variables>().generalVariables.currentBackGround.fontColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 28)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: getIt<Functions>().getWidgetWidth(width: 15),
                        right: getIt<Functions>().getWidgetWidth(width: 15),
                        top: getIt<Functions>().getWidgetHeight(height: 20)),
                    child: BlocConsumer<TripListEntryBloc, TripListEntryState>(
                      listenWhen: (TripListEntryState previous, TripListEntryState current) {
                        return previous != current;
                      },
                      buildWhen: (TripListEntryState previous, TripListEntryState current) {
                        return previous != current;
                      },
                      listener: (BuildContext context, TripListEntryState state) {},
                      builder: (BuildContext context, TripListEntryState state) {
                        if (state is TripListEntryLoading) {
                          return Skeletonizer(
                            enabled: true,
                            child: SfDataGridTheme(
                              data: const SfDataGridThemeData(
                                  headerColor: Colors.transparent, gridLineColor: Colors.transparent, selectionColor: Colors.transparent),
                              child: SfDataGrid(
                                source: TripListDataSource(context.read<TripListEntryBloc>().soListDummy, dataGridController, context),
                                columnWidthMode: ColumnWidthMode.fill,
                                controller: dataGridController,
                                columns: getColumns,
                                gridLinesVisibility: GridLinesVisibility.horizontal,
                                headerRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                                rowHeight: getIt<Functions>().getWidgetHeight(height: 63),
                                selectionMode: SelectionMode.multiple,
                                onCellTap: (details) {},
                                allowPullToRefresh: true,
                                loadMoreViewBuilder: (context, loadMoreRows) {
                                  Future<String> loadRows() async {
                                    await loadMoreRows();
                                    return Future<String>.value('Completed');
                                  }

                                  return FutureBuilder<String>(
                                      initialData: 'loading',
                                      future: loadRows(),
                                      builder: (context, snapShot) {
                                        if (snapShot.data == 'loading') {
                                          return Container(
                                              height: 60.0,
                                              width: double.infinity,
                                              decoration: const BoxDecoration(color: Color(0xffEEF4FF)),
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  const CupertinoActivityIndicator(),
                                                  Text(
                                                    snapShot.data ?? "",
                                                    style: TextStyle(color: Colors.grey.shade300),
                                                  )
                                                ],
                                              ));
                                        } else {
                                          return const SizedBox();
                                        }
                                      });
                                },
                              ),
                            ),
                          );
                        } else if (state is TripListEntryTableLoading) {
                          return SfDataGridTheme(
                            data: const SfDataGridThemeData(
                                headerColor: Colors.transparent, gridLineColor: Colors.transparent, selectionColor: Colors.transparent),
                            child: SfDataGrid(
                              source: TripListDataSource(context.read<TripListEntryBloc>().soListDummy, dataGridController, context),
                              columnWidthMode: ColumnWidthMode.fill,
                              controller: dataGridController,
                              columns: getColumns,
                              gridLinesVisibility: GridLinesVisibility.horizontal,
                              headerRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                              rowHeight: getIt<Functions>().getWidgetHeight(height: 63),
                              selectionMode: SelectionMode.multiple,
                              onCellTap: (details) {},
                              allowPullToRefresh: true,
                              loadMoreViewBuilder: (context, loadMoreRows) {
                                Future<String> loadRows() async {
                                  await loadMoreRows();
                                  return Future<String>.value('Completed');
                                }

                                return FutureBuilder<String>(
                                    initialData: 'loading',
                                    future: loadRows(),
                                    builder: (context, snapShot) {
                                      if (snapShot.data == 'loading') {
                                        return Container(
                                            height: 60.0,
                                            width: double.infinity,
                                            decoration: const BoxDecoration(color: Color(0xffEEF4FF)),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const CupertinoActivityIndicator(),
                                                Text(
                                                  snapShot.data ?? "",
                                                  style: TextStyle(color: Colors.grey.shade300),
                                                )
                                              ],
                                            ));
                                      } else {
                                        return const SizedBox();
                                      }
                                    });
                              },
                            ),
                          );
                        } else if (state is TripListEntryLoaded) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SfDataGridTheme(
                                data: const SfDataGridThemeData(
                                    headerColor: Colors.transparent, gridLineColor: Colors.transparent, selectionColor: Colors.transparent),
                                child: SfDataGrid(
                                  source: TripListDataSource(context.read<TripListEntryBloc>().searchedSoList, dataGridController, context),
                                  columnWidthMode: ColumnWidthMode.fill,
                                  controller: dataGridController,
                                  columns: getColumns,
                                  gridLinesVisibility: GridLinesVisibility.horizontal,
                                  headerRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                                  rowHeight: getIt<Functions>().getWidgetHeight(height: 63),
                                  selectionMode: SelectionMode.multiple,
                                  onCellTap: (details) {
                                    context.read<TripListEntryBloc>().searchedSoList[details.rowColumnIndex.rowIndex - 1].isSelected = true;
                                    context
                                        .read<TripListEntryBloc>()
                                        .selectedSoList
                                        .add(context.read<TripListEntryBloc>().searchedSoList[details.rowColumnIndex.rowIndex - 1]);
                                    getIt<Variables>().generalVariables.indexName = TripListDetailScreen.id;
                                    getIt<Variables>().generalVariables.tripListRouteList.add(TripListEntryScreen.id);
                                    context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                  },
                                  allowPullToRefresh: true,
                                  loadMoreViewBuilder: (context, loadMoreRows) {
                                    Future<String> loadRows() async {
                                      await loadMoreRows();
                                      return Future<String>.value('Completed');
                                    }

                                    return FutureBuilder<String>(
                                        initialData: 'loading',
                                        future: loadRows(),
                                        builder: (context, snapShot) {
                                          if (snapShot.data == 'loading') {
                                            return Container(
                                                height: 60.0,
                                                width: double.infinity,
                                                decoration: const BoxDecoration(color: Color(0xffEEF4FF)),
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    const CupertinoActivityIndicator(),
                                                    Text(
                                                      snapShot.data ?? "",
                                                      style: TextStyle(color: Colors.grey.shade300),
                                                    )
                                                  ],
                                                ));
                                          } else {
                                            return const SizedBox();
                                          }
                                        });
                                  },
                                ),
                              ),
                              context.read<TripListEntryBloc>().searchedSoList.isEmpty
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/general/no_response.svg",
                                          height: getIt<Functions>().getWidgetHeight(height: 200),
                                          width: getIt<Functions>().getWidgetWidth(width: 200),
                                          colorFilter: ColorFilter.mode(const Color(0xff007AFF).withOpacity(0.3), BlendMode.srcIn),
                                        ),
                                        Text(
                                          getIt<Variables>().generalVariables.currentLanguage.tripListIsEmpty,
                                          style: TextStyle(
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                            color: const Color(0xff282F3A),
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )
                                  : const SizedBox()
                            ],
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                BlocBuilder<TripListEntryBloc, TripListEntryState>(
                  builder: (BuildContext context, TripListEntryState state) {
                    if (state is TripListEntryLoaded) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: context.read<TripListEntryBloc>().selectedSoList.isNotEmpty ? 15 : 0),
                          ),
                          context.read<TripListEntryBloc>().selectedSoList.isNotEmpty
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xffE0E7EC),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            minimumSize:
                                                Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50))),
                                        onPressed: () {
                                          context.read<TripListEntryBloc>().isAllSelected = false;
                                          context.read<TripListEntryBloc>().selectedSoList.clear();
                                          for (int i = 0; i < context.read<TripListEntryBloc>().searchedSoList.length; i++) {
                                            context.read<TripListEntryBloc>().searchedSoList[i].isSelected = false;
                                          }
                                          context.read<TripListEntryBloc>().add(const TripListEntrySetStateEvent());
                                        },
                                        child: Text(
                                          getIt<Variables>().generalVariables.currentLanguage.cancel.toUpperCase(),
                                          style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 15), color: const Color(0xff6F6F6F)),
                                        )),
                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 15)),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xff007838),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            minimumSize:
                                                Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50))),
                                        onPressed: () {
                                          getIt<Variables>().generalVariables.indexName = TripListDetailScreen.id;
                                          getIt<Variables>().generalVariables.tripListRouteList.add(TripListEntryScreen.id);
                                          context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                        },
                                        child: Text(
                                          getIt<Variables>().generalVariables.currentLanguage.continueText.toUpperCase(),
                                          style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 15), color: const Color(0xffFFFFFF)),
                                        )),
                                  ],
                                )
                              : const SizedBox(),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: context.read<TripListEntryBloc>().selectedSoList.isNotEmpty ? 15 : 0),
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          );
        } else {
          return Container(
            color: const Color(0xffEEF4FF),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                BlocBuilder<TripListEntryBloc, TripListEntryState>(
                  builder: (BuildContext context, TripListEntryState state) {
                    return SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 194),
                      child: AppBar(
                        backgroundColor: const Color(0xffEEF4FF),
                        leading: IconButton(
                          onPressed: () {
                            getIt<Variables>().generalVariables.indexName = getIt<Variables>()
                                .generalVariables
                                .tripListRouteList[getIt<Variables>().generalVariables.tripListRouteList.length - 1];
                            context.read<NavigationBloc>().add(const NavigationInitialEvent());
                            getIt<Variables>()
                                .generalVariables
                                .tripListRouteList
                                .removeAt(getIt<Variables>().generalVariables.tripListRouteList.length - 1);
                          },
                          icon: const Icon(Icons.arrow_back, color: Color(0xffffffff)),
                        ),
                        titleSpacing: 0,
                        title: AnimatedCrossFade(
                          firstChild: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    "${getIt<Variables>().generalVariables.currentLanguage.sortingTrip} # ${getIt<Variables>().generalVariables.tripListMainIdData.tripNum}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                        color: const Color(0xffffffff)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: getIt<Functions>().getWidgetWidth(width: 7),
                              ),
                            ],
                          ),
                          secondChild: textBars(controller: searchBar),
                          crossFadeState: context.read<TripListEntryBloc>().searchBarEnabled ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 100),
                        ),
                        flexibleSpace: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: const Alignment(0.00, 1.00),
                              end: const Alignment(0, -1),
                              colors: [
                                getIt<Variables>().generalVariables.currentBackGround.bgColor1,
                                getIt<Variables>().generalVariables.currentBackGround.bgColor2
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 34),
                            width: getIt<Functions>().getWidgetWidth(width: 34),
                            child: PageView.builder(
                              controller: PageController(),
                              scrollDirection: Axis.vertical,
                              allowImplicitScrolling: true,
                              onPageChanged: state is TripListEntryLoading || state is TripListEntryTableLoading
                                  ? (value) {}
                                  : (value) {
                                      getIt<Variables>().generalVariables.currentBackGround =
                                          getIt<Variables>().generalVariables.backGroundChangesList[value];
                                      context.read<TripListEntryBloc>().currentListIndex = value;
                                      context.read<TripListEntryBloc>().add(const TripListEntryFilterEvent());
                                    },
                              itemCount: getIt<Variables>().generalVariables.backGroundChangesList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    height: getIt<Functions>().getWidgetHeight(height: 34),
                                    width: getIt<Functions>().getWidgetWidth(width: 34),
                                    margin: const EdgeInsets.symmetric(vertical: 2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: getIt<Variables>().generalVariables.backGroundChangesList[index].color,
                                        border: Border.all(color: Colors.white, width: 1)),
                                    child: Center(
                                        child: Text(getIt<Variables>().generalVariables.backGroundChangesList[index].symbol,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                color: Colors.white))));
                              },
                            ),
                          ),
                          SizedBox(
                            width: getIt<Functions>().getWidgetWidth(width: 10),
                          ),
                          InkWell(
                            onTap: state is TripListEntryLoading || state is TripListEntryTableLoading
                                ? () {}
                                : () {
                                    context.read<TripListEntryBloc>().searchBarEnabled = !context.read<TripListEntryBloc>().searchBarEnabled;
                                    if (!context.read<TripListEntryBloc>().searchBarEnabled) {
                                      searchBar.clear();
                                      FocusManager.instance.primaryFocus!.unfocus();
                                      context.read<TripListEntryBloc>().searchText = "";
                                    }
                                    context.read<TripListEntryBloc>().add(const TripListEntryFilterEvent());
                                  },
                            child: Container(
                              height: getIt<Functions>().getWidgetHeight(height: 34),
                              width: getIt<Functions>().getWidgetWidth(width: 34),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFFFFFFF).withOpacity(0.2)),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/warehouse_list/search_icon.svg',
                                  height: getIt<Functions>().getWidgetHeight(height: 15),
                                  width: getIt<Functions>().getWidgetWidth(width: 15),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: getIt<Functions>().getWidgetWidth(width: 10),
                          ),
                          InkWell(
                            onTap: state is TripListEntryLoading || state is TripListEntryTableLoading
                                ? () {}
                                : () {
                                    getIt<Variables>().generalVariables.filterSelectedMainIndex = 0;
                                    Scaffold.of(context).openEndDrawer();
                                  },
                            child: Badge(
                              backgroundColor: const Color(0xff007AFF),
                              smallSize: getIt<Variables>().generalVariables.selectedFilters.isEmpty ? 0 : 8,
                              child: Container(
                                height: getIt<Functions>().getWidgetHeight(height: 34),
                                width: getIt<Functions>().getWidgetWidth(width: 34),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFFFFFFF).withOpacity(0.2)),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/warehouse_list/filter_icon.svg',
                                    height: getIt<Functions>().getWidgetHeight(height: 17.30),
                                    width: getIt<Functions>().getWidgetWidth(width: 17.30),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: getIt<Functions>().getWidgetWidth(width: 10),
                          ),
                        ],
                        bottom: PreferredSize(
                          preferredSize: Size(
                              getIt<Functions>().getWidgetWidth(
                                  width: Orientation.portrait == MediaQuery.of(context).orientation
                                      ? getIt<Variables>().generalVariables.width
                                      : getIt<Variables>().generalVariables.height),
                              getIt<Functions>().getWidgetHeight(height: 104)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: getIt<Functions>().getWidgetHeight(height: 45),
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        onTap: getIt<Variables>().generalVariables.isNetworkOffline
                                            ? () {}
                                            : () {
                                                getIt<Variables>().generalVariables.isStatusDrawer = true;
                                                Scaffold.of(context).openEndDrawer();
                                              },
                                        child: Center(
                                          child: SvgPicture.asset(
                                            "assets/pick_list/status_image.svg",
                                            height: getIt<Functions>().getWidgetHeight(height: 20),
                                            width: getIt<Functions>().getWidgetWidth(width: 20),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      const VerticalDivider(color: Colors.white, width: 25),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        onTap: getIt<Variables>().generalVariables.isNetworkOffline
                                            ? () {}
                                            : () {
                                                getIt<Variables>().generalVariables.isStatusDrawer = true;
                                                Scaffold.of(context).openEndDrawer();
                                              },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              getIt<Variables>().generalVariables.currentLanguage.status.toUpperCase(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                  color: const Color(0xffffffff)),
                                            ),
                                            Text(
                                              getIt<Variables>().generalVariables.tripListMainIdData.tripStatus == "Pending"
                                                  ? getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase()
                                                  : getIt<Variables>().generalVariables.tripListMainIdData.tripStatus == "Partial"
                                                      ? getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase()
                                                      : getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                  color: const Color(0xffF8B11D)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const VerticalDivider(color: Colors.white, width: 25),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.route.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xffffffff)),
                                          ),
                                          Text(
                                            getIt<Variables>().generalVariables.tripListMainIdData.tripRoute,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: getIt<Variables>().generalVariables.currentBackGround.fontColor),
                                          ),
                                        ],
                                      ),
                                      const VerticalDivider(color: Colors.white, width: 25),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.createdTime.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xffffffff)),
                                          ),
                                          Text(
                                            getIt<Variables>().generalVariables.tripListMainIdData.tripCreatedTime,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: getIt<Variables>().generalVariables.currentBackGround.fontColor),
                                          ),
                                        ],
                                      ),
                                      const VerticalDivider(color: Colors.white, width: 25),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.total.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xffffffff)),
                                          ),
                                          Text(
                                            "${getIt<Variables>().generalVariables.tripListMainIdData.tripOrders} Orders",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: getIt<Variables>().generalVariables.currentBackGround.fontColor),
                                          ),
                                        ],
                                      ),
                                      const VerticalDivider(color: Colors.white, width: 25),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.totalStops.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xffffffff)),
                                          ),
                                          Text(
                                            "# ${getIt<Variables>().generalVariables.tripListMainIdData.tripStops}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: getIt<Variables>().generalVariables.currentBackGround.fontColor),
                                          ),
                                        ],
                                      ),
                                      const VerticalDivider(color: Colors.white, width: 25),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.loadingBay.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xffffffff)),
                                          ),
                                          Text(
                                            "${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayDryName} / ${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayFrozenName}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: getIt<Variables>().generalVariables.currentBackGround.fontColor),
                                          ),
                                        ],
                                      ),
                                      const VerticalDivider(color: Colors.white, width: 25),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.vehicleNo.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xffffffff)),
                                          ),
                                          Text(
                                            getIt<Variables>().generalVariables.tripListMainIdData.tripVehicle,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: getIt<Variables>().generalVariables.currentBackGround.fontColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 30)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: getIt<Functions>().getWidgetWidth(width: 15),
                        right: getIt<Functions>().getWidgetWidth(width: 15),
                        top: getIt<Functions>().getWidgetHeight(height: 20)),
                    child: BlocConsumer<TripListEntryBloc, TripListEntryState>(
                      listenWhen: (TripListEntryState previous, TripListEntryState current) {
                        return previous != current;
                      },
                      buildWhen: (TripListEntryState previous, TripListEntryState current) {
                        return previous != current;
                      },
                      listener: (BuildContext context, TripListEntryState state) {},
                      builder: (BuildContext context, TripListEntryState state) {
                        if (state is TripListEntryLoading) {
                          return Skeletonizer(
                            enabled: true,
                            child: SfDataGridTheme(
                              data: const SfDataGridThemeData(
                                  headerColor: Colors.transparent, gridLineColor: Colors.transparent, selectionColor: Colors.transparent),
                              child: SfDataGrid(
                                source: TripListDataSource(context.read<TripListEntryBloc>().soListDummy, dataGridController, context),
                                columnWidthMode: ColumnWidthMode.fill,
                                controller: dataGridController,
                                columns: getColumns,
                                gridLinesVisibility: GridLinesVisibility.horizontal,
                                headerRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                                rowHeight: getIt<Functions>().getWidgetHeight(height: 63),
                                selectionMode: SelectionMode.multiple,
                                onCellTap: (details) {},
                                allowPullToRefresh: true,
                                loadMoreViewBuilder: (context, loadMoreRows) {
                                  Future<String> loadRows() async {
                                    await loadMoreRows();
                                    return Future<String>.value('Completed');
                                  }

                                  return FutureBuilder<String>(
                                      initialData: 'loading',
                                      future: loadRows(),
                                      builder: (context, snapShot) {
                                        if (snapShot.data == 'loading') {
                                          return Container(
                                              height: 60.0,
                                              width: double.infinity,
                                              decoration: const BoxDecoration(color: Color(0xffEEF4FF)),
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  const CupertinoActivityIndicator(),
                                                  Text(
                                                    snapShot.data ?? "",
                                                    style: TextStyle(color: Colors.grey.shade300),
                                                  )
                                                ],
                                              ));
                                        } else {
                                          return const SizedBox();
                                        }
                                      });
                                },
                              ),
                            ),
                          );
                        } else if (state is TripListEntryTableLoading) {
                          return SfDataGridTheme(
                            data: const SfDataGridThemeData(
                                headerColor: Colors.transparent, gridLineColor: Colors.transparent, selectionColor: Colors.transparent),
                            child: SfDataGrid(
                              source: TripListDataSource(context.read<TripListEntryBloc>().soListDummy, dataGridController, context),
                              columnWidthMode: ColumnWidthMode.fill,
                              controller: dataGridController,
                              columns: getColumns,
                              gridLinesVisibility: GridLinesVisibility.horizontal,
                              headerRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                              rowHeight: getIt<Functions>().getWidgetHeight(height: 63),
                              selectionMode: SelectionMode.multiple,
                              onCellTap: (details) {},
                              allowPullToRefresh: true,
                              loadMoreViewBuilder: (context, loadMoreRows) {
                                Future<String> loadRows() async {
                                  await loadMoreRows();
                                  return Future<String>.value('Completed');
                                }

                                return FutureBuilder<String>(
                                    initialData: 'loading',
                                    future: loadRows(),
                                    builder: (context, snapShot) {
                                      if (snapShot.data == 'loading') {
                                        return Container(
                                            height: 60.0,
                                            width: double.infinity,
                                            decoration: const BoxDecoration(color: Color(0xffEEF4FF)),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const CupertinoActivityIndicator(),
                                                Text(
                                                  snapShot.data ?? "",
                                                  style: TextStyle(color: Colors.grey.shade300),
                                                )
                                              ],
                                            ));
                                      } else {
                                        return const SizedBox();
                                      }
                                    });
                              },
                            ),
                          );
                        } else if (state is TripListEntryLoaded) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SfDataGridTheme(
                                data: const SfDataGridThemeData(
                                    headerColor: Colors.transparent, gridLineColor: Colors.transparent, selectionColor: Colors.transparent),
                                child: SfDataGrid(
                                  source: TripListDataSource(context.read<TripListEntryBloc>().searchedSoList, dataGridController, context),
                                  columnWidthMode: ColumnWidthMode.auto,
                                  columnSizer: CustomColumnSizer(),
                                  controller: dataGridController,
                                  columns: getColumns,
                                  gridLinesVisibility: GridLinesVisibility.horizontal,
                                  headerRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                                  rowHeight: getIt<Functions>().getWidgetHeight(height: 63),
                                  selectionMode: SelectionMode.multiple,
                                  allowPullToRefresh: true,
                                  onCellTap: (details) {
                                    context.read<TripListEntryBloc>().searchedSoList[details.rowColumnIndex.rowIndex - 1].isSelected = true;
                                    context
                                        .read<TripListEntryBloc>()
                                        .selectedSoList
                                        .add(context.read<TripListEntryBloc>().searchedSoList[details.rowColumnIndex.rowIndex - 1]);
                                    getIt<Variables>().generalVariables.indexName = TripListDetailScreen.id;
                                    getIt<Variables>().generalVariables.tripListRouteList.add(TripListEntryScreen.id);
                                    context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                  },
                                  loadMoreViewBuilder: (context, loadMoreRows) {
                                    Future<String> loadRows() async {
                                      await loadMoreRows();
                                      return Future<String>.value('Completed');
                                    }

                                    return FutureBuilder<String>(
                                        initialData: 'loading',
                                        future: loadRows(),
                                        builder: (context, snapShot) {
                                          if (snapShot.data == 'loading') {
                                            return Container(
                                                height: 60.0,
                                                width: double.infinity,
                                                decoration: const BoxDecoration(color: Color(0xffEEF4FF)),
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    const CupertinoActivityIndicator(),
                                                    Text(
                                                      snapShot.data ?? "",
                                                      style: TextStyle(color: Colors.grey.shade300),
                                                    )
                                                  ],
                                                ));
                                          } else {
                                            return const SizedBox();
                                          }
                                        });
                                  },
                                ),
                              ),
                              context.read<TripListEntryBloc>().searchedSoList.isEmpty
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/general/no_response.svg",
                                          height: getIt<Functions>().getWidgetHeight(height: 200),
                                          width: getIt<Functions>().getWidgetWidth(width: 200),
                                          colorFilter: ColorFilter.mode(const Color(0xff007AFF).withOpacity(0.3), BlendMode.srcIn),
                                        ),
                                        Text(
                                          getIt<Variables>().generalVariables.currentLanguage.tripListIsEmpty,
                                          style: TextStyle(
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                            color: const Color(0xff282F3A),
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )
                                  : const SizedBox()
                            ],
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                BlocBuilder<TripListEntryBloc, TripListEntryState>(builder: (BuildContext context, TripListEntryState state) {
                  if (state is TripListEntryLoaded) {
                    return Column(
                      children: [
                        context.read<TripListEntryBloc>().selectedSoList.isNotEmpty
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xffE0E7EC),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          minimumSize:
                                              Size(getIt<Functions>().getWidgetWidth(width: 150), getIt<Functions>().getWidgetHeight(height: 35))),
                                      onPressed: () {
                                        context.read<TripListEntryBloc>().isAllSelected = false;
                                        context.read<TripListEntryBloc>().selectedSoList.clear();
                                        for (int i = 0; i < context.read<TripListEntryBloc>().searchedSoList.length; i++) {
                                          context.read<TripListEntryBloc>().searchedSoList[i].isSelected = false;
                                        }
                                        context.read<TripListEntryBloc>().add(const TripListEntrySetStateEvent());
                                      },
                                      child: Text(
                                        getIt<Variables>().generalVariables.currentLanguage.cancel.toUpperCase(),
                                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 15), color: const Color(0xff6F6F6F)),
                                      )),
                                  SizedBox(width: getIt<Functions>().getWidgetWidth(width: 15)),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xff007838),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          minimumSize:
                                              Size(getIt<Functions>().getWidgetWidth(width: 150), getIt<Functions>().getWidgetHeight(height: 35))),
                                      onPressed: () {
                                        getIt<Variables>().generalVariables.indexName = TripListDetailScreen.id;
                                        getIt<Variables>().generalVariables.tripListRouteList.add(TripListEntryScreen.id);
                                        context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                      },
                                      child: Text(
                                        getIt<Variables>().generalVariables.currentLanguage.continueText.toUpperCase(),
                                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 15), color: const Color(0xffFFFFFF)),
                                      )),
                                ],
                              )
                            : const SizedBox(),
                        SizedBox(
                          height: getIt<Functions>().getWidgetHeight(height: context.read<TripListEntryBloc>().selectedSoList.isNotEmpty ? 15 : 0),
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget textBars({required TextEditingController controller}) {
    return BlocBuilder<TripListEntryBloc, TripListEntryState>(
      builder: (BuildContext context, TripListEntryState tripList) {
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
                    context.read<TripListEntryBloc>().add(const TripListEntrySetStateEvent());
                    if (timer?.isActive ?? false) timer?.cancel();
                    timer = Timer(const Duration(milliseconds: 500), () {
                      if (value.isNotEmpty) {
                        context.read<TripListEntryBloc>().searchText = value;
                        context.read<TripListEntryBloc>().add(const TripListEntryFilterEvent());
                      } else {
                        FocusManager.instance.primaryFocus!.unfocus();
                        context.read<TripListEntryBloc>().searchText = "";
                        context.read<TripListEntryBloc>().add(const TripListEntryFilterEvent());
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
                                context.read<TripListEntryBloc>().searchText = "";
                                context.read<TripListEntryBloc>().add(const TripListEntryFilterEvent());
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
}

class TripListDataSource extends DataGridSource {
  TripListDataSource(List<SoList> tripList, this.dataGridController, this.context) {
    buildDataGridRows(tripList);
  }

  List<DataGridRow> dataGridRows = [];

  DataGridController dataGridController;
  BuildContext context;

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRows(List<SoList> tripList) {
    dataGridRows = tripList
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell(columnName: 'SalesOrder', value: e),
              DataGridCell(columnName: 'Status', value: [e.soStatus]),
              DataGridCell(columnName: 'NoOfItems', value: ['${e.soNoOfSortedItems}/${e.soNoOfItems}']),
              DataGridCell(columnName: 'Type', value: [e.soType]),
              DataGridCell(columnName: 'Stop', value: [e.soStops]),
              DataGridCell(columnName: 'Handled', value: e.soHandledBy),
            ]))
        .toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      if (e.columnName == 'SalesOrder') {
        SoList dataValue = e.value;
        return BlocBuilder<TripListEntryBloc, TripListEntryState>(
          builder: (BuildContext context, TripListEntryState state) {
            return Skeletonizer(
              enabled: state is TripListEntryTableLoading || state is TripListEntryLoading,
              child: Container(
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffE0E7EC)))),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Skeleton.shade(
                      child: Checkbox(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          activeColor: const Color(0xff007838),
                          checkColor: const Color(0xffffffff),
                          value: dataValue.isSelected,
                          onChanged: (value) {
                            if (value!) {
                              dataValue.isSelected = true;
                              context.read<TripListEntryBloc>().selectedSoList.add(dataValue);
                              context.read<TripListEntryBloc>().add(const TripListEntrySetStateEvent());
                            } else {
                              dataValue.isSelected = false;
                              int index = context.read<TripListEntryBloc>().selectedSoList.indexWhere((e) => e.soNum == dataValue.soNum);
                              context.read<TripListEntryBloc>().selectedSoList.removeAt(index);
                              context.read<TripListEntryBloc>().add(const TripListEntrySetStateEvent());
                            }
                            if (context.read<TripListEntryBloc>().selectedSoList.length == context.read<TripListEntryBloc>().searchedSoList.length) {
                              context.read<TripListEntryBloc>().isAllSelected = true;
                            } else {
                              context.read<TripListEntryBloc>().isAllSelected = false;
                            }
                          }),
                    ),
                    SizedBox(
                      width: getIt<Functions>().getWidgetWidth(width: 5),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                dataValue.isSelected = true;
                                context.read<TripListEntryBloc>().selectedSoList.add(dataValue);
                                getIt<Variables>().generalVariables.indexName = TripListDetailScreen.id;
                                getIt<Variables>().generalVariables.tripListRouteList.add(TripListEntryScreen.id);
                                context.read<NavigationBloc>().add(const NavigationInitialEvent());
                              },
                              child: Text(
                                '${getIt<Variables>().generalVariables.currentLanguage.so.toUpperCase()} # : ${dataValue.soNum}',
                                style: TextStyle(
                                    color: const Color(0xff282F3A),
                                    fontWeight: FontWeight.w600,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 16 : 13),
                                    fontFamily: "Figtree"),
                              ),
                            ),
                            SizedBox(width: getIt<Functions>().getWidgetWidth(width: 5)),
                            InkWell(
                              onTap: () {
                                getIt<Variables>().generalVariables.popUpWidget = soContent(
                                    deliveryInstruction: dataValue.soDeliveryInstruction,
                                    soNumber: dataValue.soNum,
                                    noOfItems: dataValue.soNoOfItems,
                                    place: dataValue.soCustomerName);
                                getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                              },
                              child: Skeleton.shade(
                                child: SvgPicture.asset('assets/trip_list/about.svg',
                                    height: getIt<Functions>().getWidgetHeight(height: 12), width: getIt<Functions>().getWidgetWidth(width: 12)),
                              ),
                            ),
                            SizedBox(width: getIt<Functions>().getWidgetWidth(width: 5)),
                            dataValue.disputeStatus
                                ? Skeleton.shade(
                                    child: SvgPicture.asset('assets/trip_list/dispute.svg',
                                        height: getIt<Functions>().getWidgetHeight(height: 12), width: getIt<Functions>().getWidgetWidth(width: 12)),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            dataValue.isSelected = true;
                            context.read<TripListEntryBloc>().selectedSoList.add(dataValue);
                            getIt<Variables>().generalVariables.indexName = TripListDetailScreen.id;
                            getIt<Variables>().generalVariables.tripListRouteList.add(TripListEntryScreen.id);
                            context.read<NavigationBloc>().add(const NavigationInitialEvent());
                          },
                          child: SizedBox(
                            width: getIt<Functions>().getWidgetWidth(width: 200),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                dataValue.soCustomerName,
                                style: TextStyle(
                                    color: const Color(0xff8A8D8E),
                                    fontWeight: FontWeight.w500,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                    fontFamily: "Figtree"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      if (e.columnName == 'Handled') {
        List<HandledByForUpdateList> dataValue = e.value;
        return BlocBuilder<TripListEntryBloc, TripListEntryState>(builder: (BuildContext context, TripListEntryState state) {
          List<String> images = List.generate(dataValue.length, (i) => dataValue[i].image);
          return Skeletonizer(
            enabled: state is TripListEntryTableLoading || state is TripListEntryLoading,
            child: Skeleton.shade(
              child: images.isEmpty
                  ? Center(
                      child: Text("-",
                          style: TextStyle(
                              color: const Color(0xff282F3A),
                              fontWeight: FontWeight.w500,
                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                              fontFamily: "Figtree")),
                    )
                  : InkWell(
                      onTap: () {
                        if (dataValue.isNotEmpty) {
                          getIt<Variables>().generalVariables.popUpWidget = usersDetailsContent(handled: dataValue);
                          getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                        }
                      },
                      child: ImageStack(
                        imageList: images,
                        imageSource: getIt<Variables>().generalVariables.isNetworkOffline ? ImageSourceStack.offline : ImageSourceStack.network,
                        totalCount: images.length,
                        imageRadius: 30,
                        imageCount: 3,
                        imageBorderWidth: 0.5,
                        backgroundColor: Colors.white,
                        extraCountTextStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
            ),
          );
        });
      }
      if (e.columnName == 'Stop') {
        return BlocBuilder<TripListEntryBloc, TripListEntryState>(builder: (BuildContext context, TripListEntryState state) {
          return Skeletonizer(
            enabled: state is TripListEntryTableLoading || state is TripListEntryLoading,
            child: Skeleton.shade(
              child: Container(
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffE0E7EC)))),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: getIt<Functions>().getWidgetWidth(width: 6.5), vertical: getIt<Functions>().getWidgetHeight(height: 4.5)),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: const Color(0xff29B473)),
                    child: Text(
                      num.parse(e.value[0].toString()) > 9 ? e.value[0].toString() : "0${e.value[0]}",
                      style: TextStyle(
                          color: const Color(0xffFFFFFF),
                          fontWeight: FontWeight.w600,
                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                          fontFamily: "Figtree"),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      }
      if (e.columnName == 'Status') {
        return BlocBuilder<TripListEntryBloc, TripListEntryState>(builder: (BuildContext context, TripListEntryState state) {
          return Skeletonizer(
            enabled: state is TripListEntryTableLoading || state is TripListEntryLoading,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffE0E7EC)))),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  e.value[0] == "Pending"
                      ? getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase()
                      : getIt<Variables>().generalVariables.currentLanguage.sorted.toUpperCase(),
                  style: TextStyle(
                      color: const Color(0xff282F3A),
                      fontWeight: FontWeight.w600,
                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                      fontFamily: "Figtree"),
                ),
              ),
            ),
          );
        });
      }
      if (e.columnName == 'Type') {
        return BlocBuilder<TripListEntryBloc, TripListEntryState>(builder: (BuildContext context, TripListEntryState state) {
          return Skeletonizer(
            enabled: state is TripListEntryTableLoading || state is TripListEntryLoading,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffE0E7EC)))),
              child: Text(
                e.value[0],
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: const Color(0xff282F3A),
                    fontWeight: FontWeight.w600,
                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                    fontFamily: "Figtree"),
              ),
            ),
          );
        });
      } else {
        return BlocBuilder<TripListEntryBloc, TripListEntryState>(builder: (BuildContext context, TripListEntryState state) {
          return Skeletonizer(
            enabled: state is TripListEntryTableLoading || state is TripListEntryLoading,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffE0E7EC)))),
              child: Text(
                e.value[0],
                style: TextStyle(
                    color: const Color(0xff282F3A),
                    fontWeight: FontWeight.w600,
                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                    fontFamily: "Figtree"),
              ),
            ),
          );
        });
      }
    }).toList());
  }

  Widget usersDetailsContent({required List<HandledByForUpdateList> handled}) {
    return BlocConsumer<TripListEntryBloc, TripListEntryState>(
      listenWhen: (TripListEntryState previous, TripListEntryState current) {
        return previous != current;
      },
      buildWhen: (TripListEntryState previous, TripListEntryState current) {
        return previous != current;
      },
      listener: (BuildContext context, TripListEntryState state) {},
      builder: (BuildContext context, TripListEntryState state) {
        return SizedBox(
          height: getIt<Functions>().getWidgetHeight(height: 500),
          width: getIt<Functions>().getWidgetWidth(width: 420),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: getIt<Functions>().getWidgetHeight(height: 44),
                      width: getIt<Functions>().getWidgetHeight(height: 44),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage("assets/pick_list/store_keep.png"),
                            fit: BoxFit.fill,
                          )),
                    ),
                    SizedBox(
                      width: getIt<Functions>().getWidgetWidth(width: 10),
                    ),
                    Text(
                      getIt<Variables>().generalVariables.currentLanguage.storeKeeper,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 18), color: const Color(0xff282F3A)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: getIt<Functions>().getWidgetHeight(height: 20),
              ),
              const Divider(
                height: 0,
                thickness: 1,
                color: Color(0xffE0E7EC),
              ),
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.only(
                        left: getIt<Functions>().getWidgetWidth(width: 20),
                        right: getIt<Functions>().getWidgetWidth(width: 20),
                        top: getIt<Functions>().getWidgetHeight(height: 20)),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: handled.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: getIt<Functions>().getWidgetHeight(height: 60),
                        margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: getIt<Functions>().getWidgetHeight(height: 50),
                              width: getIt<Functions>().getWidgetHeight(height: 50),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(handled[index].image),
                                    fit: BoxFit.fill,
                                  )),
                            ),
                            SizedBox(
                              width: getIt<Functions>().getWidgetWidth(width: 10),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        handled[index].name.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 15),
                                            color: const Color(0xff282F3A)),
                                      ),
                                      Text(
                                        handled[index].updatedItems,
                                        style: TextStyle(
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xff007838)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Emp code:${handled[index].code}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                            color: const Color(0xff8A8D8E)),
                                      ),
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.sortedItem.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xff282F3A)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              InkWell(
                onTap: () {
                  FocusManager.instance.primaryFocus!.unfocus();
                  Navigator.pop(context);
                },
                child: Container(
                  height: getIt<Functions>().getWidgetHeight(height: 50),
                  decoration: const BoxDecoration(
                    color: Color(0xffEEF4FF),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                  ),
                  child: Center(
                    child: Text(
                      getIt<Variables>().generalVariables.currentLanguage.close.toUpperCase(),
                      style: TextStyle(
                          color: const Color(0xff1D2736), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
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

  void updateDataGrid() {
    notifyListeners();
  }

  @override
  Future<void> handleRefresh() async {
    context.read<TripListEntryBloc>().isAllSelected =
        context.read<TripListEntryBloc>().selectedSoList.length == context.read<TripListEntryBloc>().searchedSoList.length;
    context.read<TripListEntryBloc>().add(const TripListEntrySetStateEvent());
  }

  @override
  Future<void> handleLoadMoreRows() async {
    context.read<TripListEntryBloc>().isAllSelected =
        context.read<TripListEntryBloc>().selectedSoList.length == context.read<TripListEntryBloc>().searchedSoList.length;
    context.read<TripListEntryBloc>().add(const TripListEntrySetStateEvent());
  }

  Widget soContent({required String deliveryInstruction, required String soNumber, required String noOfItems, required String place}) {
    return BlocConsumer<TripListEntryBloc, TripListEntryState>(
      listenWhen: (TripListEntryState previous, TripListEntryState current) {
        return previous != current;
      },
      buildWhen: (TripListEntryState previous, TripListEntryState current) {
        return previous != current;
      },
      listener: (BuildContext context, TripListEntryState state) {},
      builder: (BuildContext context, TripListEntryState state) {
        return SizedBox(
          height: getIt<Functions>().getWidgetHeight(height: 368),
          width: getIt<Functions>().getWidgetWidth(width: 612),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                height: getIt<Functions>().getWidgetHeight(height: 50),
                width: getIt<Functions>().getWidgetWidth(width: 50),
                padding: EdgeInsets.symmetric(
                    vertical: getIt<Functions>().getWidgetHeight(height: 10.72), horizontal: getIt<Functions>().getWidgetWidth(width: 10.72)),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff8944AB),
                ),
                child: Image.asset('assets/trip_list/box.png'),
              ),
              SizedBox(
                height: getIt<Functions>().getWidgetHeight(height: 17),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                child: Text(
                  "${getIt<Variables>().generalVariables.currentLanguage.so.toUpperCase()} # : $soNumber",
                  style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 20), color: const Color(0xff282F3A)),
                ),
              ),
              SizedBox(
                height: getIt<Functions>().getWidgetHeight(height: 7),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                child: Text(
                  "${getIt<Variables>().generalVariables.currentLanguage.numberOfItems} : $noOfItems",
                  style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 15), color: const Color(0xff8A8D8E)),
                ),
              ),
              SizedBox(
                height: getIt<Functions>().getWidgetHeight(height: 7),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                child: Text(
                  place,
                  style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 15), color: const Color(0xff007AFF)),
                ),
              ),
              SizedBox(
                height: getIt<Functions>().getWidgetHeight(height: 7),
              ),
              const Expanded(
                child: Divider(
                  thickness: 1,
                  color: Color(0xffE0E7EC),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                  child: Text(
                    getIt<Variables>().generalVariables.currentLanguage.deliveryInstruction.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: const Color(0xff8A8D8E)),
                  ),
                ),
              ),
              SizedBox(
                height: getIt<Functions>().getWidgetHeight(height: 7),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                child: Text(
                  deliveryInstruction,
                  style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff282F3A)),
                  textAlign: TextAlign.start,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  FocusManager.instance.primaryFocus!.unfocus();
                  Navigator.pop(context);
                },
                child: Container(
                  height: getIt<Functions>().getWidgetHeight(height: 50),
                  decoration: const BoxDecoration(
                    color: Color(0xffE0E7EC),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                  ),
                  child: Center(
                    child: Text(
                      getIt<Variables>().generalVariables.currentLanguage.close.toUpperCase(),
                      style: TextStyle(
                          color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
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

class CustomColumnSizer extends ColumnSizer {
  @override
  double computeCellWidth(GridColumn column, DataGridRow row, Object? cellValue, TextStyle textStyle) {
    dynamic valueData;
    if (column.columnName == "SalesOrder") {
      valueData = "123456789012345678901234567890";
    } else if (column.columnName == "Handled") {
      valueData = "1234567890";
    } else {
      valueData = "123456";
    }
    return getIt<Functions>().getWidgetWidth(width: super.computeCellWidth(column, row, valueData, textStyle));
  }
}
