// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';

// Project imports:
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/bloc/timer/timer_bloc.dart';
import 'package:oda/bloc/warehouse_pickup/warehouse_pickup_detail/warehouse_pickup_detail_bloc.dart';
import 'package:oda/edited_packages/data_table_library/src/data_table_2.dart';
import 'package:oda/local_database/pick_list_box/pick_list.dart';
import 'package:oda/local_database/trip_box/trip_list.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/resources/widgets.dart';
import 'package:oda/screens/warehouse_pickup/warehouse_pickup_summary_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WarehousePickupDetailScreen extends StatefulWidget {
  static const String id = "warehouse_pickup_detail_screen";

  const WarehousePickupDetailScreen({super.key});

  @override
  State<WarehousePickupDetailScreen> createState() => _WarehousePickupDetailScreenState();
}

class _WarehousePickupDetailScreenState extends State<WarehousePickupDetailScreen> with TickerProviderStateMixin {
  TextEditingController searchBar = TextEditingController();
  TextEditingController reasonSearchFieldController = TextEditingController();
  TextEditingController commentsBar = TextEditingController();
  late TabController tabController;
  Timer? timer;
  String timerString = "00:00:00";
  Timer? timeSpentTimer;
  final ScrollController _pendingScrollController = ScrollController();
  final ScrollController _pendingEmptyController = ScrollController();
  final ScrollController _deliveredScrollController = ScrollController();
  final ScrollController _deliveredEmptyController = ScrollController();
  final ScrollController _unavailableScrollController = ScrollController();
  final ScrollController _unavailableEmptyController = ScrollController();
  double pendingTriggerOffset = -140.0;
  double pendingEmptyTriggerOffset = -140.0;
  double deliveredTriggerOffset = -140.0;
  double deliveredEmptyTriggerOffset = -140.0;
  double unavailableTriggerOffset = -140.0;
  double unavailableEmptyTriggerOffset = -140.0;
  bool isPendingAlreadyCalled = false;
  bool isPendingEmptyAlreadyCalled = false;
  bool isDeliveredAlreadyCalled = false;
  bool isDeliveredEmptyAlreadyCalled = false;
  bool isUnavailableAlreadyCalled = false;
  bool isUnavailableEmptyAlreadyCalled = false;

