// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Project imports:
import 'package:oda/bloc/back_to_store/back_to_store/back_to_store_bloc.dart';
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/edited_packages/drop_down_lib/drop_down_search_field.dart';
import 'package:oda/repository_model/back_to_store/back_to_store_list.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/resources/widgets.dart';
import 'package:oda/screens/back_to_store/add_back_store_screen.dart';
import 'package:oda/screens/home/home_screen.dart';

class BackToStoreScreen extends StatefulWidget {
  static const String id = "bts_screen";
  const BackToStoreScreen({super.key});

  @override
  State<BackToStoreScreen> createState() => _BackToStoreScreenState();
}

class _BackToStoreScreenState extends State<BackToStoreScreen> with TickerProviderStateMixin {
  TextEditingController searchBar = TextEditingController();
  TextEditingController commentsBar = TextEditingController();
  TextEditingController quantityBar = TextEditingController();
  final TextEditingController reasonSearchFieldController = TextEditingController();
  SuggestionsBoxController reasonSuggestionBoxController = SuggestionsBoxController();
  RefreshController pickedRefreshController = RefreshController();
  RefreshController yetToPickRefreshController = RefreshController();
  RefreshController unavailableRefreshController = RefreshController();
  late TabController tabController;
  Timer? timer;

  static List<String> getSuggestions({required String query, required List<String> data}) {
    List<String> matches = <String>[];
    matches.addAll(data);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  @override
  void initState() {
    FocusManager.instance.primaryFocus!.unfocus();
    getIt<Variables>().generalVariables.filters = [];
    context.read<BackToStoreBloc>().tabIndex = 0;
    tabController = TabController(length: 3, vsync: this, initialIndex: 0)
      ..addListener(() {
        if (tabController.indexIsChanging) {
          context.read<BackToStoreBloc>().pageIndex = 1;
          context.read<BackToStoreBloc>().tabIndex = tabController.index;
          context.read<BackToStoreBloc>().tabIndex = tabController.index;
          switch (context.read<BackToStoreBloc>().tabIndex) {
            case 0:
              context.read<BackToStoreBloc>().tabName = "Submitted";
            case 1:
              context.read<BackToStoreBloc>().tabName = "Updated";
            case 2:
              context.read<BackToStoreBloc>().tabName = "Not Available";
            default:
              context.read<BackToStoreBloc>().tabName = "Submitted";
          }
          context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: false));
          setState(() {});
        }
      });
    context.read<BackToStoreBloc>().add(const BackToStoreInitialEvent());
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
                BlocBuilder<BackToStoreBloc, BackToStoreState>(
                  builder: (BuildContext context, BackToStoreState state) {
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
                            Expanded(
                              child: Text(
                                getIt<Variables>().generalVariables.currentLanguage.backToStore,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 26),
                                    color: const Color(0xff282F3A)),
                              ),
                            ),
                            textBars(controller: searchBar)
                          ],
                        ),
                        actions: [
                          SizedBox(
                            width: getIt<Functions>().getWidgetWidth(width: 12),
                          ),
                          context.read<BackToStoreBloc>().backToStoreListResponse.addBtsStatus
                              ? SizedBox(
                                  height: getIt<Functions>().getWidgetHeight(height: 35),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xff007838),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(7),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 13)),
                                      ),
                                      onPressed: () {
                                        BackToStoreBloc().add(const BackToStoreSetStateEvent(stillLoading: true));
                                        getIt<Variables>().generalVariables.indexName = AddBackStoreScreen.id;
                                        getIt<Variables>().generalVariables.btsRouteList.add(BackToStoreScreen.id);
                                        context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.add_circle_outline_outlined,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: getIt<Functions>().getWidgetWidth(width: 8),
                                          ),
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.add.toUpperCase(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                              color: const Color(0xffffffff),
                                            ),
                                          )
                                        ],
                                      )),
                                )
                              : const SizedBox(),
                          IconButton(
                            onPressed: () {
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
                      BlocBuilder<BackToStoreBloc, BackToStoreState>(
                        builder: (BuildContext context, BackToStoreState state) {
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
                              padding: EdgeInsets.symmetric(
                                  vertical: getIt<Functions>().getWidgetHeight(height: 3), horizontal: getIt<Functions>().getWidgetWidth(width: 16)),
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              dividerHeight: 0.0,
                              tabs: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(child: Text(getIt<Variables>().generalVariables.currentLanguage.yetToPick.toUpperCase())),
                                    context.read<BackToStoreBloc>().backToStoreListResponse.yetToUpdate != 0
                                        ? Row(
                                            children: [
                                              SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                    vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                decoration: BoxDecoration(
                                                    color: context.read<BackToStoreBloc>().tabIndex == 0 ? Colors.white : const Color(0xff007AFF),
                                                    borderRadius: BorderRadius.circular(20)),
                                                child: Text(
                                                  context.read<BackToStoreBloc>().backToStoreListResponse.yetToUpdate < 10
                                                      ? "0${context.read<BackToStoreBloc>().backToStoreListResponse.yetToUpdate}"
                                                      : context.read<BackToStoreBloc>().backToStoreListResponse.yetToUpdate.toString(),
                                                  style: TextStyle(
                                                      color: context.read<BackToStoreBloc>().tabIndex == 0 ? const Color(0xff282F3A) : Colors.white,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              )
                                            ],
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(child: Text(getIt<Variables>().generalVariables.currentLanguage.picked.toUpperCase())),
                                    context.read<BackToStoreBloc>().backToStoreListResponse.updated != 0
                                        ? Row(
                                            children: [
                                              SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                    vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                decoration: BoxDecoration(
                                                    color: context.read<BackToStoreBloc>().tabIndex == 1 ? Colors.white : const Color(0xff007AFF),
                                                    borderRadius: BorderRadius.circular(20)),
                                                child: Text(
                                                  context.read<BackToStoreBloc>().backToStoreListResponse.updated < 10
                                                      ? "0${context.read<BackToStoreBloc>().backToStoreListResponse.updated}"
                                                      : context.read<BackToStoreBloc>().backToStoreListResponse.updated.toString(),
                                                  style: TextStyle(
                                                      color: context.read<BackToStoreBloc>().tabIndex == 1 ? const Color(0xff282F3A) : Colors.white,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              )
                                            ],
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(child: Text(getIt<Variables>().generalVariables.currentLanguage.unavailable.toUpperCase())),
                                    context.read<BackToStoreBloc>().backToStoreListResponse.unavailable != 0
                                        ? Row(
                                            children: [
                                              SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                    vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                decoration: BoxDecoration(
                                                    color: context.read<BackToStoreBloc>().tabIndex == 2 ? Colors.white : const Color(0xff007AFF),
                                                    borderRadius: BorderRadius.circular(20)),
                                                child: Text(
                                                  context.read<BackToStoreBloc>().backToStoreListResponse.unavailable < 10
                                                      ? "0${context.read<BackToStoreBloc>().backToStoreListResponse.unavailable}"
                                                      : context.read<BackToStoreBloc>().backToStoreListResponse.unavailable.toString(),
                                                  style: TextStyle(
                                                      color: context.read<BackToStoreBloc>().tabIndex == 2 ? const Color(0xff282F3A) : Colors.white,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              )
                                            ],
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: BlocConsumer<BackToStoreBloc, BackToStoreState>(
                          listenWhen: (BackToStoreState previous, BackToStoreState current) {
                            return previous != current;
                          },
                          buildWhen: (BackToStoreState previous, BackToStoreState current) {
                            return previous != current;
                          },
                          listener: (BuildContext context, BackToStoreState state) {
                            if (state is BackToStoreError) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                            }
                          },
                          builder: (BuildContext context, BackToStoreState bts) {
                            if (bts is BackToStoreLoaded) {
                              switch (context.read<BackToStoreBloc>().tabIndex) {
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
                                        context.read<BackToStoreBloc>().pageIndex = 1;
                                        context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: false));
                                        if (mounted) setState(() {});
                                        yetToPickRefreshController.refreshCompleted();
                                      },
                                      controller: yetToPickRefreshController,
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
                                        context.read<BackToStoreBloc>().pageIndex++;
                                        context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: true));
                                        if (mounted) setState(() {});
                                        yetToPickRefreshController.loadComplete();
                                      },
                                      child: context.read<BackToStoreBloc>().backToStoreListResponse.items.isEmpty
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
                                                  getIt<Variables>().generalVariables.currentLanguage.backToStoreListIsEmpty,
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
                                              itemCount: context.read<BackToStoreBloc>().backToStoreListResponse.items.length,
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int index) {
                                                return InkWell(
                                                  onTap: () {
                                                    reasonSearchFieldController.clear();
                                                    context.read<BackToStoreBloc>().selectedReason = "";
                                                    commentsBar.clear();
                                                    quantityBar.clear();
                                                    getIt<Variables>().generalVariables.popUpWidget = selectedContent(index: index);
                                                    getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(8),
                                                        border: Border.all(
                                                            color: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].id ==
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
                                                          decoration: BoxDecoration(
                                                              color: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].id ==
                                                                      getIt<Variables>().generalVariables.socketMessageId
                                                                  ? Colors.green.withOpacity(0.1)
                                                                  : Colors.transparent),
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: getIt<Functions>().getWidgetWidth(width: 20),
                                                              vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                                  '0xFF${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].typeColor}'))),
                                                                          child: Center(
                                                                            child: Text(
                                                                              context
                                                                                  .read<BackToStoreBloc>()
                                                                                  .backToStoreListResponse
                                                                                  .items[index]
                                                                                  .itemType,
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: getIt<Functions>().getTextSize(
                                                                                      fontSize: context
                                                                                                  .read<BackToStoreBloc>()
                                                                                                  .backToStoreListResponse
                                                                                                  .items[index]
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
                                                                                        .read<BackToStoreBloc>()
                                                                                        .backToStoreListResponse
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
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemCode}",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                            color: const Color(0xff8A8D8E)),
                                                                                      ),
                                                                                      const VerticalDivider(
                                                                                        color: Color(0xff8A8D8E),
                                                                                      ),
                                                                                      Text(
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.uom.toUpperCase()} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].uom}",
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
                                                                  SizedBox(
                                                                    width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                  ),
                                                                  context.read<BackToStoreBloc>().backToStoreListResponse.addBtsStatus
                                                                      ? const SizedBox()
                                                                      : IntrinsicHeight(
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  reasonSearchFieldController.clear();
                                                                                  context.read<BackToStoreBloc>().selectedReason = "";
                                                                                  commentsBar.clear();
                                                                                  quantityBar.clear();
                                                                                  context.read<BackToStoreBloc>().updateLoader = false;
                                                                                  context.read<BackToStoreBloc>().selectedReasonEmpty = false;
                                                                                  context.read<BackToStoreBloc>().hideKeyBoardReason = false;
                                                                                  getIt<Variables>().generalVariables.popUpWidget =
                                                                                      unavailableContent(index: index);
                                                                                  getIt<Functions>().showAnimatedDialog(
                                                                                      context: context, isFromTop: false, isCloseDisabled: false);
                                                                                },
                                                                                child: Text(
                                                                                  getIt<Variables>()
                                                                                      .generalVariables
                                                                                      .currentLanguage
                                                                                      .unavailable
                                                                                      .toUpperCase(),
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
                                                                                  reasonSearchFieldController.clear();
                                                                                  context.read<BackToStoreBloc>().selectedReason = "";
                                                                                  commentsBar.clear();
                                                                                  quantityBar.clear();
                                                                                  context.read<BackToStoreBloc>().updateLoader = false;
                                                                                  context.read<BackToStoreBloc>().textFieldEmpty = false;
                                                                                  context.read<BackToStoreBloc>().formatError = false;
                                                                                  context.read<BackToStoreBloc>().moreQuantityError = false;
                                                                                  context.read<BackToStoreBloc>().isZeroValue = false;
                                                                                  getIt<Variables>().generalVariables.popUpWidget =
                                                                                      availableContent(index: index);
                                                                                  getIt<Functions>().showAnimatedDialog(
                                                                                      context: context, isFromTop: false, isCloseDisabled: false);
                                                                                },
                                                                                child: Text(
                                                                                  getIt<Variables>()
                                                                                      .generalVariables
                                                                                      .currentLanguage
                                                                                      .picked
                                                                                      .toUpperCase(),
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
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Expanded(
                                                                    child: SingleChildScrollView(
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                                                                      .entryTime
                                                                                      .toUpperCase(),
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                      color: const Color(0xff8A8D8E)),
                                                                                ),
                                                                                Text(
                                                                                  context
                                                                                      .read<BackToStoreBloc>()
                                                                                      .backToStoreListResponse
                                                                                      .items[index]
                                                                                      .entryTime,
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
                                                                                      .reported
                                                                                      .toUpperCase(),
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                      color: const Color(0xff8A8D8E)),
                                                                                ),
                                                                                Text(
                                                                                  context
                                                                                      .read<BackToStoreBloc>()
                                                                                      .backToStoreListResponse
                                                                                      .items[index]
                                                                                      .requestedBy,
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
                                                                                      .location
                                                                                      .toUpperCase(),
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                      color: const Color(0xff8A8D8E)),
                                                                                ),
                                                                                Text(
                                                                                  context
                                                                                      .read<BackToStoreBloc>()
                                                                                      .backToStoreListResponse
                                                                                      .items[index]
                                                                                      .location,
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
                                                                    width: getIt<Functions>().getWidgetWidth(width: 60),
                                                                  ),
                                                                  SizedBox(
                                                                    width: getIt<Functions>().getWidgetWidth(width: 150),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                      children: [
                                                                        Text(
                                                                          context
                                                                              .read<BackToStoreBloc>()
                                                                              .backToStoreListResponse
                                                                              .items[index]
                                                                              .quantity,
                                                                          style: TextStyle(
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                              fontWeight: FontWeight.w600,
                                                                              color: const Color(0xff007AFF)),
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
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          height: getIt<Functions>().getWidgetHeight(height: 44),
                                                          decoration: BoxDecoration(
                                                            color: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].id ==
                                                                    getIt<Variables>().generalVariables.socketMessageId
                                                                ? Colors.green.withOpacity(0.1)
                                                                : const Color(0xffCDE5FF),
                                                            borderRadius: const BorderRadius.only(
                                                                bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                                          ),
                                                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      "${getIt<Variables>().generalVariables.currentLanguage.source.toUpperCase()}  :  ",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      color: const Color(0xff282F3A),
                                                                      fontWeight: FontWeight.w500),
                                                                  children: [
                                                                    TextSpan(
                                                                        text: context
                                                                            .read<BackToStoreBloc>()
                                                                            .backToStoreListResponse
                                                                            .items[index]
                                                                            .source,
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
                                                                      "${getIt<Variables>().generalVariables.currentLanguage.reason.toUpperCase()}  :  ",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      color: const Color(0xff282F3A),
                                                                      fontWeight: FontWeight.w500),
                                                                  children: [
                                                                    TextSpan(
                                                                        text: context
                                                                            .read<BackToStoreBloc>()
                                                                            .backToStoreListResponse
                                                                            .items[index]
                                                                            .btsReason,
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
                                        context.read<BackToStoreBloc>().pageIndex = 1;
                                        context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: false));
                                        if (mounted) setState(() {});
                                        pickedRefreshController.refreshCompleted();
                                      },
                                      controller: pickedRefreshController,
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
                                        context.read<BackToStoreBloc>().pageIndex++;
                                        context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: true));
                                        if (mounted) setState(() {});
                                        pickedRefreshController.loadComplete();
                                      },
                                      child: context.read<BackToStoreBloc>().backToStoreListResponse.items.isEmpty
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
                                                  getIt<Variables>().generalVariables.currentLanguage.backToStoreListIsEmpty,
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
                                              itemCount: context.read<BackToStoreBloc>().backToStoreListResponse.items.length,
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int index) {
                                                return InkWell(
                                                  onTap: () {
                                                    reasonSearchFieldController.clear();
                                                    context.read<BackToStoreBloc>().selectedReason = "";
                                                    commentsBar.clear();
                                                    quantityBar.clear();
                                                    getIt<Variables>().generalVariables.popUpWidget = selectedContent(index: index);
                                                    getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
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
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: getIt<Functions>().getWidgetWidth(width: 20),
                                                              vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(
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
                                                                                  '0xFF${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].typeColor}'))),
                                                                          child: Center(
                                                                            child: Text(
                                                                              context
                                                                                  .read<BackToStoreBloc>()
                                                                                  .backToStoreListResponse
                                                                                  .items[index]
                                                                                  .itemType,
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: getIt<Functions>().getTextSize(
                                                                                      fontSize: context
                                                                                                  .read<BackToStoreBloc>()
                                                                                                  .backToStoreListResponse
                                                                                                  .items[index]
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
                                                                                        .read<BackToStoreBloc>()
                                                                                        .backToStoreListResponse
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
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemCode}",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                            color: const Color(0xff8A8D8E)),
                                                                                      ),
                                                                                      const VerticalDivider(
                                                                                        color: Color(0xff8A8D8E),
                                                                                      ),
                                                                                      Text(
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.uom.toUpperCase()} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].uom}",
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
                                                                  SizedBox(
                                                                    width: getIt<Functions>().getWidgetWidth(width: 150),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                      children: [
                                                                        Text(
                                                                          context
                                                                              .read<BackToStoreBloc>()
                                                                              .backToStoreListResponse
                                                                              .items[index]
                                                                              .pickedQty,
                                                                          style: TextStyle(
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                              fontWeight: FontWeight.w600,
                                                                              color: const Color(0xff007838)),
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
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                                              ),
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 57),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
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
                                                                                    .entryTime
                                                                                    .toUpperCase(),
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 7)),
                                                                              Text(
                                                                                context
                                                                                    .read<BackToStoreBloc>()
                                                                                    .backToStoreListResponse
                                                                                    .items[index]
                                                                                    .entryTime,
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff282F3A)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(width: getIt<Functions>().getWidgetWidth(width: 45)),
                                                                          Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                getIt<Variables>()
                                                                                    .generalVariables
                                                                                    .currentLanguage
                                                                                    .reported
                                                                                    .toUpperCase(),
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 7)),
                                                                              Text(
                                                                                context
                                                                                    .read<BackToStoreBloc>()
                                                                                    .backToStoreListResponse
                                                                                    .items[index]
                                                                                    .requestedBy,
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff282F3A)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(width: getIt<Functions>().getWidgetWidth(width: 45)),
                                                                          Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                getIt<Variables>()
                                                                                    .generalVariables
                                                                                    .currentLanguage
                                                                                    .location
                                                                                    .toUpperCase(),
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 7)),
                                                                              Text(
                                                                                context
                                                                                    .read<BackToStoreBloc>()
                                                                                    .backToStoreListResponse
                                                                                    .items[index]
                                                                                    .location,
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff282F3A)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(width: getIt<Functions>().getWidgetWidth(width: 45)),
                                                                          Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                getIt<Variables>()
                                                                                    .generalVariables
                                                                                    .currentLanguage
                                                                                    .updatedBy
                                                                                    .toUpperCase(),
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 7)),
                                                                              Text(
                                                                                context
                                                                                    .read<BackToStoreBloc>()
                                                                                    .backToStoreListResponse
                                                                                    .items[index]
                                                                                    .updatedBy,
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff282F3A)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(width: getIt<Functions>().getWidgetWidth(width: 45)),
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
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 7)),
                                                                              Text(
                                                                                context
                                                                                    .read<BackToStoreBloc>()
                                                                                    .backToStoreListResponse
                                                                                    .items[index]
                                                                                    .updatedTime,
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
                                                                      "${getIt<Variables>().generalVariables.currentLanguage.source.toUpperCase()} :  ",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      color: const Color(0xff282F3A),
                                                                      fontWeight: FontWeight.w500),
                                                                  children: [
                                                                    TextSpan(
                                                                        text: context
                                                                            .read<BackToStoreBloc>()
                                                                            .backToStoreListResponse
                                                                            .items[index]
                                                                            .source,
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
                                                                      "${getIt<Variables>().generalVariables.currentLanguage.reason.toUpperCase()}  :  ",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      color: const Color(0xff282F3A),
                                                                      fontWeight: FontWeight.w500),
                                                                  children: [
                                                                    TextSpan(
                                                                        text: context
                                                                            .read<BackToStoreBloc>()
                                                                            .backToStoreListResponse
                                                                            .items[index]
                                                                            .btsReason,
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
                                        context.read<BackToStoreBloc>().pageIndex = 1;
                                        context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: false));
                                        if (mounted) setState(() {});
                                        unavailableRefreshController.refreshCompleted();
                                      },
                                      controller: unavailableRefreshController,
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
                                        context.read<BackToStoreBloc>().pageIndex++;
                                        context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: true));
                                        if (mounted) setState(() {});
                                        unavailableRefreshController.loadComplete();
                                      },
                                      child: context.read<BackToStoreBloc>().backToStoreListResponse.items.isEmpty
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
                                                  getIt<Variables>().generalVariables.currentLanguage.backToStoreListIsEmpty,
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
                                              itemCount: context.read<BackToStoreBloc>().backToStoreListResponse.items.length,
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int index) {
                                                return InkWell(
                                                  onTap: () {
                                                    reasonSearchFieldController.clear();
                                                    context.read<BackToStoreBloc>().selectedReason = "";
                                                    commentsBar.clear();
                                                    quantityBar.clear();
                                                    context.read<BackToStoreBloc>().updateLoader = false;
                                                    context.read<BackToStoreBloc>().textFieldEmpty = false;
                                                    context.read<BackToStoreBloc>().formatError = false;
                                                    context.read<BackToStoreBloc>().moreQuantityError = false;
                                                    context.read<BackToStoreBloc>().isZeroValue = false;
                                                    getIt<Variables>().generalVariables.popUpWidget =
                                                        context.read<BackToStoreBloc>().backToStoreListResponse.addBtsStatus
                                                            ? selectedContent(index: index)
                                                            : availableContent(index: index);
                                                    getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
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
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: getIt<Functions>().getWidgetWidth(width: 20),
                                                              vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(
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
                                                                                  '0xFF${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].typeColor}'))),
                                                                          child: Center(
                                                                            child: Text(
                                                                              context
                                                                                  .read<BackToStoreBloc>()
                                                                                  .backToStoreListResponse
                                                                                  .items[index]
                                                                                  .itemType,
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: getIt<Functions>().getTextSize(
                                                                                      fontSize: context
                                                                                                  .read<BackToStoreBloc>()
                                                                                                  .backToStoreListResponse
                                                                                                  .items[index]
                                                                                                  .itemType
                                                                                                  .length >=
                                                                                              2
                                                                                          ? 20
                                                                                          : 24),
                                                                                  color: const Color(0xffFFFFFF)),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                        ),
                                                                        Expanded(
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
                                                                                        .read<BackToStoreBloc>()
                                                                                        .backToStoreListResponse
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
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemCode}",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                            color: const Color(0xff8A8D8E)),
                                                                                      ),
                                                                                      const VerticalDivider(
                                                                                        color: Color(0xff8A8D8E),
                                                                                      ),
                                                                                      Text(
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.uom.toUpperCase()} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].uom}",
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
                                                                  SizedBox(
                                                                    width: getIt<Functions>().getWidgetWidth(width: 150),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                      children: [
                                                                        Text(
                                                                          context
                                                                              .read<BackToStoreBloc>()
                                                                              .backToStoreListResponse
                                                                              .items[index]
                                                                              .quantity,
                                                                          style: TextStyle(
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                              fontWeight: FontWeight.w600,
                                                                              color: const Color(0xffF92C38)),
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
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                                              ),
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 57),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
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
                                                                                    .entryTime
                                                                                    .toUpperCase(),
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 7)),
                                                                              Text(
                                                                                context
                                                                                    .read<BackToStoreBloc>()
                                                                                    .backToStoreListResponse
                                                                                    .items[index]
                                                                                    .entryTime,
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff282F3A)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(width: getIt<Functions>().getWidgetWidth(width: 43)),
                                                                          Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                getIt<Variables>()
                                                                                    .generalVariables
                                                                                    .currentLanguage
                                                                                    .reported
                                                                                    .toUpperCase(),
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 7)),
                                                                              Text(
                                                                                context
                                                                                    .read<BackToStoreBloc>()
                                                                                    .backToStoreListResponse
                                                                                    .items[index]
                                                                                    .requestedBy,
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff282F3A)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(width: getIt<Functions>().getWidgetWidth(width: 43)),
                                                                          Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                getIt<Variables>()
                                                                                    .generalVariables
                                                                                    .currentLanguage
                                                                                    .location
                                                                                    .toUpperCase(),
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 7)),
                                                                              Text(
                                                                                context
                                                                                    .read<BackToStoreBloc>()
                                                                                    .backToStoreListResponse
                                                                                    .items[index]
                                                                                    .location,
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff282F3A)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(width: getIt<Functions>().getWidgetWidth(width: 43)),
                                                                          Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                getIt<Variables>()
                                                                                    .generalVariables
                                                                                    .currentLanguage
                                                                                    .updatedBy
                                                                                    .toUpperCase(),
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 7)),
                                                                              Text(
                                                                                context
                                                                                    .read<BackToStoreBloc>()
                                                                                    .backToStoreListResponse
                                                                                    .items[index]
                                                                                    .updatedBy,
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff282F3A)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(width: getIt<Functions>().getWidgetWidth(width: 43)),
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
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 7)),
                                                                              Text(
                                                                                context
                                                                                    .read<BackToStoreBloc>()
                                                                                    .backToStoreListResponse
                                                                                    .items[index]
                                                                                    .updatedTime,
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
                                                                      "${getIt<Variables>().generalVariables.currentLanguage.source.toUpperCase()}  :  ",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      color: const Color(0xff282F3A),
                                                                      fontWeight: FontWeight.w500),
                                                                  children: [
                                                                    TextSpan(
                                                                        text: context
                                                                            .read<BackToStoreBloc>()
                                                                            .backToStoreListResponse
                                                                            .items[index]
                                                                            .source,
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
                                                                      "${getIt<Variables>().generalVariables.currentLanguage.reason.toUpperCase()}  :  ",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      color: const Color(0xff282F3A),
                                                                      fontWeight: FontWeight.w500),
                                                                  children: [
                                                                    TextSpan(
                                                                        text: context
                                                                            .read<BackToStoreBloc>()
                                                                            .backToStoreListResponse
                                                                            .items[index]
                                                                            .btsReason,
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
                                        context.read<BackToStoreBloc>().pageIndex = 1;
                                        context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: false));
                                        if (mounted) setState(() {});
                                        yetToPickRefreshController.refreshCompleted();
                                      },
                                      controller: yetToPickRefreshController,
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
                                        context.read<BackToStoreBloc>().pageIndex++;
                                        context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: true));
                                        if (mounted) setState(() {});
                                        yetToPickRefreshController.loadComplete();
                                      },
                                      child: context.read<BackToStoreBloc>().backToStoreListResponse.items.isEmpty
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
                                                  getIt<Variables>().generalVariables.currentLanguage.backToStoreListIsEmpty,
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
                                              itemCount: context.read<BackToStoreBloc>().backToStoreListResponse.items.length,
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int index) {
                                                return InkWell(
                                                  onTap: () {
                                                    reasonSearchFieldController.clear();
                                                    context.read<BackToStoreBloc>().selectedReason = "";
                                                    commentsBar.clear();
                                                    quantityBar.clear();
                                                    getIt<Variables>().generalVariables.popUpWidget = selectedContent(index: index);
                                                    getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
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
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: getIt<Functions>().getWidgetWidth(width: 20),
                                                              vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                                  '0xFF${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].typeColor}'))),
                                                                          child: Center(
                                                                            child: Text(
                                                                              context
                                                                                  .read<BackToStoreBloc>()
                                                                                  .backToStoreListResponse
                                                                                  .items[index]
                                                                                  .itemType,
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: getIt<Functions>().getTextSize(
                                                                                      fontSize: context
                                                                                                  .read<BackToStoreBloc>()
                                                                                                  .backToStoreListResponse
                                                                                                  .items[index]
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
                                                                                        .read<BackToStoreBloc>()
                                                                                        .backToStoreListResponse
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
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemCode}",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                            color: const Color(0xff8A8D8E)),
                                                                                      ),
                                                                                      const VerticalDivider(
                                                                                        color: Color(0xff8A8D8E),
                                                                                      ),
                                                                                      Text(
                                                                                        "${getIt<Variables>().generalVariables.currentLanguage.uom.toUpperCase()} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].uom}",
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
                                                                  SizedBox(
                                                                    width: getIt<Functions>().getWidgetWidth(width: 20),
                                                                  ),
                                                                  IntrinsicHeight(
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap: () {
                                                                            reasonSearchFieldController.clear();
                                                                            context.read<BackToStoreBloc>().selectedReason = "";
                                                                            commentsBar.clear();
                                                                            quantityBar.clear();
                                                                            context.read<BackToStoreBloc>().updateLoader = false;
                                                                            context.read<BackToStoreBloc>().selectedReasonEmpty = false;
                                                                            context.read<BackToStoreBloc>().hideKeyBoardReason = false;
                                                                            getIt<Variables>().generalVariables.popUpWidget =
                                                                                unavailableContent(index: index);
                                                                            getIt<Functions>().showAnimatedDialog(
                                                                                context: context, isFromTop: false, isCloseDisabled: false);
                                                                          },
                                                                          child: Text(
                                                                            getIt<Variables>()
                                                                                .generalVariables
                                                                                .currentLanguage
                                                                                .unavailable
                                                                                .toUpperCase(),
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
                                                                            reasonSearchFieldController.clear();
                                                                            context.read<BackToStoreBloc>().selectedReason = "";
                                                                            commentsBar.clear();
                                                                            quantityBar.clear();
                                                                            context.read<BackToStoreBloc>().updateLoader = false;
                                                                            context.read<BackToStoreBloc>().textFieldEmpty = false;
                                                                            context.read<BackToStoreBloc>().formatError = false;
                                                                            context.read<BackToStoreBloc>().moreQuantityError = false;
                                                                            context.read<BackToStoreBloc>().isZeroValue = false;
                                                                            getIt<Variables>().generalVariables.popUpWidget =
                                                                                availableContent(index: index);
                                                                            getIt<Functions>().showAnimatedDialog(
                                                                                context: context, isFromTop: false, isCloseDisabled: false);
                                                                          },
                                                                          child: Text(
                                                                            getIt<Variables>().generalVariables.currentLanguage.picked.toUpperCase(),
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
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Expanded(
                                                                    child: SingleChildScrollView(
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                                                                      .entryTime
                                                                                      .toUpperCase(),
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                      color: const Color(0xff8A8D8E)),
                                                                                ),
                                                                                Text(
                                                                                  context
                                                                                      .read<BackToStoreBloc>()
                                                                                      .backToStoreListResponse
                                                                                      .items[index]
                                                                                      .entryTime,
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
                                                                                      .reported
                                                                                      .toUpperCase(),
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                      color: const Color(0xff8A8D8E)),
                                                                                ),
                                                                                Text(
                                                                                  context
                                                                                      .read<BackToStoreBloc>()
                                                                                      .backToStoreListResponse
                                                                                      .items[index]
                                                                                      .requestedBy,
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
                                                                                      .location
                                                                                      .toUpperCase(),
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                      color: const Color(0xff8A8D8E)),
                                                                                ),
                                                                                Text(
                                                                                  context
                                                                                      .read<BackToStoreBloc>()
                                                                                      .backToStoreListResponse
                                                                                      .items[index]
                                                                                      .location,
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
                                                                    width: getIt<Functions>().getWidgetWidth(width: 60),
                                                                  ),
                                                                  SizedBox(
                                                                    width: getIt<Functions>().getWidgetWidth(width: 150),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                      children: [
                                                                        Text(
                                                                          context
                                                                              .read<BackToStoreBloc>()
                                                                              .backToStoreListResponse
                                                                              .items[index]
                                                                              .quantity,
                                                                          style: TextStyle(
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 28),
                                                                              fontWeight: FontWeight.w600,
                                                                              color: const Color(0xff007AFF)),
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
                                                                      "${getIt<Variables>().generalVariables.currentLanguage.source.toUpperCase()}  :  ",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      color: const Color(0xff282F3A),
                                                                      fontWeight: FontWeight.w500),
                                                                  children: [
                                                                    TextSpan(
                                                                        text: context
                                                                            .read<BackToStoreBloc>()
                                                                            .backToStoreListResponse
                                                                            .items[index]
                                                                            .source,
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
                                                                      "${getIt<Variables>().generalVariables.currentLanguage.reason.toUpperCase()}  :  ",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      color: const Color(0xff282F3A),
                                                                      fontWeight: FontWeight.w500),
                                                                  children: [
                                                                    TextSpan(
                                                                        text: context
                                                                            .read<BackToStoreBloc>()
                                                                            .backToStoreListResponse
                                                                            .items[index]
                                                                            .btsReason,
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
                                                  ),
                                                );
                                              }),
                                    ),
                                  );
                              }
                            } else if (bts is BackToStoreLoading) {
                              switch (context.read<BackToStoreBloc>().tabIndex) {
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
                                            return InkWell(
                                              onTap: () {},
                                              child: Container(
                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
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
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        'ItemType',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                            color: const Color(0xFFFFFFFF)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                  ),
                                                                  SizedBox(
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 280),
                                                                          child: Text(
                                                                            'Item Name',
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
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
                                                                                "Item Code",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              const VerticalDivider(
                                                                                color: Color(0xff8A8D8E),
                                                                              ),
                                                                              Text(
                                                                                "Uom : kg",
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
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 16),
                                                          ),
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 50),
                                                            child: ListView(
                                                              scrollDirection: Axis.horizontal,
                                                              children: [
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      'Entry Time',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      '11/02/24',
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
                                                                      'Reported',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      'John smith',
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
                                                                      'location',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      'location',
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
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      'Quantity',
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xff007AFF)),
                                                                    ),
                                                                    Text(
                                                                      'Quantity',
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
                                                              text: "Reason  :  ",
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                  color: const Color(0xff282F3A),
                                                                  fontWeight: FontWeight.w500),
                                                              children: [
                                                                TextSpan(
                                                                    text: 'Reason',
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xffF92C38),
                                                                        fontWeight: FontWeight.w500)),
                                                              ],
                                                            ),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: "Reason  :  ",
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                  color: const Color(0xff282F3A),
                                                                  fontWeight: FontWeight.w500),
                                                              children: [
                                                                TextSpan(
                                                                    text: 'Reason',
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xffF92C38),
                                                                        fontWeight: FontWeight.w500)),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                                            return InkWell(
                                              onTap: () {},
                                              child: Container(
                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
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
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        'ItemType',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                            color: const Color(0xFFFFFFFF)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                  ),
                                                                  SizedBox(
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 280),
                                                                          child: Text(
                                                                            'Item Name',
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
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
                                                                                "Item Code",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              const VerticalDivider(
                                                                                color: Color(0xff8A8D8E),
                                                                              ),
                                                                              Text(
                                                                                "Uom : kg",
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
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 16),
                                                          ),
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 50),
                                                            child: ListView(
                                                              scrollDirection: Axis.horizontal,
                                                              children: [
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      'Entry Time',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      '11/02/24',
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
                                                                      'Reported',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      'John smith',
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
                                                                      'location',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      'location',
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
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      'Quantity',
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xff007AFF)),
                                                                    ),
                                                                    Text(
                                                                      'Quantity',
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
                                                              text: "Reason  :  ",
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                  color: const Color(0xff282F3A),
                                                                  fontWeight: FontWeight.w500),
                                                              children: [
                                                                TextSpan(
                                                                    text: 'Reason',
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xffF92C38),
                                                                        fontWeight: FontWeight.w500)),
                                                              ],
                                                            ),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: "Reason  :  ",
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                  color: const Color(0xff282F3A),
                                                                  fontWeight: FontWeight.w500),
                                                              children: [
                                                                TextSpan(
                                                                    text: 'Reason',
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xffF92C38),
                                                                        fontWeight: FontWeight.w500)),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                                            return InkWell(
                                              onTap: () {},
                                              child: Container(
                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
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
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        'ItemType',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                            color: const Color(0xFFFFFFFF)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                  ),
                                                                  SizedBox(
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 280),
                                                                          child: Text(
                                                                            'Item Name',
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
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
                                                                                "Item Code",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              const VerticalDivider(
                                                                                color: Color(0xff8A8D8E),
                                                                              ),
                                                                              Text(
                                                                                "Uom : kg",
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
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 16),
                                                          ),
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 50),
                                                            child: ListView(
                                                              scrollDirection: Axis.horizontal,
                                                              children: [
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      'Entry Time',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      '11/02/24',
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
                                                                      'Reported',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      'John smith',
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
                                                                      'location',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      'location',
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
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      'Quantity',
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xff007AFF)),
                                                                    ),
                                                                    Text(
                                                                      'Quantity',
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
                                                              text: "Reason  :  ",
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                  color: const Color(0xff282F3A),
                                                                  fontWeight: FontWeight.w500),
                                                              children: [
                                                                TextSpan(
                                                                    text: 'Reason',
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xffF92C38),
                                                                        fontWeight: FontWeight.w500)),
                                                              ],
                                                            ),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: "Reason  :  ",
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                  color: const Color(0xff282F3A),
                                                                  fontWeight: FontWeight.w500),
                                                              children: [
                                                                TextSpan(
                                                                    text: 'Reason',
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xffF92C38),
                                                                        fontWeight: FontWeight.w500)),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                                            return InkWell(
                                              onTap: () {},
                                              child: Container(
                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                                margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
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
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        'ItemType',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                            color: const Color(0xFFFFFFFF)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                  ),
                                                                  SizedBox(
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 280),
                                                                          child: Text(
                                                                            'Item Name',
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
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
                                                                                "Item Code",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              const VerticalDivider(
                                                                                color: Color(0xff8A8D8E),
                                                                              ),
                                                                              Text(
                                                                                "Uom : kg",
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
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 16),
                                                          ),
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 50),
                                                            child: ListView(
                                                              scrollDirection: Axis.horizontal,
                                                              children: [
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      'Entry Time',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      '11/02/24',
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
                                                                      'Reported',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      'John smith',
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
                                                                      'location',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      'location',
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
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      'Quantity',
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xff007AFF)),
                                                                    ),
                                                                    Text(
                                                                      'Quantity',
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
                                                              text: "Reason  :  ",
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                  color: const Color(0xff282F3A),
                                                                  fontWeight: FontWeight.w500),
                                                              children: [
                                                                TextSpan(
                                                                    text: 'Reason',
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xffF92C38),
                                                                        fontWeight: FontWeight.w500)),
                                                              ],
                                                            ),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: "Reason  :  ",
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                  color: const Color(0xff282F3A),
                                                                  fontWeight: FontWeight.w500),
                                                              children: [
                                                                TextSpan(
                                                                    text: 'Reason',
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xffF92C38),
                                                                        fontWeight: FontWeight.w500)),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                BlocBuilder<BackToStoreBloc, BackToStoreState>(
                  builder: (BuildContext context, BackToStoreState state) {
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
                                  Expanded(
                                    child: Text(
                                      getIt<Variables>().generalVariables.currentLanguage.backToStore,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: getIt<Functions>().getTextSize(fontSize: 26),
                                          color: const Color(0xff282F3A)),
                                    ),
                                  ),
                                ],
                              ),
                              secondChild: textBars(controller: searchBar),
                              crossFadeState: context.read<BackToStoreBloc>().searchBarEnabled ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 100),
                            ),
                            actions: [
                              SizedBox(
                                width: getIt<Functions>().getWidgetWidth(width: 8),
                              ),
                              context.read<BackToStoreBloc>().backToStoreListResponse.addBtsStatus
                                  ? InkWell(
                                      onTap: state is BackToStoreLoading
                                          ? () {}
                                          : () {
                                              BackToStoreBloc().add(const BackToStoreSetStateEvent(stillLoading: true));
                                              getIt<Variables>().generalVariables.indexName = AddBackStoreScreen.id;
                                              getIt<Variables>().generalVariables.btsRouteList.add(BackToStoreScreen.id);
                                              context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                            },
                                      child: Container(
                                        height: getIt<Functions>().getWidgetHeight(height: 35.44),
                                        width: getIt<Functions>().getWidgetWidth(width: 35.44),
                                        margin: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 14.56)),
                                        decoration: const BoxDecoration(color: Color(0xff007838), shape: BoxShape.circle),
                                        child: const Icon(
                                          Icons.add_circle_outline_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: BackToStoreState is BackToStoreLoading
                                    ? () {}
                                    : () {
                                        context.read<BackToStoreBloc>().searchBarEnabled = !context.read<BackToStoreBloc>().searchBarEnabled;
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
                                onTap: BackToStoreState is BackToStoreLoading
                                    ? () {}
                                    : () {
                                        getIt<Variables>().generalVariables.filterSelectedMainIndex = 0;
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
                      BlocBuilder<BackToStoreBloc, BackToStoreState>(
                        builder: (BuildContext context, BackToStoreState state) {
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Flexible(child: Text(getIt<Variables>().generalVariables.currentLanguage.yetToPick.toUpperCase())),
                                      context.read<BackToStoreBloc>().backToStoreListResponse.yetToUpdate != 0
                                          ? Row(
                                              children: [
                                                SizedBox(width: getIt<Functions>().getWidgetWidth(width: 7)),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                      vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                  decoration: BoxDecoration(
                                                      color: context.read<BackToStoreBloc>().tabIndex == 0 ? Colors.white : const Color(0xff007AFF),
                                                      borderRadius: BorderRadius.circular(20)),
                                                  child: Text(
                                                    context.read<BackToStoreBloc>().backToStoreListResponse.yetToUpdate < 10
                                                        ? "0${context.read<BackToStoreBloc>().backToStoreListResponse.yetToUpdate}"
                                                        : context.read<BackToStoreBloc>().backToStoreListResponse.yetToUpdate.toString(),
                                                    style: TextStyle(
                                                        color: context.read<BackToStoreBloc>().tabIndex == 0 ? const Color(0xff282F3A) : Colors.white,
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 8),
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                )
                                              ],
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                                Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Flexible(child: Text(getIt<Variables>().generalVariables.currentLanguage.picked.toUpperCase())),
                                      context.read<BackToStoreBloc>().backToStoreListResponse.updated != 0
                                          ? Row(
                                              children: [
                                                SizedBox(width: getIt<Functions>().getWidgetWidth(width: 7)),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                      vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                  decoration: BoxDecoration(
                                                      color: context.read<BackToStoreBloc>().tabIndex == 1 ? Colors.white : const Color(0xff007AFF),
                                                      borderRadius: BorderRadius.circular(20)),
                                                  child: Text(
                                                    context.read<BackToStoreBloc>().backToStoreListResponse.updated < 10
                                                        ? "0${context.read<BackToStoreBloc>().backToStoreListResponse.updated}"
                                                        : context.read<BackToStoreBloc>().backToStoreListResponse.updated.toString(),
                                                    style: TextStyle(
                                                        color: context.read<BackToStoreBloc>().tabIndex == 1 ? const Color(0xff282F3A) : Colors.white,
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 8),
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                )
                                              ],
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                                Tab(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(child: Text(getIt<Variables>().generalVariables.currentLanguage.unavailable.toUpperCase())),
                                    context.read<BackToStoreBloc>().backToStoreListResponse.unavailable != 0
                                        ? Row(
                                            children: [
                                              SizedBox(width: getIt<Functions>().getWidgetWidth(width: 7)),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: getIt<Functions>().getWidgetWidth(width: 6),
                                                    vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                decoration: BoxDecoration(
                                                    color: context.read<BackToStoreBloc>().tabIndex == 2 ? Colors.white : const Color(0xff007AFF),
                                                    borderRadius: BorderRadius.circular(20)),
                                                child: Text(
                                                  context.read<BackToStoreBloc>().backToStoreListResponse.unavailable < 10
                                                      ? "0${context.read<BackToStoreBloc>().backToStoreListResponse.unavailable}"
                                                      : context.read<BackToStoreBloc>().backToStoreListResponse.unavailable.toString(),
                                                  style: TextStyle(
                                                      color: context.read<BackToStoreBloc>().tabIndex == 2 ? const Color(0xff282F3A) : Colors.white,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 8),
                                                      fontWeight: FontWeight.w700),
                                                ),
                                              )
                                            ],
                                          )
                                        : const SizedBox(),
                                  ],
                                )),
                              ],
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: BlocConsumer<BackToStoreBloc, BackToStoreState>(
                          listenWhen: (BackToStoreState previous, BackToStoreState current) {
                            return previous != current;
                          },
                          buildWhen: (BackToStoreState previous, BackToStoreState current) {
                            return previous != current;
                          },
                          listener: (BuildContext context, BackToStoreState state) {
                            if (state is BackToStoreError) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                            }
                          },
                          builder: (BuildContext context, BackToStoreState bts) {
                            if (bts is BackToStoreLoaded) {
                              switch (context.read<BackToStoreBloc>().tabIndex) {
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
                                        context.read<BackToStoreBloc>().pageIndex = 1;
                                        context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: false));
                                        if (mounted) setState(() {});
                                        yetToPickRefreshController.refreshCompleted();
                                      },
                                      controller: yetToPickRefreshController,
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
                                        context.read<BackToStoreBloc>().pageIndex++;
                                        context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: true));
                                        if (mounted) setState(() {});
                                        yetToPickRefreshController.loadComplete();
                                      },
                                      child: context.read<BackToStoreBloc>().backToStoreListResponse.items.isEmpty
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
                                                  getIt<Variables>().generalVariables.currentLanguage.backToStoreListIsEmpty,
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
                                              itemCount: context.read<BackToStoreBloc>().backToStoreListResponse.items.length,
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int index) {
                                                return InkWell(
                                                  onTap: () {
                                                    reasonSearchFieldController.clear();
                                                    context.read<BackToStoreBloc>().selectedReason = "";
                                                    commentsBar.clear();
                                                    quantityBar.clear();
                                                    getIt<Variables>().generalVariables.popUpWidget = selectedContent(index: index);
                                                    getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
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
                                                          width: double.infinity,
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
                                                                child: SizedBox(
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                          "${getIt<Variables>().generalVariables.currentLanguage.source.toUpperCase()}  :  ",
                                                                          style: TextStyle(
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xff282F3A),
                                                                              fontWeight: FontWeight.w600)),
                                                                      Text(
                                                                          context.read<BackToStoreBloc>().backToStoreListResponse.items[index].source,
                                                                          style: TextStyle(
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                              color: const Color(0xffF92C38),
                                                                              fontWeight: FontWeight.w600)),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Flexible(
                                                                child: context.read<BackToStoreBloc>().backToStoreListResponse.addBtsStatus
                                                                    ? const SizedBox()
                                                                    : SizedBox(
                                                                        child: SingleChildScrollView(
                                                                          scrollDirection: Axis.horizontal,
                                                                          child: Row(
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  reasonSearchFieldController.clear();
                                                                                  context.read<BackToStoreBloc>().selectedReason = "";
                                                                                  commentsBar.clear();
                                                                                  quantityBar.clear();
                                                                                  context.read<BackToStoreBloc>().updateLoader = false;
                                                                                  context.read<BackToStoreBloc>().selectedReasonEmpty = false;
                                                                                  context.read<BackToStoreBloc>().hideKeyBoardReason = false;
                                                                                  getIt<Variables>().generalVariables.popUpWidget =
                                                                                      unavailableContent(index: index);
                                                                                  getIt<Functions>().showAnimatedDialog(
                                                                                      context: context, isFromTop: false, isCloseDisabled: false);
                                                                                },
                                                                                child: Text(
                                                                                  getIt<Variables>()
                                                                                      .generalVariables
                                                                                      .currentLanguage
                                                                                      .unavailable
                                                                                      .toUpperCase(),
                                                                                  style: TextStyle(
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                      fontWeight: FontWeight.w600,
                                                                                      color: const Color(0xffF92C38)),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                " | ",
                                                                                style: TextStyle(
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  reasonSearchFieldController.clear();
                                                                                  context.read<BackToStoreBloc>().selectedReason = "";
                                                                                  commentsBar.clear();
                                                                                  quantityBar.clear();
                                                                                  context.read<BackToStoreBloc>().updateLoader = false;
                                                                                  context.read<BackToStoreBloc>().textFieldEmpty = false;
                                                                                  context.read<BackToStoreBloc>().formatError = false;
                                                                                  context.read<BackToStoreBloc>().moreQuantityError = false;
                                                                                  context.read<BackToStoreBloc>().isZeroValue = false;
                                                                                  getIt<Variables>().generalVariables.popUpWidget =
                                                                                      availableContent(index: index);
                                                                                  getIt<Functions>().showAnimatedDialog(
                                                                                      context: context, isFromTop: false, isCloseDisabled: false);
                                                                                },
                                                                                child: Text(
                                                                                  getIt<Variables>()
                                                                                      .generalVariables
                                                                                      .currentLanguage
                                                                                      .picked
                                                                                      .toUpperCase(),
                                                                                  style: TextStyle(
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                      fontWeight: FontWeight.w600,
                                                                                      color: const Color(0xff007838)),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
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
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                    width: getIt<Functions>().getWidgetWidth(width: 40),
                                                                    decoration: BoxDecoration(
                                                                      color: Color(int.parse(
                                                                          '0xFF${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].typeColor}')),
                                                                      shape: BoxShape.circle,
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemType,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: getIt<Functions>().getTextSize(
                                                                                fontSize: context
                                                                                            .read<BackToStoreBloc>()
                                                                                            .backToStoreListResponse
                                                                                            .items[index]
                                                                                            .itemType
                                                                                            .length >=
                                                                                        2
                                                                                    ? 14
                                                                                    : 16),
                                                                            color: const Color(0xFFFFFFFF)),
                                                                      ),
                                                                    ),
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
                                                                                  .read<BackToStoreBloc>()
                                                                                  .backToStoreListResponse
                                                                                  .items[index]
                                                                                  .itemName,
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
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
                                                                                  "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemCode}",
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                      color: const Color(0xff8A8D8E)),
                                                                                ),
                                                                                const VerticalDivider(
                                                                                  color: Color(0xff8A8D8E),
                                                                                ),
                                                                                Text(
                                                                                  "${getIt<Variables>().generalVariables.currentLanguage.uom.toUpperCase()} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].uom}",
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
                                                                    ),
                                                                  )
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
                                                                                    .entryTime
                                                                                    .toUpperCase(),
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                              Text(
                                                                                context
                                                                                    .read<BackToStoreBloc>()
                                                                                    .backToStoreListResponse
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
                                                                                    .reported
                                                                                    .toUpperCase(),
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                              Text(
                                                                                context
                                                                                    .read<BackToStoreBloc>()
                                                                                    .backToStoreListResponse
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
                                                                                    .location
                                                                                    .toUpperCase(),
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                              Text(
                                                                                context
                                                                                    .read<BackToStoreBloc>()
                                                                                    .backToStoreListResponse
                                                                                    .items[index]
                                                                                    .location,
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
                                                                        context.read<BackToStoreBloc>().backToStoreListResponse.items[index].quantity,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007AFF)),
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
                                                                        text: context
                                                                            .read<BackToStoreBloc>()
                                                                            .backToStoreListResponse
                                                                            .items[index]
                                                                            .btsReason,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            color: const Color(0xffF92C38),
                                                                            fontWeight: FontWeight.w500)),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
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
                                        context.read<BackToStoreBloc>().pageIndex = 1;
                                        context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: false));
                                        if (mounted) setState(() {});
                                        pickedRefreshController.refreshCompleted();
                                      },
                                      controller: pickedRefreshController,
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
                                        context.read<BackToStoreBloc>().pageIndex++;
                                        context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: true));
                                        if (mounted) setState(() {});
                                        pickedRefreshController.loadComplete();
                                      },
                                      child: context.read<BackToStoreBloc>().backToStoreListResponse.items.isEmpty
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
                                                  getIt<Variables>().generalVariables.currentLanguage.backToStoreListIsEmpty,
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
                                              itemCount: context.read<BackToStoreBloc>().backToStoreListResponse.items.length,
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int index) {
                                                return InkWell(
                                                  onTap: () {
                                                    reasonSearchFieldController.clear();
                                                    context.read<BackToStoreBloc>().selectedReason = "";
                                                    commentsBar.clear();
                                                    quantityBar.clear();
                                                    getIt<Variables>().generalVariables.popUpWidget = selectedContent(index: index);
                                                    getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
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
                                                            children: [
                                                              RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      "${getIt<Variables>().generalVariables.currentLanguage.source.toUpperCase()}  :  ",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      color: const Color(0xff282F3A),
                                                                      fontWeight: FontWeight.w600),
                                                                  children: [
                                                                    TextSpan(
                                                                        text: context
                                                                            .read<BackToStoreBloc>()
                                                                            .backToStoreListResponse
                                                                            .items[index]
                                                                            .source,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            color: const Color(0xffF92C38),
                                                                            fontWeight: FontWeight.w600)),
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
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                    width: getIt<Functions>().getWidgetWidth(width: 40),
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                        color: Color(int.parse(
                                                                            '0XFF${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].typeColor}'))),
                                                                    child: Center(
                                                                      child: Text(
                                                                        context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemType,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: getIt<Functions>().getTextSize(
                                                                                fontSize: context
                                                                                            .read<BackToStoreBloc>()
                                                                                            .backToStoreListResponse
                                                                                            .items[index]
                                                                                            .itemType
                                                                                            .length >=
                                                                                        2
                                                                                    ? 14
                                                                                    : 16),
                                                                            color: const Color(0xFFFFFFFF)),
                                                                      ),
                                                                    ),
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
                                                                                  .read<BackToStoreBloc>()
                                                                                  .backToStoreListResponse
                                                                                  .items[index]
                                                                                  .itemName,
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ),
                                                                          SingleChildScrollView(
                                                                            scrollDirection: Axis.horizontal,
                                                                            child: IntrinsicHeight(
                                                                              child: Row(
                                                                                children: [
                                                                                  Text(
                                                                                    "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemCode}",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                        color: const Color(0xff8A8D8E)),
                                                                                  ),
                                                                                  const VerticalDivider(
                                                                                    color: Color(0xff8A8D8E),
                                                                                  ),
                                                                                  Text(
                                                                                    "${getIt<Variables>().generalVariables.currentLanguage.uom.toUpperCase()} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].uom}",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 11),
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
                                                                  SizedBox(width: getIt<Functions>().getWidgetWidth(width: 10)),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    children: [
                                                                      Text(
                                                                        context
                                                                            .read<BackToStoreBloc>()
                                                                            .backToStoreListResponse
                                                                            .items[index]
                                                                            .pickedQty,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007838)),
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
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                                              ),
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                child: ListView(
                                                                  scrollDirection: Axis.horizontal,
                                                                  physics: const BouncingScrollPhysics(),
                                                                  shrinkWrap: true,
                                                                  padding: EdgeInsets.zero,
                                                                  children: [
                                                                    SizedBox(
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            getIt<Variables>()
                                                                                .generalVariables
                                                                                .currentLanguage
                                                                                .entryTime
                                                                                .toUpperCase(),
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                color: const Color(0xff8A8D8E)),
                                                                          ),
                                                                          Text(
                                                                            context
                                                                                .read<BackToStoreBloc>()
                                                                                .backToStoreListResponse
                                                                                .items[index]
                                                                                .entryTime,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 20)),
                                                                    SizedBox(
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            getIt<Variables>()
                                                                                .generalVariables
                                                                                .currentLanguage
                                                                                .reported
                                                                                .toUpperCase(),
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                color: const Color(0xff8A8D8E)),
                                                                          ),
                                                                          Text(
                                                                            context
                                                                                .read<BackToStoreBloc>()
                                                                                .backToStoreListResponse
                                                                                .items[index]
                                                                                .requestedBy,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 20)),
                                                                    SizedBox(
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            getIt<Variables>()
                                                                                .generalVariables
                                                                                .currentLanguage
                                                                                .location
                                                                                .toUpperCase(),
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                color: const Color(0xff8A8D8E)),
                                                                          ),
                                                                          Text(
                                                                            context
                                                                                .read<BackToStoreBloc>()
                                                                                .backToStoreListResponse
                                                                                .items[index]
                                                                                .location,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 20)),
                                                                    SizedBox(
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            getIt<Variables>()
                                                                                .generalVariables
                                                                                .currentLanguage
                                                                                .updatedBy
                                                                                .toUpperCase(),
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                color: const Color(0xff8A8D8E)),
                                                                          ),
                                                                          Text(
                                                                            context
                                                                                .read<BackToStoreBloc>()
                                                                                .backToStoreListResponse
                                                                                .items[index]
                                                                                .updatedBy,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 20)),
                                                                    SizedBox(
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
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
                                                                          Text(
                                                                            context
                                                                                .read<BackToStoreBloc>()
                                                                                .backToStoreListResponse
                                                                                .items[index]
                                                                                .updatedTime,
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
                                                                      fontWeight: FontWeight.w600),
                                                                  children: [
                                                                    TextSpan(
                                                                        text: context
                                                                            .read<BackToStoreBloc>()
                                                                            .backToStoreListResponse
                                                                            .items[index]
                                                                            .btsReason,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            color: const Color(0xffF92C38),
                                                                            fontWeight: FontWeight.w600)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
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
                                        context.read<BackToStoreBloc>().pageIndex = 1;
                                        context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: false));
                                        if (mounted) setState(() {});
                                        unavailableRefreshController.refreshCompleted();
                                      },
                                      controller: unavailableRefreshController,
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
                                        context.read<BackToStoreBloc>().pageIndex++;
                                        context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: true));
                                        if (mounted) setState(() {});
                                        unavailableRefreshController.loadComplete();
                                      },
                                      child: context.read<BackToStoreBloc>().backToStoreListResponse.items.isEmpty
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
                                                  getIt<Variables>().generalVariables.currentLanguage.backToStoreListIsEmpty,
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
                                              itemCount: context.read<BackToStoreBloc>().backToStoreListResponse.items.length,
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int index) {
                                                return InkWell(
                                                  onTap: () {
                                                    reasonSearchFieldController.clear();
                                                    context.read<BackToStoreBloc>().selectedReason = "";
                                                    commentsBar.clear();
                                                    quantityBar.clear();
                                                    context.read<BackToStoreBloc>().updateLoader = false;
                                                    context.read<BackToStoreBloc>().textFieldEmpty = false;
                                                    context.read<BackToStoreBloc>().formatError = false;
                                                    context.read<BackToStoreBloc>().moreQuantityError = false;
                                                    context.read<BackToStoreBloc>().isZeroValue = false;
                                                    getIt<Variables>().generalVariables.popUpWidget =
                                                        context.read<BackToStoreBloc>().backToStoreListResponse.addBtsStatus
                                                            ? selectedContent(index: index)
                                                            : availableContent(index: index);
                                                    getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
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
                                                            children: [
                                                              RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      "${getIt<Variables>().generalVariables.currentLanguage.source.toUpperCase()}  :  ",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      color: const Color(0xff282F3A),
                                                                      fontWeight: FontWeight.w600),
                                                                  children: [
                                                                    TextSpan(
                                                                        text: context
                                                                            .read<BackToStoreBloc>()
                                                                            .backToStoreListResponse
                                                                            .items[index]
                                                                            .source,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            color: const Color(0xffF92C38),
                                                                            fontWeight: FontWeight.w600)),
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
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                    width: getIt<Functions>().getWidgetWidth(width: 40),
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                        color: Color(int.parse(
                                                                            '0xFF${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].typeColor}'))),
                                                                    child: Center(
                                                                      child: Text(
                                                                        context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemType,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: getIt<Functions>().getTextSize(
                                                                                fontSize: context
                                                                                            .read<BackToStoreBloc>()
                                                                                            .backToStoreListResponse
                                                                                            .items[index]
                                                                                            .itemType
                                                                                            .length >=
                                                                                        2
                                                                                    ? 14
                                                                                    : 16),
                                                                            color: const Color(0xFFFFFFFF)),
                                                                      ),
                                                                    ),
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
                                                                                  .read<BackToStoreBloc>()
                                                                                  .backToStoreListResponse
                                                                                  .items[index]
                                                                                  .itemName,
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                                                  color: const Color(0xff282F3A)),
                                                                            ),
                                                                          ),
                                                                          SingleChildScrollView(
                                                                            scrollDirection: Axis.horizontal,
                                                                            child: IntrinsicHeight(
                                                                              child: Row(
                                                                                children: [
                                                                                  Text(
                                                                                    "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemCode}",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                        color: const Color(0xff8A8D8E)),
                                                                                  ),
                                                                                  const VerticalDivider(
                                                                                    color: Color(0xff8A8D8E),
                                                                                  ),
                                                                                  Text(
                                                                                    "${getIt<Variables>().generalVariables.currentLanguage.uom.toUpperCase()} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].uom}",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 11),
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
                                                                    width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    children: [
                                                                      Text(
                                                                        context.read<BackToStoreBloc>().backToStoreListResponse.items[index].quantity,
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
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                                              ),
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                child: ListView(
                                                                  scrollDirection: Axis.horizontal,
                                                                  physics: const BouncingScrollPhysics(),
                                                                  shrinkWrap: true,
                                                                  padding: EdgeInsets.zero,
                                                                  children: [
                                                                    SizedBox(
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            getIt<Variables>()
                                                                                .generalVariables
                                                                                .currentLanguage
                                                                                .entryTime
                                                                                .toUpperCase(),
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                color: const Color(0xff8A8D8E)),
                                                                          ),
                                                                          Text(
                                                                            context
                                                                                .read<BackToStoreBloc>()
                                                                                .backToStoreListResponse
                                                                                .items[index]
                                                                                .entryTime,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 20)),
                                                                    SizedBox(
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            getIt<Variables>()
                                                                                .generalVariables
                                                                                .currentLanguage
                                                                                .reported
                                                                                .toUpperCase(),
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                color: const Color(0xff8A8D8E)),
                                                                          ),
                                                                          Text(
                                                                            context
                                                                                .read<BackToStoreBloc>()
                                                                                .backToStoreListResponse
                                                                                .items[index]
                                                                                .requestedBy,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 20)),
                                                                    SizedBox(
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            getIt<Variables>()
                                                                                .generalVariables
                                                                                .currentLanguage
                                                                                .location
                                                                                .toUpperCase(),
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                color: const Color(0xff8A8D8E)),
                                                                          ),
                                                                          Text(
                                                                            context
                                                                                .read<BackToStoreBloc>()
                                                                                .backToStoreListResponse
                                                                                .items[index]
                                                                                .location,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 20)),
                                                                    SizedBox(
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            getIt<Variables>()
                                                                                .generalVariables
                                                                                .currentLanguage
                                                                                .updatedBy
                                                                                .toUpperCase(),
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                color: const Color(0xff8A8D8E)),
                                                                          ),
                                                                          Text(
                                                                            context
                                                                                .read<BackToStoreBloc>()
                                                                                .backToStoreListResponse
                                                                                .items[index]
                                                                                .updatedBy,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                color: const Color(0xff282F3A)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 20)),
                                                                    SizedBox(
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
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
                                                                          Text(
                                                                            context
                                                                                .read<BackToStoreBloc>()
                                                                                .backToStoreListResponse
                                                                                .items[index]
                                                                                .updatedTime,
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
                                                                      fontWeight: FontWeight.w600),
                                                                  children: [
                                                                    TextSpan(
                                                                        text: context
                                                                            .read<BackToStoreBloc>()
                                                                            .backToStoreListResponse
                                                                            .items[index]
                                                                            .btsReason,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            color: const Color(0xffF92C38),
                                                                            fontWeight: FontWeight.w600)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
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
                                        context.read<BackToStoreBloc>().pageIndex = 1;
                                        context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: false));
                                        setState(() {});
                                        yetToPickRefreshController.refreshCompleted();
                                      },
                                      controller: yetToPickRefreshController,
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
                                        context.read<BackToStoreBloc>().pageIndex++;
                                        context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: true));
                                        if (mounted) setState(() {});
                                        yetToPickRefreshController.loadComplete();
                                      },
                                      child: context.read<BackToStoreBloc>().backToStoreListResponse.items.isEmpty
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
                                                  getIt<Variables>().generalVariables.currentLanguage.backToStoreListIsEmpty,
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
                                              itemCount: context.read<BackToStoreBloc>().backToStoreListResponse.items.length,
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int index) {
                                                return InkWell(
                                                  onTap: () {
                                                    reasonSearchFieldController.clear();
                                                    context.read<BackToStoreBloc>().selectedReason = "";
                                                    commentsBar.clear();
                                                    quantityBar.clear();
                                                    getIt<Variables>().generalVariables.popUpWidget = selectedContent(index: index);
                                                    getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
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
                                                          width: double.infinity,
                                                          decoration: const BoxDecoration(
                                                            color: Color(0xffE3E7EA),
                                                            borderRadius:
                                                                BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                          ),
                                                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                          child: Expanded(
                                                            child: SingleChildScrollView(
                                                              scrollDirection: Axis.horizontal,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  RichText(
                                                                    text: TextSpan(
                                                                      text:
                                                                          "${getIt<Variables>().generalVariables.currentLanguage.source.toUpperCase()}  :  ",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          color: const Color(0xff282F3A),
                                                                          fontWeight: FontWeight.w500),
                                                                      children: [
                                                                        TextSpan(
                                                                            text: context
                                                                                .read<BackToStoreBloc>()
                                                                                .backToStoreListResponse
                                                                                .items[index]
                                                                                .source,
                                                                            style: TextStyle(
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                color: const Color(0xffF92C38),
                                                                                fontWeight: FontWeight.w500)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: getIt<Functions>().getWidgetWidth(width: 35)),
                                                                  IntrinsicHeight(
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap: () {
                                                                            reasonSearchFieldController.clear();
                                                                            context.read<BackToStoreBloc>().selectedReason = "";
                                                                            commentsBar.clear();
                                                                            quantityBar.clear();
                                                                            context.read<BackToStoreBloc>().updateLoader = false;
                                                                            context.read<BackToStoreBloc>().selectedReasonEmpty = false;
                                                                            context.read<BackToStoreBloc>().hideKeyBoardReason = false;
                                                                            getIt<Variables>().generalVariables.popUpWidget =
                                                                                unavailableContent(index: index);
                                                                            getIt<Functions>().showAnimatedDialog(
                                                                                context: context, isFromTop: false, isCloseDisabled: false);
                                                                          },
                                                                          child: Text(
                                                                            getIt<Variables>()
                                                                                .generalVariables
                                                                                .currentLanguage
                                                                                .unavailable
                                                                                .toUpperCase(),
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
                                                                            reasonSearchFieldController.clear();
                                                                            context.read<BackToStoreBloc>().selectedReason = "";
                                                                            commentsBar.clear();
                                                                            quantityBar.clear();
                                                                            context.read<BackToStoreBloc>().updateLoader = false;
                                                                            context.read<BackToStoreBloc>().textFieldEmpty = false;
                                                                            context.read<BackToStoreBloc>().formatError = false;
                                                                            context.read<BackToStoreBloc>().moreQuantityError = false;
                                                                            context.read<BackToStoreBloc>().isZeroValue = false;
                                                                            getIt<Variables>().generalVariables.popUpWidget =
                                                                                availableContent(index: index);
                                                                            getIt<Functions>().showAnimatedDialog(
                                                                                context: context, isFromTop: false, isCloseDisabled: false);
                                                                          },
                                                                          child: Text(
                                                                            getIt<Variables>().generalVariables.currentLanguage.picked.toUpperCase(),
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
                                                                      color: Color(int.parse(
                                                                          '0xFF${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].typeColor}')),
                                                                      shape: BoxShape.circle,
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemType,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: getIt<Functions>().getTextSize(
                                                                                fontSize: context
                                                                                            .read<BackToStoreBloc>()
                                                                                            .backToStoreListResponse
                                                                                            .items[index]
                                                                                            .itemType
                                                                                            .length >=
                                                                                        2
                                                                                    ? 14
                                                                                    : 16),
                                                                            color: const Color(0xFFFFFFFF)),
                                                                      ),
                                                                    ),
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
                                                                                  .read<BackToStoreBloc>()
                                                                                  .backToStoreListResponse
                                                                                  .items[index]
                                                                                  .itemName,
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
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
                                                                                  "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemCode}",
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                      color: const Color(0xff8A8D8E)),
                                                                                ),
                                                                                const VerticalDivider(
                                                                                  color: Color(0xff8A8D8E),
                                                                                ),
                                                                                Text(
                                                                                  "${getIt<Variables>().generalVariables.currentLanguage.uom.toUpperCase()} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].uom}",
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
                                                                    ),
                                                                  )
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
                                                                                    .entryTime
                                                                                    .toUpperCase(),
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                              Text(
                                                                                context
                                                                                    .read<BackToStoreBloc>()
                                                                                    .backToStoreListResponse
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
                                                                                    .reported
                                                                                    .toUpperCase(),
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                              Text(
                                                                                context
                                                                                    .read<BackToStoreBloc>()
                                                                                    .backToStoreListResponse
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
                                                                                    .location
                                                                                    .toUpperCase(),
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                              Text(
                                                                                context
                                                                                    .read<BackToStoreBloc>()
                                                                                    .backToStoreListResponse
                                                                                    .items[index]
                                                                                    .location,
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
                                                                        context.read<BackToStoreBloc>().backToStoreListResponse.items[index].quantity,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff007AFF)),
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
                                                                        text: context
                                                                            .read<BackToStoreBloc>()
                                                                            .backToStoreListResponse
                                                                            .items[index]
                                                                            .btsReason,
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                            color: const Color(0xffF92C38),
                                                                            fontWeight: FontWeight.w500)),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                    ),
                                  );
                              }
                            } else if (bts is BackToStoreLoading) {
                              switch (context.read<BackToStoreBloc>().tabIndex) {
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
                                            return InkWell(
                                              onTap: () {},
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
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                      ),
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                              text: "Source  :  ",
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                  color: const Color(0xff282F3A),
                                                                  fontWeight: FontWeight.w500),
                                                              children: [
                                                                TextSpan(
                                                                    text: 'Source',
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xffF92C38),
                                                                        fontWeight: FontWeight.w500)),
                                                              ],
                                                            ),
                                                          ),
                                                          IntrinsicHeight(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {},
                                                                  child: Text(
                                                                    'Unavailable',
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
                                                                  onTap: () {},
                                                                  child: Text(
                                                                    'picked',
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
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        'ItemType',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                            color: const Color(0xFFFFFFFF)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                  ),
                                                                  SizedBox(
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 280),
                                                                          child: Text(
                                                                            'Item Name',
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
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
                                                                                "Item Code",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              const VerticalDivider(
                                                                                color: Color(0xff8A8D8E),
                                                                              ),
                                                                              Text(
                                                                                "Uom : kg",
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
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 16),
                                                          ),
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 50),
                                                            child: ListView(
                                                              scrollDirection: Axis.horizontal,
                                                              children: [
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      'Entry Time',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      '11/02/24',
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
                                                                      'Reported',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      'John smith',
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
                                                                      'location',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      'location',
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
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      'Quantity',
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xff007AFF)),
                                                                    ),
                                                                    Text(
                                                                      'Quantity',
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
                                                              text: "Reason  :  ",
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                  color: const Color(0xff282F3A),
                                                                  fontWeight: FontWeight.w500),
                                                              children: [
                                                                TextSpan(
                                                                    text: 'Reason',
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xffF92C38),
                                                                        fontWeight: FontWeight.w500)),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                                            return InkWell(
                                              onTap: () {},
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
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                      ),
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                              text: "Source  :  ",
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                  color: const Color(0xff282F3A),
                                                                  fontWeight: FontWeight.w500),
                                                              children: [
                                                                TextSpan(
                                                                    text: 'Source',
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xffF92C38),
                                                                        fontWeight: FontWeight.w500)),
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
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        'ItemType',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                            color: const Color(0xFFFFFFFF)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                  ),
                                                                  SizedBox(
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 280),
                                                                          child: Text(
                                                                            'Item Name',
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
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
                                                                                "Item Code",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              const VerticalDivider(
                                                                                color: Color(0xff8A8D8E),
                                                                              ),
                                                                              Text(
                                                                                "Uom : kg",
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
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 16),
                                                          ),
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 50),
                                                            child: ListView(
                                                              scrollDirection: Axis.horizontal,
                                                              children: [
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      'Entry Time',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      '11/02/24',
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
                                                                      'Reported',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      'John smith',
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
                                                                      'location',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      'location',
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
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      'Quantity',
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xff007AFF)),
                                                                    ),
                                                                    Text(
                                                                      'Quantity',
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
                                                              text: "Reason  :  ",
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                  color: const Color(0xff282F3A),
                                                                  fontWeight: FontWeight.w500),
                                                              children: [
                                                                TextSpan(
                                                                    text: 'Reason',
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xffF92C38),
                                                                        fontWeight: FontWeight.w500)),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                                            return InkWell(
                                              onTap: () {},
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
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                      ),
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                              text: "Source  :  ",
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                  color: const Color(0xff282F3A),
                                                                  fontWeight: FontWeight.w500),
                                                              children: [
                                                                TextSpan(
                                                                    text: 'Source',
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xffF92C38),
                                                                        fontWeight: FontWeight.w500)),
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
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        'ItemType',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                            color: const Color(0xFFFFFFFF)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                  ),
                                                                  SizedBox(
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 280),
                                                                          child: Text(
                                                                            'Item Name',
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
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
                                                                                "Item Code",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              const VerticalDivider(
                                                                                color: Color(0xff8A8D8E),
                                                                              ),
                                                                              Text(
                                                                                "Uom : kg",
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
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 16),
                                                          ),
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 50),
                                                            child: ListView(
                                                              scrollDirection: Axis.horizontal,
                                                              children: [
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      'Entry Time',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      '11/02/24',
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
                                                                      'Reported',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      'John smith',
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
                                                                      'location',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      'location',
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
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      'Quantity',
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xff007AFF)),
                                                                    ),
                                                                    Text(
                                                                      'Quantity',
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
                                                              text: "Reason  :  ",
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                  color: const Color(0xff282F3A),
                                                                  fontWeight: FontWeight.w500),
                                                              children: [
                                                                TextSpan(
                                                                    text: 'Reason',
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xffF92C38),
                                                                        fontWeight: FontWeight.w500)),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                                            return InkWell(
                                              onTap: () {},
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
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                                      ),
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                              text: "Source  :  ",
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                  color: const Color(0xff282F3A),
                                                                  fontWeight: FontWeight.w500),
                                                              children: [
                                                                TextSpan(
                                                                    text: 'Source',
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xffF92C38),
                                                                        fontWeight: FontWeight.w500)),
                                                              ],
                                                            ),
                                                          ),
                                                          IntrinsicHeight(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {},
                                                                  child: Text(
                                                                    'Unavailable',
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
                                                                  onTap: () {},
                                                                  child: Text(
                                                                    'picked',
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
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        'ItemType',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                                            color: const Color(0xFFFFFFFF)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: getIt<Functions>().getWidgetWidth(width: 10),
                                                                  ),
                                                                  SizedBox(
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 280),
                                                                          child: Text(
                                                                            'Item Name',
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
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
                                                                                "Item Code",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                                    color: const Color(0xff8A8D8E)),
                                                                              ),
                                                                              const VerticalDivider(
                                                                                color: Color(0xff8A8D8E),
                                                                              ),
                                                                              Text(
                                                                                "Uom : kg",
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
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 16),
                                                          ),
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 50),
                                                            child: ListView(
                                                              scrollDirection: Axis.horizontal,
                                                              children: [
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      'Entry Time',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      '11/02/24',
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
                                                                      'Reported',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      'John smith',
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
                                                                      'location',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          color: const Color(0xff8A8D8E)),
                                                                    ),
                                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                                                                    Text(
                                                                      'location',
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
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      'Quantity',
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 17),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xff007AFF)),
                                                                    ),
                                                                    Text(
                                                                      'Quantity',
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
                                                              text: "Reason  :  ",
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                  color: const Color(0xff282F3A),
                                                                  fontWeight: FontWeight.w500),
                                                              children: [
                                                                TextSpan(
                                                                    text: 'Reason',
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        color: const Color(0xffF92C38),
                                                                        fontWeight: FontWeight.w500)),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
      }),
    );
  }

  Widget textBars({required TextEditingController controller}) {
    return BlocBuilder<BackToStoreBloc, BackToStoreState>(
      builder: (BuildContext context, BackToStoreState state) {
        return Padding(
          padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 15)),
          child: SizedBox(
            height: getIt<Functions>().getWidgetHeight(height: 36),
            width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 250 : 268),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: getIt<Functions>().getWidgetHeight(height: 36),
                    child: TextFormField(
                      controller: controller,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        if (timer?.isActive ?? false) timer?.cancel();
                        timer = Timer(const Duration(milliseconds: 500), () {
                          if (value.isNotEmpty) {
                            context.read<BackToStoreBloc>().searchText = value.toLowerCase();
                            context.read<BackToStoreBloc>().pageIndex = 1;
                            context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: false));
                          } else {
                            context.read<BackToStoreBloc>().searchText = "";
                            context.read<BackToStoreBloc>().pageIndex = 1;
                            context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: false));
                          }
                        });
                      },
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
                        hintText: getIt<Variables>().generalVariables.currentLanguage.search,
                        hintStyle: TextStyle(
                            color: const Color(0xff8F9BB3), fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                        suffixIcon: controller.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  controller.clear();
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                                  context.read<BackToStoreBloc>().searchText = "";
                                  context.read<BackToStoreBloc>().pageIndex = 1;
                                  context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: false));
                                },
                                icon: const Icon(Icons.clear, color: Colors.black, size: 15))
                            : const SizedBox(),
                      ),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }

  Widget btsAlertContent() {
    return BlocConsumer<BackToStoreBloc, BackToStoreState>(
      listenWhen: (BackToStoreState previous, BackToStoreState current) {
        return previous != current;
      },
      buildWhen: (BackToStoreState previous, BackToStoreState current) {
        return previous != current;
      },
      listener: (BuildContext context, BackToStoreState state) {
        if (state is BackToStoreError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (BuildContext context, BackToStoreState state) {
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
                "BTS Alert !",
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
                          "13",
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: 28), fontWeight: FontWeight.w600, color: const Color(0xff007838)),
                        ),
                        Text(
                          "REQUIRED QTY",
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
              SizedBox(
                height: getIt<Functions>().getWidgetHeight(height: 105),
                width: getIt<Functions>().getWidgetWidth(width: 465),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "One More Night Hostel",
                      style: TextStyle(
                          fontSize: getIt<Functions>().getTextSize(fontSize: 18), color: const Color(0xff282F3A), fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Mutton Leg Boneless - Aus Origin - KG",
                      style: TextStyle(
                          fontSize: getIt<Functions>().getTextSize(fontSize: 16), color: const Color(0xff282F3A), fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Request By : Ava Johnson",
                      style: TextStyle(
                          fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff282F3A), fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : MB002 | Ship to Code : SF1937",
                      style: TextStyle(
                          fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff282F3A), fontWeight: FontWeight.w500),
                    ),
                  ],
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

  Widget unavailableContent({required int index}) {
    context.read<BackToStoreBloc>().selectedReasonEmpty = false;
    context.read<BackToStoreBloc>().selectedReason = "";
    context.read<BackToStoreBloc>().selectedReasonName = null;
    context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
    return BlocConsumer<BackToStoreBloc, BackToStoreState>(
      listenWhen: (BackToStoreState previous, BackToStoreState current) {
        return previous != current;
      },
      buildWhen: (BackToStoreState previous, BackToStoreState current) {
        return previous != current;
      },
      listener: (BuildContext context, BackToStoreState state) {
        if (state is BackToStoreSuccess) {
          context.read<BackToStoreBloc>().backToStoreListResponse.yetToUpdate--;
          context.read<BackToStoreBloc>().backToStoreListResponse.unavailable++;
          context.read<BackToStoreBloc>().updateLoader = false;
          Navigator.pop(context);
          context.read<BackToStoreBloc>().backToStoreListResponse.items.removeAt(index);
          context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is BackToStoreFailure) {
          context.read<BackToStoreBloc>().updateLoader = false;
          context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
        }
        if (state is BackToStoreError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          context.read<BackToStoreBloc>().updateLoader = false;
          getIt<Widgets>().flushBarWidget(context: context, message: state.message);
        }
      },
      builder: (BuildContext context, BackToStoreState state) {
        if (getIt<Variables>().generalVariables.isDeviceTablet) {
          return SizedBox(
            height: getIt<Functions>().getWidgetHeight(height: 392),
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
                            color: Color(int.parse('0xFF${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].typeColor}'))),
                        child: Center(
                          child: Text(
                            context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemType,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: getIt<Functions>().getTextSize(
                                    fontSize: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemCode.length >= 2 ? 20 : 24),
                                color: const Color(0xFFFFFFFF)),
                          ),
                        ),
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
                                context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                    color: const Color(0xFF282F3A)),
                              ),
                            ),
                            Text(
                              "${getIt<Variables>().generalVariables.currentLanguage.quantityToPick} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].quantity}${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].uom}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 15),
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
                        height: getIt<Functions>().getWidgetHeight(height: 80),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getIt<Variables>().generalVariables.currentLanguage.reason.toUpperCase(),
                              style: TextStyle(
                                  color: const Color(0xff282F3A),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                            ),
                            SizedBox(
                              height: getIt<Functions>().getWidgetHeight(height: 45),
                              child: DropDownSearchFormField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  decoration: InputDecoration(
                                      fillColor: const Color(0xffffffff),
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
                                      suffixIcon: reasonSearchFieldController.text.isNotEmpty
                                          ? IconButton(
                                              onPressed: () {
                                                reasonSearchFieldController.clear();
                                                context.read<BackToStoreBloc>().selectedReasonEmpty = false;
                                                context.read<BackToStoreBloc>().hideKeyBoardReason = false;
                                                context.read<BackToStoreBloc>().selectedReason = "";
                                                context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
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
                                      hintText: getIt<Variables>().generalVariables.currentLanguage.selectReason,
                                      hintStyle: TextStyle(
                                          color: const Color(0xff8A8D8E),
                                          fontWeight: FontWeight.w400,
                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                  controller: reasonSearchFieldController,
                                ),
                                hideKeyboard: context.read<BackToStoreBloc>().hideKeyBoardReason,
                                suggestionsCallback: (pattern) {
                                  context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                                  return getSuggestions(
                                      query: pattern,
                                      data: List.generate(context.read<BackToStoreBloc>().backToStoreListResponse.unavailableReasons.length,
                                          (i) => context.read<BackToStoreBloc>().backToStoreListResponse.unavailableReasons[i].description));
                                },
                                itemBuilder: (context, String suggestion) {
                                  return ListTile(title: Text(suggestion));
                                },
                                transitionBuilder: (context, suggestionsBox, controller) {
                                  return suggestionsBox;
                                },
                                onSuggestionSelected: (String suggestion) {
                                  reasonSearchFieldController.text = suggestion;
                                  context.read<BackToStoreBloc>().hideKeyBoardReason = true;
                                  context.read<BackToStoreBloc>().selectedReason = context
                                      .read<BackToStoreBloc>()
                                      .backToStoreListResponse
                                      .unavailableReasons
                                      .singleWhere((element) => element.description == suggestion)
                                      .id;
                                  context.read<BackToStoreBloc>().selectedReasonEmpty = false;
                                  context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                                },
                                suggestionsBoxController: reasonSuggestionBoxController,
                                validator: (value) => value!.isEmpty ? 'Please select a reason' : null,
                                onSaved: (value) => context.read<BackToStoreBloc>().selectedReason = value!,
                                displayAllSuggestionWhenTap: true,
                                autoFlipDirection: true,
                                autoFlipMinHeight: 150,
                                suggestionsBoxDecoration: SuggestionsBoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
                              ),
                            ),
                            context.read<BackToStoreBloc>().selectedReasonEmpty
                                ? Text(
                                    getIt<Variables>().generalVariables.currentLanguage.pleaseSelectTheReason,
                                    style: TextStyle(
                                        color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 10)),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
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
                                  color: const Color(0xff282F3A),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                            ),
                            SizedBox(
                              height: getIt<Functions>().getWidgetHeight(height: 45),
                              child: TextFormField(
                                controller: commentsBar,
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
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 45),
                      ),
                    ],
                  ),
                ),
                context.read<BackToStoreBloc>().updateLoader
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
                          if (context.read<BackToStoreBloc>().selectedReason == "") {
                            context.read<BackToStoreBloc>().selectedReasonEmpty = true;
                            context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                          } else {
                            FocusManager.instance.primaryFocus!.unfocus();
                            context.read<BackToStoreBloc>().selectedReasonEmpty = false;
                            context.read<BackToStoreBloc>().updateLoader = true;
                            context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                            context.read<BackToStoreBloc>().add(BackToStoreUnAvailableEvent(
                                comments: commentsBar.text, id: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].id));
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
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        } else {
          return SizedBox(
            width: getIt<Variables>().generalVariables.width,
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
                            color: Color(int.parse('0xFF${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].typeColor}'))),
                        child: Center(
                          child: Text(
                            context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemType,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: getIt<Functions>().getTextSize(
                                    fontSize: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemType.length >= 2 ? 16 : 20),
                                color: const Color(0xFFFFFFFF)),
                          ),
                        ),
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
                                context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemName,
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                    color: const Color(0xff282F3A),
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            Text(
                              "${getIt<Variables>().generalVariables.currentLanguage.quantityToPick} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].quantity} ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].uom}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 13),
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
                              getIt<Variables>().generalVariables.currentLanguage.reason.toUpperCase(),
                              style: TextStyle(
                                  color: const Color(0xff282F3A),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                            ),
                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 45), child: buildDropButton())
                          ],
                        ),
                      ),
                      context.read<BackToStoreBloc>().selectedReasonEmpty
                          ? Text(
                              getIt<Variables>().generalVariables.currentLanguage.pleaseSelectTheReason,
                              style:
                                  TextStyle(color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 10)),
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
                                  color: const Color(0xff282F3A),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                            ),
                            SizedBox(
                              height: getIt<Functions>().getWidgetHeight(height: 45),
                              child: TextFormField(
                                controller: commentsBar,
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
                                onChanged: (val) {
                                  context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                                },
                                validator: (value) =>
                                    value!.isEmpty ? getIt<Variables>().generalVariables.currentLanguage.pleaseEnterTheComments : null,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 45),
                      ),
                    ],
                  ),
                ),
                context.read<BackToStoreBloc>().updateLoader
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
                          if (context.read<BackToStoreBloc>().selectedReason == "") {
                            context.read<BackToStoreBloc>().selectedReasonEmpty = true;
                            context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                          } else {
                            FocusManager.instance.primaryFocus!.unfocus();
                            context.read<BackToStoreBloc>().selectedReasonEmpty = false;
                            context.read<BackToStoreBloc>().updateLoader = true;
                            context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                            context.read<BackToStoreBloc>().add(BackToStoreUnAvailableEvent(
                                comments: commentsBar.text, id: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].id));
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
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget selectedContent({required int index}) {
    return BlocConsumer<BackToStoreBloc, BackToStoreState>(
      listenWhen: (BackToStoreState previous, BackToStoreState current) {
        return previous != current;
      },
      buildWhen: (BackToStoreState previous, BackToStoreState current) {
        return previous != current;
      },
      listener: (BuildContext context, BackToStoreState state) {
        if (state is BackToStoreSuccess) {
          context.read<BackToStoreBloc>().updateLoader = false;
          context.read<BackToStoreBloc>().backToStoreListResponse.yetToUpdate--;
          context.read<BackToStoreBloc>().backToStoreListResponse.items.removeAt(index);
          context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
          Navigator.pop(context);
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is BackToStoreError) {
          context.read<BackToStoreBloc>().updateLoader = false;
          context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
          ScaffoldMessenger.of(context).clearSnackBars();
          getIt<Widgets>().flushBarWidget(context: context, message: state.message);
        }
      },
      builder: (BuildContext context, BackToStoreState state) {
        if (getIt<Variables>().generalVariables.isDeviceTablet) {
          return SizedBox(
            height: getIt<Functions>().getWidgetHeight(height: 262),
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
                            color: Color(int.parse('0xFF${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].typeColor}'))),
                        child: Center(
                          child: Text(
                            context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemType,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: getIt<Functions>().getTextSize(
                                    fontSize: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemType.length >= 2 ? 22 : 28),
                                color: const Color(0xffFFFFFF)),
                          ),
                        ),
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
                                context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                    color: const Color(0xff282F3A)),
                              ),
                            ),
                            Text(
                              "${getIt<Variables>().generalVariables.currentLanguage.quantityToPick} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].quantity} ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].uom}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 15),
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
                        height: getIt<Functions>().getWidgetHeight(height: 20),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            getIt<Variables>().generalVariables.currentLanguage.notes.toUpperCase(),
                            style: TextStyle(
                                color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                          ),
                          Text(
                            context.read<BackToStoreBloc>().backToStoreListResponse.items[index].btsNotes,
                            style: TextStyle(
                                color: const Color(0xff282F3A), fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 40),
                      ),
                    ],
                  ),
                ),
                context.read<BackToStoreBloc>().updateLoader
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
                    : context.read<BackToStoreBloc>().tabIndex == 0
                        ? InkWell(
                            onTap: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].removeBtsStatus
                                ? () {
                                    FocusManager.instance.primaryFocus!.unfocus();
                                    context.read<BackToStoreBloc>().updateLoader = true;
                                    context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                                    context
                                        .read<BackToStoreBloc>()
                                        .add(BackToStoreRemoveEvent(btsId: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].id));
                                  }
                                : () {
                                    FocusManager.instance.primaryFocus!.unfocus();
                                    Navigator.pop(context);
                                  },
                            child: Container(
                              height: getIt<Functions>().getWidgetHeight(height: 50),
                              decoration: BoxDecoration(
                                color: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].removeBtsStatus
                                    ? const Color(0xffDC474A)
                                    : const Color(0xffE0E7EC),
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                              ),
                              child: Center(
                                child: Text(
                                  context.read<BackToStoreBloc>().backToStoreListResponse.items[index].removeBtsStatus
                                      ? getIt<Variables>().generalVariables.currentLanguage.remove.toUpperCase().toUpperCase()
                                      : getIt<Variables>().generalVariables.currentLanguage.close.toUpperCase(),
                                  style: TextStyle(
                                      color: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].removeBtsStatus
                                          ? const Color(0xffffffff)
                                          : const Color(0xff282F3A),
                                      fontWeight: FontWeight.w600,
                                      fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                                ),
                              ),
                            ),
                          )
                        : InkWell(
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
                                      color: const Color(0xff282F3A),
                                      fontWeight: FontWeight.w600,
                                      fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                                ),
                              ),
                            ),
                          ),
              ],
            ),
          );
        } else {
          return SizedBox(
            width: getIt<Variables>().generalVariables.width,
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
                            color: Color(int.parse('0xFF${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].typeColor}'))),
                        child: Center(
                          child: Text(
                            context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemType,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: getIt<Functions>().getTextSize(
                                    fontSize: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemType.length >= 2 ? 16 : 18),
                                color: const Color(0xFFFFFFFF),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
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
                                context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemName,
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                    color: const Color(0xff282F3A),
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            Text(
                              "${getIt<Variables>().generalVariables.currentLanguage.quantityToPick} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].quantity} ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].uom}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 13),
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
                        height: getIt<Functions>().getWidgetHeight(height: 20),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            getIt<Variables>().generalVariables.currentLanguage.notes.toUpperCase(),
                            style: TextStyle(
                                color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                          ),
                          Text(
                            context.read<BackToStoreBloc>().backToStoreListResponse.items[index].btsNotes,
                            style: TextStyle(
                                color: const Color(0xff282F3A), fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 40),
                      ),
                    ],
                  ),
                ),
                context.read<BackToStoreBloc>().updateLoader
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
                    : context.read<BackToStoreBloc>().tabIndex == 0
                        ? InkWell(
                            onTap: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].removeBtsStatus
                                ? () {
                                    FocusManager.instance.primaryFocus!.unfocus();
                                    context.read<BackToStoreBloc>().updateLoader = true;
                                    context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                                    context
                                        .read<BackToStoreBloc>()
                                        .add(BackToStoreRemoveEvent(btsId: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].id));
                                  }
                                : () {
                                    FocusManager.instance.primaryFocus!.unfocus();
                                    Navigator.pop(context);
                                  },
                            child: Container(
                              height: getIt<Functions>().getWidgetHeight(height: 50),
                              decoration: BoxDecoration(
                                color: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].removeBtsStatus
                                    ? const Color(0xffDC474A)
                                    : const Color(0xffE0E7EC),
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                              ),
                              child: Center(
                                child: Text(
                                  context.read<BackToStoreBloc>().backToStoreListResponse.items[index].removeBtsStatus
                                      ? getIt<Variables>().generalVariables.currentLanguage.remove.toUpperCase().toUpperCase()
                                      : getIt<Variables>().generalVariables.currentLanguage.close.toUpperCase(),
                                  style: TextStyle(
                                      color: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].removeBtsStatus
                                          ? const Color(0xffffffff)
                                          : const Color(0xff282F3A),
                                      fontWeight: FontWeight.w600,
                                      fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                                ),
                              ),
                            ),
                          )
                        : InkWell(
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
                                      color: const Color(0xff282F3A),
                                      fontWeight: FontWeight.w600,
                                      fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                                ),
                              ),
                            ),
                          ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget availableContent({required int index}) {
    context.read<BackToStoreBloc>().textFieldEmpty = false;
    context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
    return BlocConsumer<BackToStoreBloc, BackToStoreState>(
      listenWhen: (BackToStoreState previous, BackToStoreState current) {
        return previous != current;
      },
      buildWhen: (BackToStoreState previous, BackToStoreState current) {
        return previous != current;
      },
      listener: (BuildContext context, BackToStoreState state) {
        if (state is BackToStoreSuccess) {
          if (context.read<BackToStoreBloc>().tabIndex == 0) {
            context.read<BackToStoreBloc>().backToStoreListResponse.yetToUpdate--;
            context.read<BackToStoreBloc>().backToStoreListResponse.updated++;
          } else {
            context.read<BackToStoreBloc>().backToStoreListResponse.unavailable--;
            context.read<BackToStoreBloc>().backToStoreListResponse.updated++;
          }
          context.read<BackToStoreBloc>().updateLoader = false;
          quantityBar.clear();
          Navigator.pop(context);
          context.read<BackToStoreBloc>().backToStoreListResponse.items.removeAt(index);
          context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is BackToStoreFailure) {
          context.read<BackToStoreBloc>().updateLoader = false;
          context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
        }
        if (state is BackToStoreError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (BuildContext context, BackToStoreState state) {
        if (getIt<Variables>().generalVariables.isDeviceTablet) {
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
                          color: Color(int.parse('0xFF${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].typeColor}')),
                        ),
                        child: Center(
                          child: Text(
                            context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemType,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: getIt<Functions>().getTextSize(
                                    fontSize: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemType.length >= 2 ? 20 : 24),
                                color: const Color(0xFFFFFFFF)),
                          ),
                        ),
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
                                context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                    color: const Color(0xff282F3A)),
                              ),
                            ),
                            Text(
                              "${getIt<Variables>().generalVariables.currentLanguage.quantityToPick} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].quantity}${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].uom}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 15),
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
                        height: getIt<Functions>().getWidgetHeight(height: 12),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "${getIt<Variables>().generalVariables.currentLanguage.notes.toUpperCase()}  :  ",
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: const Color(0xff8A8D8E), fontWeight: FontWeight.w500),
                          children: [
                            TextSpan(
                                text: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].btsNotes,
                                style: TextStyle(
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                    color: const Color(0xff282F3A),
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      context.read<BackToStoreBloc>().tabIndex == 2
                          ? SizedBox(
                              height: getIt<Functions>().getWidgetHeight(height: 28),
                            )
                          : const SizedBox(),
                      context.read<BackToStoreBloc>().tabIndex == 2
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getIt<Variables>().generalVariables.currentLanguage.reason,
                                      style: TextStyle(
                                          color: const Color(0xff282F3A),
                                          fontWeight: FontWeight.w600,
                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                    SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 45),
                                      child: TextFormField(
                                        initialValue: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].unavailReason,
                                        readOnly: true,
                                        enabled: false,
                                        style: TextStyle(
                                          color: const Color(0xff8A8D8E),
                                          fontWeight: FontWeight.w400,
                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                        ),
                                        decoration: InputDecoration(
                                          fillColor: const Color(0xffffffff),
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
                                              borderSide: const BorderSide(color: Color(0xff007AFF), width: 0.73)),
                                          focusedErrorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(4),
                                              borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                                SizedBox(
                                  width: getIt<Functions>().getWidgetWidth(width: 20),
                                ),
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getIt<Variables>().generalVariables.currentLanguage.comments,
                                      style: TextStyle(
                                          color: const Color(0xff282F3A),
                                          fontWeight: FontWeight.w600,
                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                    SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 45),
                                      child: TextFormField(
                                        initialValue: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].unavailNotes,
                                        readOnly: true,
                                        style: TextStyle(
                                          color: const Color(0xff8A8D8E),
                                          fontWeight: FontWeight.w400,
                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                        ),
                                        enabled: false,
                                        decoration: InputDecoration(
                                          fillColor: const Color(0xffffffff),
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
                                              borderSide: const BorderSide(color: Color(0xff007AFF), width: 0.73)),
                                          focusedErrorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(4),
                                              borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                              ],
                            )
                          : const SizedBox(),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 28),
                      ),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 85),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getIt<Variables>().generalVariables.currentLanguage.enterQuantity,
                              style: TextStyle(
                                  color: const Color(0xff282F3A),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                            ),
                            SizedBox(
                              height: getIt<Functions>().getWidgetHeight(height: 45),
                              child: TextFormField(
                                controller: quantityBar,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                autofocus: true,
                                inputFormatters: [
                                  NumberInputFormatter(onError: (value) {
                                    context.read<BackToStoreBloc>().formatError = value;
                                    context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                                  })
                                ],
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    context.read<BackToStoreBloc>().formatError = false;
                                    context.read<BackToStoreBloc>().textFieldEmpty = true;
                                    context.read<BackToStoreBloc>().isZeroValue = false;
                                    context.read<BackToStoreBloc>().moreQuantityError = false;
                                    context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                                  } else {
                                    context.read<BackToStoreBloc>().textFieldEmpty = false;
                                    context.read<BackToStoreBloc>().formatError = false;
                                    context.read<BackToStoreBloc>().isZeroValue = false;
                                    if (double.parse(value) >
                                        double.parse(context.read<BackToStoreBloc>().backToStoreListResponse.items[index].quantity)) {
                                      context.read<BackToStoreBloc>().moreQuantityError = true;
                                      context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                                    } else {
                                      context.read<BackToStoreBloc>().moreQuantityError = false;
                                      context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                                    }
                                  }
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
                                      borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xff007AFF), width: 0.73)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                  hintText: getIt<Variables>().generalVariables.currentLanguage.enterQuantity,
                                  hintStyle: TextStyle(
                                    color: const Color(0xff8A8D8E),
                                    fontWeight: FontWeight.w400,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                  ),
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                        vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                    child: Text(
                                      context.read<BackToStoreBloc>().backToStoreListResponse.items[index].uom,
                                      style: TextStyle(
                                        color: const Color(0xff8A8D8E),
                                        fontWeight: FontWeight.w500,
                                        fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                                validator: (value) =>
                                    value!.isEmpty ? getIt<Variables>().generalVariables.currentLanguage.pleaseEnterTheComments : null,
                              ),
                            ),
                            context.read<BackToStoreBloc>().textFieldEmpty ||
                                    context.read<BackToStoreBloc>().formatError ||
                                    context.read<BackToStoreBloc>().moreQuantityError ||
                                    context.read<BackToStoreBloc>().isZeroValue
                                ? Text(
                                    context.read<BackToStoreBloc>().textFieldEmpty
                                        ? getIt<Variables>().generalVariables.currentLanguage.textFieldEmpty
                                        : context.read<BackToStoreBloc>().formatError
                                            ? "${getIt<Variables>().generalVariables.currentLanguage.lessThan10000} ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].uom} (ex: 9999.999)."
                                            : context.read<BackToStoreBloc>().moreQuantityError
                                                ? getIt<Variables>().generalVariables.currentLanguage.moreQuantity
                                                : context.read<BackToStoreBloc>().isZeroValue
                                                    ? getIt<Variables>().generalVariables.currentLanguage.zeroQuantity
                                                    : "",
                                    style: TextStyle(
                                        color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 10)),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 20),
                      ),
                      Text(
                        getIt<Variables>().generalVariables.currentLanguage.notes,
                        style: TextStyle(
                            color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                      ),
                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 45),
                        child: TextFormField(
                          controller: commentsBar,
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
                            hintText: getIt<Variables>().generalVariables.currentLanguage.enterHere,
                            hintStyle: TextStyle(
                              color: const Color(0xff8A8D8E),
                              fontWeight: FontWeight.w400,
                              fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                            ),
                          ),
                          onChanged: (val) {
                            context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                          },
                          validator: (value) => value!.isEmpty ? getIt<Variables>().generalVariables.currentLanguage.pleaseEnterTheComments : null,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: 20),
                ),
                context.read<BackToStoreBloc>().updateLoader
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
                          if (!context.read<BackToStoreBloc>().moreQuantityError) {
                            if (quantityBar.text.isEmpty) {
                              context.read<BackToStoreBloc>().textFieldEmpty = true;
                              context.read<BackToStoreBloc>().formatError = false;
                              context.read<BackToStoreBloc>().moreQuantityError = false;
                              context.read<BackToStoreBloc>().isZeroValue = false;
                              context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                            } else {
                              if (quantityBar.text == "." || double.parse(quantityBar.text) == 0.0) {
                                quantityBar.text = "0.0";
                                context.read<BackToStoreBloc>().isZeroValue = true;
                                context.read<BackToStoreBloc>().textFieldEmpty = false;
                                context.read<BackToStoreBloc>().formatError = false;
                                context.read<BackToStoreBloc>().moreQuantityError = false;
                                context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                              } else {
                                context.read<BackToStoreBloc>().textFieldEmpty = false;
                                context.read<BackToStoreBloc>().updateLoader = true;
                                context.read<BackToStoreBloc>().isZeroValue = false;
                                context.read<BackToStoreBloc>().formatError = false;
                                context.read<BackToStoreBloc>().moreQuantityError = false;
                                FocusManager.instance.primaryFocus!.unfocus();
                                context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                                context.read<BackToStoreBloc>().add(BackToStorePickedQtyEvent(
                                    comments: commentsBar.text,
                                    pickedQty: double.parse(quantityBar.text),
                                    id: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].id));
                              }
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
                              getIt<Variables>().generalVariables.currentLanguage.picked.toUpperCase(),
                              style: TextStyle(
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        } else {
          return SizedBox(
            width: getIt<Variables>().generalVariables.width,
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
                            color: Color(int.parse('0xFF${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].typeColor}'))),
                        child: Center(
                          child: Text(
                            context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemType,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: getIt<Functions>().getTextSize(
                                    fontSize: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemType.length >= 2 ? 14 : 18),
                                color: const Color(0xFFFFFFFF)),
                          ),
                        ),
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
                                context.read<BackToStoreBloc>().backToStoreListResponse.items[index].itemName,
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                    color: const Color(0xff282F3A),
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            Text(
                              "${getIt<Variables>().generalVariables.currentLanguage.quantityToPick} : ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].quantity} ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].uom}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 13),
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
                        height: getIt<Functions>().getWidgetHeight(height: 12),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "${getIt<Variables>().generalVariables.currentLanguage.notes.toUpperCase()} :  ",
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: const Color(0xff8A8D8E), fontWeight: FontWeight.w500),
                          children: [
                            TextSpan(
                                text: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].btsNotes,
                                style: TextStyle(
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                    color: const Color(0xff282F3A),
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      context.read<BackToStoreBloc>().tabIndex == 2
                          ? SizedBox(
                              height: getIt<Functions>().getWidgetHeight(height: 28),
                            )
                          : const SizedBox(),
                      context.read<BackToStoreBloc>().tabIndex == 2
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getIt<Variables>().generalVariables.currentLanguage.reason,
                                      style: TextStyle(
                                          color: const Color(0xff282F3A),
                                          fontWeight: FontWeight.w600,
                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                    SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 45),
                                      child: TextFormField(
                                        initialValue: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].unavailReason,
                                        readOnly: true,
                                        enabled: false,
                                        style: TextStyle(
                                          color: const Color(0xff8A8D8E),
                                          fontWeight: FontWeight.w400,
                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                        ),
                                        decoration: InputDecoration(
                                          fillColor: const Color(0xffffffff),
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
                                              borderSide: const BorderSide(color: Color(0xff007AFF), width: 0.73)),
                                          focusedErrorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(4),
                                              borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                                SizedBox(
                                  width: getIt<Functions>().getWidgetWidth(width: 20),
                                ),
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getIt<Variables>().generalVariables.currentLanguage.comments,
                                      style: TextStyle(
                                          color: const Color(0xff282F3A),
                                          fontWeight: FontWeight.w600,
                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                    SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 45),
                                      child: TextFormField(
                                        initialValue: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].remarks,
                                        readOnly: true,
                                        style: TextStyle(
                                          color: const Color(0xff8A8D8E),
                                          fontWeight: FontWeight.w400,
                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                        ),
                                        enabled: false,
                                        decoration: InputDecoration(
                                          fillColor: const Color(0xffffffff),
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
                                              borderSide: const BorderSide(color: Color(0xff007AFF), width: 0.73)),
                                          focusedErrorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(4),
                                              borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                              ],
                            )
                          : const SizedBox(),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 28),
                      ),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 86),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getIt<Variables>().generalVariables.currentLanguage.enterQuantity,
                              style: TextStyle(
                                  color: const Color(0xff282F3A),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                            ),
                            SizedBox(
                              height: getIt<Functions>().getWidgetHeight(height: 45),
                              child: TextFormField(
                                controller: quantityBar,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                autofocus: true,
                                inputFormatters: [
                                  NumberInputFormatter(onError: (value) {
                                    context.read<BackToStoreBloc>().formatError = value;
                                    context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                                  })
                                ],
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    context.read<BackToStoreBloc>().textFieldEmpty = true;
                                    context.read<BackToStoreBloc>().formatError = false;
                                    context.read<BackToStoreBloc>().isZeroValue = false;
                                    context.read<BackToStoreBloc>().moreQuantityError = false;
                                    context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                                  } else {
                                    context.read<BackToStoreBloc>().textFieldEmpty = false;
                                    context.read<BackToStoreBloc>().formatError = false;
                                    context.read<BackToStoreBloc>().isZeroValue = false;
                                    if (double.parse(value) >
                                        double.parse(context.read<BackToStoreBloc>().backToStoreListResponse.items[index].quantity)) {
                                      context.read<BackToStoreBloc>().moreQuantityError = true;
                                      context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                                    } else {
                                      context.read<BackToStoreBloc>().moreQuantityError = false;
                                      context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                                    }
                                  }
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
                                      borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xff007AFF), width: 0.73)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                                  hintText: getIt<Variables>().generalVariables.currentLanguage.enterQuantity,
                                  hintStyle: TextStyle(
                                    color: const Color(0xff8A8D8E),
                                    fontWeight: FontWeight.w400,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                  ),
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                        vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                    child: Text(
                                      context.read<BackToStoreBloc>().backToStoreListResponse.items[index].uom.toUpperCase(),
                                      style: TextStyle(
                                        color: const Color(0xff8A8D8E),
                                        fontWeight: FontWeight.w500,
                                        fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                                validator: (value) => value!.isEmpty ? 'Please enter your comments' : null,
                              ),
                            ),
                            context.read<BackToStoreBloc>().textFieldEmpty ||
                                    context.read<BackToStoreBloc>().formatError ||
                                    context.read<BackToStoreBloc>().moreQuantityError ||
                                    context.read<BackToStoreBloc>().isZeroValue
                                ? Text(
                                    context.read<BackToStoreBloc>().textFieldEmpty
                                        ? getIt<Variables>().generalVariables.currentLanguage.textFieldEmpty
                                        : context.read<BackToStoreBloc>().formatError
                                            ? "${getIt<Variables>().generalVariables.currentLanguage.lessThan10000} ${context.read<BackToStoreBloc>().backToStoreListResponse.items[index].uom} (ex: 9999.999)."
                                            : context.read<BackToStoreBloc>().isZeroValue
                                                ? getIt<Variables>().generalVariables.currentLanguage.zeroQuantity
                                                : context.read<BackToStoreBloc>().moreQuantityError
                                                    ? getIt<Variables>().generalVariables.currentLanguage.moreQuantity
                                                    : "",
                                    style: TextStyle(
                                        color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 10)),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
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
                              getIt<Variables>().generalVariables.currentLanguage.notes,
                              style: TextStyle(
                                  color: const Color(0xff282F3A),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                            ),
                            SizedBox(
                              height: getIt<Functions>().getWidgetHeight(height: 45),
                              child: TextFormField(
                                controller: commentsBar,
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
                                  hintText: getIt<Variables>().generalVariables.currentLanguage.enterHere,
                                  hintStyle: TextStyle(
                                    color: const Color(0xff8A8D8E),
                                    fontWeight: FontWeight.w400,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                  ),
                                ),
                                onChanged: (val) {
                                  context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                                },
                                validator: (value) =>
                                    value!.isEmpty ? getIt<Variables>().generalVariables.currentLanguage.pleaseEnterTheComments : null,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 20),
                      ),
                    ],
                  ),
                ),
                context.read<BackToStoreBloc>().updateLoader
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
                          if (!context.read<BackToStoreBloc>().moreQuantityError) {
                            if (quantityBar.text.isEmpty) {
                              context.read<BackToStoreBloc>().textFieldEmpty = true;
                              context.read<BackToStoreBloc>().formatError = false;
                              context.read<BackToStoreBloc>().moreQuantityError = false;
                              context.read<BackToStoreBloc>().isZeroValue = false;
                              context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                            } else {
                              if (quantityBar.text == "." || double.parse(quantityBar.text) == 0.0) {
                                quantityBar.text = "0.0";
                                context.read<BackToStoreBloc>().isZeroValue = true;
                                context.read<BackToStoreBloc>().textFieldEmpty = false;
                                context.read<BackToStoreBloc>().formatError = false;
                                context.read<BackToStoreBloc>().moreQuantityError = false;
                                context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                              } else {
                                context.read<BackToStoreBloc>().textFieldEmpty = false;
                                context.read<BackToStoreBloc>().updateLoader = true;
                                context.read<BackToStoreBloc>().isZeroValue = false;
                                context.read<BackToStoreBloc>().formatError = false;
                                context.read<BackToStoreBloc>().moreQuantityError = false;
                                FocusManager.instance.primaryFocus!.unfocus();
                                context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                                context.read<BackToStoreBloc>().add(BackToStorePickedQtyEvent(
                                    comments: commentsBar.text,
                                    pickedQty: double.parse(quantityBar.text),
                                    id: context.read<BackToStoreBloc>().backToStoreListResponse.items[index].id));
                              }
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
                              getIt<Variables>().generalVariables.currentLanguage.picked.toUpperCase(),
                              style: TextStyle(
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildDropButton() {
    return Container(
      height: getIt<Functions>().getWidgetHeight(height: 45),
      decoration: BoxDecoration(
          color: const Color(0xffffffff), borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffE0E7EC), width: 0.73)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: changeReason,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  context.read<BackToStoreBloc>().selectedReasonName ?? getIt<Variables>().generalVariables.currentLanguage.chooseReason,
                  style: TextStyle(
                      fontSize: context.read<BackToStoreBloc>().selectedReasonName == null ? 12 : 15,
                      color: context.read<BackToStoreBloc>().selectedReasonName == null ? Colors.grey.shade500 : Colors.black),
                ),
              ),
              context.read<BackToStoreBloc>().selectedReasonName != null
                  ? InkWell(
                      onTap: () {
                        context.read<BackToStoreBloc>().selectedReasonName = null;
                        context.read<BackToStoreBloc>().selectedReasonEmpty = false;
                        context.read<BackToStoreBloc>().selectedReason = "";
                        context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent(stillLoading: false));
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
    List<UnavailableBTSReason> searchReasons = context.read<BackToStoreBloc>().backToStoreListResponse.unavailableReasons;
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
                                  context.read<BackToStoreBloc>().selectedReasonEmpty = false;
                                  context.read<BackToStoreBloc>().selectedReasonName = "";
                                  context.read<BackToStoreBloc>().selectedReason = "";
                                  context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent(stillLoading: false));
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
                          .read<BackToStoreBloc>()
                          .backToStoreListResponse
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
                          context.read<BackToStoreBloc>().selectedReasonName = searchReasons[index].description;
                          context.read<BackToStoreBloc>().selectedReasonEmpty = false;
                          context.read<BackToStoreBloc>().selectedReason = searchReasons[index].id;
                          context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent(stillLoading: false));
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
