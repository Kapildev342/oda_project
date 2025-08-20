// Dart imports:
import 'dart:async';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
// Project imports:
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/bloc/pick_list/pick_list/pick_list_bloc.dart';
import 'package:oda/bloc/pick_list/pick_list_details/pick_list_details_bloc.dart';
import 'package:oda/edited_packages/drop_down_lib/drop_down_search_field.dart';
import 'package:oda/local_database/pick_list_box/pick_list.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/screens/home/home_screen.dart';
import 'package:oda/screens/pick_list/pick_list_details_screen.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PickListScreen extends StatefulWidget {
  static const String id = "pick_list_screen";

  const PickListScreen({super.key});

  @override
  State<PickListScreen> createState() => _PickListScreenState();
}

class _PickListScreenState extends State<PickListScreen> {
  TextEditingController locationSearchFieldController = TextEditingController();
  SuggestionsBoxController locationSuggestionBoxController = SuggestionsBoxController();
  TextEditingController searchBar = TextEditingController();
  RefreshController refreshController = RefreshController();
  Timer? timer;

  @override
  void initState() {
    context.read<PickListBloc>().add(const PickListInitialEvent(/*isRefreshing: false*/));
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
          if (context.read<PickListBloc>().isLocationSelected) {
            context.read<NavigationBloc>().add(const BottomNavigationEvent(index: 0));
            getIt<Variables>().generalVariables.indexName = HomeScreen.id;
            context.read<NavigationBloc>().add(const NavigationInitialEvent());
          } else {}
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
                  BlocBuilder<PickListBloc, PickListState>(
                    builder: (BuildContext context, PickListState state) {
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
                          forceMaterialTransparency: true,
                          titleSpacing: 0,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  getIt<Variables>().generalVariables.currentLanguage.picklist,
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
                            IconButton(
                              onPressed: state is PickListLoading
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
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: BlocConsumer<PickListBloc, PickListState>(
                      listenWhen: (PickListState previous, PickListState current) {
                        return previous != current;
                      },
                      buildWhen: (PickListState previous, PickListState current) {
                        return previous != current;
                      },
                      listener: (BuildContext context, PickListState state) {
                        if (state is PickListDialogState) {
                          getIt<Variables>().generalVariables.popUpWidget = pickListFloorChoosingContent(contextNew: context);
                          getIt<Functions>()
                              .showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: true, isBackEnabled: true);
                        }
                        if (state is PickListFailure) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                        }
                      },
                      builder: (BuildContext context, PickListState state) {
                        if (state is PickListLoading) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: SizedBox(
                                  height: getIt<Functions>().getWidgetHeight(height: 50),
                                  child: Skeletonizer(
                                      enabled: true,
                                      child: Row(
                                        children: [
                                          Container(
                                              height: getIt<Functions>().getWidgetHeight(height: 45),
                                              margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 10)),
                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 10)),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  color: getIt<Variables>().generalVariables.selectedFiltersName.isEmpty
                                                      ? const Color(0xffEEF4FF)
                                                      : Colors.white,
                                                  border: Border.all(
                                                      color: getIt<Variables>().generalVariables.selectedFiltersName.isEmpty
                                                          ? const Color(0xff8A8D8E).withOpacity(0.5)
                                                          : const Color(0xff8A8D8E),
                                                      width: 1)),
                                              child: Center(
                                                child: Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.clearAll,
                                                  style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                    color: getIt<Variables>().generalVariables.selectedFiltersName.isEmpty
                                                        ? const Color(0xff1D2736).withOpacity(0.5)
                                                        : const Color(0xff1D2736),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              )),
                                        ],
                                      )),
                                ),
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                              Expanded(
                                child: Skeletonizer(
                                  enabled: true,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                      width: getIt<Functions>().getWidgetWidth(
                                          width: Orientation.portrait == MediaQuery.of(context).orientation
                                              ? getIt<Variables>().generalVariables.width * 2
                                              : getIt<Variables>().generalVariables.height * 2),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: getIt<Functions>().getWidgetHeight(height: 40),
                                            color: const Color(0xffE0E7EC),
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              physics: const NeverScrollableScrollPhysics(),
                                              children: [
                                                SizedBox(
                                                  width: getIt<Functions>().getWidgetWidth(
                                                      width: Orientation.portrait == MediaQuery.of(context).orientation
                                                          ? getIt<Variables>().generalVariables.width / 4
                                                          : getIt<Variables>().generalVariables.height / 4),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.picklist,
                                                        style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: getIt<Functions>().getWidgetWidth(
                                                      width: Orientation.portrait == MediaQuery.of(context).orientation
                                                          ? getIt<Variables>().generalVariables.width / 4
                                                          : getIt<Variables>().generalVariables.height / 4),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.total,
                                                        style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: getIt<Functions>().getWidgetWidth(
                                                      width: Orientation.portrait == MediaQuery.of(context).orientation
                                                          ? getIt<Variables>().generalVariables.width / 4
                                                          : getIt<Variables>().generalVariables.height / 4),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.created,
                                                        style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: getIt<Functions>().getWidgetWidth(
                                                      width: Orientation.portrait == MediaQuery.of(context).orientation
                                                          ? getIt<Variables>().generalVariables.width / 4
                                                          : getIt<Variables>().generalVariables.height / 4),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      Text(
                                                        getIt<Variables>()
                                                            .generalVariables
                                                            .currentLanguage
                                                            .status
                                                            .toLowerCase()
                                                            .replaceFirst('s', "S"),
                                                        style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: getIt<Functions>().getWidgetWidth(
                                                      width: Orientation.portrait == MediaQuery.of(context).orientation
                                                          ? getIt<Variables>().generalVariables.width / 4
                                                          : getIt<Variables>().generalVariables.height / 4),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.completed,
                                                        style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: getIt<Functions>().getWidgetWidth(
                                                      width: Orientation.portrait == MediaQuery.of(context).orientation
                                                          ? getIt<Variables>().generalVariables.width / 4
                                                          : getIt<Variables>().generalVariables.height / 4),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.handled,
                                                        style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                          Expanded(
                                            child: Skeletonizer(
                                              enabled: true,
                                              child: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  physics: const BouncingScrollPhysics(),
                                                  itemCount: 1,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          height: getIt<Functions>().getWidgetHeight(height: 40),
                                                          child: ListView(
                                                            scrollDirection: Axis.horizontal,
                                                            physics: const NeverScrollableScrollPhysics(),
                                                            children: [
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(
                                                                    width: Orientation.portrait == MediaQuery.of(context).orientation
                                                                        ? getIt<Variables>().generalVariables.width / 4
                                                                        : getIt<Variables>().generalVariables.height / 4),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              "123456789",
                                                                              style: TextStyle(
                                                                                  color: const Color(0xff282F3A),
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize:
                                                                                      getIt<Functions>().getTextSize(fontSize: 12)),
                                                                            ),
                                                                            SizedBox(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 8)),
                                                                            Skeleton.shade(
                                                                              child: SvgPicture.asset(
                                                                                "assets/pick_list/picklist_red.svg",
                                                                                height: getIt<Functions>().getWidgetHeight(height: 12),
                                                                                width: getIt<Functions>().getWidgetWidth(width: 12),
                                                                                fit: BoxFit.fill,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Text(
                                                                          "(Colombia)",
                                                                          style: TextStyle(
                                                                              color: const Color(0xff8A8D8E),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(
                                                                    width: Orientation.portrait == MediaQuery.of(context).orientation
                                                                        ? getIt<Variables>().generalVariables.width / 4
                                                                        : getIt<Variables>().generalVariables.height / 4),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "200/250",
                                                                          style: TextStyle(
                                                                              color: const Color(0xff282F3A),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                        ),
                                                                        Skeleton.shade(
                                                                          child: Container(
                                                                            height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                            width: getIt<Functions>().getWidgetWidth(width: 24),
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.deepPurpleAccent,
                                                                              borderRadius: BorderRadius.circular(3),
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                "D",
                                                                                style: TextStyle(
                                                                                    color: const Color(0xffffffff),
                                                                                    fontSize:
                                                                                        getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    fontWeight: FontWeight.w700),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(
                                                                    width: Orientation.portrait == MediaQuery.of(context).orientation
                                                                        ? getIt<Variables>().generalVariables.width / 4
                                                                        : getIt<Variables>().generalVariables.height / 4),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "27/11/2024",
                                                                          maxLines: 2,
                                                                          style: TextStyle(
                                                                              color: const Color(0xff282F3A),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                        ),
                                                                        Text(
                                                                          "11:00 PM",
                                                                          maxLines: 2,
                                                                          style: TextStyle(
                                                                              color: const Color(0xff282F3A),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(
                                                                    width: Orientation.portrait == MediaQuery.of(context).orientation
                                                                        ? getIt<Variables>().generalVariables.width / 4
                                                                        : getIt<Variables>().generalVariables.height / 4),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "Pending",
                                                                          style: TextStyle(
                                                                              color: Colors.red,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(
                                                                    width: Orientation.portrait == MediaQuery.of(context).orientation
                                                                        ? getIt<Variables>().generalVariables.width / 4
                                                                        : getIt<Variables>().generalVariables.height / 4),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "27/11/2024",
                                                                          style: TextStyle(
                                                                              color: const Color(0xff282F3A),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                        ),
                                                                        Text(
                                                                          "11:00 PM",
                                                                          maxLines: 2,
                                                                          style: TextStyle(
                                                                              color: const Color(0xff282F3A),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(
                                                                    width: Orientation.portrait == MediaQuery.of(context).orientation
                                                                        ? getIt<Variables>().generalVariables.width / 4
                                                                        : getIt<Variables>().generalVariables.height / 4),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                    Skeleton.shade(
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                            width: getIt<Functions>().getWidgetWidth(width: 95),
                                                                            child: Stack(
                                                                                children: List<Widget>.generate(
                                                                                    3,
                                                                                    (i) => i == 0
                                                                                        ? const CircleAvatar(
                                                                                            radius: 18, backgroundColor: Colors.grey)
                                                                                        : Positioned(
                                                                                            left: i * 22,
                                                                                            child: const CircleAvatar(
                                                                                                radius: 18,
                                                                                                backgroundColor: Colors.grey),
                                                                                          ))),
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
                                                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
                                                        const Divider(color: Color(0xffE0E7EC), height: 0, thickness: 1),
                                                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 17)),
                                                      ],
                                                    );
                                                  }),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (state is PickListTableLoading) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: getIt<Functions>().getWidgetHeight(height: 45),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: getIt<Functions>().getWidgetHeight(height: 45),
                                        margin: EdgeInsets.only(
                                            left: getIt<Functions>().getWidgetWidth(width: 12),
                                            right: getIt<Functions>().getWidgetWidth(width: 12),
                                            bottom: getIt<Functions>().getWidgetHeight(height: 10)),
                                        padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 10)),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: getIt<Variables>().generalVariables.selectedFiltersName.isEmpty
                                                ? const Color(0xffEEF4FF)
                                                : Colors.white,
                                            border: Border.all(
                                                color: getIt<Variables>().generalVariables.selectedFiltersName.isEmpty
                                                    ? const Color(0xff8A8D8E).withOpacity(0.5)
                                                    : const Color(0xff8A8D8E),
                                                width: 1)),
                                        child: Center(
                                          child: Text(
                                            getIt<Variables>().generalVariables.currentLanguage.clearAll,
                                            style: TextStyle(
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: getIt<Variables>().generalVariables.selectedFiltersName.isEmpty
                                                  ? const Color(0xff1D2736).withOpacity(0.5)
                                                  : const Color(0xff1D2736),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )),
                                    Expanded(
                                      child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.horizontal,
                                          physics: const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: getIt<Variables>().generalVariables.selectedFiltersName.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Container(
                                              margin: EdgeInsets.only(
                                                  right: getIt<Functions>().getWidgetWidth(width: 10),
                                                  bottom: getIt<Functions>().getWidgetHeight(height: 10)),
                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 10)),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  color: const Color(0xffEEF4FF),
                                                  border: Border.all(color: const Color(0xff007AFF), width: 1)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        getIt<Variables>().generalVariables.selectedFiltersName[index],
                                                        style: TextStyle(
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                          color: const Color(0xff1D2736),
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 2)),
                                                      Text(
                                                        getIt<Variables>().generalVariables.selectedFilters[index].options.length > 1
                                                            ? "+${getIt<Variables>().generalVariables.selectedFilters[index].options.length - 1} more"
                                                            : "",
                                                        style: TextStyle(
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                          color: const Color(0xff007AFF),
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: getIt<Functions>().getWidgetWidth(width: 8),
                                                  ),
                                                  SvgPicture.asset(
                                                    "assets/catch_weight/close-circle.svg",
                                                    height: getIt<Functions>().getWidgetHeight(height: 22),
                                                    width: getIt<Functions>().getWidgetWidth(width: 22),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 16)),
                                  child: Column(
                                    children: [
                                      SfDataGridTheme(
                                        data: const SfDataGridThemeData(
                                          headerColor: Colors.transparent,
                                          gridLineColor: Colors.transparent,
                                          selectionColor: Colors.transparent,
                                          frozenPaneLineColor: Colors.transparent,
                                        ),
                                        child: SfDataGrid(
                                          columns: [
                                            GridColumn(
                                              columnName: "pick_list",
                                              label: Container(
                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xffE0E7EC),
                                                  borderRadius: BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(getIt<Variables>().generalVariables.isDeviceTablet ? 4 : 4),
                                                      topLeft:
                                                          Radius.circular(getIt<Variables>().generalVariables.isDeviceTablet ? 4 : 4)),
                                                ),
                                                child: ListView(
                                                  scrollDirection: Axis.horizontal,
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.picklist,
                                                        style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: "total",
                                              label: Container(
                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xffE0E7EC),
                                                ),
                                                child: ListView(
                                                  scrollDirection: Axis.horizontal,
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.total,
                                                        style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: "created",
                                              label: Container(
                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xffE0E7EC),
                                                ),
                                                child: ListView(
                                                  scrollDirection: Axis.horizontal,
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.created,
                                                        style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: "status",
                                              label: Container(
                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xffE0E7EC),
                                                ),
                                                child: ListView(
                                                  scrollDirection: Axis.horizontal,
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        getIt<Variables>()
                                                            .generalVariables
                                                            .currentLanguage
                                                            .status
                                                            .toLowerCase()
                                                            .replaceFirst('s', "S"),
                                                        style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: "delivery_area",
                                              label: Container(
                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xffE0E7EC),
                                                ),
                                                child: ListView(
                                                  scrollDirection: Axis.horizontal,
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.deliveryArea,
                                                        style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: "order_type",
                                              label: Container(
                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xffE0E7EC),
                                                ),
                                                child: ListView(
                                                  scrollDirection: Axis.horizontal,
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.orderType,
                                                        style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: "completed",
                                              label: Container(
                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xffE0E7EC),
                                                ),
                                                child: ListView(
                                                  scrollDirection: Axis.horizontal,
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.completed,
                                                        style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: "handled",
                                              label: Container(
                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xffE0E7EC),
                                                  borderRadius: BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(getIt<Variables>().generalVariables.isDeviceTablet ? 4 : 4),
                                                      topRight:
                                                          Radius.circular(getIt<Variables>().generalVariables.isDeviceTablet ? 4 : 4)),
                                                ),
                                                child: ListView(
                                                  scrollDirection: Axis.horizontal,
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.handled,
                                                        style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                          shrinkWrapRows: true,
                                          shrinkWrapColumns: true,
                                          columnWidthMode: ColumnWidthMode.fill,
                                          rowHeight: 65,
                                          headerRowHeight: 40,
                                          headerGridLinesVisibility: GridLinesVisibility.none,
                                          gridLinesVisibility: GridLinesVisibility.horizontal,
                                          columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                                          source: PickListMainDataSource(pickListData: [], context: context),
                                          allowPullToRefresh: true,
                                        ),
                                      ),
                                      Expanded(
                                        child: Skeletonizer(
                                          enabled: true,
                                          child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics: const BouncingScrollPhysics(),
                                              itemCount: 1,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      height: getIt<Functions>().getWidgetHeight(height: 40),
                                                      child: ListView(
                                                        scrollDirection: Axis.horizontal,
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        children: [
                                                          SizedBox(
                                                            width: getIt<Functions>().getWidgetWidth(
                                                                width: Orientation.portrait == MediaQuery.of(context).orientation
                                                                    ? getIt<Variables>().generalVariables.width / 4
                                                                    : getIt<Variables>().generalVariables.height / 4),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Text(
                                                                          "123456789",
                                                                          style: TextStyle(
                                                                              color: const Color(0xff282F3A),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                        ),
                                                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                                                        Skeleton.shade(
                                                                          child: SvgPicture.asset(
                                                                            "assets/pick_list/picklist_red.svg",
                                                                            height: getIt<Functions>().getWidgetHeight(height: 12),
                                                                            width: getIt<Functions>().getWidgetWidth(width: 12),
                                                                            fit: BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Text(
                                                                      "(Colombia)",
                                                                      style: TextStyle(
                                                                          color: const Color(0xff8A8D8E),
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: getIt<Functions>().getWidgetWidth(
                                                                width: Orientation.portrait == MediaQuery.of(context).orientation
                                                                    ? getIt<Variables>().generalVariables.width / 4
                                                                    : getIt<Variables>().generalVariables.height / 4),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      "200/250",
                                                                      style: TextStyle(
                                                                          color: const Color(0xff282F3A),
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                    ),
                                                                    Skeleton.shade(
                                                                      child: Container(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                        width: getIt<Functions>().getWidgetWidth(width: 24),
                                                                        decoration: BoxDecoration(
                                                                          color: Colors.deepPurpleAccent,
                                                                          borderRadius: BorderRadius.circular(3),
                                                                        ),
                                                                        child: Center(
                                                                          child: Text(
                                                                            "D",
                                                                            style: TextStyle(
                                                                                color: const Color(0xffffffff),
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: getIt<Functions>().getWidgetWidth(
                                                                width: Orientation.portrait == MediaQuery.of(context).orientation
                                                                    ? getIt<Variables>().generalVariables.width / 4
                                                                    : getIt<Variables>().generalVariables.height / 4),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      "27/11/2024",
                                                                      maxLines: 2,
                                                                      style: TextStyle(
                                                                          color: const Color(0xff282F3A),
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                    ),
                                                                    Text(
                                                                      "11:00 PM",
                                                                      maxLines: 2,
                                                                      style: TextStyle(
                                                                          color: const Color(0xff282F3A),
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: getIt<Functions>().getWidgetWidth(
                                                                width: Orientation.portrait == MediaQuery.of(context).orientation
                                                                    ? getIt<Variables>().generalVariables.width / 4
                                                                    : getIt<Variables>().generalVariables.height / 4),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      "Pending",
                                                                      style: TextStyle(
                                                                          color: Colors.red,
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: getIt<Functions>().getWidgetWidth(
                                                                width: Orientation.portrait == MediaQuery.of(context).orientation
                                                                    ? getIt<Variables>().generalVariables.width / 4
                                                                    : getIt<Variables>().generalVariables.height / 4),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      "27/11/2024",
                                                                      style: TextStyle(
                                                                          color: const Color(0xff282F3A),
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                    ),
                                                                    Text(
                                                                      "11:00 PM",
                                                                      maxLines: 2,
                                                                      style: TextStyle(
                                                                          color: const Color(0xff282F3A),
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: getIt<Functions>().getWidgetWidth(
                                                                width: Orientation.portrait == MediaQuery.of(context).orientation
                                                                    ? getIt<Variables>().generalVariables.width / 4
                                                                    : getIt<Variables>().generalVariables.height / 4),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                Skeleton.shade(
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width: getIt<Functions>().getWidgetWidth(width: 95),
                                                                        child: Stack(
                                                                            children: List<Widget>.generate(
                                                                                3,
                                                                                (i) => i == 0
                                                                                    ? const CircleAvatar(
                                                                                        radius: 18, backgroundColor: Colors.grey)
                                                                                    : Positioned(
                                                                                        left: i * 22,
                                                                                        child: const CircleAvatar(
                                                                                            radius: 18, backgroundColor: Colors.grey),
                                                                                      ))),
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
                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
                                                    const Divider(color: Color(0xffE0E7EC), height: 0, thickness: 1),
                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 17)),
                                                  ],
                                                );
                                              }),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (state is PickListLoaded) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: getIt<Functions>().getWidgetHeight(height: 45),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (getIt<Variables>().generalVariables.selectedFilters.isNotEmpty) {
                                          getIt<Variables>().generalVariables.selectedFilters.clear();
                                          getIt<Variables>().generalVariables.selectedFiltersName.clear();
                                          context.read<PickListBloc>().add(const PickListSetStateEvent());
                                          context.read<PickListBloc>().add(const PickListTabChangingEvent(isLoading: false));
                                        }
                                      },
                                      child: Container(
                                          height: getIt<Functions>().getWidgetHeight(height: 45),
                                          margin: EdgeInsets.only(
                                              left: getIt<Functions>().getWidgetWidth(width: 12),
                                              right: getIt<Functions>().getWidgetWidth(width: 12),
                                              bottom: getIt<Functions>().getWidgetHeight(height: 10)),
                                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 10)),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: getIt<Variables>().generalVariables.selectedFiltersName.isEmpty
                                                  ? const Color(0xffEEF4FF)
                                                  : Colors.white,
                                              border: Border.all(
                                                  color: getIt<Variables>().generalVariables.selectedFiltersName.isEmpty
                                                      ? const Color(0xff8A8D8E).withOpacity(0.5)
                                                      : const Color(0xff8A8D8E),
                                                  width: 1)),
                                          child: Center(
                                            child: Text(
                                              getIt<Variables>().generalVariables.currentLanguage.clearAll,
                                              style: TextStyle(
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                color: getIt<Variables>().generalVariables.selectedFiltersName.isEmpty
                                                    ? const Color(0xff1D2736).withOpacity(0.5)
                                                    : const Color(0xff1D2736),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          )),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.horizontal,
                                          physics: const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: getIt<Variables>().generalVariables.selectedFiltersName.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Container(
                                              margin: EdgeInsets.only(
                                                  right: getIt<Functions>().getWidgetWidth(width: 10),
                                                  bottom: getIt<Functions>().getWidgetHeight(height: 10)),
                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 10)),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  color: const Color(0xffEEF4FF),
                                                  border: Border.all(color: const Color(0xff007AFF), width: 1)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        getIt<Variables>().generalVariables.selectedFiltersName[index],
                                                        style: TextStyle(
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                          color: const Color(0xff1D2736),
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 2)),
                                                      Text(
                                                        getIt<Variables>().generalVariables.selectedFilters[index].options.length > 1
                                                            ? "+${getIt<Variables>().generalVariables.selectedFilters[index].options.length - 1} more"
                                                            : "",
                                                        style: TextStyle(
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                          color: const Color(0xff007AFF),
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                                  InkWell(
                                                    onTap: () {
                                                      getIt<Variables>().generalVariables.selectedFilters.removeAt(index);
                                                      getIt<Variables>().generalVariables.selectedFiltersName.removeAt(index);
                                                      context.read<PickListBloc>().add(const PickListSetStateEvent());
                                                      context
                                                          .read<PickListBloc>()
                                                          .add(const PickListTabChangingEvent(isLoading: false));
                                                    },
                                                    child: SvgPicture.asset(
                                                      "assets/catch_weight/close-circle.svg",
                                                      height: getIt<Functions>().getWidgetHeight(height: 22),
                                                      width: getIt<Functions>().getWidgetWidth(width: 22),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                              Expanded(
                                child: Container(
                                    margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetWidth(width: 8)),
                                    padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 16)),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: SfDataGridTheme(
                                          data: const SfDataGridThemeData(
                                            headerColor: Colors.transparent,
                                            gridLineColor: Colors.transparent,
                                            selectionColor: Colors.transparent,
                                            frozenPaneLineColor: Colors.transparent,
                                          ),
                                          child: SfDataGrid(
                                            columns: [
                                              GridColumn(
                                                columnName: getIt<Variables>().generalVariables.currentLanguage.picklist,
                                                label: Container(
                                                  padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xffE0E7EC),
                                                    borderRadius: BorderRadius.only(
                                                        bottomLeft: Radius.circular(getIt<Variables>().generalVariables.isDeviceTablet ? 4 : 4),
                                                        topLeft: Radius.circular(getIt<Variables>().generalVariables.isDeviceTablet ? 4 : 4)),
                                                  ),
                                                  child: Center(
                                                    child: AutoSizeText(
                                                      maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      maxLines: 2,
                                                      getIt<Variables>().generalVariables.currentLanguage.picklist,
                                                      style:
                                                      const TextStyle(color: Color(0xff282F3A), fontWeight: FontWeight.w700, fontFamily: "Figtree"),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: getIt<Variables>().generalVariables.currentLanguage.total,
                                                label: Container(
                                                  padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xffE0E7EC),
                                                  ),
                                                  child: Align(
                                                    alignment: AlignmentDirectional.centerStart,
                                                    child: AutoSizeText(
                                                      maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      maxLines: 2,
                                                      getIt<Variables>().generalVariables.currentLanguage.total,
                                                      style:
                                                      const TextStyle(color: Color(0xff282F3A), fontWeight: FontWeight.w700, fontFamily: "Figtree"),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: getIt<Variables>().generalVariables.currentLanguage.created,
                                                label: Container(
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xffE0E7EC),
                                                  ),
                                                  child: Center(
                                                    child: FittedBox(
                                                      child: AutoSizeText(
                                                        maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                        maxLines: 2,
                                                        getIt<Variables>().generalVariables.currentLanguage.created,
                                                        style: const TextStyle(
                                                            color: Color(0xff282F3A), fontWeight: FontWeight.w700, fontFamily: "Figtree"),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: getIt<Variables>().generalVariables.currentLanguage.status,
                                                label: Container(
                                                  padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xffE0E7EC),
                                                  ),
                                                  child: Align(
                                                    alignment: AlignmentDirectional.centerStart,
                                                    child: AutoSizeText(
                                                      maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      maxLines: 2,
                                                      getIt<Variables>().generalVariables.currentLanguage.status.toLowerCase().replaceFirst('s', "S"),
                                                      style:
                                                      const TextStyle(color: Color(0xff282F3A), fontWeight: FontWeight.w700, fontFamily: "Figtree"),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: getIt<Variables>().generalVariables.currentLanguage.deliveryArea,
                                                label: Container(
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xffE0E7EC),
                                                  ),
                                                  child: Center(
                                                    child: AutoSizeText(
                                                      maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      maxLines: 2,
                                                      getIt<Variables>().generalVariables.currentLanguage.deliveryArea,
                                                      style:
                                                      const TextStyle(color: Color(0xff282F3A), fontWeight: FontWeight.w700, fontFamily: "Figtree"),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: getIt<Variables>().generalVariables.currentLanguage.orderType,
                                                label: Container(
                                                  padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xffE0E7EC),
                                                  ),
                                                  child: Align(
                                                    alignment: AlignmentDirectional.centerStart,
                                                    child: AutoSizeText(
                                                      maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      maxLines: 2,
                                                      getIt<Variables>().generalVariables.currentLanguage.orderType,
                                                      style:
                                                      const TextStyle(color: Color(0xff282F3A), fontWeight: FontWeight.w700, fontFamily: "Figtree"),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: getIt<Variables>().generalVariables.currentLanguage.completed,
                                                label: Container(
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xffE0E7EC),
                                                  ),
                                                  child: Center(
                                                    child: AutoSizeText(
                                                      maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      maxLines: 2,
                                                      getIt<Variables>().generalVariables.currentLanguage.completed,
                                                      style:
                                                      const TextStyle(color: Color(0xff282F3A), fontWeight: FontWeight.w700, fontFamily: "Figtree"),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: getIt<Variables>().generalVariables.currentLanguage.handled,
                                                label: Container(
                                                  padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 16)),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xffE0E7EC),
                                                    borderRadius: BorderRadius.only(
                                                        bottomRight: Radius.circular(getIt<Variables>().generalVariables.isDeviceTablet ? 4 : 4),
                                                        topRight: Radius.circular(getIt<Variables>().generalVariables.isDeviceTablet ? 4 : 4)),
                                                  ),
                                                  child: Center(
                                                    child: FittedBox(
                                                      child: AutoSizeText(
                                                        maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                        maxLines: 2,
                                                        getIt<Variables>().generalVariables.currentLanguage.handled,
                                                        style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                            columnWidthMode: ColumnWidthMode.fill,
                                            shrinkWrapRows: true,
                                            rowHeight: 65,
                                            headerRowHeight: 40,
                                            headerGridLinesVisibility: GridLinesVisibility.none,
                                            gridLinesVisibility: GridLinesVisibility.horizontal,
                                            source:
                                            PickListMainDataSource(pickListData: context.read<PickListBloc>().searchedPickList, context: context),
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
                                                          decoration: const BoxDecoration(
                                                              color: Colors.white,
                                                              border:
                                                              BorderDirectional(top: BorderSide(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.26)))),
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
                                                      return SizedBox.fromSize(size: Size.zero);
                                                    }
                                                  });
                                            },
                                            onCellTap: (DataGridCellTapDetails details) {
                                              if (details.rowColumnIndex.rowIndex != 0) {
                                                if (details.column.columnName == getIt<Variables>().generalVariables.currentLanguage.handled) {
                                                  if (context
                                                      .read<PickListBloc>()
                                                      .searchedPickList[details.rowColumnIndex.rowIndex - 1]
                                                      .handledBy
                                                      .isNotEmpty) {
                                                    getIt<Variables>().generalVariables.popUpWidget = usersDetailsContent(
                                                        handled: context
                                                            .read<PickListBloc>()
                                                            .searchedPickList[details.rowColumnIndex.rowIndex - 1]
                                                            .handledBy);
                                                    getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                                  }
                                                } else {
                                                  context.read<PickListDetailsBloc>().selectedPickListId = context.read<PickListBloc>().searchedPickList[details.rowColumnIndex.rowIndex - 1].id;
                                                  getIt<Variables>().generalVariables.picklistItemData = context.read<PickListBloc>().searchedPickList[details.rowColumnIndex.rowIndex - 1];
                                                  getIt<Variables>().generalVariables.indexName = PickListDetailsScreen.id;
                                                  getIt<Variables>().generalVariables.pickListRouteList.add(PickListScreen.id);
                                                  context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      context.read<PickListBloc>().searchedPickList.isEmpty
                                          ? Center(
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
                                                  getIt<Variables>().generalVariables.currentLanguage.pickListIsEmpty,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w600),
                                                ),
                                                const SizedBox(height: 150)
                                              ],
                                            ),
                                          )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  BlocBuilder<PickListBloc, PickListState>(
                    builder: (BuildContext context, PickListState pickList) {
                      return SizedBox(
                        height: getIt<Functions>().getWidgetHeight(height: 118),
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
                              forceMaterialTransparency: true,
                              title: AnimatedCrossFade(
                                firstChild: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        getIt<Variables>().generalVariables.currentLanguage.picklist,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 26),
                                            color: const Color(0xff282F3A)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                secondChild: textBars(controller: searchBar),
                                crossFadeState: context.read<PickListBloc>().searchBarEnabled
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                                duration: const Duration(milliseconds: 100),
                              ),
                              actions: [
                                IconButton(
                                  splashColor: Colors.transparent,
                                  splashRadius: 0.1,
                                  padding: EdgeInsets.zero,
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: pickList is PickListLoading
                                      ? () {}
                                      : () {
                                          context.read<PickListBloc>().searchBarEnabled =
                                              !context.read<PickListBloc>().searchBarEnabled;
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
                                  onPressed: pickList is PickListLoading
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
                                ),
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
                    child: BlocConsumer<PickListBloc, PickListState>(
                      listenWhen: (PickListState previous, PickListState current) {
                        return previous != current;
                      },
                      buildWhen: (PickListState previous, PickListState current) {
                        return previous != current;
                      },
                      listener: (BuildContext context, PickListState state) {
                        if (state is PickListDialogState) {
                          getIt<Variables>().generalVariables.popUpWidget = pickListFloorChoosingContent(contextNew: context);
                          getIt<Functions>()
                              .showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: true, isBackEnabled: true);
                        }
                        if (state is PickListFailure) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                        }
                      },
                      builder: (BuildContext context, PickListState state) {
                        if (state is PickListLoading) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: getIt<Functions>().getWidgetHeight(height: 50),
                                child: Skeletonizer(
                                    enabled: true,
                                    child: Row(
                                      children: [
                                        Container(
                                            height: getIt<Functions>().getWidgetHeight(height: 45),
                                            margin: EdgeInsets.only(
                                                left: getIt<Functions>().getWidgetWidth(width: 12),
                                                right: getIt<Functions>().getWidgetWidth(width: 12),
                                                bottom: getIt<Functions>().getWidgetHeight(height: 10)),
                                            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 10)),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: getIt<Variables>().generalVariables.selectedFiltersName.isEmpty
                                                    ? const Color(0xffEEF4FF)
                                                    : Colors.white,
                                                border: Border.all(
                                                    color: getIt<Variables>().generalVariables.selectedFiltersName.isEmpty
                                                        ? const Color(0xff8A8D8E).withOpacity(0.5)
                                                        : const Color(0xff8A8D8E),
                                                    width: 1)),
                                            child: Center(
                                              child: Text(
                                                getIt<Variables>().generalVariables.currentLanguage.clearAll,
                                                style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                  color: getIt<Variables>().generalVariables.selectedFiltersName.isEmpty
                                                      ? const Color(0xff1D2736).withOpacity(0.5)
                                                      : const Color(0xff1D2736),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )),
                                      ],
                                    )),
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                              Expanded(
                                child: Skeletonizer(
                                  enabled: true,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                      width: getIt<Functions>().getWidgetWidth(width: 600),
                                      margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 15)),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: getIt<Functions>().getWidgetHeight(height: 40),
                                            color: const Color(0xffE0E7EC),
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              physics: const NeverScrollableScrollPhysics(),
                                              children: [
                                                SizedBox(
                                                  width: getIt<Functions>().getWidgetWidth(width: 125),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.picklist,
                                                        style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: getIt<Functions>().getWidgetWidth(width: 75),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.total,
                                                        style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: getIt<Functions>().getWidgetWidth(width: 100),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.created,
                                                        style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: getIt<Functions>().getWidgetWidth(width: 75),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      Text(
                                                        getIt<Variables>()
                                                            .generalVariables
                                                            .currentLanguage
                                                            .status
                                                            .toLowerCase()
                                                            .replaceFirst('s', "S"),
                                                        style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: getIt<Functions>().getWidgetWidth(width: 100),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.completed,
                                                        style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: getIt<Functions>().getWidgetWidth(width: 125),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.handled,
                                                        style: TextStyle(
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                          Expanded(
                                            child: Skeletonizer(
                                              enabled: true,
                                              child: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  physics: const BouncingScrollPhysics(),
                                                  itemCount: 1,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          height: getIt<Functions>().getWidgetHeight(height: 50),
                                                          child: ListView(
                                                            scrollDirection: Axis.horizontal,
                                                            physics: const NeverScrollableScrollPhysics(),
                                                            children: [
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 125),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              "123456789",
                                                                              style: TextStyle(
                                                                                  color: const Color(0xff282F3A),
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize:
                                                                                      getIt<Functions>().getTextSize(fontSize: 12)),
                                                                            ),
                                                                            SizedBox(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 8)),
                                                                            Skeleton.shade(
                                                                              child: SvgPicture.asset(
                                                                                "assets/pick_list/picklist_red.svg",
                                                                                height: getIt<Functions>().getWidgetHeight(height: 12),
                                                                                width: getIt<Functions>().getWidgetWidth(width: 12),
                                                                                fit: BoxFit.fill,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Text(
                                                                          "(Colombia)",
                                                                          style: TextStyle(
                                                                              color: const Color(0xff8A8D8E),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 75),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "200/250",
                                                                          style: TextStyle(
                                                                              color: const Color(0xff282F3A),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                        ),
                                                                        Skeleton.shade(
                                                                          child: Container(
                                                                            height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                            width: getIt<Functions>().getWidgetWidth(width: 24),
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.deepPurpleAccent,
                                                                              borderRadius: BorderRadius.circular(3),
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                "D",
                                                                                style: TextStyle(
                                                                                    color: const Color(0xffffffff),
                                                                                    fontSize:
                                                                                        getIt<Functions>().getTextSize(fontSize: 12),
                                                                                    fontWeight: FontWeight.w700),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 100),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "27/11/2024",
                                                                          maxLines: 2,
                                                                          style: TextStyle(
                                                                              color: const Color(0xff282F3A),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                        ),
                                                                        Text(
                                                                          "11:00 PM",
                                                                          maxLines: 2,
                                                                          style: TextStyle(
                                                                              color: const Color(0xff282F3A),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 75),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "Pending",
                                                                          style: TextStyle(
                                                                              color: Colors.red,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 100),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          "27/11/2024",
                                                                          style: TextStyle(
                                                                              color: const Color(0xff282F3A),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                        ),
                                                                        Text(
                                                                          "11:00 PM",
                                                                          maxLines: 2,
                                                                          style: TextStyle(
                                                                              color: const Color(0xff282F3A),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 125),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 95),
                                                                          child: Stack(
                                                                              children: List<Widget>.generate(
                                                                                  3,
                                                                                  (i) => i == 0
                                                                                      ? const CircleAvatar(
                                                                                          radius: 18, backgroundColor: Colors.grey)
                                                                                      : Positioned(
                                                                                          left: i * 22,
                                                                                          child: const CircleAvatar(
                                                                                              radius: 18,
                                                                                              backgroundColor: Colors.grey),
                                                                                        ))),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
                                                        const Divider(color: Color(0xffE0E7EC), height: 0, thickness: 1),
                                                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 17)),
                                                      ],
                                                    );
                                                  }),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (state is PickListTableLoading) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: getIt<Functions>().getWidgetHeight(height: 45),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: getIt<Functions>().getWidgetHeight(height: 45),
                                        margin: EdgeInsets.only(
                                            left: getIt<Functions>().getWidgetWidth(width: 12),
                                            right: getIt<Functions>().getWidgetWidth(width: 12),
                                            bottom: getIt<Functions>().getWidgetHeight(height: 10)),
                                        padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 10)),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: getIt<Variables>().generalVariables.selectedFiltersName.isEmpty
                                                ? const Color(0xffEEF4FF)
                                                : Colors.white,
                                            border: Border.all(
                                                color: getIt<Variables>().generalVariables.selectedFiltersName.isEmpty
                                                    ? const Color(0xff8A8D8E).withOpacity(0.5)
                                                    : const Color(0xff8A8D8E),
                                                width: 1)),
                                        child: Center(
                                          child: Text(
                                            getIt<Variables>().generalVariables.currentLanguage.clearAll,
                                            style: TextStyle(
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: getIt<Variables>().generalVariables.selectedFiltersName.isEmpty
                                                  ? const Color(0xff1D2736).withOpacity(0.5)
                                                  : const Color(0xff1D2736),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )),
                                    Expanded(
                                      child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.horizontal,
                                          physics: const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: getIt<Variables>().generalVariables.selectedFiltersName.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Container(
                                              margin: EdgeInsets.only(
                                                  right: getIt<Functions>().getWidgetWidth(width: 10),
                                                  bottom: getIt<Functions>().getWidgetHeight(height: 10)),
                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 10)),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  color: const Color(0xffEEF4FF),
                                                  border: Border.all(color: const Color(0xff007AFF), width: 1)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        getIt<Variables>().generalVariables.selectedFiltersName[index],
                                                        style: TextStyle(
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                          color: const Color(0xff1D2736),
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 2)),
                                                      Text(
                                                        getIt<Variables>().generalVariables.selectedFilters[index].options.length > 1
                                                            ? "+${getIt<Variables>().generalVariables.selectedFilters[index].options.length - 1} more"
                                                            : "",
                                                        style: TextStyle(
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                          color: const Color(0xff007AFF),
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: getIt<Functions>().getWidgetWidth(width: 8),
                                                  ),
                                                  SvgPicture.asset(
                                                    "assets/catch_weight/close-circle.svg",
                                                    height: getIt<Functions>().getWidgetHeight(height: 22),
                                                    width: getIt<Functions>().getWidgetWidth(width: 22),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: getIt<Functions>().getWidgetWidth(width: 600),
                                    child: Column(
                                      children: [
                                        SfDataGridTheme(
                                          data: const SfDataGridThemeData(
                                            headerColor: Color(0xffE0E7EC),
                                            gridLineColor: Colors.transparent,
                                            selectionColor: Colors.transparent,
                                            frozenPaneLineColor: Colors.transparent,
                                          ),
                                          child: SfDataGrid(
                                            columns: [
                                              GridColumn(
                                                columnName: getIt<Variables>().generalVariables.currentLanguage.picklist,
                                                label: Padding(
                                                  padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                  child: Row(
                                                    children: [
                                                      Center(
                                                        child: AutoSizeText(
                                                          maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                          minFontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                          maxLines: 2,
                                                          getIt<Variables>().generalVariables.currentLanguage.picklist,
                                                          style: const TextStyle(
                                                              color: Color(0xff282F3A),
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: "Figtree"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: getIt<Variables>().generalVariables.currentLanguage.total,
                                                label: Padding(
                                                  padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                  child: Row(
                                                    children: [
                                                      Center(
                                                        child: AutoSizeText(
                                                          maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                          minFontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                          maxLines: 2,
                                                          getIt<Variables>().generalVariables.currentLanguage.total,
                                                          style: const TextStyle(
                                                              color: Color(0xff282F3A),
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: "Figtree"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: getIt<Variables>().generalVariables.currentLanguage.created,
                                                label: Padding(
                                                  padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                  child: Row(
                                                    children: [
                                                      Center(
                                                        child: AutoSizeText(
                                                          maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                          minFontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                          maxLines: 2,
                                                          getIt<Variables>().generalVariables.currentLanguage.created,
                                                          style: const TextStyle(
                                                              color: Color(0xff282F3A),
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: "Figtree"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: getIt<Variables>()
                                                    .generalVariables
                                                    .currentLanguage
                                                    .status
                                                    .toLowerCase()
                                                    .replaceFirst('s', "S"),
                                                label: Padding(
                                                  padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                  child: Row(
                                                    children: [
                                                      Center(
                                                        child: AutoSizeText(
                                                          maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                          minFontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                          maxLines: 2,
                                                          getIt<Variables>()
                                                              .generalVariables
                                                              .currentLanguage
                                                              .status
                                                              .toLowerCase()
                                                              .replaceFirst('s', "S"),
                                                          style: const TextStyle(
                                                              color: Color(0xff282F3A),
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: "Figtree"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: getIt<Variables>().generalVariables.currentLanguage.deliveryArea,
                                                label: Padding(
                                                  padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                  child: Row(
                                                    children: [
                                                      Center(
                                                        child: AutoSizeText(
                                                          maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                          minFontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                          maxLines: 2,
                                                          getIt<Variables>().generalVariables.currentLanguage.deliveryArea,
                                                          style: const TextStyle(
                                                              color: Color(0xff282F3A),
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: "Figtree"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: getIt<Variables>().generalVariables.currentLanguage.orderType,
                                                label: Padding(
                                                  padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                  child: Row(
                                                    children: [
                                                      Center(
                                                        child: AutoSizeText(
                                                          maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                          minFontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                          maxLines: 2,
                                                          getIt<Variables>().generalVariables.currentLanguage.orderType,
                                                          style: const TextStyle(
                                                              color: Color(0xff282F3A),
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: "Figtree"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: getIt<Variables>().generalVariables.currentLanguage.completed,
                                                label: Padding(
                                                  padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                  child: Row(
                                                    children: [
                                                      Center(
                                                        child: AutoSizeText(
                                                          maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                          minFontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                          maxLines: 2,
                                                          getIt<Variables>().generalVariables.currentLanguage.completed,
                                                          style: const TextStyle(
                                                              color: Color(0xff282F3A),
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: "Figtree"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: getIt<Variables>().generalVariables.currentLanguage.handled,
                                                label: Padding(
                                                  padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 16)),
                                                  child: Row(
                                                    children: [
                                                      Center(
                                                        child: AutoSizeText(
                                                          maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                          minFontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                          maxLines: 2,
                                                          getIt<Variables>().generalVariables.currentLanguage.handled,
                                                          style: const TextStyle(
                                                              color: Color(0xff282F3A),
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: "Figtree"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                            shrinkWrapRows: true,
                                            columnWidthMode: ColumnWidthMode.auto,
                                            rowHeight: 65,
                                            headerRowHeight: 40,
                                            headerGridLinesVisibility: GridLinesVisibility.none,
                                            gridLinesVisibility: GridLinesVisibility.horizontal,
                                            columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                                            source: PickListMainDataSource(pickListData: [], context: context),
                                          ),
                                        ),
                                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                        Expanded(
                                          child: Skeletonizer(
                                            enabled: true,
                                            child: ListView.builder(
                                                padding: EdgeInsets.zero,
                                                physics: const BouncingScrollPhysics(),
                                                itemCount: 1,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: getIt<Functions>().getWidgetHeight(height: 50),
                                                        child: ListView(
                                                          scrollDirection: Axis.horizontal,
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          children: [
                                                            SizedBox(
                                                              width: getIt<Functions>().getWidgetWidth(width: 125),
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            "123456789",
                                                                            style: TextStyle(
                                                                                color: const Color(0xff282F3A),
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize:
                                                                                    getIt<Functions>().getTextSize(fontSize: 12)),
                                                                          ),
                                                                          SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                                                          Skeleton.shade(
                                                                            child: SvgPicture.asset(
                                                                              "assets/pick_list/picklist_red.svg",
                                                                              height: getIt<Functions>().getWidgetHeight(height: 12),
                                                                              width: getIt<Functions>().getWidgetWidth(width: 12),
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Text(
                                                                        "(Colombia)",
                                                                        style: TextStyle(
                                                                            color: const Color(0xff8A8D8E),
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: getIt<Functions>().getWidgetWidth(width: 75),
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        "200/250",
                                                                        style: TextStyle(
                                                                            color: const Color(0xff282F3A),
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                      ),
                                                                      Skeleton.shade(
                                                                        child: Container(
                                                                          height: getIt<Functions>().getWidgetHeight(height: 20),
                                                                          width: getIt<Functions>().getWidgetWidth(width: 24),
                                                                          decoration: BoxDecoration(
                                                                            color: Colors.deepPurpleAccent,
                                                                            borderRadius: BorderRadius.circular(3),
                                                                          ),
                                                                          child: Center(
                                                                            child: Text(
                                                                              "D",
                                                                              style: TextStyle(
                                                                                  color: const Color(0xffffffff),
                                                                                  fontSize:
                                                                                      getIt<Functions>().getTextSize(fontSize: 12),
                                                                                  fontWeight: FontWeight.w700),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: getIt<Functions>().getWidgetWidth(width: 100),
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        "27/11/2024",
                                                                        maxLines: 2,
                                                                        style: TextStyle(
                                                                            color: const Color(0xff282F3A),
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                      ),
                                                                      Text(
                                                                        "11:00 PM",
                                                                        maxLines: 2,
                                                                        style: TextStyle(
                                                                            color: const Color(0xff282F3A),
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: getIt<Functions>().getWidgetWidth(width: 75),
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        "Pending",
                                                                        style: TextStyle(
                                                                            color: Colors.red,
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: getIt<Functions>().getWidgetWidth(width: 100),
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        "27/11/2024",
                                                                        style: TextStyle(
                                                                            color: const Color(0xff282F3A),
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                      ),
                                                                      Text(
                                                                        "11:00 PM",
                                                                        maxLines: 2,
                                                                        style: TextStyle(
                                                                            color: const Color(0xff282F3A),
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: getIt<Functions>().getWidgetWidth(width: 125),
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width: getIt<Functions>().getWidgetWidth(width: 95),
                                                                        child: Stack(
                                                                            children: List<Widget>.generate(
                                                                                3,
                                                                                (i) => i == 0
                                                                                    ? const CircleAvatar(
                                                                                        radius: 18, backgroundColor: Colors.grey)
                                                                                    : Positioned(
                                                                                        left: i * 22,
                                                                                        child: const CircleAvatar(
                                                                                            radius: 18, backgroundColor: Colors.grey),
                                                                                      ))),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
                                                      const Divider(color: Color(0xffE0E7EC), height: 0, thickness: 1),
                                                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 17)),
                                                    ],
                                                  );
                                                }),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (state is PickListLoaded) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: getIt<Functions>().getWidgetHeight(height: 45),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (getIt<Variables>().generalVariables.selectedFilters.isNotEmpty) {
                                          getIt<Variables>().generalVariables.selectedFilters.clear();
                                          getIt<Variables>().generalVariables.selectedFiltersName.clear();
                                          context.read<PickListBloc>().add(const PickListSetStateEvent());
                                          context.read<PickListBloc>().add(const PickListTabChangingEvent(isLoading: false));
                                        }
                                      },
                                      child: Container(
                                          height: getIt<Functions>().getWidgetHeight(height: 45),
                                          margin: EdgeInsets.only(
                                              left: getIt<Functions>().getWidgetWidth(width: 12),
                                              right: getIt<Functions>().getWidgetWidth(width: 12),
                                              bottom: getIt<Functions>().getWidgetHeight(height: 10)),
                                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 10)),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: getIt<Variables>().generalVariables.selectedFiltersName.isEmpty
                                                  ? const Color(0xffEEF4FF)
                                                  : Colors.white,
                                              border: Border.all(
                                                  color: getIt<Variables>().generalVariables.selectedFiltersName.isEmpty
                                                      ? const Color(0xff8A8D8E).withOpacity(0.5)
                                                      : const Color(0xff8A8D8E),
                                                  width: 1)),
                                          child: Center(
                                            child: Text(
                                              getIt<Variables>().generalVariables.currentLanguage.clearAll,
                                              style: TextStyle(
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                color: getIt<Variables>().generalVariables.selectedFiltersName.isEmpty
                                                    ? const Color(0xff1D2736).withOpacity(0.5)
                                                    : const Color(0xff1D2736),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          )),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.horizontal,
                                          physics: const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: getIt<Variables>().generalVariables.selectedFiltersName.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Container(
                                              margin: EdgeInsets.only(
                                                  right: getIt<Functions>().getWidgetWidth(width: 10),
                                                  bottom: getIt<Functions>().getWidgetHeight(height: 10)),
                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 10)),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  color: const Color(0xffEEF4FF),
                                                  border: Border.all(color: const Color(0xff007AFF), width: 1)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        getIt<Variables>().generalVariables.selectedFiltersName[index],
                                                        style: TextStyle(
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                          color: const Color(0xff1D2736),
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 2)),
                                                      Text(
                                                        getIt<Variables>().generalVariables.selectedFilters[index].options.length > 1
                                                            ? "+${getIt<Variables>().generalVariables.selectedFilters[index].options.length - 1} more"
                                                            : "",
                                                        style: TextStyle(
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                          color: const Color(0xff007AFF),
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                                                  InkWell(
                                                    onTap: () {
                                                      getIt<Variables>().generalVariables.selectedFilters.removeAt(index);
                                                      getIt<Variables>().generalVariables.selectedFiltersName.removeAt(index);
                                                      context.read<PickListBloc>().add(const PickListSetStateEvent());
                                                      context
                                                          .read<PickListBloc>()
                                                          .add(const PickListTabChangingEvent(isLoading: false));
                                                    },
                                                    child: SvgPicture.asset(
                                                      "assets/catch_weight/close-circle.svg",
                                                      height: getIt<Functions>().getWidgetHeight(height: 22),
                                                      width: getIt<Functions>().getWidgetWidth(width: 22),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                              Expanded(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: SfDataGridTheme(
                                        data: const SfDataGridThemeData(
                                          headerColor: Color(0xffE0E7EC),
                                          gridLineColor: Colors.transparent,
                                          selectionColor: Colors.transparent,
                                          frozenPaneLineColor: Colors.transparent,
                                        ),
                                        child: SfDataGrid(
                                          columns: [
                                            GridColumn(
                                              columnName: getIt<Variables>().generalVariables.currentLanguage.picklist,
                                              label: Padding(
                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                child: Row(
                                                  children: [
                                                    Center(
                                                      child: AutoSizeText(
                                                        maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                        minFontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                        maxLines: 2,
                                                        getIt<Variables>().generalVariables.currentLanguage.picklist,
                                                        style: const TextStyle(
                                                            color: Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: getIt<Variables>().generalVariables.currentLanguage.total,
                                              label: Padding(
                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                child: Row(
                                                  children: [
                                                    Center(
                                                      child: AutoSizeText(
                                                        maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                        minFontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                        maxLines: 2,
                                                        getIt<Variables>().generalVariables.currentLanguage.total,
                                                        style: const TextStyle(
                                                            color: Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: getIt<Variables>().generalVariables.currentLanguage.created,
                                              label: Padding(
                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                child: Row(
                                                  children: [
                                                    Center(
                                                      child: AutoSizeText(
                                                        maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                        minFontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                        maxLines: 2,
                                                        getIt<Variables>().generalVariables.currentLanguage.created,
                                                        style: const TextStyle(
                                                            color: Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: getIt<Variables>()
                                                  .generalVariables
                                                  .currentLanguage
                                                  .status
                                                  .toLowerCase()
                                                  .replaceFirst('s', "S"),
                                              label: Padding(
                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                child: Row(
                                                  children: [
                                                    Center(
                                                      child: AutoSizeText(
                                                        maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                        minFontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                        maxLines: 2,
                                                        getIt<Variables>()
                                                            .generalVariables
                                                            .currentLanguage
                                                            .status
                                                            .toLowerCase()
                                                            .replaceFirst('s', "S"),
                                                        style: const TextStyle(
                                                            color: Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: getIt<Variables>().generalVariables.currentLanguage.deliveryArea,
                                              label: Padding(
                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                child: Row(
                                                  children: [
                                                    Center(
                                                      child: AutoSizeText(
                                                        maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                        minFontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                        maxLines: 2,
                                                        getIt<Variables>().generalVariables.currentLanguage.deliveryArea,
                                                        style: const TextStyle(
                                                            color: Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: getIt<Variables>().generalVariables.currentLanguage.orderType,
                                              label: Padding(
                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                child: Row(
                                                  children: [
                                                    Center(
                                                      child: AutoSizeText(
                                                        maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                        minFontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                        maxLines: 2,
                                                        getIt<Variables>().generalVariables.currentLanguage.orderType,
                                                        style: const TextStyle(
                                                            color: Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: getIt<Variables>().generalVariables.currentLanguage.completed,
                                              label: Padding(
                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                child: Row(
                                                  children: [
                                                    Center(
                                                      child: AutoSizeText(
                                                        maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                        minFontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                        maxLines: 2,
                                                        getIt<Variables>().generalVariables.currentLanguage.completed,
                                                        style: const TextStyle(
                                                            color: Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GridColumn(
                                              columnName: getIt<Variables>().generalVariables.currentLanguage.handled,
                                              label: Padding(
                                                padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 16)),
                                                child: Row(
                                                  children: [
                                                    Center(
                                                      child: AutoSizeText(
                                                        maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                        minFontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                        maxLines: 2,
                                                        getIt<Variables>().generalVariables.currentLanguage.handled,
                                                        style: const TextStyle(
                                                            color: Color(0xff282F3A),
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                          shrinkWrapRows: true,
                                          columnWidthMode: ColumnWidthMode.auto,
                                          columnSizer: CustomColumnSizer(context: context),
                                          rowHeight: 65,
                                          headerRowHeight: 40,
                                          headerGridLinesVisibility: GridLinesVisibility.none,
                                          gridLinesVisibility: GridLinesVisibility.horizontal,
                                          columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                                          source: PickListMainDataSource(
                                              pickListData: context.read<PickListBloc>().searchedPickList, context: context),
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
                                                        decoration: const BoxDecoration(
                                                            color: Colors.white,
                                                            border: BorderDirectional(
                                                                top: BorderSide(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.26)))),
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
                                                    return SizedBox.fromSize(size: Size.zero);
                                                  }
                                                });
                                          },
                                          onCellTap: (DataGridCellTapDetails details) {
                                            if (details.rowColumnIndex.rowIndex != 0) {
                                              if (details.column.columnName ==
                                                  getIt<Variables>().generalVariables.currentLanguage.handled) {
                                                if (context
                                                    .read<PickListBloc>()
                                                    .searchedPickList[details.rowColumnIndex.rowIndex - 1]
                                                    .handledBy
                                                    .isNotEmpty) {
                                                  getIt<Variables>().generalVariables.popUpWidget = usersDetailsContent(
                                                      handled: context
                                                          .read<PickListBloc>()
                                                          .searchedPickList[details.rowColumnIndex.rowIndex - 1]
                                                          .handledBy);
                                                  getIt<Functions>()
                                                      .showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                                }
                                              } else {
                                                getIt<Variables>().generalVariables.picklistItemData =
                                                    context.read<PickListBloc>().searchedPickList[details.rowColumnIndex.rowIndex - 1];
                                                context.read<PickListDetailsBloc>().selectedPickListId = context
                                                    .read<PickListBloc>()
                                                    .searchedPickList[details.rowColumnIndex.rowIndex - 1]
                                                    .id;
                                                getIt<Variables>().generalVariables.indexName = PickListDetailsScreen.id;
                                                getIt<Variables>().generalVariables.pickListRouteList.add(PickListScreen.id);
                                                context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    context.read<PickListBloc>().searchedPickList.isEmpty
                                        ? Expanded(
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/general/no_response.svg",
                                                    height: getIt<Functions>().getWidgetHeight(height: 200),
                                                    width: getIt<Functions>().getWidgetWidth(width: 200),
                                                    colorFilter:
                                                        ColorFilter.mode(const Color(0xff007AFF).withOpacity(0.3), BlendMode.srcIn),
                                                  ),
                                                  Text(
                                                    getIt<Variables>().generalVariables.currentLanguage.pickListIsEmpty,
                                                    style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 150)
                                                ],
                                              ),
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              ),
                            ],
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
        },
      ),
    );
  }

  Widget textBars({required TextEditingController controller}) {
    return BlocBuilder<PickListBloc, PickListState>(
      builder: (BuildContext context, PickListState catchWeight) {
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
                          context.read<PickListBloc>().searchText = value.toLowerCase();
                          context.read<PickListBloc>().pageIndex = 1;
                          context.read<PickListBloc>().add(const PickListTabChangingEvent(isLoading: false));
                        } else {
                          context.read<PickListBloc>().searchText = "";
                          context.read<PickListBloc>().pageIndex = 1;
                          context.read<PickListBloc>().add(const PickListTabChangingEvent(isLoading: false));
                        }
                      });
                    },
                    controller: controller,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        fontSize: getIt<Functions>().getTextSize(fontSize: 15), fontWeight: FontWeight.w500, color: Colors.black),
                    decoration: InputDecoration(
                        fillColor: const Color(0xff767680).withOpacity(0.12),
                        filled: true,
                        contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 15)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xffE0E6EE), width: 0.68)),
                        prefixIcon: const Icon(Icons.search, color: Color(0xff8F9BB3)),
                        suffixIcon: controller.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  controller.clear();
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  context.read<PickListBloc>().add(const PickListSetStateEvent());
                                  context.read<PickListBloc>().searchText = "";
                                  context.read<PickListBloc>().pageIndex = 1;
                                  context.read<PickListBloc>().add(const PickListTabChangingEvent(isLoading: false));
                                },
                                icon: const Icon(Icons.clear, color: Colors.black, size: 15))
                            : const SizedBox(),
                        hintText: getIt<Variables>().generalVariables.currentLanguage.search,
                        hintStyle: TextStyle(
                            color: const Color(0xff8F9BB3),
                            fontWeight: FontWeight.w400,
                            fontSize: getIt<Functions>().getTextSize(fontSize: 15))),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget usersDetailsContent({required List<HandledByPickList> handled}) {
    return BlocConsumer<PickListBloc, PickListState>(
      listenWhen: (PickListState previous, PickListState current) {
        return previous != current;
      },
      buildWhen: (PickListState previous, PickListState current) {
        return previous != current;
      },
      listener: (BuildContext context, PickListState state) {},
      builder: (BuildContext context, PickListState state) {
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
                          fontWeight: FontWeight.w600,
                          fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                          color: const Color(0xff282F3A)),
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
                                    image: getIt<Variables>().generalVariables.isNetworkOffline
                                        ? const AssetImage("assets/general/profile_default.png")
                                        : NetworkImage(handled[index].image),
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
                                        handled[index].pickedItems,
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
                                        getIt<Variables>().generalVariables.currentLanguage.pickedItem.toUpperCase(),
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
                          color: const Color(0xff1D2736),
                          fontWeight: FontWeight.w600,
                          fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
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

  Widget pickListFloorChoosingContent({required BuildContext contextNew}) {
    context.read<PickListBloc>().fieldEmpty = false;
    context.read<PickListBloc>().selectedLocation = null;
    context.read<PickListBloc>().selectedLocationId = "";
    return SizedBox(
      width: getIt<Functions>().getWidgetWidth(width: 600),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
          SvgPicture.asset(
            "assets/pick_list/location.svg",
            height: getIt<Functions>().getWidgetHeight(height: 70),
            width: getIt<Functions>().getWidgetWidth(width: 70),
            fit: BoxFit.fill,
          ),
          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
          Center(
            child: Text(
              getIt<Variables>().generalVariables.currentLanguage.chooseWorkLocation,
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: const Color(0xff282F3A), fontSize: getIt<Functions>().getTextSize(fontSize: 26)),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 60)),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 100 : 15)),
            child: SizedBox(
              height: getIt<Functions>().getWidgetHeight(height: 75),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getIt<Variables>().generalVariables.currentLanguage.selectFloor,
                    style: TextStyle(
                        color: const Color(0xff282F3A),
                        fontWeight: FontWeight.w600,
                        fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                  ),
                  BlocBuilder<PickListBloc, PickListState>(
                    builder: (BuildContext context, PickListState state) {
                      return SizedBox(
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
                                .read<PickListBloc>()
                                .searchedFloorData
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
                            value: context.read<PickListBloc>().selectedLocation,
                            onChanged: (String? suggestion) async {
                              context.read<PickListBloc>().selectedLocation = suggestion ?? "";
                              context.read<PickListBloc>().fieldEmpty = false;
                              context.read<PickListBloc>().selectedLocationId =
                                  (context.read<PickListBloc>().searchedFloorData.singleWhere((e) => e.label == suggestion)).id;
                              context.read<PickListBloc>().add(const PickListSetStateEvent(stillLoading: true));
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
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: getIt<Functions>().getWidgetHeight(height: context.read<PickListBloc>().fieldEmpty ? 12 : 0)),
          BlocBuilder<PickListBloc, PickListState>(
            builder: (BuildContext context, PickListState state) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 100 : 15)),
                child: Row(
                  children: [
                    Text(
                        context.read<PickListBloc>().fieldEmpty
                            ? getIt<Variables>().generalVariables.currentLanguage.pleaseEnterTheFloor
                            : "",
                        style: TextStyle(
                            fontSize: getIt<Functions>().getTextSize(fontSize: 10), color: Colors.red, fontWeight: FontWeight.w600)),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
          InkWell(
            onTap: () {
              if (context.read<PickListBloc>().selectedLocationId == "") {
                context.read<PickListBloc>().fieldEmpty = true;
                context.read<PickListBloc>().add(const PickListSetStateEvent(stillLoading: true));
              } else {
                context.read<PickListBloc>().fieldEmpty = false;
                Navigator.pop(context);
                Future.delayed(const Duration(milliseconds: 200), () {
                  contextNew.read<PickListBloc>().isLocationSelected = true;
                  contextNew.read<PickListBloc>().add(const PickListLocationChangedEvent());
                  FocusManager.instance.primaryFocus!.unfocus();
                });
              }
            },
            child: Container(
              height: getIt<Functions>().getWidgetHeight(height: 50),
              decoration: const BoxDecoration(
                color: Color(0xff007838),
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
              ),
              child: Center(
                child: Text(
                  getIt<Variables>().generalVariables.currentLanguage.continueToPicking.toUpperCase(),
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
}

class PickListMainDataSource extends DataGridSource {
  final BuildContext context;

  PickListMainDataSource({required List<PicklistItem> pickListData, required this.context}) {
    dataGridRows = pickListData
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell(
                  columnName: getIt<Variables>().generalVariables.currentLanguage.picklist,
                  value: DataValue(
                      id: dataGridRow.id, dataListValue: [dataGridRow.picklistNumber, dataGridRow.disputeStatus, dataGridRow.route])),
              DataGridCell(
                  columnName: getIt<Variables>().generalVariables.currentLanguage.total,
                  value: DataValue(
                      id: dataGridRow.id,
                      dataListValue: [dataGridRow.pickedQty, dataGridRow.quantity, dataGridRow.itemsColor, dataGridRow.itemsType])),
              DataGridCell(
                  columnName: getIt<Variables>().generalVariables.currentLanguage.created,
                  value: DataValue(
                      id: dataGridRow.id, dataListValue: [dataGridRow.created, dataGridRow.createdDate, dataGridRow.createdTime])),
              DataGridCell(
                  columnName: getIt<Variables>().generalVariables.currentLanguage.status,
                  value: DataValue(id: dataGridRow.id, dataListValue: [
                    dataGridRow.status,
                    dataGridRow.statusColor,
                    dataGridRow.statusBGColor,
                    dataGridRow.inProgress
                  ])),
              DataGridCell(
                  columnName: getIt<Variables>().generalVariables.currentLanguage.deliveryArea,
                  value: DataValue(id: dataGridRow.id, dataListValue: [dataGridRow.deliveryArea])),
              DataGridCell(
                  columnName: getIt<Variables>().generalVariables.currentLanguage.orderType,
                  value: DataValue(id: dataGridRow.id, dataListValue: [dataGridRow.orderType])),
              DataGridCell(
                  columnName: getIt<Variables>().generalVariables.currentLanguage.completed,
                  value: DataValue(
                      id: dataGridRow.id,
                      dataListValue: [dataGridRow.completed, dataGridRow.completedDate, dataGridRow.completedTime])),
              DataGridCell(
                  columnName: getIt<Variables>().generalVariables.currentLanguage.handled,
                  value: DataValue(id: dataGridRow.id, dataListValue: dataGridRow.handledBy)),
            ]))
        .toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  Future<void> handleRefresh() async {
    context.read<PickListBloc>().pageIndex = 1;
    context.read<PickListBloc>().add(const PickListTabChangingEvent(isLoading: false/*isRefreshing: true*/));
  }

  @override
  Future<void> handleLoadMoreRows() async {
    context.read<PickListBloc>().pageIndex++;
    context.read<PickListBloc>().add(const PickListTabChangingEvent(isLoading: true));
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      if (e.columnName == getIt<Variables>().generalVariables.currentLanguage.picklist) {
        return BlocBuilder<PickListBloc, PickListState>(
          builder: (BuildContext context, PickListState state) {
            DataValue data = e.value;
            List<dynamic> dataValue = data.dataListValue;
            String selectedId = data.id;
            bool isSelectedCell = selectedId == getIt<Variables>().generalVariables.socketMessageId;
            return Skeletonizer(
              enabled: state is PickListTableLoading,
              child: Container(
                padding: EdgeInsets.only(
                    left: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 12 : 16)),
                decoration: BoxDecoration(
                  border: isSelectedCell
                      ? const Border(
                          top: BorderSide(color: Colors.green, width: 2),
                          bottom: BorderSide(color: Colors.green, width: 2),
                          left: BorderSide(color: Colors.green, width: 2))
                      : const Border(bottom: BorderSide(color: Color(0xffE0E7EC))),
                  color: isSelectedCell ? Colors.green.withOpacity(0.1) : Colors.transparent,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: AutoSizeText(
                            maxFontSize: getIt<Functions>().getTextSize(fontSize: 12),
                            minFontSize: getIt<Functions>().getTextSize(fontSize: 6),
                            maxLines: 1,
                            dataValue.isNotEmpty
                                ? dataValue[0] != ""
                                    ? dataValue[0]
                                    : "-"
                                : "-",
                            style: TextStyle(
                                color: const Color(0xff282F3A),
                                fontWeight: FontWeight.w500,
                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                fontFamily: "Figtree"),
                          ),
                        ),
                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8)),
                        dataValue[1]
                            ? SvgPicture.asset(
                                "assets/pick_list/picklist_red.svg",
                                height: getIt<Functions>().getWidgetHeight(height: 12),
                                width: getIt<Functions>().getWidgetWidth(width: 12),
                                fit: BoxFit.fill,
                              )
                            : const SizedBox(),
                      ],
                    ),
                    SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 6),
                    ),
                    Text(
                      dataValue.length > 2
                          ? dataValue[2] != ""
                              ? dataValue[2]
                              : "-"
                          : "-",
                      style: TextStyle(
                          color: const Color(0xff8A8D8E),
                          fontWeight: FontWeight.w500,
                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                          fontFamily: "Figtree"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      if (e.columnName == getIt<Variables>().generalVariables.currentLanguage.total) {
        return BlocBuilder<PickListBloc, PickListState>(
          builder: (BuildContext context, PickListState state) {
            DataValue data = e.value;
            List<dynamic> dataValue = data.dataListValue;
            String selectedId = data.id;
            bool isSelectedCell = selectedId == getIt<Variables>().generalVariables.socketMessageId;
            return Skeletonizer(
              enabled: state is PickListTableLoading,
              child: Container(
                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                decoration: BoxDecoration(
                    border: isSelectedCell
                        ? const Border(
                            top: BorderSide(color: Colors.green, width: 2), bottom: BorderSide(color: Colors.green, width: 2))
                        : const Border(bottom: BorderSide(color: Color(0xffE0E7EC))),
                    color: isSelectedCell ? Colors.green.withOpacity(0.1) : Colors.transparent),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataValue.length >= 4 ? "${dataValue[0]}/${dataValue[1]}" : "-",
                      style: TextStyle(
                          color: const Color(0xff282F3A),
                          fontWeight: FontWeight.w500,
                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                          fontFamily: "Figtree"),
                    ),
                    SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 6),
                    ),
                    Container(
                      height: getIt<Functions>().getWidgetHeight(height: 20),
                      width: getIt<Functions>().getWidgetWidth(width: 24),
                      decoration: BoxDecoration(
                        color: Color(int.parse(dataValue[2])),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Center(
                        child: Text(
                          dataValue[3],
                          style: TextStyle(
                              color: const Color(0xffffffff),
                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Figtree"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      if (e.columnName == getIt<Variables>().generalVariables.currentLanguage.created) {
        return BlocBuilder<PickListBloc, PickListState>(
          builder: (BuildContext context, PickListState state) {
            DataValue data = e.value;
            List<dynamic> dataValue = data.dataListValue;
            String selectedId = data.id;
            bool isSelectedCell = selectedId == getIt<Variables>().generalVariables.socketMessageId;
            return Skeletonizer(
              enabled: state is PickListTableLoading,
              child: Container(
                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                decoration: BoxDecoration(
                    border: isSelectedCell
                        ? const Border(
                            top: BorderSide(color: Colors.green, width: 2), bottom: BorderSide(color: Colors.green, width: 2))
                        : const Border(bottom: BorderSide(color: Color(0xffE0E7EC))),
                    color: isSelectedCell ? Colors.green.withOpacity(0.1) : Colors.transparent),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataValue.isNotEmpty
                          ? dataValue[1] != ""
                              ? dataValue[1]
                              : "-"
                          : "-",
                      style: TextStyle(
                          color: const Color(0xff282F3A),
                          fontWeight: FontWeight.w500,
                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                          fontFamily: "Figtree"),
                    ),
                    SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 6),
                    ),
                    dataValue.isNotEmpty
                        ? dataValue[2] != ""
                            ? Text(
                                dataValue[2],
                                style: TextStyle(
                                    color: const Color(0xff282F3A),
                                    fontWeight: FontWeight.w500,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                    fontFamily: "Figtree"),
                              )
                            : const SizedBox()
                        : const SizedBox(),
                  ],
                ),
              ),
            );
          },
        );
      }
      if (e.columnName == getIt<Variables>().generalVariables.currentLanguage.status) {
        return BlocBuilder<PickListBloc, PickListState>(
          builder: (BuildContext context, PickListState state) {
            DataValue data = e.value;
            List<dynamic> dataValue = data.dataListValue;
            String selectedId = data.id;
            bool isSelectedCell = selectedId == getIt<Variables>().generalVariables.socketMessageId;
            return Skeletonizer(
              enabled: state is PickListTableLoading,
              child: Container(
                padding: EdgeInsets.only(
                    left: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 0 : 16)),
                decoration: BoxDecoration(
                    border: isSelectedCell
                        ? const Border(
                            top: BorderSide(color: Colors.green, width: 2), bottom: BorderSide(color: Colors.green, width: 2))
                        : const Border(bottom: BorderSide(color: Color(0xffE0E7EC))),
                    color: isSelectedCell ? Colors.green.withOpacity(0.1) : Colors.transparent),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: getIt<Functions>().getWidgetWidth(width: 9),
                              vertical: getIt<Functions>().getWidgetHeight(height: 5)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(int.parse(dataValue[2])),
                          ),
                          child: Text(
                            dataValue.isNotEmpty
                                ? dataValue[0] != ""
                                    ? dataValue[0]
                                    : "-"
                                : "-",
                            style: TextStyle(
                                color: Color(int.parse(dataValue[1])),
                                fontWeight: FontWeight.w500,
                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                fontFamily: "Figtree"),
                          ),
                        ),
                        Text(
                          dataValue[3] ? "*" : "",
                          style: TextStyle(
                              color: const Color(0xff282F3A),
                              fontWeight: FontWeight.w500,
                              fontSize: getIt<Functions>().getTextSize(fontSize: 20),
                              fontFamily: "Figtree"),
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
      if (e.columnName == getIt<Variables>().generalVariables.currentLanguage.deliveryArea) {
        return BlocBuilder<PickListBloc, PickListState>(
          builder: (BuildContext context, PickListState state) {
            DataValue data = e.value;
            List<dynamic> dataValue = data.dataListValue;
            String selectedId = data.id;
            bool isSelectedCell = selectedId == getIt<Variables>().generalVariables.socketMessageId;
            return Skeletonizer(
              enabled: state is PickListTableLoading,
              child: Container(
                padding: EdgeInsets.only(
                    left: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 0 : 16)),
                decoration: BoxDecoration(
                    border: isSelectedCell
                        ? const Border(
                            top: BorderSide(color: Colors.green, width: 2), bottom: BorderSide(color: Colors.green, width: 2))
                        : const Border(bottom: BorderSide(color: Color(0xffE0E7EC))),
                    color: isSelectedCell ? Colors.green.withOpacity(0.1) : Colors.transparent),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: getIt<Functions>().getWidgetWidth(width: 9),
                          vertical: getIt<Functions>().getWidgetHeight(height: 5)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        dataValue.isNotEmpty
                            ? dataValue[0] != ""
                                ? dataValue[0].toLowerCase()
                                : "-"
                            : "-",
                        style: TextStyle(
                            color: const Color(0xff282F3A),
                            fontWeight: FontWeight.w500,
                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                            fontFamily: "Figtree"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      if (e.columnName == getIt<Variables>().generalVariables.currentLanguage.orderType) {
        return BlocBuilder<PickListBloc, PickListState>(
          builder: (BuildContext context, PickListState state) {
            DataValue data = e.value;
            List<dynamic> dataValue = data.dataListValue;
            String selectedId = data.id;
            bool isSelectedCell = selectedId == getIt<Variables>().generalVariables.socketMessageId;
            return Skeletonizer(
              enabled: state is PickListTableLoading,
              child: Container(
                padding: EdgeInsets.only(
                    left: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 0 : 16)),
                decoration: BoxDecoration(
                    border: isSelectedCell
                        ? const Border(
                            top: BorderSide(color: Colors.green, width: 2), bottom: BorderSide(color: Colors.green, width: 2))
                        : const Border(bottom: BorderSide(color: Color(0xffE0E7EC))),
                    color: isSelectedCell ? Colors.green.withOpacity(0.1) : Colors.transparent),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: getIt<Functions>().getWidgetWidth(width: 9),
                          vertical: getIt<Functions>().getWidgetHeight(height: 5)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        dataValue.isNotEmpty
                            ? dataValue[0] != ""
                                ? dataValue[0].toLowerCase()
                                : "-"
                            : "-",
                        style: TextStyle(
                            color: const Color(0xff282F3A),
                            fontWeight: FontWeight.w500,
                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                            fontFamily: "Figtree"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      if (e.columnName == getIt<Variables>().generalVariables.currentLanguage.completed) {
        return BlocBuilder<PickListBloc, PickListState>(
          builder: (BuildContext context, PickListState state) {
            DataValue data = e.value;
            List<dynamic> dataValue = data.dataListValue;
            String selectedId = data.id;
            bool isSelectedCell = selectedId == getIt<Variables>().generalVariables.socketMessageId;
            return Skeletonizer(
              enabled: state is PickListTableLoading,
              child: Container(
                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                decoration: BoxDecoration(
                    border: isSelectedCell
                        ? const Border(
                            top: BorderSide(color: Colors.green, width: 2), bottom: BorderSide(color: Colors.green, width: 2))
                        : const Border(bottom: BorderSide(color: Color(0xffE0E7EC))),
                    color: isSelectedCell ? Colors.green.withOpacity(0.1) : Colors.transparent),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataValue.isNotEmpty
                          ? dataValue[1] != ""
                              ? dataValue[1]
                              : "-"
                          : "-",
                      style: TextStyle(
                          color: const Color(0xff282F3A),
                          fontWeight: FontWeight.w500,
                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                          fontFamily: "Figtree"),
                    ),
                    SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 6),
                    ),
                    dataValue.isNotEmpty
                        ? dataValue[2] != ""
                            ? Text(
                                dataValue[2],
                                style: TextStyle(
                                    color: const Color(0xff282F3A),
                                    fontWeight: FontWeight.w500,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                    fontFamily: "Figtree"),
                              )
                            : const SizedBox()
                        : const SizedBox(),
                  ],
                ),
              ),
            );
          },
        );
      }
      if (e.columnName == getIt<Variables>().generalVariables.currentLanguage.handled) {
        return BlocBuilder<PickListBloc, PickListState>(
          builder: (BuildContext context, PickListState state) {
            DataValue data = e.value;
            List<dynamic> dataValue = data.dataListValue;
            String selectedId = data.id;
            bool isSelectedCell = selectedId == getIt<Variables>().generalVariables.socketMessageId;
            return Skeletonizer(
              enabled: state is PickListTableLoading,
              child: Container(
                  padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                  decoration: BoxDecoration(
                      border: isSelectedCell
                          ? const Border(
                              top: BorderSide(color: Colors.green, width: 2),
                              bottom: BorderSide(color: Colors.green, width: 2),
                              right: BorderSide(color: Colors.green, width: 2))
                          : const Border(bottom: BorderSide(color: Color(0xffE0E7EC))),
                      color: isSelectedCell ? Colors.green.withOpacity(0.1) : Colors.transparent),
                  child: dataValue.isNotEmpty
                      ? Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          SizedBox(
                            width: 75,
                            child: Stack(
                                children: List<Widget>.generate(
                                    dataValue.length >= 2 ? 2 : dataValue.length,
                                    (i) => i == 0
                                        ? CircleAvatar(
                                            radius: 15,
                                            backgroundImage: getIt<Variables>().generalVariables.isNetworkOffline
                                                ? const AssetImage("assets/general/profile_default.png")
                                                : NetworkImage(
                                                    dataValue[i].image,
                                                  ),
                                          )
                                        : Positioned(
                                            left: i * 20,
                                            child: Stack(
                                              children: [
                                                CircleAvatar(
                                                  radius: 15,
                                                  backgroundImage: getIt<Variables>().generalVariables.isNetworkOffline
                                                      ? const AssetImage("assets/general/profile_default.png")
                                                      : NetworkImage(
                                                          dataValue[i].image,
                                                        ),
                                                ),
                                                dataValue.length > 2
                                                    ? CircleAvatar(
                                                        radius: 15,
                                                        backgroundColor: Colors.black26.withOpacity(0.6),
                                                        child: Center(
                                                          child: Text("+${dataValue.length - 2}",
                                                              style: const TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.bold,
                                                              )),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                          ))),
                          )
                        ])
                      : Row(
                          children: [
                            Text("-",
                                style: TextStyle(
                                    color: const Color(0xff282F3A),
                                    fontWeight: FontWeight.w500,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                    fontFamily: "Figtree")),
                          ],
                        )),
            );
          },
        );
      }
      return Padding(
        padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  e.value.dataListValue.isNotEmpty
                      ? e.value.dataListValue[0] != ""
                          ? e.value.dataListValue[0]
                          : "-"
                      : "-",
                  style: const TextStyle(fontSize: 12, fontFamily: "Figtree"),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList());
  }
}

class CustomColumnSizer extends ColumnSizer {
  final BuildContext context;

  CustomColumnSizer({required this.context});

  @override
  double computeCellWidth(GridColumn column, DataGridRow row, Object? cellValue, TextStyle textStyle) {
    Object? valueData;
    if (column.columnName == getIt<Variables>().generalVariables.currentLanguage.total) {
      valueData = "100/200";
    } else if (column.columnName == getIt<Variables>().generalVariables.currentLanguage.created ||
        column.columnName == getIt<Variables>().generalVariables.currentLanguage.completed ||
        column.columnName == getIt<Variables>().generalVariables.currentLanguage.handled) {
      valueData = "10/12";
    } else if (column.columnName == getIt<Variables>().generalVariables.currentLanguage.deliveryArea ||
        column.columnName == getIt<Variables>().generalVariables.currentLanguage.orderType) {
      valueData = "10012020";
    } else {
      valueData = "12345678900123";
    }
    return Orientation.portrait == MediaQuery.of(context).orientation
        ? getIt<Functions>().getWidgetWidth(width: super.computeCellWidth(column, row, valueData, textStyle))
        : getIt<Functions>().getWidgetHeight(
            height: (super.computeCellWidth(column, row, valueData, textStyle)) *
                (getIt<Variables>().generalVariables.isDeviceTablet ? 1.40 : 1.1));
  }
}

class DataValue {
  final String id;
  final List<dynamic> dataListValue;

  const DataValue({required this.id, required this.dataListValue});
}
