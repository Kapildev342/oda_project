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
import 'package:oda/bloc/ro_trip_list/ro_trip_list_main/ro_trip_list_main_bloc.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/screens/home/home_screen.dart';
import 'package:oda/screens/ro_trip_list/ro_trip_list_detail_screen.dart';

class RoTripListScreen extends StatefulWidget {
  static const String id = "ro_trip_list_screen";
  const RoTripListScreen({super.key});

  @override
  State<RoTripListScreen> createState() => _RoTripListScreenState();
}

class _RoTripListScreenState extends State<RoTripListScreen> {
  Timer? timer;
  TextEditingController searchBar = TextEditingController();
  DataGridController dataGridController = DataGridController();

  @override
  void initState() {
    context.read<RoTripListMainBloc>().tripListDummy = [
      RoTripList(
        tripId: "1234",
        tripNum: "12345",
        tripCreatedTime: "12/01/2025 03:15 PM",
        tripVehicle: "1234",
        tripRoute: "1234",
        tripReturnQty: '37',
        tripCollectedAmount: '100000',
        tripReconciliationStatus: 'Pending',
      )
    ];
    context.read<RoTripListMainBloc>().add(const RoTripListMainInitialEvent(isInitial: true));
    super.initState();
  }

  List<GridColumn> get getColumns {
    return <GridColumn>[
      GridColumn(
        columnName: 'trip_no',
        label: Container(
            decoration: BoxDecoration(
              color: const Color(0xffE0E7EC),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(getIt<Variables>().generalVariables.isDeviceTablet ? 4 : 4),
                  topLeft: Radius.circular(getIt<Variables>().generalVariables.isDeviceTablet ? 4 : 4)),
            ),
            alignment: Alignment.center,
            child: Text(getIt<Variables>().generalVariables.currentLanguage.tripNo,
                style: TextStyle(
                    color: const Color(0xff282F3A),
                    fontWeight: FontWeight.w700,
                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                    fontFamily: "Figtree"))),
      ),
      GridColumn(
          columnName: 'date',
          label: Container(
              decoration: const BoxDecoration(color: Color(0xffE0E7EC)),
              alignment: Alignment.center,
              child: Text(
                getIt<Variables>().generalVariables.currentLanguage.date.replaceAll('d', "D"),
                style: TextStyle(
                    fontFamily: "Figtree",
                    color: const Color(0xff282F3A),
                    fontWeight: FontWeight.w700,
                    fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
              ))),
      GridColumn(
          columnName: 'vehicle',
          label: Container(
              decoration: const BoxDecoration(color: Color(0xffE0E7EC)),
              alignment: Alignment.center,
              child: Text(
                getIt<Variables>().generalVariables.currentLanguage.vehicleNo,
                style: TextStyle(
                    fontFamily: "Figtree",
                    color: const Color(0xff282F3A),
                    fontWeight: FontWeight.w700,
                    fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
              ))),
      GridColumn(
          columnName: 'area',
          label: Container(
              decoration: const BoxDecoration(color: Color(0xffE0E7EC)),
              alignment: Alignment.center,
              child: Text(
                getIt<Variables>().generalVariables.currentLanguage.area,
                style: TextStyle(
                    fontFamily: "Figtree",
                    color: const Color(0xff282F3A),
                    fontWeight: FontWeight.w700,
                    fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
              ))),
      GridColumn(
          columnName: 'return_qty',
          label: Container(
              decoration: const BoxDecoration(color: Color(0xffE0E7EC)),
              alignment: Alignment.center,
              child: Text(
                getIt<Variables>().generalVariables.currentLanguage.returnQty,
                style: TextStyle(
                    fontFamily: "Figtree",
                    color: const Color(0xff282F3A),
                    fontWeight: FontWeight.w700,
                    fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
              ))),
      GridColumn(
          columnName: 'collected_amount',
          label: Container(
              decoration: const BoxDecoration(color: Color(0xffE0E7EC)),
              alignment: Alignment.center,
              child: Text(
                getIt<Variables>().generalVariables.currentLanguage.collectedAmount,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Figtree",
                    color: const Color(0xff282F3A),
                    fontWeight: FontWeight.w700,
                    fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
              ))),
      GridColumn(
          columnName: 'reconciliation',
          label: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(getIt<Variables>().generalVariables.isDeviceTablet ? 4 : 4),
                      bottomRight: Radius.circular(getIt<Variables>().generalVariables.isDeviceTablet ? 4 : 4)),
                  color: const Color(0xffE0E7EC)),
              alignment: Alignment.center,
              child: Text(
                getIt<Variables>().generalVariables.currentLanguage.reconciliation,
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
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 480) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<RoTripListMainBloc, RoTripListMainState>(
                    builder: (BuildContext context, RoTripListMainState tripList) {
                      return SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 117),
                        child: AppBar(
                          forceMaterialTransparency: true,
                          automaticallyImplyLeading: false,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    getIt<Variables>().generalVariables.currentLanguage.roTripDetails,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: getIt<Functions>().getTextSize(fontSize: 26),
                                        color: const Color(0xff282F3A)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: getIt<Functions>().getWidgetWidth(width: 7),
                              ),
                            ],
                          ),
                          actions: [
                            SizedBox(
                              width: getIt<Functions>().getWidgetWidth(width: 7),
                            ),
                            AnimatedCrossFade(
                              firstChild: const SizedBox(),
                              secondChild: textBars(controller: searchBar),
                              crossFadeState:
                                  context.read<RoTripListMainBloc>().searchBarEnabled ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 100),
                            ),
                            SizedBox(
                              width: getIt<Functions>().getWidgetWidth(width: 14),
                            ),
                            InkWell(
                              onTap: tripList is RoTripListMainLoading || tripList is RoTripListMainTableLoading
                                  ? () {}
                                  : () {
                                      context.read<RoTripListMainBloc>().searchBarEnabled = !context.read<RoTripListMainBloc>().searchBarEnabled;
                                      if (!context.read<RoTripListMainBloc>().searchBarEnabled) {
                                        searchBar.clear();
                                        FocusManager.instance.primaryFocus!.unfocus();
                                        context.read<RoTripListMainBloc>().searchText = "";
                                      }
                                      context.read<RoTripListMainBloc>().add(const RoTripListMainFilterEvent());
                                    },
                              child: Container(
                                height: getIt<Functions>().getWidgetHeight(height: 37),
                                width: getIt<Functions>().getWidgetWidth(width: 37),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFFFFFFF).withOpacity(0.2)),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/catch_weight/action_search.svg',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: getIt<Functions>().getWidgetWidth(width: 14),
                            ),
                            InkWell(
                              onTap: tripList is RoTripListMainLoading || tripList is RoTripListMainTableLoading
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
                                      'assets/catch_weight/filter.svg',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 15)),
                  Expanded(
                    child: BlocConsumer<RoTripListMainBloc, RoTripListMainState>(
                      buildWhen: (RoTripListMainState previous, RoTripListMainState current) {
                        return previous != current;
                      },
                      listenWhen: (RoTripListMainState previous, RoTripListMainState current) {
                        return previous != current;
                      },
                      listener: (BuildContext context, RoTripListMainState state) {
                        if (state is RoTripListMainError) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                        }
                      },
                      builder: (BuildContext context, RoTripListMainState state) {
                        if (state is RoTripListMainLoading) {
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
                                source: TripListScreenDataSource(context.read<RoTripListMainBloc>().tripListDummy, dataGridController, context),
                                columnWidthMode: ColumnWidthMode.fill,
                                controller: dataGridController,
                                columns: getColumns,
                                gridLinesVisibility: GridLinesVisibility.horizontal,
                                headerRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                                rowHeight: getIt<Functions>().getWidgetHeight(height: 63),
                                selectionMode: SelectionMode.multiple,
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
                        } else if (state is RoTripListMainTableLoading) {
                          return SfDataGridTheme(
                            data: const SfDataGridThemeData(
                              headerColor: Colors.transparent,
                              gridLineColor: Colors.transparent,
                              selectionColor: Colors.transparent,
                              frozenPaneLineColor: Colors.transparent,
                            ),
                            child: SfDataGrid(
                              source: TripListScreenDataSource(context.read<RoTripListMainBloc>().tripListDummy, dataGridController, context),
                              columnWidthMode: ColumnWidthMode.fill,
                              controller: dataGridController,
                              columns: getColumns,
                              gridLinesVisibility: GridLinesVisibility.horizontal,
                              headerRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                              rowHeight: getIt<Functions>().getWidgetHeight(height: 63),
                              selectionMode: SelectionMode.multiple,
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
                        } else if (state is RoTripListMainLoaded) {
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
                                  source:
                                      TripListScreenDataSource(context.read<RoTripListMainBloc>().searchedRoTripList, dataGridController, context),
                                  columnWidthMode: ColumnWidthMode.fill,
                                  controller: dataGridController,
                                  columns: getColumns,
                                  gridLinesVisibility: GridLinesVisibility.horizontal,
                                  headerRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                                  rowHeight: getIt<Functions>().getWidgetHeight(height: 63),
                                  selectionMode: SelectionMode.multiple,
                                  onCellTap: (details) {
                                    getIt<Variables>().generalVariables.roTripListMainIdData =
                                        context.read<RoTripListMainBloc>().searchedRoTripList[details.rowColumnIndex.rowIndex - 1];
                                    getIt<Variables>().generalVariables.indexName = RoTripListDetailScreen.id;
                                    getIt<Variables>().generalVariables.roTripListRouteList.add(RoTripListScreen.id);
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
                              context.read<RoTripListMainBloc>().searchedRoTripList.isEmpty
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
                ],
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<RoTripListMainBloc, RoTripListMainState>(
                  builder: (BuildContext context, RoTripListMainState tripList) {
                    return AppBar(
                      automaticallyImplyLeading: false,
                      title: AnimatedCrossFade(
                        firstChild: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  getIt<Variables>().generalVariables.currentLanguage.roTripDetails,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700, fontSize: getIt<Functions>().getTextSize(fontSize: 26), color: const Color(0xff282F3A)),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: getIt<Functions>().getWidgetWidth(width: 7),
                            ),
                          ],
                        ),
                        secondChild: textBars(controller: searchBar),
                        crossFadeState: context.read<RoTripListMainBloc>().searchBarEnabled ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 100),
                      ),
                      actions: [
                        InkWell(
                          onTap: tripList is RoTripListMainLoading || tripList is RoTripListMainTableLoading
                              ? () {}
                              : () {
                                  context.read<RoTripListMainBloc>().searchBarEnabled = !context.read<RoTripListMainBloc>().searchBarEnabled;
                                  if (!context.read<RoTripListMainBloc>().searchBarEnabled) {
                                    searchBar.clear();
                                    FocusManager.instance.primaryFocus!.unfocus();
                                    context.read<RoTripListMainBloc>().searchText = "";
                                  }
                                  context.read<RoTripListMainBloc>().add(const RoTripListMainFilterEvent());
                                },
                          child: Container(
                            height: getIt<Functions>().getWidgetHeight(height: 34),
                            width: getIt<Functions>().getWidgetWidth(width: 34),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFFFFFFF).withOpacity(0.2)),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/catch_weight/action_search.svg',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: getIt<Functions>().getWidgetWidth(width: 7),
                        ),
                        InkWell(
                          onTap: tripList is RoTripListMainLoading || tripList is RoTripListMainTableLoading
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
                                  'assets/catch_weight/filter.svg',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: getIt<Functions>().getWidgetWidth(width: 12),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 16)),
                Expanded(
                  child: BlocConsumer<RoTripListMainBloc, RoTripListMainState>(
                    buildWhen: (RoTripListMainState previous, RoTripListMainState current) {
                      return previous != current;
                    },
                    listenWhen: (RoTripListMainState previous, RoTripListMainState current) {
                      return previous != current;
                    },
                    listener: (BuildContext context, RoTripListMainState state) {
                      if (state is RoTripListMainError) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    builder: (BuildContext context, RoTripListMainState state) {
                      if (state is RoTripListMainLoading) {
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
                              source: TripListScreenDataSource(context.read<RoTripListMainBloc>().tripListDummy, dataGridController, context),
                              columnWidthMode: ColumnWidthMode.auto,
                              columnSizer: CustomColumnSizer(),
                              controller: dataGridController,
                              columns: getColumns,
                              gridLinesVisibility: GridLinesVisibility.horizontal,
                              headerRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                              rowHeight: getIt<Functions>().getWidgetHeight(height: 63),
                              selectionMode: SelectionMode.multiple,
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
                      } else if (state is RoTripListMainTableLoading) {
                        return SfDataGridTheme(
                          data: const SfDataGridThemeData(
                            headerColor: Colors.transparent,
                            gridLineColor: Colors.transparent,
                            selectionColor: Colors.transparent,
                            frozenPaneLineColor: Colors.transparent,
                          ),
                          child: SfDataGrid(
                            source: TripListScreenDataSource(context.read<RoTripListMainBloc>().tripListDummy, dataGridController, context),
                            columnWidthMode: ColumnWidthMode.auto,
                            columnSizer: CustomColumnSizer(),
                            controller: dataGridController,
                            columns: getColumns,
                            gridLinesVisibility: GridLinesVisibility.horizontal,
                            headerRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                            rowHeight: getIt<Functions>().getWidgetHeight(height: 63),
                            selectionMode: SelectionMode.multiple,
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
                      } else if (state is RoTripListMainLoaded) {
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
                                source: TripListScreenDataSource(context.read<RoTripListMainBloc>().searchedRoTripList, dataGridController, context),
                                columnWidthMode: ColumnWidthMode.auto,
                                columnSizer: CustomColumnSizer(),
                                controller: dataGridController,
                                columns: getColumns,
                                gridLinesVisibility: GridLinesVisibility.horizontal,
                                headerRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                                rowHeight: getIt<Functions>().getWidgetHeight(height: 63),
                                selectionMode: SelectionMode.multiple,
                                onCellTap: (details) {
                                  getIt<Variables>().generalVariables.roTripListMainIdData =
                                      context.read<RoTripListMainBloc>().searchedRoTripList[details.rowColumnIndex.rowIndex - 1];
                                  getIt<Variables>().generalVariables.indexName = RoTripListDetailScreen.id;
                                  getIt<Variables>().generalVariables.roTripListRouteList.add(RoTripListScreen.id);
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
                            context.read<RoTripListMainBloc>().searchedRoTripList.isEmpty
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
              ],
            );
          }
        },
      ),
    );
  }

  Widget textBars({required TextEditingController controller}) {
    return BlocBuilder<RoTripListMainBloc, RoTripListMainState>(
      builder: (BuildContext context, RoTripListMainState tripList) {
        return SizedBox(
          height: getIt<Functions>().getWidgetHeight(height: 40),
          width: getIt<Functions>().getWidgetWidth(width: 250),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: getIt<Functions>().getWidgetHeight(height: 36),
                child: TextFormField(
                  onChanged: (value) {
                    context.read<RoTripListMainBloc>().add(const RoTripListMainSetStateEvent());
                    if (timer?.isActive ?? false) timer?.cancel();
                    timer = Timer(const Duration(milliseconds: 500), () {
                      if (value.isNotEmpty) {
                        context.read<RoTripListMainBloc>().searchText = value;
                        context.read<RoTripListMainBloc>().add(const RoTripListMainFilterEvent());
                      } else {
                        FocusManager.instance.primaryFocus!.unfocus();
                        context.read<RoTripListMainBloc>().searchText = "";
                        context.read<RoTripListMainBloc>().add(const RoTripListMainFilterEvent());
                      }
                    });
                  },
                  controller: controller,
                  cursorColor: const Color(0xff282F3A),
                  keyboardType: TextInputType.text,
                  style:
                      TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 15), fontWeight: FontWeight.w500, color: const Color(0xff282F3A)),
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
                      prefixIcon: Icon(Icons.search, color: const Color(0xff282F3A).withOpacity(0.5)),
                      suffixIcon: controller.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                controller.clear();
                                FocusManager.instance.primaryFocus!.unfocus();
                                context.read<RoTripListMainBloc>().searchText = "";
                                context.read<RoTripListMainBloc>().add(const RoTripListMainFilterEvent());
                              },
                              icon: Icon(Icons.clear, color: const Color(0xff282F3A).withOpacity(0.5), size: 15))
                          : const SizedBox(),
                      hintText: getIt<Variables>().generalVariables.currentLanguage.search,
                      hintStyle: TextStyle(
                          color: const Color(0xff282F3A).withOpacity(0.5),
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

class TripListScreenDataSource extends DataGridSource {
  TripListScreenDataSource(List<RoTripList> tripList, this.dataGridController, this.context) {
    buildDataGridRows(tripList);
  }

  List<DataGridRow> dataGridRows = [];

  DataGridController dataGridController;
  BuildContext context;

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRows(List<RoTripList> tripList) {
    dataGridRows = tripList
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell(columnName: 'trip_no', value: e.tripNum),
              DataGridCell(columnName: 'date', value: e.tripCreatedTime),
              DataGridCell(columnName: 'vehicle', value: e.tripVehicle),
              DataGridCell(columnName: 'area', value: e.tripRoute),
              DataGridCell(columnName: 'return_qty', value: e.tripReturnQty),
              DataGridCell(columnName: 'collected_amount', value: e.tripCollectedAmount),
              DataGridCell(columnName: 'reconciliation', value: e.tripReconciliationStatus),
            ]))
        .toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      if (e.columnName == 'collected_amount') {
        return BlocBuilder<RoTripListMainBloc, RoTripListMainState>(builder: (BuildContext context, RoTripListMainState state) {
          return Skeletonizer(
            enabled: state is RoTripListMainTableLoading || state is RoTripListMainLoading,
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffE0E7EC)))),
              child: Text(
                "Rs ${e.value}",
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
      if (e.columnName == 'reconciliation') {
        return BlocBuilder<RoTripListMainBloc, RoTripListMainState>(builder: (BuildContext context, RoTripListMainState state) {
          return Skeletonizer(
            enabled: state is RoTripListMainTableLoading || state is RoTripListMainLoading,
            child: Skeleton.shade(
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffE0E7EC)))),
                child: Container(
                  width: getIt<Functions>().getWidgetWidth(width: 80),
                  padding: EdgeInsets.symmetric(
                      vertical: getIt<Functions>().getWidgetHeight(height: 5), horizontal: getIt<Functions>().getWidgetWidth(width: 7)),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: getIt<Variables>().generalVariables.isDeviceTablet ? Colors.transparent : const Color(0xffE0E7EC))),
                      color: e.value.toString().toLowerCase() == "pending" ? const Color(0xffE7A454) : const Color(0xff29B473),
                      borderRadius: BorderRadius.circular(3)),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      e.value.toString().toLowerCase() == "pending"
                          ? getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase()
                          : getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase(),
                      style: TextStyle(
                          color: const Color(0xffffffff),
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
      else {
        return BlocBuilder<RoTripListMainBloc, RoTripListMainState>(builder: (BuildContext context, RoTripListMainState state) {
          return Skeletonizer(
            enabled: state is RoTripListMainTableLoading || state is RoTripListMainLoading,
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffE0E7EC)))),
              child: Text(
                e.value.toString(),
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

  void updateDataGrid() {
    notifyListeners();
  }

  @override
  Future<void> handleRefresh() async {
    context.read<RoTripListMainBloc>().tripListDummy.clear();
    context.read<RoTripListMainBloc>().tripListDummy = [
      RoTripList(
        tripId: "1234",
        tripNum: "12345",
        tripCreatedTime: "12/01/2025 03:15 PM",
        tripVehicle: "1234",
        tripRoute: "1234",
        tripReturnQty: '37',
        tripCollectedAmount: '100000',
        tripReconciliationStatus: 'Pending',
      )
    ];
    context.read<RoTripListMainBloc>().add(const RoTripListMainInitialEvent(isInitial: false));
  }

  @override
  Future<void> handleLoadMoreRows() async {
    context.read<RoTripListMainBloc>().tripListDummy.addAll([]);
    context.read<RoTripListMainBloc>().add(const RoTripListMainSetStateEvent());
  }
}

class CustomColumnSizer extends ColumnSizer {
  @override
  double computeCellWidth(GridColumn column, DataGridRow row, Object? cellValue, TextStyle textStyle) {
    dynamic valueData;
    if (column.columnName == "tripId") {
      valueData = "123456789000";
    }
    else if (column.columnName == "area") {
      valueData = "123456789000";
    }
    else if (column.columnName == "route" ||
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

class RoTripList {
  String tripId;
  String tripNum;
  String tripCreatedTime;
  String tripVehicle;
  String tripRoute;
  String tripReturnQty;
  String tripCollectedAmount;
  String tripReconciliationStatus;

  RoTripList({
    required this.tripId,
    required this.tripNum,
    required this.tripCreatedTime,
    required this.tripVehicle,
    required this.tripRoute,
    required this.tripReturnQty,
    required this.tripCollectedAmount,
    required this.tripReconciliationStatus,
  });

  factory RoTripList.fromJson(Map<String, dynamic> json) => RoTripList(
        tripId: json["trip_id"] ?? '',
        tripNum: json["trip_num"] ?? '',
        tripCreatedTime: json["trip_date"] ?? '',
        tripVehicle: json["vehicle_number"] ?? 'L01234',
        tripRoute: json["route_name"] ?? '',
        tripReturnQty: json["return_qty"] ?? '',
        tripCollectedAmount: json["collected_amount"] ?? '',
        tripReconciliationStatus: json["return_status"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "trip_id": tripId,
        "trip_num": tripNum,
        "trip_date": tripCreatedTime,
        "vehicle_number": tripVehicle,
        "route_name": tripRoute,
        "return_qty": tripReturnQty,
        "collected_amount": tripCollectedAmount,
        "return_status": tripReconciliationStatus,
      };
}
