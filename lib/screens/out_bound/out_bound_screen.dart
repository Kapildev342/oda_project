// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// Project imports:
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/bloc/out_bound/out_bound_main/out_bound_bloc.dart';
import 'package:oda/edited_packages/image_stack_library.dart';
import 'package:oda/local_database/trip_box/trip_list.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/screens/home/home_screen.dart';
import 'package:oda/screens/out_bound/out_bound_entry_screen.dart';

class OutBoundScreen extends StatefulWidget {
  static const String id = "out_bound_screen";
  const OutBoundScreen({super.key});

  @override
  State<OutBoundScreen> createState() => _OutBoundScreenState();
}

class _OutBoundScreenState extends State<OutBoundScreen> {
  TextEditingController searchBar = TextEditingController();
  Timer? timer;
  DataGridController dataGridController = DataGridController();

  @override
  void initState() {
    context.read<OutBoundBloc>().tripListDummy = [
      TripList(
          tripId: "1234",
          tripNum: "12345",
          tripVehicle: "1234",
          tripRoute: "1234",
          tripStops: "02",
          tripCreatedTime: "12/01/2025 03:15 PM",
          tripOrders: "100",
          tripHandledBy: [],
          tripStatus: 'Pending',
          tripLoadingBayDry: '1',
          tripLoadingBayFrozen: "A",
          tripStatusColor: 'DC474A',
          tripStatusBackGroundColor: 'FFCCCF',
          tripItemType: 'B',
          unavailableReasons: [],
          sessionInfo: SessionInfo.fromJson({}),
          partialItemsList: [],
          tripLoadingBayDryName: '',
          tripLoadingBayFrozenName: '',
          businessDate: '',
          deliveryArea: '',
          isSessionOpened: false,
          sessionId: '',
          sessionTimeStamp: '',
          sessionEventType: '')
    ];
    context.read<OutBoundBloc>().add(const OutBoundInitialEvent(isInitial: true));
    getIt<Variables>().generalVariables.currentBackGround = getIt<Variables>().generalVariables.backGroundChangesList[0];
    super.initState();
  }

