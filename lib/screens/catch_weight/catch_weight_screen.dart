// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Project imports:
import 'package:oda/bloc/catch_weight/catch_weight_bloc.dart';
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/edited_packages/drop_down_lib/drop_down_search_field.dart';
import 'package:oda/local_database/user_box/user.dart';
import 'package:oda/repository_model/catch_weight/catch_weight_list_model.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/resources/widgets.dart';
import 'package:oda/screens/home/home_screen.dart';

class CatchWeightScreen extends StatefulWidget {
  static const String id = "catch_weight_screen";

  const CatchWeightScreen({super.key});

  @override
  State<CatchWeightScreen> createState() => _CatchWeightScreenState();
}

class _CatchWeightScreenState extends State<CatchWeightScreen> with TickerProviderStateMixin {
  TextEditingController searchBar = TextEditingController();
  TextEditingController commentsBar = TextEditingController();
  TextEditingController reasonSearchFieldController = TextEditingController();
  TextEditingController itemSearchFieldController = TextEditingController();
  SuggestionsBoxController reasonSuggestionBoxController = SuggestionsBoxController();
  SuggestionsBoxController itemSuggestionBoxController = SuggestionsBoxController();
  RefreshController yetToUpdateRefreshController = RefreshController();
  RefreshController updatedRefreshController = RefreshController();
  RefreshController unavailableRefreshController = RefreshController();
  RefreshController completedRefreshController = RefreshController();
  TabController? tabController;
  Timer? timer;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this, initialIndex: 0)
      ..addListener(() {
        if (tabController!.indexIsChanging) {
          context.read<CatchWeightBloc>().pageIndex = 1;
          context.read<CatchWeightBloc>().tabIndex = tabController!.index;
          switch (context.read<CatchWeightBloc>().tabIndex) {
            case 0:
              context.read<CatchWeightBloc>().tabName = "Submitted";
            case 1:
              context.read<CatchWeightBloc>().tabName = "Updated";
            case 2:
              context.read<CatchWeightBloc>().tabName = "Not Available";
            case 3:
              context.read<CatchWeightBloc>().tabName = "Completed";
            default:
              context.read<CatchWeightBloc>().tabName = "Submitted";
          }
          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: false));
          setState(() {});
        }
      });
    context.read<CatchWeightBloc>().add(const CatchWeightInitialEvent());
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
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 480) {
            return Container(
              color: const Color(0xffEEF4FF),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  BlocBuilder<CatchWeightBloc, CatchWeightState>(
                    builder: (BuildContext context, CatchWeightState catchWeight) {
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
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  getIt<Variables>().generalVariables.currentLanguage.catchWeightList,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: getIt<Functions>().getTextSize(fontSize: 26),
                                      color: const Color(0xff282F3A)),
                                ),
                              ),
                              textBars(controller: searchBar)
                            ],
                          ),
                          titleSpacing: 0,
                          actions: [
                            IconButton(
                              splashColor: Colors.transparent,
                              splashRadius: 0.1,
                              padding: EdgeInsets.zero,
                              focusColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: catchWeight is CatchWeightLoading
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
                        BlocBuilder<CatchWeightBloc, CatchWeightState>(
                          builder: (BuildContext context, CatchWeightState catchWeight) {
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
                                labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis),
                                unselectedLabelStyle: TextStyle(
                                    color: const Color(0xff6F6F6F),
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis),
                                splashBorderRadius: BorderRadius.circular(8),
                                padding: const EdgeInsets.all(3),
                                indicatorSize: TabBarIndicatorSize.tab,
                                dividerColor: Colors.transparent,
                                dividerHeight: 0.0,
                                tabs: [
                                  Tab(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(child: Text(getIt<Variables>().generalVariables.currentLanguage.yetToUpdate.toUpperCase())),
                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                        context.read<CatchWeightBloc>().catchWeightListResponse.yetToUpdate == 0
                                            ? const SizedBox()
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                    vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                decoration: BoxDecoration(
                                                    color: context.read<CatchWeightBloc>().tabIndex == 0 ? Colors.white : const Color(0xff007AFF),
                                                    borderRadius: BorderRadius.circular(20)),
                                                child: Text(
                                                  context.read<CatchWeightBloc>().catchWeightListResponse.yetToUpdate < 10
                                                      ? "0${context.read<CatchWeightBloc>().catchWeightListResponse.yetToUpdate}"
                                                      : context.read<CatchWeightBloc>().catchWeightListResponse.yetToUpdate.toString(),
                                                  style: TextStyle(
                                                      color: context.read<CatchWeightBloc>().tabIndex == 0 ? const Color(0xff282F3A) : Colors.white,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                  Tab(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Flexible(child: Text(getIt<Variables>().generalVariables.currentLanguage.updated.toUpperCase())),
                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                        context.read<CatchWeightBloc>().catchWeightListResponse.updated == 0
                                            ? const SizedBox()
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                    vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                decoration: BoxDecoration(
                                                    color: context.read<CatchWeightBloc>().tabIndex == 1 ? Colors.white : const Color(0xff007AFF),
                                                    borderRadius: BorderRadius.circular(20)),
                                                child: Text(
                                                  context.read<CatchWeightBloc>().catchWeightListResponse.updated < 10
                                                      ? "0${context.read<CatchWeightBloc>().catchWeightListResponse.updated}"
                                                      : context.read<CatchWeightBloc>().catchWeightListResponse.updated.toString(),
                                                  style: TextStyle(
                                                      color: context.read<CatchWeightBloc>().tabIndex == 1 ? const Color(0xff282F3A) : Colors.white,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                  Tab(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Flexible(child: Text(getIt<Variables>().generalVariables.currentLanguage.unavailable.toUpperCase())),
                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                        context.read<CatchWeightBloc>().catchWeightListResponse.unavailable == 0
                                            ? const SizedBox()
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                    vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                decoration: BoxDecoration(
                                                    color: context.read<CatchWeightBloc>().tabIndex == 2 ? Colors.white : const Color(0xff007AFF),
                                                    borderRadius: BorderRadius.circular(20)),
                                                child: Text(
                                                  context.read<CatchWeightBloc>().catchWeightListResponse.unavailable < 10
                                                      ? "0${context.read<CatchWeightBloc>().catchWeightListResponse.unavailable}"
                                                      : context.read<CatchWeightBloc>().catchWeightListResponse.unavailable.toString(),
                                                  style: TextStyle(
                                                      color: context.read<CatchWeightBloc>().tabIndex == 2 ? const Color(0xff282F3A) : Colors.white,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                  Tab(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Flexible(child: Text(getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase())),
                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                        context.read<CatchWeightBloc>().catchWeightListResponse.completed == 0
                                            ? const SizedBox()
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                    vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                decoration: BoxDecoration(
                                                    color: context.read<CatchWeightBloc>().tabIndex == 3 ? Colors.white : const Color(0xff007AFF),
                                                    borderRadius: BorderRadius.circular(20)),
                                                child: Text(
                                                  context.read<CatchWeightBloc>().catchWeightListResponse.completed < 10
                                                      ? "0${context.read<CatchWeightBloc>().catchWeightListResponse.completed}"
                                                      : context.read<CatchWeightBloc>().catchWeightListResponse.completed.toString(),
                                                  style: TextStyle(
                                                      color: context.read<CatchWeightBloc>().tabIndex == 3 ? const Color(0xff282F3A) : Colors.white,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Expanded(
                          child: BlocConsumer<CatchWeightBloc, CatchWeightState>(
                            listenWhen: (CatchWeightState previous, CatchWeightState current) {
                              return previous != current;
                            },
                            buildWhen: (CatchWeightState previous, CatchWeightState current) {
                              return previous != current;
                            },
                            listener: (BuildContext context, CatchWeightState state) {
                              if (state is CatchWeightError) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                              }
                            },
                            builder: (BuildContext context, CatchWeightState catchWeight) {
                              if (catchWeight is CatchWeightLoaded) {
                                switch (context.read<CatchWeightBloc>().tabIndex) {
                                  case 0:
                                    return Container(
                                      margin: EdgeInsets.only(
                                          left: getIt<Functions>().getWidgetWidth(width: 16),
                                          right: getIt<Functions>().getWidgetWidth(width: 16),
                                          bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                      child: SmartRefresher(
                                        enablePullDown: true,
                                        enablePullUp: true,
                                        physics: const BouncingScrollPhysics(),
                                        onRefresh: () {
                                          context.read<CatchWeightBloc>().pageIndex = 1;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: false));
                                          yetToUpdateRefreshController.refreshCompleted();
                                          setState(() {});
                                        },
                                        controller: yetToUpdateRefreshController,
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
                                        onLoading: () {
                                          context.read<CatchWeightBloc>().pageIndex++;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: true));
                                          yetToUpdateRefreshController.loadComplete();
                                          setState(() {});
                                        },
                                        child: context.read<CatchWeightBloc>().catchWeightListResponse.items.isEmpty
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
                                                    getIt<Variables>().generalVariables.currentLanguage.catchWeightListIsEmpty,
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
                                                itemCount: context.read<CatchWeightBloc>().catchWeightListResponse.items.length,
                                                shrinkWrap: true,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Container(
                                                    height: getIt<Functions>().getWidgetHeight(height: 180),
                                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                    margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                                              Expanded(
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      "${getIt<Variables>().generalVariables.currentLanguage.customer.toUpperCase()} : ",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                    Expanded(
                                                                      child: Text(
                                                                        context
                                                                            .read<CatchWeightBloc>()
                                                                            .catchWeightListResponse
                                                                            .items[index]
                                                                            .customerName,
                                                                        maxLines: 1,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007AFF)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              IntrinsicHeight(
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap: () {
                                                                        context.read<CatchWeightBloc>().selectedItemId =
                                                                            context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                        reasonSearchFieldController.clear();
                                                                        itemSearchFieldController.clear();
                                                                        context.read<CatchWeightBloc>().selectedReason = "";
                                                                        context.read<CatchWeightBloc>().selectedItem = "";
                                                                        commentsBar.clear();
                                                                        context.read<CatchWeightBloc>().updateLoader = false;
                                                                        context.read<CatchWeightBloc>().commentTextEmpty = false;
                                                                        context.read<CatchWeightBloc>().selectedReasonEmpty = false;
                                                                        context.read<CatchWeightBloc>().selectItemEmpty = false;
                                                                        context.read<CatchWeightBloc>().hideKeyBoardReason = false;
                                                                        context.read<CatchWeightBloc>().hideKeyBoardItem = false;
                                                                        getIt<Variables>().generalVariables.popUpWidget =
                                                                            unavailableContent(index: index);
                                                                        getIt<Functions>().showAnimatedDialog(
                                                                            context: context, isFromTop: false, isCloseDisabled: false);
                                                                      },
                                                                      child: Text(
                                                                        getIt<Variables>().generalVariables.currentLanguage.unavailable.toUpperCase(),
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xffF92C38)),
                                                                      ),
                                                                    ),
                                                                    const VerticalDivider(
                                                                      color: Color(0xff8A8D8E),
                                                                    ),
                                                                    InkWell(
                                                                      onTap: () {
                                                                        context.read<CatchWeightBloc>().selectedItemId =
                                                                            context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                        reasonSearchFieldController.clear();
                                                                        itemSearchFieldController.clear();
                                                                        context.read<CatchWeightBloc>().selectedReason = "";
                                                                        context.read<CatchWeightBloc>().selectedItem = "";
                                                                        commentsBar.clear();
                                                                        context.read<CatchWeightBloc>().chipsContentList.clear();
                                                                        context.read<CatchWeightBloc>().textFieldEmpty = false;
                                                                        context.read<CatchWeightBloc>().availableQtyParticularsEmpty = false;
                                                                        context.read<CatchWeightBloc>().updateLoader = false;
                                                                        context.read<CatchWeightBloc>().formatError = false;
                                                                        context.read<CatchWeightBloc>().moreQuantityError = false;
                                                                        context.read<CatchWeightBloc>().isZeroValue = false;
                                                                        getIt<Variables>().generalVariables.popUpWidget =
                                                                            availableContent(index: index, isYetToUpdate: true);
                                                                        getIt<Functions>().showAnimatedDialog(
                                                                            context: context, isFromTop: false, isCloseDisabled: false);
                                                                      },
                                                                      child: Text(
                                                                        getIt<Variables>().generalVariables.currentLanguage.available.toUpperCase(),
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007838)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
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
                                                                              image: DecorationImage(
                                                                                image: NetworkImage(context
                                                                                    .read<CatchWeightBloc>()
                                                                                    .catchWeightListResponse
                                                                                    .items[index]
                                                                                    .itemImage),
                                                                                fit: BoxFit.fill,
                                                                              )),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                        ),
                                                                        Flexible(
                                                                          child: SizedBox(
                                                                            height: getIt<Functions>().getWidgetHeight(height: 41),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Text(
                                                                                    context
                                                                                        .read<CatchWeightBloc>()
                                                                                        .catchWeightListResponse
                                                                                        .items[index]
                                                                                        .itemName,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                        color: const Color(0xff282F3A)),
                                                                                  ),
                                                                                ),
                                                                                IntrinsicHeight(
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.soNumber.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].soNumber}",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                            color: const Color(0xff8A8D8E)),
                                                                                      ),
                                                                                      const VerticalDivider(
                                                                                        color: Color(0xff8A8D8E),
                                                                                      ),
                                                                                      Text(
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].itemCode}",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                            color: const Color(0xff8A8D8E)),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    children: [
                                                                      Text(
                                                                        "${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].reqQuantity} ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].weightUnit}",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007AFF)),
                                                                      ),
                                                                      Text(
                                                                        getIt<Variables>().generalVariables.currentLanguage.requiredQty.toUpperCase(),
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
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        getIt<Variables>().generalVariables.currentLanguage.entryTime.toUpperCase(),
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            color: const Color(0xff8A8D8E)),
                                                                      ),
                                                                      Text(
                                                                        context
                                                                            .read<CatchWeightBloc>()
                                                                            .catchWeightListResponse
                                                                            .items[index]
                                                                            .entryTime,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        getIt<Variables>().generalVariables.currentLanguage.reqBy.toUpperCase(),
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            color: const Color(0xff8A8D8E)),
                                                                      ),
                                                                      Text(
                                                                        context
                                                                            .read<CatchWeightBloc>()
                                                                            .catchWeightListResponse
                                                                            .items[index]
                                                                            .requestedBy,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        getIt<Variables>().generalVariables.currentLanguage.shipToCode.toUpperCase(),
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            color: const Color(0xff8A8D8E)),
                                                                      ),
                                                                      Text(
                                                                        context
                                                                            .read<CatchWeightBloc>()
                                                                            .catchWeightListResponse
                                                                            .items[index]
                                                                            .shipToCode,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
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
                                      child: SmartRefresher(
                                        enablePullDown: true,
                                        enablePullUp: true,
                                        physics: const BouncingScrollPhysics(),
                                        onRefresh: () {
                                          context.read<CatchWeightBloc>().pageIndex = 1;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: false));
                                          updatedRefreshController.refreshCompleted();
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
                                        controller: updatedRefreshController,
                                        onLoading: () {
                                          context.read<CatchWeightBloc>().pageIndex++;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: true));
                                          updatedRefreshController.loadComplete();
                                          setState(() {});
                                        },
                                        child: context.read<CatchWeightBloc>().catchWeightListResponse.items.isEmpty
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
                                                    getIt<Variables>().generalVariables.currentLanguage.catchWeightListIsEmpty,
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
                                                itemCount: context.read<CatchWeightBloc>().catchWeightListResponse.items.length,
                                                shrinkWrap: true,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Container(
                                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                    margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                                              Expanded(
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      "${getIt<Variables>().generalVariables.currentLanguage.customer.toUpperCase()} : ",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                    Expanded(
                                                                      child: Text(
                                                                        context
                                                                            .read<CatchWeightBloc>()
                                                                            .catchWeightListResponse
                                                                            .items[index]
                                                                            .customerName,
                                                                        maxLines: 1,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007AFF)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      reasonSearchFieldController.clear();
                                                                      itemSearchFieldController.clear();
                                                                      context.read<CatchWeightBloc>().selectedReason = "";
                                                                      context.read<CatchWeightBloc>().selectedItem = "";
                                                                      commentsBar.clear();
                                                                      context.read<CatchWeightBloc>().selectedItemId =
                                                                          context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                      context.read<CatchWeightBloc>().chipsContentList.clear();
                                                                      context.read<CatchWeightBloc>().chipsContentList.addAll(List<double>.generate(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .availQtyParticulars
                                                                              .length,
                                                                          (i) => i == 0 || i == 1
                                                                              ? 0.0
                                                                              : double.parse(context
                                                                                  .read<CatchWeightBloc>()
                                                                                  .catchWeightListResponse
                                                                                  .items[index]
                                                                                  .availQtyParticulars[i])));
                                                                      context.read<CatchWeightBloc>().chipsContentList.removeAt(0);
                                                                      context.read<CatchWeightBloc>().chipsContentList.removeAt(0);
                                                                      context.read<CatchWeightBloc>().updateLoader = false;
                                                                      getIt<Variables>().generalVariables.popUpWidget =
                                                                          undoPickedContent(index: index);
                                                                      getIt<Functions>().showAnimatedDialog(
                                                                          context: context, isFromTop: false, isCloseDisabled: false);
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.undo.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              fontWeight: FontWeight.w600,
                                                                              color: const Color(0xff007838)),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 8),
                                                                        ),
                                                                        SvgPicture.asset(
                                                                          "assets/catch_weight/undo.svg",
                                                                          height: getIt<Functions>().getWidgetHeight(height: 14),
                                                                          width: getIt<Functions>().getWidgetHeight(height: 14),
                                                                          fit: BoxFit.fill,
                                                                        )
                                                                      ],
                                                                    ),
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
                                                                              image: DecorationImage(
                                                                                image: NetworkImage(context
                                                                                    .read<CatchWeightBloc>()
                                                                                    .catchWeightListResponse
                                                                                    .items[index]
                                                                                    .itemImage),
                                                                                fit: BoxFit.fill,
                                                                              )),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                        ),
                                                                        Flexible(
                                                                          child: SizedBox(
                                                                            height: getIt<Functions>().getWidgetHeight(height: 41),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Text(
                                                                                    context
                                                                                        .read<CatchWeightBloc>()
                                                                                        .catchWeightListResponse
                                                                                        .items[index]
                                                                                        .itemName,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                        color: const Color(0xff282F3A)),
                                                                                  ),
                                                                                ),
                                                                                IntrinsicHeight(
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.soNumber.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].soNumber}",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                            color: const Color(0xff8A8D8E)),
                                                                                      ),
                                                                                      const VerticalDivider(
                                                                                        color: Color(0xff8A8D8E),
                                                                                      ),
                                                                                      Text(
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].itemCode}",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                            color: const Color(0xff8A8D8E)),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    children: [
                                                                      RichText(
                                                                        text: TextSpan(
                                                                          text: context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .availQty,
                                                                          style: TextStyle(
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                              color: const Color(0xff007838),
                                                                              fontWeight: FontWeight.w600),
                                                                          children: [
                                                                            TextSpan(
                                                                                text:
                                                                                    '/${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].reqQuantity} ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].weightUnit}',
                                                                                style: TextStyle(
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                    color: const Color(0xff007AFF),
                                                                                    fontWeight: FontWeight.w600)),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        getIt<Variables>().generalVariables.currentLanguage.updatedQty.toUpperCase(),
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
                                                              SizedBox(
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
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.entryTime.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .entryTime,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.reqBy.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .requestedBy,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>()
                                                                              .generalVariables
                                                                              .currentLanguage
                                                                              .shipToCode
                                                                              .toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .shipToCode,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .updatedTime,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.updatedBy.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .updatedBy,
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
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
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
                                                                  alignment: WrapAlignment.start,
                                                                  children: List.generate(
                                                                      context
                                                                          .read<CatchWeightBloc>()
                                                                          .catchWeightListResponse
                                                                          .items[index]
                                                                          .availQtyParticulars
                                                                          .length,
                                                                      (idx) => idx == 0
                                                                          ? Container(
                                                                              height: getIt<Functions>().getWidgetHeight(height: 30),
                                                                              width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                              padding: EdgeInsets.only(
                                                                                  right: getIt<Functions>().getWidgetWidth(width: 10)),
                                                                              child: Center(
                                                                                child: SizedBox(
                                                                                  height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                  child: SvgPicture.asset(
                                                                                    "assets/catch_weight/measurement.svg",
                                                                                    height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                    width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                                    fit: BoxFit.fill,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : idx == 1
                                                                              ? Container(
                                                                                  height: getIt<Functions>().getWidgetHeight(height: 30),
                                                                                  padding: EdgeInsets.symmetric(
                                                                                      horizontal: getIt<Functions>().getWidgetWidth(width: 8),
                                                                                      vertical: getIt<Functions>().getWidgetHeight(height: 8)),
                                                                                  child: Text(
                                                                                    "${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].availQtyParticulars[idx]}  : ",
                                                                                    style: TextStyle(
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color(0xff282F3A)),
                                                                                  ),
                                                                                )
                                                                              : Container(
                                                                                  height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                  width: getIt<Functions>().getWidgetWidth(
                                                                                      width: (context
                                                                                                  .read<CatchWeightBloc>()
                                                                                                  .catchWeightListResponse
                                                                                                  .items[index]
                                                                                                  .availQtyParticulars[idx]
                                                                                                  .length *
                                                                                              7) +
                                                                                          30),
                                                                                  padding: EdgeInsets.symmetric(
                                                                                      horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                                                                      vertical: getIt<Functions>().getWidgetHeight(height: 2)),
                                                                                  margin: EdgeInsets.only(
                                                                                      left: getIt<Functions>().getWidgetWidth(width: 6),
                                                                                      top: getIt<Functions>().getWidgetHeight(height: 6)),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                    color: const Color(0xff7AA440),
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      context
                                                                                          .read<CatchWeightBloc>()
                                                                                          .catchWeightListResponse
                                                                                          .items[index]
                                                                                          .availQtyParticulars[idx],
                                                                                      style: TextStyle(
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
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
                                                      ],
                                                    ),
                                                  );
                                                }),
                                      ),
                                    );
                                  case 2:
                                    return Container(
                                      margin: EdgeInsets.only(
                                          left: getIt<Functions>().getWidgetWidth(width: 16),
                                          right: getIt<Functions>().getWidgetWidth(width: 16),
                                          bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                      child: SmartRefresher(
                                        enablePullDown: true,
                                        enablePullUp: true,
                                        physics: const BouncingScrollPhysics(),
                                        onRefresh: () {
                                          context.read<CatchWeightBloc>().pageIndex = 1;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: false));
                                          unavailableRefreshController.refreshCompleted();
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
                                        controller: unavailableRefreshController,
                                        onLoading: () {
                                          context.read<CatchWeightBloc>().pageIndex++;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: true));
                                          unavailableRefreshController.loadComplete();
                                          setState(() {});
                                        },
                                        child: context.read<CatchWeightBloc>().catchWeightListResponse.items.isEmpty
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
                                                    getIt<Variables>().generalVariables.currentLanguage.catchWeightListIsEmpty,
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
                                                itemCount: context.read<CatchWeightBloc>().catchWeightListResponse.items.length,
                                                shrinkWrap: true,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Container(
                                                    height: getIt<Functions>().getWidgetHeight(height: 224),
                                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                    margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                                              Expanded(
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      "${getIt<Variables>().generalVariables.currentLanguage.customer.toUpperCase()} : ",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                    Expanded(
                                                                      child: Text(
                                                                        context
                                                                            .read<CatchWeightBloc>()
                                                                            .catchWeightListResponse
                                                                            .items[index]
                                                                            .customerName,
                                                                        maxLines: 1,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007AFF)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      context.read<CatchWeightBloc>().selectedItemId =
                                                                          context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                      reasonSearchFieldController.clear();
                                                                      itemSearchFieldController.clear();
                                                                      context.read<CatchWeightBloc>().selectedReason = "";
                                                                      context.read<CatchWeightBloc>().selectedItem = "";
                                                                      commentsBar.clear();
                                                                      context.read<CatchWeightBloc>().chipsContentList.clear();
                                                                      context.read<CatchWeightBloc>().textFieldEmpty = false;
                                                                      context.read<CatchWeightBloc>().availableQtyParticularsEmpty = false;
                                                                      context.read<CatchWeightBloc>().updateLoader = false;
                                                                      context.read<CatchWeightBloc>().formatError = false;
                                                                      context.read<CatchWeightBloc>().moreQuantityError = false;
                                                                      context.read<CatchWeightBloc>().isZeroValue = false;
                                                                      getIt<Variables>().generalVariables.popUpWidget =
                                                                          availableContent(index: index, isYetToUpdate: false);
                                                                      getIt<Functions>().showAnimatedDialog(
                                                                          context: context, isFromTop: false, isCloseDisabled: false);
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.available.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              fontWeight: FontWeight.w600,
                                                                              color: const Color(0xff007838)),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 8),
                                                                        ),
                                                                        SvgPicture.asset(
                                                                          "assets/catch_weight/box_tick.svg",
                                                                          height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                          width: getIt<Functions>().getWidgetHeight(height: 16),
                                                                          fit: BoxFit.fill,
                                                                        )
                                                                      ],
                                                                    ),
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
                                                                              image: DecorationImage(
                                                                                image: NetworkImage(context
                                                                                    .read<CatchWeightBloc>()
                                                                                    .catchWeightListResponse
                                                                                    .items[index]
                                                                                    .itemImage),
                                                                                fit: BoxFit.fill,
                                                                              )),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                        ),
                                                                        Flexible(
                                                                          child: SizedBox(
                                                                            height: getIt<Functions>().getWidgetHeight(height: 41),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Text(
                                                                                    context
                                                                                        .read<CatchWeightBloc>()
                                                                                        .catchWeightListResponse
                                                                                        .items[index]
                                                                                        .itemName,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                        color: const Color(0xff282F3A)),
                                                                                  ),
                                                                                ),
                                                                                IntrinsicHeight(
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.soNumber.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].soNumber}",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                            color: const Color(0xff8A8D8E)),
                                                                                      ),
                                                                                      const VerticalDivider(
                                                                                        color: Color(0xff8A8D8E),
                                                                                      ),
                                                                                      Text(
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].itemCode}",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
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
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    children: [
                                                                      Text(
                                                                        "${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].reqQuantity} ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].weightUnit}",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xffF92C38)),
                                                                      ),
                                                                      Text(
                                                                        getIt<Variables>().generalVariables.currentLanguage.reqQty.toUpperCase(),
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
                                                              SizedBox(
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
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.entryTime.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .entryTime,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.reqBy.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .requestedBy,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>()
                                                                              .generalVariables
                                                                              .currentLanguage
                                                                              .shipToCode
                                                                              .toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .shipToCode,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .updatedTime,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.updatedBy.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .updatedBy,
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
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          height: getIt<Functions>().getWidgetHeight(height: 44),
                                                          decoration: const BoxDecoration(
                                                            color: Color(0xffCDE5FF),
                                                            borderRadius:
                                                                BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                                          ),
                                                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Expanded(
                                                                child: RichText(
                                                                  text: TextSpan(
                                                                    text:
                                                                        "${getIt<Variables>().generalVariables.currentLanguage.reason.toUpperCase()}  :  ",
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff282F3A),
                                                                        fontWeight: FontWeight.w500),
                                                                    children: [
                                                                      TextSpan(
                                                                          text: context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .reason
                                                                              .toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xffF92C38),
                                                                              fontWeight: FontWeight.w500)),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Flexible(
                                                                child: RichText(
                                                                  text: TextSpan(
                                                                    text:
                                                                        "${getIt<Variables>().generalVariables.currentLanguage.alternativeItem.toUpperCase()}  :  ",
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff282F3A),
                                                                        fontWeight: FontWeight.w500),
                                                                    children: [
                                                                      TextSpan(
                                                                          text: context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .alternativeItemName
                                                                              .toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff007AFF),
                                                                              fontWeight: FontWeight.w500)),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                      ),
                                    );
                                  case 3:
                                    return Container(
                                      margin: EdgeInsets.only(
                                          left: getIt<Functions>().getWidgetWidth(width: 16),
                                          right: getIt<Functions>().getWidgetWidth(width: 16),
                                          bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                      child: SmartRefresher(
                                        enablePullDown: true,
                                        enablePullUp: true,
                                        physics: const BouncingScrollPhysics(),
                                        onRefresh: () {
                                          context.read<CatchWeightBloc>().pageIndex = 1;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: false));
                                          completedRefreshController.refreshCompleted();
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
                                        controller: completedRefreshController,
                                        onLoading: () {
                                          context.read<CatchWeightBloc>().pageIndex++;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: true));
                                          completedRefreshController.loadComplete();
                                          setState(() {});
                                        },
                                        child: context.read<CatchWeightBloc>().catchWeightListResponse.items.isEmpty
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
                                                    getIt<Variables>().generalVariables.currentLanguage.catchWeightListIsEmpty,
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
                                                itemCount: context.read<CatchWeightBloc>().catchWeightListResponse.items.length,
                                                shrinkWrap: true,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Container(
                                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                    margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                "${getIt<Variables>().generalVariables.currentLanguage.customer.toUpperCase()} : ",
                                                                style: TextStyle(
                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                    fontWeight: FontWeight.w600,
                                                                    color: const Color(0xff282F3A)),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  context.read<CatchWeightBloc>().catchWeightListResponse.items[index].customerName,
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      fontWeight: FontWeight.w600,
                                                                      color: const Color(0xff007AFF)),
                                                                ),
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
                                                                              image: DecorationImage(
                                                                                image: NetworkImage(context
                                                                                    .read<CatchWeightBloc>()
                                                                                    .catchWeightListResponse
                                                                                    .items[index]
                                                                                    .itemImage),
                                                                                fit: BoxFit.fill,
                                                                              )),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                        ),
                                                                        Flexible(
                                                                          child: SizedBox(
                                                                            height: getIt<Functions>().getWidgetHeight(height: 41),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Text(
                                                                                    context
                                                                                        .read<CatchWeightBloc>()
                                                                                        .catchWeightListResponse
                                                                                        .items[index]
                                                                                        .itemName,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                        color: const Color(0xff282F3A)),
                                                                                  ),
                                                                                ),
                                                                                IntrinsicHeight(
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.soNumber.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].soNumber}",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                            color: const Color(0xff8A8D8E)),
                                                                                      ),
                                                                                      const VerticalDivider(
                                                                                        color: Color(0xff8A8D8E),
                                                                                      ),
                                                                                      Text(
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].itemCode}",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
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
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    children: [
                                                                      RichText(
                                                                        text: TextSpan(
                                                                          text: context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .availQty,
                                                                          style: TextStyle(
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                              color: const Color(0xff007838),
                                                                              fontWeight: FontWeight.w600),
                                                                          children: [
                                                                            TextSpan(
                                                                                text:
                                                                                    '/${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].reqQuantity} ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].weightUnit}',
                                                                                style: TextStyle(
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                    color: const Color(0xff007AFF),
                                                                                    fontWeight: FontWeight.w600)),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        getIt<Variables>().generalVariables.currentLanguage.updatedQty.toUpperCase(),
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
                                                              SizedBox(
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
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.entryTime.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .entryTime,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.reqBy.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .requestedBy,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>()
                                                                              .generalVariables
                                                                              .currentLanguage
                                                                              .shipToCode
                                                                              .toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .shipToCode,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .updatedTime,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.updatedBy.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .updatedBy,
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
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
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
                                                                      context
                                                                          .read<CatchWeightBloc>()
                                                                          .catchWeightListResponse
                                                                          .items[index]
                                                                          .availQtyParticulars
                                                                          .length,
                                                                      (idx) => idx == 0
                                                                          ? Container(
                                                                              height: getIt<Functions>().getWidgetHeight(height: 30),
                                                                              width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                              padding: EdgeInsets.only(
                                                                                  right: getIt<Functions>().getWidgetWidth(width: 10)),
                                                                              child: Center(
                                                                                child: SizedBox(
                                                                                  height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                  child: SvgPicture.asset(
                                                                                    "assets/catch_weight/measurement.svg",
                                                                                    height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                    width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                                    fit: BoxFit.fill,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : idx == 1
                                                                              ? Container(
                                                                                  height: getIt<Functions>().getWidgetHeight(height: 30),
                                                                                  padding: EdgeInsets.symmetric(
                                                                                      horizontal: getIt<Functions>().getWidgetWidth(width: 8),
                                                                                      vertical: getIt<Functions>().getWidgetHeight(height: 8)),
                                                                                  child: Text(
                                                                                    "${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].availQtyParticulars[idx]}  : ",
                                                                                    style: TextStyle(
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color(0xff282F3A)),
                                                                                  ),
                                                                                )
                                                                              : Container(
                                                                                  height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                  width: getIt<Functions>().getWidgetWidth(
                                                                                      width: (context
                                                                                                  .read<CatchWeightBloc>()
                                                                                                  .catchWeightListResponse
                                                                                                  .items[index]
                                                                                                  .availQtyParticulars[idx]
                                                                                                  .length *
                                                                                              7) +
                                                                                          30),
                                                                                  padding: EdgeInsets.symmetric(
                                                                                      horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                                                                      vertical: getIt<Functions>().getWidgetHeight(height: 2)),
                                                                                  margin: EdgeInsets.only(
                                                                                      left: getIt<Functions>().getWidgetWidth(width: 6),
                                                                                      top: getIt<Functions>().getWidgetHeight(height: 6)),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                    color: const Color(0xff7AA440),
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      context
                                                                                          .read<CatchWeightBloc>()
                                                                                          .catchWeightListResponse
                                                                                          .items[index]
                                                                                          .availQtyParticulars[idx],
                                                                                      style: TextStyle(
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
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
                                                      ],
                                                    ),
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
                                      child: SmartRefresher(
                                        enablePullDown: true,
                                        enablePullUp: true,
                                        physics: const BouncingScrollPhysics(),
                                        onRefresh: () {
                                          context.read<CatchWeightBloc>().pageIndex = 1;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: false));
                                          yetToUpdateRefreshController.refreshCompleted();
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
                                        controller: yetToUpdateRefreshController,
                                        onLoading: () {
                                          context.read<CatchWeightBloc>().pageIndex++;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: true));
                                          yetToUpdateRefreshController.loadComplete();
                                          setState(() {});
                                        },
                                        child: context.read<CatchWeightBloc>().catchWeightListResponse.items.isEmpty
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
                                                    getIt<Variables>().generalVariables.currentLanguage.catchWeightListIsEmpty,
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
                                                itemCount: context.read<CatchWeightBloc>().catchWeightListResponse.items.length,
                                                shrinkWrap: true,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Container(
                                                    height: getIt<Functions>().getWidgetHeight(height: 180),
                                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                    margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                                              Expanded(
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      "${getIt<Variables>().generalVariables.currentLanguage.customer.toUpperCase()} : ",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                    Expanded(
                                                                      child: Text(
                                                                        context
                                                                            .read<CatchWeightBloc>()
                                                                            .catchWeightListResponse
                                                                            .items[index]
                                                                            .customerName,
                                                                        maxLines: 1,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007AFF)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              IntrinsicHeight(
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap: () {
                                                                        context.read<CatchWeightBloc>().selectedItemId =
                                                                            context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                        reasonSearchFieldController.clear();
                                                                        itemSearchFieldController.clear();
                                                                        context.read<CatchWeightBloc>().selectedReason = "";
                                                                        context.read<CatchWeightBloc>().selectedItem = "";
                                                                        commentsBar.clear();
                                                                        context.read<CatchWeightBloc>().updateLoader = false;
                                                                        context.read<CatchWeightBloc>().commentTextEmpty = false;
                                                                        context.read<CatchWeightBloc>().selectedReasonEmpty = false;
                                                                        context.read<CatchWeightBloc>().selectItemEmpty = false;
                                                                        context.read<CatchWeightBloc>().hideKeyBoardReason = false;
                                                                        context.read<CatchWeightBloc>().hideKeyBoardItem = false;
                                                                        getIt<Variables>().generalVariables.popUpWidget =
                                                                            unavailableContent(index: index);
                                                                        getIt<Functions>().showAnimatedDialog(
                                                                            context: context, isFromTop: false, isCloseDisabled: false);
                                                                      },
                                                                      child: Text(
                                                                        getIt<Variables>().generalVariables.currentLanguage.unavailable.toUpperCase(),
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xffF92C38)),
                                                                      ),
                                                                    ),
                                                                    const VerticalDivider(
                                                                      color: Color(0xff8A8D8E),
                                                                    ),
                                                                    InkWell(
                                                                      onTap: () {
                                                                        context.read<CatchWeightBloc>().selectedItemId =
                                                                            context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                        reasonSearchFieldController.clear();
                                                                        itemSearchFieldController.clear();
                                                                        context.read<CatchWeightBloc>().selectedReason = "";
                                                                        context.read<CatchWeightBloc>().selectedItem = "";
                                                                        commentsBar.clear();
                                                                        context.read<CatchWeightBloc>().chipsContentList.clear();
                                                                        context.read<CatchWeightBloc>().textFieldEmpty = false;
                                                                        context.read<CatchWeightBloc>().availableQtyParticularsEmpty = false;
                                                                        context.read<CatchWeightBloc>().updateLoader = false;
                                                                        context.read<CatchWeightBloc>().formatError = false;
                                                                        context.read<CatchWeightBloc>().moreQuantityError = false;
                                                                        context.read<CatchWeightBloc>().isZeroValue = false;
                                                                        getIt<Variables>().generalVariables.popUpWidget =
                                                                            availableContent(index: index, isYetToUpdate: true);
                                                                        getIt<Functions>().showAnimatedDialog(
                                                                            context: context, isFromTop: false, isCloseDisabled: false);
                                                                      },
                                                                      child: Text(
                                                                        getIt<Variables>().generalVariables.currentLanguage.available.toUpperCase(),
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007838)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
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
                                                                              image: DecorationImage(
                                                                                image: NetworkImage(context
                                                                                    .read<CatchWeightBloc>()
                                                                                    .catchWeightListResponse
                                                                                    .items[index]
                                                                                    .itemImage),
                                                                                fit: BoxFit.fill,
                                                                              )),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                        ),
                                                                        Flexible(
                                                                          child: SizedBox(
                                                                            height: getIt<Functions>().getWidgetHeight(height: 41),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                SingleChildScrollView(
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  child: Text(
                                                                                    context
                                                                                        .read<CatchWeightBloc>()
                                                                                        .catchWeightListResponse
                                                                                        .items[index]
                                                                                        .itemName,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                        color: const Color(0xff282F3A)),
                                                                                  ),
                                                                                ),
                                                                                IntrinsicHeight(
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.soNumber.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].soNumber}",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                            color: const Color(0xff8A8D8E)),
                                                                                      ),
                                                                                      const VerticalDivider(
                                                                                        color: Color(0xff8A8D8E),
                                                                                      ),
                                                                                      Text(
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].itemCode}",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                            color: const Color(0xff8A8D8E)),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    children: [
                                                                      Text(
                                                                        "${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].reqQuantity} ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].weightUnit}",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007AFF)),
                                                                      ),
                                                                      Text(
                                                                        getIt<Variables>().generalVariables.currentLanguage.requiredQty.toUpperCase(),
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
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        getIt<Variables>().generalVariables.currentLanguage.entryTime.toUpperCase(),
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            color: const Color(0xff8A8D8E)),
                                                                      ),
                                                                      Text(
                                                                        context
                                                                            .read<CatchWeightBloc>()
                                                                            .catchWeightListResponse
                                                                            .items[index]
                                                                            .entryTime,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        getIt<Variables>().generalVariables.currentLanguage.reqBy.toUpperCase(),
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            color: const Color(0xff8A8D8E)),
                                                                      ),
                                                                      Text(
                                                                        context
                                                                            .read<CatchWeightBloc>()
                                                                            .catchWeightListResponse
                                                                            .items[index]
                                                                            .requestedBy,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        getIt<Variables>().generalVariables.currentLanguage.shipToCode.toUpperCase(),
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            color: const Color(0xff8A8D8E)),
                                                                      ),
                                                                      Text(
                                                                        context
                                                                            .read<CatchWeightBloc>()
                                                                            .catchWeightListResponse
                                                                            .items[index]
                                                                            .shipToCode,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
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
                                                  );
                                                }),
                                      ),
                                    );
                                }
                              } else if (catchWeight is CatchWeightLoading) {
                                switch (context.read<CatchWeightBloc>().tabIndex) {
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
                                            itemCount: 1,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Container(
                                                height: getIt<Functions>().getWidgetHeight(height: 180),
                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: getIt<Functions>().getWidgetHeight(height: 38),
                                                      decoration: const BoxDecoration(
                                                        color: Color(0xffE3E7EA),
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
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
                                                                "${getIt<Variables>().generalVariables.currentLanguage.customer.toUpperCase()} : ",
                                                                style: TextStyle(
                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                    fontWeight: FontWeight.w600,
                                                                    color: const Color(0xff282F3A)),
                                                              ),
                                                              Text(
                                                                "ONE MORE NIGHT HOSTEL",
                                                                style: TextStyle(
                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                    fontWeight: FontWeight.w600,
                                                                    color: const Color(0xff007AFF)),
                                                              ),
                                                            ],
                                                          ),
                                                          IntrinsicHeight(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    context.read<CatchWeightBloc>().selectedItemId =
                                                                        context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                    reasonSearchFieldController.clear();
                                                                    itemSearchFieldController.clear();
                                                                    context.read<CatchWeightBloc>().selectedReason = "";
                                                                    context.read<CatchWeightBloc>().selectedItem = "";
                                                                    commentsBar.clear();
                                                                    context.read<CatchWeightBloc>().updateLoader = false;
                                                                    context.read<CatchWeightBloc>().commentTextEmpty = false;
                                                                    context.read<CatchWeightBloc>().selectedReasonEmpty = false;
                                                                    context.read<CatchWeightBloc>().selectItemEmpty = false;
                                                                    context.read<CatchWeightBloc>().hideKeyBoardReason = false;
                                                                    context.read<CatchWeightBloc>().hideKeyBoardItem = false;
                                                                    getIt<Variables>().generalVariables.popUpWidget =
                                                                        unavailableContent(index: index);
                                                                    getIt<Functions>().showAnimatedDialog(
                                                                        context: context, isFromTop: false, isCloseDisabled: false);
                                                                  },
                                                                  child: Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.unavailable.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xffF92C38)),
                                                                  ),
                                                                ),
                                                                const VerticalDivider(
                                                                  color: Color(0xff8A8D8E),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    context.read<CatchWeightBloc>().selectedItemId =
                                                                        context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                    reasonSearchFieldController.clear();
                                                                    itemSearchFieldController.clear();
                                                                    context.read<CatchWeightBloc>().selectedReason = "";
                                                                    context.read<CatchWeightBloc>().selectedItem = "";
                                                                    commentsBar.clear();
                                                                    context.read<CatchWeightBloc>().chipsContentList.clear();
                                                                    context.read<CatchWeightBloc>().textFieldEmpty = false;
                                                                    context.read<CatchWeightBloc>().availableQtyParticularsEmpty = false;
                                                                    context.read<CatchWeightBloc>().updateLoader = false;
                                                                    context.read<CatchWeightBloc>().formatError = false;
                                                                    context.read<CatchWeightBloc>().moreQuantityError = false;
                                                                    context.read<CatchWeightBloc>().isZeroValue = false;
                                                                    getIt<Variables>().generalVariables.popUpWidget =
                                                                        availableContent(index: index, isYetToUpdate: true);
                                                                    getIt<Functions>().showAnimatedDialog(
                                                                        context: context, isFromTop: false, isCloseDisabled: false);
                                                                  },
                                                                  child: Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.available.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff007838)),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
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
                                                                  SizedBox(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "Mutton Leg Boneless - Aus Origin - KG",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                        IntrinsicHeight(
                                                                          child: Row(
                                                                            children: [
                                                                              Text(
                                                                                "${getIt<Variables>().generalVariables.currentLanguage.soNumber.toUpperCase()} : 196045",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              const VerticalDivider(
                                                                                color: Color(0xff8A8D8E),
                                                                              ),
                                                                              Text(
                                                                                "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : MB002",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
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
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: [
                                                                  Text(
                                                                    "41 KG",
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff007AFF)),
                                                                  ),
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.requiredQty.toUpperCase(),
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
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.entryTime.toUpperCase(),
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
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 30),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.reqBy.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff8A8D8E)),
                                                                  ),
                                                                  Text(
                                                                    "Ava Johnson",
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 30),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.shipToCode.toUpperCase(),
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
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
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
                                            itemCount: 1,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Container(
                                                height: getIt<Functions>().getWidgetHeight(height: 222),
                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: getIt<Functions>().getWidgetHeight(height: 38),
                                                      decoration: const BoxDecoration(
                                                        color: Color(0xffE3E7EA),
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
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
                                                                "${getIt<Variables>().generalVariables.currentLanguage.customer.toUpperCase()} : ",
                                                                style: TextStyle(
                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                    fontWeight: FontWeight.w600,
                                                                    color: const Color(0xff282F3A)),
                                                              ),
                                                              Text(
                                                                "ONE MORE NIGHT HOSTEL",
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
                                                              InkWell(
                                                                onTap: () {
                                                                  reasonSearchFieldController.clear();
                                                                  itemSearchFieldController.clear();
                                                                  context.read<CatchWeightBloc>().selectedReason = "";
                                                                  context.read<CatchWeightBloc>().selectedItem = "";
                                                                  context.read<CatchWeightBloc>().selectedItemId =
                                                                      context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                  context.read<CatchWeightBloc>().chipsContentList.clear();
                                                                  context.read<CatchWeightBloc>().chipsContentList.addAll(List<double>.generate(
                                                                      context
                                                                          .read<CatchWeightBloc>()
                                                                          .catchWeightListResponse
                                                                          .items[index]
                                                                          .availQtyParticulars
                                                                          .length,
                                                                      (i) => i == 0 || i == 1
                                                                          ? 0.0
                                                                          : double.parse(context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .availQtyParticulars[i])));
                                                                  context.read<CatchWeightBloc>().chipsContentList.removeAt(0);
                                                                  context.read<CatchWeightBloc>().chipsContentList.removeAt(0);
                                                                  commentsBar.clear();
                                                                  context.read<CatchWeightBloc>().updateLoader = false;
                                                                  getIt<Variables>().generalVariables.popUpWidget = undoPickedContent(index: index);
                                                                  getIt<Functions>()
                                                                      .showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.undo.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xff007838)),
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 8),
                                                                    ),
                                                                    SvgPicture.asset(
                                                                      "assets/catch_weight/undo.svg",
                                                                      height: getIt<Functions>().getWidgetHeight(height: 14),
                                                                      width: getIt<Functions>().getWidgetHeight(height: 14),
                                                                      fit: BoxFit.fill,
                                                                    )
                                                                  ],
                                                                ),
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
                                                                  SizedBox(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "Mutton Leg Boneless - Aus Origin - KG",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                        IntrinsicHeight(
                                                                          child: Row(
                                                                            children: [
                                                                              Text(
                                                                                "${getIt<Variables>().generalVariables.currentLanguage.soNumber.toUpperCase()} : 196045",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              const VerticalDivider(
                                                                                color: Color(0xff8A8D8E),
                                                                              ),
                                                                              Text(
                                                                                "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : MB002",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
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
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: [
                                                                  RichText(
                                                                    text: TextSpan(
                                                                      text: "40.25",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                          color: const Color(0xff007838),
                                                                          fontWeight: FontWeight.w600),
                                                                      children: [
                                                                        TextSpan(
                                                                            text: '/41 KG',
                                                                            style: TextStyle(
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                color: const Color(0xff007AFF),
                                                                                fontWeight: FontWeight.w600)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.updatedQty.toUpperCase(),
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
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.entryTime.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff8A8D8E)),
                                                                  ),
                                                                  Text(
                                                                    "19/05/24, 11:37 AM",
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 30),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.reqBy.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff8A8D8E)),
                                                                  ),
                                                                  Text(
                                                                    "Ava Johnson",
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 30),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.shipToCode.toUpperCase(),
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
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 30),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.updatedTime.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff8A8D8E)),
                                                                  ),
                                                                  Text(
                                                                    "19/05/24, 11:37 AM",
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 30),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.updatedBy.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff8A8D8E)),
                                                                  ),
                                                                  Text(
                                                                    "John Mathew",
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            decoration: const BoxDecoration(
                                                              color: Color(0xffCDE5FF),
                                                              borderRadius:
                                                                  BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                                            ),
                                                            padding: EdgeInsets.only(
                                                                left: getIt<Functions>().getWidgetWidth(width: 12),
                                                                top: getIt<Functions>().getWidgetHeight(height: 8),
                                                                bottom: getIt<Functions>().getWidgetHeight(height: 8)),
                                                            child: Wrap(
                                                              children: List.generate(
                                                                  1,
                                                                  (idx) => idx == 0
                                                                      ? Skeleton.shade(
                                                                          child: Container(
                                                                            height: getIt<Functions>().getWidgetHeight(height: 30),
                                                                            width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                            padding:
                                                                                EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 10)),
                                                                            child: Center(
                                                                              child: SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                child: SvgPicture.asset(
                                                                                  "assets/catch_weight/measurement.svg",
                                                                                  height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                  width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                                  fit: BoxFit.fill,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : idx == 1
                                                                          ? Container(
                                                                              height: getIt<Functions>().getWidgetHeight(height: 30),
                                                                              width: getIt<Functions>().getWidgetWidth(width: 75),
                                                                              padding: EdgeInsets.symmetric(
                                                                                  horizontal: getIt<Functions>().getWidgetWidth(width: 8)),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "idx KG  : ",
                                                                                  style: TextStyle(
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                      fontWeight: FontWeight.w600,
                                                                                      color: const Color(0xff282F3A)),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : Container(
                                                                              height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                              padding: EdgeInsets.symmetric(
                                                                                  horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                                                                  vertical: getIt<Functions>().getWidgetWidth(width: 2)),
                                                                              margin: EdgeInsets.only(
                                                                                  left: getIt<Functions>().getWidgetWidth(width: 6),
                                                                                  top: getIt<Functions>().getWidgetHeight(height: 6)),
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "22.65",
                                                                                  style: TextStyle(
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11),
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
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                    );
                                  case 2:
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
                                            itemCount: 1,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Container(
                                                height: getIt<Functions>().getWidgetHeight(height: 224),
                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: getIt<Functions>().getWidgetHeight(height: 38),
                                                      decoration: const BoxDecoration(
                                                        color: Color(0xffE3E7EA),
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
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
                                                                "${getIt<Variables>().generalVariables.currentLanguage.customer.toUpperCase()} : ",
                                                                style: TextStyle(
                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                    fontWeight: FontWeight.w600,
                                                                    color: const Color(0xff282F3A)),
                                                              ),
                                                              Text(
                                                                "ONE MORE NIGHT HOSTEL",
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
                                                              InkWell(
                                                                onTap: () {
                                                                  context.read<CatchWeightBloc>().selectedItemId =
                                                                      context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                  reasonSearchFieldController.clear();
                                                                  itemSearchFieldController.clear();
                                                                  context.read<CatchWeightBloc>().selectedReason = "";
                                                                  context.read<CatchWeightBloc>().selectedItem = "";
                                                                  commentsBar.clear();
                                                                  context.read<CatchWeightBloc>().chipsContentList.clear();
                                                                  context.read<CatchWeightBloc>().textFieldEmpty = false;
                                                                  context.read<CatchWeightBloc>().availableQtyParticularsEmpty = false;
                                                                  context.read<CatchWeightBloc>().updateLoader = false;
                                                                  context.read<CatchWeightBloc>().formatError = false;
                                                                  context.read<CatchWeightBloc>().moreQuantityError = false;
                                                                  context.read<CatchWeightBloc>().isZeroValue = false;
                                                                  getIt<Variables>().generalVariables.popUpWidget =
                                                                      availableContent(index: index, isYetToUpdate: false);
                                                                  getIt<Functions>()
                                                                      .showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.available.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xff007838)),
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 8),
                                                                    ),
                                                                    SvgPicture.asset(
                                                                      "assets/catch_weight/box_tick.svg",
                                                                      height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                      width: getIt<Functions>().getWidgetHeight(height: 16),
                                                                      fit: BoxFit.fill,
                                                                    )
                                                                  ],
                                                                ),
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
                                                                  SizedBox(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "Mutton Leg Boneless - Aus Origin - KG",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                        IntrinsicHeight(
                                                                          child: Row(
                                                                            children: [
                                                                              Text(
                                                                                "${getIt<Variables>().generalVariables.currentLanguage.soNumber.toUpperCase()} : 196045",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              const VerticalDivider(
                                                                                color: Color(0xff8A8D8E),
                                                                              ),
                                                                              Text(
                                                                                "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : MB002",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
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
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: [
                                                                  Text(
                                                                    "41 KG",
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xffF92C38)),
                                                                  ),
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.reqQty.toUpperCase(),
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
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.entryTime.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff8A8D8E)),
                                                                  ),
                                                                  Text(
                                                                    "19/05/24, 11:37 AM",
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 30),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.reqBy.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff8A8D8E)),
                                                                  ),
                                                                  Text(
                                                                    "Ava Johnson",
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 30),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.shipToCode.toUpperCase(),
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
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 30),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.updatedTime.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff8A8D8E)),
                                                                  ),
                                                                  Text(
                                                                    "19/05/24, 11:37 AM",
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 30),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.updatedBy.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff8A8D8E)),
                                                                  ),
                                                                  Text(
                                                                    "John Mathew",
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      height: getIt<Functions>().getWidgetHeight(height: 44),
                                                      decoration: const BoxDecoration(
                                                        color: Color(0xffCDE5FF),
                                                        borderRadius:
                                                            BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                                      ),
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  "${getIt<Variables>().generalVariables.currentLanguage.reason.toUpperCase()}  :  ",
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                  color: const Color(0xff282F3A),
                                                                  fontWeight: FontWeight.w500),
                                                              children: [
                                                                TextSpan(
                                                                    text: 'EXPIRED STOCKS',
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xffF92C38),
                                                                        fontWeight: FontWeight.w500)),
                                                              ],
                                                            ),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  "${getIt<Variables>().generalVariables.currentLanguage.alternativeItem.toUpperCase()}  :  ",
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                  color: const Color(0xff282F3A),
                                                                  fontWeight: FontWeight.w500),
                                                              children: [
                                                                TextSpan(
                                                                    text: 'Lamb Leg Boneless - AUs Origin - Kg',
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff007AFF),
                                                                        fontWeight: FontWeight.w500)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                    );
                                  case 3:
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
                                            itemCount: 1,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Container(
                                                height: getIt<Functions>().getWidgetHeight(height: 222),
                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: getIt<Functions>().getWidgetHeight(height: 38),
                                                      decoration: const BoxDecoration(
                                                        color: Color(0xffE3E7EA),
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                      ),
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            "${getIt<Variables>().generalVariables.currentLanguage.customer.toUpperCase()} : ",
                                                            style: TextStyle(
                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                fontWeight: FontWeight.w600,
                                                                color: const Color(0xff282F3A)),
                                                          ),
                                                          Text(
                                                            "ONE MORE NIGHT HOSTEL",
                                                            style: TextStyle(
                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                fontWeight: FontWeight.w600,
                                                                color: const Color(0xff007AFF)),
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
                                                                  SizedBox(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "Mutton Leg Boneless - Aus Origin - KG",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                        IntrinsicHeight(
                                                                          child: Row(
                                                                            children: [
                                                                              Text(
                                                                                "${getIt<Variables>().generalVariables.currentLanguage.soNumber.toUpperCase()} : 196045",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              const VerticalDivider(
                                                                                color: Color(0xff8A8D8E),
                                                                              ),
                                                                              Text(
                                                                                "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : MB002",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
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
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: [
                                                                  RichText(
                                                                    text: TextSpan(
                                                                      text: "40.25",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                          color: const Color(0xff007838),
                                                                          fontWeight: FontWeight.w600),
                                                                      children: [
                                                                        TextSpan(
                                                                            text: '/41 KG',
                                                                            style: TextStyle(
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                                color: const Color(0xff007AFF),
                                                                                fontWeight: FontWeight.w600)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.updatedQty.toUpperCase(),
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
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.entryTime.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff8A8D8E)),
                                                                  ),
                                                                  Text(
                                                                    "19/05/24, 11:37 AM",
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 30),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.reqBy.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff8A8D8E)),
                                                                  ),
                                                                  Text(
                                                                    "Ava Johnson",
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 30),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.shipToCode.toUpperCase(),
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
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 30),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.updatedTime.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff8A8D8E)),
                                                                  ),
                                                                  Text(
                                                                    "19/05/24, 11:37 AM",
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 30),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.updatedBy.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff8A8D8E)),
                                                                  ),
                                                                  Text(
                                                                    "John Mathew",
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            decoration: const BoxDecoration(
                                                              color: Color(0xffCDE5FF),
                                                              borderRadius:
                                                                  BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                                            ),
                                                            padding: EdgeInsets.only(
                                                                left: getIt<Functions>().getWidgetWidth(width: 12),
                                                                top: getIt<Functions>().getWidgetHeight(height: 8),
                                                                bottom: getIt<Functions>().getWidgetHeight(height: 8)),
                                                            child: Wrap(
                                                              children: List.generate(
                                                                  1,
                                                                  (idx) => idx == 0
                                                                      ? Skeleton.shade(
                                                                          child: Container(
                                                                            height: getIt<Functions>().getWidgetHeight(height: 30),
                                                                            width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                            padding:
                                                                                EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 10)),
                                                                            child: Center(
                                                                              child: SizedBox(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                child: SvgPicture.asset(
                                                                                  "assets/catch_weight/measurement.svg",
                                                                                  height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                  width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                                  fit: BoxFit.fill,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : idx == 1
                                                                          ? Container(
                                                                              height: getIt<Functions>().getWidgetHeight(height: 30),
                                                                              width: getIt<Functions>().getWidgetWidth(width: 75),
                                                                              padding: EdgeInsets.symmetric(
                                                                                  horizontal: getIt<Functions>().getWidgetWidth(width: 8)),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "idx KG  : ",
                                                                                  style: TextStyle(
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                      fontWeight: FontWeight.w600,
                                                                                      color: const Color(0xff282F3A)),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : Container(
                                                                              height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                              padding: EdgeInsets.symmetric(
                                                                                  horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                                                                  vertical: getIt<Functions>().getWidgetHeight(height: 2)),
                                                                              margin: EdgeInsets.only(
                                                                                  left: getIt<Functions>().getWidgetWidth(width: 6),
                                                                                  top: getIt<Functions>().getWidgetHeight(height: 6)),
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "22.65",
                                                                                  style: TextStyle(
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11),
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
                                                  ],
                                                ),
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
                                            itemCount: 1,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Container(
                                                height: getIt<Functions>().getWidgetHeight(height: 180),
                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: getIt<Functions>().getWidgetHeight(height: 38),
                                                      decoration: const BoxDecoration(
                                                        color: Color(0xffE3E7EA),
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
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
                                                                "${getIt<Variables>().generalVariables.currentLanguage.customer.toUpperCase()} : ",
                                                                style: TextStyle(
                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                    fontWeight: FontWeight.w600,
                                                                    color: const Color(0xff282F3A)),
                                                              ),
                                                              Text(
                                                                "ONE MORE NIGHT HOSTEL",
                                                                style: TextStyle(
                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                    fontWeight: FontWeight.w600,
                                                                    color: const Color(0xff007AFF)),
                                                              ),
                                                            ],
                                                          ),
                                                          IntrinsicHeight(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    context.read<CatchWeightBloc>().selectedItemId =
                                                                        context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                    reasonSearchFieldController.clear();
                                                                    itemSearchFieldController.clear();
                                                                    context.read<CatchWeightBloc>().selectedReason = "";
                                                                    context.read<CatchWeightBloc>().selectedItem = "";
                                                                    commentsBar.clear();
                                                                    context.read<CatchWeightBloc>().updateLoader = false;
                                                                    context.read<CatchWeightBloc>().commentTextEmpty = false;
                                                                    context.read<CatchWeightBloc>().selectedReasonEmpty = false;
                                                                    context.read<CatchWeightBloc>().selectItemEmpty = false;
                                                                    context.read<CatchWeightBloc>().hideKeyBoardReason = false;
                                                                    context.read<CatchWeightBloc>().hideKeyBoardItem = false;
                                                                    getIt<Variables>().generalVariables.popUpWidget =
                                                                        unavailableContent(index: index);
                                                                    getIt<Functions>().showAnimatedDialog(
                                                                        context: context, isFromTop: false, isCloseDisabled: false);
                                                                  },
                                                                  child: Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.unavailable.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xffF92C38)),
                                                                  ),
                                                                ),
                                                                const VerticalDivider(
                                                                  color: Color(0xff8A8D8E),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    context.read<CatchWeightBloc>().selectedItemId =
                                                                        context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                    reasonSearchFieldController.clear();
                                                                    itemSearchFieldController.clear();
                                                                    context.read<CatchWeightBloc>().selectedReason = "";
                                                                    context.read<CatchWeightBloc>().selectedItem = "";
                                                                    commentsBar.clear();
                                                                    context.read<CatchWeightBloc>().chipsContentList.clear();
                                                                    context.read<CatchWeightBloc>().textFieldEmpty = false;
                                                                    context.read<CatchWeightBloc>().availableQtyParticularsEmpty = false;
                                                                    context.read<CatchWeightBloc>().updateLoader = false;
                                                                    context.read<CatchWeightBloc>().formatError = false;
                                                                    context.read<CatchWeightBloc>().moreQuantityError = false;
                                                                    context.read<CatchWeightBloc>().isZeroValue = false;
                                                                    getIt<Variables>().generalVariables.popUpWidget =
                                                                        availableContent(index: index, isYetToUpdate: true);
                                                                    getIt<Functions>().showAnimatedDialog(
                                                                        context: context, isFromTop: false, isCloseDisabled: false);
                                                                  },
                                                                  child: Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.available.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff007838)),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
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
                                                                  SizedBox(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "Mutton Leg Boneless - Aus Origin - KG",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                        IntrinsicHeight(
                                                                          child: Row(
                                                                            children: [
                                                                              Text(
                                                                                "${getIt<Variables>().generalVariables.currentLanguage.soNumber.toUpperCase()} : 196045",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              const VerticalDivider(
                                                                                color: Color(0xff8A8D8E),
                                                                              ),
                                                                              Text(
                                                                                "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : MB002",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
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
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: [
                                                                  Text(
                                                                    "41 KG",
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff007AFF)),
                                                                  ),
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.requiredQty.toUpperCase(),
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
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.entryTime.toUpperCase(),
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
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 30),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.reqBy.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff8A8D8E)),
                                                                  ),
                                                                  Text(
                                                                    "Ava Johnson",
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xff282F3A)),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 30),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.shipToCode.toUpperCase(),
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
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
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
                  BlocBuilder<CatchWeightBloc, CatchWeightState>(
                    builder: (BuildContext context, CatchWeightState catchWeight) {
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
                                  icon: const Icon(Icons.menu)),
                              titleSpacing: 0,
                              title: AnimatedCrossFade(
                                firstChild: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        getIt<Variables>().generalVariables.currentLanguage.catchWeight,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 26),
                                            color: const Color(0xff282F3A)),
                                      ),
                                    ),
                                  ],
                                ),
                                secondChild: textBars(controller: searchBar),
                                crossFadeState:
                                    context.read<CatchWeightBloc>().searchBarEnabled ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                duration: const Duration(milliseconds: 100),
                              ),
                              actions: [
                                IconButton(
                                  splashColor: Colors.transparent,
                                  splashRadius: 0.1,
                                  padding: EdgeInsets.zero,
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: catchWeight is CatchWeightLoading
                                      ? () {}
                                      : () {
                                          context.read<CatchWeightBloc>().searchBarEnabled = !context.read<CatchWeightBloc>().searchBarEnabled;
                                          setState(() {});
                                        },
                                  icon: SvgPicture.asset(
                                    "assets/catch_weight/action_search.svg",
                                    height: getIt<Functions>().getWidgetHeight(height: 34),
                                    width: getIt<Functions>().getWidgetWidth(width: 34),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                IconButton(
                                  splashColor: Colors.transparent,
                                  splashRadius: 0.1,
                                  padding: EdgeInsets.zero,
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: catchWeight is CatchWeightLoading
                                      ? () {}
                                      : () {
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
                        BlocBuilder<CatchWeightBloc, CatchWeightState>(
                          builder: (BuildContext context, CatchWeightState catchWeight) {
                            return Container(
                              height: getIt<Functions>().getWidgetHeight(height: 50),
                              margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                              decoration: const BoxDecoration(color: Colors.white),
                              child: TabBar(
                                indicatorWeight: 0,
                                controller: tabController,
                                indicator: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: const Color(0xff007AFF)),
                                labelStyle: TextStyle(
                                    color: Colors.white, fontSize: getIt<Functions>().getTextSize(fontSize: 11), fontWeight: FontWeight.w600),
                                unselectedLabelStyle: TextStyle(
                                    color: const Color(0xff6F6F6F),
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                    fontWeight: FontWeight.w600),
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
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(getIt<Variables>().generalVariables.currentLanguage.yetToUpdate.toUpperCase()),
                                          SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                          context.read<CatchWeightBloc>().catchWeightListResponse.yetToUpdate == 0
                                              ? const SizedBox()
                                              : Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                      vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                  decoration: BoxDecoration(
                                                      color: context.read<CatchWeightBloc>().tabIndex == 0 ? Colors.white : const Color(0xff007AFF),
                                                      borderRadius: BorderRadius.circular(20)),
                                                  child: Text(
                                                    context.read<CatchWeightBloc>().catchWeightListResponse.yetToUpdate < 10
                                                        ? "0${context.read<CatchWeightBloc>().catchWeightListResponse.yetToUpdate}"
                                                        : context.read<CatchWeightBloc>().catchWeightListResponse.yetToUpdate.toString(),
                                                    style: TextStyle(
                                                        color: context.read<CatchWeightBloc>().tabIndex == 0 ? const Color(0xff282F3A) : Colors.white,
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
                                          Text(getIt<Variables>().generalVariables.currentLanguage.updated.toUpperCase()),
                                          SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                          context.read<CatchWeightBloc>().catchWeightListResponse.updated == 0
                                              ? const SizedBox()
                                              : Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                      vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                  decoration: BoxDecoration(
                                                      color: context.read<CatchWeightBloc>().tabIndex == 1 ? Colors.white : const Color(0xff007AFF),
                                                      borderRadius: BorderRadius.circular(20)),
                                                  child: Text(
                                                    context.read<CatchWeightBloc>().catchWeightListResponse.updated < 10
                                                        ? "0${context.read<CatchWeightBloc>().catchWeightListResponse.updated}"
                                                        : context.read<CatchWeightBloc>().catchWeightListResponse.updated.toString(),
                                                    style: TextStyle(
                                                        color: context.read<CatchWeightBloc>().tabIndex == 1 ? const Color(0xff282F3A) : Colors.white,
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
                                          Text(getIt<Variables>().generalVariables.currentLanguage.unavailable.toUpperCase()),
                                          SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                          context.read<CatchWeightBloc>().catchWeightListResponse.unavailable == 0
                                              ? const SizedBox()
                                              : Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                      vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                  decoration: BoxDecoration(
                                                      color: context.read<CatchWeightBloc>().tabIndex == 2 ? Colors.white : const Color(0xff007AFF),
                                                      borderRadius: BorderRadius.circular(20)),
                                                  child: Text(
                                                    context.read<CatchWeightBloc>().catchWeightListResponse.unavailable < 10
                                                        ? "0${context.read<CatchWeightBloc>().catchWeightListResponse.unavailable}"
                                                        : context.read<CatchWeightBloc>().catchWeightListResponse.unavailable.toString(),
                                                    style: TextStyle(
                                                        color: context.read<CatchWeightBloc>().tabIndex == 2 ? const Color(0xff282F3A) : Colors.white,
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
                                          Text(getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase()),
                                          SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                          context.read<CatchWeightBloc>().catchWeightListResponse.completed == 0
                                              ? const SizedBox()
                                              : Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                      vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                  decoration: BoxDecoration(
                                                      color: context.read<CatchWeightBloc>().tabIndex == 3 ? Colors.white : const Color(0xff007AFF),
                                                      borderRadius: BorderRadius.circular(20)),
                                                  child: Text(
                                                    context.read<CatchWeightBloc>().catchWeightListResponse.completed < 10
                                                        ? "0${context.read<CatchWeightBloc>().catchWeightListResponse.completed}"
                                                        : context.read<CatchWeightBloc>().catchWeightListResponse.completed.toString(),
                                                    style: TextStyle(
                                                        color: context.read<CatchWeightBloc>().tabIndex == 3 ? const Color(0xff282F3A) : Colors.white,
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
                        Expanded(
                          child: BlocConsumer<CatchWeightBloc, CatchWeightState>(
                            listenWhen: (CatchWeightState previous, CatchWeightState current) {
                              return previous != current;
                            },
                            buildWhen: (CatchWeightState previous, CatchWeightState current) {
                              return previous != current;
                            },
                            listener: (BuildContext context, CatchWeightState state) {
                              if (state is CatchWeightError) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                              }
                            },
                            builder: (BuildContext context, CatchWeightState catchWeight) {
                              if (catchWeight is CatchWeightLoaded) {
                                switch (context.read<CatchWeightBloc>().tabIndex) {
                                  case 0:
                                    return Container(
                                      margin: EdgeInsets.only(
                                          left: getIt<Functions>().getWidgetWidth(width: 16),
                                          right: getIt<Functions>().getWidgetWidth(width: 16),
                                          bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                      child: SmartRefresher(
                                        enablePullDown: true,
                                        enablePullUp: true,
                                        physics: const BouncingScrollPhysics(),
                                        onRefresh: () {
                                          context.read<CatchWeightBloc>().pageIndex = 1;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: false));
                                          yetToUpdateRefreshController.refreshCompleted();
                                          setState(() {});
                                        },
                                        controller: yetToUpdateRefreshController,
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
                                        onLoading: () {
                                          context.read<CatchWeightBloc>().pageIndex++;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: true));
                                          yetToUpdateRefreshController.loadComplete();
                                          setState(() {});
                                        },
                                        child: context.read<CatchWeightBloc>().catchWeightListResponse.items.isEmpty
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
                                                    getIt<Variables>().generalVariables.currentLanguage.catchWeightListIsEmpty,
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
                                                itemCount: context.read<CatchWeightBloc>().catchWeightListResponse.items.length,
                                                shrinkWrap: true,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Container(
                                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                    margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          height: getIt<Functions>().getWidgetHeight(height: 38),
                                                          decoration: const BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border(bottom: BorderSide(width: 1, color: Color(0xffE0E7EC))),
                                                            borderRadius:
                                                                BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                          ),
                                                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Expanded(
                                                                child: SingleChildScrollView(
                                                                  scrollDirection: Axis.horizontal,
                                                                  child: Text(
                                                                    context.read<CatchWeightBloc>().catchWeightListResponse.items[index].customerName,
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                        fontWeight: FontWeight.w500,
                                                                        color: const Color(0xff007AFF)),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 12),
                                                              ),
                                                              IntrinsicHeight(
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap: () {
                                                                        context.read<CatchWeightBloc>().selectedItemId =
                                                                            context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                        reasonSearchFieldController.clear();
                                                                        itemSearchFieldController.clear();
                                                                        context.read<CatchWeightBloc>().selectedReason = "";
                                                                        context.read<CatchWeightBloc>().selectedItem = "";
                                                                        commentsBar.clear();
                                                                        context.read<CatchWeightBloc>().updateLoader = false;
                                                                        context.read<CatchWeightBloc>().commentTextEmpty = false;
                                                                        context.read<CatchWeightBloc>().selectedReasonEmpty = false;
                                                                        context.read<CatchWeightBloc>().selectItemEmpty = false;
                                                                        context.read<CatchWeightBloc>().hideKeyBoardReason = false;
                                                                        context.read<CatchWeightBloc>().hideKeyBoardItem = false;
                                                                        getIt<Variables>().generalVariables.popUpWidget =
                                                                            unavailableContent(index: index);
                                                                        getIt<Functions>().showAnimatedDialog(
                                                                            context: context, isFromTop: false, isCloseDisabled: false);
                                                                      },
                                                                      child: Text(
                                                                        getIt<Variables>().generalVariables.currentLanguage.unavailable.toUpperCase(),
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                            fontWeight: FontWeight.w500,
                                                                            color: const Color(0xffF92C38)),
                                                                      ),
                                                                    ),
                                                                    const VerticalDivider(
                                                                      color: Color(0xff8A8D8E),
                                                                    ),
                                                                    InkWell(
                                                                      onTap: () {
                                                                        context.read<CatchWeightBloc>().selectedItemId =
                                                                            context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                        reasonSearchFieldController.clear();
                                                                        itemSearchFieldController.clear();
                                                                        context.read<CatchWeightBloc>().selectedReason = "";
                                                                        context.read<CatchWeightBloc>().selectedItem = "";
                                                                        commentsBar.clear();
                                                                        context.read<CatchWeightBloc>().chipsContentList.clear();
                                                                        context.read<CatchWeightBloc>().textFieldEmpty = false;
                                                                        context.read<CatchWeightBloc>().availableQtyParticularsEmpty = false;
                                                                        context.read<CatchWeightBloc>().updateLoader = false;
                                                                        context.read<CatchWeightBloc>().formatError = false;
                                                                        context.read<CatchWeightBloc>().moreQuantityError = false;
                                                                        context.read<CatchWeightBloc>().isZeroValue = false;
                                                                        getIt<Variables>().generalVariables.popUpWidget =
                                                                            availableContent(index: index, isYetToUpdate: true);
                                                                        getIt<Functions>().showAnimatedDialog(
                                                                            context: context, isFromTop: false, isCloseDisabled: false);
                                                                      },
                                                                      child: Text(
                                                                        getIt<Variables>().generalVariables.currentLanguage.available.toUpperCase(),
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                            fontWeight: FontWeight.w500,
                                                                            color: const Color(0xff007838)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Container(
                                                                          height: getIt<Functions>().getWidgetHeight(height: 30),
                                                                          width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              image: DecorationImage(
                                                                                image: NetworkImage(context
                                                                                    .read<CatchWeightBloc>()
                                                                                    .catchWeightListResponse
                                                                                    .items[index]
                                                                                    .itemImage),
                                                                                fit: BoxFit.fill,
                                                                              )),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 200),
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              SingleChildScrollView(
                                                                                scrollDirection: Axis.horizontal,
                                                                                child: Text(
                                                                                  context
                                                                                      .read<CatchWeightBloc>()
                                                                                      .catchWeightListResponse
                                                                                      .items[index]
                                                                                      .itemName,
                                                                                  maxLines: 1,
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                                                      color: const Color(0xff282F3A),
                                                                                      overflow: TextOverflow.ellipsis),
                                                                                ),
                                                                              ),
                                                                              IntrinsicHeight(
                                                                                child: SizedBox(
                                                                                  height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                                  child: ListView(
                                                                                    physics: const ScrollPhysics(),
                                                                                    shrinkWrap: true,
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    children: [
                                                                                      Text(
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.soNumber.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].soNumber}",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                            color: const Color(0xff8A8D8E)),
                                                                                      ),
                                                                                      const VerticalDivider(
                                                                                        color: Color(0xff8A8D8E),
                                                                                      ),
                                                                                      Text(
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].itemCode}",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                            color: const Color(0xff8A8D8E)),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Text(
                                                                          "${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].reqQuantity} ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].weightUnit}",
                                                                          style: TextStyle(
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                              fontWeight: FontWeight.w600,
                                                                              color: const Color(0xff007AFF)),
                                                                        ),
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.reqQty.toUpperCase(),
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
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                                              ),
                                                              Container(
                                                                height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetHeight(height: 12)),
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
                                                                          getIt<Variables>().generalVariables.currentLanguage.entryTime.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .entryTime,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.reqBy.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .requestedBy,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>()
                                                                              .generalVariables
                                                                              .currentLanguage
                                                                              .shipToCode
                                                                              .toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .shipToCode,
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
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
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
                                      child: SmartRefresher(
                                        enablePullDown: true,
                                        enablePullUp: true,
                                        physics: const BouncingScrollPhysics(),
                                        onRefresh: () {
                                          context.read<CatchWeightBloc>().pageIndex = 1;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: false));
                                          updatedRefreshController.refreshCompleted();
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
                                        controller: updatedRefreshController,
                                        onLoading: () {
                                          context.read<CatchWeightBloc>().pageIndex++;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: true));
                                          updatedRefreshController.loadComplete();
                                          setState(() {});
                                        },
                                        child: context.read<CatchWeightBloc>().catchWeightListResponse.items.isEmpty
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
                                                    getIt<Variables>().generalVariables.currentLanguage.catchWeightListIsEmpty,
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
                                                itemCount: context.read<CatchWeightBloc>().catchWeightListResponse.items.length,
                                                shrinkWrap: true,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Container(
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
                                                            color: Colors.white,
                                                            border: Border(bottom: BorderSide(width: 1, color: Color(0xffE0E7EC))),
                                                            borderRadius:
                                                                BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                          ),
                                                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Expanded(
                                                                child: SingleChildScrollView(
                                                                  scrollDirection: Axis.horizontal,
                                                                  child: Text(
                                                                    context.read<CatchWeightBloc>().catchWeightListResponse.items[index].customerName,
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                        fontWeight: FontWeight.w500,
                                                                        color: const Color(0xff007AFF)),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 12),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      reasonSearchFieldController.clear();
                                                                      itemSearchFieldController.clear();
                                                                      context.read<CatchWeightBloc>().selectedReason = "";
                                                                      context.read<CatchWeightBloc>().selectedItem = "";
                                                                      context.read<CatchWeightBloc>().selectedItemId =
                                                                          context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                      context.read<CatchWeightBloc>().chipsContentList.clear();
                                                                      context.read<CatchWeightBloc>().chipsContentList.addAll(List<double>.generate(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .availQtyParticulars
                                                                              .length,
                                                                          (i) => i == 0 || i == 1
                                                                              ? 0.0
                                                                              : double.parse(context
                                                                                  .read<CatchWeightBloc>()
                                                                                  .catchWeightListResponse
                                                                                  .items[index]
                                                                                  .availQtyParticulars[i])));
                                                                      context.read<CatchWeightBloc>().chipsContentList.removeAt(0);
                                                                      context.read<CatchWeightBloc>().chipsContentList.removeAt(0);
                                                                      commentsBar.clear();
                                                                      context.read<CatchWeightBloc>().updateLoader = false;
                                                                      getIt<Variables>().generalVariables.popUpWidget =
                                                                          undoPickedContent(index: index);
                                                                      getIt<Functions>().showAnimatedDialog(
                                                                          context: context, isFromTop: false, isCloseDisabled: false);
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.undo.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                              fontWeight: FontWeight.w500,
                                                                              color: const Color(0xff007838)),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 8),
                                                                        ),
                                                                        SvgPicture.asset(
                                                                          "assets/catch_weight/undo.svg",
                                                                          height: getIt<Functions>().getWidgetHeight(height: 14),
                                                                          width: getIt<Functions>().getWidgetHeight(height: 14),
                                                                          fit: BoxFit.fill,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            height: getIt<Functions>().getWidgetHeight(height: 30),
                                                                            width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                            decoration: BoxDecoration(
                                                                                shape: BoxShape.circle,
                                                                                image: DecorationImage(
                                                                                  image: NetworkImage(context
                                                                                      .read<CatchWeightBloc>()
                                                                                      .catchWeightListResponse
                                                                                      .items[index]
                                                                                      .itemImage),
                                                                                  fit: BoxFit.fill,
                                                                                )),
                                                                          ),
                                                                          SizedBox(
                                                                            width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                          ),
                                                                          Expanded(
                                                                            child: SizedBox(
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  SingleChildScrollView(
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    child: Text(
                                                                                      context
                                                                                          .read<CatchWeightBloc>()
                                                                                          .catchWeightListResponse
                                                                                          .items[index]
                                                                                          .itemName,
                                                                                      maxLines: 1,
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                                                          color: const Color(0xff282F3A),
                                                                                          overflow: TextOverflow.ellipsis),
                                                                                    ),
                                                                                  ),
                                                                                  IntrinsicHeight(
                                                                                    child: SizedBox(
                                                                                      height: getIt<Functions>().getWidgetHeight(height: 15),
                                                                                      child: ListView(
                                                                                        physics: const ScrollPhysics(),
                                                                                        shrinkWrap: true,
                                                                                        scrollDirection: Axis.horizontal,
                                                                                        children: [
                                                                                          Text(
                                                                                            "${getIt<Variables>().generalVariables.currentLanguage.soNumber.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].soNumber}",
                                                                                            style: TextStyle(
                                                                                                fontWeight: FontWeight.w500,
                                                                                                fontSize:
                                                                                                    getIt<Functions>().getTextSize(fontSize: 10),
                                                                                                color: const Color(0xff8A8D8E)),
                                                                                          ),
                                                                                          const VerticalDivider(
                                                                                            color: Color(0xff8A8D8E),
                                                                                          ),
                                                                                          Text(
                                                                                            "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].itemCode}",
                                                                                            style: TextStyle(
                                                                                                fontWeight: FontWeight.w500,
                                                                                                fontSize:
                                                                                                    getIt<Functions>().getTextSize(fontSize: 10),
                                                                                                color: const Color(0xff8A8D8E)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: getIt<Functions>().getWidgetWidth(width: 8),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        AutoSizeText(
                                                                          maxFontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                          minFontSize: getIt<Functions>().getTextSize(fontSize: 15),
                                                                          maxLines: 1,
                                                                          softWrap: true,
                                                                          "${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].availQty} ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].weightUnit}",
                                                                          style:
                                                                              const TextStyle(color: Color(0xff007838), fontWeight: FontWeight.w600),
                                                                        ),
                                                                        AutoSizeText(
                                                                          maxFontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          minFontSize: getIt<Functions>().getTextSize(fontSize: 8),
                                                                          maxLines: 2,
                                                                          softWrap: true,
                                                                          getIt<Variables>()
                                                                              .generalVariables
                                                                              .currentLanguage
                                                                              .updatedQty
                                                                              .toUpperCase(),
                                                                          style:
                                                                              const TextStyle(fontWeight: FontWeight.w500, color: Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                                              ),
                                                              Container(
                                                                height: getIt<Functions>().getWidgetHeight(height: 42),
                                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetHeight(height: 12)),
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
                                                                          getIt<Variables>().generalVariables.currentLanguage.entryTime.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .entryTime,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.reqBy.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .requestedBy,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>()
                                                                              .generalVariables
                                                                              .currentLanguage
                                                                              .shipToCode
                                                                              .toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .shipToCode,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>()
                                                                              .generalVariables
                                                                              .currentLanguage
                                                                              .updatedTime
                                                                              .toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .updatedTime,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.updatedBy.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .updatedBy,
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
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
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
                                                                      context
                                                                          .read<CatchWeightBloc>()
                                                                          .catchWeightListResponse
                                                                          .items[index]
                                                                          .availQtyParticulars
                                                                          .length,
                                                                      (idx) => idx == 0
                                                                          ? Padding(
                                                                              padding: const EdgeInsets.only(right: 10.0),
                                                                              child: SvgPicture.asset(
                                                                                "assets/catch_weight/measurement.svg",
                                                                                height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                                fit: BoxFit.fill,
                                                                              ),
                                                                            )
                                                                          : idx == 1
                                                                              ? Container(
                                                                                  height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                  padding: EdgeInsets.symmetric(
                                                                                      horizontal: getIt<Functions>().getWidgetWidth(width: 8)),
                                                                                  child: Text(
                                                                                    "${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].availQtyParticulars[idx]}  : ",
                                                                                    style: TextStyle(
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color(0xff282F3A)),
                                                                                  ),
                                                                                )
                                                                              : Container(
                                                                                  height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                  width: getIt<Functions>().getWidgetWidth(
                                                                                      width: (context
                                                                                                  .read<CatchWeightBloc>()
                                                                                                  .catchWeightListResponse
                                                                                                  .items[index]
                                                                                                  .availQtyParticulars[idx]
                                                                                                  .length *
                                                                                              7) +
                                                                                          30),
                                                                                  padding: EdgeInsets.symmetric(
                                                                                      horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                                  margin: EdgeInsets.only(
                                                                                      left: getIt<Functions>().getWidgetWidth(width: 6),
                                                                                      bottom: getIt<Functions>().getWidgetHeight(height: 2)),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                    color: const Color(0xff7AA440),
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      context
                                                                                          .read<CatchWeightBloc>()
                                                                                          .catchWeightListResponse
                                                                                          .items[index]
                                                                                          .availQtyParticulars[idx],
                                                                                      style: TextStyle(
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
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
                                                      ],
                                                    ),
                                                  );
                                                }),
                                      ),
                                    );
                                  case 2:
                                    return Container(
                                      margin: EdgeInsets.only(
                                          left: getIt<Functions>().getWidgetWidth(width: 16),
                                          right: getIt<Functions>().getWidgetWidth(width: 16),
                                          bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                      child: SmartRefresher(
                                        enablePullDown: true,
                                        enablePullUp: true,
                                        physics: const BouncingScrollPhysics(),
                                        onRefresh: () {
                                          context.read<CatchWeightBloc>().pageIndex = 1;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: false));
                                          unavailableRefreshController.refreshCompleted();
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
                                        controller: unavailableRefreshController,
                                        onLoading: () {
                                          context.read<CatchWeightBloc>().pageIndex++;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: true));
                                          unavailableRefreshController.loadComplete();
                                          setState(() {});
                                        },
                                        child: context.read<CatchWeightBloc>().catchWeightListResponse.items.isEmpty
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
                                                    getIt<Variables>().generalVariables.currentLanguage.catchWeightListIsEmpty,
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
                                                itemCount: context.read<CatchWeightBloc>().catchWeightListResponse.items.length,
                                                shrinkWrap: true,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Container(
                                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                    margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          height: getIt<Functions>().getWidgetHeight(height: 38),
                                                          decoration: const BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border(bottom: BorderSide(width: 1, color: Color(0xffE0E7EC))),
                                                            borderRadius:
                                                                BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                          ),
                                                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Expanded(
                                                                child: SingleChildScrollView(
                                                                  scrollDirection: Axis.horizontal,
                                                                  child: Text(
                                                                    context.read<CatchWeightBloc>().catchWeightListResponse.items[index].customerName,
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff007AFF)),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 12),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      context.read<CatchWeightBloc>().selectedItemId =
                                                                          context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                      reasonSearchFieldController.clear();
                                                                      itemSearchFieldController.clear();
                                                                      context.read<CatchWeightBloc>().selectedReason = "";
                                                                      context.read<CatchWeightBloc>().selectedItem = "";
                                                                      commentsBar.clear();
                                                                      context.read<CatchWeightBloc>().chipsContentList.clear();
                                                                      context.read<CatchWeightBloc>().textFieldEmpty = false;
                                                                      context.read<CatchWeightBloc>().availableQtyParticularsEmpty = false;
                                                                      context.read<CatchWeightBloc>().updateLoader = false;
                                                                      context.read<CatchWeightBloc>().formatError = false;
                                                                      context.read<CatchWeightBloc>().moreQuantityError = false;
                                                                      context.read<CatchWeightBloc>().isZeroValue = false;
                                                                      getIt<Variables>().generalVariables.popUpWidget =
                                                                          availableContent(index: index, isYetToUpdate: false);
                                                                      getIt<Functions>().showAnimatedDialog(
                                                                          context: context, isFromTop: false, isCloseDisabled: false);
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.available.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                              fontWeight: FontWeight.w600,
                                                                              color: const Color(0xff007838)),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 8),
                                                                        ),
                                                                        SvgPicture.asset(
                                                                          "assets/catch_weight/box_tick.svg",
                                                                          height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                          width: getIt<Functions>().getWidgetHeight(height: 16),
                                                                          fit: BoxFit.fill,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Container(
                                                                          height: getIt<Functions>().getWidgetHeight(height: 30),
                                                                          width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              image: DecorationImage(
                                                                                image: NetworkImage(context
                                                                                    .read<CatchWeightBloc>()
                                                                                    .catchWeightListResponse
                                                                                    .items[index]
                                                                                    .itemImage),
                                                                                fit: BoxFit.fill,
                                                                              )),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 200),
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              SingleChildScrollView(
                                                                                scrollDirection: Axis.horizontal,
                                                                                child: Text(
                                                                                  context
                                                                                      .read<CatchWeightBloc>()
                                                                                      .catchWeightListResponse
                                                                                      .items[index]
                                                                                      .itemName,
                                                                                  maxLines: 1,
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                                                      color: const Color(0xff282F3A),
                                                                                      overflow: TextOverflow.ellipsis),
                                                                                ),
                                                                              ),
                                                                              IntrinsicHeight(
                                                                                child: SizedBox(
                                                                                  height: getIt<Functions>().getWidgetHeight(height: 15),
                                                                                  child: ListView(
                                                                                    physics: const ScrollPhysics(),
                                                                                    shrinkWrap: true,
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    children: [
                                                                                      Text(
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.soNumber.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].soNumber}",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                            color: const Color(0xff8A8D8E)),
                                                                                      ),
                                                                                      const VerticalDivider(
                                                                                        color: Color(0xff8A8D8E),
                                                                                      ),
                                                                                      Text(
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].itemCode}",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                            color: const Color(0xff8A8D8E)),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Text(
                                                                          "${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].reqQuantity} ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].weightUnit}",
                                                                          style: TextStyle(
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                              fontWeight: FontWeight.w600,
                                                                              color: const Color(0xffF92C38)),
                                                                        ),
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.reqQty.toUpperCase(),
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
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                                              ),
                                                              Container(
                                                                height: getIt<Functions>().getWidgetHeight(height: 42),
                                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetHeight(height: 12)),
                                                                child: ListView(
                                                                  scrollDirection: Axis.horizontal,
                                                                  physics: const BouncingScrollPhysics(),
                                                                  shrinkWrap: true,
                                                                  padding: EdgeInsets.zero,
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.entryTime.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .entryTime,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.reqBy.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .requestedBy,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>()
                                                                              .generalVariables
                                                                              .currentLanguage
                                                                              .shipToCode
                                                                              .toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .shipToCode,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .updatedTime,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.updatedBy.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .updatedBy,
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
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration: const BoxDecoration(
                                                            color: Color(0xffCDE5FF),
                                                            borderRadius:
                                                                BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                                          ),
                                                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                          child: Row(
                                                            children: [
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  SizedBox(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 8),
                                                                  ),
                                                                  SizedBox(
                                                                    width: getIt<Functions>()
                                                                        .getWidgetWidth(width: getIt<Variables>().generalVariables.width - 45),
                                                                    child: RichText(
                                                                      text: TextSpan(
                                                                        text:
                                                                            "${getIt<Variables>().generalVariables.currentLanguage.reason.toUpperCase()}  :  ",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            color: const Color(0xff282F3A),
                                                                            fontWeight: FontWeight.w500),
                                                                        children: [
                                                                          TextSpan(
                                                                              text: context
                                                                                  .read<CatchWeightBloc>()
                                                                                  .catchWeightListResponse
                                                                                  .items[index]
                                                                                  .reason
                                                                                  .toUpperCase(),
                                                                              style: TextStyle(
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  color: const Color(0xffF92C38),
                                                                                  fontWeight: FontWeight.w500)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 12),
                                                                  ),
                                                                  SizedBox(
                                                                    width: getIt<Functions>()
                                                                        .getWidgetWidth(width: getIt<Variables>().generalVariables.width - 45),
                                                                    child: RichText(
                                                                      maxLines: 2,
                                                                      softWrap: true,
                                                                      text: TextSpan(
                                                                        text:
                                                                            "${getIt<Variables>().generalVariables.currentLanguage.alternativeItem.toUpperCase()}  :  ",
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                            color: const Color(0xff282F3A),
                                                                            fontWeight: FontWeight.w500),
                                                                        children: [
                                                                          TextSpan(
                                                                              text: context
                                                                                  .read<CatchWeightBloc>()
                                                                                  .catchWeightListResponse
                                                                                  .items[index]
                                                                                  .alternativeItemName,
                                                                              style: TextStyle(
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                  color: const Color(0xff007AFF),
                                                                                  fontWeight: FontWeight.w500)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 8),
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
                                    );
                                  case 3:
                                    return Container(
                                      margin: EdgeInsets.only(
                                          left: getIt<Functions>().getWidgetWidth(width: 16),
                                          right: getIt<Functions>().getWidgetWidth(width: 16),
                                          bottom: getIt<Functions>().getWidgetHeight(height: 20)),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                      child: SmartRefresher(
                                        enablePullDown: true,
                                        enablePullUp: true,
                                        physics: const BouncingScrollPhysics(),
                                        onRefresh: () {
                                          context.read<CatchWeightBloc>().pageIndex = 1;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: false));
                                          completedRefreshController.refreshCompleted();
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
                                        controller: completedRefreshController,
                                        onLoading: () {
                                          context.read<CatchWeightBloc>().pageIndex++;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: true));
                                          completedRefreshController.loadComplete();
                                          setState(() {});
                                        },
                                        child: context.read<CatchWeightBloc>().catchWeightListResponse.items.isEmpty
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
                                                    getIt<Variables>().generalVariables.currentLanguage.catchWeightListIsEmpty,
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
                                                itemCount: context.read<CatchWeightBloc>().catchWeightListResponse.items.length,
                                                shrinkWrap: true,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Container(
                                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                    margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          height: getIt<Functions>().getWidgetHeight(height: 38),
                                                          decoration: const BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border(bottom: BorderSide(width: 1, color: Color(0xffE0E7EC))),
                                                            borderRadius:
                                                                BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                          ),
                                                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: SingleChildScrollView(
                                                                  scrollDirection: Axis.horizontal,
                                                                  child: Text(
                                                                    context.read<CatchWeightBloc>().catchWeightListResponse.items[index].customerName,
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff007AFF)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            height: getIt<Functions>().getWidgetHeight(height: 30),
                                                                            width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                            decoration: BoxDecoration(
                                                                                shape: BoxShape.circle,
                                                                                image: DecorationImage(
                                                                                  image: NetworkImage(context
                                                                                      .read<CatchWeightBloc>()
                                                                                      .catchWeightListResponse
                                                                                      .items[index]
                                                                                      .itemImage),
                                                                                  fit: BoxFit.fill,
                                                                                )),
                                                                          ),
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
                                                                                    context
                                                                                        .read<CatchWeightBloc>()
                                                                                        .catchWeightListResponse
                                                                                        .items[index]
                                                                                        .itemName,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                                                        color: const Color(0xff282F3A)),
                                                                                  ),
                                                                                ),
                                                                                IntrinsicHeight(
                                                                                  child: SizedBox(
                                                                                    height: getIt<Functions>().getWidgetHeight(height: 15),
                                                                                    child: ListView(
                                                                                      physics: const ScrollPhysics(),
                                                                                      shrinkWrap: true,
                                                                                      scrollDirection: Axis.horizontal,
                                                                                      children: [
                                                                                        Text(
                                                                                          "${getIt<Variables>().generalVariables.currentLanguage.soNumber.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].soNumber}",
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                              color: const Color(0xff8A8D8E)),
                                                                                        ),
                                                                                        const VerticalDivider(
                                                                                          color: Color(0xff8A8D8E),
                                                                                        ),
                                                                                        Text(
                                                                                          "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].itemCode}",
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                              color: const Color(0xff8A8D8E)),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .availQty,
                                                                          maxLines: 1,
                                                                          style: TextStyle(
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                              color: const Color(0xff007838),
                                                                              fontWeight: FontWeight.w600,
                                                                              overflow: TextOverflow.ellipsis),
                                                                        ),
                                                                        Text(
                                                                          getIt<Variables>()
                                                                              .generalVariables
                                                                              .currentLanguage
                                                                              .updatedQty
                                                                              .toUpperCase(),
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
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                                              ),
                                                              Container(
                                                                height: getIt<Functions>().getWidgetHeight(height: 42),
                                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetHeight(height: 12)),
                                                                child: ListView(
                                                                  scrollDirection: Axis.horizontal,
                                                                  physics: const BouncingScrollPhysics(),
                                                                  shrinkWrap: true,
                                                                  padding: EdgeInsets.zero,
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.entryTime.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .entryTime,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.reqBy.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .requestedBy,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>()
                                                                              .generalVariables
                                                                              .currentLanguage
                                                                              .shipToCode
                                                                              .toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .shipToCode,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .updatedTime,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.updatedBy.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .updatedBy,
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
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
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
                                                                      context
                                                                          .read<CatchWeightBloc>()
                                                                          .catchWeightListResponse
                                                                          .items[index]
                                                                          .availQtyParticulars
                                                                          .length,
                                                                      (idx) => idx == 0
                                                                          ? Padding(
                                                                              padding: const EdgeInsets.only(right: 10.0),
                                                                              child: SvgPicture.asset(
                                                                                "assets/catch_weight/measurement.svg",
                                                                                height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                                fit: BoxFit.fill,
                                                                              ),
                                                                            )
                                                                          : idx == 1
                                                                              ? Container(
                                                                                  height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                  padding: EdgeInsets.symmetric(
                                                                                      horizontal: getIt<Functions>().getWidgetWidth(width: 8)),
                                                                                  child: Text(
                                                                                    "${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].availQtyParticulars[idx]}  : ",
                                                                                    style: TextStyle(
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: const Color(0xff282F3A)),
                                                                                  ),
                                                                                )
                                                                              : Container(
                                                                                  height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                  width: getIt<Functions>().getWidgetWidth(
                                                                                      width: (context
                                                                                                  .read<CatchWeightBloc>()
                                                                                                  .catchWeightListResponse
                                                                                                  .items[index]
                                                                                                  .availQtyParticulars[idx]
                                                                                                  .length *
                                                                                              7) +
                                                                                          30),
                                                                                  padding: EdgeInsets.symmetric(
                                                                                      horizontal: getIt<Functions>().getWidgetWidth(width: 8)),
                                                                                  margin: EdgeInsets.only(
                                                                                      left: getIt<Functions>().getWidgetWidth(width: 6),
                                                                                      bottom: getIt<Functions>().getWidgetHeight(height: 2)),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                    color: const Color(0xff7AA440),
                                                                                  ),
                                                                                  child: Text(
                                                                                    context
                                                                                        .read<CatchWeightBloc>()
                                                                                        .catchWeightListResponse
                                                                                        .items[index]
                                                                                        .availQtyParticulars[idx],
                                                                                    style: TextStyle(
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: const Color(0xffffffff)),
                                                                                  ),
                                                                                )),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
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
                                      child: SmartRefresher(
                                        enablePullDown: true,
                                        enablePullUp: true,
                                        physics: const BouncingScrollPhysics(),
                                        onRefresh: () {
                                          context.read<CatchWeightBloc>().pageIndex = 1;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: false));
                                          yetToUpdateRefreshController.refreshCompleted();
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
                                        controller: yetToUpdateRefreshController,
                                        onLoading: () {
                                          context.read<CatchWeightBloc>().pageIndex++;
                                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: true));
                                          yetToUpdateRefreshController.loadComplete();
                                          setState(() {});
                                        },
                                        child: context.read<CatchWeightBloc>().catchWeightListResponse.items.isEmpty
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
                                                    getIt<Variables>().generalVariables.currentLanguage.catchWeightListIsEmpty,
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
                                                itemCount: context.read<CatchWeightBloc>().catchWeightListResponse.items.length,
                                                shrinkWrap: true,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Container(
                                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                    margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          height: getIt<Functions>().getWidgetHeight(height: 38),
                                                          decoration: const BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border(bottom: BorderSide(width: 1, color: Color(0xffE0E7EC))),
                                                            borderRadius:
                                                                BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                          ),
                                                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Expanded(
                                                                child: SingleChildScrollView(
                                                                  scrollDirection: Axis.horizontal,
                                                                  child: Text(
                                                                    context.read<CatchWeightBloc>().catchWeightListResponse.items[index].customerName,
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                        fontWeight: FontWeight.w500,
                                                                        color: const Color(0xff007AFF)),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 12),
                                                              ),
                                                              IntrinsicHeight(
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap: () {
                                                                        context.read<CatchWeightBloc>().selectedItemId =
                                                                            context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                        reasonSearchFieldController.clear();
                                                                        itemSearchFieldController.clear();
                                                                        context.read<CatchWeightBloc>().selectedReason = "";
                                                                        context.read<CatchWeightBloc>().selectedItem = "";
                                                                        commentsBar.clear();
                                                                        context.read<CatchWeightBloc>().updateLoader = false;
                                                                        context.read<CatchWeightBloc>().commentTextEmpty = false;
                                                                        context.read<CatchWeightBloc>().selectedReasonEmpty = false;
                                                                        context.read<CatchWeightBloc>().selectItemEmpty = false;
                                                                        context.read<CatchWeightBloc>().hideKeyBoardReason = false;
                                                                        context.read<CatchWeightBloc>().hideKeyBoardItem = false;
                                                                        getIt<Variables>().generalVariables.popUpWidget =
                                                                            unavailableContent(index: index);
                                                                        getIt<Functions>().showAnimatedDialog(
                                                                            context: context, isFromTop: false, isCloseDisabled: false);
                                                                      },
                                                                      child: Text(
                                                                        getIt<Variables>().generalVariables.currentLanguage.unavailable.toUpperCase(),
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                            fontWeight: FontWeight.w500,
                                                                            color: const Color(0xffF92C38)),
                                                                      ),
                                                                    ),
                                                                    const VerticalDivider(
                                                                      color: Color(0xff8A8D8E),
                                                                    ),
                                                                    InkWell(
                                                                      onTap: () {
                                                                        context.read<CatchWeightBloc>().selectedItemId =
                                                                            context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                        reasonSearchFieldController.clear();
                                                                        itemSearchFieldController.clear();
                                                                        context.read<CatchWeightBloc>().selectedReason = "";
                                                                        context.read<CatchWeightBloc>().selectedItem = "";
                                                                        commentsBar.clear();
                                                                        context.read<CatchWeightBloc>().chipsContentList.clear();
                                                                        context.read<CatchWeightBloc>().textFieldEmpty = false;
                                                                        context.read<CatchWeightBloc>().availableQtyParticularsEmpty = false;
                                                                        context.read<CatchWeightBloc>().updateLoader = false;
                                                                        context.read<CatchWeightBloc>().formatError = false;
                                                                        context.read<CatchWeightBloc>().moreQuantityError = false;
                                                                        context.read<CatchWeightBloc>().isZeroValue = false;
                                                                        getIt<Variables>().generalVariables.popUpWidget =
                                                                            availableContent(index: index, isYetToUpdate: true);
                                                                        getIt<Functions>().showAnimatedDialog(
                                                                            context: context, isFromTop: false, isCloseDisabled: false);
                                                                      },
                                                                      child: Text(
                                                                        getIt<Variables>().generalVariables.currentLanguage.available.toUpperCase(),
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                            fontWeight: FontWeight.w500,
                                                                            color: const Color(0xff007838)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Container(
                                                                          height: getIt<Functions>().getWidgetHeight(height: 30),
                                                                          width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              image: DecorationImage(
                                                                                image: NetworkImage(context
                                                                                    .read<CatchWeightBloc>()
                                                                                    .catchWeightListResponse
                                                                                    .items[index]
                                                                                    .itemImage),
                                                                                fit: BoxFit.fill,
                                                                              )),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 200),
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              SingleChildScrollView(
                                                                                scrollDirection: Axis.horizontal,
                                                                                child: Text(
                                                                                  context
                                                                                      .read<CatchWeightBloc>()
                                                                                      .catchWeightListResponse
                                                                                      .items[index]
                                                                                      .itemName,
                                                                                  maxLines: 1,
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                                                      color: const Color(0xff282F3A),
                                                                                      overflow: TextOverflow.ellipsis),
                                                                                ),
                                                                              ),
                                                                              IntrinsicHeight(
                                                                                child: SizedBox(
                                                                                  height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                                  child: ListView(
                                                                                    physics: const ScrollPhysics(),
                                                                                    shrinkWrap: true,
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    children: [
                                                                                      Text(
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.soNumber.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].soNumber}",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                            color: const Color(0xff8A8D8E)),
                                                                                      ),
                                                                                      const VerticalDivider(
                                                                                        color: Color(0xff8A8D8E),
                                                                                      ),
                                                                                      Text(
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].itemCode}",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                            color: const Color(0xff8A8D8E)),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Text(
                                                                          "${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].reqQuantity} ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].weightUnit}",
                                                                          style: TextStyle(
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                              fontWeight: FontWeight.w600,
                                                                              color: const Color(0xff007AFF)),
                                                                        ),
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.reqQty.toUpperCase(),
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
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                                              ),
                                                              Container(
                                                                height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetHeight(height: 12)),
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
                                                                          getIt<Variables>().generalVariables.currentLanguage.entryTime.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .entryTime,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>().generalVariables.currentLanguage.reqBy.toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .requestedBy,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Text(
                                                                          getIt<Variables>()
                                                                              .generalVariables
                                                                              .currentLanguage
                                                                              .shipToCode
                                                                              .toUpperCase(),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                              color: const Color(0xff8A8D8E)),
                                                                        ),
                                                                        Text(
                                                                          context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .shipToCode,
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
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                      ),
                                    );
                                }
                              } else if (catchWeight is CatchWeightLoading) {
                                switch (context.read<CatchWeightBloc>().tabIndex) {
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
                                            itemCount: 1,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Container(
                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: getIt<Functions>().getWidgetHeight(height: 38),
                                                      decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border(bottom: BorderSide(width: 1, color: Color(0xffE0E7EC))),
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                      ),
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            "ONE MORE NIGHT HOSTEL",
                                                            style: TextStyle(
                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                fontWeight: FontWeight.w500,
                                                                color: const Color(0xff007AFF)),
                                                          ),
                                                          IntrinsicHeight(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    context.read<CatchWeightBloc>().selectedItemId =
                                                                        context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                    reasonSearchFieldController.clear();
                                                                    itemSearchFieldController.clear();
                                                                    context.read<CatchWeightBloc>().selectedReason = "";
                                                                    context.read<CatchWeightBloc>().selectedItem = "";
                                                                    commentsBar.clear();
                                                                    context.read<CatchWeightBloc>().updateLoader = false;
                                                                    context.read<CatchWeightBloc>().commentTextEmpty = false;
                                                                    context.read<CatchWeightBloc>().selectedReasonEmpty = false;
                                                                    context.read<CatchWeightBloc>().selectItemEmpty = false;
                                                                    context.read<CatchWeightBloc>().hideKeyBoardReason = false;
                                                                    context.read<CatchWeightBloc>().hideKeyBoardItem = false;
                                                                    getIt<Variables>().generalVariables.popUpWidget =
                                                                        unavailableContent(index: index);
                                                                    getIt<Functions>().showAnimatedDialog(
                                                                        context: context, isFromTop: false, isCloseDisabled: false);
                                                                  },
                                                                  child: Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.unavailable.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                        fontWeight: FontWeight.w500,
                                                                        color: const Color(0xffF92C38)),
                                                                  ),
                                                                ),
                                                                const VerticalDivider(
                                                                  color: Color(0xff8A8D8E),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    context.read<CatchWeightBloc>().selectedItemId =
                                                                        context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                    reasonSearchFieldController.clear();
                                                                    itemSearchFieldController.clear();
                                                                    context.read<CatchWeightBloc>().selectedReason = "";
                                                                    context.read<CatchWeightBloc>().selectedItem = "";
                                                                    commentsBar.clear();
                                                                    context.read<CatchWeightBloc>().chipsContentList.clear();
                                                                    context.read<CatchWeightBloc>().textFieldEmpty = false;
                                                                    context.read<CatchWeightBloc>().availableQtyParticularsEmpty = false;
                                                                    context.read<CatchWeightBloc>().updateLoader = false;
                                                                    context.read<CatchWeightBloc>().formatError = false;
                                                                    context.read<CatchWeightBloc>().moreQuantityError = false;
                                                                    context.read<CatchWeightBloc>().isZeroValue = false;
                                                                    getIt<Variables>().generalVariables.popUpWidget =
                                                                        availableContent(index: index, isYetToUpdate: true);
                                                                    getIt<Functions>().showAnimatedDialog(
                                                                        context: context, isFromTop: false, isCloseDisabled: false);
                                                                  },
                                                                  child: Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.available.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                        fontWeight: FontWeight.w500,
                                                                        color: const Color(0xff007838)),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Container(
                                                                      height: getIt<Functions>().getWidgetHeight(height: 30),
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
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
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 225),
                                                                          child: Text(
                                                                            "Mutton Leg Boneless - Aus Origin - KG",
                                                                            maxLines: 1,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                                                color: const Color(0xff282F3A),
                                                                                overflow: TextOverflow.ellipsis),
                                                                          ),
                                                                        ),
                                                                        IntrinsicHeight(
                                                                          child: Row(
                                                                            children: [
                                                                              Text(
                                                                                "${getIt<Variables>().generalVariables.currentLanguage.soNumber.toUpperCase()} : 196045",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              const VerticalDivider(
                                                                                color: Color(0xff8A8D8E),
                                                                              ),
                                                                              Text(
                                                                                "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : MB002",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      "41 KG",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xff007AFF)),
                                                                    ),
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.reqQty.toUpperCase(),
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
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 16),
                                                          ),
                                                          Container(
                                                            height: getIt<Functions>().getWidgetHeight(height: 35),
                                                            padding: EdgeInsets.only(left: getIt<Functions>().getWidgetHeight(height: 12)),
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
                                                                      getIt<Variables>().generalVariables.currentLanguage.entryTime.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    Text(
                                                                      "19/05/2024, 01:10 PM",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.reqBy.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    Text(
                                                                      "Ava Johnson",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.shipToCode.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    Text(
                                                                      "SF1937",
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
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
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
                                            itemCount: 1,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Container(
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
                                                        color: Colors.white,
                                                        border: Border(bottom: BorderSide(width: 1, color: Color(0xffE0E7EC))),
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                      ),
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            "ONE MORE NIGHT HOSTEL",
                                                            style: TextStyle(
                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                fontWeight: FontWeight.w500,
                                                                color: const Color(0xff007AFF)),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  reasonSearchFieldController.clear();
                                                                  itemSearchFieldController.clear();
                                                                  context.read<CatchWeightBloc>().selectedReason = "";
                                                                  context.read<CatchWeightBloc>().selectedItem = "";
                                                                  context.read<CatchWeightBloc>().selectedItemId =
                                                                      context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                  context.read<CatchWeightBloc>().chipsContentList.clear();
                                                                  context.read<CatchWeightBloc>().chipsContentList.addAll(List<double>.generate(
                                                                      context
                                                                          .read<CatchWeightBloc>()
                                                                          .catchWeightListResponse
                                                                          .items[index]
                                                                          .availQtyParticulars
                                                                          .length,
                                                                      (i) => i == 0 || i == 1
                                                                          ? 0.0
                                                                          : double.parse(context
                                                                              .read<CatchWeightBloc>()
                                                                              .catchWeightListResponse
                                                                              .items[index]
                                                                              .availQtyParticulars[i])));
                                                                  context.read<CatchWeightBloc>().chipsContentList.removeAt(0);
                                                                  context.read<CatchWeightBloc>().chipsContentList.removeAt(0);
                                                                  commentsBar.clear();
                                                                  context.read<CatchWeightBloc>().updateLoader = false;
                                                                  getIt<Variables>().generalVariables.popUpWidget = undoPickedContent(index: index);
                                                                  getIt<Functions>()
                                                                      .showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.undo.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                          fontWeight: FontWeight.w500,
                                                                          color: const Color(0xff007838)),
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 8),
                                                                    ),
                                                                    SvgPicture.asset(
                                                                      "assets/catch_weight/undo.svg",
                                                                      height: getIt<Functions>().getWidgetHeight(height: 14),
                                                                      width: getIt<Functions>().getWidgetHeight(height: 14),
                                                                      fit: BoxFit.fill,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Container(
                                                                      height: getIt<Functions>().getWidgetHeight(height: 30),
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
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
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 225),
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "Mutton Leg Boneless - Aus Origin - KG",
                                                                            maxLines: 1,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                                                color: const Color(0xff282F3A),
                                                                                overflow: TextOverflow.ellipsis),
                                                                          ),
                                                                          IntrinsicHeight(
                                                                            child: Row(
                                                                              children: [
                                                                                Text(
                                                                                  "${getIt<Variables>().generalVariables.currentLanguage.soNumber.toUpperCase()} : 196045",
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                      color: const Color(0xff8A8D8E)),
                                                                                ),
                                                                                const VerticalDivider(
                                                                                  color: Color(0xff8A8D8E),
                                                                                ),
                                                                                Text(
                                                                                  "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : MB002",
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                      color: const Color(0xff8A8D8E)),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      "40.25 KG",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                          color: const Color(0xff007838),
                                                                          fontWeight: FontWeight.w600),
                                                                    ),
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.updatedQty.toUpperCase(),
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
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 16),
                                                          ),
                                                          Container(
                                                            height: getIt<Functions>().getWidgetHeight(height: 40),
                                                            padding: EdgeInsets.only(left: getIt<Functions>().getWidgetHeight(height: 12)),
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
                                                                      getIt<Variables>().generalVariables.currentLanguage.entryTime.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    Text(
                                                                      "19/05/24, 11:37 AM",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.reqBy.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    Text(
                                                                      "Ava Johnson",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.shipToCode.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    Text(
                                                                      "SF1937",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.updatedTime.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    Text(
                                                                      "19/05/24, 11:37 AM",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.updatedBy.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    Text(
                                                                      "John Mathew",
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
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            decoration: const BoxDecoration(
                                                              color: Color(0xffCDE5FF),
                                                              borderRadius:
                                                                  BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                                            ),
                                                            padding: EdgeInsets.only(
                                                                left: getIt<Functions>().getWidgetWidth(width: 12),
                                                                top: getIt<Functions>().getWidgetHeight(height: 8),
                                                                bottom: getIt<Functions>().getWidgetHeight(height: 8)),
                                                            child: Wrap(
                                                              children: List.generate(
                                                                  1,
                                                                  (idx) => idx == 0
                                                                      ? Padding(
                                                                          padding: const EdgeInsets.only(right: 10.0),
                                                                          child: SvgPicture.asset(
                                                                            "assets/catch_weight/measurement.svg",
                                                                            height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                            width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                            fit: BoxFit.fill,
                                                                          ),
                                                                        )
                                                                      : idx == 1
                                                                          ? Text(
                                                                              "idx KG  : ",
                                                                              style: TextStyle(
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: const Color(0xff282F3A)),
                                                                            )
                                                                          : Container(
                                                                              height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                              padding: EdgeInsets.symmetric(
                                                                                  horizontal: getIt<Functions>().getWidgetWidth(width: 8)),
                                                                              margin: EdgeInsets.only(
                                                                                  left: getIt<Functions>().getWidgetWidth(width: 6),
                                                                                  top: getIt<Functions>().getWidgetHeight(height: 6)),
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(8),
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "22.65",
                                                                                  style: TextStyle(
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11),
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
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                    );
                                  case 2:
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
                                            itemCount: 1,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Container(
                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: getIt<Functions>().getWidgetHeight(height: 38),
                                                      decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border(bottom: BorderSide(width: 1, color: Color(0xffE0E7EC))),
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                      ),
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            "ONE MORE NIGHT HOSTEL",
                                                            style: TextStyle(
                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                fontWeight: FontWeight.w600,
                                                                color: const Color(0xff007AFF)),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  context.read<CatchWeightBloc>().selectedItemId =
                                                                      context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                  reasonSearchFieldController.clear();
                                                                  itemSearchFieldController.clear();
                                                                  context.read<CatchWeightBloc>().selectedReason = "";
                                                                  context.read<CatchWeightBloc>().selectedItem = "";
                                                                  commentsBar.clear();
                                                                  context.read<CatchWeightBloc>().chipsContentList.clear();
                                                                  context.read<CatchWeightBloc>().textFieldEmpty = false;
                                                                  context.read<CatchWeightBloc>().availableQtyParticularsEmpty = false;
                                                                  context.read<CatchWeightBloc>().updateLoader = false;
                                                                  context.read<CatchWeightBloc>().formatError = false;
                                                                  context.read<CatchWeightBloc>().moreQuantityError = false;
                                                                  context.read<CatchWeightBloc>().isZeroValue = false;
                                                                  getIt<Variables>().generalVariables.popUpWidget =
                                                                      availableContent(index: index, isYetToUpdate: false);
                                                                  getIt<Functions>()
                                                                      .showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.available.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xff007838)),
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 8),
                                                                    ),
                                                                    SvgPicture.asset(
                                                                      "assets/catch_weight/box_tick.svg",
                                                                      height: getIt<Functions>().getWidgetHeight(height: 16),
                                                                      width: getIt<Functions>().getWidgetHeight(height: 16),
                                                                      fit: BoxFit.fill,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Container(
                                                                      height: getIt<Functions>().getWidgetHeight(height: 30),
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
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
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 225),
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "Mutton Leg Boneless - Aus Origin - KG",
                                                                            maxLines: 1,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                                                color: const Color(0xff282F3A),
                                                                                overflow: TextOverflow.ellipsis),
                                                                          ),
                                                                          IntrinsicHeight(
                                                                            child: Row(
                                                                              children: [
                                                                                Text(
                                                                                  "${getIt<Variables>().generalVariables.currentLanguage.soNumber.toUpperCase()} : 196045",
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                      color: const Color(0xff8A8D8E)),
                                                                                ),
                                                                                const VerticalDivider(
                                                                                  color: Color(0xff8A8D8E),
                                                                                ),
                                                                                Text(
                                                                                  "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : MB002",
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                      color: const Color(0xff8A8D8E)),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      "41 KG",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xffF92C38)),
                                                                    ),
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.reqQty.toUpperCase(),
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
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 16),
                                                          ),
                                                          Container(
                                                            height: getIt<Functions>().getWidgetHeight(height: 40),
                                                            padding: EdgeInsets.only(left: getIt<Functions>().getWidgetHeight(height: 12)),
                                                            child: ListView(
                                                              scrollDirection: Axis.horizontal,
                                                              physics: const BouncingScrollPhysics(),
                                                              shrinkWrap: true,
                                                              padding: EdgeInsets.zero,
                                                              children: [
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.entryTime.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    Text(
                                                                      "19/05/24, 11:37 AM",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.reqBy.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    Text(
                                                                      "Ava Johnson",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.shipToCode.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    Text(
                                                                      "SF1937",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.updatedTime.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    Text(
                                                                      "19/05/24, 11:37 AM",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.updatedBy.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    Text(
                                                                      "John Mathew",
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
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                        color: Color(0xffCDE5FF),
                                                        borderRadius:
                                                            BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                                      ),
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 8),
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      "${getIt<Variables>().generalVariables.currentLanguage.reason.toUpperCase()}  :  ",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      color: const Color(0xff282F3A),
                                                                      fontWeight: FontWeight.w500),
                                                                  children: [
                                                                    TextSpan(
                                                                        text: 'EXPIRED STOCKS',
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            color: const Color(0xffF92C38),
                                                                            fontWeight: FontWeight.w500)),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 12),
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      "${getIt<Variables>().generalVariables.currentLanguage.alternativeItem.toUpperCase()}  :  ",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                      color: const Color(0xff282F3A),
                                                                      fontWeight: FontWeight.w500),
                                                                  children: [
                                                                    TextSpan(
                                                                        text: 'Lamb Leg Boneless-AUs Origin-Kg',
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                            color: const Color(0xff007AFF),
                                                                            fontWeight: FontWeight.w500)),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 8),
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
                                    );
                                  case 3:
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
                                            itemCount: 1,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Container(
                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: getIt<Functions>().getWidgetHeight(height: 38),
                                                      decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border(bottom: BorderSide(width: 1, color: Color(0xffE0E7EC))),
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                      ),
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "ONE MORE NIGHT HOSTEL",
                                                            style: TextStyle(
                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                fontWeight: FontWeight.w600,
                                                                color: const Color(0xff007AFF)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Container(
                                                                      height: getIt<Functions>().getWidgetHeight(height: 30),
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
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
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 225),
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "Mutton Leg Boneless - Aus Origin - KG",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                          IntrinsicHeight(
                                                                            child: Row(
                                                                              children: [
                                                                                Text(
                                                                                  "${getIt<Variables>().generalVariables.currentLanguage.soNumber.toUpperCase()} : 196045",
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                      color: const Color(0xff8A8D8E)),
                                                                                ),
                                                                                const VerticalDivider(
                                                                                  color: Color(0xff8A8D8E),
                                                                                ),
                                                                                Text(
                                                                                  "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : MB002",
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                      color: const Color(0xff8A8D8E)),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      "40.25",
                                                                      maxLines: 1,
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                          color: const Color(0xff007838),
                                                                          fontWeight: FontWeight.w600,
                                                                          overflow: TextOverflow.ellipsis),
                                                                    ),
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.updatedQty.toUpperCase(),
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
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 16),
                                                          ),
                                                          Container(
                                                            height: getIt<Functions>().getWidgetHeight(height: 40),
                                                            padding: EdgeInsets.only(left: getIt<Functions>().getWidgetHeight(height: 12)),
                                                            child: ListView(
                                                              scrollDirection: Axis.horizontal,
                                                              physics: const BouncingScrollPhysics(),
                                                              shrinkWrap: true,
                                                              padding: EdgeInsets.zero,
                                                              children: [
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.entryTime.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    Text(
                                                                      "19/05/24, 11:37 AM",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.reqBy.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    Text(
                                                                      "Ava Johnson",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.shipToCode.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    Text(
                                                                      "SF1937",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.updatedTime.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    Text(
                                                                      "19/05/24, 11:37 AM",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.updatedBy.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    Text(
                                                                      "John Mathew",
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
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            decoration: const BoxDecoration(
                                                              color: Color(0xffCDE5FF),
                                                              borderRadius:
                                                                  BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                                            ),
                                                            padding: EdgeInsets.only(
                                                                left: getIt<Functions>().getWidgetWidth(width: 12),
                                                                top: getIt<Functions>().getWidgetHeight(height: 8),
                                                                bottom: getIt<Functions>().getWidgetHeight(height: 8)),
                                                            child: Wrap(
                                                              children: List.generate(
                                                                  1,
                                                                  (idx) => idx == 0
                                                                      ? Padding(
                                                                          padding: const EdgeInsets.only(right: 10.0),
                                                                          child: SvgPicture.asset(
                                                                            "assets/catch_weight/measurement.svg",
                                                                            height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                            width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                            fit: BoxFit.fill,
                                                                          ),
                                                                        )
                                                                      : idx == 1
                                                                          ? Text("idx KG  : ",
                                                                              style: TextStyle(
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: const Color(0xff282F3A)))
                                                                          : Container(
                                                                              height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                              padding: EdgeInsets.symmetric(
                                                                                  horizontal: getIt<Functions>().getWidgetWidth(width: 8)),
                                                                              margin: EdgeInsets.only(
                                                                                  left: getIt<Functions>().getWidgetWidth(width: 6),
                                                                                  top: getIt<Functions>().getWidgetHeight(height: 6)),
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "22.65",
                                                                                  style: TextStyle(
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11),
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
                                                  ],
                                                ),
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
                                            itemCount: 1,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Container(
                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: getIt<Functions>().getWidgetHeight(height: 38),
                                                      decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border(bottom: BorderSide(width: 1, color: Color(0xffE0E7EC))),
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                      ),
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            "ONE MORE NIGHT HOSTEL",
                                                            style: TextStyle(
                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                fontWeight: FontWeight.w500,
                                                                color: const Color(0xff007AFF)),
                                                          ),
                                                          IntrinsicHeight(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    context.read<CatchWeightBloc>().selectedItemId =
                                                                        context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                    reasonSearchFieldController.clear();
                                                                    itemSearchFieldController.clear();
                                                                    context.read<CatchWeightBloc>().selectedReason = "";
                                                                    context.read<CatchWeightBloc>().selectedItem = "";
                                                                    commentsBar.clear();
                                                                    context.read<CatchWeightBloc>().updateLoader = false;
                                                                    context.read<CatchWeightBloc>().commentTextEmpty = false;
                                                                    context.read<CatchWeightBloc>().selectedReasonEmpty = false;
                                                                    context.read<CatchWeightBloc>().selectItemEmpty = false;
                                                                    context.read<CatchWeightBloc>().hideKeyBoardReason = false;
                                                                    context.read<CatchWeightBloc>().hideKeyBoardItem = false;
                                                                    getIt<Variables>().generalVariables.popUpWidget =
                                                                        unavailableContent(index: index);
                                                                    getIt<Functions>().showAnimatedDialog(
                                                                        context: context, isFromTop: false, isCloseDisabled: false);
                                                                  },
                                                                  child: Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.unavailable.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                        fontWeight: FontWeight.w500,
                                                                        color: const Color(0xffF92C38)),
                                                                  ),
                                                                ),
                                                                const VerticalDivider(
                                                                  color: Color(0xff8A8D8E),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    context.read<CatchWeightBloc>().selectedItemId =
                                                                        context.read<CatchWeightBloc>().catchWeightListResponse.items[index].id;
                                                                    reasonSearchFieldController.clear();
                                                                    itemSearchFieldController.clear();
                                                                    context.read<CatchWeightBloc>().selectedReason = "";
                                                                    context.read<CatchWeightBloc>().selectedItem = "";
                                                                    commentsBar.clear();
                                                                    context.read<CatchWeightBloc>().chipsContentList.clear();
                                                                    context.read<CatchWeightBloc>().textFieldEmpty = false;
                                                                    context.read<CatchWeightBloc>().availableQtyParticularsEmpty = false;
                                                                    context.read<CatchWeightBloc>().updateLoader = false;
                                                                    context.read<CatchWeightBloc>().formatError = false;
                                                                    context.read<CatchWeightBloc>().moreQuantityError = false;
                                                                    context.read<CatchWeightBloc>().isZeroValue = false;
                                                                    getIt<Variables>().generalVariables.popUpWidget =
                                                                        availableContent(index: index, isYetToUpdate: true);
                                                                    getIt<Functions>().showAnimatedDialog(
                                                                        context: context, isFromTop: false, isCloseDisabled: false);
                                                                  },
                                                                  child: Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.available.toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                        fontWeight: FontWeight.w500,
                                                                        color: const Color(0xff007838)),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Container(
                                                                      height: getIt<Functions>().getWidgetHeight(height: 30),
                                                                      width: getIt<Functions>().getWidgetWidth(width: 30),
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
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 225),
                                                                          child: Text(
                                                                            "Mutton Leg Boneless - Aus Origin - KG",
                                                                            maxLines: 1,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                                                color: const Color(0xff282F3A),
                                                                                overflow: TextOverflow.ellipsis),
                                                                          ),
                                                                        ),
                                                                        IntrinsicHeight(
                                                                          child: Row(
                                                                            children: [
                                                                              Text(
                                                                                "${getIt<Variables>().generalVariables.currentLanguage.soNumber.toUpperCase()} : 196045",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              const VerticalDivider(
                                                                                color: Color(0xff8A8D8E),
                                                                              ),
                                                                              Text(
                                                                                "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : MB002",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      "41 KG",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xff007AFF)),
                                                                    ),
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.reqQty.toUpperCase(),
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
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 16),
                                                          ),
                                                          Container(
                                                            height: getIt<Functions>().getWidgetHeight(height: 35),
                                                            padding: EdgeInsets.only(left: getIt<Functions>().getWidgetHeight(height: 12)),
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
                                                                      getIt<Variables>().generalVariables.currentLanguage.entryTime.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    Text(
                                                                      "19/05/2024, 01:10 PM",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.reqBy.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    Text(
                                                                      "Ava Johnson",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: getIt<Functions>().getWidgetWidth(width: 30),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.shipToCode.toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    Text(
                                                                      "SF1937",
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
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
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
        },
      ),
    );
  }

  Widget textBars({required TextEditingController controller}) {
    return BlocBuilder<CatchWeightBloc, CatchWeightState>(
      builder: (BuildContext context, CatchWeightState catchWeight) {
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
                          context.read<CatchWeightBloc>().searchText = value.toLowerCase();
                          context.read<CatchWeightBloc>().pageIndex = 1;
                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: false));
                        } else {
                          context.read<CatchWeightBloc>().searchText = "";
                          context.read<CatchWeightBloc>().pageIndex = 1;
                          context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: false));
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
                                  context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
                                  context.read<CatchWeightBloc>().searchText = "";
                                  context.read<CatchWeightBloc>().pageIndex = 1;
                                  context.read<CatchWeightBloc>().add(const CatchWeightTabChangingEvent(isLoading: false));
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

  Widget availableContent({required int index, required bool isYetToUpdate}) {
    return BlocConsumer<CatchWeightBloc, CatchWeightState>(
      listenWhen: (CatchWeightState previous, CatchWeightState current) {
        return previous != current;
      },
      buildWhen: (CatchWeightState previous, CatchWeightState current) {
        return previous != current;
      },
      listener: (BuildContext context, CatchWeightState state) {
        if (state is CatchWeightSuccess) {
          if (isYetToUpdate) {
            context.read<CatchWeightBloc>().catchWeightListResponse.yetToUpdate--;
            context.read<CatchWeightBloc>().catchWeightListResponse.updated++;
          } else {
            context.read<CatchWeightBloc>().catchWeightListResponse.unavailable--;
            context.read<CatchWeightBloc>().catchWeightListResponse.updated++;
          }
          context.read<CatchWeightBloc>().updateLoader = false;
          Navigator.pop(context);
          context.read<CatchWeightBloc>().catchWeightListResponse.items.removeAt(index);
          context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is CatchWeightFailure) {
          context.read<CatchWeightBloc>().updateLoader = false;
          context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
        }
        if (state is CatchWeightError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          getIt<Widgets>().flushBarWidget(context: context, message: state.message);
        }
      },
      builder: (BuildContext context, CatchWeightState state) {
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
                      height: getIt<Functions>().getWidgetHeight(height: 44),
                      width: getIt<Functions>().getWidgetWidth(width: 44),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(context.read<CatchWeightBloc>().catchWeightListResponse.items[index].itemImage),
                            fit: BoxFit.fill,
                          )),
                    ),
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
                              context.read<CatchWeightBloc>().catchWeightListResponse.items[index].itemName,
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                  color: const Color(0xff282F3A),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          Text(
                            "${getIt<Variables>().generalVariables.currentLanguage.requiredQuantity.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].reqQuantity} ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].weightUnit}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 15), color: const Color(0xff007AFF)),
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
                            getIt<Variables>().generalVariables.currentLanguage.enterQuantity,
                            style: TextStyle(
                                color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 45),
                            child: TextFormField(
                              controller: commentsBar,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              autofocus: true,
                              inputFormatters: [
                                NumberInputFormatter(onError: (value) {
                                  context.read<CatchWeightBloc>().formatError = value;
                                  context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
                                })
                              ],
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
                                    borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xff007AFF), width: 0.73)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                suffixIcon: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: getIt<Functions>().getWidgetWidth(width: 4),
                                      vertical: getIt<Functions>().getWidgetHeight(height: 4)),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xff007AFF),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                        padding: EdgeInsets.zero),
                                    onPressed: () {
                                      if (commentsBar.text.isEmpty) {
                                        context.read<CatchWeightBloc>().textFieldEmpty = true;
                                        context.read<CatchWeightBloc>().availableQtyParticularsEmpty = false;
                                        context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
                                      } else {
                                        if (commentsBar.text == ".") {
                                          commentsBar.text = "0.0";
                                          context.read<CatchWeightBloc>().isZeroValue = true;
                                          context.read<CatchWeightBloc>().formatError = false;
                                          context.read<CatchWeightBloc>().textFieldEmpty = false;
                                          context.read<CatchWeightBloc>().availableQtyParticularsEmpty = false;
                                          context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
                                        } else if (double.parse(commentsBar.text) == 0.0) {
                                          context.read<CatchWeightBloc>().isZeroValue = true;
                                          context.read<CatchWeightBloc>().formatError = false;
                                          context.read<CatchWeightBloc>().textFieldEmpty = false;
                                          context.read<CatchWeightBloc>().availableQtyParticularsEmpty = false;
                                          context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
                                        } else {
                                          context.read<CatchWeightBloc>().isZeroValue = false;
                                          context.read<CatchWeightBloc>().chipsContentList.add(double.parse(commentsBar.text));
                                          context.read<CatchWeightBloc>().formatError = false;
                                          context.read<CatchWeightBloc>().textFieldEmpty = false;
                                          context.read<CatchWeightBloc>().availableQtyParticularsEmpty = false;
                                          double sum = context.read<CatchWeightBloc>().chipsContentList.fold(0.0, (prev, element) => prev + element);
                                          if (sum > double.parse(context.read<CatchWeightBloc>().catchWeightListResponse.items[index].reqQuantity)) {
                                            context.read<CatchWeightBloc>().chipsContentList.remove(double.parse(commentsBar.text));
                                            context.read<CatchWeightBloc>().moreQuantityError = true;
                                            context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
                                          } else {
                                            context.read<CatchWeightBloc>().moreQuantityError = false;
                                            context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
                                            commentsBar.clear();
                                          }
                                        }
                                      }
                                    },
                                    child: Text(
                                      getIt<Variables>().generalVariables.currentLanguage.enter,
                                      style: const TextStyle(color: Color(0xffffffff)),
                                    ),
                                  ),
                                ),
                                hintText: getIt<Variables>().generalVariables.currentLanguage.enterQuantity,
                                hintStyle: TextStyle(
                                  color: const Color(0xff8A8D8E),
                                  fontWeight: FontWeight.w400,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                ),
                              ),
                              validator: (value) => value!.isEmpty ? 'Please enter your comments' : null,
                            ),
                          )
                        ],
                      ),
                    ),
                    context.read<CatchWeightBloc>().availableQtyParticularsEmpty ||
                            context.read<CatchWeightBloc>().textFieldEmpty ||
                            context.read<CatchWeightBloc>().formatError ||
                            context.read<CatchWeightBloc>().moreQuantityError ||
                            context.read<CatchWeightBloc>().isZeroValue
                        ? Text(
                            context.read<CatchWeightBloc>().textFieldEmpty
                                ? getIt<Variables>().generalVariables.currentLanguage.textFieldEmpty
                                : context.read<CatchWeightBloc>().formatError
                                    ? "${getIt<Variables>().generalVariables.currentLanguage.lessThan10000} ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].weightUnit} (ex: 9999.999)."
                                    : context.read<CatchWeightBloc>().moreQuantityError
                                        ? getIt<Variables>().generalVariables.currentLanguage.moreQuantity
                                        : context.read<CatchWeightBloc>().isZeroValue
                                            ? getIt<Variables>().generalVariables.currentLanguage.zeroQuantity
                                            : context.read<CatchWeightBloc>().availableQtyParticularsEmpty
                                                ? getIt<Variables>().generalVariables.currentLanguage.didNotAddQuantity
                                                : "",
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 10)),
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 12),
                    ),
                    SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 12),
                    ),
                    chipsWidget(isUndo: false, index: index),
                    SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 45),
                    ),
                  ],
                ),
              ),
              context.read<CatchWeightBloc>().updateLoader
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
                        if (context.read<CatchWeightBloc>().chipsContentList.isEmpty) {
                          context.read<CatchWeightBloc>().textFieldEmpty = false;
                          context.read<CatchWeightBloc>().availableQtyParticularsEmpty = true;
                          context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
                        } else {
                          context.read<CatchWeightBloc>().updateLoader = true;
                          context.read<CatchWeightBloc>().textFieldEmpty = false;
                          context.read<CatchWeightBloc>().availableQtyParticularsEmpty = false;
                          context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
                          context.read<CatchWeightBloc>().availableQtyParticulars = context.read<CatchWeightBloc>().chipsContentList.join(",");
                          FocusManager.instance.primaryFocus!.unfocus();
                          context.read<CatchWeightBloc>().add(const CatchWeightUpdateEvent(isAvailable: true));
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
                            getIt<Variables>().generalVariables.currentLanguage.update.toUpperCase(),
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

  Widget unavailableContent({required int index}) {
    context.read<CatchWeightBloc>().selectedReasonName = null;
    context.read<CatchWeightBloc>().selectedItemName = null;
    return BlocConsumer<CatchWeightBloc, CatchWeightState>(
      listenWhen: (CatchWeightState previous, CatchWeightState current) {
        return previous != current;
      },
      buildWhen: (CatchWeightState previous, CatchWeightState current) {
        return previous != current;
      },
      listener: (BuildContext context, CatchWeightState state) {
        if (state is CatchWeightSuccess) {
          context.read<CatchWeightBloc>().updateLoader = false;
          Navigator.pop(context);
          context.read<CatchWeightBloc>().catchWeightListResponse.yetToUpdate--;
          context.read<CatchWeightBloc>().catchWeightListResponse.unavailable++;
          context.read<CatchWeightBloc>().catchWeightListResponse.items.removeAt(index);
          context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is CatchWeightFailure) {
          context.read<CatchWeightBloc>().updateLoader = false;
          context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
        }
        if (state is CatchWeightError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          getIt<Widgets>().flushBarWidget(context: context, message: state.message);
        }
      },
      builder: (BuildContext context, CatchWeightState state) {
        return SizedBox(
          height: getIt<Functions>().getWidgetHeight(height: 485),
          width: getIt<Functions>().getWidgetWidth(width: 600),
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
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(context.read<CatchWeightBloc>().catchWeightListResponse.items[index].itemImage),
                            fit: BoxFit.fill,
                          )),
                    ),
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
                              context.read<CatchWeightBloc>().catchWeightListResponse.items[index].itemName,
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                  color: const Color(0xff282F3A),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          Text(
                            "${getIt<Variables>().generalVariables.currentLanguage.requiredQuantity.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].reqQuantity} ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].weightUnit}",
                            maxLines: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: getIt<Functions>().getTextSize(fontSize: 15),
                                color: const Color(0xff007AFF),
                                overflow: TextOverflow.ellipsis),
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
                            child: buildDropButton(isItem: false),
                          )
                        ],
                      ),
                    ),
                    context.read<CatchWeightBloc>().selectedReasonEmpty
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
                                context.read<CatchWeightBloc>().commentTextEmpty = value.isEmpty ? true : false;
                                context.read<CatchWeightBloc>().commentText = value.isEmpty ? "" : value;
                                context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
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
                    context.read<CatchWeightBloc>().commentTextEmpty
                        ? Text(
                            getIt<Variables>().generalVariables.currentLanguage.pleaseEnterTheComments,
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
                            getIt<Variables>().generalVariables.currentLanguage.alternativeItem,
                            style: TextStyle(
                                color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 45),
                            child: buildDropButton(isItem: true),
                          )
                        ],
                      ),
                    ),
                    context.read<CatchWeightBloc>().selectItemEmpty
                        ? Text(
                            getIt<Variables>().generalVariables.currentLanguage.pleaseSelectAlterNativeItem,
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 10)),
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 45),
                    ),
                  ],
                ),
              ),
              context.read<CatchWeightBloc>().updateLoader
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
                        if (context.read<CatchWeightBloc>().selectedReason == "" || commentsBar.text == "") {
                          if (context.read<CatchWeightBloc>().selectedReason == "") {
                            context.read<CatchWeightBloc>().selectedReasonEmpty = true;
                            context.read<CatchWeightBloc>().commentTextEmpty = false;
                            context.read<CatchWeightBloc>().selectItemEmpty = false;
                            context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
                          } else if (commentsBar.text == "") {
                            context.read<CatchWeightBloc>().selectedReasonEmpty = false;
                            context.read<CatchWeightBloc>().commentTextEmpty = true;
                            context.read<CatchWeightBloc>().selectItemEmpty = false;
                            context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
                          } else {}
                        } else {
                          if (context.read<CatchWeightBloc>().selectedItem == "" && itemSearchFieldController.text.isNotEmpty) {
                            context.read<CatchWeightBloc>().selectedReasonEmpty = false;
                            context.read<CatchWeightBloc>().commentTextEmpty = false;
                            context.read<CatchWeightBloc>().selectItemEmpty = true;
                            context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
                          } else {
                            context.read<CatchWeightBloc>().updateLoader = true;
                            FocusManager.instance.primaryFocus!.unfocus();
                            context.read<CatchWeightBloc>().selectedReasonEmpty = false;
                            context.read<CatchWeightBloc>().commentTextEmpty = false;
                            context.read<CatchWeightBloc>().selectItemEmpty = false;
                            context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
                            context.read<CatchWeightBloc>().add(const CatchWeightUpdateEvent(isAvailable: false));
                          }
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

  Widget undoPickedContent({required int index}) {
    return BlocConsumer<CatchWeightBloc, CatchWeightState>(
      listenWhen: (CatchWeightState previous, CatchWeightState current) {
        return previous != current;
      },
      buildWhen: (CatchWeightState previous, CatchWeightState current) {
        return previous != current;
      },
      listener: (BuildContext context, CatchWeightState state) {
        if (state is CatchWeightSuccess) {
          context.read<CatchWeightBloc>().updateLoader = false;
          context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
          Navigator.pop(context);
          context.read<CatchWeightBloc>().catchWeightListResponse.updated--;
          context.read<CatchWeightBloc>().catchWeightListResponse.yetToUpdate++;
          context.read<CatchWeightBloc>().catchWeightListResponse.items.removeAt(index);
          context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is CatchWeightFailure) {
          context.read<CatchWeightBloc>().updateLoader = false;
          context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
        }
        if (state is CatchWeightError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          getIt<Widgets>().flushBarWidget(context: context, message: state.message);
        }
      },
      builder: (BuildContext context, CatchWeightState state) {
        return SizedBox(
          width: getIt<Functions>().getWidgetWidth(width: 600),
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
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(context.read<CatchWeightBloc>().catchWeightListResponse.items[index].itemImage),
                            fit: BoxFit.fill,
                          )),
                    ),
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
                              context.read<CatchWeightBloc>().catchWeightListResponse.items[index].itemName,
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                  color: const Color(0xff282F3A),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          Text(
                            "${getIt<Variables>().generalVariables.currentLanguage.requiredQuantity.toUpperCase()} : ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].reqQuantity} ${context.read<CatchWeightBloc>().catchWeightListResponse.items[index].weightUnit}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 15), color: const Color(0xff007AFF)),
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
                    Text(
                      getIt<Variables>().generalVariables.currentLanguage.catchWeight,
                      style: TextStyle(
                          fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                    ),
                    SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 12),
                    ),
                    chipsWidget(isUndo: true, index: index),
                    SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 45),
                    ),
                  ],
                ),
              ),
              context.read<CatchWeightBloc>().updateLoader
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
                        context.read<CatchWeightBloc>().updateLoader = true;
                        context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
                        FocusManager.instance.primaryFocus!.unfocus();
                        context.read<CatchWeightBloc>().add(const CatchWeightUndoEvent());
                      },
                      child: Container(
                        height: getIt<Functions>().getWidgetHeight(height: 50),
                        decoration: const BoxDecoration(
                          color: Color(0xffF92C38),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                        ),
                        child: Center(
                          child: Text(
                            getIt<Variables>().generalVariables.currentLanguage.undo.toUpperCase(),
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

  Widget catchWeightAlertContent() {
    return BlocConsumer<CatchWeightBloc, CatchWeightState>(
      listenWhen: (CatchWeightState previous, CatchWeightState current) {
        return previous != current;
      },
      buildWhen: (CatchWeightState previous, CatchWeightState current) {
        return previous != current;
      },
      listener: (BuildContext context, CatchWeightState state) {},
      builder: (BuildContext context, CatchWeightState state) {
        return SizedBox(
          height: getIt<Functions>().getWidgetHeight(height: 400),
          width: getIt<Functions>().getWidgetWidth(width: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/catch_weight/alert_clock.svg",
                height: getIt<Functions>().getWidgetHeight(height: 47),
                width: getIt<Functions>().getWidgetWidth(width: 47),
                fit: BoxFit.fill,
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
              Text(
                "Catch Weight Alert !",
                style: TextStyle(fontWeight: FontWeight.w400, color: const Color(0xff282F3A), fontSize: getIt<Functions>().getTextSize(fontSize: 20)),
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
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
                    height: getIt<Functions>().getWidgetHeight(height: 66),
                    width: getIt<Functions>().getWidgetWidth(width: 240),
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xffBBC6CD), width: 0.5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "37",
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: 28), fontWeight: FontWeight.w600, color: const Color(0xff007838)),
                        ),
                        Text(
                          getIt<Variables>().generalVariables.currentLanguage.requiredQty.toUpperCase(),
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w500, color: const Color(0xff282F3A)),
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
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
              Expanded(
                child: SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: 105),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "One More Night Hostel",
                        style: TextStyle(
                            fontSize: getIt<Functions>().getTextSize(fontSize: 18), color: const Color(0xff282F3A), fontWeight: FontWeight.w600),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          "Mutton Leg Boneless - Aus Origin - KG",
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: 16), color: const Color(0xff282F3A), fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text(
                        "Request By : Ava Johnson",
                        style: TextStyle(
                            fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff282F3A), fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "${getIt<Variables>().generalVariables.currentLanguage.itemCode} : MB002 | Ship to Code : SF1937",
                        style: TextStyle(
                            fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff282F3A), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 38)),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      FocusManager.instance.primaryFocus!.unfocus();
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: getIt<Functions>().getWidgetHeight(height: 50),
                      width: getIt<Functions>().getWidgetWidth(width: 300),
                      decoration: const BoxDecoration(
                        color: Color(0xffE0E7EC),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15)),
                      ),
                      child: Center(
                        child: Text(
                          'IGNORE NOW',
                          style: TextStyle(
                              color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      FocusManager.instance.primaryFocus!.unfocus();
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: getIt<Functions>().getWidgetHeight(height: 50),
                      width: getIt<Functions>().getWidgetWidth(width: 300),
                      decoration: const BoxDecoration(
                        color: Color(0xff007838),
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(15)),
                      ),
                      child: Center(
                        child: Text(
                          'ATTEND',
                          style: TextStyle(
                              color: const Color(0xffffffff), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget chipsWidget({required bool isUndo, required int index}) {
    return Wrap(
      alignment: WrapAlignment.start,
      children: List<Widget>.generate(
        context.read<CatchWeightBloc>().chipsContentList.length,
        (idx) => Container(
          height: getIt<Functions>().getWidgetHeight(height: 30),
          padding:
              EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 8), vertical: getIt<Functions>().getWidgetHeight(height: 4)),
          margin: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 8), bottom: getIt<Functions>().getWidgetHeight(height: 8)),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: isUndo ? const Color(0xff007838) : const Color(0xffEEF4FF)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              isUndo
                  ? const SizedBox()
                  : InkWell(
                      onTap: () {
                        context.read<CatchWeightBloc>().chipsContentList.removeAt(idx);
                        context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent());
                      },
                      child: SvgPicture.asset(
                        "assets/catch_weight/close-circle.svg",
                        height: getIt<Functions>().getWidgetHeight(height: 22),
                        width: getIt<Functions>().getWidgetWidth(width: 22),
                        fit: BoxFit.fill,
                      ),
                    ),
              isUndo
                  ? const SizedBox()
                  : SizedBox(
                      width: getIt<Functions>().getWidgetWidth(width: 8),
                    ),
              Text(
                context.read<CatchWeightBloc>().chipsContentList[idx].toStringAsFixed(3),
                style: TextStyle(
                  fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                  color: isUndo ? const Color(0xffffffff) : const Color(0xff1D2736),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropButton({required bool isItem}) {
    return Container(
      height: getIt<Functions>().getWidgetHeight(height: 45),
      decoration: BoxDecoration(
          color: const Color(0xffffffff), borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffE0E7EC), width: 0.73)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: isItem ? changeAltItem : changeReason,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  isItem
                      ? context.read<CatchWeightBloc>().selectedItemName ?? getIt<Variables>().generalVariables.currentLanguage.chooseItem
                      : context.read<CatchWeightBloc>().selectedReasonName ?? getIt<Variables>().generalVariables.currentLanguage.chooseReason,
                  style: isItem
                      ? TextStyle(
                          fontSize: context.read<CatchWeightBloc>().selectedItemName == null ? 12 : 15,
                          color: context.read<CatchWeightBloc>().selectedItemName == null ? Colors.grey.shade500 : Colors.black)
                      : TextStyle(
                          fontSize: context.read<CatchWeightBloc>().selectedReasonName == null ? 12 : 15,
                          color: context.read<CatchWeightBloc>().selectedReasonName == null ? Colors.grey.shade500 : Colors.black),
                ),
              ),
              isItem
                  ? context.read<CatchWeightBloc>().selectedItemName != null
                      ? InkWell(
                          onTap: () {
                            context.read<CatchWeightBloc>().selectedItemName = null;
                            context.read<CatchWeightBloc>().selectItemEmpty = false;
                            context.read<CatchWeightBloc>().selectedItem = "";
                            context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent(stillLoading: false));
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
                        )
                  : context.read<CatchWeightBloc>().selectedReasonName != null
                      ? InkWell(
                          onTap: () {
                            context.read<CatchWeightBloc>().selectedReasonName = null;
                            context.read<CatchWeightBloc>().selectedReasonEmpty = false;
                            context.read<CatchWeightBloc>().selectedReason = "";
                            context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent(stillLoading: false));
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
    List<FilterOptionsResponse> searchItems = context.read<CatchWeightBloc>().catchWeightListResponse.alternativeItems;
    for (int i = 0; i < searchItems.length; i++) {
      if (searchItems[i].id == context.read<CatchWeightBloc>().selectedItemId) {
        searchItems.removeAt(i);
      }
    }
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
                        suffixIcon: itemSearchFieldController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  itemSearchFieldController.clear();
                                  context.read<CatchWeightBloc>().selectItemEmpty = false;
                                  context.read<CatchWeightBloc>().selectedItemName = null;
                                  context.read<CatchWeightBloc>().selectedItem = "";
                                  context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent(stillLoading: false));
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
                        hintText: getIt<Variables>().generalVariables.currentLanguage.chooseItem,
                        hintStyle: TextStyle(
                            color: const Color(0xff8A8D8E), fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                    onChanged: (value) {
                      searchItems = context
                          .read<CatchWeightBloc>()
                          .catchWeightListResponse
                          .alternativeItems
                          .where((element) => element.label.toLowerCase().contains(value.toLowerCase()))
                          .toList();
                      for (int i = 0; i < searchItems.length; i++) {
                        if (searchItems[i].id == context.read<CatchWeightBloc>().selectedItemId) {
                          searchItems.removeAt(i);
                        }
                      }
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
                          context.read<CatchWeightBloc>().selectedItemName = searchItems[index].label;
                          context.read<CatchWeightBloc>().selectItemEmpty = false;
                          context.read<CatchWeightBloc>().selectedItem = searchItems[index].id;
                          context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent(stillLoading: false));
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

  Future<void> changeReason() async {
    List<ReasonItem> searchReasons = context.read<CatchWeightBloc>().catchWeightListResponse.unavailableReasons;
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
                                  context.read<CatchWeightBloc>().selectedReasonEmpty = false;
                                  context.read<CatchWeightBloc>().selectedReasonName = "";
                                  context.read<CatchWeightBloc>().selectedReason = "";
                                  context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent(stillLoading: false));
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
                      searchReasons = context
                          .read<CatchWeightBloc>()
                          .catchWeightListResponse
                          .unavailableReasons
                          .where((element) => element.description.toLowerCase().contains(value.toLowerCase()))
                          .toList();
                      if (mounted) modelSetState(() {});
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.separated(
                      itemCount: searchReasons.length,
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                      itemBuilder: (ctx, index) => ListTile(
                        title: Text(
                          searchReasons[index].description,
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.read<CatchWeightBloc>().selectedReasonName = searchReasons[index].description;
                          context.read<CatchWeightBloc>().selectedReasonEmpty = false;
                          context.read<CatchWeightBloc>().selectedReason = searchReasons[index].id;
                          context.read<CatchWeightBloc>().add(const CatchWeightSetStateEvent(stillLoading: false));
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