  @override
  void initState() {
    getIt<Variables>().generalVariables.filters = [];
    context.read<WarehousePickupDetailBloc>().tabIndex = 0;
    tabController = TabController(length: 3, vsync: this, initialIndex: 0)
      ..addListener(() {
        if (tabController.indexIsChanging) {
          context.read<WarehousePickupDetailBloc>().pageIndex = 1;
          context.read<WarehousePickupDetailBloc>().tabIndex = tabController.index;
          switch (context.read<WarehousePickupDetailBloc>().tabIndex) {
            case 0:
              {
                context.read<WarehousePickupDetailBloc>().tabName = "Pending";
              }
            case 1:
              {
                context.read<WarehousePickupDetailBloc>().tabName = "Loaded";
              }
            case 2:
              {
                context.read<WarehousePickupDetailBloc>().tabName = "Unavailable";
              }
            default:
              {
                context.read<WarehousePickupDetailBloc>().tabName = "Pending";
              }
          }
          context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailTabChangingEvent(isLoading: false));
        }
      });
    _pendingScrollController.addListener(_onScroll);
    _pendingEmptyController.addListener(_onScrollEmpty);
    _deliveredScrollController.addListener(_onScroll2);
    _deliveredEmptyController.addListener(_onScroll2Empty);
    _unavailableScrollController.addListener(_onScroll3);
    _unavailableEmptyController.addListener(_onScroll3Empty);
    context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailInitialEvent());
    timerFunction();
    super.initState();
  }

  timerFunction() async {
    timeSpentTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timerString = getIt<Functions>().durationToString(
          timeStamp: getIt<Variables>().generalVariables.soListMainIdData.sessionInfo.sessionStartTimestamp, currentTime: DateTime.now());
      context.read<TimerBloc>().add(const TimerInitialEvent());
    });
  }

  void _onScroll() {
    if (_pendingScrollController.offset == 0.0) {
      isPendingAlreadyCalled = false;
    }
    if (_pendingScrollController.offset < pendingTriggerOffset) {
      if (isPendingAlreadyCalled == false) {
        context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailTabChangingEvent(isLoading: false));
        isPendingAlreadyCalled = true;
      }
    }
  }

  void _onScrollEmpty() {
    if (_pendingEmptyController.offset == 0.0) {
      isPendingEmptyAlreadyCalled = false;
    }
    if (_pendingEmptyController.offset < pendingEmptyTriggerOffset) {
      if (isPendingEmptyAlreadyCalled == false) {
        context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailTabChangingEvent(isLoading: false));
        isPendingEmptyAlreadyCalled = true;
      }
    }
  }

  void _onScroll2() {
    if (_deliveredScrollController.offset == 0.0) {
      isDeliveredAlreadyCalled = false;
    }
    if (_deliveredScrollController.offset < deliveredTriggerOffset) {
      if (isDeliveredAlreadyCalled == false) {
        context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailTabChangingEvent(isLoading: false));
        isDeliveredAlreadyCalled = true;
      }
    }
  }

  void _onScroll2Empty() {
    if (_deliveredEmptyController.offset == 0.0) {
      isDeliveredEmptyAlreadyCalled = false;
    }
    if (_deliveredEmptyController.offset < deliveredEmptyTriggerOffset) {
      if (isDeliveredEmptyAlreadyCalled == false) {
        context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailTabChangingEvent(isLoading: false));
        isDeliveredEmptyAlreadyCalled = true;
      }
    }
  }

  void _onScroll3() {
    if (_unavailableScrollController.offset == 0.0) {
      isUnavailableAlreadyCalled = false;
    }
    if (_unavailableScrollController.offset < unavailableTriggerOffset) {
      if (isUnavailableAlreadyCalled == false) {
        context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailTabChangingEvent(isLoading: false));
        isUnavailableAlreadyCalled = true;
      }
    }
  }

  void _onScroll3Empty() {
    if (_unavailableEmptyController.offset == 0.0) {
      isUnavailableEmptyAlreadyCalled = false;
    }
    if (_unavailableEmptyController.offset < unavailableEmptyTriggerOffset) {
      if (isUnavailableEmptyAlreadyCalled == false) {
        context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailTabChangingEvent(isLoading: false));
        isUnavailableEmptyAlreadyCalled = true;
      }
    }
  }

  @override
  void dispose() {
    timeSpentTimer!.cancel();
    _pendingScrollController.removeListener(_onScroll);
    _pendingScrollController.dispose();
    _pendingEmptyController.removeListener(_onScroll);
    _pendingEmptyController.dispose();
    _deliveredScrollController.removeListener(_onScroll2);
    _deliveredScrollController.dispose();
    _deliveredEmptyController.removeListener(_onScroll2);
    _deliveredEmptyController.dispose();
    _unavailableScrollController.removeListener(_onScroll3);
    _unavailableScrollController.dispose();
    _unavailableEmptyController.removeListener(_onScroll3);
    _unavailableEmptyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WarehousePickupDetailBloc, WarehousePickupDetailState>(
      builder: (BuildContext context, WarehousePickupDetailState state) {
        return PopScope(
          canPop: false,
          onPopInvoked: (value) {
            getIt<Variables>().generalVariables.indexName =
                getIt<Variables>().generalVariables.warehouseRouteList[getIt<Variables>().generalVariables.warehouseRouteList.length - 1];
            context.read<NavigationBloc>().add(const NavigationInitialEvent());
            getIt<Variables>().generalVariables.warehouseRouteList.removeAt(getIt<Variables>().generalVariables.warehouseRouteList.length - 1);
          },
          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth > 480) {
              return Container(
                color: const Color(0xffEEF4FF),
                child: Column(
                  children: [
                    BlocBuilder<WarehousePickupDetailBloc, WarehousePickupDetailState>(
                      builder: (BuildContext context, WarehousePickupDetailState state) {
                        return SizedBox(
                          height: getIt<Functions>().getWidgetHeight(height: 154),
                          child: AppBar(
                            backgroundColor: const Color(0xff1D2736),
                            leading: IconButton(
                              onPressed: () {
                                getIt<Variables>().generalVariables.indexName = getIt<Variables>()
                                    .generalVariables
                                    .warehouseRouteList[getIt<Variables>().generalVariables.warehouseRouteList.length - 1];
                                context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                getIt<Variables>()
                                    .generalVariables
                                    .warehouseRouteList
                                    .removeAt(getIt<Variables>().generalVariables.warehouseRouteList.length - 1);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Color(0xffffffff),
                              ),
                            ),
                            title: Text(
                              "${getIt<Variables>().generalVariables.currentLanguage.so.toUpperCase()} # ${getIt<Variables>().generalVariables.soListMainIdData.soNum}  ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 22),
                                  color: const Color(0xffffffff)),
                            ),
                            actions: [
                              AnimatedCrossFade(
                                firstChild: const SizedBox(),
                                secondChild: textBars(controller: searchBar),
                                crossFadeState:
                                    context.read<WarehousePickupDetailBloc>().searchBarEnabled ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                duration: const Duration(milliseconds: 100),
                              ),
                              SizedBox(
                                width: getIt<Functions>().getWidgetWidth(width: 14),
                              ),
                              InkWell(
                                onTap: state is WarehousePickupDetailLoading
                                    ? () {}
                                    : () {
                                        context.read<WarehousePickupDetailBloc>().searchBarEnabled =
                                            !context.read<WarehousePickupDetailBloc>().searchBarEnabled;
                                        if (context.read<WarehousePickupDetailBloc>().searchBarEnabled == false) {
                                          searchBar.clear();
                                          FocusManager.instance.primaryFocus!.unfocus();
                                          context.read<WarehousePickupDetailBloc>().searchText = "";
                                        }
                                        context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailFilterEvent());
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
                                onTap: state is WarehousePickupDetailLoading
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
                                  getIt<Functions>().getWidgetHeight(height: 140)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 14)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 52),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: getIt<Variables>().generalVariables.isNetworkOffline
                                                ? () {}
                                                : () {
                                                    getIt<Variables>().generalVariables.isStatusDrawer = true;
                                                    Scaffold.of(context).openEndDrawer();
                                                  },
                                            child: SvgPicture.asset(
                                              "assets/pick_list/status_image.svg",
                                              height: getIt<Functions>().getWidgetHeight(height: 20),
                                              width: getIt<Functions>().getWidgetWidth(width: 20),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
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
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              getIt<Variables>().generalVariables.currentLanguage.status,
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                  color: const Color(0xffffffff)),
                                                            ),
                                                            Text(
                                                              getIt<Variables>().generalVariables.soListMainIdData.soStatus.toUpperCase(),
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                  color: const Color(0xffF8B11D)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: getIt<Functions>().getWidgetHeight(height: 30),
                                                        width: getIt<Functions>().getWidgetWidth(width: 0),
                                                        child: const VerticalDivider(
                                                          color: Color(0xffE0E7EC),
                                                          width: 1,
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            getIt<Variables>().generalVariables.currentLanguage.numberOfItems.toUpperCase(),
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                color: const Color(0xffffffff)),
                                                          ),
                                                          Text(
                                                            "${getIt<Variables>().generalVariables.soListMainIdData.soNoOfLoadedItems} / ${getIt<Variables>().generalVariables.soListMainIdData.soNoOfItems}",
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                color: const Color(0xff5AC8EA)),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: getIt<Functions>().getWidgetHeight(height: 30),
                                                        width: getIt<Functions>().getWidgetWidth(width: 0),
                                                        child: const VerticalDivider(
                                                          color: Color(0xffE0E7EC),
                                                          width: 1,
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            getIt<Variables>().generalVariables.currentLanguage.dateAndTime,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                color: const Color(0xffffffff)),
                                                          ),
                                                          Text(
                                                            getIt<Variables>().generalVariables.soListMainIdData.soCreatedTime,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                color: const Color(0xff5AC8EA)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: getIt<Functions>().getWidgetWidth(width: 30)),
                                                Container(
                                                  height: getIt<Functions>().getWidgetHeight(height: 45),
                                                  padding: EdgeInsets.only(
                                                      left: getIt<Functions>().getWidgetWidth(width: 10),
                                                      right: getIt<Functions>().getWidgetWidth(width: 4),
                                                      top: getIt<Functions>().getWidgetHeight(height: 4),
                                                      bottom: getIt<Functions>().getWidgetHeight(height: 4)),
                                                  decoration: BoxDecoration(color: const Color(0xffFFFFFF), borderRadius: BorderRadius.circular(7)),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          FittedBox(
                                                            fit: BoxFit.scaleDown,
                                                            child: Text(
                                                              getIt<Variables>().generalVariables.currentLanguage.timeSpent,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                  color: const Color(0xff1D2736)),
                                                            ),
                                                          ),
                                                          BlocBuilder<TimerBloc, TimerState>(
                                                            builder: (BuildContext context, TimerState state) {
                                                              return Text(
                                                                timerString,
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                    color: const Color(0xff007AFF)),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                                      Container(
                                                        height: getIt<Functions>().getWidgetHeight(height: 40),
                                                        width: getIt<Functions>().getWidgetWidth(width: 105),
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Expanded(
                                                                child: Container(
                                                              decoration: const BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
                                                                color: Color(0xff007838),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  Hive.box<ItemsList>('items_list_pickup')
                                                                      .values
                                                                      .toList()
                                                                      .where((element) =>
                                                                          element.soId == getIt<Variables>().generalVariables.soListMainIdData.soId &&
                                                                          element.itemLoadedStatus == "Loaded" &&
                                                                          element.isProgressStatus &&
                                                                          (element.handledBy.isNotEmpty
                                                                              ? (element.handledBy[0].code ==
                                                                                  getIt<Variables>().generalVariables.userDataEmployeeCode)
                                                                              : false))
                                                                      .toList()
                                                                      .length
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: const Color(0xffffffff),
                                                                      fontWeight: FontWeight.w600,
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                                ),
                                                              ),
                                                            )),
                                                            Expanded(
                                                                child: Container(
                                                              decoration: const BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
                                                                color: Color(0xffF92C38),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  Hive.box<ItemsList>('items_list_pickup')
                                                                      .values
                                                                      .toList()
                                                                      .where((element) =>
                                                                          element.soId == getIt<Variables>().generalVariables.soListMainIdData.soId &&
                                                                          element.itemLoadedStatus == "Unavailable" &&
                                                                          element.isProgressStatus &&
                                                                          (element.handledBy.isNotEmpty
                                                                              ? (element.handledBy[0].code ==
                                                                                  getIt<Variables>().generalVariables.userDataEmployeeCode)
                                                                              : false))
                                                                      .toList()
                                                                      .length
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: const Color(0xffffffff),
                                                                      fontWeight: FontWeight.w600,
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                                ),
                                                              ),
                                                            )),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                                      getIt<Variables>().generalVariables.soListMainIdData.soStatus.toLowerCase() == "completed"
                                                          ? Container(
                                                              height: getIt<Functions>().getWidgetHeight(height: 40),
                                                              width: getIt<Functions>().getWidgetWidth(width: 150),
                                                              decoration:
                                                                  BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
                                                              child: Center(
                                                                child: Text(
                                                                  getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase(),
                                                                  maxLines: 1,
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    color: const Color(0xff000000),
                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : InkWell(
                                                              onTap: () {
                                                                if (context
                                                                        .read<WarehousePickupDetailBloc>()
                                                                        .searchedItemsList
                                                                        .where((element) => element.itemLoadedStatus == "Pending")
                                                                        .toList()
                                                                        .isEmpty &&
                                                                    context
                                                                        .read<WarehousePickupDetailBloc>()
                                                                        .searchedItemsList
                                                                        .where((element) => element.itemLoadedStatus == "Unavailable")
                                                                        .toList()
                                                                        .isEmpty) {
                                                                  getIt<Variables>().generalVariables.indexName = WarehousePickupSummaryScreen.id;
                                                                  getIt<Variables>()
                                                                      .generalVariables
                                                                      .warehouseRouteList
                                                                      .add(WarehousePickupDetailScreen.id);
                                                                  context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                                                } else {
                                                                  ScaffoldMessenger.of(context).clearSnackBars();
                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                      SnackBar(content: Text(getIt<Variables>().generalVariables.currentLanguage.missedToDeliver)));
                                                                }
                                                              },
                                                              child: Container(
                                                                height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                width: getIt<Functions>().getWidgetWidth(width: 150),
                                                                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(4)),
                                                                child: Center(
                                                                  child: Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.delivered.toUpperCase(),
                                                                    maxLines: 1,
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                      color: const Color(0xffffffff),
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                      fontWeight: FontWeight.w600,
                                                                    ),
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
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 15)),
                                  ],
                                ),
                              ),
                            ),
                            titleSpacing: 0,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                    BlocBuilder<WarehousePickupDetailBloc, WarehousePickupDetailState>(
                      builder: (BuildContext context, WarehousePickupDetailState state) {
                        return Container(
                          height: getIt<Functions>().getWidgetHeight(height: 50),
                          margin: EdgeInsets.only(
                              bottom: getIt<Functions>().getWidgetHeight(height: 20),
                              left: getIt<Functions>().getWidgetWidth(width: 20),
                              right: getIt<Functions>().getWidgetWidth(width: 20)),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(7)),
                          child: TabBar(
                            indicatorWeight: 0,
                            controller: tabController,
                            indicator: BoxDecoration(borderRadius: BorderRadius.circular(7), color: const Color(0xff007AFF)),
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w600),
                            unselectedLabelStyle: TextStyle(
                                color: const Color(0xff6F6F6F), fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w600),
                            splashBorderRadius: BorderRadius.circular(7),
                            padding: EdgeInsets.symmetric(
                                vertical: getIt<Functions>().getWidgetHeight(height: 7), horizontal: getIt<Functions>().getWidgetWidth(width: 7)),
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            dividerHeight: 0.0,
                            isScrollable: false,
                            tabAlignment: TabAlignment.fill,
                            tabs: [
                              Tab(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(getIt<Variables>().generalVariables.currentLanguage.yetToDeliver.toUpperCase()),
                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                        context
                                                .read<WarehousePickupDetailBloc>()
                                                .searchedItemsList
                                                .where((element) => element.itemLoadedStatus == "Pending")
                                                .toList()
                                                .isEmpty
                                            ? const SizedBox()
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                    vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                decoration: BoxDecoration(
                                                    color: context.read<WarehousePickupDetailBloc>().tabIndex == 0
                                                        ? Colors.white
                                                        : const Color(0xff007AFF),
                                                    borderRadius: BorderRadius.circular(20)),
                                                child: Text(
                                                  context
                                                              .read<WarehousePickupDetailBloc>()
                                                              .searchedItemsList
                                                              .where((element) => element.itemLoadedStatus == "Pending")
                                                              .toList()
                                                              .length <
                                                          10
                                                      ? "0${context.read<WarehousePickupDetailBloc>().searchedItemsList.where((element) => element.itemLoadedStatus == "Pending").toList().length}"
                                                      : context
                                                          .read<WarehousePickupDetailBloc>()
                                                          .searchedItemsList
                                                          .where((element) => element.itemLoadedStatus == "Pending")
                                                          .toList()
                                                          .length
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: context.read<WarehousePickupDetailBloc>().tabIndex == 0
                                                          ? const Color(0xff282F3A)
                                                          : Colors.white,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 8),
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Tab(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(getIt<Variables>().generalVariables.currentLanguage.delivered.toUpperCase()),
                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                        context
                                                .read<WarehousePickupDetailBloc>()
                                                .searchedItemsList
                                                .where((element) => element.itemLoadedStatus == "Loaded")
                                                .toList()
                                                .isEmpty
                                            ? const SizedBox()
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                    vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                decoration: BoxDecoration(
                                                    color: context.read<WarehousePickupDetailBloc>().tabIndex == 1
                                                        ? Colors.white
                                                        : const Color(0xff007AFF),
                                                    borderRadius: BorderRadius.circular(20)),
                                                child: Text(
                                                  context
                                                              .read<WarehousePickupDetailBloc>()
                                                              .searchedItemsList
                                                              .where((element) => element.itemLoadedStatus == "Loaded")
                                                              .toList()
                                                              .length <
                                                          10
                                                      ? "0${context.read<WarehousePickupDetailBloc>().searchedItemsList.where((element) => element.itemLoadedStatus == "Loaded").toList().length}"
                                                      : context
                                                          .read<WarehousePickupDetailBloc>()
                                                          .searchedItemsList
                                                          .where((element) => element.itemLoadedStatus == "Loaded")
                                                          .toList()
                                                          .length
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: context.read<WarehousePickupDetailBloc>().tabIndex == 1
                                                          ? const Color(0xff282F3A)
                                                          : Colors.white,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 8),
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Tab(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(getIt<Variables>().generalVariables.currentLanguage.unavailable.toUpperCase()),
                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                        context
                                                .read<WarehousePickupDetailBloc>()
                                                .searchedItemsList
                                                .where((element) => element.itemLoadedStatus == "Unavailable")
                                                .toList()
                                                .isEmpty
                                            ? const SizedBox()
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                    vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                decoration: BoxDecoration(
                                                    color: context.read<WarehousePickupDetailBloc>().tabIndex == 2
                                                        ? Colors.white
                                                        : const Color(0xff007AFF),
                                                    borderRadius: BorderRadius.circular(20)),
                                                child: Text(
                                                  context
                                                              .read<WarehousePickupDetailBloc>()
                                                              .searchedItemsList
                                                              .where((element) => element.itemLoadedStatus == "Unavailable")
                                                              .toList()
                                                              .length <
                                                          10
                                                      ? "0${context.read<WarehousePickupDetailBloc>().searchedItemsList.where((element) => element.itemLoadedStatus == "Unavailable").toList().length}"
                                                      : context
                                                          .read<WarehousePickupDetailBloc>()
                                                          .searchedItemsList
                                                          .where((element) => element.itemLoadedStatus == "Unavailable")
                                                          .toList()
                                                          .length
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: context.read<WarehousePickupDetailBloc>().tabIndex == 2
                                                          ? const Color(0xff282F3A)
                                                          : Colors.white,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 8),
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: BlocBuilder<WarehousePickupDetailBloc, WarehousePickupDetailState>(
                        builder: (BuildContext context, WarehousePickupDetailState state) {
                          if (state is WarehousePickupDetailLoaded) {
                            switch (context.read<WarehousePickupDetailBloc>().tabIndex) {
                              case 0:
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: getIt<Functions>().getWidgetWidth(width: 20), right: getIt<Functions>().getWidgetWidth(width: 20)),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                  child: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList.isEmpty
                                      ? Stack(
                                          children: [
                                            SizedBox(
                                              width: getIt<Variables>().generalVariables.width,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
                                                  const CupertinoActivityIndicator(),
                                                ],
                                              ),
                                            ),
                                            ListView(
                                              padding: EdgeInsets.zero,
                                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                              controller: _pendingEmptyController,
                                              children: [
                                                Container(
                                                  color: const Color(0xffEEF4FF),
                                                  child: Column(
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
                                                        getIt<Variables>().generalVariables.currentLanguage.warehouseListIsEmpty,
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w600),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Stack(
                                          children: [
                                            SizedBox(
                                              width: getIt<Variables>().generalVariables.width,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
                                                  const CupertinoActivityIndicator(),
                                                ],
                                              ),
                                            ),
                                            ListView(
                                              padding: EdgeInsets.zero,
                                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                              controller: _pendingScrollController,
                                              children: [
                                                ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemCount: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList.length,
                                                    shrinkWrap: true,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return Container(
                                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                        margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              height: getIt<Functions>().getWidgetHeight(height: 38),
                                                              decoration: const BoxDecoration(
                                                                color: Color(0xffE3E7EA),
                                                                borderRadius:
                                                                    BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                                              ),
                                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  RichText(
                                                                    text: TextSpan(
                                                                      text: "${getIt<Variables>().generalVariables.currentLanguage.loadingBay} : ",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          color: const Color(0xff282F3A),
                                                                          fontWeight: FontWeight.w600,
                                                                          fontFamily: "overpassmono"),
                                                                      children: [
                                                                        TextSpan(
                                                                            text:
                                                                                '${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayDryName} / ${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayFrozenName}',
                                                                            style: TextStyle(
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                color: const Color(0xff007AFF),
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: "overpassmono")),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            ListView.builder(
                                                                padding: EdgeInsets.zero,
                                                                physics: const NeverScrollableScrollPhysics(),
                                                                shrinkWrap: true,
                                                                itemCount:
                                                                    context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index].length,
                                                                itemBuilder: (BuildContext context, int idx) {
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      if (context
                                                                              .read<WarehousePickupDetailBloc>()
                                                                              .singleTabGroupedItemsList[index][idx]
                                                                              .itemPickedStatus ==
                                                                          "Picked") {
                                                                        getIt<Variables>().generalVariables.popUpWidget = yetToDeliverContent(
                                                                            selectedItem: context
                                                                                .read<WarehousePickupDetailBloc>()
                                                                                .singleTabGroupedItemsList[index][idx],
                                                                            index: index,
                                                                            idx: idx,
                                                                            isDelivering: false);
                                                                        getIt<Functions>().showAnimatedDialog(
                                                                            context: context, isFromTop: false, isCloseDisabled: false);
                                                                      } else {
                                                                        ScaffoldMessenger.of(context).clearSnackBars();
                                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                            content: Text(
                                                                                getIt<Variables>().generalVariables.currentLanguage.itemNotPicked)));
                                                                      }
                                                                    },
                                                                    child: Column(
                                                                      children: [
                                                                        Container(
                                                                          padding: EdgeInsets.only(
                                                                            left: getIt<Functions>().getWidgetWidth(width: 20),
                                                                            right: getIt<Functions>().getWidgetWidth(width: 20),
                                                                            top: getIt<Functions>().getWidgetHeight(height: 16),
                                                                            bottom: getIt<Functions>().getWidgetHeight(height: 16),
                                                                          ),
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Container(
                                                                                      height: getIt<Functions>().getWidgetHeight(height: 28),
                                                                                      width: getIt<Functions>().getWidgetWidth(width: 28),
                                                                                      decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        color: Color(int.parse(
                                                                                            "0XFF${context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].typeColor}")),
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          context
                                                                                              .read<WarehousePickupDetailBloc>()
                                                                                              .singleTabGroupedItemsList[index][idx]
                                                                                              .itemType,
                                                                                          style: TextStyle(
                                                                                              color: const Color(0xffffffff),
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                                              fontWeight: FontWeight.w700),
                                                                                        ),
                                                                                      )),
                                                                                  SizedBox(width: getIt<Functions>().getWidgetWidth(width: 10)),
                                                                                  Expanded(
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          context
                                                                                              .read<WarehousePickupDetailBloc>()
                                                                                              .singleTabGroupedItemsList[index][idx]
                                                                                              .itemName,
                                                                                          maxLines: 1,
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.w600,
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                              color: const Color(0xff282F3A),
                                                                                              overflow: TextOverflow.ellipsis),
                                                                                        ),
                                                                                        Text(
                                                                                          "${getIt<Variables>().generalVariables.currentLanguage.remarks} : ${context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].remarks}",
                                                                                          maxLines: 1,
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                              color: const Color(0xff6F6F6F),
                                                                                              overflow: TextOverflow.ellipsis),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                              ),
                                                                              SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 58),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: ListView(
                                                                                        scrollDirection: Axis.horizontal,
                                                                                        physics: const BouncingScrollPhysics(),
                                                                                        shrinkWrap: true,
                                                                                        padding: EdgeInsets.zero,
                                                                                        children: [
                                                                                          Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Text(
                                                                                                getIt<Variables>()
                                                                                                    .generalVariables
                                                                                                    .currentLanguage
                                                                                                    .itemCode
                                                                                                    .toUpperCase(),
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 12),
                                                                                                    color: const Color(0xff8A8D8E)),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                  height:
                                                                                                      getIt<Functions>().getWidgetHeight(height: 7)),
                                                                                              Text(
                                                                                                context
                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                    .singleTabGroupedItemsList[index][idx]
                                                                                                    .itemCode,
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 12),
                                                                                                    color: const Color(0xff282F3A)),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(
                                                                                              width: getIt<Functions>().getWidgetWidth(width: 60)),
                                                                                          Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Text(
                                                                                                getIt<Variables>()
                                                                                                    .generalVariables
                                                                                                    .currentLanguage
                                                                                                    .uom,
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 12),
                                                                                                    color: const Color(0xff8A8D8E)),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                  height:
                                                                                                      getIt<Functions>().getWidgetHeight(height: 7)),
                                                                                              Text(
                                                                                                context
                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                    .singleTabGroupedItemsList[index][idx]
                                                                                                    .uom,
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 12),
                                                                                                    color: const Color(0xff282F3A)),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(
                                                                                              width: getIt<Functions>().getWidgetWidth(width: 60)),
                                                                                          Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Text(
                                                                                                getIt<Variables>()
                                                                                                    .generalVariables
                                                                                                    .currentLanguage
                                                                                                    .packageTerms
                                                                                                    .toUpperCase(),
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 12),
                                                                                                    color: const Color(0xff8A8D8E)),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                  height:
                                                                                                      getIt<Functions>().getWidgetHeight(height: 7)),
                                                                                              Text(
                                                                                                context
                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                    .singleTabGroupedItemsList[index][idx]
                                                                                                    .packageTerms,
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 12),
                                                                                                    color: const Color(0xff282F3A)),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                                      children: [
                                                                                        Text(
                                                                                          getIt<Functions>().formatNumber(
                                                                                              qty: context
                                                                                                  .read<WarehousePickupDetailBloc>()
                                                                                                  .singleTabGroupedItemsList[index][idx]
                                                                                                  .quantity),
                                                                                          style: TextStyle(
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                                              fontWeight: FontWeight.w600,
                                                                                              color: const Color(0xff007AFF)),
                                                                                        ),
                                                                                        Text(
                                                                                          getIt<Variables>()
                                                                                              .generalVariables
                                                                                              .currentLanguage
                                                                                              .qty
                                                                                              .toUpperCase(),
                                                                                          style: TextStyle(
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
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
                                                                        ),
                                                                        context
                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                        .catchWeightStatus ==
                                                                                    "No" ||
                                                                                (getIt<Functions>().getStringToList(
                                                                                        value: context
                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                            .singleTabGroupedItemsList[index][idx]
                                                                                            .catchWeightInfo,
                                                                                        quantity: context
                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                            .singleTabGroupedItemsList[index][idx]
                                                                                            .lineLoadedQty,
                                                                                        weightUnit: context
                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                            .singleTabGroupedItemsList[index][idx]
                                                                                            .uom))
                                                                                    .isEmpty
                                                                            ? const SizedBox()
                                                                            : Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Container(
                                                                                      decoration: const BoxDecoration(
                                                                                        color: Color(0xffCDE5FF),
                                                                                        borderRadius: BorderRadius.only(
                                                                                            bottomLeft: Radius.circular(8),
                                                                                            bottomRight: Radius.circular(8)),
                                                                                      ),
                                                                                      padding: EdgeInsets.only(
                                                                                          left: getIt<Functions>().getWidgetWidth(width: 12),
                                                                                          top: getIt<Functions>().getWidgetHeight(height: 8),
                                                                                          bottom: getIt<Functions>().getWidgetHeight(height: 8)),
                                                                                      child: Wrap(
                                                                                        children: List.generate(
                                                                                            (getIt<Functions>().getStringToList(
                                                                                                    value: context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                                        .catchWeightInfo,
                                                                                                    quantity: context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                                        .lineLoadedQty,
                                                                                                    weightUnit: context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                                        .uom))
                                                                                                .length,
                                                                                            (i) => i == 0
                                                                                                ? Padding(
                                                                                                    padding: const EdgeInsets.only(right: 10.0),
                                                                                                    child: SvgPicture.asset(
                                                                                                      "assets/catch_weight/measurement.svg",
                                                                                                      height: getIt<Functions>()
                                                                                                          .getWidgetHeight(height: 20),
                                                                                                      width: getIt<Functions>()
                                                                                                          .getWidgetWidth(width: 20),
                                                                                                      fit: BoxFit.fill,
                                                                                                    ),
                                                                                                  )
                                                                                                : i == 1
                                                                                                    ? Container(
                                                                                                        height: getIt<Functions>()
                                                                                                            .getWidgetHeight(height: 20),
                                                                                                        padding: EdgeInsets.symmetric(
                                                                                                            horizontal: getIt<Functions>()
                                                                                                                .getWidgetWidth(width: 8)),
                                                                                                        child: Text(
                                                                                                          "${(getIt<Functions>().getStringToList(value: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].catchWeightInfo, quantity: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].quantity, weightUnit: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].uom))[i]}  : ",
                                                                                                          style: TextStyle(
                                                                                                              fontSize: getIt<Functions>()
                                                                                                                  .getTextSize(fontSize: 12),
                                                                                                              fontWeight: FontWeight.w600,
                                                                                                              color: const Color(0xff282F3A)),
                                                                                                        ),
                                                                                                      )
                                                                                                    : Container(
                                                                                                        height: getIt<Functions>()
                                                                                                            .getWidgetHeight(height: 20),
                                                                                                        width: getIt<Functions>().getWidgetWidth(
                                                                                                            width: ((getIt<Functions>().getStringToList(
                                                                                                                            value: context
                                                                                                                                .read<
                                                                                                                                    WarehousePickupDetailBloc>()
                                                                                                                                .singleTabGroupedItemsList[
                                                                                                                                    index][idx]
                                                                                                                                .catchWeightInfo,
                                                                                                                            quantity: context
                                                                                                                                .read<
                                                                                                                                    WarehousePickupDetailBloc>()
                                                                                                                                .singleTabGroupedItemsList[
                                                                                                                                    index][idx]
                                                                                                                                .lineLoadedQty,
                                                                                                                            weightUnit: context
                                                                                                                                .read<
                                                                                                                                    WarehousePickupDetailBloc>()
                                                                                                                                .singleTabGroupedItemsList[
                                                                                                                                    index][idx]
                                                                                                                                .uom))[i]
                                                                                                                        .length *
                                                                                                                    7) +
                                                                                                                30),
                                                                                                        padding: EdgeInsets.symmetric(
                                                                                                            horizontal: getIt<Functions>()
                                                                                                                .getWidgetWidth(width: 12)),
                                                                                                        margin: EdgeInsets.only(
                                                                                                            left: getIt<Functions>()
                                                                                                                .getWidgetWidth(width: 6),
                                                                                                            bottom: getIt<Functions>()
                                                                                                                .getWidgetHeight(height: 2)),
                                                                                                        decoration: BoxDecoration(
                                                                                                          borderRadius: BorderRadius.circular(8),
                                                                                                          color: const Color(0xff7AA440),
                                                                                                        ),
                                                                                                        child: Center(
                                                                                                          child: Text(
                                                                                                            (getIt<Functions>().getStringToList(
                                                                                                                value: context
                                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                                    .singleTabGroupedItemsList[index]
                                                                                                                        [idx]
                                                                                                                    .catchWeightInfo,
                                                                                                                quantity: context
                                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                                    .singleTabGroupedItemsList[index]
                                                                                                                        [idx]
                                                                                                                    .lineLoadedQty,
                                                                                                                weightUnit: context
                                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                                    .singleTabGroupedItemsList[index]
                                                                                                                        [idx]
                                                                                                                    .uom))[i],
                                                                                                            style: TextStyle(
                                                                                                                fontSize: getIt<Functions>()
                                                                                                                    .getTextSize(fontSize: 12),
                                                                                                                fontWeight: FontWeight.w500,
                                                                                                                color: const Color(0xffffffff)),
                                                                                                          ),
                                                                                                        ),
                                                                                                      )),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(),
                                                                                ],
                                                                              ),
                                                                        idx ==
                                                                                context
                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                        .singleTabGroupedItemsList[index]
                                                                                        .length -
                                                                                    1
                                                                            ? const SizedBox()
                                                                            : const Divider(color: Color(0xffE0E7EC))
                                                                      ],
                                                                    ),
                                                                  );
                                                                }),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              ],
                                            ),
                                          ],
                                        ),
                                );
                              case 1:
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: getIt<Functions>().getWidgetWidth(width: 20), right: getIt<Functions>().getWidgetWidth(width: 20)),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                  child: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList.isEmpty &&
                                          context.read<WarehousePickupDetailBloc>().singleTabGroupingItemsList.isEmpty
                                      ? Stack(
                                          children: [
                                            SizedBox(
                                              width: getIt<Variables>().generalVariables.width,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
                                                  const CupertinoActivityIndicator(),
                                                ],
                                              ),
                                            ),
                                            ListView(
                                              padding: EdgeInsets.zero,
                                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                              controller: _deliveredEmptyController,
                                              children: [
                                                Container(
                                                  color: const Color(0xffEEF4FF),
                                                  child: Column(
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
                                                        getIt<Variables>().generalVariables.currentLanguage.warehouseListIsEmpty,
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w600),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Stack(
                                          children: [
                                            SizedBox(
                                              width: getIt<Variables>().generalVariables.width,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
                                                  const CupertinoActivityIndicator(),
                                                ],
                                              ),
                                            ),
                                            ListView(
                                              padding: EdgeInsets.zero,
                                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                              controller: _deliveredScrollController,
                                              children: [
                                                context.read<WarehousePickupDetailBloc>().singleTabGroupingItemsList.isEmpty
                                                    ? const SizedBox()
                                                    : ListView.builder(
                                                        padding: EdgeInsets.zero,
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        itemCount: context.read<WarehousePickupDetailBloc>().singleTabGroupingItemsList.length,
                                                        shrinkWrap: true,
                                                        itemBuilder: (BuildContext context, int index) {
                                                          return Container(
                                                            margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                            child: DottedBorder(
                                                              color:
                                                                  getIt<Variables>().generalVariables.userData.userProfile.userName.toLowerCase() ==
                                                                          context
                                                                              .read<WarehousePickupDetailBloc>()
                                                                              .groupedKeepersNameList[index]
                                                                              .toLowerCase()
                                                                      ? const Color(0xff34C759)
                                                                      : Colors.grey,
                                                              strokeWidth: 1,
                                                              borderType: BorderType.RRect,
                                                              dashPattern: const [6, 3],
                                                              radius: const Radius.circular(12),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                                margin: EdgeInsets.only(
                                                                    bottom: getIt<Functions>().getWidgetHeight(
                                                                        height: context
                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                    .singleTabGroupingItemsList
                                                                                    .length >
                                                                                1
                                                                            ? 20
                                                                            : 0)),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      height: getIt<Functions>().getWidgetHeight(height: 38),
                                                                      decoration: const BoxDecoration(
                                                                        color: Color(0xffE3E7EA),
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                                                      ),
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          RichText(
                                                                            text: TextSpan(
                                                                              text:
                                                                                  "${getIt<Variables>().generalVariables.currentLanguage.loadingBay} : ",
                                                                              style: TextStyle(
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A),
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontFamily: "overpassmono"),
                                                                              children: [
                                                                                TextSpan(
                                                                                    text:
                                                                                        '${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayDryName} / ${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayFrozenName}',
                                                                                    style: TextStyle(
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        color: const Color(0xff007AFF),
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontFamily: "overpassmono")),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    ListView.builder(
                                                                        padding: EdgeInsets.zero,
                                                                        physics: const NeverScrollableScrollPhysics(),
                                                                        shrinkWrap: true,
                                                                        itemCount: context
                                                                            .read<WarehousePickupDetailBloc>()
                                                                            .singleTabGroupingItemsList[index]
                                                                            .length,
                                                                        itemBuilder: (BuildContext context, int idx) {
                                                                          return InkWell(
                                                                            onTap: () {
                                                                              if (context
                                                                                      .read<WarehousePickupDetailBloc>()
                                                                                      .singleTabGroupingItemsList[index][idx]
                                                                                      .itemPickedStatus ==
                                                                                  "Picked") {
                                                                                getIt<Variables>().generalVariables.popUpWidget = yetToDeliverContent(
                                                                                    selectedItem: context
                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                        .singleTabGroupingItemsList[index][idx],
                                                                                    index: index,
                                                                                    idx: idx,
                                                                                    isDelivering: true);
                                                                                getIt<Functions>().showAnimatedDialog(
                                                                                    context: context, isFromTop: false, isCloseDisabled: false);
                                                                              } else {
                                                                                ScaffoldMessenger.of(context).clearSnackBars();
                                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                    content: Text(getIt<Variables>()
                                                                                        .generalVariables
                                                                                        .currentLanguage
                                                                                        .itemNotPicked)));
                                                                              }
                                                                            },
                                                                            child: Column(
                                                                              children: [
                                                                                Container(
                                                                                  padding: EdgeInsets.only(
                                                                                    left: getIt<Functions>().getWidgetWidth(width: 20),
                                                                                    right: getIt<Functions>().getWidgetWidth(width: 20),
                                                                                    top: getIt<Functions>().getWidgetHeight(height: 16),
                                                                                    bottom: getIt<Functions>().getWidgetHeight(height: 16),
                                                                                  ),
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          Container(
                                                                                              height: getIt<Functions>().getWidgetHeight(height: 28),
                                                                                              width: getIt<Functions>().getWidgetWidth(width: 28),
                                                                                              decoration: BoxDecoration(
                                                                                                shape: BoxShape.circle,
                                                                                                color: Color(int.parse(
                                                                                                    "0XFF${context.read<WarehousePickupDetailBloc>().singleTabGroupingItemsList[index][idx].typeColor}")),
                                                                                              ),
                                                                                              child: Center(
                                                                                                child: Text(
                                                                                                  context
                                                                                                      .read<WarehousePickupDetailBloc>()
                                                                                                      .singleTabGroupingItemsList[index][idx]
                                                                                                      .itemType,
                                                                                                  style: TextStyle(
                                                                                                      color: const Color(0xffffffff),
                                                                                                      fontSize: getIt<Functions>()
                                                                                                          .getTextSize(fontSize: 17),
                                                                                                      fontWeight: FontWeight.w700),
                                                                                                ),
                                                                                              )),
                                                                                          SizedBox(
                                                                                              width: getIt<Functions>().getWidgetWidth(width: 10)),
                                                                                          Expanded(
                                                                                            child: Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(
                                                                                                  context
                                                                                                      .read<WarehousePickupDetailBloc>()
                                                                                                      .singleTabGroupingItemsList[index][idx]
                                                                                                      .itemName,
                                                                                                  maxLines: 1,
                                                                                                  style: TextStyle(
                                                                                                      fontWeight: FontWeight.w600,
                                                                                                      fontSize: getIt<Functions>()
                                                                                                          .getTextSize(fontSize: 16),
                                                                                                      color: const Color(0xff282F3A),
                                                                                                      overflow: TextOverflow.ellipsis),
                                                                                                ),
                                                                                                Text(
                                                                                                  "${getIt<Variables>().generalVariables.currentLanguage.remarks} : ${context.read<WarehousePickupDetailBloc>().singleTabGroupingItemsList[index][idx].remarks}",
                                                                                                  maxLines: 1,
                                                                                                  style: TextStyle(
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                      fontSize: getIt<Functions>()
                                                                                                          .getTextSize(fontSize: 11),
                                                                                                      color: const Color(0xff6F6F6F),
                                                                                                      overflow: TextOverflow.ellipsis),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: getIt<Functions>().getWidgetHeight(height: 58),
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: ListView(
                                                                                                scrollDirection: Axis.horizontal,
                                                                                                physics: const BouncingScrollPhysics(),
                                                                                                shrinkWrap: true,
                                                                                                padding: EdgeInsets.zero,
                                                                                                children: [
                                                                                                  Column(
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        getIt<Variables>()
                                                                                                            .generalVariables
                                                                                                            .currentLanguage
                                                                                                            .itemCode
                                                                                                            .toUpperCase(),
                                                                                                        style: TextStyle(
                                                                                                            fontWeight: FontWeight.w500,
                                                                                                            fontSize: getIt<Functions>()
                                                                                                                .getTextSize(fontSize: 12),
                                                                                                            color: const Color(0xff8A8D8E)),
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                          height: getIt<Functions>()
                                                                                                              .getWidgetHeight(height: 7)),
                                                                                                      Text(
                                                                                                        context
                                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                                            .singleTabGroupingItemsList[index][idx]
                                                                                                            .itemCode,
                                                                                                        style: TextStyle(
                                                                                                            fontWeight: FontWeight.w600,
                                                                                                            fontSize: getIt<Functions>()
                                                                                                                .getTextSize(fontSize: 12),
                                                                                                            color: const Color(0xff282F3A)),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                      width: getIt<Functions>()
                                                                                                          .getWidgetWidth(width: 60)),
                                                                                                  Column(
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        getIt<Variables>()
                                                                                                            .generalVariables
                                                                                                            .currentLanguage
                                                                                                            .uom,
                                                                                                        style: TextStyle(
                                                                                                            fontWeight: FontWeight.w500,
                                                                                                            fontSize: getIt<Functions>()
                                                                                                                .getTextSize(fontSize: 12),
                                                                                                            color: const Color(0xff8A8D8E)),
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                          height: getIt<Functions>()
                                                                                                              .getWidgetHeight(height: 7)),
                                                                                                      Text(
                                                                                                        context
                                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                                            .singleTabGroupingItemsList[index][idx]
                                                                                                            .uom,
                                                                                                        style: TextStyle(
                                                                                                            fontWeight: FontWeight.w600,
                                                                                                            fontSize: getIt<Functions>()
                                                                                                                .getTextSize(fontSize: 12),
                                                                                                            color: const Color(0xff282F3A)),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                      width: getIt<Functions>()
                                                                                                          .getWidgetWidth(width: 60)),
                                                                                                  Column(
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        getIt<Variables>()
                                                                                                            .generalVariables
                                                                                                            .currentLanguage
                                                                                                            .packageTerms
                                                                                                            .toUpperCase(),
                                                                                                        style: TextStyle(
                                                                                                            fontWeight: FontWeight.w500,
                                                                                                            fontSize: getIt<Functions>()
                                                                                                                .getTextSize(fontSize: 12),
                                                                                                            color: const Color(0xff8A8D8E)),
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                          height: getIt<Functions>()
                                                                                                              .getWidgetHeight(height: 7)),
                                                                                                      Text(
                                                                                                        context
                                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                                            .singleTabGroupingItemsList[index][idx]
                                                                                                            .packageTerms,
                                                                                                        style: TextStyle(
                                                                                                            fontWeight: FontWeight.w600,
                                                                                                            fontSize: getIt<Functions>()
                                                                                                                .getTextSize(fontSize: 12),
                                                                                                            color: const Color(0xff282F3A)),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                      width: getIt<Functions>()
                                                                                                          .getWidgetWidth(width: 60)),
                                                                                                  Column(
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        getIt<Variables>()
                                                                                                            .generalVariables
                                                                                                            .currentLanguage
                                                                                                            .sorter
                                                                                                            .toUpperCase(),
                                                                                                        style: TextStyle(
                                                                                                            fontWeight: FontWeight.w500,
                                                                                                            fontSize: getIt<Functions>()
                                                                                                                .getTextSize(fontSize: 12),
                                                                                                            color: const Color(0xff8A8D8E)),
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                          height: getIt<Functions>()
                                                                                                              .getWidgetHeight(height: 7)),
                                                                                                      context
                                                                                                              .read<WarehousePickupDetailBloc>()
                                                                                                              .singleTabGroupingItemsList[index][idx]
                                                                                                              .handledBy
                                                                                                              .isNotEmpty
                                                                                                          ? Text(
                                                                                                              context
                                                                                                                  .read<WarehousePickupDetailBloc>()
                                                                                                                  .singleTabGroupingItemsList[index]
                                                                                                                      [idx]
                                                                                                                  .handledBy[0]
                                                                                                                  .name,
                                                                                                              style: TextStyle(
                                                                                                                  fontWeight: FontWeight.w600,
                                                                                                                  fontSize: getIt<Functions>()
                                                                                                                      .getTextSize(fontSize: 12),
                                                                                                                  color: const Color(0xff282F3A)),
                                                                                                            )
                                                                                                          : const SizedBox(),
                                                                                                    ],
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                                              children: [
                                                                                                Text(
                                                                                                  getIt<Functions>().formatNumber(
                                                                                                      qty: context
                                                                                                          .read<WarehousePickupDetailBloc>()
                                                                                                          .singleTabGroupingItemsList[index][idx]
                                                                                                          .lineLoadedQty),
                                                                                                  style: TextStyle(
                                                                                                      fontSize: getIt<Functions>()
                                                                                                          .getTextSize(fontSize: 28),
                                                                                                      fontWeight: FontWeight.w600,
                                                                                                      color: const Color(0xff007838)),
                                                                                                ),
                                                                                                Text(
                                                                                                  getIt<Variables>()
                                                                                                      .generalVariables
                                                                                                      .currentLanguage
                                                                                                      .loadedQty
                                                                                                      .toUpperCase(),
                                                                                                  style: TextStyle(
                                                                                                      fontSize: getIt<Functions>()
                                                                                                          .getTextSize(fontSize: 12),
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
                                                                                ),
                                                                                context
                                                                                                .read<WarehousePickupDetailBloc>()
                                                                                                .singleTabGroupingItemsList[index][idx]
                                                                                                .catchWeightStatus ==
                                                                                            "No" ||
                                                                                        (getIt<Functions>().getStringToList(
                                                                                                value: context
                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                    .singleTabGroupingItemsList[index][idx]
                                                                                                    .catchWeightInfo,
                                                                                                quantity: context
                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                    .singleTabGroupingItemsList[index][idx]
                                                                                                    .lineLoadedQty,
                                                                                                weightUnit: context
                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                    .singleTabGroupingItemsList[index][idx]
                                                                                                    .uom))
                                                                                            .isEmpty
                                                                                    ? const SizedBox()
                                                                                    : Row(
                                                                                        children: [
                                                                                          Expanded(
                                                                                            child: Container(
                                                                                              decoration: const BoxDecoration(
                                                                                                color: Color(0xffCDE5FF),
                                                                                                borderRadius: BorderRadius.only(
                                                                                                    bottomLeft: Radius.circular(8),
                                                                                                    bottomRight: Radius.circular(8)),
                                                                                              ),
                                                                                              padding: EdgeInsets.only(
                                                                                                  left: getIt<Functions>().getWidgetWidth(width: 12),
                                                                                                  top: getIt<Functions>().getWidgetHeight(height: 8),
                                                                                                  bottom:
                                                                                                      getIt<Functions>().getWidgetHeight(height: 8)),
                                                                                              child: Wrap(
                                                                                                children: List.generate(
                                                                                                    (getIt<Functions>().getStringToList(
                                                                                                            value: context
                                                                                                                .read<WarehousePickupDetailBloc>()
                                                                                                                .singleTabGroupingItemsList[index]
                                                                                                                    [idx]
                                                                                                                .catchWeightInfo,
                                                                                                            quantity: context
                                                                                                                .read<WarehousePickupDetailBloc>()
                                                                                                                .singleTabGroupingItemsList[index]
                                                                                                                    [idx]
                                                                                                                .lineLoadedQty,
                                                                                                            weightUnit: context
                                                                                                                .read<WarehousePickupDetailBloc>()
                                                                                                                .singleTabGroupingItemsList[index]
                                                                                                                    [idx]
                                                                                                                .uom))
                                                                                                        .length,
                                                                                                    (i) => i == 0
                                                                                                        ? Padding(
                                                                                                            padding:
                                                                                                                const EdgeInsets.only(right: 10.0),
                                                                                                            child: SvgPicture.asset(
                                                                                                              "assets/catch_weight/measurement.svg",
                                                                                                              height: getIt<Functions>()
                                                                                                                  .getWidgetHeight(height: 20),
                                                                                                              width: getIt<Functions>()
                                                                                                                  .getWidgetWidth(width: 20),
                                                                                                              fit: BoxFit.fill,
                                                                                                            ),
                                                                                                          )
                                                                                                        : i == 1
                                                                                                            ? Container(
                                                                                                                height: getIt<Functions>()
                                                                                                                    .getWidgetHeight(height: 20),
                                                                                                                padding: EdgeInsets.symmetric(
                                                                                                                    horizontal: getIt<Functions>()
                                                                                                                        .getWidgetWidth(width: 8)),
                                                                                                                child: Text(
                                                                                                                  (getIt<Functions>().getStringToList(
                                                                                                                      value: context
                                                                                                                          .read<
                                                                                                                              WarehousePickupDetailBloc>()
                                                                                                                          .singleTabGroupingItemsList[
                                                                                                                              index][idx]
                                                                                                                          .catchWeightInfo,
                                                                                                                      quantity: context
                                                                                                                          .read<
                                                                                                                              WarehousePickupDetailBloc>()
                                                                                                                          .singleTabGroupingItemsList[
                                                                                                                              index][idx]
                                                                                                                          .lineLoadedQty,
                                                                                                                      weightUnit: context
                                                                                                                          .read<
                                                                                                                              WarehousePickupDetailBloc>()
                                                                                                                          .singleTabGroupingItemsList[
                                                                                                                              index][idx]
                                                                                                                          .uom))[i],
                                                                                                                  style: TextStyle(
                                                                                                                      fontSize: getIt<Functions>()
                                                                                                                          .getTextSize(fontSize: 12),
                                                                                                                      fontWeight: FontWeight.w600,
                                                                                                                      color: const Color(0xff282F3A)),
                                                                                                                ),
                                                                                                              )
                                                                                                            : Container(
                                                                                                                height: getIt<Functions>()
                                                                                                                    .getWidgetHeight(height: 20),
                                                                                                                width: getIt<Functions>().getWidgetWidth(
                                                                                                                    width: ((getIt<Functions>().getStringToList(
                                                                                                                                    value: context
                                                                                                                                        .read<
                                                                                                                                            WarehousePickupDetailBloc>()
                                                                                                                                        .singleTabGroupingItemsList[
                                                                                                                                            index]
                                                                                                                                            [idx]
                                                                                                                                        .catchWeightInfo,
                                                                                                                                    quantity: context
                                                                                                                                        .read<
                                                                                                                                            WarehousePickupDetailBloc>()
                                                                                                                                        .singleTabGroupingItemsList[
                                                                                                                                            index]
                                                                                                                                            [idx]
                                                                                                                                        .lineLoadedQty,
                                                                                                                                    weightUnit: context
                                                                                                                                        .read<
                                                                                                                                            WarehousePickupDetailBloc>()
                                                                                                                                        .singleTabGroupingItemsList[
                                                                                                                                            index]
                                                                                                                                            [idx]
                                                                                                                                        .uom))[i]
                                                                                                                                .length *
                                                                                                                            7) +
                                                                                                                        30),
                                                                                                                padding: EdgeInsets.symmetric(
                                                                                                                    horizontal: getIt<Functions>()
                                                                                                                        .getWidgetWidth(width: 12)),
                                                                                                                margin: EdgeInsets.only(
                                                                                                                    left: getIt<Functions>()
                                                                                                                        .getWidgetWidth(width: 6),
                                                                                                                    bottom: getIt<Functions>()
                                                                                                                        .getWidgetHeight(height: 2)),
                                                                                                                decoration: BoxDecoration(
                                                                                                                  borderRadius:
                                                                                                                      BorderRadius.circular(8),
                                                                                                                  color: const Color(0xff7AA440),
                                                                                                                ),
                                                                                                                child: Center(
                                                                                                                  child: Text(
                                                                                                                    (getIt<Functions>().getStringToList(
                                                                                                                        value: context
                                                                                                                            .read<
                                                                                                                                WarehousePickupDetailBloc>()
                                                                                                                            .singleTabGroupingItemsList[
                                                                                                                                index][idx]
                                                                                                                            .catchWeightInfo,
                                                                                                                        quantity: context
                                                                                                                            .read<
                                                                                                                                WarehousePickupDetailBloc>()
                                                                                                                            .singleTabGroupingItemsList[
                                                                                                                                index][idx]
                                                                                                                            .lineLoadedQty,
                                                                                                                        weightUnit: context
                                                                                                                            .read<
                                                                                                                                WarehousePickupDetailBloc>()
                                                                                                                            .singleTabGroupingItemsList[
                                                                                                                                index][idx]
                                                                                                                            .uom))[i],
                                                                                                                    style: TextStyle(
                                                                                                                        fontSize: getIt<Functions>()
                                                                                                                            .getTextSize(
                                                                                                                                fontSize: 12),
                                                                                                                        fontWeight: FontWeight.w500,
                                                                                                                        color:
                                                                                                                            const Color(0xffffffff)),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              )),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(),
                                                                                        ],
                                                                                      ),
                                                                                idx ==
                                                                                        context
                                                                                                .read<WarehousePickupDetailBloc>()
                                                                                                .singleTabGroupingItemsList[index]
                                                                                                .length -
                                                                                            1
                                                                                    ? const SizedBox()
                                                                                    : const Divider(color: Color(0xffE0E7EC))
                                                                              ],
                                                                            ),
                                                                          );
                                                                        }),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList.isEmpty
                                                    ? const SizedBox()
                                                    : ListView.builder(
                                                        padding: EdgeInsets.zero,
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        itemCount: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList.length,
                                                        shrinkWrap: true,
                                                        itemBuilder: (BuildContext context, int index) {
                                                          return Container(
                                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                            margin: EdgeInsets.only(
                                                                bottom: getIt<Functions>().getWidgetHeight(
                                                                    height:
                                                                        context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList.length > 1
                                                                            ? 20
                                                                            : 0)),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                  height: getIt<Functions>().getWidgetHeight(height: 38),
                                                                  decoration: const BoxDecoration(
                                                                    color: Color(0xffE3E7EA),
                                                                    borderRadius:
                                                                        BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                                                  ),
                                                                  padding:
                                                                      EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      RichText(
                                                                        text: TextSpan(
                                                                          text:
                                                                              "${getIt<Variables>().generalVariables.currentLanguage.loadingBay} : ",
                                                                          style: TextStyle(
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A),
                                                                              fontWeight: FontWeight.w600,
                                                                              fontFamily: "overpassmono"),
                                                                          children: [
                                                                            TextSpan(
                                                                                text:
                                                                                    '${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayDryName} / ${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayFrozenName}',
                                                                                style: TextStyle(
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff007AFF),
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontFamily: "overpassmono")),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                ListView.builder(
                                                                    padding: EdgeInsets.zero,
                                                                    physics: const NeverScrollableScrollPhysics(),
                                                                    shrinkWrap: true,
                                                                    itemCount: context
                                                                        .read<WarehousePickupDetailBloc>()
                                                                        .singleTabGroupedItemsList[index]
                                                                        .length,
                                                                    itemBuilder: (BuildContext context, int idx) {
                                                                      return InkWell(
                                                                        onTap: () {
                                                                          if (context
                                                                                  .read<WarehousePickupDetailBloc>()
                                                                                  .singleTabGroupedItemsList[index][idx]
                                                                                  .itemPickedStatus ==
                                                                              "Picked") {
                                                                            getIt<Variables>().generalVariables.popUpWidget = yetToDeliverContent(
                                                                                selectedItem: context
                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                    .singleTabGroupedItemsList[index][idx],
                                                                                index: index,
                                                                                idx: idx,
                                                                                isDelivering: false);
                                                                            getIt<Functions>().showAnimatedDialog(
                                                                                context: context, isFromTop: false, isCloseDisabled: false);
                                                                          } else {
                                                                            ScaffoldMessenger.of(context).clearSnackBars();
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                content: Text(getIt<Variables>()
                                                                                    .generalVariables
                                                                                    .currentLanguage
                                                                                    .itemNotPicked)));
                                                                          }
                                                                        },
                                                                        child: Column(
                                                                          children: [
                                                                            Container(
                                                                              padding: EdgeInsets.only(
                                                                                left: getIt<Functions>().getWidgetWidth(width: 20),
                                                                                right: getIt<Functions>().getWidgetWidth(width: 20),
                                                                                top: getIt<Functions>().getWidgetHeight(height: 16),
                                                                                bottom: getIt<Functions>().getWidgetHeight(height: 16),
                                                                              ),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Container(
                                                                                          height: getIt<Functions>().getWidgetHeight(height: 28),
                                                                                          width: getIt<Functions>().getWidgetWidth(width: 28),
                                                                                          decoration: BoxDecoration(
                                                                                            shape: BoxShape.circle,
                                                                                            color: Color(int.parse(
                                                                                                "0XFF${context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].typeColor}")),
                                                                                          ),
                                                                                          child: Center(
                                                                                            child: Text(
                                                                                              context
                                                                                                  .read<WarehousePickupDetailBloc>()
                                                                                                  .singleTabGroupedItemsList[index][idx]
                                                                                                  .itemType,
                                                                                              style: TextStyle(
                                                                                                  color: const Color(0xffffffff),
                                                                                                  fontSize:
                                                                                                      getIt<Functions>().getTextSize(fontSize: 17),
                                                                                                  fontWeight: FontWeight.w700),
                                                                                            ),
                                                                                          )),
                                                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 10)),
                                                                                      Expanded(
                                                                                        child: Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text(
                                                                                              context
                                                                                                  .read<WarehousePickupDetailBloc>()
                                                                                                  .singleTabGroupedItemsList[index][idx]
                                                                                                  .itemName,
                                                                                              maxLines: 1,
                                                                                              style: TextStyle(
                                                                                                  fontWeight: FontWeight.w600,
                                                                                                  fontSize:
                                                                                                      getIt<Functions>().getTextSize(fontSize: 16),
                                                                                                  color: const Color(0xff282F3A),
                                                                                                  overflow: TextOverflow.ellipsis),
                                                                                            ),
                                                                                            Text(
                                                                                              "${getIt<Variables>().generalVariables.currentLanguage.remarks} : ${context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].remarks}",
                                                                                              maxLines: 1,
                                                                                              style: TextStyle(
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  fontSize:
                                                                                                      getIt<Functions>().getTextSize(fontSize: 11),
                                                                                                  color: const Color(0xff6F6F6F),
                                                                                                  overflow: TextOverflow.ellipsis),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: getIt<Functions>().getWidgetHeight(height: 58),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: ListView(
                                                                                            scrollDirection: Axis.horizontal,
                                                                                            physics: const BouncingScrollPhysics(),
                                                                                            shrinkWrap: true,
                                                                                            padding: EdgeInsets.zero,
                                                                                            children: [
                                                                                              Column(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    getIt<Variables>()
                                                                                                        .generalVariables
                                                                                                        .currentLanguage
                                                                                                        .itemCode
                                                                                                        .toUpperCase(),
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        fontSize: getIt<Functions>()
                                                                                                            .getTextSize(fontSize: 12),
                                                                                                        color: const Color(0xff8A8D8E)),
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                      height: getIt<Functions>()
                                                                                                          .getWidgetHeight(height: 7)),
                                                                                                  Text(
                                                                                                    context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                                        .itemCode,
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        fontSize: getIt<Functions>()
                                                                                                            .getTextSize(fontSize: 12),
                                                                                                        color: const Color(0xff282F3A)),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              SizedBox(
                                                                                                  width:
                                                                                                      getIt<Functions>().getWidgetWidth(width: 60)),
                                                                                              Column(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    getIt<Variables>()
                                                                                                        .generalVariables
                                                                                                        .currentLanguage
                                                                                                        .uom,
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        fontSize: getIt<Functions>()
                                                                                                            .getTextSize(fontSize: 12),
                                                                                                        color: const Color(0xff8A8D8E)),
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                      height: getIt<Functions>()
                                                                                                          .getWidgetHeight(height: 7)),
                                                                                                  Text(
                                                                                                    context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                                        .uom,
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        fontSize: getIt<Functions>()
                                                                                                            .getTextSize(fontSize: 12),
                                                                                                        color: const Color(0xff282F3A)),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              SizedBox(
                                                                                                  width:
                                                                                                      getIt<Functions>().getWidgetWidth(width: 60)),
                                                                                              Column(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    getIt<Variables>()
                                                                                                        .generalVariables
                                                                                                        .currentLanguage
                                                                                                        .packageTerms
                                                                                                        .toUpperCase(),
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        fontSize: getIt<Functions>()
                                                                                                            .getTextSize(fontSize: 12),
                                                                                                        color: const Color(0xff8A8D8E)),
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                      height: getIt<Functions>()
                                                                                                          .getWidgetHeight(height: 7)),
                                                                                                  Text(
                                                                                                    context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                                        .packageTerms,
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        fontSize: getIt<Functions>()
                                                                                                            .getTextSize(fontSize: 12),
                                                                                                        color: const Color(0xff282F3A)),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              SizedBox(
                                                                                                  width:
                                                                                                      getIt<Functions>().getWidgetWidth(width: 60)),
                                                                                              Column(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    getIt<Variables>()
                                                                                                        .generalVariables
                                                                                                        .currentLanguage
                                                                                                        .sorter
                                                                                                        .toUpperCase(),
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        fontSize: getIt<Functions>()
                                                                                                            .getTextSize(fontSize: 12),
                                                                                                        color: const Color(0xff8A8D8E)),
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                      height: getIt<Functions>()
                                                                                                          .getWidgetHeight(height: 7)),
                                                                                                  context
                                                                                                          .read<WarehousePickupDetailBloc>()
                                                                                                          .singleTabGroupedItemsList[index][idx]
                                                                                                          .handledBy
                                                                                                          .isNotEmpty
                                                                                                      ? Text(
                                                                                                          context
                                                                                                              .read<WarehousePickupDetailBloc>()
                                                                                                              .singleTabGroupedItemsList[index][idx]
                                                                                                              .handledBy[0]
                                                                                                              .name,
                                                                                                          style: TextStyle(
                                                                                                              fontWeight: FontWeight.w600,
                                                                                                              fontSize: getIt<Functions>()
                                                                                                                  .getTextSize(fontSize: 12),
                                                                                                              color: const Color(0xff282F3A)),
                                                                                                        )
                                                                                                      : const SizedBox(),
                                                                                                ],
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                                          children: [
                                                                                            Text(
                                                                                              getIt<Functions>().formatNumber(
                                                                                                  qty: context
                                                                                                      .read<WarehousePickupDetailBloc>()
                                                                                                      .singleTabGroupedItemsList[index][idx]
                                                                                                      .lineLoadedQty),
                                                                                              style: TextStyle(
                                                                                                  fontSize:
                                                                                                      getIt<Functions>().getTextSize(fontSize: 28),
                                                                                                  fontWeight: FontWeight.w600,
                                                                                                  color: const Color(0xff007838)),
                                                                                            ),
                                                                                            Text(
                                                                                              getIt<Variables>()
                                                                                                  .generalVariables
                                                                                                  .currentLanguage
                                                                                                  .loadedQty
                                                                                                  .toUpperCase(),
                                                                                              style: TextStyle(
                                                                                                  fontSize:
                                                                                                      getIt<Functions>().getTextSize(fontSize: 12),
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
                                                                            ),
                                                                            context
                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                            .singleTabGroupedItemsList[index][idx]
                                                                                            .catchWeightStatus ==
                                                                                        "No" ||
                                                                                    (getIt<Functions>().getStringToList(
                                                                                            value: context
                                                                                                .read<WarehousePickupDetailBloc>()
                                                                                                .singleTabGroupedItemsList[index][idx]
                                                                                                .catchWeightInfo,
                                                                                            quantity: context
                                                                                                .read<WarehousePickupDetailBloc>()
                                                                                                .singleTabGroupedItemsList[index][idx]
                                                                                                .lineLoadedQty,
                                                                                            weightUnit: context
                                                                                                .read<WarehousePickupDetailBloc>()
                                                                                                .singleTabGroupedItemsList[index][idx]
                                                                                                .uom))
                                                                                        .isEmpty
                                                                                ? const SizedBox()
                                                                                : Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: Container(
                                                                                          decoration: const BoxDecoration(
                                                                                            color: Color(0xffCDE5FF),
                                                                                            borderRadius: BorderRadius.only(
                                                                                                bottomLeft: Radius.circular(8),
                                                                                                bottomRight: Radius.circular(8)),
                                                                                          ),
                                                                                          padding: EdgeInsets.only(
                                                                                              left: getIt<Functions>().getWidgetWidth(width: 12),
                                                                                              top: getIt<Functions>().getWidgetHeight(height: 8),
                                                                                              bottom: getIt<Functions>().getWidgetHeight(height: 8)),
                                                                                          child: Wrap(
                                                                                            children: List.generate(
                                                                                                (getIt<Functions>().getStringToList(
                                                                                                        value: context
                                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                                            .singleTabGroupedItemsList[index][idx]
                                                                                                            .catchWeightInfo,
                                                                                                        quantity: context
                                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                                            .singleTabGroupedItemsList[index][idx]
                                                                                                            .lineLoadedQty,
                                                                                                        weightUnit: context
                                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                                            .singleTabGroupedItemsList[index][idx]
                                                                                                            .uom))
                                                                                                    .length,
                                                                                                (i) => i == 0
                                                                                                    ? Padding(
                                                                                                        padding: const EdgeInsets.only(right: 10.0),
                                                                                                        child: SvgPicture.asset(
                                                                                                          "assets/catch_weight/measurement.svg",
                                                                                                          height: getIt<Functions>()
                                                                                                              .getWidgetHeight(height: 20),
                                                                                                          width: getIt<Functions>()
                                                                                                              .getWidgetWidth(width: 20),
                                                                                                          fit: BoxFit.fill,
                                                                                                        ),
                                                                                                      )
                                                                                                    : i == 1
                                                                                                        ? Container(
                                                                                                            height: getIt<Functions>()
                                                                                                                .getWidgetHeight(height: 20),
                                                                                                            padding: EdgeInsets.symmetric(
                                                                                                                horizontal: getIt<Functions>()
                                                                                                                    .getWidgetWidth(width: 8)),
                                                                                                            child: Text(
                                                                                                              (getIt<Functions>().getStringToList(
                                                                                                                  value: context
                                                                                                                      .read<
                                                                                                                          WarehousePickupDetailBloc>()
                                                                                                                      .singleTabGroupedItemsList[
                                                                                                                          index][idx]
                                                                                                                      .catchWeightInfo,
                                                                                                                  quantity: context
                                                                                                                      .read<
                                                                                                                          WarehousePickupDetailBloc>()
                                                                                                                      .singleTabGroupedItemsList[
                                                                                                                          index][idx]
                                                                                                                      .lineLoadedQty,
                                                                                                                  weightUnit: context
                                                                                                                      .read<
                                                                                                                          WarehousePickupDetailBloc>()
                                                                                                                      .singleTabGroupedItemsList[
                                                                                                                          index][idx]
                                                                                                                      .uom))[i],
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: getIt<Functions>()
                                                                                                                      .getTextSize(fontSize: 12),
                                                                                                                  fontWeight: FontWeight.w600,
                                                                                                                  color: const Color(0xff282F3A)),
                                                                                                            ),
                                                                                                          )
                                                                                                        : Container(
                                                                                                            height: getIt<Functions>()
                                                                                                                .getWidgetHeight(height: 20),
                                                                                                            width: getIt<Functions>().getWidgetWidth(
                                                                                                                width: ((getIt<Functions>().getStringToList(
                                                                                                                                value: context
                                                                                                                                    .read<
                                                                                                                                        WarehousePickupDetailBloc>()
                                                                                                                                    .singleTabGroupedItemsList[
                                                                                                                                        index][idx]
                                                                                                                                    .catchWeightInfo,
                                                                                                                                quantity: context
                                                                                                                                    .read<
                                                                                                                                        WarehousePickupDetailBloc>()
                                                                                                                                    .singleTabGroupedItemsList[
                                                                                                                                        index][idx]
                                                                                                                                    .lineLoadedQty,
                                                                                                                                weightUnit: context
                                                                                                                                    .read<
                                                                                                                                        WarehousePickupDetailBloc>()
                                                                                                                                    .singleTabGroupedItemsList[
                                                                                                                                        index][idx]
                                                                                                                                    .uom))[i]
                                                                                                                            .length *
                                                                                                                        7) +
                                                                                                                    30),
                                                                                                            padding: EdgeInsets.symmetric(
                                                                                                                horizontal: getIt<Functions>()
                                                                                                                    .getWidgetWidth(width: 12)),
                                                                                                            margin: EdgeInsets.only(
                                                                                                                left: getIt<Functions>()
                                                                                                                    .getWidgetWidth(width: 6),
                                                                                                                bottom: getIt<Functions>()
                                                                                                                    .getWidgetHeight(height: 2)),
                                                                                                            decoration: BoxDecoration(
                                                                                                              borderRadius: BorderRadius.circular(8),
                                                                                                              color: const Color(0xff7AA440),
                                                                                                            ),
                                                                                                            child: Center(
                                                                                                              child: Text(
                                                                                                                (getIt<Functions>().getStringToList(
                                                                                                                    value: context
                                                                                                                        .read<
                                                                                                                            WarehousePickupDetailBloc>()
                                                                                                                        .singleTabGroupedItemsList[
                                                                                                                            index][idx]
                                                                                                                        .catchWeightInfo,
                                                                                                                    quantity: context
                                                                                                                        .read<
                                                                                                                            WarehousePickupDetailBloc>()
                                                                                                                        .singleTabGroupedItemsList[
                                                                                                                            index][idx]
                                                                                                                        .lineLoadedQty,
                                                                                                                    weightUnit: context
                                                                                                                        .read<
                                                                                                                            WarehousePickupDetailBloc>()
                                                                                                                        .singleTabGroupedItemsList[
                                                                                                                            index][idx]
                                                                                                                        .uom))[i],
                                                                                                                style: TextStyle(
                                                                                                                    fontSize: getIt<Functions>()
                                                                                                                        .getTextSize(fontSize: 12),
                                                                                                                    fontWeight: FontWeight.w500,
                                                                                                                    color: const Color(0xffffffff)),
                                                                                                              ),
                                                                                                            ),
                                                                                                          )),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(),
                                                                                    ],
                                                                                  ),
                                                                            idx ==
                                                                                    context
                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                            .singleTabGroupedItemsList[index]
                                                                                            .length -
                                                                                        1
                                                                                ? const SizedBox()
                                                                                : const Divider(color: Color(0xffE0E7EC))
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }),
                                                              ],
                                                            ),
                                                          );
                                                        }),
                                              ],
                                            ),
                                          ],
                                        ),
                                );
                              case 2:
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: getIt<Functions>().getWidgetWidth(width: 20), right: getIt<Functions>().getWidgetWidth(width: 20)),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                  child: context.read<WarehousePickupDetailBloc>().singleTabItemsList.isEmpty
                                      ? Stack(
                                          children: [
                                            SizedBox(
                                              width: getIt<Variables>().generalVariables.width,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
                                                  const CupertinoActivityIndicator(),
                                                ],
                                              ),
                                            ),
                                            ListView(
                                              padding: EdgeInsets.zero,
                                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                              controller: _unavailableScrollController,
                                              children: [
                                                Container(
                                                  color: const Color(0xffEEF4FF),
                                                  child: Column(
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
                                                        getIt<Variables>().generalVariables.currentLanguage.warehouseListIsEmpty,
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w600),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Stack(
                                          children: [
                                            SizedBox(
                                              width: getIt<Variables>().generalVariables.width,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
                                                  const CupertinoActivityIndicator(),
                                                ],
                                              ),
                                            ),
                                            ListView(
                                              padding: EdgeInsets.zero,
                                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                              controller: _unavailableEmptyController,
                                              children: [
                                                ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: context.read<WarehousePickupDetailBloc>().singleTabItemsList.length,
                                                    itemBuilder: (BuildContext context, int idx) {
                                                      return InkWell(
                                                        onTap: () {
                                                          if (context.read<WarehousePickupDetailBloc>().singleTabItemsList[idx].itemPickedStatus ==
                                                              "Picked") {
                                                            getIt<Variables>().generalVariables.popUpWidget = yetToDeliverContent(
                                                                selectedItem: context.read<WarehousePickupDetailBloc>().singleTabItemsList[idx],
                                                                index: idx,
                                                                idx: idx,
                                                                isDelivering: false);
                                                            getIt<Functions>()
                                                                .showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                                          } else {
                                                            ScaffoldMessenger.of(context).clearSnackBars();
                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                content: Text(getIt<Variables>().generalVariables.currentLanguage.itemNotPicked)));
                                                          }
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: getIt<Functions>().getWidgetHeight(height: 38),
                                                              decoration: const BoxDecoration(
                                                                color: Color(0xffE3E7EA),
                                                                borderRadius:
                                                                    BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                                              ),
                                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  RichText(
                                                                    text: TextSpan(
                                                                      text: "${getIt<Variables>().generalVariables.currentLanguage.loadingBay} : ",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          color: const Color(0xff282F3A),
                                                                          fontWeight: FontWeight.w600,
                                                                          fontFamily: "overpassmono"),
                                                                      children: [
                                                                        TextSpan(
                                                                            text:
                                                                                '${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayDryName} / ${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayFrozenName}',
                                                                            style: TextStyle(
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                color: const Color(0xff007AFF),
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: "overpassmono")),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  RichText(
                                                                    text: TextSpan(
                                                                      text:
                                                                          "${getIt<Variables>().generalVariables.currentLanguage.reason.toUpperCase()} : ",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          color: const Color(0xff282F3A),
                                                                          fontWeight: FontWeight.w600,
                                                                          fontFamily: "overpassmono"),
                                                                      children: [
                                                                        TextSpan(
                                                                            text: context
                                                                                .read<WarehousePickupDetailBloc>()
                                                                                .singleTabItemsList[idx]
                                                                                .itemLoadedUnavailableReason
                                                                                .toUpperCase(),
                                                                            style: TextStyle(
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                color: const Color(0xffDC4748),
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: "overpassmono")),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.only(
                                                                left: getIt<Functions>().getWidgetWidth(width: 20),
                                                                right: getIt<Functions>().getWidgetWidth(width: 20),
                                                                top: getIt<Functions>().getWidgetHeight(height: 16),
                                                                bottom: getIt<Functions>().getWidgetHeight(height: 16),
                                                              ),
                                                              decoration: const BoxDecoration(
                                                                color: Color(0xffFFFFFF),
                                                                borderRadius: BorderRadius.only(
                                                                    bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Container(
                                                                          height: getIt<Functions>().getWidgetHeight(height: 28),
                                                                          width: getIt<Functions>().getWidgetWidth(width: 28),
                                                                          decoration: BoxDecoration(
                                                                            shape: BoxShape.circle,
                                                                            color: Color(int.parse(
                                                                                "0XFF${context.read<WarehousePickupDetailBloc>().singleTabItemsList[idx].typeColor}")),
                                                                          ),
                                                                          child: Center(
                                                                            child: Text(
                                                                              context
                                                                                  .read<WarehousePickupDetailBloc>()
                                                                                  .singleTabItemsList[idx]
                                                                                  .itemType,
                                                                              style: TextStyle(
                                                                                  color: const Color(0xffffffff),
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                                  fontWeight: FontWeight.w700),
                                                                            ),
                                                                          )),
                                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 10)),
                                                                      Expanded(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              context
                                                                                  .read<WarehousePickupDetailBloc>()
                                                                                  .singleTabItemsList[idx]
                                                                                  .itemName,
                                                                              maxLines: 1,
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                  color: const Color(0xff282F3A),
                                                                                  overflow: TextOverflow.ellipsis),
                                                                            ),
                                                                            Text(
                                                                              "${getIt<Variables>().generalVariables.currentLanguage.remarks} : ${context.read<WarehousePickupDetailBloc>().singleTabItemsList[idx].remarks}",
                                                                              maxLines: 1,
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                  color: const Color(0xff6F6F6F),
                                                                                  overflow: TextOverflow.ellipsis),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                  ),
                                                                  SizedBox(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 58),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Expanded(
                                                                          child: ListView(
                                                                            scrollDirection: Axis.horizontal,
                                                                            physics: const BouncingScrollPhysics(),
                                                                            shrinkWrap: true,
                                                                            padding: EdgeInsets.zero,
                                                                            children: [
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    getIt<Variables>()
                                                                                        .generalVariables
                                                                                        .currentLanguage
                                                                                        .itemCode
                                                                                        .toUpperCase(),
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        color: const Color(0xff8A8D8E)),
                                                                                  ),
                                                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 7)),
                                                                                  Text(
                                                                                    context
                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                        .singleTabItemsList[idx]
                                                                                        .itemCode,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        color: const Color(0xff282F3A)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(width: getIt<Functions>().getWidgetWidth(width: 60)),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    getIt<Variables>().generalVariables.currentLanguage.uom,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        color: const Color(0xff8A8D8E)),
                                                                                  ),
                                                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 7)),
                                                                                  Text(
                                                                                    context
                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                        .singleTabItemsList[idx]
                                                                                        .uom,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        color: const Color(0xff282F3A)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(width: getIt<Functions>().getWidgetWidth(width: 60)),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    getIt<Variables>()
                                                                                        .generalVariables
                                                                                        .currentLanguage
                                                                                        .packageTerms
                                                                                        .toUpperCase(),
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        color: const Color(0xff8A8D8E)),
                                                                                  ),
                                                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 7)),
                                                                                  Text(
                                                                                    context
                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                        .singleTabItemsList[idx]
                                                                                        .packageTerms,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        color: const Color(0xff282F3A)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(width: getIt<Functions>().getWidgetWidth(width: 60)),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    getIt<Variables>()
                                                                                        .generalVariables
                                                                                        .currentLanguage
                                                                                        .sorter
                                                                                        .toUpperCase(),
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        color: const Color(0xff8A8D8E)),
                                                                                  ),
                                                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 7)),
                                                                                  context
                                                                                          .read<WarehousePickupDetailBloc>()
                                                                                          .singleTabItemsList[idx]
                                                                                          .handledBy
                                                                                          .isNotEmpty
                                                                                      ? Text(
                                                                                          context
                                                                                              .read<WarehousePickupDetailBloc>()
                                                                                              .singleTabItemsList[idx]
                                                                                              .handledBy[0]
                                                                                              .name,
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.w600,
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                              color: const Color(0xff282F3A)),
                                                                                        )
                                                                                      : const SizedBox(),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                          children: [
                                                                            Text(
                                                                              getIt<Functions>().formatNumber(
                                                                                  qty: context
                                                                                      .read<WarehousePickupDetailBloc>()
                                                                                      .singleTabItemsList[idx]
                                                                                      .quantity),
                                                                              style: TextStyle(
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: const Color(0xffDC4748)),
                                                                            ),
                                                                            Text(
                                                                              getIt<Variables>().generalVariables.currentLanguage.qty.toUpperCase(),
                                                                              style: TextStyle(
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
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
                                                            ),
                                                            context.read<WarehousePickupDetailBloc>().singleTabItemsList[idx].catchWeightStatus ==
                                                                        "No" ||
                                                                    (getIt<Functions>().getStringToList(
                                                                            value: context
                                                                                .read<WarehousePickupDetailBloc>()
                                                                                .singleTabItemsList[idx]
                                                                                .catchWeightInfo,
                                                                            quantity: context
                                                                                .read<WarehousePickupDetailBloc>()
                                                                                .singleTabItemsList[idx]
                                                                                .lineLoadedQty,
                                                                            weightUnit: context
                                                                                .read<WarehousePickupDetailBloc>()
                                                                                .singleTabItemsList[idx]
                                                                                .uom))
                                                                        .isEmpty
                                                                ? const SizedBox()
                                                                : Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: Container(
                                                                          decoration: const BoxDecoration(
                                                                            color: Color(0xffCDE5FF),
                                                                            borderRadius: BorderRadius.only(
                                                                                bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                                                          ),
                                                                          padding: EdgeInsets.only(
                                                                              left: getIt<Functions>().getWidgetWidth(width: 12),
                                                                              top: getIt<Functions>().getWidgetHeight(height: 8),
                                                                              bottom: getIt<Functions>().getWidgetHeight(height: 8)),
                                                                          child: Wrap(
                                                                            children: List.generate(
                                                                                (getIt<Functions>().getStringToList(
                                                                                        value: context
                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                            .singleTabItemsList[idx]
                                                                                            .catchWeightInfo,
                                                                                        quantity: context
                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                            .singleTabItemsList[idx]
                                                                                            .lineLoadedQty,
                                                                                        weightUnit: context
                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                            .singleTabItemsList[idx]
                                                                                            .uom))
                                                                                    .length,
                                                                                (i) => i == 0
                                                                                    ? Padding(
                                                                                        padding: const EdgeInsets.only(right: 10.0),
                                                                                        child: SvgPicture.asset(
                                                                                          "assets/catch_weight/measurement.svg",
                                                                                          height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                          width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                                          fit: BoxFit.fill,
                                                                                        ),
                                                                                      )
                                                                                    : i == 1
                                                                                        ? Container(
                                                                                            height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                            padding: EdgeInsets.symmetric(
                                                                                                horizontal:
                                                                                                    getIt<Functions>().getWidgetWidth(width: 8)),
                                                                                            child: Text(
                                                                                              "${(getIt<Functions>().getStringToList(value: context.read<WarehousePickupDetailBloc>().singleTabItemsList[idx].catchWeightInfo, quantity: context.read<WarehousePickupDetailBloc>().singleTabItemsList[idx].lineLoadedQty, weightUnit: context.read<WarehousePickupDetailBloc>().singleTabItemsList[idx].uom))[i]}  : ",
                                                                                              style: TextStyle(
                                                                                                  fontSize:
                                                                                                      getIt<Functions>().getTextSize(fontSize: 12),
                                                                                                  fontWeight: FontWeight.w600,
                                                                                                  color: const Color(0xff282F3A)),
                                                                                            ),
                                                                                          )
                                                                                        : Container(
                                                                                            height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                            width: getIt<Functions>().getWidgetWidth(
                                                                                                width: ((getIt<Functions>().getStringToList(
                                                                                                                value: context
                                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                                    .singleTabItemsList[idx]
                                                                                                                    .catchWeightInfo,
                                                                                                                quantity: context
                                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                                    .singleTabItemsList[idx]
                                                                                                                    .lineLoadedQty,
                                                                                                                weightUnit: context
                                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                                    .singleTabItemsList[idx]
                                                                                                                    .uom))[i]
                                                                                                            .length *
                                                                                                        7) +
                                                                                                    30),
                                                                                            padding: EdgeInsets.symmetric(
                                                                                                horizontal:
                                                                                                    getIt<Functions>().getWidgetWidth(width: 12)),
                                                                                            margin: EdgeInsets.only(
                                                                                                left: getIt<Functions>().getWidgetWidth(width: 6),
                                                                                                bottom:
                                                                                                    getIt<Functions>().getWidgetHeight(height: 2)),
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(8),
                                                                                              color: const Color(0xff7AA440),
                                                                                            ),
                                                                                            child: Center(
                                                                                              child: Text(
                                                                                                (getIt<Functions>().getStringToList(
                                                                                                    value: context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabItemsList[idx]
                                                                                                        .catchWeightInfo,
                                                                                                    quantity: context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabItemsList[idx]
                                                                                                        .lineLoadedQty,
                                                                                                    weightUnit: context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabItemsList[idx]
                                                                                                        .uom))[i],
                                                                                                style: TextStyle(
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 12),
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    color: const Color(0xffffffff)),
                                                                                              ),
                                                                                            ),
                                                                                          )),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(),
                                                                    ],
                                                                  ),
                                                            /*idx == context.read<WarehousePickupDetailBloc>().singleTabItemsList.length - 1
                                                                ? const SizedBox()
                                                                : const Divider(color: Color(0xffE0E7EC))*/
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              ],
                                            ),
                                          ],
                                        ),
                                );
                              default:
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: getIt<Functions>().getWidgetWidth(width: 20), right: getIt<Functions>().getWidgetWidth(width: 20)),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                  child: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList.isEmpty
                                      ? Stack(
                                          children: [
                                            SizedBox(
                                              width: getIt<Variables>().generalVariables.width,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
                                                  const CupertinoActivityIndicator(),
                                                ],
                                              ),
                                            ),
                                            ListView(
                                              padding: EdgeInsets.zero,
                                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                              controller: _pendingEmptyController,
                                              children: [
                                                Container(
                                                  color: const Color(0xffEEF4FF),
                                                  child: Column(
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
                                                        getIt<Variables>().generalVariables.currentLanguage.tripListItemsEmpty,
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w600),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Stack(
                                          children: [
                                            SizedBox(
                                              width: getIt<Variables>().generalVariables.width,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
                                                  const CupertinoActivityIndicator(),
                                                ],
                                              ),
                                            ),
                                            ListView(
                                              padding: EdgeInsets.zero,
                                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                              controller: _pendingScrollController,
                                              children: [
                                                ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemCount: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList.length,
                                                    shrinkWrap: true,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return Container(
                                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                        margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              height: getIt<Functions>().getWidgetHeight(height: 38),
                                                              decoration: const BoxDecoration(
                                                                color: Color(0xffE3E7EA),
                                                                borderRadius:
                                                                    BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                                              ),
                                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  RichText(
                                                                    text: TextSpan(
                                                                      text: "${getIt<Variables>().generalVariables.currentLanguage.loadingBay} : ",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          color: const Color(0xff282F3A),
                                                                          fontWeight: FontWeight.w600,
                                                                          fontFamily: "overpassmono"),
                                                                      children: [
                                                                        TextSpan(
                                                                            text:
                                                                                '${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayDryName} / ${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayFrozenName}',
                                                                            style: TextStyle(
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                color: const Color(0xff007AFF),
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: "overpassmono")),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            ListView.builder(
                                                                padding: EdgeInsets.zero,
                                                                physics: const NeverScrollableScrollPhysics(),
                                                                shrinkWrap: true,
                                                                itemCount:
                                                                    context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index].length,
                                                                itemBuilder: (BuildContext context, int idx) {
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      if (context
                                                                              .read<WarehousePickupDetailBloc>()
                                                                              .singleTabGroupedItemsList[index][idx]
                                                                              .itemPickedStatus ==
                                                                          "Picked") {
                                                                        getIt<Variables>().generalVariables.popUpWidget = yetToDeliverContent(
                                                                            selectedItem: context
                                                                                .read<WarehousePickupDetailBloc>()
                                                                                .singleTabGroupedItemsList[index][idx],
                                                                            index: index,
                                                                            idx: idx,
                                                                            isDelivering: false);
                                                                        getIt<Functions>().showAnimatedDialog(
                                                                            context: context, isFromTop: false, isCloseDisabled: false);
                                                                      } else {
                                                                        ScaffoldMessenger.of(context).clearSnackBars();
                                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                            content: Text(
                                                                                getIt<Variables>().generalVariables.currentLanguage.itemNotPicked)));
                                                                      }
                                                                    },
                                                                    child: Column(
                                                                      children: [
                                                                        Container(
                                                                          padding: EdgeInsets.only(
                                                                            left: getIt<Functions>().getWidgetWidth(width: 20),
                                                                            right: getIt<Functions>().getWidgetWidth(width: 20),
                                                                            top: getIt<Functions>().getWidgetHeight(height: 16),
                                                                            bottom: getIt<Functions>().getWidgetHeight(height: 16),
                                                                          ),
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Container(
                                                                                      height: getIt<Functions>().getWidgetHeight(height: 28),
                                                                                      width: getIt<Functions>().getWidgetWidth(width: 28),
                                                                                      decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        color: Color(int.parse(
                                                                                            "0XFF${context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].typeColor}")),
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          context
                                                                                              .read<WarehousePickupDetailBloc>()
                                                                                              .singleTabGroupedItemsList[index][idx]
                                                                                              .itemType,
                                                                                          style: TextStyle(
                                                                                              color: const Color(0xffffffff),
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                                              fontWeight: FontWeight.w700),
                                                                                        ),
                                                                                      )),
                                                                                  SizedBox(width: getIt<Functions>().getWidgetWidth(width: 10)),
                                                                                  Expanded(
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          context
                                                                                              .read<WarehousePickupDetailBloc>()
                                                                                              .singleTabGroupedItemsList[index][idx]
                                                                                              .itemName,
                                                                                          maxLines: 1,
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.w600,
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                              color: const Color(0xff282F3A),
                                                                                              overflow: TextOverflow.ellipsis),
                                                                                        ),
                                                                                        Text(
                                                                                          "${getIt<Variables>().generalVariables.currentLanguage.remarks} : ${context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].remarks}",
                                                                                          maxLines: 1,
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                              color: const Color(0xff6F6F6F),
                                                                                              overflow: TextOverflow.ellipsis),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                              ),
                                                                              SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 58),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: ListView(
                                                                                        scrollDirection: Axis.horizontal,
                                                                                        physics: const BouncingScrollPhysics(),
                                                                                        shrinkWrap: true,
                                                                                        padding: EdgeInsets.zero,
                                                                                        children: [
                                                                                          Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Text(
                                                                                                getIt<Variables>()
                                                                                                    .generalVariables
                                                                                                    .currentLanguage
                                                                                                    .itemCode
                                                                                                    .toUpperCase(),
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 12),
                                                                                                    color: const Color(0xff8A8D8E)),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                  height:
                                                                                                      getIt<Functions>().getWidgetHeight(height: 7)),
                                                                                              Text(
                                                                                                context
                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                    .singleTabGroupedItemsList[index][idx]
                                                                                                    .itemCode,
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 12),
                                                                                                    color: const Color(0xff282F3A)),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(
                                                                                              width: getIt<Functions>().getWidgetWidth(width: 60)),
                                                                                          Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Text(
                                                                                                getIt<Variables>()
                                                                                                    .generalVariables
                                                                                                    .currentLanguage
                                                                                                    .uom,
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 12),
                                                                                                    color: const Color(0xff8A8D8E)),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                  height:
                                                                                                      getIt<Functions>().getWidgetHeight(height: 7)),
                                                                                              Text(
                                                                                                context
                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                    .singleTabGroupedItemsList[index][idx]
                                                                                                    .uom,
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 12),
                                                                                                    color: const Color(0xff282F3A)),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(
                                                                                              width: getIt<Functions>().getWidgetWidth(width: 60)),
                                                                                          Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Text(
                                                                                                getIt<Variables>()
                                                                                                    .generalVariables
                                                                                                    .currentLanguage
                                                                                                    .packageTerms
                                                                                                    .toUpperCase(),
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 12),
                                                                                                    color: const Color(0xff8A8D8E)),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                  height:
                                                                                                      getIt<Functions>().getWidgetHeight(height: 7)),
                                                                                              Text(
                                                                                                context
                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                    .singleTabGroupedItemsList[index][idx]
                                                                                                    .packageTerms,
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 12),
                                                                                                    color: const Color(0xff282F3A)),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                                      children: [
                                                                                        Text(
                                                                                          context
                                                                                              .read<WarehousePickupDetailBloc>()
                                                                                              .singleTabGroupedItemsList[index][idx]
                                                                                              .quantity,
                                                                                          style: TextStyle(
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                                              fontWeight: FontWeight.w600,
                                                                                              color: const Color(0xff007AFF)),
                                                                                        ),
                                                                                        Text(
                                                                                          getIt<Variables>()
                                                                                              .generalVariables
                                                                                              .currentLanguage
                                                                                              .qty
                                                                                              .toUpperCase(),
                                                                                          style: TextStyle(
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
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
                                                                        ),
                                                                        context
                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                        .catchWeightStatus ==
                                                                                    "No" ||
                                                                                (getIt<Functions>().getStringToList(
                                                                                        value: context
                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                            .singleTabGroupedItemsList[index][idx]
                                                                                            .catchWeightInfo,
                                                                                        quantity: context
                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                            .singleTabGroupedItemsList[index][idx]
                                                                                            .lineLoadedQty,
                                                                                        weightUnit: context
                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                            .singleTabGroupedItemsList[index][idx]
                                                                                            .uom))
                                                                                    .isEmpty
                                                                            ? const SizedBox()
                                                                            : Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Container(
                                                                                      decoration: const BoxDecoration(
                                                                                        color: Color(0xffCDE5FF),
                                                                                        borderRadius: BorderRadius.only(
                                                                                            bottomLeft: Radius.circular(8),
                                                                                            bottomRight: Radius.circular(8)),
                                                                                      ),
                                                                                      padding: EdgeInsets.only(
                                                                                          left: getIt<Functions>().getWidgetWidth(width: 12),
                                                                                          top: getIt<Functions>().getWidgetHeight(height: 8),
                                                                                          bottom: getIt<Functions>().getWidgetHeight(height: 8)),
                                                                                      child: Wrap(
                                                                                        children: List.generate(
                                                                                            (getIt<Functions>().getStringToList(
                                                                                                    value: context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                                        .catchWeightInfo,
                                                                                                    quantity: context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                                        .lineLoadedQty,
                                                                                                    weightUnit: context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                                        .uom))
                                                                                                .length,
                                                                                            (i) => i == 0
                                                                                                ? Padding(
                                                                                                    padding: const EdgeInsets.only(right: 10.0),
                                                                                                    child: SvgPicture.asset(
                                                                                                      "assets/catch_weight/measurement.svg",
                                                                                                      height: getIt<Functions>()
                                                                                                          .getWidgetHeight(height: 20),
                                                                                                      width: getIt<Functions>()
                                                                                                          .getWidgetWidth(width: 20),
                                                                                                      fit: BoxFit.fill,
                                                                                                    ),
                                                                                                  )
                                                                                                : i == 1
                                                                                                    ? Container(
                                                                                                        height: getIt<Functions>()
                                                                                                            .getWidgetHeight(height: 20),
                                                                                                        padding: EdgeInsets.symmetric(
                                                                                                            horizontal: getIt<Functions>()
                                                                                                                .getWidgetWidth(width: 8)),
                                                                                                        child: Text(
                                                                                                          (getIt<Functions>().getStringToList(
                                                                                                              value: context
                                                                                                                  .read<WarehousePickupDetailBloc>()
                                                                                                                  .singleTabGroupedItemsList[index]
                                                                                                                      [idx]
                                                                                                                  .catchWeightInfo,
                                                                                                              quantity: context
                                                                                                                  .read<WarehousePickupDetailBloc>()
                                                                                                                  .singleTabGroupedItemsList[index]
                                                                                                                      [idx]
                                                                                                                  .quantity,
                                                                                                              weightUnit: context
                                                                                                                  .read<WarehousePickupDetailBloc>()
                                                                                                                  .singleTabGroupedItemsList[index]
                                                                                                                      [idx]
                                                                                                                  .uom))[i],
                                                                                                          style: TextStyle(
                                                                                                              fontSize: getIt<Functions>()
                                                                                                                  .getTextSize(fontSize: 12),
                                                                                                              fontWeight: FontWeight.w600,
                                                                                                              color: const Color(0xff282F3A)),
                                                                                                        ),
                                                                                                      )
                                                                                                    : Container(
                                                                                                        height: getIt<Functions>()
                                                                                                            .getWidgetHeight(height: 20),
                                                                                                        width: getIt<Functions>().getWidgetWidth(
                                                                                                            width: ((getIt<Functions>().getStringToList(
                                                                                                                            value: context
                                                                                                                                .read<
                                                                                                                                    WarehousePickupDetailBloc>()
                                                                                                                                .singleTabGroupedItemsList[
                                                                                                                                    index][idx]
                                                                                                                                .catchWeightInfo,
                                                                                                                            quantity: context
                                                                                                                                .read<
                                                                                                                                    WarehousePickupDetailBloc>()
                                                                                                                                .singleTabGroupedItemsList[
                                                                                                                                    index][idx]
                                                                                                                                .lineLoadedQty,
                                                                                                                            weightUnit: context
                                                                                                                                .read<
                                                                                                                                    WarehousePickupDetailBloc>()
                                                                                                                                .singleTabGroupedItemsList[
                                                                                                                                    index][idx]
                                                                                                                                .uom))[i]
                                                                                                                        .length *
                                                                                                                    7) +
                                                                                                                30),
                                                                                                        padding: EdgeInsets.symmetric(
                                                                                                            horizontal: getIt<Functions>()
                                                                                                                .getWidgetWidth(width: 12)),
                                                                                                        margin: EdgeInsets.only(
                                                                                                            left: getIt<Functions>()
                                                                                                                .getWidgetWidth(width: 6),
                                                                                                            bottom: getIt<Functions>()
                                                                                                                .getWidgetHeight(height: 2)),
                                                                                                        decoration: BoxDecoration(
                                                                                                          borderRadius: BorderRadius.circular(8),
                                                                                                          color: const Color(0xff7AA440),
                                                                                                        ),
                                                                                                        child: Center(
                                                                                                          child: Text(
                                                                                                            (getIt<Functions>().getStringToList(
                                                                                                                value: context
                                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                                    .singleTabGroupedItemsList[index]
                                                                                                                        [idx]
                                                                                                                    .catchWeightInfo,
                                                                                                                quantity: context
                                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                                    .singleTabGroupedItemsList[index]
                                                                                                                        [idx]
                                                                                                                    .lineLoadedQty,
                                                                                                                weightUnit: context
                                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                                    .singleTabGroupedItemsList[index]
                                                                                                                        [idx]
                                                                                                                    .uom))[i],
                                                                                                            style: TextStyle(
                                                                                                                fontSize: getIt<Functions>()
                                                                                                                    .getTextSize(fontSize: 12),
                                                                                                                fontWeight: FontWeight.w500,
                                                                                                                color: const Color(0xffffffff)),
                                                                                                          ),
                                                                                                        ),
                                                                                                      )),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(),
                                                                                ],
                                                                              ),
                                                                        idx ==
                                                                                context
                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                        .singleTabGroupedItemsList[index]
                                                                                        .length -
                                                                                    1
                                                                            ? const SizedBox()
                                                                            : const Divider(color: Color(0xffE0E7EC))
                                                                      ],
                                                                    ),
                                                                  );
                                                                }),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              ],
                                            ),
                                          ],
                                        ),
                                );
                            }
                          } else if (state is WarehousePickupDetailLoading) {
                            return Container(
                              margin: EdgeInsets.only(
                                  left: getIt<Functions>().getWidgetWidth(width: 20), right: getIt<Functions>().getWidgetWidth(width: 20)),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                              child: Skeletonizer(
                                enabled: true,
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: const ScrollPhysics(),
                                    itemCount: 1,
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                        margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: getIt<Functions>().getWidgetHeight(height: 40),
                                              decoration: const BoxDecoration(
                                                color: Color(0xffE3E7EA),
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                                  vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                              child: IntrinsicHeight(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text("${getIt<Variables>().generalVariables.currentLanguage.floorNo.toUpperCase()} : F ",
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                            fontWeight: FontWeight.w600,
                                                            color: const Color(0xff282F3A))),
                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 80)),
                                                    Text("${getIt<Variables>().generalVariables.currentLanguage.roomNo.toUpperCase()} : R",
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                            fontWeight: FontWeight.w600,
                                                            color: const Color(0xff282F3A))),
                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 80)),
                                                    Text("${getIt<Variables>().generalVariables.currentLanguage.zoneNo.toUpperCase()} : Z",
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                            fontWeight: FontWeight.w600,
                                                            color: const Color(0xff282F3A))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            ListView.builder(
                                                padding: EdgeInsets.zero,
                                                physics: const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: 1,
                                                itemBuilder: (BuildContext context, int idx) {
                                                  return Container(
                                                    padding: EdgeInsets.only(
                                                        left: getIt<Functions>().getWidgetWidth(width: 20),
                                                        right: getIt<Functions>().getWidgetWidth(width: 20),
                                                        top: getIt<Functions>().getWidgetHeight(height: 16)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Skeleton.shade(
                                                              child: Container(
                                                                  height: getIt<Functions>().getWidgetHeight(height: 28),
                                                                  width: getIt<Functions>().getWidgetWidth(width: 28),
                                                                  decoration: const BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    color: Colors.purpleAccent,
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "D",
                                                                      style: TextStyle(
                                                                          color: const Color(0xffffffff),
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 15),
                                                                          fontWeight: FontWeight.w700),
                                                                    ),
                                                                  )),
                                                            ),
                                                            SizedBox(
                                                              width: getIt<Functions>().getWidgetWidth(width: 10),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                "CORN FLOUR - 1KG",
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                    color: const Color(0xff282F3A),
                                                                    overflow: TextOverflow.ellipsis),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: getIt<Functions>().getWidgetHeight(height: 14),
                                                        ),
                                                        SizedBox(
                                                          height: getIt<Functions>().getWidgetHeight(height: 58),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Expanded(
                                                                child: SizedBox(
                                                                  height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                  child: ListView(
                                                                    scrollDirection: Axis.horizontal,
                                                                    physics: const BouncingScrollPhysics(),
                                                                    shrinkWrap: true,
                                                                    padding: EdgeInsets.zero,
                                                                    children: [
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Text(
                                                                            getIt<Variables>()
                                                                                .generalVariables
                                                                                .currentLanguage
                                                                                .itemCode
                                                                                .toUpperCase(),
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                color: const Color(0xff8A8D8E)),
                                                                          ),
                                                                          Text(
                                                                            "F008",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 60)),
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "UOM",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                color: const Color(0xff8A8D8E)),
                                                                          ),
                                                                          Text(
                                                                            "UOM",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 60)),
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            getIt<Variables>()
                                                                                .generalVariables
                                                                                .currentLanguage
                                                                                .packageTerms
                                                                                .toUpperCase(),
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                color: const Color(0xff8A8D8E)),
                                                                          ),
                                                                          Text(
                                                                            "Package Terms",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 10),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    "24",
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff007AFF)),
                                                                  ),
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.qtyToSort.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        fontWeight: FontWeight.w500,
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)),
                                                      ],
                                                    ),
                                                  );
                                                })
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                color: const Color(0xffEEF4FF),
                child: Column(
                  children: [
                    BlocBuilder<WarehousePickupDetailBloc, WarehousePickupDetailState>(
                      builder: (BuildContext context, WarehousePickupDetailState state) {
                        return SizedBox(
                          height: getIt<Functions>().getWidgetHeight(height: 250),
                          child: AppBar(
                            backgroundColor: const Color(0xff1D2736),
                            leading: IconButton(
                              onPressed: () {
                                getIt<Variables>().generalVariables.indexName = getIt<Variables>()
                                    .generalVariables
                                    .warehouseRouteList[getIt<Variables>().generalVariables.warehouseRouteList.length - 1];
                                context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                getIt<Variables>()
                                    .generalVariables
                                    .warehouseRouteList
                                    .removeAt(getIt<Variables>().generalVariables.warehouseRouteList.length - 1);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Color(0xffffffff),
                              ),
                            ),
                            titleSpacing: 0,
                            title: AnimatedCrossFade(
                              firstChild: Text(
                                "${getIt<Variables>().generalVariables.currentLanguage.so.toUpperCase()} # ${getIt<Variables>().generalVariables.soListMainIdData.soNum}  ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                    color: const Color(0xffffffff)),
                              ),
                              secondChild: textBars(controller: searchBar),
                              crossFadeState:
                                  context.read<WarehousePickupDetailBloc>().searchBarEnabled ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 100),
                            ),
                            actions: [
                              InkWell(
                                onTap: state is WarehousePickupDetailLoading
                                    ? () {}
                                    : () {
                                        context.read<WarehousePickupDetailBloc>().searchBarEnabled =
                                            !context.read<WarehousePickupDetailBloc>().searchBarEnabled;
                                        if (!context.read<WarehousePickupDetailBloc>().searchBarEnabled) {
                                          searchBar.clear();
                                          FocusManager.instance.primaryFocus!.unfocus();
                                          context.read<WarehousePickupDetailBloc>().searchText = "";
                                        }
                                        context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailFilterEvent());
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
                                onTap: state is WarehousePickupDetailLoading
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
                                  getIt<Functions>().getWidgetHeight(height: 140)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 14)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 52),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: getIt<Variables>().generalVariables.isNetworkOffline
                                                ? () {}
                                                : () {
                                                    getIt<Variables>().generalVariables.isStatusDrawer = true;
                                                    Scaffold.of(context).openEndDrawer();
                                                  },
                                            child: SvgPicture.asset(
                                              "assets/pick_list/status_image.svg",
                                              height: getIt<Functions>().getWidgetHeight(height: 20),
                                              width: getIt<Functions>().getWidgetWidth(width: 20),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                          Flexible(
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
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.status,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                            color: const Color(0xffffffff)),
                                                      ),
                                                      Text(
                                                        getIt<Variables>().generalVariables.soListMainIdData.soStatus.toUpperCase(),
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                            color: const Color(0xffF8B11D)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: getIt<Functions>().getWidgetHeight(height: 30),
                                                  width: getIt<Functions>().getWidgetWidth(width: 0),
                                                  child: const VerticalDivider(
                                                    color: Color(0xffE0E7EC),
                                                    width: 1,
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.numberOfItems.toUpperCase(),
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                          color: const Color(0xffffffff)),
                                                    ),
                                                    Text(
                                                      "${getIt<Variables>().generalVariables.soListMainIdData.soNoOfLoadedItems} / ${getIt<Variables>().generalVariables.soListMainIdData.soNoOfItems}",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                          color: const Color(0xff5AC8EA)),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: getIt<Functions>().getWidgetHeight(height: 30),
                                                  width: getIt<Functions>().getWidgetWidth(width: 0),
                                                  child: const VerticalDivider(
                                                    color: Color(0xffE0E7EC),
                                                    width: 1,
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.dateAndTime,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                          color: const Color(0xffffffff)),
                                                    ),
                                                    Text(
                                                      getIt<Variables>().generalVariables.soListMainIdData.soCreatedTime,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                          color: const Color(0xff5AC8EA)),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 23)),
                                    Container(
                                      height: getIt<Functions>().getWidgetHeight(height: 45),
                                      padding: EdgeInsets.only(
                                          left: getIt<Functions>().getWidgetWidth(width: 10),
                                          right: getIt<Functions>().getWidgetWidth(width: 4),
                                          top: getIt<Functions>().getWidgetHeight(height: 4),
                                          bottom: getIt<Functions>().getWidgetHeight(height: 4)),
                                      decoration: BoxDecoration(color: const Color(0xffFFFFFF), borderRadius: BorderRadius.circular(7)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                getIt<Variables>().generalVariables.currentLanguage.timeSpent,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                    color: const Color(0xff1D2736)),
                                              ),
                                              BlocBuilder<TimerBloc, TimerState>(builder: (BuildContext context, TimerState state) {
                                                return Text(
                                                  timerString,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                      color: const Color(0xff007aff)),
                                                );
                                              }),
                                            ],
                                          ),
                                          Container(
                                            height: getIt<Functions>().getWidgetHeight(height: 31),
                                            width: getIt<Functions>().getWidgetWidth(width: 105),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                    child: Container(
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
                                                    color: Color(0xff007838),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      Hive.box<ItemsList>('items_list_pickup')
                                                          .values
                                                          .toList()
                                                          .where((element) =>
                                                              element.soId == getIt<Variables>().generalVariables.soListMainIdData.soId &&
                                                              element.itemLoadedStatus == "Loaded" &&
                                                              element.isProgressStatus &&
                                                              (element.handledBy.isNotEmpty
                                                                  ? (element.handledBy[0].code ==
                                                                      getIt<Variables>().generalVariables.userDataEmployeeCode)
                                                                  : false))
                                                          .toList()
                                                          .length
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: const Color(0xffffffff),
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                    ),
                                                  ),
                                                )),
                                                Expanded(
                                                    child: Container(
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
                                                    color: Color(0xffF92C38),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      Hive.box<ItemsList>('items_list_pickup')
                                                          .values
                                                          .toList()
                                                          .where((element) =>
                                                              element.soId == getIt<Variables>().generalVariables.soListMainIdData.soId &&
                                                              element.itemLoadedStatus == "Unavailable" &&
                                                              element.isProgressStatus &&
                                                              (element.handledBy.isNotEmpty
                                                                  ? (element.handledBy[0].code ==
                                                                      getIt<Variables>().generalVariables.userDataEmployeeCode)
                                                                  : false))
                                                          .toList()
                                                          .length
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: const Color(0xffffffff),
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                    ),
                                                  ),
                                                )),
                                              ],
                                            ),
                                          ),
                                          getIt<Variables>().generalVariables.soListMainIdData.soStatus.toLowerCase() == "completed"
                                              ? Container(
                                                  height: getIt<Functions>().getWidgetHeight(height: 30),
                                                  width: getIt<Functions>().getWidgetWidth(width: 150),
                                                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
                                                  child: Center(
                                                    child: Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase(),
                                                      maxLines: 1,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: const Color(0xff000000),
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    if (context
                                                            .read<WarehousePickupDetailBloc>()
                                                            .searchedItemsList
                                                            .where((element) => element.itemLoadedStatus == "Pending")
                                                            .toList()
                                                            .isEmpty &&
                                                        context
                                                            .read<WarehousePickupDetailBloc>()
                                                            .searchedItemsList
                                                            .where((element) => element.itemLoadedStatus == "Unavailable")
                                                            .toList()
                                                            .isEmpty) {
                                                      getIt<Variables>().generalVariables.indexName = WarehousePickupSummaryScreen.id;
                                                      getIt<Variables>().generalVariables.warehouseRouteList.add(WarehousePickupDetailScreen.id);
                                                      context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                                    } else {
                                                      ScaffoldMessenger.of(context).clearSnackBars();
                                                      ScaffoldMessenger.of(context)
                                                          .showSnackBar(SnackBar(content: Text(getIt<Variables>().generalVariables.currentLanguage.missedToDeliver)));
                                                    }
                                                  },
                                                  child: Container(
                                                    height: getIt<Functions>().getWidgetHeight(height: 30),
                                                    width: getIt<Functions>().getWidgetWidth(width: 150),
                                                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(4)),
                                                    child: Center(
                                                      child: Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.delivered.toUpperCase(),
                                                        maxLines: 1,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          color: const Color(0xffffffff),
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 15)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
                    BlocBuilder<WarehousePickupDetailBloc, WarehousePickupDetailState>(
                      builder: (BuildContext context, WarehousePickupDetailState state) {
                        return Container(
                          height: getIt<Functions>().getWidgetHeight(height: 50),
                          margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 14)),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.symmetric(
                              horizontal: getIt<Functions>().getWidgetWidth(width: 13), vertical: getIt<Functions>().getWidgetHeight(height: 4)),
                          child: TabBar(
                            indicatorWeight: 0,
                            controller: tabController,
                            indicator: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: const Color(0xff007AFF)),
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: getIt<Functions>().getTextSize(fontSize: 11), fontWeight: FontWeight.w600),
                            unselectedLabelStyle: TextStyle(
                                color: const Color(0xff6F6F6F), fontSize: getIt<Functions>().getTextSize(fontSize: 11), fontWeight: FontWeight.w600),
                            splashBorderRadius: BorderRadius.circular(8),
                            padding: EdgeInsets.symmetric(
                                vertical: getIt<Functions>().getWidgetHeight(height: 3), horizontal: getIt<Functions>().getWidgetWidth(width: 3)),
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            dividerHeight: 0.0,
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            tabs: [
                              Tab(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(getIt<Variables>().generalVariables.currentLanguage.yetToDeliver.toUpperCase()),
                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                        context
                                                .read<WarehousePickupDetailBloc>()
                                                .searchedItemsList
                                                .where((element) => element.itemLoadedStatus == "Pending")
                                                .toList()
                                                .isEmpty
                                            ? const SizedBox()
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                    vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                decoration: BoxDecoration(
                                                    color: context.read<WarehousePickupDetailBloc>().tabIndex == 0
                                                        ? Colors.white
                                                        : const Color(0xff007AFF),
                                                    borderRadius: BorderRadius.circular(20)),
                                                child: Text(
                                                  context
                                                              .read<WarehousePickupDetailBloc>()
                                                              .searchedItemsList
                                                              .where((element) => element.itemLoadedStatus == "Pending")
                                                              .toList()
                                                              .length <
                                                          10
                                                      ? "0${context.read<WarehousePickupDetailBloc>().searchedItemsList.where((element) => element.itemLoadedStatus == "Pending").toList().length}"
                                                      : context
                                                          .read<WarehousePickupDetailBloc>()
                                                          .searchedItemsList
                                                          .where((element) => element.itemLoadedStatus == "Pending")
                                                          .toList()
                                                          .length
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: context.read<WarehousePickupDetailBloc>().tabIndex == 0
                                                          ? const Color(0xff282F3A)
                                                          : Colors.white,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 8),
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Tab(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(getIt<Variables>().generalVariables.currentLanguage.delivered.toUpperCase()),
                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                        context
                                                .read<WarehousePickupDetailBloc>()
                                                .searchedItemsList
                                                .where((element) => element.itemLoadedStatus == "Loaded")
                                                .toList()
                                                .isEmpty
                                            ? const SizedBox()
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                    vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                decoration: BoxDecoration(
                                                    color: context.read<WarehousePickupDetailBloc>().tabIndex == 1
                                                        ? Colors.white
                                                        : const Color(0xff007AFF),
                                                    borderRadius: BorderRadius.circular(20)),
                                                child: Text(
                                                  context
                                                              .read<WarehousePickupDetailBloc>()
                                                              .searchedItemsList
                                                              .where((element) => element.itemLoadedStatus == "Loaded")
                                                              .toList()
                                                              .length <
                                                          10
                                                      ? "0${context.read<WarehousePickupDetailBloc>().searchedItemsList.where((element) => element.itemLoadedStatus == "Loaded").toList().length}"
                                                      : context
                                                          .read<WarehousePickupDetailBloc>()
                                                          .searchedItemsList
                                                          .where((element) => element.itemLoadedStatus == "Loaded")
                                                          .toList()
                                                          .length
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: context.read<WarehousePickupDetailBloc>().tabIndex == 1
                                                          ? const Color(0xff282F3A)
                                                          : Colors.white,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 8),
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Tab(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(getIt<Variables>().generalVariables.currentLanguage.unavailable.toUpperCase()),
                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                        context
                                                .read<WarehousePickupDetailBloc>()
                                                .searchedItemsList
                                                .where((element) => element.itemLoadedStatus == "Unavailable")
                                                .toList()
                                                .isEmpty
                                            ? const SizedBox()
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                    vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                decoration: BoxDecoration(
                                                    color: context.read<WarehousePickupDetailBloc>().tabIndex == 2
                                                        ? Colors.white
                                                        : const Color(0xff007AFF),
                                                    borderRadius: BorderRadius.circular(20)),
                                                child: Text(
                                                  context
                                                              .read<WarehousePickupDetailBloc>()
                                                              .searchedItemsList
                                                              .where((element) => element.itemLoadedStatus == "Unavailable")
                                                              .toList()
                                                              .length <
                                                          10
                                                      ? "0${context.read<WarehousePickupDetailBloc>().searchedItemsList.where((element) => element.itemLoadedStatus == "Unavailable").toList().length}"
                                                      : context
                                                          .read<WarehousePickupDetailBloc>()
                                                          .searchedItemsList
                                                          .where((element) => element.itemLoadedStatus == "Unavailable")
                                                          .toList()
                                                          .length
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: context.read<WarehousePickupDetailBloc>().tabIndex == 2
                                                          ? const Color(0xff282F3A)
                                                          : Colors.white,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 8),
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: BlocBuilder<WarehousePickupDetailBloc, WarehousePickupDetailState>(
                        builder: (BuildContext context, WarehousePickupDetailState state) {
                          if (state is WarehousePickupDetailLoaded) {
                            switch (context.read<WarehousePickupDetailBloc>().tabIndex) {
                              case 0:
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: getIt<Functions>().getWidgetWidth(width: 12),
                                      right: getIt<Functions>().getWidgetWidth(width: 12),
                                      bottom: getIt<Functions>().getWidgetHeight(height: 12)),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                  child: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList.isEmpty
                                      ? Stack(
                                          children: [
                                            SizedBox(
                                              width: getIt<Variables>().generalVariables.width,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
                                                  const CupertinoActivityIndicator(),
                                                ],
                                              ),
                                            ),
                                            ListView(
                                              padding: EdgeInsets.zero,
                                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                              controller: _pendingEmptyController,
                                              children: [
                                                Container(
                                                  color: const Color(0xffEEF4FF),
                                                  child: Column(
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
                                                        getIt<Variables>().generalVariables.currentLanguage.warehouseListIsEmpty,
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w600),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Stack(
                                          children: [
                                            SizedBox(
                                              width: getIt<Variables>().generalVariables.width,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
                                                  const CupertinoActivityIndicator(),
                                                ],
                                              ),
                                            ),
                                            ListView(
                                              padding: EdgeInsets.zero,
                                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                              controller: _pendingScrollController,
                                              children: [
                                                ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemCount: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList.length,
                                                    shrinkWrap: true,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return Container(
                                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                        margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              height: getIt<Functions>().getWidgetHeight(height: 36),
                                                              decoration: const BoxDecoration(
                                                                color: Color(0xffE3E7EA),
                                                                borderRadius:
                                                                    BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                                              ),
                                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 14)),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  RichText(
                                                                    text: TextSpan(
                                                                      text:
                                                                          "${getIt<Variables>().generalVariables.currentLanguage.loadingBay.toUpperCase()} : ",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                          color: const Color(0xff282F3A),
                                                                          fontWeight: FontWeight.w600,
                                                                          fontFamily: "overpassmono"),
                                                                      children: [
                                                                        TextSpan(
                                                                            text:
                                                                                '${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayDryName} / ${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayFrozenName}',
                                                                            style: TextStyle(
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                color: const Color(0xff007AFF),
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: "overpassmono")),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            ListView.builder(
                                                                padding: EdgeInsets.zero,
                                                                physics: const NeverScrollableScrollPhysics(),
                                                                shrinkWrap: true,
                                                                itemCount:
                                                                    context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index].length,
                                                                itemBuilder: (BuildContext context, int idx) {
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      if (context
                                                                              .read<WarehousePickupDetailBloc>()
                                                                              .singleTabGroupedItemsList[index][idx]
                                                                              .itemPickedStatus ==
                                                                          "Picked" ) {
                                                                        getIt<Variables>().generalVariables.popUpWidget = yetToDeliverContent(
                                                                            selectedItem: context
                                                                                .read<WarehousePickupDetailBloc>()
                                                                                .singleTabGroupedItemsList[index][idx],
                                                                            index: index,
                                                                            idx: idx,
                                                                            isDelivering: false);
                                                                        getIt<Functions>().showAnimatedDialog(
                                                                            context: context, isFromTop: false, isCloseDisabled: false);
                                                                      } else {
                                                                        ScaffoldMessenger.of(context).clearSnackBars();
                                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                            content: Text(
                                                                                getIt<Variables>().generalVariables.currentLanguage.itemNotPicked)));
                                                                      }
                                                                    },
                                                                    child: Column(
                                                                      children: [
                                                                        Container(
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                                                              vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Container(
                                                                                      height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                                      width: getIt<Functions>().getWidgetWidth(width: 35),
                                                                                      decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        color: Color(int.parse(
                                                                                            "0XFF${context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].typeColor}")),
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          context
                                                                                              .read<WarehousePickupDetailBloc>()
                                                                                              .singleTabGroupedItemsList[index][idx]
                                                                                              .itemType,
                                                                                          style: TextStyle(
                                                                                              color: const Color(0xffffffff),
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                              fontWeight: FontWeight.w700),
                                                                                        ),
                                                                                      )),
                                                                                  SizedBox(width: getIt<Functions>().getWidgetWidth(width: 10)),
                                                                                  Expanded(
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        SingleChildScrollView(
                                                                                          scrollDirection: Axis.horizontal,
                                                                                          child: Text(
                                                                                            context
                                                                                                .read<WarehousePickupDetailBloc>()
                                                                                                .singleTabGroupedItemsList[index][idx]
                                                                                                .itemName,
                                                                                            maxLines: 1,
                                                                                            style: TextStyle(
                                                                                                fontWeight: FontWeight.w600,
                                                                                                fontSize:
                                                                                                    getIt<Functions>().getTextSize(fontSize: 16),
                                                                                                color: const Color(0xff282F3A),
                                                                                                overflow: TextOverflow.ellipsis),
                                                                                          ),
                                                                                        ),
                                                                                        Text(
                                                                                          "${getIt<Variables>().generalVariables.currentLanguage.remarks} : ${context.read<WarehousePickupDetailBloc>().singleTabItemsList[idx].remarks}",
                                                                                          maxLines: 1,
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                              color: const Color(0xff6F6F6F),
                                                                                              overflow: TextOverflow.ellipsis),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                              ),
                                                                              SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 46),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: ListView(
                                                                                        scrollDirection: Axis.horizontal,
                                                                                        physics: const BouncingScrollPhysics(),
                                                                                        shrinkWrap: true,
                                                                                        padding: EdgeInsets.zero,
                                                                                        children: [
                                                                                          Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            children: [
                                                                                              Text(
                                                                                                getIt<Variables>()
                                                                                                    .generalVariables
                                                                                                    .currentLanguage
                                                                                                    .itemCode
                                                                                                    .toUpperCase(),
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 10),
                                                                                                    color: const Color(0xff8A8D8E)),
                                                                                              ),
                                                                                              Text(
                                                                                                context
                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                    .singleTabGroupedItemsList[index][idx]
                                                                                                    .itemCode,
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 11),
                                                                                                    color: const Color(0xff282F3A)),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(
                                                                                              width: getIt<Functions>().getWidgetWidth(width: 15)),
                                                                                          Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            children: [
                                                                                              Text(
                                                                                                "UOM",
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 10),
                                                                                                    color: const Color(0xff8A8D8E)),
                                                                                              ),
                                                                                              Text(
                                                                                                context
                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                    .singleTabGroupedItemsList[index][idx]
                                                                                                    .uom,
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 11),
                                                                                                    color: const Color(0xff282F3A)),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(
                                                                                              width: getIt<Functions>().getWidgetWidth(width: 15)),
                                                                                          Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            children: [
                                                                                              Text(
                                                                                                getIt<Variables>()
                                                                                                    .generalVariables
                                                                                                    .currentLanguage
                                                                                                    .packageTerms
                                                                                                    .toUpperCase(),
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 10),
                                                                                                    color: const Color(0xff8A8D8E)),
                                                                                              ),
                                                                                              Text(
                                                                                                context
                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                    .singleTabGroupedItemsList[index][idx]
                                                                                                    .packageTerms,
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 11),
                                                                                                    color: const Color(0xff282F3A)),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                                      children: [
                                                                                        Text(
                                                                                          getIt<Functions>().formatNumber(
                                                                                              qty: context
                                                                                                  .read<WarehousePickupDetailBloc>()
                                                                                                  .singleTabGroupedItemsList[index][idx]
                                                                                                  .quantity),
                                                                                          style: TextStyle(
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                              fontWeight: FontWeight.w600,
                                                                                              color: const Color(0xff007AFF)),
                                                                                        ),
                                                                                        Text(
                                                                                          getIt<Variables>()
                                                                                              .generalVariables
                                                                                              .currentLanguage
                                                                                              .qty
                                                                                              .toUpperCase(),
                                                                                          style: TextStyle(
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
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
                                                                        ),
                                                                        context
                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                        .catchWeightStatus ==
                                                                                    "No" ||
                                                                                (getIt<Functions>().getStringToList(
                                                                                        value: context
                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                            .singleTabGroupedItemsList[index][idx]
                                                                                            .catchWeightInfo,
                                                                                        quantity: context
                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                            .singleTabGroupedItemsList[index][idx]
                                                                                            .lineLoadedQty,
                                                                                        weightUnit: context
                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                            .singleTabGroupedItemsList[index][idx]
                                                                                            .uom))
                                                                                    .isEmpty
                                                                            ? const SizedBox()
                                                                            : Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Container(
                                                                                      decoration: const BoxDecoration(
                                                                                        color: Color(0xffCDE5FF),
                                                                                        borderRadius: BorderRadius.only(
                                                                                            bottomLeft: Radius.circular(8),
                                                                                            bottomRight: Radius.circular(8)),
                                                                                      ),
                                                                                      padding: EdgeInsets.only(
                                                                                          left: getIt<Functions>().getWidgetWidth(width: 12),
                                                                                          top: getIt<Functions>().getWidgetHeight(height: 8),
                                                                                          bottom: getIt<Functions>().getWidgetHeight(height: 8)),
                                                                                      child: Wrap(
                                                                                        children: List.generate(
                                                                                            (getIt<Functions>().getStringToList(
                                                                                                    value: context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                                        .catchWeightInfo,
                                                                                                    quantity: context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                                        .lineLoadedQty,
                                                                                                    weightUnit: context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                                        .uom))
                                                                                                .length,
                                                                                            (i) => i == 0
                                                                                                ? Padding(
                                                                                                    padding: const EdgeInsets.only(right: 10.0),
                                                                                                    child: SvgPicture.asset(
                                                                                                      "assets/catch_weight/measurement.svg",
                                                                                                      height: getIt<Functions>()
                                                                                                          .getWidgetHeight(height: 20),
                                                                                                      width: getIt<Functions>()
                                                                                                          .getWidgetWidth(width: 20),
                                                                                                      fit: BoxFit.fill,
                                                                                                    ),
                                                                                                  )
                                                                                                : i == 1
                                                                                                    ? Container(
                                                                                                        height: getIt<Functions>()
                                                                                                            .getWidgetHeight(height: 20),
                                                                                                        padding: EdgeInsets.symmetric(
                                                                                                            horizontal: getIt<Functions>()
                                                                                                                .getWidgetWidth(width: 8)),
                                                                                                        child: Text(
                                                                                                          "${(getIt<Functions>().getStringToList(value: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].catchWeightInfo, quantity: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].quantity, weightUnit: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].uom))[i]}  : ",
                                                                                                          style: TextStyle(
                                                                                                              fontSize: getIt<Functions>()
                                                                                                                  .getTextSize(fontSize: 12),
                                                                                                              fontWeight: FontWeight.w600,
                                                                                                              color: const Color(0xff282F3A)),
                                                                                                        ),
                                                                                                      )
                                                                                                    : Container(
                                                                                                        height: getIt<Functions>()
                                                                                                            .getWidgetHeight(height: 20),
                                                                                                        width: getIt<Functions>().getWidgetWidth(
                                                                                                            width: ((getIt<Functions>().getStringToList(
                                                                                                                            value: context
                                                                                                                                .read<
                                                                                                                                    WarehousePickupDetailBloc>()
                                                                                                                                .singleTabGroupedItemsList[
                                                                                                                                    index][idx]
                                                                                                                                .catchWeightInfo,
                                                                                                                            quantity: context
                                                                                                                                .read<
                                                                                                                                    WarehousePickupDetailBloc>()
                                                                                                                                .singleTabGroupedItemsList[
                                                                                                                                    index][idx]
                                                                                                                                .lineLoadedQty,
                                                                                                                            weightUnit: context
                                                                                                                                .read<
                                                                                                                                    WarehousePickupDetailBloc>()
                                                                                                                                .singleTabGroupedItemsList[
                                                                                                                                    index][idx]
                                                                                                                                .uom))[i]
                                                                                                                        .length *
                                                                                                                    7) +
                                                                                                                30),
                                                                                                        padding: EdgeInsets.symmetric(
                                                                                                            horizontal: getIt<Functions>()
                                                                                                                .getWidgetWidth(width: 12)),
                                                                                                        margin: EdgeInsets.only(
                                                                                                            left: getIt<Functions>()
                                                                                                                .getWidgetWidth(width: 6),
                                                                                                            bottom: getIt<Functions>()
                                                                                                                .getWidgetHeight(height: 2)),
                                                                                                        decoration: BoxDecoration(
                                                                                                          borderRadius: BorderRadius.circular(8),
                                                                                                          color: const Color(0xff7AA440),
                                                                                                        ),
                                                                                                        child: Center(
                                                                                                          child: Text(
                                                                                                            (getIt<Functions>().getStringToList(
                                                                                                                value: context
                                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                                    .singleTabGroupedItemsList[index]
                                                                                                                        [idx]
                                                                                                                    .catchWeightInfo,
                                                                                                                quantity: context
                                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                                    .singleTabGroupedItemsList[index]
                                                                                                                        [idx]
                                                                                                                    .lineLoadedQty,
                                                                                                                weightUnit: context
                                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                                    .singleTabGroupedItemsList[index]
                                                                                                                        [idx]
                                                                                                                    .uom))[i],
                                                                                                            style: TextStyle(
                                                                                                                fontSize: getIt<Functions>()
                                                                                                                    .getTextSize(fontSize: 12),
                                                                                                                fontWeight: FontWeight.w500,
                                                                                                                color: const Color(0xffffffff)),
                                                                                                          ),
                                                                                                        ),
                                                                                                      )),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(),
                                                                                ],
                                                                              ),
                                                                        idx ==
                                                                                context
                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                        .singleTabGroupedItemsList[index]
                                                                                        .length -
                                                                                    1
                                                                            ? const SizedBox()
                                                                            : const Divider(color: Color(0xffE0E7EC))
                                                                      ],
                                                                    ),
                                                                  );
                                                                }),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              ],
                                            ),
                                          ],
                                        ),
                                );
                              case 1:
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: getIt<Functions>().getWidgetWidth(width: 12),
                                      right: getIt<Functions>().getWidgetWidth(width: 12),
                                      bottom: getIt<Functions>().getWidgetHeight(height: 12)),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                  child: context.read<WarehousePickupDetailBloc>().singleTabGroupingItemsList.isEmpty &&
                                          context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList.isEmpty
                                      ? Stack(
                                          children: [
                                            SizedBox(
                                              width: getIt<Variables>().generalVariables.width,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
                                                  const CupertinoActivityIndicator(),
                                                ],
                                              ),
                                            ),
                                            ListView(
                                              padding: EdgeInsets.zero,
                                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                              controller: _deliveredEmptyController,
                                              children: [
                                                Container(
                                                  color: const Color(0xffEEF4FF),
                                                  child: Column(
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
                                                        getIt<Variables>().generalVariables.currentLanguage.warehouseListIsEmpty,
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w600),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Stack(
                                          children: [
                                            SizedBox(
                                              width: getIt<Variables>().generalVariables.width,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
                                                  const CupertinoActivityIndicator(),
                                                ],
                                              ),
                                            ),
                                            ListView(
                                              padding: EdgeInsets.zero,
                                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                              controller: _deliveredScrollController,
                                              children: [
                                                context.read<WarehousePickupDetailBloc>().singleTabGroupingItemsList.isEmpty
                                                    ? const SizedBox()
                                                    : ListView.builder(
                                                        padding: EdgeInsets.zero,
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: context.read<WarehousePickupDetailBloc>().singleTabGroupingItemsList.length,
                                                        itemBuilder: (BuildContext context, int index) {
                                                          return Container(
                                                            margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                            child: DottedBorder(
                                                              color:
                                                                  getIt<Variables>().generalVariables.userData.userProfile.userName.toLowerCase() ==
                                                                          context
                                                                              .read<WarehousePickupDetailBloc>()
                                                                              .groupedKeepersNameList[index]
                                                                              .toLowerCase()
                                                                      ? const Color(0xff34C759)
                                                                      : Colors.grey,
                                                              strokeWidth: 1,
                                                              borderType: BorderType.RRect,
                                                              dashPattern: const [6, 3],
                                                              radius: const Radius.circular(12),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                                margin: EdgeInsets.only(
                                                                    bottom: getIt<Functions>().getWidgetHeight(
                                                                        height: context
                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                    .singleTabGroupingItemsList
                                                                                    .length >
                                                                                1
                                                                            ? 20
                                                                            : 0)),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      height: getIt<Functions>().getWidgetHeight(height: 36),
                                                                      decoration: const BoxDecoration(
                                                                        color: Color(0xffE3E7EA),
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                                                      ),
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: getIt<Functions>().getWidgetWidth(width: 14)),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          RichText(
                                                                            text: TextSpan(
                                                                              text:
                                                                                  "${getIt<Variables>().generalVariables.currentLanguage.loadingBay.toUpperCase()} : ",
                                                                              style: TextStyle(
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                  color: const Color(0xff282F3A),
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontFamily: "overpassmono"),
                                                                              children: [
                                                                                TextSpan(
                                                                                    text:
                                                                                        '${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayDryName} / ${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayFrozenName}',
                                                                                    style: TextStyle(
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                        color: const Color(0xff007AFF),
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontFamily: "overpassmono")),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    ListView.builder(
                                                                        padding: EdgeInsets.zero,
                                                                        physics: const NeverScrollableScrollPhysics(),
                                                                        shrinkWrap: true,
                                                                        itemCount: context
                                                                            .read<WarehousePickupDetailBloc>()
                                                                            .singleTabGroupingItemsList[index]
                                                                            .length,
                                                                        itemBuilder: (BuildContext context, int idx) {
                                                                          return InkWell(
                                                                            onTap: () {
                                                                              if (context
                                                                                      .read<WarehousePickupDetailBloc>()
                                                                                      .singleTabGroupingItemsList[index][idx]
                                                                                      .itemPickedStatus ==
                                                                                  "Picked") {
                                                                                getIt<Variables>().generalVariables.popUpWidget = yetToDeliverContent(
                                                                                    selectedItem: context
                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                        .singleTabGroupingItemsList[index][idx],
                                                                                    index: index,
                                                                                    idx: idx,
                                                                                    isDelivering: true);
                                                                                getIt<Functions>().showAnimatedDialog(
                                                                                    context: context, isFromTop: false, isCloseDisabled: false);
                                                                              } else {
                                                                                ScaffoldMessenger.of(context).clearSnackBars();
                                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                    content: Text(getIt<Variables>()
                                                                                        .generalVariables
                                                                                        .currentLanguage
                                                                                        .itemNotPicked)));
                                                                              }
                                                                            },
                                                                            child: Column(
                                                                              children: [
                                                                                Container(
                                                                                  padding: EdgeInsets.symmetric(
                                                                                      horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                                                                      vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          Container(
                                                                                              height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                                              width: getIt<Functions>().getWidgetWidth(width: 35),
                                                                                              decoration: BoxDecoration(
                                                                                                shape: BoxShape.circle,
                                                                                                color: Color(int.parse(
                                                                                                    "0XFF${context.read<WarehousePickupDetailBloc>().singleTabGroupingItemsList[index][idx].typeColor}")),
                                                                                              ),
                                                                                              child: Center(
                                                                                                child: Text(
                                                                                                  context
                                                                                                      .read<WarehousePickupDetailBloc>()
                                                                                                      .singleTabGroupingItemsList[index][idx]
                                                                                                      .itemType,
                                                                                                  style: TextStyle(
                                                                                                      color: const Color(0xffffffff),
                                                                                                      fontSize: getIt<Functions>()
                                                                                                          .getTextSize(fontSize: 16),
                                                                                                      fontWeight: FontWeight.w700),
                                                                                                ),
                                                                                              )),
                                                                                          SizedBox(
                                                                                              width: getIt<Functions>().getWidgetWidth(width: 10)),
                                                                                          Expanded(
                                                                                            child: Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                SingleChildScrollView(
                                                                                                  scrollDirection: Axis.horizontal,
                                                                                                  child: Text(
                                                                                                    context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabGroupingItemsList[index][idx]
                                                                                                        .itemName,
                                                                                                    maxLines: 1,
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        fontSize: getIt<Functions>()
                                                                                                            .getTextSize(fontSize: 16),
                                                                                                        color: const Color(0xff282F3A),
                                                                                                        overflow: TextOverflow.ellipsis),
                                                                                                  ),
                                                                                                ),
                                                                                                Text(
                                                                                                  "${getIt<Variables>().generalVariables.currentLanguage.remarks} : ${context.read<WarehousePickupDetailBloc>().singleTabGroupingItemsList[index][idx].remarks}",
                                                                                                  maxLines: 1,
                                                                                                  style: TextStyle(
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                      fontSize: getIt<Functions>()
                                                                                                          .getTextSize(fontSize: 11),
                                                                                                      color: const Color(0xff6F6F6F),
                                                                                                      overflow: TextOverflow.ellipsis),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: getIt<Functions>().getWidgetHeight(height: 46),
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: ListView(
                                                                                                scrollDirection: Axis.horizontal,
                                                                                                physics: const BouncingScrollPhysics(),
                                                                                                shrinkWrap: true,
                                                                                                padding: EdgeInsets.zero,
                                                                                                children: [
                                                                                                  Column(
                                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        getIt<Variables>()
                                                                                                            .generalVariables
                                                                                                            .currentLanguage
                                                                                                            .itemCode
                                                                                                            .toUpperCase(),
                                                                                                        style: TextStyle(
                                                                                                            fontWeight: FontWeight.w500,
                                                                                                            fontSize: getIt<Functions>()
                                                                                                                .getTextSize(fontSize: 10),
                                                                                                            color: const Color(0xff8A8D8E)),
                                                                                                      ),
                                                                                                      Text(
                                                                                                        context
                                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                                            .singleTabGroupingItemsList[index][idx]
                                                                                                            .itemCode,
                                                                                                        style: TextStyle(
                                                                                                            fontWeight: FontWeight.w600,
                                                                                                            fontSize: getIt<Functions>()
                                                                                                                .getTextSize(fontSize: 11),
                                                                                                            color: const Color(0xff282F3A)),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                      width: getIt<Functions>()
                                                                                                          .getWidgetWidth(width: 15)),
                                                                                                  Column(
                                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        "UOM",
                                                                                                        style: TextStyle(
                                                                                                            fontWeight: FontWeight.w500,
                                                                                                            fontSize: getIt<Functions>()
                                                                                                                .getTextSize(fontSize: 10),
                                                                                                            color: const Color(0xff8A8D8E)),
                                                                                                      ),
                                                                                                      Text(
                                                                                                        context
                                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                                            .singleTabGroupingItemsList[index][idx]
                                                                                                            .uom,
                                                                                                        style: TextStyle(
                                                                                                            fontWeight: FontWeight.w600,
                                                                                                            fontSize: getIt<Functions>()
                                                                                                                .getTextSize(fontSize: 11),
                                                                                                            color: const Color(0xff282F3A)),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                      width: getIt<Functions>()
                                                                                                          .getWidgetWidth(width: 15)),
                                                                                                  Column(
                                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        getIt<Variables>()
                                                                                                            .generalVariables
                                                                                                            .currentLanguage
                                                                                                            .packageTerms
                                                                                                            .toUpperCase(),
                                                                                                        style: TextStyle(
                                                                                                            fontWeight: FontWeight.w500,
                                                                                                            fontSize: getIt<Functions>()
                                                                                                                .getTextSize(fontSize: 10),
                                                                                                            color: const Color(0xff8A8D8E)),
                                                                                                      ),
                                                                                                      Text(
                                                                                                        context
                                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                                            .singleTabGroupingItemsList[index][idx]
                                                                                                            .packageTerms,
                                                                                                        style: TextStyle(
                                                                                                            fontWeight: FontWeight.w600,
                                                                                                            fontSize: getIt<Functions>()
                                                                                                                .getTextSize(fontSize: 11),
                                                                                                            color: const Color(0xff282F3A)),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                      width: getIt<Functions>()
                                                                                                          .getWidgetWidth(width: 30)),
                                                                                                  Column(
                                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        getIt<Variables>()
                                                                                                            .generalVariables
                                                                                                            .currentLanguage
                                                                                                            .sorter
                                                                                                            .toUpperCase(),
                                                                                                        style: TextStyle(
                                                                                                            fontWeight: FontWeight.w500,
                                                                                                            fontSize: getIt<Functions>()
                                                                                                                .getTextSize(fontSize: 10),
                                                                                                            color: const Color(0xff8A8D8E)),
                                                                                                      ),
                                                                                                      context
                                                                                                              .read<WarehousePickupDetailBloc>()
                                                                                                              .singleTabGroupingItemsList[index][idx]
                                                                                                              .handledBy
                                                                                                              .isNotEmpty
                                                                                                          ? Text(
                                                                                                              context
                                                                                                                  .read<WarehousePickupDetailBloc>()
                                                                                                                  .singleTabGroupingItemsList[index]
                                                                                                                      [idx]
                                                                                                                  .handledBy[0]
                                                                                                                  .name,
                                                                                                              style: TextStyle(
                                                                                                                  fontWeight: FontWeight.w600,
                                                                                                                  fontSize: getIt<Functions>()
                                                                                                                      .getTextSize(fontSize: 11),
                                                                                                                  color: const Color(0xff282F3A)),
                                                                                                            )
                                                                                                          : const SizedBox(),
                                                                                                    ],
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                                              children: [
                                                                                                Text(
                                                                                                  getIt<Functions>().formatNumber(
                                                                                                      qty: context
                                                                                                          .read<WarehousePickupDetailBloc>()
                                                                                                          .singleTabGroupingItemsList[index][idx]
                                                                                                          .lineLoadedQty),
                                                                                                  style: TextStyle(
                                                                                                      fontSize: getIt<Functions>()
                                                                                                          .getTextSize(fontSize: 17),
                                                                                                      fontWeight: FontWeight.w600,
                                                                                                      color: const Color(0xff29B473)),
                                                                                                ),
                                                                                                Text(
                                                                                                  getIt<Variables>()
                                                                                                      .generalVariables
                                                                                                      .currentLanguage
                                                                                                      .loadedQty
                                                                                                      .toUpperCase(),
                                                                                                  style: TextStyle(
                                                                                                      fontSize: getIt<Functions>()
                                                                                                          .getTextSize(fontSize: 10),
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                      color: const Color(0xff282F3A)),
                                                                                                ),
                                                                                              ],
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                context
                                                                                                .read<WarehousePickupDetailBloc>()
                                                                                                .singleTabGroupingItemsList[index][idx]
                                                                                                .catchWeightStatus ==
                                                                                            "No" ||
                                                                                        (getIt<Functions>().getStringToList(
                                                                                                value: context
                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                    .singleTabGroupingItemsList[index][idx]
                                                                                                    .catchWeightInfo,
                                                                                                quantity: context
                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                    .singleTabGroupingItemsList[index][idx]
                                                                                                    .lineLoadedQty,
                                                                                                weightUnit: context
                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                    .singleTabGroupingItemsList[index][idx]
                                                                                                    .uom))
                                                                                            .isEmpty
                                                                                    ? const SizedBox()
                                                                                    : Row(
                                                                                        children: [
                                                                                          Expanded(
                                                                                            child: Container(
                                                                                              decoration: const BoxDecoration(
                                                                                                color: Color(0xffCDE5FF),
                                                                                                borderRadius: BorderRadius.only(
                                                                                                    bottomLeft: Radius.circular(8),
                                                                                                    bottomRight: Radius.circular(8)),
                                                                                              ),
                                                                                              padding: EdgeInsets.only(
                                                                                                  left: getIt<Functions>().getWidgetWidth(width: 12),
                                                                                                  top: getIt<Functions>().getWidgetHeight(height: 8),
                                                                                                  bottom:
                                                                                                      getIt<Functions>().getWidgetHeight(height: 8)),
                                                                                              child: Wrap(
                                                                                                children: List.generate(
                                                                                                    (getIt<Functions>().getStringToList(
                                                                                                            value: context
                                                                                                                .read<WarehousePickupDetailBloc>()
                                                                                                                .singleTabGroupingItemsList[index]
                                                                                                                    [idx]
                                                                                                                .catchWeightInfo,
                                                                                                            quantity: context
                                                                                                                .read<WarehousePickupDetailBloc>()
                                                                                                                .singleTabGroupingItemsList[index]
                                                                                                                    [idx]
                                                                                                                .lineLoadedQty,
                                                                                                            weightUnit: context
                                                                                                                .read<WarehousePickupDetailBloc>()
                                                                                                                .singleTabGroupingItemsList[index]
                                                                                                                    [idx]
                                                                                                                .uom))
                                                                                                        .length,
                                                                                                    (i) => i == 0
                                                                                                        ? Padding(
                                                                                                            padding:
                                                                                                                const EdgeInsets.only(right: 10.0),
                                                                                                            child: SvgPicture.asset(
                                                                                                              "assets/catch_weight/measurement.svg",
                                                                                                              height: getIt<Functions>()
                                                                                                                  .getWidgetHeight(height: 20),
                                                                                                              width: getIt<Functions>()
                                                                                                                  .getWidgetWidth(width: 20),
                                                                                                              fit: BoxFit.fill,
                                                                                                            ),
                                                                                                          )
                                                                                                        : i == 1
                                                                                                            ? Container(
                                                                                                                height: getIt<Functions>()
                                                                                                                    .getWidgetHeight(height: 20),
                                                                                                                padding: EdgeInsets.symmetric(
                                                                                                                    horizontal: getIt<Functions>()
                                                                                                                        .getWidgetWidth(width: 8)),
                                                                                                                child: Text(
                                                                                                                  "${(getIt<Functions>().getStringToList(value: context.read<WarehousePickupDetailBloc>().singleTabGroupingItemsList[index][idx].catchWeightInfo, quantity: context.read<WarehousePickupDetailBloc>().singleTabGroupingItemsList[index][idx].quantity, weightUnit: context.read<WarehousePickupDetailBloc>().singleTabGroupingItemsList[index][idx].uom))[i]}  : ",
                                                                                                                  style: TextStyle(
                                                                                                                      fontSize: getIt<Functions>()
                                                                                                                          .getTextSize(fontSize: 12),
                                                                                                                      fontWeight: FontWeight.w600,
                                                                                                                      color: const Color(0xff282F3A)),
                                                                                                                ),
                                                                                                              )
                                                                                                            : Container(
                                                                                                                height: getIt<Functions>()
                                                                                                                    .getWidgetHeight(height: 20),
                                                                                                                width: getIt<Functions>().getWidgetWidth(
                                                                                                                    width: ((getIt<Functions>().getStringToList(
                                                                                                                                    value: context
                                                                                                                                        .read<
                                                                                                                                            WarehousePickupDetailBloc>()
                                                                                                                                        .singleTabGroupingItemsList[
                                                                                                                                            index]
                                                                                                                                            [idx]
                                                                                                                                        .catchWeightInfo,
                                                                                                                                    quantity: context
                                                                                                                                        .read<
                                                                                                                                            WarehousePickupDetailBloc>()
                                                                                                                                        .singleTabGroupingItemsList[
                                                                                                                                            index]
                                                                                                                                            [idx]
                                                                                                                                        .lineLoadedQty,
                                                                                                                                    weightUnit: context
                                                                                                                                        .read<
                                                                                                                                            WarehousePickupDetailBloc>()
                                                                                                                                        .singleTabGroupingItemsList[
                                                                                                                                            index]
                                                                                                                                            [idx]
                                                                                                                                        .uom))[i]
                                                                                                                                .length *
                                                                                                                            7) +
                                                                                                                        30),
                                                                                                                padding: EdgeInsets.symmetric(
                                                                                                                    horizontal: getIt<Functions>()
                                                                                                                        .getWidgetWidth(width: 12)),
                                                                                                                margin: EdgeInsets.only(
                                                                                                                    left: getIt<Functions>()
                                                                                                                        .getWidgetWidth(width: 6),
                                                                                                                    bottom: getIt<Functions>()
                                                                                                                        .getWidgetHeight(height: 2)),
                                                                                                                decoration: BoxDecoration(
                                                                                                                  borderRadius:
                                                                                                                      BorderRadius.circular(8),
                                                                                                                  color: const Color(0xff7AA440),
                                                                                                                ),
                                                                                                                child: Center(
                                                                                                                  child: Text(
                                                                                                                    (getIt<Functions>().getStringToList(
                                                                                                                        value: context
                                                                                                                            .read<
                                                                                                                                WarehousePickupDetailBloc>()
                                                                                                                            .singleTabGroupingItemsList[
                                                                                                                                index][idx]
                                                                                                                            .catchWeightInfo,
                                                                                                                        quantity: context
                                                                                                                            .read<
                                                                                                                                WarehousePickupDetailBloc>()
                                                                                                                            .singleTabGroupingItemsList[
                                                                                                                                index][idx]
                                                                                                                            .lineLoadedQty,
                                                                                                                        weightUnit: context
                                                                                                                            .read<
                                                                                                                                WarehousePickupDetailBloc>()
                                                                                                                            .singleTabGroupingItemsList[
                                                                                                                                index][idx]
                                                                                                                            .uom))[i],
                                                                                                                    style: TextStyle(
                                                                                                                        fontSize: getIt<Functions>()
                                                                                                                            .getTextSize(
                                                                                                                                fontSize: 12),
                                                                                                                        fontWeight: FontWeight.w500,
                                                                                                                        color:
                                                                                                                            const Color(0xffffffff)),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              )),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(),
                                                                                        ],
                                                                                      ),
                                                                                idx ==
                                                                                        context
                                                                                                .read<WarehousePickupDetailBloc>()
                                                                                                .singleTabGroupingItemsList[index]
                                                                                                .length -
                                                                                            1
                                                                                    ? const SizedBox()
                                                                                    : const Divider(color: Color(0xffE0E7EC))
                                                                              ],
                                                                            ),
                                                                          );
                                                                        }),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList.isEmpty
                                                    ? const SizedBox()
                                                    : ListView.builder(
                                                        padding: EdgeInsets.zero,
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList.length,
                                                        itemBuilder: (BuildContext context, int index) {
                                                          return Container(
                                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                            margin: EdgeInsets.only(
                                                                bottom: getIt<Functions>().getWidgetHeight(
                                                                    height:
                                                                        context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList.length > 1
                                                                            ? 20
                                                                            : 0)),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                  height: getIt<Functions>().getWidgetHeight(height: 36),
                                                                  decoration: const BoxDecoration(
                                                                    color: Color(0xffE3E7EA),
                                                                    borderRadius:
                                                                        BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                                                  ),
                                                                  padding:
                                                                      EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 14)),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      RichText(
                                                                        text: TextSpan(
                                                                          text:
                                                                              "${getIt<Variables>().generalVariables.currentLanguage.loadingBay.toUpperCase()} : ",
                                                                          style: TextStyle(
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                              color: const Color(0xff282F3A),
                                                                              fontWeight: FontWeight.w600,
                                                                              fontFamily: "overpassmono"),
                                                                          children: [
                                                                            TextSpan(
                                                                                text:
                                                                                    '${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayDryName} / ${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayFrozenName}',
                                                                                style: TextStyle(
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                    color: const Color(0xff007AFF),
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontFamily: "overpassmono")),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                ListView.builder(
                                                                    padding: EdgeInsets.zero,
                                                                    physics: const NeverScrollableScrollPhysics(),
                                                                    shrinkWrap: true,
                                                                    itemCount: context
                                                                        .read<WarehousePickupDetailBloc>()
                                                                        .singleTabGroupedItemsList[index]
                                                                        .length,
                                                                    itemBuilder: (BuildContext context, int idx) {
                                                                      return InkWell(
                                                                        onTap: () {
                                                                          if (context
                                                                                  .read<WarehousePickupDetailBloc>()
                                                                                  .singleTabGroupedItemsList[index][idx]
                                                                                  .itemPickedStatus ==
                                                                              "Picked") {
                                                                            getIt<Variables>().generalVariables.popUpWidget = yetToDeliverContent(
                                                                                selectedItem: context
                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                    .singleTabGroupedItemsList[index][idx],
                                                                                index: index,
                                                                                idx: idx,
                                                                                isDelivering: false);
                                                                            getIt<Functions>().showAnimatedDialog(
                                                                                context: context, isFromTop: false, isCloseDisabled: false);
                                                                          } else {
                                                                            ScaffoldMessenger.of(context).clearSnackBars();
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                content: Text(getIt<Variables>()
                                                                                    .generalVariables
                                                                                    .currentLanguage
                                                                                    .itemNotPicked)));
                                                                          }
                                                                        },
                                                                        child: Column(
                                                                          children: [
                                                                            Container(
                                                                              padding: EdgeInsets.symmetric(
                                                                                  horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                                                                  vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Container(
                                                                                          height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                                          width: getIt<Functions>().getWidgetWidth(width: 35),
                                                                                          decoration: BoxDecoration(
                                                                                            shape: BoxShape.circle,
                                                                                            color: Color(int.parse(
                                                                                                "0XFF${context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].typeColor}")),
                                                                                          ),
                                                                                          child: Center(
                                                                                            child: Text(
                                                                                              context
                                                                                                  .read<WarehousePickupDetailBloc>()
                                                                                                  .singleTabGroupedItemsList[index][idx]
                                                                                                  .itemType,
                                                                                              style: TextStyle(
                                                                                                  color: const Color(0xffffffff),
                                                                                                  fontSize:
                                                                                                      getIt<Functions>().getTextSize(fontSize: 16),
                                                                                                  fontWeight: FontWeight.w700),
                                                                                            ),
                                                                                          )),
                                                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 10)),
                                                                                      Expanded(
                                                                                        child: Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            SingleChildScrollView(
                                                                                              scrollDirection: Axis.horizontal,
                                                                                              child: Text(
                                                                                                context
                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                    .singleTabGroupedItemsList[index][idx]
                                                                                                    .itemName,
                                                                                                maxLines: 1,
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 16),
                                                                                                    color: const Color(0xff282F3A),
                                                                                                    overflow: TextOverflow.ellipsis),
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              "${getIt<Variables>().generalVariables.currentLanguage.remarks} : ${context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].remarks}",
                                                                                              maxLines: 1,
                                                                                              style: TextStyle(
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  fontSize:
                                                                                                      getIt<Functions>().getTextSize(fontSize: 11),
                                                                                                  color: const Color(0xff6F6F6F),
                                                                                                  overflow: TextOverflow.ellipsis),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: getIt<Functions>().getWidgetHeight(height: 46),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: ListView(
                                                                                            scrollDirection: Axis.horizontal,
                                                                                            physics: const BouncingScrollPhysics(),
                                                                                            shrinkWrap: true,
                                                                                            padding: EdgeInsets.zero,
                                                                                            children: [
                                                                                              Column(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    getIt<Variables>()
                                                                                                        .generalVariables
                                                                                                        .currentLanguage
                                                                                                        .itemCode
                                                                                                        .toUpperCase(),
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        fontSize: getIt<Functions>()
                                                                                                            .getTextSize(fontSize: 10),
                                                                                                        color: const Color(0xff8A8D8E)),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                                        .itemCode,
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        fontSize: getIt<Functions>()
                                                                                                            .getTextSize(fontSize: 11),
                                                                                                        color: const Color(0xff282F3A)),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              SizedBox(
                                                                                                  width:
                                                                                                      getIt<Functions>().getWidgetWidth(width: 15)),
                                                                                              Column(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    "UOM",
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        fontSize: getIt<Functions>()
                                                                                                            .getTextSize(fontSize: 10),
                                                                                                        color: const Color(0xff8A8D8E)),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                                        .uom,
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        fontSize: getIt<Functions>()
                                                                                                            .getTextSize(fontSize: 11),
                                                                                                        color: const Color(0xff282F3A)),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              SizedBox(
                                                                                                  width:
                                                                                                      getIt<Functions>().getWidgetWidth(width: 15)),
                                                                                              Column(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    getIt<Variables>()
                                                                                                        .generalVariables
                                                                                                        .currentLanguage
                                                                                                        .packageTerms
                                                                                                        .toUpperCase(),
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        fontSize: getIt<Functions>()
                                                                                                            .getTextSize(fontSize: 10),
                                                                                                        color: const Color(0xff8A8D8E)),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                                        .packageTerms,
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        fontSize: getIt<Functions>()
                                                                                                            .getTextSize(fontSize: 11),
                                                                                                        color: const Color(0xff282F3A)),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              SizedBox(
                                                                                                  width:
                                                                                                      getIt<Functions>().getWidgetWidth(width: 30)),
                                                                                              Column(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    getIt<Variables>()
                                                                                                        .generalVariables
                                                                                                        .currentLanguage
                                                                                                        .sorter
                                                                                                        .toUpperCase(),
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        fontSize: getIt<Functions>()
                                                                                                            .getTextSize(fontSize: 10),
                                                                                                        color: const Color(0xff8A8D8E)),
                                                                                                  ),
                                                                                                  context
                                                                                                          .read<WarehousePickupDetailBloc>()
                                                                                                          .singleTabGroupedItemsList[index][idx]
                                                                                                          .handledBy
                                                                                                          .isNotEmpty
                                                                                                      ? Text(
                                                                                                          context
                                                                                                              .read<WarehousePickupDetailBloc>()
                                                                                                              .singleTabGroupedItemsList[index][idx]
                                                                                                              .handledBy[0]
                                                                                                              .name,
                                                                                                          style: TextStyle(
                                                                                                              fontWeight: FontWeight.w600,
                                                                                                              fontSize: getIt<Functions>()
                                                                                                                  .getTextSize(fontSize: 11),
                                                                                                              color: const Color(0xff282F3A)),
                                                                                                        )
                                                                                                      : const SizedBox(),
                                                                                                ],
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                                          children: [
                                                                                            Text(
                                                                                              getIt<Functions>().formatNumber(
                                                                                                  qty: context
                                                                                                      .read<WarehousePickupDetailBloc>()
                                                                                                      .singleTabGroupedItemsList[index][idx]
                                                                                                      .lineLoadedQty),
                                                                                              style: TextStyle(
                                                                                                  fontSize:
                                                                                                      getIt<Functions>().getTextSize(fontSize: 17),
                                                                                                  fontWeight: FontWeight.w600,
                                                                                                  color: const Color(0xff29B473)),
                                                                                            ),
                                                                                            Text(
                                                                                              getIt<Variables>()
                                                                                                  .generalVariables
                                                                                                  .currentLanguage
                                                                                                  .loadedQty
                                                                                                  .toUpperCase(),
                                                                                              style: TextStyle(
                                                                                                  fontSize:
                                                                                                      getIt<Functions>().getTextSize(fontSize: 10),
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  color: const Color(0xff282F3A)),
                                                                                            ),
                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            context
                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                            .singleTabGroupedItemsList[index][idx]
                                                                                            .catchWeightStatus ==
                                                                                        "No" ||
                                                                                    (getIt<Functions>().getStringToList(
                                                                                            value: context
                                                                                                .read<WarehousePickupDetailBloc>()
                                                                                                .singleTabGroupedItemsList[index][idx]
                                                                                                .catchWeightInfo,
                                                                                            quantity: context
                                                                                                .read<WarehousePickupDetailBloc>()
                                                                                                .singleTabGroupedItemsList[index][idx]
                                                                                                .lineLoadedQty,
                                                                                            weightUnit: context
                                                                                                .read<WarehousePickupDetailBloc>()
                                                                                                .singleTabGroupedItemsList[index][idx]
                                                                                                .uom))
                                                                                        .isEmpty
                                                                                ? const SizedBox()
                                                                                : Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: Container(
                                                                                          decoration: const BoxDecoration(
                                                                                            color: Color(0xffCDE5FF),
                                                                                            borderRadius: BorderRadius.only(
                                                                                                bottomLeft: Radius.circular(8),
                                                                                                bottomRight: Radius.circular(8)),
                                                                                          ),
                                                                                          padding: EdgeInsets.only(
                                                                                              left: getIt<Functions>().getWidgetWidth(width: 12),
                                                                                              top: getIt<Functions>().getWidgetHeight(height: 8),
                                                                                              bottom: getIt<Functions>().getWidgetHeight(height: 8)),
                                                                                          child: Wrap(
                                                                                            children: List.generate(
                                                                                                (getIt<Functions>().getStringToList(
                                                                                                        value: context
                                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                                            .singleTabGroupedItemsList[index][idx]
                                                                                                            .catchWeightInfo,
                                                                                                        quantity: context
                                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                                            .singleTabGroupedItemsList[index][idx]
                                                                                                            .lineLoadedQty,
                                                                                                        weightUnit: context
                                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                                            .singleTabGroupedItemsList[index][idx]
                                                                                                            .uom))
                                                                                                    .length,
                                                                                                (i) => i == 0
                                                                                                    ? Padding(
                                                                                                        padding: const EdgeInsets.only(right: 10.0),
                                                                                                        child: SvgPicture.asset(
                                                                                                          "assets/catch_weight/measurement.svg",
                                                                                                          height: getIt<Functions>()
                                                                                                              .getWidgetHeight(height: 20),
                                                                                                          width: getIt<Functions>()
                                                                                                              .getWidgetWidth(width: 20),
                                                                                                          fit: BoxFit.fill,
                                                                                                        ),
                                                                                                      )
                                                                                                    : i == 1
                                                                                                        ? Container(
                                                                                                            height: getIt<Functions>()
                                                                                                                .getWidgetHeight(height: 20),
                                                                                                            padding: EdgeInsets.symmetric(
                                                                                                                horizontal: getIt<Functions>()
                                                                                                                    .getWidgetWidth(width: 8)),
                                                                                                            child: Text(
                                                                                                              "${(getIt<Functions>().getStringToList(value: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].catchWeightInfo, quantity: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].quantity, weightUnit: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].uom))[i]}  : ",
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: getIt<Functions>()
                                                                                                                      .getTextSize(fontSize: 12),
                                                                                                                  fontWeight: FontWeight.w600,
                                                                                                                  color: const Color(0xff282F3A)),
                                                                                                            ),
                                                                                                          )
                                                                                                        : Container(
                                                                                                            height: getIt<Functions>()
                                                                                                                .getWidgetHeight(height: 20),
                                                                                                            width: getIt<Functions>().getWidgetWidth(
                                                                                                                width: ((getIt<Functions>().getStringToList(
                                                                                                                                value: context
                                                                                                                                    .read<
                                                                                                                                        WarehousePickupDetailBloc>()
                                                                                                                                    .singleTabGroupedItemsList[
                                                                                                                                        index][idx]
                                                                                                                                    .catchWeightInfo,
                                                                                                                                quantity: context
                                                                                                                                    .read<
                                                                                                                                        WarehousePickupDetailBloc>()
                                                                                                                                    .singleTabGroupedItemsList[
                                                                                                                                        index][idx]
                                                                                                                                    .lineLoadedQty,
                                                                                                                                weightUnit: context
                                                                                                                                    .read<
                                                                                                                                        WarehousePickupDetailBloc>()
                                                                                                                                    .singleTabGroupedItemsList[
                                                                                                                                        index][idx]
                                                                                                                                    .uom))[i]
                                                                                                                            .length *
                                                                                                                        7) +
                                                                                                                    30),
                                                                                                            padding: EdgeInsets.symmetric(
                                                                                                                horizontal: getIt<Functions>()
                                                                                                                    .getWidgetWidth(width: 12)),
                                                                                                            margin: EdgeInsets.only(
                                                                                                                left: getIt<Functions>()
                                                                                                                    .getWidgetWidth(width: 6),
                                                                                                                bottom: getIt<Functions>()
                                                                                                                    .getWidgetHeight(height: 2)),
                                                                                                            decoration: BoxDecoration(
                                                                                                              borderRadius: BorderRadius.circular(8),
                                                                                                              color: const Color(0xff7AA440),
                                                                                                            ),
                                                                                                            child: Center(
                                                                                                              child: Text(
                                                                                                                (getIt<Functions>().getStringToList(
                                                                                                                    value: context
                                                                                                                        .read<
                                                                                                                            WarehousePickupDetailBloc>()
                                                                                                                        .singleTabGroupedItemsList[
                                                                                                                            index][idx]
                                                                                                                        .catchWeightInfo,
                                                                                                                    quantity: context
                                                                                                                        .read<
                                                                                                                            WarehousePickupDetailBloc>()
                                                                                                                        .singleTabGroupedItemsList[
                                                                                                                            index][idx]
                                                                                                                        .lineLoadedQty,
                                                                                                                    weightUnit: context
                                                                                                                        .read<
                                                                                                                            WarehousePickupDetailBloc>()
                                                                                                                        .singleTabGroupedItemsList[
                                                                                                                            index][idx]
                                                                                                                        .uom))[i],
                                                                                                                style: TextStyle(
                                                                                                                    fontSize: getIt<Functions>()
                                                                                                                        .getTextSize(fontSize: 12),
                                                                                                                    fontWeight: FontWeight.w500,
                                                                                                                    color: const Color(0xffffffff)),
                                                                                                              ),
                                                                                                            ),
                                                                                                          )),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(),
                                                                                    ],
                                                                                  ),
                                                                            idx ==
                                                                                    context
                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                            .singleTabGroupedItemsList[index]
                                                                                            .length -
                                                                                        1
                                                                                ? const SizedBox()
                                                                                : const Divider(color: Color(0xffE0E7EC))
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }),
                                                              ],
                                                            ),
                                                          );
                                                        }),
                                              ],
                                            ),
                                          ],
                                        ),
                                );
                              case 2:
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: getIt<Functions>().getWidgetWidth(width: 12),
                                      right: getIt<Functions>().getWidgetWidth(width: 12),
                                      bottom: getIt<Functions>().getWidgetHeight(height: 12)),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                  child: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList.isEmpty
                                      ? Stack(
                                          children: [
                                            SizedBox(
                                              width: getIt<Variables>().generalVariables.width,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
                                                  const CupertinoActivityIndicator(),
                                                ],
                                              ),
                                            ),
                                            ListView(
                                              padding: EdgeInsets.zero,
                                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                              controller: _unavailableScrollController,
                                              children: [
                                                Container(
                                                  color: const Color(0xffEEF4FF),
                                                  child: Column(
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
                                                        getIt<Variables>().generalVariables.currentLanguage.warehouseListIsEmpty,
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w600),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Stack(
                                          children: [
                                            SizedBox(
                                              width: getIt<Variables>().generalVariables.width,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
                                                  const CupertinoActivityIndicator(),
                                                ],
                                              ),
                                            ),
                                            ListView(
                                              padding: EdgeInsets.zero,
                                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                              controller: _unavailableEmptyController,
                                              children: [
                                                ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: context.read<WarehousePickupDetailBloc>().singleTabItemsList.length,
                                                    itemBuilder: (BuildContext context, int idx) {
                                                      return InkWell(
                                                        onTap: () {
                                                          if (context.read<WarehousePickupDetailBloc>().singleTabItemsList[idx].itemPickedStatus ==
                                                              "Picked") {
                                                            getIt<Variables>().generalVariables.popUpWidget = yetToDeliverContent(
                                                                selectedItem: context.read<WarehousePickupDetailBloc>().singleTabItemsList[idx],
                                                                index: idx,
                                                                idx: idx,
                                                                isDelivering: false);
                                                            getIt<Functions>()
                                                                .showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                                          } else {
                                                            ScaffoldMessenger.of(context).clearSnackBars();
                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                content: Text(getIt<Variables>().generalVariables.currentLanguage.itemNotPicked)));
                                                          }
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                          margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                height: getIt<Functions>().getWidgetHeight(height: 36),
                                                                decoration: const BoxDecoration(
                                                                  color: Color(0xffE3E7EA),
                                                                  borderRadius:
                                                                      BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                                                ),
                                                                padding:
                                                                    EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 14)),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    RichText(
                                                                      text: TextSpan(
                                                                        text:
                                                                            "${getIt<Variables>().generalVariables.currentLanguage.loadingBay.toUpperCase()} : ",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                            color: const Color(0xff282F3A),
                                                                            fontWeight: FontWeight.w600,
                                                                            fontFamily: "overpassmono"),
                                                                        children: [
                                                                          TextSpan(
                                                                              text:
                                                                                  '${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayDryName} / ${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayFrozenName}',
                                                                              style: TextStyle(
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                  color: const Color(0xff007AFF),
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontFamily: "overpassmono")),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    RichText(
                                                                      text: TextSpan(
                                                                        text:
                                                                            "${getIt<Variables>().generalVariables.currentLanguage.reason.toUpperCase()} : ",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                            color: const Color(0xff282F3A),
                                                                            fontWeight: FontWeight.w600,
                                                                            fontFamily: "overpassmono"),
                                                                        children: [
                                                                          TextSpan(
                                                                              text: context
                                                                                  .read<WarehousePickupDetailBloc>()
                                                                                  .singleTabItemsList[idx]
                                                                                  .itemLoadedUnavailableReason
                                                                                  .toUpperCase(),
                                                                              style: TextStyle(
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                  color: const Color(0xffDC4748),
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontFamily: "overpassmono")),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                                                    vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                                                decoration: const BoxDecoration(
                                                                  color: Color(0xffFFFFFF),
                                                                  borderRadius: BorderRadius.only(
                                                                      bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                                                ),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Container(
                                                                            height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                            width: getIt<Functions>().getWidgetWidth(width: 35),
                                                                            decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              color: Color(int.parse(
                                                                                  "0XFF${context.read<WarehousePickupDetailBloc>().singleTabItemsList[idx].typeColor}")),
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                context
                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                    .singleTabItemsList[idx]
                                                                                    .itemType,
                                                                                style: TextStyle(
                                                                                    color: const Color(0xffffffff),
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                    fontWeight: FontWeight.w700),
                                                                              ),
                                                                            )),
                                                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 10)),
                                                                        Expanded(
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                context
                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                    .singleTabItemsList[idx]
                                                                                    .itemName,
                                                                                maxLines: 1,
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                    color: const Color(0xff282F3A),
                                                                                    overflow: TextOverflow.ellipsis),
                                                                              ),
                                                                              Text(
                                                                                "${getIt<Variables>().generalVariables.currentLanguage.remarks} : ${context.read<WarehousePickupDetailBloc>().singleTabItemsList[idx].remarks}",
                                                                                maxLines: 1,
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                    color: const Color(0xff6F6F6F),
                                                                                    overflow: TextOverflow.ellipsis),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                    ),
                                                                    SizedBox(
                                                                      height: getIt<Functions>().getWidgetHeight(height: 46),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Expanded(
                                                                            child: ListView(
                                                                              scrollDirection: Axis.horizontal,
                                                                              physics: const BouncingScrollPhysics(),
                                                                              shrinkWrap: true,
                                                                              padding: EdgeInsets.zero,
                                                                              children: [
                                                                                Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Text(
                                                                                      getIt<Variables>()
                                                                                          .generalVariables
                                                                                          .currentLanguage
                                                                                          .itemCode
                                                                                          .toUpperCase(),
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                          color: const Color(0xff8A8D8E)),
                                                                                    ),
                                                                                    Text(
                                                                                      context
                                                                                          .read<WarehousePickupDetailBloc>()
                                                                                          .singleTabItemsList[idx]
                                                                                          .itemCode,
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w600,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                          color: const Color(0xff282F3A)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(width: getIt<Functions>().getWidgetWidth(width: 15)),
                                                                                Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Text(
                                                                                      "UOM",
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                          color: const Color(0xff8A8D8E)),
                                                                                    ),
                                                                                    Text(
                                                                                      context
                                                                                          .read<WarehousePickupDetailBloc>()
                                                                                          .singleTabItemsList[idx]
                                                                                          .uom,
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w600,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                          color: const Color(0xff282F3A)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(width: getIt<Functions>().getWidgetWidth(width: 15)),
                                                                                Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Text(
                                                                                      getIt<Variables>()
                                                                                          .generalVariables
                                                                                          .currentLanguage
                                                                                          .packageTerms
                                                                                          .toUpperCase(),
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                          color: const Color(0xff8A8D8E)),
                                                                                    ),
                                                                                    Text(
                                                                                      context
                                                                                          .read<WarehousePickupDetailBloc>()
                                                                                          .singleTabItemsList[idx]
                                                                                          .packageTerms,
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w600,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                          color: const Color(0xff282F3A)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(width: getIt<Functions>().getWidgetWidth(width: 30)),
                                                                                Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Text(
                                                                                      getIt<Variables>()
                                                                                          .generalVariables
                                                                                          .currentLanguage
                                                                                          .sorter
                                                                                          .toUpperCase(),
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                          color: const Color(0xff8A8D8E)),
                                                                                    ),
                                                                                    context
                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                            .singleTabItemsList[idx]
                                                                                            .handledBy
                                                                                            .isNotEmpty
                                                                                        ? Text(
                                                                                            context
                                                                                                .read<WarehousePickupDetailBloc>()
                                                                                                .singleTabItemsList[idx]
                                                                                                .handledBy[0]
                                                                                                .name,
                                                                                            style: TextStyle(
                                                                                                fontWeight: FontWeight.w600,
                                                                                                fontSize:
                                                                                                    getIt<Functions>().getTextSize(fontSize: 11),
                                                                                                color: const Color(0xff282F3A)),
                                                                                          )
                                                                                        : const SizedBox(),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Column(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                                            children: [
                                                                              Text(
                                                                                getIt<Functions>().formatNumber(
                                                                                    qty: context
                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                        .singleTabItemsList[idx]
                                                                                        .quantity),
                                                                                style: TextStyle(
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                    color: const Color(0xffDC4748),
                                                                                    fontWeight: FontWeight.w600),
                                                                              ),
                                                                              Text(
                                                                                getIt<Variables>().generalVariables.currentLanguage.qty.toUpperCase(),
                                                                                style: TextStyle(
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: const Color(0xff282F3A)),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              context.read<WarehousePickupDetailBloc>().singleTabItemsList[idx].catchWeightStatus ==
                                                                          "No" ||
                                                                      (getIt<Functions>().getStringToList(
                                                                              value: context
                                                                                  .read<WarehousePickupDetailBloc>()
                                                                                  .singleTabItemsList[idx]
                                                                                  .catchWeightInfo,
                                                                              quantity: context
                                                                                  .read<WarehousePickupDetailBloc>()
                                                                                  .singleTabItemsList[idx]
                                                                                  .lineLoadedQty,
                                                                              weightUnit: context
                                                                                  .read<WarehousePickupDetailBloc>()
                                                                                  .singleTabItemsList[idx]
                                                                                  .uom))
                                                                          .isEmpty
                                                                  ? const SizedBox()
                                                                  : Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child: Container(
                                                                            decoration: const BoxDecoration(
                                                                              color: Color(0xffCDE5FF),
                                                                              borderRadius: BorderRadius.only(
                                                                                  bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                                                            ),
                                                                            padding: EdgeInsets.only(
                                                                                left: getIt<Functions>().getWidgetWidth(width: 12),
                                                                                top: getIt<Functions>().getWidgetHeight(height: 8),
                                                                                bottom: getIt<Functions>().getWidgetHeight(height: 8)),
                                                                            child: Wrap(
                                                                              children: List.generate(
                                                                                  (getIt<Functions>().getStringToList(
                                                                                          value: context
                                                                                              .read<WarehousePickupDetailBloc>()
                                                                                              .singleTabItemsList[idx]
                                                                                              .catchWeightInfo,
                                                                                          quantity: context
                                                                                              .read<WarehousePickupDetailBloc>()
                                                                                              .singleTabItemsList[idx]
                                                                                              .lineLoadedQty,
                                                                                          weightUnit: context
                                                                                              .read<WarehousePickupDetailBloc>()
                                                                                              .singleTabItemsList[idx]
                                                                                              .uom))
                                                                                      .length,
                                                                                  (i) => i == 0
                                                                                      ? Padding(
                                                                                          padding: const EdgeInsets.only(right: 10.0),
                                                                                          child: SvgPicture.asset(
                                                                                            "assets/catch_weight/measurement.svg",
                                                                                            height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                            width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                                            fit: BoxFit.fill,
                                                                                          ),
                                                                                        )
                                                                                      : i == 1
                                                                                          ? Container(
                                                                                              height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                              padding: EdgeInsets.symmetric(
                                                                                                  horizontal:
                                                                                                      getIt<Functions>().getWidgetWidth(width: 8)),
                                                                                              child: Text(
                                                                                                "${(getIt<Functions>().getStringToList(value: context.read<WarehousePickupDetailBloc>().singleTabItemsList[idx].catchWeightInfo, quantity: context.read<WarehousePickupDetailBloc>().singleTabItemsList[idx].lineLoadedQty, weightUnit: context.read<WarehousePickupDetailBloc>().singleTabItemsList[idx].uom))[i]}  : ",
                                                                                                style: TextStyle(
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 12),
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    color: const Color(0xff282F3A)),
                                                                                              ),
                                                                                            )
                                                                                          : Container(
                                                                                              height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                              width: getIt<Functions>().getWidgetWidth(
                                                                                                  width: ((getIt<Functions>().getStringToList(
                                                                                                                  value: context
                                                                                                                      .read<
                                                                                                                          WarehousePickupDetailBloc>()
                                                                                                                      .singleTabItemsList[idx]
                                                                                                                      .catchWeightInfo,
                                                                                                                  quantity: context
                                                                                                                      .read<
                                                                                                                          WarehousePickupDetailBloc>()
                                                                                                                      .singleTabItemsList[idx]
                                                                                                                      .lineLoadedQty,
                                                                                                                  weightUnit: context
                                                                                                                      .read<
                                                                                                                          WarehousePickupDetailBloc>()
                                                                                                                      .singleTabItemsList[idx]
                                                                                                                      .uom))[i]
                                                                                                              .length *
                                                                                                          7) +
                                                                                                      30),
                                                                                              padding: EdgeInsets.symmetric(
                                                                                                  horizontal:
                                                                                                      getIt<Functions>().getWidgetWidth(width: 12)),
                                                                                              margin: EdgeInsets.only(
                                                                                                  left: getIt<Functions>().getWidgetWidth(width: 6),
                                                                                                  bottom:
                                                                                                      getIt<Functions>().getWidgetHeight(height: 2)),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.circular(8),
                                                                                                color: const Color(0xff7AA440),
                                                                                              ),
                                                                                              child: Center(
                                                                                                child: Text(
                                                                                                  (getIt<Functions>().getStringToList(
                                                                                                      value: context
                                                                                                          .read<WarehousePickupDetailBloc>()
                                                                                                          .singleTabItemsList[idx]
                                                                                                          .catchWeightInfo,
                                                                                                      quantity: context
                                                                                                          .read<WarehousePickupDetailBloc>()
                                                                                                          .singleTabItemsList[idx]
                                                                                                          .lineLoadedQty,
                                                                                                      weightUnit: context
                                                                                                          .read<WarehousePickupDetailBloc>()
                                                                                                          .singleTabItemsList[idx]
                                                                                                          .uom))[i],
                                                                                                  style: TextStyle(
                                                                                                      fontSize: getIt<Functions>()
                                                                                                          .getTextSize(fontSize: 12),
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                      color: const Color(0xffffffff)),
                                                                                                ),
                                                                                              ),
                                                                                            )),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(),
                                                                      ],
                                                                    ),
                                                              /*idx == context.read<WarehousePickupDetailBloc>().singleTabItemsList.length - 1
                                                                  ? const SizedBox()
                                                                  : const Divider(color: Color(0xffE0E7EC))*/
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ],
                                            ),
                                          ],
                                        ),
                                );
                              default:
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: getIt<Functions>().getWidgetWidth(width: 12),
                                      right: getIt<Functions>().getWidgetWidth(width: 12),
                                      bottom: getIt<Functions>().getWidgetHeight(height: 12)),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                  child: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList.isEmpty
                                      ? Stack(
                                          children: [
                                            SizedBox(
                                              width: getIt<Variables>().generalVariables.width,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
                                                  const CupertinoActivityIndicator(),
                                                ],
                                              ),
                                            ),
                                            ListView(
                                              padding: EdgeInsets.zero,
                                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                              controller: _pendingEmptyController,
                                              children: [
                                                Container(
                                                  color: const Color(0xffEEF4FF),
                                                  child: Column(
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
                                                        getIt<Variables>().generalVariables.currentLanguage.tripListItemsEmpty,
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w600),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Stack(
                                          children: [
                                            SizedBox(
                                              width: getIt<Variables>().generalVariables.width,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
                                                  const CupertinoActivityIndicator(),
                                                ],
                                              ),
                                            ),
                                            ListView(
                                              padding: EdgeInsets.zero,
                                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                              controller: _pendingScrollController,
                                              children: [
                                                ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemCount: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList.length,
                                                    shrinkWrap: true,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return Container(
                                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                        margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              height: getIt<Functions>().getWidgetHeight(height: 36),
                                                              decoration: const BoxDecoration(
                                                                color: Color(0xffE3E7EA),
                                                                borderRadius:
                                                                    BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                                              ),
                                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 14)),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  RichText(
                                                                    text: TextSpan(
                                                                      text:
                                                                          "${getIt<Variables>().generalVariables.currentLanguage.loadingBay.toUpperCase()} : ",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                          color: const Color(0xff282F3A),
                                                                          fontWeight: FontWeight.w600,
                                                                          fontFamily: "overpassmono"),
                                                                      children: [
                                                                        TextSpan(
                                                                            text:
                                                                                '${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayDryName} / ${getIt<Variables>().generalVariables.tripListMainIdData.tripLoadingBayFrozenName}',
                                                                            style: TextStyle(
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                color: const Color(0xff007AFF),
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: "overpassmono")),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            ListView.builder(
                                                                padding: EdgeInsets.zero,
                                                                physics: const NeverScrollableScrollPhysics(),
                                                                shrinkWrap: true,
                                                                itemCount:
                                                                    context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index].length,
                                                                itemBuilder: (BuildContext context, int idx) {
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      if (context
                                                                              .read<WarehousePickupDetailBloc>()
                                                                              .singleTabGroupedItemsList[index][idx]
                                                                              .itemPickedStatus ==
                                                                          "Picked") {
                                                                        getIt<Variables>().generalVariables.popUpWidget = yetToDeliverContent(
                                                                            selectedItem: context
                                                                                .read<WarehousePickupDetailBloc>()
                                                                                .singleTabGroupedItemsList[index][idx],
                                                                            index: index,
                                                                            idx: idx,
                                                                            isDelivering: false);
                                                                        getIt<Functions>().showAnimatedDialog(
                                                                            context: context, isFromTop: false, isCloseDisabled: false);
                                                                      } else {
                                                                        ScaffoldMessenger.of(context).clearSnackBars();
                                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                            content: Text(
                                                                                getIt<Variables>().generalVariables.currentLanguage.itemNotPicked)));
                                                                      }
                                                                    },
                                                                    child: Column(
                                                                      children: [
                                                                        Container(
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                                                              vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Container(
                                                                                      height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                                      width: getIt<Functions>().getWidgetWidth(width: 35),
                                                                                      decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        color: Color(int.parse(
                                                                                            "0XFF${context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].typeColor}")),
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          context
                                                                                              .read<WarehousePickupDetailBloc>()
                                                                                              .singleTabGroupedItemsList[index][idx]
                                                                                              .itemType,
                                                                                          style: TextStyle(
                                                                                              color: const Color(0xffffffff),
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                              fontWeight: FontWeight.w700),
                                                                                        ),
                                                                                      )),
                                                                                  SizedBox(width: getIt<Functions>().getWidgetWidth(width: 10)),
                                                                                  Expanded(
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        SingleChildScrollView(
                                                                                          scrollDirection: Axis.horizontal,
                                                                                          child: Text(
                                                                                            context
                                                                                                .read<WarehousePickupDetailBloc>()
                                                                                                .singleTabGroupedItemsList[index][idx]
                                                                                                .itemName,
                                                                                            maxLines: 1,
                                                                                            style: TextStyle(
                                                                                                fontWeight: FontWeight.w600,
                                                                                                fontSize:
                                                                                                    getIt<Functions>().getTextSize(fontSize: 16),
                                                                                                color: const Color(0xff282F3A),
                                                                                                overflow: TextOverflow.ellipsis),
                                                                                          ),
                                                                                        ),
                                                                                        Text(
                                                                                          "${getIt<Variables>().generalVariables.currentLanguage.remarks} : ${context.read<WarehousePickupDetailBloc>().singleTabItemsList[idx].remarks}",
                                                                                          maxLines: 1,
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                              color: const Color(0xff6F6F6F),
                                                                                              overflow: TextOverflow.ellipsis),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                              ),
                                                                              SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 46),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: ListView(
                                                                                        scrollDirection: Axis.horizontal,
                                                                                        physics: const BouncingScrollPhysics(),
                                                                                        shrinkWrap: true,
                                                                                        padding: EdgeInsets.zero,
                                                                                        children: [
                                                                                          Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            children: [
                                                                                              Text(
                                                                                                getIt<Variables>()
                                                                                                    .generalVariables
                                                                                                    .currentLanguage
                                                                                                    .itemCode
                                                                                                    .toUpperCase(),
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 10),
                                                                                                    color: const Color(0xff8A8D8E)),
                                                                                              ),
                                                                                              Text(
                                                                                                context
                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                    .singleTabGroupedItemsList[index][idx]
                                                                                                    .itemCode,
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 11),
                                                                                                    color: const Color(0xff282F3A)),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(
                                                                                              width: getIt<Functions>().getWidgetWidth(width: 15)),
                                                                                          Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            children: [
                                                                                              Text(
                                                                                                "UOM",
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 10),
                                                                                                    color: const Color(0xff8A8D8E)),
                                                                                              ),
                                                                                              Text(
                                                                                                context
                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                    .singleTabGroupedItemsList[index][idx]
                                                                                                    .uom,
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 11),
                                                                                                    color: const Color(0xff282F3A)),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(
                                                                                              width: getIt<Functions>().getWidgetWidth(width: 15)),
                                                                                          Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            children: [
                                                                                              Text(
                                                                                                getIt<Variables>()
                                                                                                    .generalVariables
                                                                                                    .currentLanguage
                                                                                                    .packageTerms
                                                                                                    .toUpperCase(),
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 10),
                                                                                                    color: const Color(0xff8A8D8E)),
                                                                                              ),
                                                                                              Text(
                                                                                                context
                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                    .singleTabGroupedItemsList[index][idx]
                                                                                                    .packageTerms,
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontSize:
                                                                                                        getIt<Functions>().getTextSize(fontSize: 11),
                                                                                                    color: const Color(0xff282F3A)),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                                      children: [
                                                                                        Text(
                                                                                          getIt<Functions>().formatNumber(
                                                                                              qty: context
                                                                                                  .read<WarehousePickupDetailBloc>()
                                                                                                  .singleTabGroupedItemsList[index][idx]
                                                                                                  .quantity),
                                                                                          style: TextStyle(
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                              fontWeight: FontWeight.w600,
                                                                                              color: const Color(0xff007AFF)),
                                                                                        ),
                                                                                        Text(
                                                                                          getIt<Variables>()
                                                                                              .generalVariables
                                                                                              .currentLanguage
                                                                                              .qty
                                                                                              .toUpperCase(),
                                                                                          style: TextStyle(
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
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
                                                                        ),
                                                                        context
                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                        .catchWeightStatus ==
                                                                                    "No" ||
                                                                                (getIt<Functions>().getStringToList(
                                                                                        value: context
                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                            .singleTabGroupedItemsList[index][idx]
                                                                                            .catchWeightInfo,
                                                                                        quantity: context
                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                            .singleTabGroupedItemsList[index][idx]
                                                                                            .lineLoadedQty,
                                                                                        weightUnit: context
                                                                                            .read<WarehousePickupDetailBloc>()
                                                                                            .singleTabGroupedItemsList[index][idx]
                                                                                            .uom))
                                                                                    .isEmpty
                                                                            ? const SizedBox()
                                                                            : Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Container(
                                                                                      decoration: const BoxDecoration(
                                                                                        color: Color(0xffCDE5FF),
                                                                                        borderRadius: BorderRadius.only(
                                                                                            bottomLeft: Radius.circular(8),
                                                                                            bottomRight: Radius.circular(8)),
                                                                                      ),
                                                                                      padding: EdgeInsets.only(
                                                                                          left: getIt<Functions>().getWidgetWidth(width: 12),
                                                                                          top: getIt<Functions>().getWidgetHeight(height: 8),
                                                                                          bottom: getIt<Functions>().getWidgetHeight(height: 8)),
                                                                                      child: Wrap(
                                                                                        children: List.generate(
                                                                                            (getIt<Functions>().getStringToList(
                                                                                                    value: context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                                        .catchWeightInfo,
                                                                                                    quantity: context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                                        .lineLoadedQty,
                                                                                                    weightUnit: context
                                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                                        .singleTabGroupedItemsList[index][idx]
                                                                                                        .uom))
                                                                                                .length,
                                                                                            (i) => i == 0
                                                                                                ? Padding(
                                                                                                    padding: const EdgeInsets.only(right: 10.0),
                                                                                                    child: SvgPicture.asset(
                                                                                                      "assets/catch_weight/measurement.svg",
                                                                                                      height: getIt<Functions>()
                                                                                                          .getWidgetHeight(height: 20),
                                                                                                      width: getIt<Functions>()
                                                                                                          .getWidgetWidth(width: 20),
                                                                                                      fit: BoxFit.fill,
                                                                                                    ),
                                                                                                  )
                                                                                                : i == 1
                                                                                                    ? Container(
                                                                                                        height: getIt<Functions>()
                                                                                                            .getWidgetHeight(height: 20),
                                                                                                        padding: EdgeInsets.symmetric(
                                                                                                            horizontal: getIt<Functions>()
                                                                                                                .getWidgetWidth(width: 8)),
                                                                                                        child: Text(
                                                                                                          "${(getIt<Functions>().getStringToList(value: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].catchWeightInfo, quantity: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].quantity, weightUnit: context.read<WarehousePickupDetailBloc>().singleTabGroupedItemsList[index][idx].uom))[i]}  : ",
                                                                                                          style: TextStyle(
                                                                                                              fontSize: getIt<Functions>()
                                                                                                                  .getTextSize(fontSize: 12),
                                                                                                              fontWeight: FontWeight.w600,
                                                                                                              color: const Color(0xff282F3A)),
                                                                                                        ),
                                                                                                      )
                                                                                                    : Container(
                                                                                                        height: getIt<Functions>()
                                                                                                            .getWidgetHeight(height: 20),
                                                                                                        width: getIt<Functions>().getWidgetWidth(
                                                                                                            width: ((getIt<Functions>().getStringToList(
                                                                                                                            value: context
                                                                                                                                .read<
                                                                                                                                    WarehousePickupDetailBloc>()
                                                                                                                                .singleTabGroupedItemsList[
                                                                                                                                    index][idx]
                                                                                                                                .catchWeightInfo,
                                                                                                                            quantity: context
                                                                                                                                .read<
                                                                                                                                    WarehousePickupDetailBloc>()
                                                                                                                                .singleTabGroupedItemsList[
                                                                                                                                    index][idx]
                                                                                                                                .lineLoadedQty,
                                                                                                                            weightUnit: context
                                                                                                                                .read<
                                                                                                                                    WarehousePickupDetailBloc>()
                                                                                                                                .singleTabGroupedItemsList[
                                                                                                                                    index][idx]
                                                                                                                                .uom))[i]
                                                                                                                        .length *
                                                                                                                    7) +
                                                                                                                30),
                                                                                                        padding: EdgeInsets.symmetric(
                                                                                                            horizontal: getIt<Functions>()
                                                                                                                .getWidgetWidth(width: 12)),
                                                                                                        margin: EdgeInsets.only(
                                                                                                            left: getIt<Functions>()
                                                                                                                .getWidgetWidth(width: 6),
                                                                                                            bottom: getIt<Functions>()
                                                                                                                .getWidgetHeight(height: 2)),
                                                                                                        decoration: BoxDecoration(
                                                                                                          borderRadius: BorderRadius.circular(8),
                                                                                                          color: const Color(0xff7AA440),
                                                                                                        ),
                                                                                                        child: Center(
                                                                                                          child: Text(
                                                                                                            (getIt<Functions>().getStringToList(
                                                                                                                value: context
                                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                                    .singleTabGroupedItemsList[index]
                                                                                                                        [idx]
                                                                                                                    .catchWeightInfo,
                                                                                                                quantity: context
                                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                                    .singleTabGroupedItemsList[index]
                                                                                                                        [idx]
                                                                                                                    .lineLoadedQty,
                                                                                                                weightUnit: context
                                                                                                                    .read<WarehousePickupDetailBloc>()
                                                                                                                    .singleTabGroupedItemsList[index]
                                                                                                                        [idx]
                                                                                                                    .uom))[i],
                                                                                                            style: TextStyle(
                                                                                                                fontSize: getIt<Functions>()
                                                                                                                    .getTextSize(fontSize: 12),
                                                                                                                fontWeight: FontWeight.w500,
                                                                                                                color: const Color(0xffffffff)),
                                                                                                          ),
                                                                                                        ),
                                                                                                      )),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(),
                                                                                ],
                                                                              ),
                                                                        idx ==
                                                                                context
                                                                                        .read<WarehousePickupDetailBloc>()
                                                                                        .singleTabGroupedItemsList[index]
                                                                                        .length -
                                                                                    1
                                                                            ? const SizedBox()
                                                                            : const Divider(color: Color(0xffE0E7EC))
                                                                      ],
                                                                    ),
                                                                  );
                                                                }),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              ],
                                            ),
                                          ],
                                        ),
                                );
                            }
                          } else if (state is WarehousePickupDetailLoading) {
                            return Container(
                              margin: EdgeInsets.only(
                                  left: getIt<Functions>().getWidgetWidth(width: 12),
                                  right: getIt<Functions>().getWidgetWidth(width: 12),
                                  bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                              child: Skeletonizer(
                                enabled: true,
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: const ScrollPhysics(),
                                    itemCount: 1,
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                        margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: getIt<Functions>().getWidgetHeight(height: 40),
                                              decoration: const BoxDecoration(
                                                color: Color(0xffE3E7EA),
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                                  vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                              child: IntrinsicHeight(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text("${getIt<Variables>().generalVariables.currentLanguage.floorNo.toUpperCase()} : F ",
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                            fontWeight: FontWeight.w600,
                                                            color: const Color(0xff282F3A))),
                                                    Text("${getIt<Variables>().generalVariables.currentLanguage.roomNo.toUpperCase()} : R",
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                            fontWeight: FontWeight.w600,
                                                            color: const Color(0xff282F3A))),
                                                    Text("${getIt<Variables>().generalVariables.currentLanguage.zoneNo.toUpperCase()} : Z",
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                            fontWeight: FontWeight.w600,
                                                            color: const Color(0xff282F3A))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            ListView.builder(
                                                padding: EdgeInsets.zero,
                                                physics: const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: 1,
                                                itemBuilder: (BuildContext context, int idx) {
                                                  return Container(
                                                    padding: EdgeInsets.only(
                                                        left: getIt<Functions>().getWidgetWidth(width: 12),
                                                        right: getIt<Functions>().getWidgetWidth(width: 12),
                                                        top: getIt<Functions>().getWidgetHeight(height: 12)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Skeleton.shade(
                                                              child: Container(
                                                                  height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                  width: getIt<Functions>().getWidgetWidth(width: 35),
                                                                  decoration: const BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    color: Colors.purpleAccent,
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "D",
                                                                      style: TextStyle(
                                                                          color: const Color(0xffffffff),
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          fontWeight: FontWeight.w700),
                                                                    ),
                                                                  )),
                                                            ),
                                                            SizedBox(
                                                              width: getIt<Functions>().getWidgetWidth(width: 10),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                "CORN FLOUR - 1KG",
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                    color: const Color(0xff282F3A),
                                                                    overflow: TextOverflow.ellipsis),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: getIt<Functions>().getWidgetHeight(height: 14),
                                                        ),
                                                        SizedBox(
                                                          height: getIt<Functions>().getWidgetHeight(height: 48),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Expanded(
                                                                child: SizedBox(
                                                                  height: getIt<Functions>().getWidgetHeight(height: 36),
                                                                  child: ListView(
                                                                    scrollDirection: Axis.horizontal,
                                                                    physics: const BouncingScrollPhysics(),
                                                                    shrinkWrap: true,
                                                                    padding: EdgeInsets.zero,
                                                                    children: [
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Text(
                                                                            getIt<Variables>()
                                                                                .generalVariables
                                                                                .currentLanguage
                                                                                .itemCode
                                                                                .toUpperCase(),
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                color: const Color(0xff8A8D8E)),
                                                                          ),
                                                                          Text(
                                                                            "F008",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 15)),
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "UOM",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                color: const Color(0xff8A8D8E)),
                                                                          ),
                                                                          Text(
                                                                            "UOM",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 15)),
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            getIt<Variables>()
                                                                                .generalVariables
                                                                                .currentLanguage
                                                                                .packageTerms
                                                                                .toUpperCase(),
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                color: const Color(0xff8A8D8E)),
                                                                          ),
                                                                          Text(
                                                                            "Package Terms",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 10),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    "24",
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff007AFF)),
                                                                  ),
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.qtyToSort.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                        fontWeight: FontWeight.w500,
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 8)),
                                                      ],
                                                    ),
                                                  );
                                                })
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
        );
      },
    );
  }

  Widget textBars({required TextEditingController controller}) {
    return BlocBuilder<WarehousePickupDetailBloc, WarehousePickupDetailState>(
      builder: (BuildContext context, WarehousePickupDetailState tripList) {
        return Padding(
          padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 15)),
          child: SizedBox(
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
                      if (timer?.isActive ?? false) timer?.cancel();
                      timer = Timer(const Duration(milliseconds: 500), () {
                        if (value.isNotEmpty) {
                          context.read<WarehousePickupDetailBloc>().searchText = value;
                          context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailFilterEvent());
                        } else {
                          FocusManager.instance.primaryFocus!.unfocus();
                          context.read<WarehousePickupDetailBloc>().searchText = "";
                          context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailFilterEvent());
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
                                  context.read<WarehousePickupDetailBloc>().searchText = "";
                                  context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailFilterEvent());
                                },
                                icon: const Icon(Icons.clear, color: Colors.white, size: 15))
                            : const SizedBox(),
                        hintText: getIt<Variables>().generalVariables.currentLanguage.search,
                        hintStyle: TextStyle(
                            color: const Color(0xffffffff), fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 15))),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget yetToDeliverContent({
    required bool isDelivering,
    required ItemsList selectedItem,
    required int index,
    required int idx,
  }) {
    context.read<WarehousePickupDetailBloc>().selectedItemId = selectedItem.itemId;
    context.read<WarehousePickupDetailBloc>().deliveredQuantityData = {};
    context.read<WarehousePickupDetailBloc>().deliveredCatchWeightData = [];
    context.read<WarehousePickupDetailBloc>().updateLoader = false;
    context.read<WarehousePickupDetailBloc>().selectedForDeliveredItem = selectedItem;
    List<CatchWeightItem> catchWeightData =
        selectedItem.catchWeightStatus != "No" ? getIt<Functions>().getStringToCatchWeight(value: selectedItem.catchWeightInfo) : [];
    if (selectedItem.catchWeightStatus != "No") {
      selectedItem.itemBatchesList[0].batchLoadedQty = "0";
      selectedItem.lineLoadedQty = "0";
      for (int i = 0; i < catchWeightData.length; i++) {
        catchWeightData[i].isSelected = true;
        catchWeightData[i].isSelectedAlready = true;
      }
      selectedItem.itemBatchesList[0].batchSortedQty = selectedItem.quantity;
      selectedItem.lineLoadedQty = selectedItem.quantity;
    }
    return SizedBox(
      width: getIt<Functions>().getWidgetWidth(width: 600),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: getIt<Functions>().getWidgetHeight(height: 35),
                    width: getIt<Functions>().getWidgetWidth(width: 35),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(int.parse("0XFF${selectedItem.typeColor}")),
                    ),
                    child: Center(
                      child: Text(
                        selectedItem.itemType,
                        style: TextStyle(
                            color: const Color(0xffffffff),
                            fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 24 : 12),
                            fontWeight: FontWeight.w700),
                      ),
                    )),
                SizedBox(
                  width: getIt<Functions>().getWidgetWidth(width: 10),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          selectedItem.itemName,
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 18 : 14),
                              color: const Color(0xff282F3A),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Text(
                                "${getIt<Variables>().generalVariables.currentLanguage.totalQty} : ${getIt<Functions>().formatNumber(qty: selectedItem.quantity)} ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 15 : 12),
                                    color: const Color(0xff007AFF)),
                              ),
                              SizedBox(
                                height: getIt<Functions>().getWidgetHeight(height: 15),
                                child: const VerticalDivider(
                                  width: 0,
                                  thickness: 1,
                                  color: Color(0xff8A8D8E),
                                ),
                              ),
                              Text(
                                "  UOM : ${selectedItem.uom}  ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 15 : 12),
                                    color: const Color(0xff007AFF)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
          const Divider(height: 0, thickness: 1, color: Color(0xffE0E7EC)),
          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
          BlocBuilder<WarehousePickupDetailBloc, WarehousePickupDetailState>(
            builder: (BuildContext context, WarehousePickupDetailState state) {
              return Scrollbar(
                child: Container(
                  height: getIt<Functions>()
                      .getWidgetHeight(height: (selectedItem.itemBatchesList.length >= 4 ? 160 : selectedItem.itemBatchesList.length * 40) + 50),
                  padding: EdgeInsets.zero,
                  child: DataTable2(
                      columnSpacing: getIt<Functions>().getWidgetWidth(width: 0),
                      horizontalMargin: getIt<Functions>().getWidgetWidth(width: 15),
                      headingRowColor: const WidgetStatePropertyAll<Color>(Color(0xffE0E7EC)),
                      headingRowDecoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                      headingRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                      dividerThickness: 0,
                      dataRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                      isHorizontalScrollBarVisible: false,
                      columns: selectedItem.catchWeightStatus == "No"
                          ? [
                              DataColumn2(
                                label: Text(
                                  maxLines: 2,
                                  "${getIt<Variables>().generalVariables.currentLanguage.batch.toLowerCase().replaceFirst('b', "B")} #",
                                  style: TextStyle(
                                      color: const Color(0xff282F3A),
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                ),
                                size: ColumnSize.M,
                              ),
                              DataColumn2(
                                label: Text(
                                  maxLines: 2,
                                  softWrap: true,
                                  getIt<Variables>().generalVariables.currentLanguage.expiryDate.toLowerCase().replaceFirst('e', "E"),
                                  style: TextStyle(
                                      color: const Color(0xff282F3A),
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                ),
                                size: ColumnSize.L,
                              ),
                              DataColumn2(
                                label: Text(
                                  maxLines: 2,
                                  softWrap: true,
                                  getIt<Variables>().generalVariables.currentLanguage.stockType,
                                  style: TextStyle(
                                      color: const Color(0xff282F3A),
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                ),
                                size: ColumnSize.M,
                              ),
                              DataColumn2(
                                label: Text(
                                  maxLines: 2,
                                  softWrap: true,
                                  getIt<Variables>().generalVariables.isDeviceTablet
                                      ? getIt<Variables>().generalVariables.currentLanguage.requiredQty
                                      : getIt<Variables>().generalVariables.currentLanguage.reqQty,
                                  style: TextStyle(
                                      color: const Color(0xff282F3A),
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                ),
                                size: ColumnSize.M,
                              ),
                            ]
                          : [
                              DataColumn2(
                                label: Text(
                                  maxLines: 2,
                                  softWrap: true,
                                  "${getIt<Variables>().generalVariables.currentLanguage.batch.toLowerCase().replaceFirst('b', "B")} #",
                                  style: TextStyle(
                                      color: const Color(0xff282F3A),
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                ),
                                size: ColumnSize.M,
                              ),
                              DataColumn2(
                                label: Text(
                                  maxLines: 2,
                                  softWrap: true,
                                  getIt<Variables>().generalVariables.currentLanguage.expiryDate.toLowerCase().replaceFirst('e', "E"),
                                  style: TextStyle(
                                      color: const Color(0xff282F3A),
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                ),
                                size: ColumnSize.L,
                              ),
                              DataColumn2(
                                label: Text(
                                  maxLines: 2,
                                  softWrap: true,
                                  getIt<Variables>().generalVariables.currentLanguage.stockType,
                                  style: TextStyle(
                                      color: const Color(0xff282F3A),
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                ),
                                size: ColumnSize.L,
                              ),
                              DataColumn2(
                                label: Text(
                                  maxLines: 2,
                                  softWrap: true,
                                  getIt<Variables>().generalVariables.isDeviceTablet
                                      ? getIt<Variables>().generalVariables.currentLanguage.requiredQty
                                      : getIt<Variables>().generalVariables.currentLanguage.reqQty,
                                  style: TextStyle(
                                      color: const Color(0xff282F3A),
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                ),
                                size: ColumnSize.M,
                              ),
                            ],
                      rows: List<DataRow>.generate(selectedItem.itemBatchesList.length, (i) {
                        return DataRow(
                            cells: selectedItem.catchWeightStatus == "No"
                                ? [
                                    DataCell(Text(selectedItem.itemBatchesList[i].batchNum,
                                        style: TextStyle(
                                            color: const Color(0xff282F3A),
                                            fontWeight: FontWeight.w500,
                                            fontSize: getIt<Functions>()
                                                .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)))),
                                    DataCell(Text(selectedItem.itemBatchesList[i].expiryDate.toString().substring(0, 10),
                                        style: TextStyle(
                                            color: const Color(0xff282F3A),
                                            fontWeight: FontWeight.w500,
                                            fontSize: getIt<Functions>()
                                                .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)))),
                                    DataCell(Text(selectedItem.itemBatchesList[i].stockType,
                                        style: TextStyle(
                                            color: const Color(0xff282F3A),
                                            fontWeight: FontWeight.w500,
                                            fontSize: getIt<Functions>()
                                                .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)))),
                                    DataCell(Center(
                                        child: Text(getIt<Functions>().formatNumber(qty: selectedItem.itemBatchesList[i].quantity),
                                            style: TextStyle(
                                                color: const Color(0xffC38C19),
                                                fontWeight: FontWeight.w500,
                                                fontSize: getIt<Functions>()
                                                    .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11))))),
                                  ]
                                : [
                                    DataCell(Text(selectedItem.itemBatchesList[i].batchNum,
                                        style: TextStyle(
                                            color: const Color(0xff282F3A),
                                            fontWeight: FontWeight.w500,
                                            fontSize: getIt<Functions>()
                                                .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)))),
                                    DataCell(Text(selectedItem.itemBatchesList[i].expiryDate.toString().substring(0, 10),
                                        style: TextStyle(
                                            color: const Color(0xff282F3A),
                                            fontWeight: FontWeight.w500,
                                            fontSize: getIt<Functions>()
                                                .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)))),
                                    DataCell(Text(selectedItem.itemBatchesList[i].stockType,
                                        style: TextStyle(
                                            color: const Color(0xff282F3A),
                                            fontWeight: FontWeight.w500,
                                            fontSize: getIt<Functions>()
                                                .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)))),
                                    DataCell(Text(getIt<Functions>().formatNumber(qty: selectedItem.itemBatchesList[i].quantity),
                                        style: TextStyle(
                                            color: const Color(0xffC38C19),
                                            fontWeight: FontWeight.w500,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 11)))),
                                  ]);
                      })),
                ),
              );
            },
          ),
          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 15)),
          BlocBuilder<WarehousePickupDetailBloc, WarehousePickupDetailState>(builder: (BuildContext context, WarehousePickupDetailState state) {
            return Column(
              children: [
                selectedItem.catchWeightStatus != "No" ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)) : const SizedBox(),
                selectedItem.catchWeightStatus != "No" ? const Divider(height: 0, thickness: 1, color: Color(0xffE0E7EC)) : const SizedBox(),
                selectedItem.catchWeightStatus != "No" ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)) : const SizedBox(),
                selectedItem.catchWeightStatus != "No"
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 20 : 12)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getIt<Variables>().generalVariables.currentLanguage.catchWeight,
                              style: TextStyle(
                                  color: const Color(0xff282F3A),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                            ),
                            SizedBox(
                              height: getIt<Functions>().getWidgetHeight(height: 10),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: List.generate(
                                        catchWeightData.length,
                                        (idx) => InkWell(
                                              onTap: () {
                                                if (!(catchWeightData[idx].isSelectedAlready)) {
                                                  catchWeightData[idx].isSelected = !(catchWeightData[idx].isSelected);
                                                  context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailSetStateEvent());
                                                }
                                              },
                                              child: Container(
                                                height: getIt<Functions>().getWidgetHeight(height: 25),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: getIt<Functions>().getWidgetWidth(width: 8),
                                                    vertical: getIt<Functions>().getWidgetHeight(height: 4)),
                                                margin: EdgeInsets.only(
                                                    left: getIt<Functions>().getWidgetWidth(width: idx == 0 ? 0 : 6),
                                                    top: getIt<Functions>().getWidgetHeight(height: 6)),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: catchWeightData[idx].isSelected ? const Color(0xff29B473) : const Color(0xffEEF4FF),
                                                ),
                                                child: Text(
                                                  catchWeightData[idx].data,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      fontWeight: FontWeight.w500,
                                                      color: catchWeightData[idx].isSelected ? const Color(0xffffffff) : const Color(0xff1D2736)),
                                                ),
                                              ),
                                            )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ],
            );
          }),
          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 15)),
          BlocConsumer<WarehousePickupDetailBloc, WarehousePickupDetailState>(
            listenWhen: (WarehousePickupDetailState previous, WarehousePickupDetailState current) {
              return previous != current;
            },
            buildWhen: (WarehousePickupDetailState previous, WarehousePickupDetailState current) {
              return previous != current;
            },
            listener: (BuildContext context, WarehousePickupDetailState state) {
              if (state is WarehousePickupDetailSuccess) {
                context.read<WarehousePickupDetailBloc>().updateLoader = false;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).clearSnackBars();
                if (state.message != "") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                }
              }
              if (state is WarehousePickupDetailFailure) {
                context.read<WarehousePickupDetailBloc>().updateLoader = false;
                context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailSetStateEvent());
              }
              if (state is WarehousePickupDetailError) {
                context.read<WarehousePickupDetailBloc>().updateLoader = false;
                ScaffoldMessenger.of(context).clearSnackBars();
                getIt<Widgets>().flushBarWidget(context: context, message: state.message);
              }
            },
            builder: (BuildContext context, WarehousePickupDetailState state) {
              return selectedItem.isCompleted
                  ? InkWell(
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
                          child: Text(getIt<Variables>().generalVariables.currentLanguage.close.toUpperCase(),
                              style: TextStyle(
                                  color: const Color(0xff282F3A),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    )
                  : context.read<WarehousePickupDetailBloc>().updateLoader
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
                      : context.read<WarehousePickupDetailBloc>().tabIndex == 0
                          ? SizedBox(
                              height: getIt<Functions>().getWidgetHeight(height: 50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        Navigator.pop(context);
                                        getIt<Variables>().generalVariables.popUpWidget =
                                            unavailableContent(selectedItem: selectedItem, index: index, idx: idx, isDelivering: isDelivering);
                                        getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                      },
                                      child: Container(
                                        height: getIt<Functions>().getWidgetHeight(height: 50),
                                        width:
                                            getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 300 : 206),
                                        decoration: const BoxDecoration(
                                          color: Color(0xffDC474A),
                                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            maxLines: 2,
                                            getIt<Variables>().generalVariables.currentLanguage.markAsUnavailable.toUpperCase(),
                                            style: TextStyle(
                                                color: const Color(0xffffffff),
                                                fontWeight: FontWeight.w600,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        if (selectedItem.catchWeightStatus != "No") {
                                          for (int i = 0; i < catchWeightData.length; i++) {
                                            if (catchWeightData[i].isSelected) {
                                              context.read<WarehousePickupDetailBloc>().deliveredCatchWeightData.add(catchWeightData[i].data);
                                            }
                                          }
                                          if (context.read<WarehousePickupDetailBloc>().deliveredCatchWeightData.isEmpty) {
                                            context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailSetStateEvent());
                                          } else {
                                            context.read<WarehousePickupDetailBloc>().updateLoader = true;
                                            FocusManager.instance.primaryFocus!.unfocus();
                                            context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailSetStateEvent());
                                            context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailDeliveredEvent());
                                          }
                                        } else {
                                          for (int i = 0; i < selectedItem.itemBatchesList.length; i++) {
                                            context.read<WarehousePickupDetailBloc>().deliveredQuantityData[selectedItem.itemBatchesList[i].batchId] =
                                                selectedItem.itemBatchesList[i].quantity;
                                          }
                                          if (context.read<WarehousePickupDetailBloc>().deliveredQuantityData.keys.isEmpty) {
                                            context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailSetStateEvent());
                                          } else {
                                            context.read<WarehousePickupDetailBloc>().updateLoader = true;
                                            FocusManager.instance.primaryFocus!.unfocus();
                                            context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailSetStateEvent());
                                            context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailDeliveredEvent());
                                          }
                                        }
                                      },
                                      child: Container(
                                        height: getIt<Functions>().getWidgetHeight(height: 50),
                                        width:
                                            getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 300 : 206),
                                        decoration: const BoxDecoration(
                                          color: Color(0xff007838),
                                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(15)),
                                        ),
                                        child: Center(
                                          child: Text(
                                              maxLines: 1,
                                              getIt<Variables>().generalVariables.currentLanguage.deliver.toUpperCase(),
                                              style: TextStyle(
                                                  color: const Color(0xffffffff),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                                              textAlign: TextAlign.center),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : context.read<WarehousePickupDetailBloc>().tabIndex == 2
                              ? InkWell(
                                  onTap: () async {
                                    if (selectedItem.catchWeightStatus != "No") {
                                      for (int i = 0; i < catchWeightData.length; i++) {
                                        if (catchWeightData[i].isSelected) {
                                          context.read<WarehousePickupDetailBloc>().deliveredCatchWeightData.add(catchWeightData[i].data);
                                        }
                                      }
                                      if (context.read<WarehousePickupDetailBloc>().deliveredCatchWeightData.isEmpty) {
                                        context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailSetStateEvent());
                                      } else {
                                        context.read<WarehousePickupDetailBloc>().updateLoader = true;
                                        FocusManager.instance.primaryFocus!.unfocus();
                                        context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailSetStateEvent());
                                        context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailDeliveredEvent());
                                      }
                                    } else {
                                      for (int i = 0; i < selectedItem.itemBatchesList.length; i++) {
                                        context.read<WarehousePickupDetailBloc>().deliveredQuantityData[selectedItem.itemBatchesList[i].batchId] =
                                            selectedItem.itemBatchesList[i].quantity;
                                      }
                                      if (context.read<WarehousePickupDetailBloc>().deliveredQuantityData.keys.isEmpty) {
                                        context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailSetStateEvent());
                                      } else {
                                        context.read<WarehousePickupDetailBloc>().updateLoader = true;
                                        FocusManager.instance.primaryFocus!.unfocus();
                                        context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailSetStateEvent());
                                        context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailDeliveredEvent());
                                      }
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
                                        getIt<Variables>().generalVariables.currentLanguage.deliver.toUpperCase(),
                                        style: TextStyle(
                                            color: const Color(0xffffffff),
                                            fontWeight: FontWeight.w600,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                                      ),
                                    ),
                                  ),
                                )
                              : getIt<Variables>().generalVariables.userDataEmployeeCode ==
                                      (selectedItem.handledBy.isNotEmpty ? selectedItem.handledBy[0].code : "")
                                  ? isDelivering
                                      ? InkWell(
                                          onTap: () async {
                                            context.read<WarehousePickupDetailBloc>().updateLoader = true;
                                            FocusManager.instance.primaryFocus!.unfocus();
                                            context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailSetStateEvent());
                                            context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailUndoDeliveredEvent());
                                          },
                                          child: Container(
                                            height: getIt<Functions>().getWidgetHeight(height: 50),
                                            decoration: const BoxDecoration(
                                              color: Color(0xffDC474A),
                                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                            ),
                                            child: Center(
                                              child: Text(
                                                getIt<Variables>().generalVariables.currentLanguage.undoDelivered.toUpperCase(),
                                                style: TextStyle(
                                                    color: const Color(0xffffffff),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () async {
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
                                              child: Text(getIt<Variables>().generalVariables.currentLanguage.close.toUpperCase(),
                                                  style: TextStyle(
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                                                  textAlign: TextAlign.center),
                                            ),
                                          ),
                                        )
                                  : InkWell(
                                      onTap: () async {
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
                                          child: Text(getIt<Variables>().generalVariables.currentLanguage.close.toUpperCase(),
                                              style: TextStyle(
                                                  color: const Color(0xff282F3A),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                                              textAlign: TextAlign.center),
                                        ),
                                      ),
                                    );
            },
          )
        ],
      ),
    );
  }

  Widget unavailableContent({
    required bool isDelivering,
    required ItemsList selectedItem,
    required int index,
    required int idx,
  }) {
    context.read<WarehousePickupDetailBloc>().selectedItemId = selectedItem.itemId;
    context.read<WarehousePickupDetailBloc>().updateLoader = false;
    context.read<WarehousePickupDetailBloc>().selectedReasonEmpty = false;
    context.read<WarehousePickupDetailBloc>().commentTextEmpty = false;
    reasonSearchFieldController.clear();
    context.read<WarehousePickupDetailBloc>().selectedReason = "";
    context.read<WarehousePickupDetailBloc>().selectedReasonName = null;
    commentsBar.clear();
    context.read<WarehousePickupDetailBloc>().selectedForDeliveredItem = selectedItem;
    return BlocConsumer<WarehousePickupDetailBloc, WarehousePickupDetailState>(
      listenWhen: (WarehousePickupDetailState previous, WarehousePickupDetailState current) {
        return previous != current;
      },
      buildWhen: (WarehousePickupDetailState previous, WarehousePickupDetailState current) {
        return previous != current;
      },
      listener: (BuildContext context, WarehousePickupDetailState state) {
        if (state is WarehousePickupDetailSuccess) {
          context.read<WarehousePickupDetailBloc>().updateLoader = false;
          Navigator.pop(context);
          ScaffoldMessenger.of(context).clearSnackBars();
          if (state.message != "") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        }
        if (state is WarehousePickupDetailFailure) {
          context.read<WarehousePickupDetailBloc>().updateLoader = false;
          context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailSetStateEvent());
        }
        if (state is WarehousePickupDetailError) {
          context.read<WarehousePickupDetailBloc>().updateLoader = false;
          ScaffoldMessenger.of(context).clearSnackBars();
          getIt<Widgets>().flushBarWidget(context: context, message: state.message);
        }
      },
      builder: (BuildContext context, WarehousePickupDetailState state) {
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
                        onTap: context.read<WarehousePickupDetailBloc>().updateLoader
                            ? () {}
                            : () {
                                FocusManager.instance.primaryFocus!.unfocus();
                                Navigator.pop(context);
                                getIt<Variables>().generalVariables.popUpWidget =
                                    yetToDeliverContent(selectedItem: selectedItem, index: index, idx: idx, isDelivering: isDelivering);
                                getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                              },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xff292D32),
                        )),
                    Container(
                        height: getIt<Functions>().getWidgetHeight(height: 35),
                        width: getIt<Functions>().getWidgetWidth(width: 35),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(int.parse("0XFF${selectedItem.typeColor}")),
                        ),
                        child: Center(
                          child: Text(
                            selectedItem.itemType,
                            style: TextStyle(
                                color: const Color(0xffffffff), fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w700),
                          ),
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
                              selectedItem.itemName,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 18 : 14),
                                  color: const Color(0xff282F3A)),
                            ),
                          ),
                          Text(
                            "${getIt<Variables>().generalVariables.currentLanguage.requiredQuantity} : ${getIt<Functions>().formatNumber(qty: selectedItem.quantity)} ${selectedItem.uom}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 15 : 12),
                                color: const Color(0xff007AFF)),
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
                            getIt<Variables>().generalVariables.currentLanguage.reason,
                            style: TextStyle(
                                color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 45),
                            child: buildDropButton(isItem: false, isLoading: context.read<WarehousePickupDetailBloc>().updateLoader),
                          )
                        ],
                      ),
                    ),
                    context.read<WarehousePickupDetailBloc>().selectedReasonEmpty
                        ? Text(
                            getIt<Variables>().generalVariables.currentLanguage.pleaseSelectReason,
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
                            getIt<Variables>().generalVariables.currentLanguage.comments,
                            style: TextStyle(
                                color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 45),
                            child: TextFormField(
                              controller: commentsBar,
                              onChanged: (value) {
                                context.read<WarehousePickupDetailBloc>().commentTextEmpty = value.isEmpty ? true : false;
                                context.read<WarehousePickupDetailBloc>().commentText = value.isEmpty ? "" : value;
                                context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailSetStateEvent());
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
                                hintText: getIt<Variables>().generalVariables.currentLanguage.enterComments,
                                hintStyle: TextStyle(
                                  color: const Color(0xff8A8D8E),
                                  fontWeight: FontWeight.w400,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                ),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? getIt<Variables>().generalVariables.currentLanguage.pleaseEnterTheComments : null,
                            ),
                          )
                        ],
                      ),
                    ),
                    context.read<WarehousePickupDetailBloc>().commentTextEmpty
                        ? Text(
                            getIt<Variables>().generalVariables.currentLanguage.pleaseEnterTheComments,
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 10)),
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 15),
                    ),
                  ],
                ),
              ),
              context.read<WarehousePickupDetailBloc>().updateLoader
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
                      onTap: () async {
                        if (context.read<WarehousePickupDetailBloc>().selectedReason == "" || commentsBar.text == "") {
                          if (context.read<WarehousePickupDetailBloc>().selectedReason == "") {
                            context.read<WarehousePickupDetailBloc>().selectedReasonEmpty = true;
                            context.read<WarehousePickupDetailBloc>().commentTextEmpty = false;
                            context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailSetStateEvent());
                          } else if (commentsBar.text == "") {
                            context.read<WarehousePickupDetailBloc>().selectedReasonEmpty = false;
                            context.read<WarehousePickupDetailBloc>().commentTextEmpty = true;
                            context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailSetStateEvent());
                          } else {}
                        } else {
                          context.read<WarehousePickupDetailBloc>().updateLoader = true;
                          FocusManager.instance.primaryFocus!.unfocus();
                          context.read<WarehousePickupDetailBloc>().selectedReasonEmpty = false;
                          context.read<WarehousePickupDetailBloc>().commentTextEmpty = false;
                          context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailSetStateEvent());
                          context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailUnavailableEvent());
                        }
                      },
                      child: Container(
                        height: getIt<Functions>().getWidgetHeight(height: 50),
                        decoration: const BoxDecoration(
                          color: Color(0xffF92C38),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                        ),
                        child: Center(
                          child: Text(
                            getIt<Variables>().generalVariables.currentLanguage.markAsUnavailable.toUpperCase(),
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

  Widget buildDropButton({required bool isItem, required bool isLoading}) {
    return Container(
      height: getIt<Functions>().getWidgetHeight(height: 45),
      decoration: BoxDecoration(
          color: const Color(0xffffffff), borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffE0E7EC), width: 0.73)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: isLoading == false ? changeReason : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  context.read<WarehousePickupDetailBloc>().selectedReasonName ?? getIt<Variables>().generalVariables.currentLanguage.chooseReason,
                  style: TextStyle(
                      fontSize: context.read<WarehousePickupDetailBloc>().selectedReasonName == null ? 12 : 15,
                      color: context.read<WarehousePickupDetailBloc>().selectedReasonName == null ? Colors.grey.shade500 : Colors.black),
                ),
              ),
              context.read<WarehousePickupDetailBloc>().selectedReasonName != null
                  ? InkWell(
                      onTap: () {
                        context.read<WarehousePickupDetailBloc>().selectedReasonName = null;
                        context.read<WarehousePickupDetailBloc>().selectedReasonEmpty = false;
                        context.read<WarehousePickupDetailBloc>().selectedReason = "";
                        context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailSetStateEvent(stillLoading: false));
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

  Future<void> changeReason() async {
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
                        getIt<Variables>().generalVariables.currentLanguage.chooseReason,
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
                        suffixIcon: reasonSearchFieldController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  reasonSearchFieldController.clear();
                                  context.read<WarehousePickupDetailBloc>().selectedReasonEmpty = false;
                                  context.read<WarehousePickupDetailBloc>().selectedReasonName = "";
                                  context.read<WarehousePickupDetailBloc>().selectedReason = "";
                                  context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailSetStateEvent(stillLoading: false));
                                },
                                icon: const Icon(
                                  Icons.close,
                                  size: 15,
                                  color: Color(0xff8A8D8E),
                                ))
                            : const Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: Color(0xff8A8D8E),
                                size: 15,
                              ),
                        hintText: getIt<Variables>().generalVariables.currentLanguage.chooseReason,
                        hintStyle: TextStyle(
                            color: const Color(0xff8A8D8E), fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                    onChanged: (value) {
                      context.read<WarehousePickupDetailBloc>().searchReasons = context
                          .read<WarehousePickupDetailBloc>()
                          .searchReasons
                          .where((element) => element.description.toLowerCase().contains(value.toLowerCase()))
                          .toList();
                      if (mounted) modelSetState(() {});
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.separated(
                      itemCount: context.read<WarehousePickupDetailBloc>().searchReasons.length,
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                      itemBuilder: (ctx, index) => ListTile(
                        title: Text(
                          context.read<WarehousePickupDetailBloc>().searchReasons[index].description,
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.read<WarehousePickupDetailBloc>().selectedReasonName =
                              context.read<WarehousePickupDetailBloc>().searchReasons[index].description;
                          context.read<WarehousePickupDetailBloc>().selectedReasonEmpty = false;
                          context.read<WarehousePickupDetailBloc>().selectedReason =
                              context.read<WarehousePickupDetailBloc>().searchReasons[index].id;
                          context.read<WarehousePickupDetailBloc>().add(const WarehousePickupDetailSetStateEvent(stillLoading: false));
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
}