  List<GridColumn> get getColumns {
    return <GridColumn>[
      GridColumn(
        columnName: 'tripId',
        label: Container(
            padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 18)),
            decoration: BoxDecoration(
              color: const Color(0xffE0E7EC),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(getIt<Variables>().generalVariables.isDeviceTablet ? 4 : 4),
                  topLeft: Radius.circular(getIt<Variables>().generalVariables.isDeviceTablet ? 4 : 4)),
            ),
            alignment: Alignment.centerLeft,
            child: Text(getIt<Variables>().generalVariables.currentLanguage.tripId,
                style: TextStyle(
                    color: const Color(0xff282F3A),
                    fontWeight: FontWeight.w700,
                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                    fontFamily: "Figtree"))),
      ),
      GridColumn(
          columnName: 'route',
          label: Container(
              decoration: const BoxDecoration(color: Color(0xffE0E7EC)),
              alignment: Alignment.center,
              child: Text(
                getIt<Variables>().generalVariables.currentLanguage.route,
                style: TextStyle(
                    fontFamily: "Figtree",
                    color: const Color(0xff282F3A),
                    fontWeight: FontWeight.w700,
                    fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
              ))),
      GridColumn(
          columnName: 'createdTime',
          label: Container(
              decoration: const BoxDecoration(color: Color(0xffE0E7EC)),
              alignment: Alignment.center,
              child: Text(
                getIt<Variables>().generalVariables.currentLanguage.createdTime,
                style: TextStyle(
                    fontFamily: "Figtree",
                    color: const Color(0xff282F3A),
                    fontWeight: FontWeight.w700,
                    fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
              ))),
      GridColumn(
          columnName: 'orders',
          label: Container(
              decoration: const BoxDecoration(color: Color(0xffE0E7EC)),
              alignment: Alignment.center,
              child: Text(
                getIt<Variables>().generalVariables.currentLanguage.orders,
                style: TextStyle(
                    fontFamily: "Figtree",
                    color: const Color(0xff282F3A),
                    fontWeight: FontWeight.w700,
                    fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
              ))),
      GridColumn(
          columnName: 'handled',
          label: Container(
              decoration: const BoxDecoration(color: Color(0xffE0E7EC)),
              alignment: Alignment.center,
              child: Text(
                getIt<Variables>().generalVariables.currentLanguage.handled,
                style: TextStyle(
                    fontFamily: "Figtree",
                    color: const Color(0xff282F3A),
                    fontWeight: FontWeight.w700,
                    fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
              ))),
      GridColumn(
          columnName: 'status',
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
          columnName: 'loadingBay',
          label: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(getIt<Variables>().generalVariables.isDeviceTablet ? 4 : 4),
                      bottomRight: Radius.circular(getIt<Variables>().generalVariables.isDeviceTablet ? 4 : 4)),
                  color: const Color(0xffE0E7EC)),
              alignment: Alignment.center,
              child: Text(
                getIt<Variables>().generalVariables.currentLanguage.loadingBay,
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
          context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 0));
          getIt<Variables>().generalVariables.indexName = HomeScreen.id;
          context.read<NavigationBloc>().add(const NavigationInitialEvent());
        }
      },
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 480) {
          return Container(
            color: const Color(0xffEEF4FF),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                BlocBuilder<OutBoundBloc, OutBoundState>(
                  builder: (BuildContext context, OutBoundState tripList) {
                    return SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 117),
                      child: AppBar(
                        backgroundColor: const Color(0xffEEF4FF),
                        leading: IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: const Icon(Icons.menu, color: Color(0xffffffff)),
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
                                  getIt<Variables>().generalVariables.currentLanguage.outBoundTripLists,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: getIt<Functions>().getTextSize(fontSize: 26),
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
                          SizedBox(
                            width: getIt<Functions>().getWidgetWidth(width: 14),
                          ),
                          AnimatedCrossFade(
                            firstChild: const SizedBox(),
                            secondChild: textBars(controller: searchBar),
                            crossFadeState: context.read<OutBoundBloc>().searchBarEnabled ? CrossFadeState.showSecond : CrossFadeState.showFirst,
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
                                  onTap: tripList is OutBoundLoading || tripList is OutBoundTableLoading
                                      ? () {}
                                      : () {
                                          getIt<Variables>().generalVariables.currentBackGround =
                                              getIt<Variables>().generalVariables.backGroundChangesList[0];
                                          context.read<OutBoundBloc>().currentListIndex = 0;
                                          context.read<OutBoundBloc>().add(const OutBoundFilterEvent());
                                        },
                                  child: context.read<OutBoundBloc>().currentListIndex == 0
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
                                  onTap: tripList is OutBoundLoading || tripList is OutBoundTableLoading
                                      ? () {}
                                      : () {
                                          getIt<Variables>().generalVariables.currentBackGround =
                                              getIt<Variables>().generalVariables.backGroundChangesList[1];
                                          context.read<OutBoundBloc>().currentListIndex = 1;
                                          context.read<OutBoundBloc>().add(const OutBoundFilterEvent());
                                        },
                                  child: context.read<OutBoundBloc>().currentListIndex == 1
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
                                  onTap: tripList is OutBoundLoading || tripList is OutBoundTableLoading
                                      ? () {}
                                      : () {
                                          getIt<Variables>().generalVariables.currentBackGround =
                                              getIt<Variables>().generalVariables.backGroundChangesList[2];
                                          context.read<OutBoundBloc>().currentListIndex = 2;
                                          context.read<OutBoundBloc>().add(const OutBoundFilterEvent());
                                        },
                                  child: context.read<OutBoundBloc>().currentListIndex == 2
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
                            onTap: tripList is OutBoundLoading || tripList is OutBoundTableLoading
                                ? () {}
                                : () {
                                    context.read<OutBoundBloc>().searchBarEnabled = !context.read<OutBoundBloc>().searchBarEnabled;
                                    if (!context.read<OutBoundBloc>().searchBarEnabled) {
                                      searchBar.clear();
                                      FocusManager.instance.primaryFocus!.unfocus();
                                      context.read<OutBoundBloc>().searchText = "";
                                    }
                                    context.read<OutBoundBloc>().add(const OutBoundFilterEvent());
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
                            onTap: tripList is OutBoundLoading || tripList is OutBoundTableLoading
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
                            width: getIt<Functions>().getWidgetWidth(width: 25),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 15)),
                    child: BlocConsumer<OutBoundBloc, OutBoundState>(
                      buildWhen: (OutBoundState previous, OutBoundState current) {
                        return previous != current;
                      },
                      listenWhen: (OutBoundState previous, OutBoundState current) {
                        return previous != current;
                      },
                      listener: (BuildContext context, OutBoundState state) {
                        if (state is OutBoundError) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                        }
                      },
                      builder: (BuildContext context, OutBoundState state) {
                        if (state is OutBoundLoading) {
                          return Skeletonizer(
                            enabled: true,
                            child: SfDataGridTheme(
                              data: const SfDataGridThemeData(
                                headerColor: Colors.transparent,
                                gridLineColor: Colors.transparent,
                                selectionColor: Colors.transparent,
                                frozenPaneLineColor: Colors.transparent,
                              ),
                              child: SfDataGrid(
                                source: OutBoundScreenDataSource(context.read<OutBoundBloc>().tripListDummy, dataGridController, context),
                                columnWidthMode: ColumnWidthMode.fill,
                                controller: dataGridController,
                                columns: getColumns,
                                gridLinesVisibility: GridLinesVisibility.horizontal,
                                headerRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                                rowHeight: getIt<Functions>().getWidgetHeight(height: 63),
                                selectionMode: SelectionMode.multiple,
                                onCellTap: (details) {
                                  getIt<Variables>().generalVariables.indexName = OutBoundEntryScreen.id;
                                  getIt<Variables>().generalVariables.outBoundRouteList.add(OutBoundScreen.id);
                                  context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                },
                                onSelectionChanging: (addedRows, removedRows) {
                                  setState(() {});
                                  return false;
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
                          );
                        } else if (state is OutBoundTableLoading) {
                          return SfDataGridTheme(
                            data: const SfDataGridThemeData(
                              headerColor: Colors.transparent,
                              gridLineColor: Colors.transparent,
                              selectionColor: Colors.transparent,
                              frozenPaneLineColor: Colors.transparent,
                            ),
                            child: SfDataGrid(
                              source: OutBoundScreenDataSource(context.read<OutBoundBloc>().tripListDummy, dataGridController, context),
                              columnWidthMode: ColumnWidthMode.fill,
                              controller: dataGridController,
                              columns: getColumns,
                              gridLinesVisibility: GridLinesVisibility.horizontal,
                              headerRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                              rowHeight: getIt<Functions>().getWidgetHeight(height: 63),
                              selectionMode: SelectionMode.multiple,
                              onCellTap: (details) {
                                getIt<Variables>().generalVariables.indexName = OutBoundEntryScreen.id;
                                getIt<Variables>().generalVariables.outBoundRouteList.add(OutBoundScreen.id);
                                context.read<NavigationBloc>().add(const NavigationInitialEvent());
                              },
                              onSelectionChanging: (addedRows, removedRows) {
                                setState(() {});
                                return false;
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
                          );
                        } else if (state is OutBoundLoaded) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SfDataGridTheme(
                                data: const SfDataGridThemeData(
                                  headerColor: Colors.transparent,
                                  gridLineColor: Colors.transparent,
                                  selectionColor: Colors.transparent,
                                  frozenPaneLineColor: Colors.transparent,
                                ),
                                child: SfDataGrid(
                                  source: OutBoundScreenDataSource(context.read<OutBoundBloc>().searchedTripList, dataGridController, context),
                                  columnWidthMode: ColumnWidthMode.fill,
                                  controller: dataGridController,
                                  columns: getColumns,
                                  gridLinesVisibility: GridLinesVisibility.horizontal,
                                  headerRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                                  rowHeight: getIt<Functions>().getWidgetHeight(height: 63),
                                  selectionMode: SelectionMode.multiple,
                                  onCellTap: (details) {
                                    getIt<Variables>().generalVariables.tripListMainIdData =
                                        context.read<OutBoundBloc>().searchedTripList[details.rowColumnIndex.rowIndex - 1];
                                    getIt<Variables>().generalVariables.indexName = OutBoundEntryScreen.id;
                                    getIt<Variables>().generalVariables.outBoundRouteList.add(OutBoundScreen.id);
                                    context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                  },
                                  onSelectionChanging: (addedRows, removedRows) {
                                    setState(() {});
                                    return false;
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
                              context.read<OutBoundBloc>().searchedTripList.isEmpty
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
                                          getIt<Variables>().generalVariables.currentLanguage.outBoundListItemsEmpty,
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
              ],
            ),
          );
        } else {
          return Container(
            color: const Color(0xffEEF4FF),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                BlocBuilder<OutBoundBloc, OutBoundState>(
                  builder: (BuildContext context, OutBoundState tripList) {
                    return SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 124),
                      child: AppBar(
                        backgroundColor: const Color(0xffEEF4FF),
                        leading: IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: const Icon(Icons.menu, color: Color(0xffffffff)),
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
                                    getIt<Variables>().generalVariables.currentLanguage.outBoundTripLists,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: getIt<Functions>().getTextSize(fontSize: 24),
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
                          crossFadeState: context.read<OutBoundBloc>().searchBarEnabled ? CrossFadeState.showSecond : CrossFadeState.showFirst,
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
                            width: getIt<Functions>().getWidgetWidth(width: 14),
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 34),
                            width: getIt<Functions>().getWidgetWidth(width: 34),
                            child: PageView.builder(
                              controller: PageController(),
                              scrollDirection: Axis.vertical,
                              allowImplicitScrolling: true,
                              onPageChanged: tripList is OutBoundLoading || tripList is OutBoundTableLoading
                                  ? (value) {}
                                  : (value) {
                                      getIt<Variables>().generalVariables.currentBackGround =
                                          getIt<Variables>().generalVariables.backGroundChangesList[value];
                                      context.read<OutBoundBloc>().currentListIndex = value;
                                      context.read<OutBoundBloc>().add(const OutBoundFilterEvent());
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
                            width: getIt<Functions>().getWidgetWidth(width: 7),
                          ),
                          InkWell(
                            onTap: tripList is OutBoundLoading || tripList is OutBoundTableLoading
                                ? () {}
                                : () {
                                    context.read<OutBoundBloc>().searchBarEnabled = !context.read<OutBoundBloc>().searchBarEnabled;
                                    if (!context.read<OutBoundBloc>().searchBarEnabled) {
                                      searchBar.clear();
                                      FocusManager.instance.primaryFocus!.unfocus();
                                      context.read<OutBoundBloc>().searchText = "";
                                    }
                                    context.read<OutBoundBloc>().add(const OutBoundFilterEvent());
                                  },
                            child: Container(
                              height: getIt<Functions>().getWidgetHeight(height: 34),
                              width: getIt<Functions>().getWidgetWidth(width: 34),
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
                            width: getIt<Functions>().getWidgetWidth(width: 7),
                          ),
                          InkWell(
                            onTap: tripList is OutBoundLoading || tripList is OutBoundTableLoading
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
                                    height: getIt<Functions>().getWidgetHeight(height: 15.5),
                                    width: getIt<Functions>().getWidgetWidth(width: 15.5),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: getIt<Functions>().getWidgetWidth(width: 16),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 24)),
                Expanded(
                  child: BlocConsumer<OutBoundBloc, OutBoundState>(
                    buildWhen: (OutBoundState previous, OutBoundState current) {
                      return previous != current;
                    },
                    listenWhen: (OutBoundState previous, OutBoundState current) {
                      return previous != current;
                    },
                    listener: (BuildContext context, OutBoundState state) {
                      if (state is OutBoundError) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    builder: (BuildContext context, OutBoundState state) {
                      if (state is OutBoundLoading) {
                        return Skeletonizer(
                          enabled: true,
                          child: SfDataGridTheme(
                            data: const SfDataGridThemeData(
                              headerColor: Colors.transparent,
                              gridLineColor: Colors.transparent,
                              selectionColor: Colors.transparent,
                              frozenPaneLineColor: Colors.transparent,
                            ),
                            child: SfDataGrid(
                              source: OutBoundScreenDataSource(context.read<OutBoundBloc>().tripListDummy, dataGridController, context),
                              columnWidthMode: ColumnWidthMode.auto,
                              columnSizer: CustomColumnSizer(),
                              controller: dataGridController,
                              columns: getColumns,
                              gridLinesVisibility: GridLinesVisibility.horizontal,
                              headerRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                              rowHeight: getIt<Functions>().getWidgetHeight(height: 63),
                              selectionMode: SelectionMode.multiple,
                              onCellTap: (details) {
                                getIt<Variables>().generalVariables.indexName = OutBoundEntryScreen.id;
                                getIt<Variables>().generalVariables.outBoundRouteList.add(OutBoundScreen.id);
                                context.read<NavigationBloc>().add(const NavigationInitialEvent());
                              },
                              onSelectionChanging: (addedRows, removedRows) {
                                setState(() {});
                                return false;
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
                        );
                      } else if (state is OutBoundTableLoading) {
                        return SfDataGridTheme(
                          data: const SfDataGridThemeData(
                            headerColor: Colors.transparent,
                            gridLineColor: Colors.transparent,
                            selectionColor: Colors.transparent,
                            frozenPaneLineColor: Colors.transparent,
                          ),
                          child: SfDataGrid(
                            source: OutBoundScreenDataSource(context.read<OutBoundBloc>().tripListDummy, dataGridController, context),
                            columnWidthMode: ColumnWidthMode.auto,
                            columnSizer: CustomColumnSizer(),
                            controller: dataGridController,
                            columns: getColumns,
                            gridLinesVisibility: GridLinesVisibility.horizontal,
                            headerRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                            rowHeight: getIt<Functions>().getWidgetHeight(height: 63),
                            selectionMode: SelectionMode.multiple,
                            onCellTap: (details) {
                              getIt<Variables>().generalVariables.indexName = OutBoundEntryScreen.id;
                              getIt<Variables>().generalVariables.outBoundRouteList.add(OutBoundScreen.id);
                              context.read<NavigationBloc>().add(const NavigationInitialEvent());
                            },
                            onSelectionChanging: (addedRows, removedRows) {
                              setState(() {});
                              return false;
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
                        );
                      } else if (state is OutBoundLoaded) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            SfDataGridTheme(
                              data: const SfDataGridThemeData(
                                headerColor: Colors.transparent,
                                gridLineColor: Colors.transparent,
                                selectionColor: Colors.transparent,
                                frozenPaneLineColor: Colors.transparent,
                              ),
                              child: SfDataGrid(
                                source: OutBoundScreenDataSource(context.read<OutBoundBloc>().searchedTripList, dataGridController, context),
                                columnWidthMode: ColumnWidthMode.auto,
                                columnSizer: CustomColumnSizer(),
                                controller: dataGridController,
                                columns: getColumns,
                                gridLinesVisibility: GridLinesVisibility.horizontal,
                                headerRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                                rowHeight: getIt<Functions>().getWidgetHeight(height: 63),
                                selectionMode: SelectionMode.multiple,
                                onCellTap: (details) {
                                  getIt<Variables>().generalVariables.tripListMainIdData =
                                      context.read<OutBoundBloc>().searchedTripList[details.rowColumnIndex.rowIndex - 1];
                                  getIt<Variables>().generalVariables.indexName = OutBoundEntryScreen.id;
                                  getIt<Variables>().generalVariables.outBoundRouteList.add(OutBoundScreen.id);
                                  context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                },
                                onSelectionChanging: (addedRows, removedRows) {
                                  setState(() {});
                                  return false;
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
                            context.read<OutBoundBloc>().searchedTripList.isEmpty
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
                                        getIt<Variables>().generalVariables.currentLanguage.outBoundListItemsEmpty,
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
              ],
            ),
          );
        }
      }),
    );
  }

  Widget textBars({required TextEditingController controller}) {
    return BlocBuilder<OutBoundBloc, OutBoundState>(
      builder: (BuildContext context, OutBoundState tripList) {
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
                    context.read<OutBoundBloc>().add(const OutBoundSetStateEvent());
                    if (timer?.isActive ?? false) timer?.cancel();
                    timer = Timer(const Duration(milliseconds: 500), () {
                      if (value.isNotEmpty) {
                        context.read<OutBoundBloc>().searchText = value;
                        context.read<OutBoundBloc>().add(const OutBoundFilterEvent());
                      } else {
                        FocusManager.instance.primaryFocus!.unfocus();
                        context.read<OutBoundBloc>().searchText = "";
                        context.read<OutBoundBloc>().add(const OutBoundFilterEvent());
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
                                context.read<OutBoundBloc>().searchText = "";
                                context.read<OutBoundBloc>().add(const OutBoundFilterEvent());
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

  Widget usersDetailsContent() {
    return BlocConsumer<OutBoundBloc, OutBoundState>(
      listenWhen: (OutBoundState previous, OutBoundState current) {
        return previous != current;
      },
      buildWhen: (OutBoundState previous, OutBoundState current) {
        return previous != current;
      },
      listener: (BuildContext context, OutBoundState state) {},
      builder: (BuildContext context, OutBoundState state) {
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
                      width: getIt<Functions>().getWidgetWidth(width: 44),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://images.pexels.com/photos/2899097/pexels-photo-2899097.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
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
                    itemCount: 100,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: getIt<Functions>().getWidgetHeight(height: 50),
                                width: getIt<Functions>().getWidgetWidth(width: 50),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "https://images.pexels.com/photos/2899097/pexels-photo-2899097.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                                      fit: BoxFit.fill,
                                    )),
                              ),
                              SizedBox(
                                width: getIt<Functions>().getWidgetWidth(width: 10),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "John Mathew",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: getIt<Functions>().getTextSize(fontSize: 15),
                                        color: const Color(0xff282F3A)),
                                  ),
                                  Text(
                                    "196045",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                        color: const Color(0xff8A8D8E)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 33),
                          )
                        ],
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
}

class OutBoundScreenDataSource extends DataGridSource {
  OutBoundScreenDataSource(List<TripList> tripList, this.dataGridController, this.context) {
    buildDataGridRows(tripList);
  }

  List<DataGridRow> dataGridRows = [];

  DataGridController dataGridController;
  BuildContext context;

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRows(List<TripList> tripList) {
    dataGridRows = tripList
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell(columnName: 'tripId', value: [e.tripNum, e.tripVehicle]),
              DataGridCell(columnName: 'route', value: [e.tripRoute, e.tripStops]),
              DataGridCell(columnName: 'createdTime', value: [e.tripCreatedTime]),
              DataGridCell(columnName: 'orders', value: [e.tripOrders]),
              DataGridCell(columnName: 'handled', value: e.tripHandledBy),
              DataGridCell(columnName: 'status', value: [e.tripStatus, e.tripStatusColor, e.tripStatusBackGroundColor]),
              DataGridCell(columnName: 'loadingBay', value: [e.tripLoadingBayDryName, e.tripLoadingBayFrozenName]),
            ]))
        .toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      if (e.columnName == 'tripId') {
        return BlocBuilder<OutBoundBloc, OutBoundState>(
          builder: (BuildContext context, OutBoundState state) {
            return Skeletonizer(
              enabled: state is OutBoundTableLoading || state is OutBoundLoading,
              child: Container(
                margin: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 18)),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffE0E7EC)))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.value[0],
                      style: TextStyle(
                          color: const Color(0xff282F3A),
                          fontWeight: FontWeight.w600,
                          fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 13 : 13),
                          fontFamily: "Figtree"),
                    ),
                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 5)),
                    Skeleton.shade(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: getIt<Functions>().getWidgetHeight(height: 4.5),
                            horizontal: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 6 : 10)),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: const Color(0xff007AFF)),
                        child: Text(
                          e.value[1],
                          style: TextStyle(
                              color: const Color(0xffFFFFFF),
                              fontWeight: FontWeight.w600,
                              fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 10 : 12),
                              fontFamily: "Figtree"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }
      if (e.columnName == 'route') {
        return BlocBuilder<OutBoundBloc, OutBoundState>(
          builder: (BuildContext context, OutBoundState state) {
            return Skeletonizer(
              enabled: state is OutBoundTableLoading || state is OutBoundLoading,
              child: Container(
                margin: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 0)),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffE0E7EC)))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getIt<Variables>().generalVariables.isDeviceTablet
                        ? FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              e.value[0],
                              style: TextStyle(
                                  color: const Color(0xff282F3A),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 13 : 13),
                                  fontFamily: "Figtree"),
                            ),
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              e.value[0],
                              style: TextStyle(
                                  color: const Color(0xff282F3A),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 13 : 13),
                                  fontFamily: "Figtree"),
                            ),
                          ),
                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 5)),
                    Skeleton.shade(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: getIt<Functions>().getWidgetHeight(height: 4.5),
                            horizontal: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 6 : 10)),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: const Color(0xff007AFF)),
                        child: Text(
                          "${e.value[1]} STOPS",
                          style: TextStyle(
                              color: const Color(0xffFFFFFF),
                              fontWeight: FontWeight.w600,
                              fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 10 : 11),
                              fontFamily: "Figtree"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }
      if (e.columnName == 'createdTime') {
        return BlocBuilder<OutBoundBloc, OutBoundState>(
          builder: (BuildContext context, OutBoundState state) {
            return Skeletonizer(
              enabled: state is OutBoundTableLoading || state is OutBoundLoading,
              child: Container(
                margin: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 0)),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffE0E7EC)))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      e.value[0].toString().substring(0, 10),
                      style: TextStyle(
                          color: const Color(0xff282F3A),
                          fontWeight: FontWeight.w600,
                          fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                          fontFamily: "Figtree"),
                    ),
                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 5)),
                    Text(
                      e.value[0].toString().substring(11, e.value[0].toString().length),
                      style: TextStyle(
                          color: const Color(0xff282F3A),
                          fontWeight: FontWeight.w600,
                          fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                          fontFamily: "Figtree"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      if (e.columnName == 'handled') {
        return BlocBuilder<OutBoundBloc, OutBoundState>(builder: (BuildContext context, OutBoundState state) {
          List<String> images = List.generate(e.value.length, (i) => e.value[i].image);
          return Skeletonizer(
            enabled: state is OutBoundTableLoading || state is OutBoundLoading,
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
                        if (e.value.isNotEmpty) {
                          getIt<Variables>().generalVariables.popUpWidget = usersDetailsContent(handled: e.value);
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
      if (e.columnName == 'status') {
        return BlocBuilder<OutBoundBloc, OutBoundState>(builder: (BuildContext context, OutBoundState state) {
          return Skeletonizer(
            enabled: state is OutBoundTableLoading || state is OutBoundLoading,
            child: Skeleton.shade(
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffE0E7EC)))),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 0 : 5),
                      horizontal: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 0 : 6)),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: getIt<Variables>().generalVariables.isDeviceTablet ? Colors.transparent : const Color(0xffE0E7EC))),
                      color: getIt<Variables>().generalVariables.isDeviceTablet ? Colors.transparent : Color(int.parse("0XFF${e.value[2]}")),
                      borderRadius: BorderRadius.circular(getIt<Variables>().generalVariables.isDeviceTablet ? 0 : 6)),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      e.value[0].toString().toLowerCase() == "pending"
                          ? getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase()
                          : e.value[0].toString().toLowerCase() == "partial"
                              ? getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase()
                              : getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase(),
                      style: TextStyle(
                          color: Color(int.parse("0XFF${e.value[1]}")),
                          fontWeight: FontWeight.w600,
                          fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 12 : 11),
                          fontFamily: "Figtree"),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      }
      if (e.columnName == 'loadingBay') {
        return BlocBuilder<OutBoundBloc, OutBoundState>(builder: (BuildContext context, OutBoundState state) {
          return Skeletonizer(
            enabled: state is OutBoundTableLoading || state is OutBoundLoading,
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffE0E7EC)))),
              child: Text(
                "${e.value[0]}/${e.value[1]}",
                style: TextStyle(
                    color: const Color(0xff282F3A),
                    fontWeight: FontWeight.w600,
                    fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                    fontFamily: "Figtree"),
              ),
            ),
          );
        });
      }
      if (e.columnName == 'orders') {
        return BlocBuilder<OutBoundBloc, OutBoundState>(builder: (BuildContext context, OutBoundState state) {
          return Skeletonizer(
            enabled: state is OutBoundTableLoading || state is OutBoundLoading,
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffE0E7EC)))),
              child: Text(
                num.parse(e.value[0].toString()) > 9 ? e.value[0].toString() : "0${e.value[0]}",
                style: TextStyle(
                    color: const Color(0xff282F3A),
                    fontWeight: FontWeight.w600,
                    fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                    fontFamily: "Figtree"),
              ),
            ),
          );
        });
      } else {
        return BlocBuilder<OutBoundBloc, OutBoundState>(builder: (BuildContext context, OutBoundState state) {
          return Skeletonizer(
            enabled: state is OutBoundTableLoading || state is OutBoundLoading,
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffE0E7EC)))),
              child: Text(
                e.value[0].toString(),
                style: TextStyle(
                    color: const Color(0xff282F3A),
                    fontWeight: FontWeight.w600,
                    fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                    fontFamily: "Figtree"),
              ),
            ),
          );
        });
      }
    }).toList());
  }

  Widget usersDetailsContent({required List<HandledByForUpdateList> handled}) {
    return BlocConsumer<OutBoundBloc, OutBoundState>(
      listenWhen: (OutBoundState previous, OutBoundState current) {
        return previous != current;
      },
      buildWhen: (OutBoundState previous, OutBoundState current) {
        return previous != current;
      },
      listener: (BuildContext context, OutBoundState state) {},
      builder: (BuildContext context, OutBoundState state) {
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
                                        getIt<Variables>().generalVariables.currentLanguage.loadedItem.toUpperCase(),
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
    context.read<OutBoundBloc>().tripListDummy.clear();
    context.read<OutBoundBloc>().tripListDummy = [
      TripList(
          tripId: "1234",
          tripNum: "12345",
          tripVehicle: "1234",
          tripRoute: "1234",
          tripStops: "02",
          tripCreatedTime: "12/01/2025 03:15 PM",
          tripOrders: "100",
          tripHandledBy: [],
          tripStatus: 'Pending',
          tripLoadingBayDry: '1',
          tripLoadingBayFrozen: "A",
          tripStatusColor: 'DC474A',
          tripStatusBackGroundColor: 'FFCCCF',
          tripItemType: 'B',
          unavailableReasons: [],
          sessionInfo: SessionInfo.fromJson({}),
          partialItemsList: [],
          tripLoadingBayDryName: '',
          tripLoadingBayFrozenName: '',
          businessDate: '',
          deliveryArea: '',
          isSessionOpened: false,
          sessionId: '',
          sessionTimeStamp: '',
          sessionEventType: '')
    ];
    context.read<OutBoundBloc>().add(const OutBoundInitialEvent(isInitial: false));
  }

  @override
  Future<void> handleLoadMoreRows() async {
    context.read<OutBoundBloc>().tripListDummy.addAll([]);
    context.read<OutBoundBloc>().add(const OutBoundSetStateEvent());
  }
}

class CustomColumnSizer extends ColumnSizer {
  @override
  double computeCellWidth(GridColumn column, DataGridRow row, Object? cellValue, TextStyle textStyle) {
    dynamic valueData;
    if (column.columnName == "tripId") {
      valueData = "123456789000";
    } else if (column.columnName == "route" ||
        column.columnName == "createdTime" ||
        column.columnName == "handled" ||
        column.columnName == "orders") {
      valueData = "12345";
    } else {
      valueData = "123456";
    }
    return super.computeCellWidth(column, row, valueData, textStyle);
  }
}
