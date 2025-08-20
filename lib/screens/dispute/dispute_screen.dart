// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Project imports:
import 'package:oda/bloc/dispute/dispute_main/dispute_main_bloc.dart';
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/screens/dispute/dispute_detail_screen.dart';
import 'package:oda/screens/home/home_screen.dart';

class DisputeScreen extends StatefulWidget {
  static const String id = "dispute_screen";
  const DisputeScreen({super.key});

  @override
  State<DisputeScreen> createState() => _DisputeScreenState();
}

class _DisputeScreenState extends State<DisputeScreen> with TickerProviderStateMixin {
  TextEditingController searchBar = TextEditingController();
  late TabController tabController;
  RefreshController yetToSolveRefreshController = RefreshController();
  RefreshController resolvedRefreshController = RefreshController();
  RefreshController closedRefreshController = RefreshController();
  Timer? timer;

  @override
  void initState() {
    getIt<Variables>().generalVariables.disputeTab = "yet_to_resolve";
    tabController = TabController(length: 2, vsync: this, initialIndex: 0)
      ..addListener(() {
        if (tabController.indexIsChanging) {
          context.read<DisputeMainBloc>().pageIndex = 1;
          context.read<DisputeMainBloc>().tabIndex = tabController.index;
          switch (context.read<DisputeMainBloc>().tabIndex) {
            case 0:
              context.read<DisputeMainBloc>().tabName = "Pending";
            case 1:
              context.read<DisputeMainBloc>().tabName = "Resolved";
            default:
              context.read<DisputeMainBloc>().tabName = "Pending";
          }
          context.read<DisputeMainBloc>().add(const DisputeMainTabChangingEvent(isLoading: false));
          setState(() {});
        }
      });
    context.read<DisputeMainBloc>().add(const DisputeMainInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        if (Scaffold.of(context).isEndDrawerOpen) {
          Scaffold.of(context).closeEndDrawer();
        } else if (Scaffold.of(context).isDrawerOpen) {
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
                BlocBuilder<DisputeMainBloc, DisputeMainState>(
                  builder: (BuildContext context, DisputeMainState disputeMainState) {
                    return SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 117),
                      child: AppBar(
                        backgroundColor: const Color(0xffEEF4FF),
                        leading: IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: const Icon(Icons.menu),
                        ),
                        titleSpacing: 0,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              getIt<Variables>().generalVariables.currentLanguage.dispute,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 26),
                                  color: const Color(0xff282F3A)),
                            ),
                            textBars(controller: searchBar)
                          ],
                        ),
                        actions: [
                          IconButton(
                            splashColor: Colors.transparent,
                            splashRadius: 0.1,
                            padding: EdgeInsets.zero,
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: disputeMainState is DisputeMainLoading
                                ? () {}
                                : () {
                                    getIt<Variables>().generalVariables.filterSelectedMainIndex = 0;
                                    Scaffold.of(context).openEndDrawer();
                                  },
                            icon: Badge(
                              backgroundColor: const Color(0xff007AFF),
                              smallSize: getIt<Variables>().generalVariables.selectedFilters.isEmpty ? 0 : 8,
                              child: SvgPicture.asset(
                                "assets/catch_weight/filter.svg",
                                height: getIt<Functions>().getWidgetHeight(height: 34),
                                width: getIt<Functions>().getWidgetWidth(width: 34),
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Column(
                    children: [
                      BlocBuilder<DisputeMainBloc, DisputeMainState>(
                        builder: (BuildContext context, DisputeMainState state) {
                          return Container(
                            height: getIt<Functions>().getWidgetHeight(height: 50),
                            margin: EdgeInsets.only(
                                left: getIt<Functions>().getWidgetWidth(width: 16),
                                right: getIt<Functions>().getWidgetWidth(width: 16),
                                bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                            child: TabBar(
                              indicatorWeight: 0,
                              controller: tabController,
                              indicator: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: const Color(0xff007AFF)),
                              labelStyle:
                                  TextStyle(color: Colors.white, fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w600),
                              unselectedLabelStyle: TextStyle(
                                  color: const Color(0xff6F6F6F),
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                  fontWeight: FontWeight.w600),
                              splashBorderRadius: BorderRadius.circular(8),
                              padding: const EdgeInsets.all(3),
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              dividerHeight: 0.0,
                              tabs: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(getIt<Variables>().generalVariables.currentLanguage.yetToSolve.toUpperCase()),
                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                    context.read<DisputeMainBloc>().disputeMainResponse.yetToResolve == 0
                                        ? const SizedBox()
                                        : Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                            decoration: BoxDecoration(
                                                color: context.read<DisputeMainBloc>().tabIndex == 0 ? Colors.white : const Color(0xff007AFF),
                                                borderRadius: BorderRadius.circular(20)),
                                            child: Text(
                                              context.read<DisputeMainBloc>().disputeMainResponse.yetToResolve < 10
                                                  ? "0${context.read<DisputeMainBloc>().disputeMainResponse.yetToResolve}"
                                                  : context.read<DisputeMainBloc>().disputeMainResponse.yetToResolve.toString(),
                                              style: TextStyle(
                                                  color: context.read<DisputeMainBloc>().tabIndex == 0 ? const Color(0xff282F3A) : Colors.white,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(getIt<Variables>().generalVariables.currentLanguage.resolved.toUpperCase()),
                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                    context.read<DisputeMainBloc>().disputeMainResponse.resolved == 0
                                        ? const SizedBox()
                                        : Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                            decoration: BoxDecoration(
                                                color: context.read<DisputeMainBloc>().tabIndex == 1 ? Colors.white : const Color(0xff007AFF),
                                                borderRadius: BorderRadius.circular(20)),
                                            child: Text(
                                              context.read<DisputeMainBloc>().disputeMainResponse.resolved < 10
                                                  ? "0${context.read<DisputeMainBloc>().disputeMainResponse.resolved}"
                                                  : context.read<DisputeMainBloc>().disputeMainResponse.resolved.toString(),
                                              style: TextStyle(
                                                  color: context.read<DisputeMainBloc>().tabIndex == 1 ? const Color(0xff282F3A) : Colors.white,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: BlocConsumer<DisputeMainBloc, DisputeMainState>(
                          listenWhen: (DisputeMainState previous, DisputeMainState current) {
                            return previous != current;
                          },
                          buildWhen: (DisputeMainState previous, DisputeMainState current) {
                            return previous != current;
                          },
                          listener: (BuildContext context, DisputeMainState state) {},
                          builder: (BuildContext context, DisputeMainState state) {
                            if (state is DisputeMainLoaded) {
                              switch (context.read<DisputeMainBloc>().tabIndex) {
                                case 0:
                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: getIt<Functions>().getWidgetWidth(width: 16), right: getIt<Functions>().getWidgetWidth(width: 16)),
                                    child: SmartRefresher(
                                      enablePullDown: true,
                                      enablePullUp: true,
                                      physics: const BouncingScrollPhysics(),
                                      onRefresh: () {
                                        context.read<DisputeMainBloc>().pageIndex = 1;
                                        context.read<DisputeMainBloc>().add(const DisputeMainTabChangingEvent(isLoading: false));
                                        yetToSolveRefreshController.refreshCompleted();
                                        setState(() {});
                                      },
                                      footer: CustomFooter(
                                        builder: (BuildContext context, LoadStatus? mode) {
                                          Widget body;
                                          if (mode == LoadStatus.idle) {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.pullUpLoad);
                                          } else if (mode == LoadStatus.loading) {
                                            body = const CupertinoActivityIndicator();
                                          } else if (mode == LoadStatus.failed) {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.pullUpLoadFailed);
                                          } else if (mode == LoadStatus.canLoading) {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.releaseLoad);
                                          } else {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.noMoreData);
                                          }
                                          return SizedBox(
                                            height: getIt<Functions>().getWidgetHeight(height: 65),
                                            child: Center(child: body),
                                          );
                                        },
                                      ),
                                      controller: yetToSolveRefreshController,
                                      onLoading: () {
                                        context.read<DisputeMainBloc>().pageIndex++;
                                        context.read<DisputeMainBloc>().add(const DisputeMainTabChangingEvent(isLoading: true));
                                        yetToSolveRefreshController.loadComplete();
                                        setState(() {});
                                      },
                                      child: context.read<DisputeMainBloc>().disputeMainResponse.disputeList.isEmpty
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
                                                  getIt<Variables>().generalVariables.currentLanguage.disputeListIsEmpty,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ],
                                            )
                                          : ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics: const ScrollPhysics(),
                                              itemCount: context.read<DisputeMainBloc>().disputeMainResponse.disputeList.length,
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        context.read<DisputeMainBloc>().selectedIndex = index;
                                                        getIt<Variables>().generalVariables.disputeTab = "yet_to_resolve";
                                                        getIt<Variables>().generalVariables.indexName = DisputeDetailScreen.id;
                                                        getIt<Variables>().generalVariables.disputeRouteList.add(DisputeScreen.id);
                                                        context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(8),
                                                            border: Border.all(
                                                                color: context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].id ==
                                                                        getIt<Variables>().generalVariables.socketMessageId
                                                                    ? Colors.black
                                                                    : Colors.transparent)),
                                                        margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              height: getIt<Functions>().getWidgetHeight(height: 38),
                                                              decoration: BoxDecoration(
                                                                color: context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].id ==
                                                                    getIt<Variables>().generalVariables.socketMessageId
                                                                    ? Colors.green.withOpacity(0.1)
                                                                    : const Color(0xffE3E7EA),
                                                                borderRadius:
                                                                    const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                              ),
                                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        "${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].locationType.toUpperCase()} : ",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                      Text(
                                                                        context
                                                                            .read<DisputeMainBloc>()
                                                                            .disputeMainResponse
                                                                            .disputeList[index]
                                                                            .location,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007AFF)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        "${getIt<Variables>().generalVariables.currentLanguage.dispute.toUpperCase()}  #: ",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                      Text(
                                                                        context
                                                                            .read<DisputeMainBloc>()
                                                                            .disputeMainResponse
                                                                            .disputeList[index]
                                                                            .disputeNum,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007838)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal: getIt<Functions>().getWidgetWidth(width: 20),
                                                                  vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                                                              decoration: BoxDecoration(
                                                                  color: context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].id ==
                                                                      getIt<Variables>().generalVariables.socketMessageId
                                                                      ? Colors.green.withOpacity(0.1)
                                                                      : Colors.transparent
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
                                                                        height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                        width: getIt<Functions>().getWidgetWidth(width: 40),
                                                                        decoration: BoxDecoration(
                                                                            shape: BoxShape.circle,
                                                                            color: Color(int.parse(
                                                                                '0xFF${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].itemColor}'))),
                                                                        child: Center(
                                                                          child: Text(
                                                                            context
                                                                                .read<DisputeMainBloc>()
                                                                                .disputeMainResponse
                                                                                .disputeList[index]
                                                                                .itemType,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: getIt<Functions>().getTextSize(
                                                                                    fontSize: context
                                                                                                .read<DisputeMainBloc>()
                                                                                                .disputeMainResponse
                                                                                                .disputeList[index]
                                                                                                .itemType
                                                                                                .length >=
                                                                                            2
                                                                                        ? 20
                                                                                        : 24),
                                                                                color: const Color(0xFFFFFFFF)),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                      ),
                                                                      Expanded(
                                                                        child: SingleChildScrollView(
                                                                          scrollDirection: Axis.horizontal,
                                                                          child: Text(
                                                                            context
                                                                                .read<DisputeMainBloc>()
                                                                                .disputeMainResponse
                                                                                .disputeList[index]
                                                                                .itemName,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Expanded(
                                                                        child: SizedBox(
                                                                          height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                          child: ListView(
                                                                            shrinkWrap: true,
                                                                            scrollDirection: Axis.horizontal,
                                                                            children: [
                                                                              SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      getIt<Variables>()
                                                                                          .generalVariables
                                                                                          .currentLanguage
                                                                                          .raised
                                                                                          .toUpperCase(),
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff007838)),
                                                                                    ),
                                                                                    Text(
                                                                                      context
                                                                                              .read<DisputeMainBloc>()
                                                                                              .disputeMainResponse
                                                                                              .disputeList[index]
                                                                                              .disputeInfo
                                                                                              .by
                                                                                              .isNotEmpty
                                                                                          ? context
                                                                                              .read<DisputeMainBloc>()
                                                                                              .disputeMainResponse
                                                                                              .disputeList[index]
                                                                                              .disputeInfo
                                                                                              .by
                                                                                              .first
                                                                                              .name
                                                                                          : "",
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff282F3A)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 45),
                                                                              ),
                                                                              SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      getIt<Variables>().generalVariables.currentLanguage.dateAndTime,
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff8A8D8E)),
                                                                                    ),
                                                                                    Text(
                                                                                      context
                                                                                          .read<DisputeMainBloc>()
                                                                                          .disputeMainResponse
                                                                                          .disputeList[index]
                                                                                          .created,
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff282F3A)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 45),
                                                                              ),
                                                                              SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                                                    Text(
                                                                                      context
                                                                                          .read<DisputeMainBloc>()
                                                                                          .disputeMainResponse
                                                                                          .disputeList[index]
                                                                                          .itemCode,
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff282F3A)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 45),
                                                                              ),
                                                                              SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      getIt<Variables>()
                                                                                          .generalVariables
                                                                                          .currentLanguage
                                                                                          .uom
                                                                                          .toUpperCase(),
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff8A8D8E)),
                                                                                    ),
                                                                                    Text(
                                                                                      context
                                                                                          .read<DisputeMainBloc>()
                                                                                          .disputeMainResponse
                                                                                          .disputeList[index]
                                                                                          .uom,
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff282F3A)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 45),
                                                                              ),
                                                                              SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      getIt<Variables>()
                                                                                          .generalVariables
                                                                                          .currentLanguage
                                                                                          .picklist
                                                                                          .toUpperCase(),
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff8A8D8E)),
                                                                                    ),
                                                                                    Text(
                                                                                      "#${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].picklistNum}",
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff282F3A)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: getIt<Functions>().getWidgetWidth(width: 45),
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            context
                                                                                .read<DisputeMainBloc>()
                                                                                .disputeMainResponse
                                                                                .disputeList[index]
                                                                                .quantity,
                                                                            style: TextStyle(
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                                fontWeight: FontWeight.w600,
                                                                                color: const Color(0xffF92C38)),
                                                                          ),
                                                                          Text(
                                                                            getIt<Variables>().generalVariables.currentLanguage.qty,
                                                                            style: TextStyle(
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                fontWeight: FontWeight.w500,
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                    ),
                                  );
                                case 1:
                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: getIt<Functions>().getWidgetWidth(width: 16), right: getIt<Functions>().getWidgetWidth(width: 16)),
                                    child: SmartRefresher(
                                      enablePullDown: true,
                                      enablePullUp: true,
                                      physics: const BouncingScrollPhysics(),
                                      onRefresh: () {
                                        context.read<DisputeMainBloc>().pageIndex = 1;
                                        context.read<DisputeMainBloc>().add(const DisputeMainTabChangingEvent(isLoading: false));
                                        resolvedRefreshController.refreshCompleted();
                                        setState(() {});
                                      },
                                      footer: CustomFooter(
                                        builder: (BuildContext context, LoadStatus? mode) {
                                          Widget body;
                                          if (mode == LoadStatus.idle) {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.pullUpLoad);
                                          } else if (mode == LoadStatus.loading) {
                                            body = const CupertinoActivityIndicator();
                                          } else if (mode == LoadStatus.failed) {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.pullUpLoadFailed);
                                          } else if (mode == LoadStatus.canLoading) {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.releaseLoad);
                                          } else {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.noMoreData);
                                          }
                                          return SizedBox(
                                            height: getIt<Functions>().getWidgetHeight(height: 65),
                                            child: Center(child: body),
                                          );
                                        },
                                      ),
                                      controller: resolvedRefreshController,
                                      onLoading: () {
                                        context.read<DisputeMainBloc>().pageIndex++;
                                        context.read<DisputeMainBloc>().add(const DisputeMainTabChangingEvent(isLoading: true));
                                        resolvedRefreshController.loadComplete();
                                        setState(() {});
                                      },
                                      child: context.read<DisputeMainBloc>().disputeMainResponse.disputeList.isEmpty
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
                                                  getIt<Variables>().generalVariables.currentLanguage.disputeListIsEmpty,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ],
                                            )
                                          : ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics: const ScrollPhysics(),
                                              itemCount: context.read<DisputeMainBloc>().disputeMainResponse.disputeList.length,
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        context.read<DisputeMainBloc>().selectedIndex = index;
                                                        getIt<Variables>().generalVariables.disputeTab = "resolved";
                                                        getIt<Variables>().generalVariables.indexName = DisputeDetailScreen.id;
                                                        getIt<Variables>().generalVariables.disputeRouteList.add(DisputeScreen.id);
                                                        context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                        margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              height: getIt<Functions>().getWidgetHeight(height: 38),
                                                              decoration: const BoxDecoration(
                                                                color: Color(0xffE3E7EA),
                                                                borderRadius:
                                                                    BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                              ),
                                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        "${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].locationType}  : ",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                      Text(
                                                                        context
                                                                            .read<DisputeMainBloc>()
                                                                            .disputeMainResponse
                                                                            .disputeList[index]
                                                                            .location,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007AFF)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        "${getIt<Variables>().generalVariables.currentLanguage.dispute.toUpperCase()}  #: ",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                      Text(
                                                                        context
                                                                            .read<DisputeMainBloc>()
                                                                            .disputeMainResponse
                                                                            .disputeList[index]
                                                                            .disputeNum,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007838)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal: getIt<Functions>().getWidgetWidth(width: 20),
                                                                  vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Flexible(
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Container(
                                                                              height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                              width: getIt<Functions>().getWidgetWidth(width: 40),
                                                                              decoration: BoxDecoration(
                                                                                  shape: BoxShape.circle,
                                                                                  color: Color(int.parse(
                                                                                      '0xFF${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].itemColor}'))),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  context
                                                                                      .read<DisputeMainBloc>()
                                                                                      .disputeMainResponse
                                                                                      .disputeList[index]
                                                                                      .itemType,
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: getIt<Functions>().getTextSize(
                                                                                          fontSize: context
                                                                                                      .read<DisputeMainBloc>()
                                                                                                      .disputeMainResponse
                                                                                                      .disputeList[index]
                                                                                                      .itemType
                                                                                                      .length >=
                                                                                                  2
                                                                                              ? 20
                                                                                              : 24),
                                                                                      color: const Color(0xFFFFFFFF)),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                            ),
                                                                            Expanded(
                                                                              child: SingleChildScrollView(
                                                                                scrollDirection: Axis.horizontal,
                                                                                child: Text(
                                                                                  context
                                                                                      .read<DisputeMainBloc>()
                                                                                      .disputeMainResponse
                                                                                      .disputeList[index]
                                                                                      .itemName,
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                      color: const Color(0xff282F3A)),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            context
                                                                                .read<DisputeMainBloc>()
                                                                                .disputeMainResponse
                                                                                .disputeList[index]
                                                                                .quantity,
                                                                            style: TextStyle(
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                                fontWeight: FontWeight.w600,
                                                                                color: const Color(0xff007838)),
                                                                          ),
                                                                          Text(
                                                                            getIt<Variables>().generalVariables.currentLanguage.qty,
                                                                            style: TextStyle(
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                fontWeight: FontWeight.w500,
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: SizedBox(
                                                                          height: getIt<Functions>().getWidgetHeight(height: 50),
                                                                          child: ListView(
                                                                            scrollDirection: Axis.horizontal,
                                                                            physics: const ScrollPhysics(),
                                                                            children: [
                                                                              SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      getIt<Variables>()
                                                                                          .generalVariables
                                                                                          .currentLanguage
                                                                                          .raised
                                                                                          .toUpperCase(),
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff007838)),
                                                                                    ),
                                                                                    Text(
                                                                                      context
                                                                                              .read<DisputeMainBloc>()
                                                                                              .disputeMainResponse
                                                                                              .disputeList[index]
                                                                                              .disputeInfo
                                                                                              .by
                                                                                              .isNotEmpty
                                                                                          ? context
                                                                                              .read<DisputeMainBloc>()
                                                                                              .disputeMainResponse
                                                                                              .disputeList[index]
                                                                                              .disputeInfo
                                                                                              .by
                                                                                              .first
                                                                                              .name
                                                                                          : "-",
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff282F3A)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 60),
                                                                              ),
                                                                              SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                                                    Text(
                                                                                      context
                                                                                          .read<DisputeMainBloc>()
                                                                                          .disputeMainResponse
                                                                                          .disputeList[index]
                                                                                          .itemCode,
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff282F3A)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 60),
                                                                              ),
                                                                              SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      getIt<Variables>()
                                                                                          .generalVariables
                                                                                          .currentLanguage
                                                                                          .uom
                                                                                          .toUpperCase(),
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff8A8D8E)),
                                                                                    ),
                                                                                    Text(
                                                                                      context
                                                                                          .read<DisputeMainBloc>()
                                                                                          .disputeMainResponse
                                                                                          .disputeList[index]
                                                                                          .uom,
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff282F3A)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 60),
                                                                              ),
                                                                              SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      getIt<Variables>().generalVariables.currentLanguage.dateAndTime,
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff8A8D8E)),
                                                                                    ),
                                                                                    Text(
                                                                                      context
                                                                                          .read<DisputeMainBloc>()
                                                                                          .disputeMainResponse
                                                                                          .disputeList[index]
                                                                                          .created,
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff282F3A)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 60),
                                                                              ),
                                                                              SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      getIt<Variables>()
                                                                                          .generalVariables
                                                                                          .currentLanguage
                                                                                          .resolved
                                                                                          .toUpperCase(),
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff007838)),
                                                                                    ),
                                                                                    Text(
                                                                                      context
                                                                                              .read<DisputeMainBloc>()
                                                                                              .disputeMainResponse
                                                                                              .disputeList[index]
                                                                                              .resolutionInfo
                                                                                              .by
                                                                                              .isNotEmpty
                                                                                          ? context
                                                                                              .read<DisputeMainBloc>()
                                                                                              .disputeMainResponse
                                                                                              .disputeList[index]
                                                                                              .resolutionInfo
                                                                                              .by
                                                                                              .first
                                                                                              .name
                                                                                          : "-",
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff282F3A)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 60),
                                                                              ),
                                                                              SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      getIt<Variables>().generalVariables.currentLanguage.dateAndTime,
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff8A8D8E)),
                                                                                    ),
                                                                                    Text(
                                                                                      context
                                                                                              .read<DisputeMainBloc>()
                                                                                              .disputeMainResponse
                                                                                              .disputeList[index]
                                                                                              .resolutionInfo
                                                                                              .by
                                                                                              .isNotEmpty
                                                                                          ? context
                                                                                              .read<DisputeMainBloc>()
                                                                                              .disputeMainResponse
                                                                                              .disputeList[index]
                                                                                              .resolutionInfo
                                                                                              .on
                                                                                          : "-",
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff282F3A)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 60),
                                                                              ),
                                                                              SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      getIt<Variables>()
                                                                                          .generalVariables
                                                                                          .currentLanguage
                                                                                          .picklist
                                                                                          .toUpperCase(),
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff8A8D8E)),
                                                                                    ),
                                                                                    Text(
                                                                                      context
                                                                                          .read<DisputeMainBloc>()
                                                                                          .disputeMainResponse
                                                                                          .disputeList[index]
                                                                                          .picklistNum,
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff282F3A)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                    ),
                                  );
                                default:
                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: getIt<Functions>().getWidgetWidth(width: 16),
                                        right: getIt<Functions>().getWidgetWidth(width: 16),
                                        bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                                    child: SmartRefresher(
                                      enablePullDown: true,
                                      enablePullUp: true,
                                      physics: const BouncingScrollPhysics(),
                                      onRefresh: () {
                                        context.read<DisputeMainBloc>().pageIndex = 1;
                                        context.read<DisputeMainBloc>().add(const DisputeMainTabChangingEvent(isLoading: false));
                                        yetToSolveRefreshController.refreshCompleted();
                                        setState(() {});
                                      },
                                      footer: CustomFooter(
                                        builder: (BuildContext context, LoadStatus? mode) {
                                          Widget body;
                                          if (mode == LoadStatus.idle) {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.pullUpLoad);
                                          } else if (mode == LoadStatus.loading) {
                                            body = const CupertinoActivityIndicator();
                                          } else if (mode == LoadStatus.failed) {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.pullUpLoadFailed);
                                          } else if (mode == LoadStatus.canLoading) {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.releaseLoad);
                                          } else {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.noMoreData);
                                          }
                                          return SizedBox(
                                            height: getIt<Functions>().getWidgetHeight(height: 65),
                                            child: Center(child: body),
                                          );
                                        },
                                      ),
                                      controller: yetToSolveRefreshController,
                                      onLoading: () {
                                        context.read<DisputeMainBloc>().pageIndex++;
                                        context.read<DisputeMainBloc>().add(const DisputeMainTabChangingEvent(isLoading: true));
                                        yetToSolveRefreshController.loadComplete();
                                        setState(() {});
                                      },
                                      child: context.read<DisputeMainBloc>().disputeMainResponse.disputeList.isEmpty
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
                                                  getIt<Variables>().generalVariables.currentLanguage.disputeListIsEmpty,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ],
                                            )
                                          : ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics: const ScrollPhysics(),
                                              itemCount: context.read<DisputeMainBloc>().disputeMainResponse.disputeList.length,
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        context.read<DisputeMainBloc>().selectedIndex = index;
                                                        getIt<Variables>().generalVariables.disputeTab = "yet_to_resolve";
                                                        getIt<Variables>().generalVariables.indexName = DisputeDetailScreen.id;
                                                        getIt<Variables>().generalVariables.disputeRouteList.add(DisputeScreen.id);
                                                        context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                        margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              height: getIt<Functions>().getWidgetHeight(height: 38),
                                                              decoration: const BoxDecoration(
                                                                color: Color(0xffE3E7EA),
                                                                borderRadius:
                                                                    BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                              ),
                                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        "${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].locationType} : ",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                      Text(
                                                                        context
                                                                            .read<DisputeMainBloc>()
                                                                            .disputeMainResponse
                                                                            .disputeList[index]
                                                                            .location,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007AFF)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        "${getIt<Variables>().generalVariables.currentLanguage.dispute.toUpperCase()}  #: ",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                      Text(
                                                                        context
                                                                            .read<DisputeMainBloc>()
                                                                            .disputeMainResponse
                                                                            .disputeList[index]
                                                                            .disputeNum,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007838)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal: getIt<Functions>().getWidgetWidth(width: 20),
                                                                  vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Container(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                        width: getIt<Functions>().getWidgetWidth(width: 40),
                                                                        decoration: BoxDecoration(
                                                                            shape: BoxShape.circle,
                                                                            color: Color(int.parse(
                                                                                '0xFF${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].itemColor}'))),
                                                                        child: Center(
                                                                          child: Text(
                                                                            context
                                                                                .read<DisputeMainBloc>()
                                                                                .disputeMainResponse
                                                                                .disputeList[index]
                                                                                .itemType,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: getIt<Functions>().getTextSize(
                                                                                    fontSize: context
                                                                                                .read<DisputeMainBloc>()
                                                                                                .disputeMainResponse
                                                                                                .disputeList[index]
                                                                                                .itemType
                                                                                                .length >=
                                                                                            2
                                                                                        ? 20
                                                                                        : 24),
                                                                                color: const Color(0xFFFFFFFF)),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                      ),
                                                                      Expanded(
                                                                        child: SingleChildScrollView(
                                                                          scrollDirection: Axis.horizontal,
                                                                          child: Text(
                                                                            context
                                                                                .read<DisputeMainBloc>()
                                                                                .disputeMainResponse
                                                                                .disputeList[index]
                                                                                .itemName,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          SizedBox(
                                                                            height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                            width: getIt<Functions>().getWidgetWidth(width: 95),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  getIt<Variables>()
                                                                                      .generalVariables
                                                                                      .currentLanguage
                                                                                      .raised
                                                                                      .toUpperCase(),
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                      color: const Color(0xff007838)),
                                                                                ),
                                                                                Text(
                                                                                  context
                                                                                          .read<DisputeMainBloc>()
                                                                                          .disputeMainResponse
                                                                                          .disputeList[index]
                                                                                          .disputeInfo
                                                                                          .by
                                                                                          .isNotEmpty
                                                                                      ? context
                                                                                          .read<DisputeMainBloc>()
                                                                                          .disputeMainResponse
                                                                                          .disputeList[index]
                                                                                          .disputeInfo
                                                                                          .by
                                                                                          .first
                                                                                          .name
                                                                                      : "",
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                      color: const Color(0xff282F3A)),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                            width: getIt<Functions>().getWidgetWidth(width: 150),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  getIt<Variables>().generalVariables.currentLanguage.dateAndTime,
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                      color: const Color(0xff8A8D8E)),
                                                                                ),
                                                                                Text(
                                                                                  context
                                                                                      .read<DisputeMainBloc>()
                                                                                      .disputeMainResponse
                                                                                      .disputeList[index]
                                                                                      .created,
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                      color: const Color(0xff282F3A)),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                            width: getIt<Functions>().getWidgetWidth(width: 95),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                                                Text(
                                                                                  context
                                                                                      .read<DisputeMainBloc>()
                                                                                      .disputeMainResponse
                                                                                      .disputeList[index]
                                                                                      .itemCode,
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                      color: const Color(0xff282F3A)),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                            width: getIt<Functions>().getWidgetWidth(width: 75),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  getIt<Variables>()
                                                                                      .generalVariables
                                                                                      .currentLanguage
                                                                                      .uom
                                                                                      .toUpperCase(),
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                      color: const Color(0xff8A8D8E)),
                                                                                ),
                                                                                Text(
                                                                                  context
                                                                                      .read<DisputeMainBloc>()
                                                                                      .disputeMainResponse
                                                                                      .disputeList[index]
                                                                                      .uom,
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                      color: const Color(0xff282F3A)),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                            width: getIt<Functions>().getWidgetWidth(width: 95),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  getIt<Variables>()
                                                                                      .generalVariables
                                                                                      .currentLanguage
                                                                                      .picklist
                                                                                      .toUpperCase(),
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                      color: const Color(0xff8A8D8E)),
                                                                                ),
                                                                                Text(
                                                                                  "#${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].picklistNum}",
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                      color: const Color(0xff282F3A)),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            context
                                                                                .read<DisputeMainBloc>()
                                                                                .disputeMainResponse
                                                                                .disputeList[index]
                                                                                .quantity,
                                                                            style: TextStyle(
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                                fontWeight: FontWeight.w600,
                                                                                color: const Color(0xffF92C38)),
                                                                          ),
                                                                          Text(
                                                                            getIt<Variables>().generalVariables.currentLanguage.qty,
                                                                            style: TextStyle(
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                fontWeight: FontWeight.w500,
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                    ),
                                  );
                              }
                            } else if (state is DisputeMainLoading) {
                              switch (context.read<DisputeMainBloc>().tabIndex) {
                                case 0:
                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: getIt<Functions>().getWidgetWidth(width: 16),
                                        right: getIt<Functions>().getWidgetWidth(width: 16),
                                        bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                    child: Skeletonizer(
                                      enabled: true,
                                      child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          physics: const ScrollPhysics(),
                                          itemCount: 5,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  DateFormat("dd/MM/yyyy").format(DateTime.now().subtract(Duration(days: index))),
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xff282F3A)),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    context.read<DisputeMainBloc>().selectedIndex = index;
                                                    getIt<Variables>().generalVariables.indexName = DisputeDetailScreen.id;
                                                    getIt<Variables>().generalVariables.disputeRouteList.add(DisputeScreen.id);
                                                    context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                    margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          height: getIt<Functions>().getWidgetHeight(height: 38),
                                                          decoration: const BoxDecoration(
                                                            color: Color(0xffE3E7EA),
                                                            borderRadius:
                                                                BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                          ),
                                                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    "${getIt<Variables>().generalVariables.currentLanguage.stagingArea.toUpperCase()} : ",
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                  Text(
                                                                    "COMMON AREA",
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff007AFF)),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    "${getIt<Variables>().generalVariables.currentLanguage.dispute.toUpperCase()}  #: ",
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                  Text(
                                                                    "19604519",
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff007838)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: getIt<Functions>().getWidgetWidth(width: 20),
                                                              vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                    width: getIt<Functions>().getWidgetWidth(width: 40),
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
                                                                  Expanded(
                                                                    child: SingleChildScrollView(
                                                                      scrollDirection: Axis.horizontal,
                                                                      child: Text(
                                                                        "Mutton Leg Boneless - Aus Origin - KG",
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      SizedBox(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                        width: getIt<Functions>().getWidgetWidth(width: 95),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              getIt<Variables>()
                                                                                  .generalVariables
                                                                                  .currentLanguage
                                                                                  .raised
                                                                                  .toUpperCase(),
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff007838)),
                                                                            ),
                                                                            Text(
                                                                              "John Smith",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                        width: getIt<Functions>().getWidgetWidth(width: 150),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              getIt<Variables>().generalVariables.currentLanguage.dateAndTime,
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                            Text(
                                                                              "19/05/2024, 01:10 PM",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                        width: getIt<Functions>().getWidgetWidth(width: 95),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                                            Text(
                                                                              "SF1937",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                        width: getIt<Functions>().getWidgetWidth(width: 75),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              getIt<Variables>().generalVariables.currentLanguage.uom.toUpperCase(),
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                            Text(
                                                                              "Pack",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                        width: getIt<Functions>().getWidgetWidth(width: 95),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              getIt<Variables>()
                                                                                  .generalVariables
                                                                                  .currentLanguage
                                                                                  .picklist
                                                                                  .toUpperCase(),
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                            Text(
                                                                              "#24102211",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        "41",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xffF92C38)),
                                                                      ),
                                                                      Text(
                                                                        "DISCREPANCY",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w500,
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                  );
                                case 1:
                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: getIt<Functions>().getWidgetWidth(width: 16),
                                        right: getIt<Functions>().getWidgetWidth(width: 16),
                                        bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                    child: Skeletonizer(
                                      enabled: true,
                                      child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          physics: const ScrollPhysics(),
                                          itemCount: 3,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  DateFormat("dd/MM/yyyy").format(DateTime.now().subtract(Duration(days: index))),
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xff282F3A)),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    context.read<DisputeMainBloc>().selectedIndex = index;
                                                    getIt<Variables>().generalVariables.indexName = DisputeDetailScreen.id;
                                                    getIt<Variables>().generalVariables.disputeRouteList.add(DisputeScreen.id);
                                                    context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                    margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          height: getIt<Functions>().getWidgetHeight(height: 38),
                                                          decoration: const BoxDecoration(
                                                            color: Color(0xffE3E7EA),
                                                            borderRadius:
                                                                BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                          ),
                                                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    "${getIt<Variables>().generalVariables.currentLanguage.stagingArea.toUpperCase()}  : ",
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                  Text(
                                                                    "COMMON AREA",
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff007AFF)),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    "${getIt<Variables>().generalVariables.currentLanguage.dispute.toUpperCase()}  #: ",
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                  Text(
                                                                    "19604519",
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff007838)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: getIt<Functions>().getWidgetWidth(width: 20),
                                                              vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                    width: getIt<Functions>().getWidgetWidth(width: 40),
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
                                                                  Expanded(
                                                                    child: SingleChildScrollView(
                                                                      scrollDirection: Axis.horizontal,
                                                                      child: Text(
                                                                        "Mutton Leg Boneless - Aus Origin - KG",
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      SizedBox(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                        width: getIt<Functions>().getWidgetWidth(width: 95),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "ITEM TYPE",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                            Text(
                                                                              "D",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                        width: getIt<Functions>().getWidgetWidth(width: 95),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                                            Text(
                                                                              "SF1937",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                        width: getIt<Functions>().getWidgetWidth(width: 75),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              getIt<Variables>().generalVariables.currentLanguage.uom.toUpperCase(),
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                            Text(
                                                                              "Pack",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                        width: getIt<Functions>().getWidgetWidth(width: 150),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              getIt<Variables>().generalVariables.currentLanguage.dateAndTime,
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                            Text(
                                                                              "19/05/2024, 01:10 PM",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                        width: getIt<Functions>().getWidgetWidth(width: 95),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              getIt<Variables>()
                                                                                  .generalVariables
                                                                                  .currentLanguage
                                                                                  .picklist
                                                                                  .toUpperCase(),
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                            Text(
                                                                              "#24102211",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        "41",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xffF92C38)),
                                                                      ),
                                                                      Text(
                                                                        "DISCREPANCY",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w500,
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                  );
                                default:
                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: getIt<Functions>().getWidgetWidth(width: 16),
                                        right: getIt<Functions>().getWidgetWidth(width: 16),
                                        bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                    child: Skeletonizer(
                                      enabled: true,
                                      child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          physics: const ScrollPhysics(),
                                          itemCount: 5,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  DateFormat("dd/MM/yyyy").format(DateTime.now().subtract(Duration(days: index))),
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xff282F3A)),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    context.read<DisputeMainBloc>().selectedIndex = index;
                                                    getIt<Variables>().generalVariables.indexName = DisputeDetailScreen.id;
                                                    getIt<Variables>().generalVariables.disputeRouteList.add(DisputeScreen.id);
                                                    context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                    margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          height: getIt<Functions>().getWidgetHeight(height: 38),
                                                          decoration: const BoxDecoration(
                                                            color: Color(0xffE3E7EA),
                                                            borderRadius:
                                                                BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                          ),
                                                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    "${getIt<Variables>().generalVariables.currentLanguage.stagingArea.toUpperCase()} : ",
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                  Text(
                                                                    "COMMON AREA",
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff007AFF)),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    "${getIt<Variables>().generalVariables.currentLanguage.dispute.toUpperCase()}  #: ",
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                  Text(
                                                                    "19604519",
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff007838)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: getIt<Functions>().getWidgetWidth(width: 20),
                                                              vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                    width: getIt<Functions>().getWidgetWidth(width: 40),
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
                                                                  Expanded(
                                                                    child: SingleChildScrollView(
                                                                      scrollDirection: Axis.horizontal,
                                                                      child: Text(
                                                                        "Mutton Leg Boneless - Aus Origin - KG",
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      SizedBox(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                        width: getIt<Functions>().getWidgetWidth(width: 95),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              getIt<Variables>()
                                                                                  .generalVariables
                                                                                  .currentLanguage
                                                                                  .raised
                                                                                  .toUpperCase(),
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff007838)),
                                                                            ),
                                                                            Text(
                                                                              "John Smith",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                        width: getIt<Functions>().getWidgetWidth(width: 150),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              getIt<Variables>().generalVariables.currentLanguage.dateAndTime,
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                            Text(
                                                                              "19/05/2024, 01:10 PM",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                        width: getIt<Functions>().getWidgetWidth(width: 95),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                                            Text(
                                                                              "SF1937",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                        width: getIt<Functions>().getWidgetWidth(width: 75),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              getIt<Variables>().generalVariables.currentLanguage.uom.toUpperCase(),
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                            Text(
                                                                              "Pack",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 35),
                                                                        width: getIt<Functions>().getWidgetWidth(width: 95),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              getIt<Variables>()
                                                                                  .generalVariables
                                                                                  .currentLanguage
                                                                                  .picklist
                                                                                  .toUpperCase(),
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                            Text(
                                                                              "#24102211",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        "41",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xffF92C38)),
                                                                      ),
                                                                      Text(
                                                                        "DISCREPANCY",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w500,
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                  );
                              }
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ),
                    ],
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
                BlocBuilder<DisputeMainBloc, DisputeMainState>(
                  builder: (BuildContext context, DisputeMainState state) {
                    return SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 117),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppBar(
                            backgroundColor: const Color(0xffEEF4FF),
                            leading: IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              icon: const Icon(Icons.menu),
                            ),
                            titleSpacing: 0,
                            title: AnimatedCrossFade(
                              firstChild: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    getIt<Variables>().generalVariables.currentLanguage.dispute,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: getIt<Functions>().getTextSize(fontSize: 26),
                                        color: const Color(0xff282F3A)),
                                  ),
                                ],
                              ),
                              secondChild: textBars(controller: searchBar),
                              crossFadeState: context.read<DisputeMainBloc>().searchBarEnabled ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 100),
                            ),
                            actions: [
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: DisputeMainState is DisputeMainLoading
                                    ? () {}
                                    : () {
                                        context.read<DisputeMainBloc>().searchBarEnabled = !context.read<DisputeMainBloc>().searchBarEnabled;
                                        setState(() {});
                                      },
                                child: Padding(
                                  padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 14)),
                                  child: SvgPicture.asset(
                                    "assets/catch_weight/action_search.svg",
                                    height: getIt<Functions>().getWidgetHeight(height: 35.44),
                                    width: getIt<Functions>().getWidgetWidth(width: 35.44),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: DisputeMainState is DisputeMainLoading
                                    ? () {}
                                    : () {
                                        Scaffold.of(context).openEndDrawer();
                                      },
                                child: Padding(
                                  padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 14)),
                                  child: Badge(
                                    backgroundColor: const Color(0xff007AFF),
                                    smallSize: getIt<Variables>().generalVariables.selectedFilters.isEmpty ? 0 : 8,
                                    child: SvgPicture.asset(
                                      "assets/catch_weight/filter.svg",
                                      height: getIt<Functions>().getWidgetHeight(height: 34),
                                      width: getIt<Functions>().getWidgetWidth(width: 34),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 16),
                          )
                        ],
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Column(
                    children: [
                      BlocBuilder<DisputeMainBloc, DisputeMainState>(
                        builder: (BuildContext context, DisputeMainState state) {
                          return Container(
                            height: getIt<Functions>().getWidgetHeight(height: 50),
                            width: getIt<Functions>().getWidgetWidth(width: 450),
                            margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 12)),
                            decoration: const BoxDecoration(color: Colors.white),
                            child: TabBar(
                              indicatorWeight: 0,
                              controller: tabController,
                              indicator: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: const Color(0xff007AFF)),
                              labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis),
                              unselectedLabelStyle: TextStyle(
                                  color: const Color(0xff6F6F6F),
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis),
                              splashBorderRadius: BorderRadius.circular(8),
                              padding: EdgeInsets.symmetric(
                                  vertical: getIt<Functions>().getWidgetHeight(height: 3), horizontal: getIt<Functions>().getWidgetWidth(width: 8)),
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              dividerHeight: 0.0,
                              tabs: [
                                Tab(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Flexible(child: Text(getIt<Variables>().generalVariables.currentLanguage.yetToSolve.toUpperCase())),
                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                        context.read<DisputeMainBloc>().disputeMainResponse.yetToResolve == 0
                                            ? const SizedBox()
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                    vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                decoration: BoxDecoration(
                                                    color: context.read<DisputeMainBloc>().tabIndex == 0 ? Colors.white : const Color(0xff007AFF),
                                                    borderRadius: BorderRadius.circular(20)),
                                                child: Text(
                                                  context.read<DisputeMainBloc>().disputeMainResponse.yetToResolve < 10
                                                      ? "0${context.read<DisputeMainBloc>().disputeMainResponse.yetToResolve}"
                                                      : context.read<DisputeMainBloc>().disputeMainResponse.yetToResolve.toString(),
                                                  style: TextStyle(
                                                      color: context.read<DisputeMainBloc>().tabIndex == 0 ? const Color(0xff282F3A) : Colors.white,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Flexible(child: Text(getIt<Variables>().generalVariables.currentLanguage.resolved.toUpperCase())),
                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                        context.read<DisputeMainBloc>().disputeMainResponse.resolved == 0
                                            ? const SizedBox()
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                    vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                decoration: BoxDecoration(
                                                    color: context.read<DisputeMainBloc>().tabIndex == 1 ? Colors.white : const Color(0xff007AFF),
                                                    borderRadius: BorderRadius.circular(20)),
                                                child: Text(
                                                  context.read<DisputeMainBloc>().disputeMainResponse.resolved < 10
                                                      ? "0${context.read<DisputeMainBloc>().disputeMainResponse.resolved}"
                                                      : context.read<DisputeMainBloc>().disputeMainResponse.resolved.toString(),
                                                  style: TextStyle(
                                                      color: context.read<DisputeMainBloc>().tabIndex == 1 ? const Color(0xff282F3A) : Colors.white,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
                      Expanded(
                        child: BlocConsumer<DisputeMainBloc, DisputeMainState>(
                          listenWhen: (DisputeMainState previous, DisputeMainState current) {
                            return previous != current;
                          },
                          buildWhen: (DisputeMainState previous, DisputeMainState current) {
                            return previous != current;
                          },
                          listener: (BuildContext context, DisputeMainState state) {},
                          builder: (BuildContext context, DisputeMainState state) {
                            if (state is DisputeMainLoaded) {
                              switch (context.read<DisputeMainBloc>().tabIndex) {
                                case 0:
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                    child: SmartRefresher(
                                      enablePullDown: true,
                                      enablePullUp: true,
                                      physics: const BouncingScrollPhysics(),
                                      onRefresh: () {
                                        context.read<DisputeMainBloc>().pageIndex = 1;
                                        context.read<DisputeMainBloc>().add(const DisputeMainTabChangingEvent(isLoading: false));
                                        yetToSolveRefreshController.refreshCompleted();
                                        setState(() {});
                                      },
                                      footer: CustomFooter(
                                        builder: (BuildContext context, LoadStatus? mode) {
                                          Widget body;
                                          if (mode == LoadStatus.idle) {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.pullUpLoad);
                                          } else if (mode == LoadStatus.loading) {
                                            body = const CupertinoActivityIndicator();
                                          } else if (mode == LoadStatus.failed) {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.pullUpLoadFailed);
                                          } else if (mode == LoadStatus.canLoading) {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.releaseLoad);
                                          } else {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.noMoreData);
                                          }
                                          return SizedBox(
                                            height: getIt<Functions>().getWidgetHeight(height: 65),
                                            child: Center(child: body),
                                          );
                                        },
                                      ),
                                      controller: yetToSolveRefreshController,
                                      onLoading: () {
                                        context.read<DisputeMainBloc>().pageIndex++;
                                        context.read<DisputeMainBloc>().add(const DisputeMainTabChangingEvent(isLoading: true));
                                        yetToSolveRefreshController.loadComplete();
                                        setState(() {});
                                      },
                                      child: context.read<DisputeMainBloc>().disputeMainResponse.disputeList.isEmpty
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
                                                  getIt<Variables>().generalVariables.currentLanguage.disputeListIsEmpty,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w600),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            )
                                          : ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics: const ScrollPhysics(),
                                              itemCount: context.read<DisputeMainBloc>().disputeMainResponse.disputeList.length,
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        context.read<DisputeMainBloc>().selectedIndex = index;
                                                        getIt<Variables>().generalVariables.disputeTab = "yet_to_resolve";
                                                        getIt<Variables>().generalVariables.indexName = DisputeDetailScreen.id;
                                                        getIt<Variables>().generalVariables.disputeRouteList.add(DisputeScreen.id);
                                                        context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                        margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              height: getIt<Functions>().getWidgetHeight(height: 38),
                                                              decoration: const BoxDecoration(
                                                                color: Color(0xffE3E7EA),
                                                                borderRadius:
                                                                    BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                              ),
                                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        "${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].locationType.toUpperCase()} : ",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                      Text(
                                                                        context
                                                                            .read<DisputeMainBloc>()
                                                                            .disputeMainResponse
                                                                            .disputeList[index]
                                                                            .location,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007AFF)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        "${getIt<Variables>().generalVariables.currentLanguage.dispute.toUpperCase()} #:",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                      Text(
                                                                        context
                                                                            .read<DisputeMainBloc>()
                                                                            .disputeMainResponse
                                                                            .disputeList[index]
                                                                            .disputeNum,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007838)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                                                  vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Flexible(
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Container(
                                                                              height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                              width: getIt<Functions>().getWidgetWidth(width: 40),
                                                                              decoration: BoxDecoration(
                                                                                  shape: BoxShape.circle,
                                                                                  color: Color(int.parse(
                                                                                      '0xFF${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].itemColor}'))),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  context
                                                                                      .read<DisputeMainBloc>()
                                                                                      .disputeMainResponse
                                                                                      .disputeList[index]
                                                                                      .itemType,
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: getIt<Functions>().getTextSize(
                                                                                          fontSize: context
                                                                                                      .read<DisputeMainBloc>()
                                                                                                      .disputeMainResponse
                                                                                                      .disputeList[index]
                                                                                                      .itemType
                                                                                                      .length >=
                                                                                                  2
                                                                                              ? 20
                                                                                              : 24),
                                                                                      color: const Color(0xFFFFFFFF)),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                            ),
                                                                            Flexible(
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  SingleChildScrollView(
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    child: Text(
                                                                                      context
                                                                                          .read<DisputeMainBloc>()
                                                                                          .disputeMainResponse
                                                                                          .disputeList[index]
                                                                                          .itemName,
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w600,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                                                          color: const Color(0xff282F3A)),
                                                                                    ),
                                                                                  ),
                                                                                  IntrinsicHeight(
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Text(
                                                                                          "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].itemCode}",
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                              color: const Color(0xff8A8D8E)),
                                                                                        ),
                                                                                        const VerticalDivider(
                                                                                          color: Color(0xff8A8D8E),
                                                                                        ),
                                                                                        Text(
                                                                                          "${getIt<Variables>().generalVariables.currentLanguage.uom.toUpperCase()} : ${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].uom}",
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                              color: const Color(0xff8A8D8E)),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: SizedBox(
                                                                          height: getIt<Functions>().getWidgetHeight(height: 50),
                                                                          child: ListView(
                                                                            scrollDirection: Axis.horizontal,
                                                                            children: [
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    getIt<Variables>()
                                                                                        .generalVariables
                                                                                        .currentLanguage
                                                                                        .raised
                                                                                        .toUpperCase(),
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                        color: const Color(0xff007838)),
                                                                                  ),
                                                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                                  Text(
                                                                                    context
                                                                                            .read<DisputeMainBloc>()
                                                                                            .disputeMainResponse
                                                                                            .disputeList[index]
                                                                                            .disputeInfo
                                                                                            .by
                                                                                            .isNotEmpty
                                                                                        ? context
                                                                                            .read<DisputeMainBloc>()
                                                                                            .disputeMainResponse
                                                                                            .disputeList[index]
                                                                                            .disputeInfo
                                                                                            .by
                                                                                            .first
                                                                                            .name
                                                                                        : "-",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        color: const Color(0xff282F3A)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                              ),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    getIt<Variables>()
                                                                                        .generalVariables
                                                                                        .currentLanguage
                                                                                        .dateAndTime
                                                                                        .toUpperCase(),
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                        color: const Color(0xff8A8D8E)),
                                                                                  ),
                                                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                                  Text(
                                                                                    context
                                                                                        .read<DisputeMainBloc>()
                                                                                        .disputeMainResponse
                                                                                        .disputeList[index]
                                                                                        .created,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        color: const Color(0xff282F3A)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                              ),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    getIt<Variables>()
                                                                                        .generalVariables
                                                                                        .currentLanguage
                                                                                        .picklist
                                                                                        .toUpperCase(),
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                        color: const Color(0xff8A8D8E)),
                                                                                  ),
                                                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                                  Text(
                                                                                    context
                                                                                        .read<DisputeMainBloc>()
                                                                                        .disputeMainResponse
                                                                                        .disputeList[index]
                                                                                        .picklistNum,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
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
                                                                        width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            context
                                                                                .read<DisputeMainBloc>()
                                                                                .disputeMainResponse
                                                                                .disputeList[index]
                                                                                .quantity,
                                                                            style: TextStyle(
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                                fontWeight: FontWeight.w600,
                                                                                color: const Color(0xffF92C38)),
                                                                          ),
                                                                          Text(
                                                                            getIt<Variables>().generalVariables.currentLanguage.qty.toUpperCase(),
                                                                            style: TextStyle(
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                fontWeight: FontWeight.w500,
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                    ),
                                  );
                                case 1:
                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: getIt<Functions>().getWidgetWidth(width: 12),
                                        right: getIt<Functions>().getWidgetWidth(width: 12),
                                        bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                    child: SmartRefresher(
                                      enablePullDown: true,
                                      enablePullUp: true,
                                      physics: const BouncingScrollPhysics(),
                                      onRefresh: () {
                                        context.read<DisputeMainBloc>().pageIndex = 1;
                                        context.read<DisputeMainBloc>().add(const DisputeMainTabChangingEvent(isLoading: false));
                                        resolvedRefreshController.refreshCompleted();
                                        setState(() {});
                                      },
                                      footer: CustomFooter(
                                        builder: (BuildContext context, LoadStatus? mode) {
                                          Widget body;
                                          if (mode == LoadStatus.idle) {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.pullUpLoad);
                                          } else if (mode == LoadStatus.loading) {
                                            body = const CupertinoActivityIndicator();
                                          } else if (mode == LoadStatus.failed) {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.pullUpLoadFailed);
                                          } else if (mode == LoadStatus.canLoading) {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.releaseLoad);
                                          } else {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.noMoreData);
                                          }
                                          return SizedBox(
                                            height: getIt<Functions>().getWidgetHeight(height: 65),
                                            child: Center(child: body),
                                          );
                                        },
                                      ),
                                      controller: resolvedRefreshController,
                                      onLoading: () {
                                        context.read<DisputeMainBloc>().pageIndex++;
                                        context.read<DisputeMainBloc>().add(const DisputeMainTabChangingEvent(isLoading: true));
                                        resolvedRefreshController.loadComplete();
                                        setState(() {});
                                      },
                                      child: context.read<DisputeMainBloc>().disputeMainResponse.disputeList.isEmpty
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
                                                  getIt<Variables>().generalVariables.currentLanguage.disputeListIsEmpty,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ],
                                            )
                                          : ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics: const ScrollPhysics(),
                                              itemCount: context.read<DisputeMainBloc>().disputeMainResponse.disputeList.length,
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        context.read<DisputeMainBloc>().selectedIndex = index;
                                                        getIt<Variables>().generalVariables.disputeTab = "resolved";
                                                        getIt<Variables>().generalVariables.indexName = DisputeDetailScreen.id;
                                                        getIt<Variables>().generalVariables.disputeRouteList.add(DisputeScreen.id);
                                                        context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                        margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              height: getIt<Functions>().getWidgetHeight(height: 38),
                                                              decoration: const BoxDecoration(
                                                                color: Color(0xffE3E7EA),
                                                                borderRadius:
                                                                    BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                              ),
                                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        "${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].locationType} : ",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                      Text(
                                                                        context
                                                                            .read<DisputeMainBloc>()
                                                                            .disputeMainResponse
                                                                            .disputeList[index]
                                                                            .location,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007AFF)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        "${getIt<Variables>().generalVariables.currentLanguage.dispute.toUpperCase()} #:",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                      Text(
                                                                        context
                                                                            .read<DisputeMainBloc>()
                                                                            .disputeMainResponse
                                                                            .disputeList[index]
                                                                            .disputeNum,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007838)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                                                  vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Flexible(
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Container(
                                                                              height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                              width: getIt<Functions>().getWidgetWidth(width: 40),
                                                                              decoration: BoxDecoration(
                                                                                  shape: BoxShape.circle,
                                                                                  color: Color(int.parse(
                                                                                      '0xFF${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].itemColor}'))),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  context
                                                                                      .read<DisputeMainBloc>()
                                                                                      .disputeMainResponse
                                                                                      .disputeList[index]
                                                                                      .itemType,
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: getIt<Functions>().getTextSize(
                                                                                          fontSize: context
                                                                                                      .read<DisputeMainBloc>()
                                                                                                      .disputeMainResponse
                                                                                                      .disputeList[index]
                                                                                                      .itemType
                                                                                                      .length >=
                                                                                                  2
                                                                                              ? 20
                                                                                              : 24),
                                                                                      color: const Color(0xFFFFFFFF)),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                            ),
                                                                            Expanded(
                                                                              child: SingleChildScrollView(
                                                                                scrollDirection: Axis.horizontal,
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      context
                                                                                          .read<DisputeMainBloc>()
                                                                                          .disputeMainResponse
                                                                                          .disputeList[index]
                                                                                          .itemName,
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w600,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                                                          color: const Color(0xff282F3A)),
                                                                                    ),
                                                                                    IntrinsicHeight(
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Text(
                                                                                            "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].itemCode}",
                                                                                            style: TextStyle(
                                                                                                fontWeight: FontWeight.w500,
                                                                                                fontSize:
                                                                                                    getIt<Functions>().getTextSize(fontSize: 11),
                                                                                                color: const Color(0xff8A8D8E)),
                                                                                          ),
                                                                                          const VerticalDivider(
                                                                                            color: Color(0xff8A8D8E),
                                                                                          ),
                                                                                          Text(
                                                                                            "${getIt<Variables>().generalVariables.currentLanguage.uom.toUpperCase()} : ${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].uom}",
                                                                                            style: TextStyle(
                                                                                                fontWeight: FontWeight.w500,
                                                                                                fontSize:
                                                                                                    getIt<Functions>().getTextSize(fontSize: 11),
                                                                                                color: const Color(0xff8A8D8E)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            context
                                                                                .read<DisputeMainBloc>()
                                                                                .disputeMainResponse
                                                                                .disputeList[index]
                                                                                .quantity,
                                                                            style: TextStyle(
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                                fontWeight: FontWeight.w600,
                                                                                color: const Color(0xff007838)),
                                                                          ),
                                                                          Text(
                                                                            getIt<Variables>().generalVariables.currentLanguage.dispute.toUpperCase(),
                                                                            style: TextStyle(
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                fontWeight: FontWeight.w500,
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: SizedBox(
                                                                          height: getIt<Functions>().getWidgetHeight(height: 50),
                                                                          child: ListView(
                                                                            scrollDirection: Axis.horizontal,
                                                                            children: [
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    getIt<Variables>()
                                                                                        .generalVariables
                                                                                        .currentLanguage
                                                                                        .raised
                                                                                        .toUpperCase(),
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                        color: const Color(0xff007838)),
                                                                                  ),
                                                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                                  Text(
                                                                                    context
                                                                                            .read<DisputeMainBloc>()
                                                                                            .disputeMainResponse
                                                                                            .disputeList[index]
                                                                                            .disputeInfo
                                                                                            .by
                                                                                            .isNotEmpty
                                                                                        ? context
                                                                                            .read<DisputeMainBloc>()
                                                                                            .disputeMainResponse
                                                                                            .disputeList[index]
                                                                                            .disputeInfo
                                                                                            .by
                                                                                            .first
                                                                                            .name
                                                                                        : "-",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        color: const Color(0xff282F3A)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                              ),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    getIt<Variables>()
                                                                                        .generalVariables
                                                                                        .currentLanguage
                                                                                        .dateAndTime
                                                                                        .toUpperCase(),
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                        color: const Color(0xff8A8D8E)),
                                                                                  ),
                                                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                                  Text(
                                                                                    context
                                                                                        .read<DisputeMainBloc>()
                                                                                        .disputeMainResponse
                                                                                        .disputeList[index]
                                                                                        .created,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        color: const Color(0xff282F3A)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                              ),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    getIt<Variables>()
                                                                                        .generalVariables
                                                                                        .currentLanguage
                                                                                        .resolved
                                                                                        .toUpperCase(),
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                        color: const Color(0xff007838)),
                                                                                  ),
                                                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                                  Text(
                                                                                    context
                                                                                            .read<DisputeMainBloc>()
                                                                                            .disputeMainResponse
                                                                                            .disputeList[index]
                                                                                            .resolutionInfo
                                                                                            .by
                                                                                            .isNotEmpty
                                                                                        ? context
                                                                                            .read<DisputeMainBloc>()
                                                                                            .disputeMainResponse
                                                                                            .disputeList[index]
                                                                                            .resolutionInfo
                                                                                            .by
                                                                                            .first
                                                                                            .name
                                                                                        : "-",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        color: const Color(0xff282F3A)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                              ),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    getIt<Variables>()
                                                                                        .generalVariables
                                                                                        .currentLanguage
                                                                                        .dateAndTime
                                                                                        .toUpperCase(),
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                        color: const Color(0xff8A8D8E)),
                                                                                  ),
                                                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                                  Text(
                                                                                    context
                                                                                            .read<DisputeMainBloc>()
                                                                                            .disputeMainResponse
                                                                                            .disputeList[index]
                                                                                            .resolutionInfo
                                                                                            .by
                                                                                            .isNotEmpty
                                                                                        ? context
                                                                                            .read<DisputeMainBloc>()
                                                                                            .disputeMainResponse
                                                                                            .disputeList[index]
                                                                                            .resolutionInfo
                                                                                            .on
                                                                                        : "-",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        color: const Color(0xff282F3A)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                              ),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    getIt<Variables>()
                                                                                        .generalVariables
                                                                                        .currentLanguage
                                                                                        .picklist
                                                                                        .toUpperCase(),
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                        color: const Color(0xff8A8D8E)),
                                                                                  ),
                                                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                                  Text(
                                                                                    context
                                                                                        .read<DisputeMainBloc>()
                                                                                        .disputeMainResponse
                                                                                        .disputeList[index]
                                                                                        .picklistNum,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
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
                                                                        width: getIt<Functions>().getWidgetWidth(width: 12),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                    ),
                                  );
                                default:
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                    child: SmartRefresher(
                                      enablePullDown: true,
                                      enablePullUp: true,
                                      physics: const BouncingScrollPhysics(),
                                      onRefresh: () {
                                        context.read<DisputeMainBloc>().pageIndex = 1;
                                        context.read<DisputeMainBloc>().add(const DisputeMainTabChangingEvent(isLoading: false));
                                        yetToSolveRefreshController.refreshCompleted();
                                        setState(() {});
                                      },
                                      footer: CustomFooter(
                                        builder: (BuildContext context, LoadStatus? mode) {
                                          Widget body;
                                          if (mode == LoadStatus.idle) {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.pullUpLoad);
                                          } else if (mode == LoadStatus.loading) {
                                            body = const CupertinoActivityIndicator();
                                          } else if (mode == LoadStatus.failed) {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.pullUpLoadFailed);
                                          } else if (mode == LoadStatus.canLoading) {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.releaseLoad);
                                          } else {
                                            body = Text(getIt<Variables>().generalVariables.currentLanguage.noMoreData);
                                          }
                                          return SizedBox(
                                            height: getIt<Functions>().getWidgetHeight(height: 65),
                                            child: Center(child: body),
                                          );
                                        },
                                      ),
                                      controller: yetToSolveRefreshController,
                                      onLoading: () {
                                        context.read<DisputeMainBloc>().pageIndex++;
                                        context.read<DisputeMainBloc>().add(const DisputeMainTabChangingEvent(isLoading: true));
                                        yetToSolveRefreshController.loadComplete();
                                        setState(() {});
                                      },
                                      child: context.read<DisputeMainBloc>().disputeMainResponse.disputeList.isEmpty
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
                                                  getIt<Variables>().generalVariables.currentLanguage.disputeListIsEmpty,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w600),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            )
                                          : ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics: const ScrollPhysics(),
                                              itemCount: context.read<DisputeMainBloc>().disputeMainResponse.disputeList.length,
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        context.read<DisputeMainBloc>().selectedIndex = index;
                                                        getIt<Variables>().generalVariables.disputeTab = "yet_to_resolve";
                                                        getIt<Variables>().generalVariables.indexName = DisputeDetailScreen.id;
                                                        getIt<Variables>().generalVariables.disputeRouteList.add(DisputeScreen.id);
                                                        context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                        margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              height: getIt<Functions>().getWidgetHeight(height: 38),
                                                              decoration: const BoxDecoration(
                                                                color: Color(0xffE3E7EA),
                                                                borderRadius:
                                                                    BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                              ),
                                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        "${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].locationType.toUpperCase()} : ",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                      Text(
                                                                        context
                                                                            .read<DisputeMainBloc>()
                                                                            .disputeMainResponse
                                                                            .disputeList[index]
                                                                            .location,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007AFF)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        "${getIt<Variables>().generalVariables.currentLanguage.dispute.toUpperCase()} #:",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                      Text(
                                                                        context
                                                                            .read<DisputeMainBloc>()
                                                                            .disputeMainResponse
                                                                            .disputeList[index]
                                                                            .disputeNum,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007838)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                                                  vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Flexible(
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Container(
                                                                              height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                              width: getIt<Functions>().getWidgetWidth(width: 40),
                                                                              decoration: BoxDecoration(
                                                                                  shape: BoxShape.circle,
                                                                                  color: Color(int.parse(
                                                                                      '0xFF${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].itemColor}'))),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  context
                                                                                      .read<DisputeMainBloc>()
                                                                                      .disputeMainResponse
                                                                                      .disputeList[index]
                                                                                      .itemType,
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: getIt<Functions>().getTextSize(
                                                                                          fontSize: context
                                                                                                      .read<DisputeMainBloc>()
                                                                                                      .disputeMainResponse
                                                                                                      .disputeList[index]
                                                                                                      .itemType
                                                                                                      .length >=
                                                                                                  2
                                                                                              ? 20
                                                                                              : 24),
                                                                                      color: const Color(0xFFFFFFFF)),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                            ),
                                                                            Flexible(
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  SingleChildScrollView(
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    child: Text(
                                                                                      context
                                                                                          .read<DisputeMainBloc>()
                                                                                          .disputeMainResponse
                                                                                          .disputeList[index]
                                                                                          .itemName,
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w600,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                                                          color: const Color(0xff282F3A)),
                                                                                    ),
                                                                                  ),
                                                                                  IntrinsicHeight(
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Text(
                                                                                          "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].itemCode}",
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                              color: const Color(0xff8A8D8E)),
                                                                                        ),
                                                                                        const VerticalDivider(
                                                                                          color: Color(0xff8A8D8E),
                                                                                        ),
                                                                                        Text(
                                                                                          "${getIt<Variables>().generalVariables.currentLanguage.uom.toUpperCase()} : ${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[index].uom}",
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                              color: const Color(0xff8A8D8E)),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: SizedBox(
                                                                          height: getIt<Functions>().getWidgetHeight(height: 50),
                                                                          child: ListView(
                                                                            scrollDirection: Axis.horizontal,
                                                                            children: [
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    getIt<Variables>()
                                                                                        .generalVariables
                                                                                        .currentLanguage
                                                                                        .raised
                                                                                        .toUpperCase(),
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                        color: const Color(0xff007838)),
                                                                                  ),
                                                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                                  Text(
                                                                                    context
                                                                                            .read<DisputeMainBloc>()
                                                                                            .disputeMainResponse
                                                                                            .disputeList[index]
                                                                                            .disputeInfo
                                                                                            .by
                                                                                            .isNotEmpty
                                                                                        ? context
                                                                                            .read<DisputeMainBloc>()
                                                                                            .disputeMainResponse
                                                                                            .disputeList[index]
                                                                                            .disputeInfo
                                                                                            .by
                                                                                            .first
                                                                                            .name
                                                                                        : "-",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        color: const Color(0xff282F3A)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                              ),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    getIt<Variables>()
                                                                                        .generalVariables
                                                                                        .currentLanguage
                                                                                        .dateAndTime
                                                                                        .toUpperCase(),
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                        color: const Color(0xff8A8D8E)),
                                                                                  ),
                                                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                                  Text(
                                                                                    context
                                                                                        .read<DisputeMainBloc>()
                                                                                        .disputeMainResponse
                                                                                        .disputeList[index]
                                                                                        .created,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        color: const Color(0xff282F3A)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                              ),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    getIt<Variables>()
                                                                                        .generalVariables
                                                                                        .currentLanguage
                                                                                        .picklist
                                                                                        .toUpperCase(),
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                        color: const Color(0xff8A8D8E)),
                                                                                  ),
                                                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                                  Text(
                                                                                    context
                                                                                        .read<DisputeMainBloc>()
                                                                                        .disputeMainResponse
                                                                                        .disputeList[index]
                                                                                        .picklistNum,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
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
                                                                        width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            context
                                                                                .read<DisputeMainBloc>()
                                                                                .disputeMainResponse
                                                                                .disputeList[index]
                                                                                .quantity,
                                                                            style: TextStyle(
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                                fontWeight: FontWeight.w600,
                                                                                color: const Color(0xffF92C38)),
                                                                          ),
                                                                          Text(
                                                                            getIt<Variables>().generalVariables.currentLanguage.qty.toUpperCase(),
                                                                            style: TextStyle(
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                fontWeight: FontWeight.w500,
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                    ),
                                  );
                              }
                            } else if (state is DisputeMainLoading) {
                              switch (context.read<DisputeMainBloc>().tabIndex) {
                                case 0:
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
                                          itemCount: 5,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                  margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: getIt<Functions>().getWidgetHeight(height: 38),
                                                        decoration: const BoxDecoration(
                                                          color: Color(0xffE3E7EA),
                                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                        ),
                                                        padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  "${getIt<Variables>().generalVariables.currentLanguage.stagingArea.toUpperCase()} : ",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      fontWeight: FontWeight.w600,
                                                                      color: const Color(0xff282F3A)),
                                                                ),
                                                                Text(
                                                                  "COMMON AREA",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      fontWeight: FontWeight.w600,
                                                                      color: const Color(0xff007AFF)),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  "${getIt<Variables>().generalVariables.currentLanguage.dispute.toUpperCase()} #:",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      fontWeight: FontWeight.w600,
                                                                      color: const Color(0xff282F3A)),
                                                                ),
                                                                Text(
                                                                  "19604519",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      fontWeight: FontWeight.w600,
                                                                      color: const Color(0xff007838)),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                                            vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Container(
                                                                      height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                      width: getIt<Functions>().getWidgetWidth(width: 40),
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
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "Barilla Spagetti N.5 - 15x500GR",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : MB002",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                            Text(
                                                                              "${getIt<Variables>().generalVariables.currentLanguage.uom.toUpperCase()} : Pack",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: getIt<Functions>().getWidgetHeight(height: 16),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: SizedBox(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 50),
                                                                    child: ListView(
                                                                      scrollDirection: Axis.horizontal,
                                                                      children: [
                                                                        Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              getIt<Variables>()
                                                                                  .generalVariables
                                                                                  .currentLanguage
                                                                                  .raised
                                                                                  .toUpperCase(),
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                  color: const Color(0xff007838)),
                                                                            ),
                                                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                            Text(
                                                                              "John Smith",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              getIt<Variables>()
                                                                                  .generalVariables
                                                                                  .currentLanguage
                                                                                  .dateAndTime
                                                                                  .toUpperCase(),
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                            Text(
                                                                              "19/05/2024, 01:10 PM",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              getIt<Variables>()
                                                                                  .generalVariables
                                                                                  .currentLanguage
                                                                                  .picklist
                                                                                  .toUpperCase(),
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                            Text(
                                                                              "BTS-01",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
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
                                                                  width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      "41",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xffF92C38)),
                                                                    ),
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.qty.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          fontWeight: FontWeight.w500,
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                  );
                                case 1:
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
                                          itemCount: 5,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                  margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: getIt<Functions>().getWidgetHeight(height: 38),
                                                        decoration: const BoxDecoration(
                                                          color: Color(0xffE3E7EA),
                                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                        ),
                                                        padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  "${getIt<Variables>().generalVariables.currentLanguage.stagingArea.toUpperCase()} : ",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      fontWeight: FontWeight.w600,
                                                                      color: const Color(0xff282F3A)),
                                                                ),
                                                                Text(
                                                                  "COMMON AREA",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      fontWeight: FontWeight.w600,
                                                                      color: const Color(0xff007AFF)),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  "${getIt<Variables>().generalVariables.currentLanguage.dispute.toUpperCase()} #:",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      fontWeight: FontWeight.w600,
                                                                      color: const Color(0xff282F3A)),
                                                                ),
                                                                Text(
                                                                  "19604519",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      fontWeight: FontWeight.w600,
                                                                      color: const Color(0xff007838)),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                                            vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Container(
                                                                      height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                      width: getIt<Functions>().getWidgetWidth(width: 40),
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
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "Barilla Spagetti N.5 - 15x500GR",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : MB002",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                            Text(
                                                                              "${getIt<Variables>().generalVariables.currentLanguage.uom.toUpperCase()} : Pack",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: getIt<Functions>().getWidgetHeight(height: 16),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: SizedBox(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 50),
                                                                    child: ListView(
                                                                      scrollDirection: Axis.horizontal,
                                                                      children: [
                                                                        Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              getIt<Variables>()
                                                                                  .generalVariables
                                                                                  .currentLanguage
                                                                                  .itemType
                                                                                  .toUpperCase(),
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                            Text(
                                                                              "D",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              getIt<Variables>()
                                                                                  .generalVariables
                                                                                  .currentLanguage
                                                                                  .updatedTime
                                                                                  .toUpperCase(),
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                            Text(
                                                                              "19/05/2024, 01:10 PM",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              getIt<Variables>()
                                                                                  .generalVariables
                                                                                  .currentLanguage
                                                                                  .picklist
                                                                                  .toUpperCase(),
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                            Text(
                                                                              "#24102211",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
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
                                                                  width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                  children: [
                                                                    Text(
                                                                      "41",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xffF92C38)),
                                                                    ),
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.dispute.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          fontWeight: FontWeight.w500,
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                  );
                                default:
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
                                          itemCount: 5,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                  margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: getIt<Functions>().getWidgetHeight(height: 38),
                                                        decoration: const BoxDecoration(
                                                          color: Color(0xffE3E7EA),
                                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                        ),
                                                        padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  "${getIt<Variables>().generalVariables.currentLanguage.stagingArea.toUpperCase()} : ",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      fontWeight: FontWeight.w600,
                                                                      color: const Color(0xff282F3A)),
                                                                ),
                                                                Text(
                                                                  "COMMON AREA",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      fontWeight: FontWeight.w600,
                                                                      color: const Color(0xff007AFF)),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  "${getIt<Variables>().generalVariables.currentLanguage.dispute.toUpperCase()} #:",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      fontWeight: FontWeight.w600,
                                                                      color: const Color(0xff282F3A)),
                                                                ),
                                                                Text(
                                                                  "19604519",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      fontWeight: FontWeight.w600,
                                                                      color: const Color(0xff007838)),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                                            vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Container(
                                                                      height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                      width: getIt<Functions>().getWidgetWidth(width: 40),
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
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "Barilla Spagetti N.5 - 15x500GR",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : MB002",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                            Text(
                                                                              "${getIt<Variables>().generalVariables.currentLanguage.uom.toUpperCase()} : Pack",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: getIt<Functions>().getWidgetHeight(height: 16),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: SizedBox(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 50),
                                                                    child: ListView(
                                                                      scrollDirection: Axis.horizontal,
                                                                      children: [
                                                                        Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              getIt<Variables>()
                                                                                  .generalVariables
                                                                                  .currentLanguage
                                                                                  .raised
                                                                                  .toUpperCase(),
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                  color: const Color(0xff007838)),
                                                                            ),
                                                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                            Text(
                                                                              "John Smith",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              getIt<Variables>()
                                                                                  .generalVariables
                                                                                  .currentLanguage
                                                                                  .dateAndTime
                                                                                  .toUpperCase(),
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                            Text(
                                                                              "19/05/2024, 01:10 PM",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              getIt<Variables>()
                                                                                  .generalVariables
                                                                                  .currentLanguage
                                                                                  .picklist
                                                                                  .toUpperCase(),
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                  color: const Color(0xff8A8D8E)),
                                                                            ),
                                                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                            Text(
                                                                              "BTS-01",
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
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
                                                                  width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      "41",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xffF92C38)),
                                                                    ),
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.qty.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          fontWeight: FontWeight.w500,
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                  );
                              }
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ),
                    ],
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
    return BlocBuilder<DisputeMainBloc, DisputeMainState>(
      builder: (BuildContext context, DisputeMainState state) {
        return Padding(
          padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 15)),
          child: SizedBox(
            height: getIt<Functions>().getWidgetHeight(height: 36),
            width: getIt<Functions>().getWidgetWidth(width: 268),
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
                          context.read<DisputeMainBloc>().searchText = value.toLowerCase();
                          context.read<DisputeMainBloc>().pageIndex = 1;
                          context.read<DisputeMainBloc>().add(const DisputeMainTabChangingEvent(isLoading: false));
                        } else {
                          context.read<DisputeMainBloc>().searchText = "";
                          context.read<DisputeMainBloc>().pageIndex = 1;
                          context.read<DisputeMainBloc>().add(const DisputeMainTabChangingEvent(isLoading: false));
                        }
                      });
                    },
                    controller: controller,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 15), fontWeight: FontWeight.w500, color: Colors.black),
                    decoration: InputDecoration(
                        fillColor: const Color(0xff767680).withOpacity(0.12),
                        filled: true,
                        contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 15)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68)),
                        prefixIcon: const Icon(Icons.search, color: Color(0xff8F9BB3)),
                        suffixIcon: controller.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  controller.clear();
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  context.read<DisputeMainBloc>().add(const DisputeMainSetStateEvent());
                                  context.read<DisputeMainBloc>().searchText = "";
                                  context.read<DisputeMainBloc>().pageIndex = 1;
                                  context.read<DisputeMainBloc>().add(const DisputeMainTabChangingEvent(isLoading: false));
                                },
                                icon: const Icon(Icons.clear, color: Colors.black, size: 15))
                            : const SizedBox(),
                        hintText: getIt<Variables>().generalVariables.currentLanguage.search,
                        hintStyle: TextStyle(
                            color: const Color(0xff8F9BB3), fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 15))),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
