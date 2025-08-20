import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/bloc/task/task_bloc/task_bloc.dart';
import 'package:oda/edited_packages/rounded_expansion_tile.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/screens/home/home_screen.dart';
import 'package:oda/screens/tasks/add_task_screen.dart';
import 'package:oda/screens/tasks/view_task_screen.dart';

class TaskScreen extends StatefulWidget {
  static const String id = "task_screen";
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  TextEditingController searchBar = TextEditingController();
  Timer? timer;

  @override
  void initState() {
    context.read<TaskBloc>().add(const TaskInitialEvent());
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
            color: const Color(0xffFFFFFF),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                BlocBuilder<TaskBloc, TaskState>(
                  builder: (BuildContext context, TaskState state) {
                    return SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 117),
                      child: AppBar(
                        backgroundColor: const Color(0xffFFFFFF),
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
                                getIt<Variables>().generalVariables.currentLanguage.tasks,
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
                          SizedBox(
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
                                  TaskBloc().add(const TaskSetStateEvent(stillLoading: true));
                                  getIt<Variables>().generalVariables.indexName = AddTaskScreen.id;
                                  getIt<Variables>().generalVariables.taskRouteList.add(TaskScreen.id);
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
                                      getIt<Variables>().generalVariables.currentLanguage.addNewTask.toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                        color: const Color(0xffffffff),
                                      ),
                                    )
                                  ],
                                )),
                          ),
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
                        elevation: 0.0,
                        surfaceTintColor: const Color(0xffffffff),
                        forceMaterialTransparency: true,
                      ),
                    );
                  },
                ),
                Expanded(
                    child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 16)),
                        shrinkWrap: true,
                        itemCount: 6,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: getIt<Functions>().getWidgetHeight(height: 16));
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 0,
                            color: const Color(0xffEEF4FF),
                            child: RoundedExpansionTile(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              title: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Department : Inbound",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xff282F3A)),
                                  ),
                                  Text(
                                    "Total tasks : 12 Items",
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xff6F6F6F)),
                                  ),
                                ],
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_sharp,
                                size: 15,
                              ),
                              children: List<Widget>.generate(
                                  5,
                                  (i) => InkWell(
                                    splashColor: Colors.transparent,
                                    splashFactory: NoSplash.splashFactory,
                                    highlightColor: Colors.transparent,
                                    onTap: (){
                                      TaskBloc().add(const TaskSetStateEvent(stillLoading: true));
                                      getIt<Variables>().generalVariables.indexName = ViewTaskScreen.id;
                                      getIt<Variables>().generalVariables.taskRouteList.add(TaskScreen.id);
                                      context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                    },
                                    child: Column(
                                          children: [
                                            i == 0
                                                ? SizedBox(
                                                    height: getIt<Functions>().getWidgetHeight(height: 24),
                                                  )
                                                : const SizedBox(),
                                            Container(
                                              height: getIt<Functions>().getWidgetHeight(height: 150),
                                              margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 16)),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: getIt<Functions>().getWidgetHeight(height: 40),
                                                    padding:
                                                        EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 16)),
                                                    decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(10),
                                                        topRight: Radius.circular(10),
                                                      ),
                                                      color: Color(0xffE3E7EA),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          "PRIORITY: NORMAL",
                                                          style: TextStyle(
                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                              fontWeight: FontWeight.w600,
                                                              color: const Color(0xff282F3A)),
                                                        ),
                                                        Text(
                                                          "DATE & TIME : 19/05/2024, 01:37 PM",
                                                          style: TextStyle(
                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                              fontWeight: FontWeight.w600,
                                                              color: const Color(0xff282F3A)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Container(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: getIt<Functions>().getWidgetWidth(width: 16)),
                                                          decoration: const BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                              bottomLeft: Radius.circular(10),
                                                              bottomRight: Radius.circular(10),
                                                            ),
                                                            color: Colors.white,
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 12),
                                                              ),
                                                              Expanded(
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 5),
                                                                          decoration: BoxDecoration(
                                                                            color: const Color(0xff96D367),
                                                                            borderRadius: BorderRadius.circular(5),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: getIt<Functions>().getWidgetWidth(width: 8),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                              vertical: getIt<Functions>().getWidgetHeight(height: 1)),
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "Purchase",
                                                                                style: TextStyle(
                                                                                    fontSize:
                                                                                        getIt<Functions>().getTextSize(fontSize: 16),
                                                                                    fontWeight: FontWeight.w700,
                                                                                    color: const Color(0xff282F3A)),
                                                                              ),
                                                                              Text(
                                                                                "Raise PR for shrink wrap rolls",
                                                                                style: TextStyle(
                                                                                    fontSize:
                                                                                        getIt<Functions>().getTextSize(fontSize: 13),
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: const Color(0xff6F6F6F)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    i.isEven
                                                                        ? InkWell(
                                                                        splashColor: Colors.transparent,
                                                                        splashFactory: NoSplash.splashFactory,
                                                                        highlightColor: Colors.transparent,
                                                                            onTap: () {
                                                                              showModalBottomSheet(
                                                                                  context: context,
                                                                                  enableDrag: false,
                                                                                  isDismissible: false,
                                                                                  isScrollControlled: true,
                                                                                  builder: (BuildContext context) {
                                                                                    return const AssigningPersonBottomSheet();
                                                                                  });
                                                                            },
                                                                            child: Container(
                                                                              height: getIt<Functions>().getWidgetHeight(height: 24),
                                                                              padding: EdgeInsets.symmetric(
                                                                                  horizontal:
                                                                                      getIt<Functions>().getWidgetWidth(width: 16)),
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(5),
                                                                                color: const Color(0xffCCCED1),
                                                                              ),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  SvgPicture.asset(
                                                                                    "assets/general/assigning_image.svg",
                                                                                    height:
                                                                                        getIt<Functions>().getWidgetHeight(height: 14),
                                                                                    width: getIt<Functions>().getWidgetWidth(width: 14),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: getIt<Functions>().getWidgetWidth(width: 8),
                                                                                  ),
                                                                                  Text("Not Assigned",
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w600,
                                                                                          fontSize: getIt<Functions>()
                                                                                              .getTextSize(fontSize: 12),
                                                                                          color: const Color(0xff282F3A)))
                                                                                ],
                                                                              ),
                                                                            ))
                                                                        : Row(
                                                                            children: [
                                                                              InkWell(
                                                                                  splashColor: Colors.transparent,
                                                                                  splashFactory: NoSplash.splashFactory,
                                                                                  highlightColor: Colors.transparent,
                                                                                  onTap: () {
                                                                                    showModalBottomSheet(
                                                                                        context: context,
                                                                                        enableDrag: false,
                                                                                        isDismissible: false,
                                                                                        isScrollControlled: true,
                                                                                        builder: (BuildContext context) {
                                                                                          return const AssigningPersonBottomSheet();
                                                                                        });
                                                                                  },
                                                                                  child: Container(
                                                                                    height:
                                                                                        getIt<Functions>().getWidgetHeight(height: 24),
                                                                                    padding: EdgeInsets.symmetric(
                                                                                        horizontal: getIt<Functions>()
                                                                                            .getWidgetWidth(width: 16)),
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(5),
                                                                                      color: const Color(0xffffffff),
                                                                                      border: Border.all(
                                                                                          color: const Color(0xff007AFF), width: 1),
                                                                                    ),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        SvgPicture.asset(
                                                                                          "assets/general/assigning_image_blue.svg",
                                                                                          height: getIt<Functions>()
                                                                                              .getWidgetHeight(height: 14),
                                                                                          width: getIt<Functions>()
                                                                                              .getWidgetWidth(width: 14),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          width: getIt<Functions>()
                                                                                              .getWidgetWidth(width: 8),
                                                                                        ),
                                                                                        Text("Re-Assign",
                                                                                            style: TextStyle(
                                                                                                fontWeight: FontWeight.w600,
                                                                                                fontSize: getIt<Functions>()
                                                                                                    .getTextSize(fontSize: 12),
                                                                                                color: const Color(0xff007AFF)))
                                                                                      ],
                                                                                    ),
                                                                                  )),
                                                                              SizedBox(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 8),
                                                                              ),
                                                                              Container(
                                                                                height: getIt<Functions>().getWidgetHeight(height: 24),
                                                                                padding: EdgeInsets.symmetric(
                                                                                    horizontal:
                                                                                        getIt<Functions>().getWidgetWidth(width: 16)),
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  color: const Color(0xff007AFF),
                                                                                ),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    SvgPicture.asset(
                                                                                      "assets/general/assigned_image.svg",
                                                                                      height:
                                                                                          getIt<Functions>().getWidgetHeight(height: 14),
                                                                                      width:
                                                                                          getIt<Functions>().getWidgetWidth(width: 14),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: getIt<Functions>().getWidgetWidth(width: 8),
                                                                                    ),
                                                                                    Text("Assigned to : Arjun",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w600,
                                                                                            fontSize: getIt<Functions>()
                                                                                                .getTextSize(fontSize: 12),
                                                                                            color: const Color(0xffffffff)))
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 12),
                                                              ),
                                                              const Divider(
                                                                height: 0,
                                                                thickness: 1,
                                                                color: Color(0xffE0E7EC),
                                                              ),
                                                              SizedBox(
                                                                height: getIt<Functions>().getWidgetHeight(height: 40),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      "ISSUE : STOCK DEPLETED – PACKING HALTED",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                    Text(
                                                                      "LOCATION : COLONIAL",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: const Color(0xff282F3A)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )))
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 16)),
                                          ],
                                        ),
                                  )),
                            ),
                          );
                        })),
              ],
            ),
          );
        }
        else {
          return Container(
            color: const Color(0xffFFFFFF),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                BlocBuilder<TaskBloc, TaskState>(
                  builder: (BuildContext context, TaskState state) {
                    return SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 117),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppBar(
                            backgroundColor: const Color(0xffFFFFFF),
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
                                      getIt<Variables>().generalVariables.currentLanguage.tasks,
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
                                  context.read<TaskBloc>().searchBarEnabled ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 100),
                            ),
                            actions: [
                              SizedBox(
                                width: getIt<Functions>().getWidgetWidth(width: 8),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                splashFactory: NoSplash.splashFactory,
                                highlightColor: Colors.transparent,
                                onTap: state is TaskLoading
                                    ? () {}
                                    : () {
                                        TaskBloc().add(const TaskSetStateEvent(stillLoading: true));
                                  getIt<Variables>().generalVariables.indexName = AddTaskScreen.id;
                                  getIt<Variables>().generalVariables.taskRouteList.add(TaskScreen.id);
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
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: state is TaskLoading
                                    ? () {}
                                    : () {
                                        context.read<TaskBloc>().searchBarEnabled = !context.read<TaskBloc>().searchBarEnabled;
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
                                onTap: state is TaskLoading
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
                            elevation: 0.0,
                            surfaceTintColor: const Color(0xffffffff),
                            forceMaterialTransparency: true,
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
                    child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                        shrinkWrap: true,
                        itemCount: 6,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12));
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 0,
                            color: const Color(0xffEEF4FF),
                            child: RoundedExpansionTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              title: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Department : Inbound",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xff282F3A)),
                                  ),
                                  Text(
                                    "Total tasks : 12 Items",
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xff6F6F6F)),
                                  ),
                                ],
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_sharp,
                                size: 14,
                              ),
                              children: List<Widget>.generate(
                                  5,
                                      (i) => InkWell(
                                    splashColor: Colors.transparent,
                                    splashFactory: NoSplash.splashFactory,
                                    highlightColor: Colors.transparent,
                                    onTap: (){
                                      TaskBloc().add(const TaskSetStateEvent(stillLoading: true));
                                      getIt<Variables>().generalVariables.indexName = ViewTaskScreen.id;
                                      getIt<Variables>().generalVariables.taskRouteList.add(TaskScreen.id);
                                      context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                    },
                                    child: Column(
                                      children: [
                                        i == 0 ? SizedBox(
                                          height: getIt<Functions>().getWidgetHeight(height: 16),
                                        ) : const SizedBox(),
                                        Container(
                                          height: getIt<Functions>().getWidgetHeight(height: 200),
                                          margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: getIt<Functions>().getWidgetHeight(height: 50),
                                                width: double.infinity,
                                                padding:
                                                EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    topRight: Radius.circular(10),
                                                  ),
                                                  color: Color(0xffE3E7EA),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "PRIORITY: NORMAL",
                                                      style: TextStyle(
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                          fontWeight: FontWeight.w600,
                                                          color: const Color(0xff282F3A)),
                                                    ),
                                                    Text(
                                                      "DATE & TIME : 19/05/2024, 01:37 PM",
                                                      style: TextStyle(
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                          fontWeight: FontWeight.w600,
                                                          color: const Color(0xff282F3A)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  child: Container(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: getIt<Functions>().getWidgetWidth(width: 16)),
                                                      decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.only(
                                                          bottomLeft: Radius.circular(10),
                                                          bottomRight: Radius.circular(10),
                                                        ),
                                                        color: Colors.white,
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 12),
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: getIt<Functions>().getWidgetWidth(width: 5),
                                                                  decoration: BoxDecoration(
                                                                    color: const Color(0xff96D367),
                                                                    borderRadius: BorderRadius.circular(5),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: getIt<Functions>().getWidgetWidth(width: 8),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      vertical: getIt<Functions>().getWidgetHeight(height: 1)),
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        "Purchase",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                            getIt<Functions>().getTextSize(fontSize: 16),
                                                                            fontWeight: FontWeight.w700,
                                                                            color: const Color(0xff282F3A)),
                                                                      ),
                                                                      Text(
                                                                        "Raise PR for shrink wrap rolls",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                            getIt<Functions>().getTextSize(fontSize: 13),
                                                                            fontWeight: FontWeight.w500,
                                                                            color: const Color(0xff6F6F6F)),
                                                                      ),
                                                                      i.isEven
                                                                          ? InkWell(
                                                                          splashColor: Colors.transparent,
                                                                          splashFactory: NoSplash.splashFactory,
                                                                          highlightColor: Colors.transparent,
                                                                          onTap: () {
                                                                            showModalBottomSheet(
                                                                                context: context,
                                                                                enableDrag: false,
                                                                                isDismissible: false,
                                                                                isScrollControlled: true,
                                                                                builder: (BuildContext context) {
                                                                                  return const AssigningPersonBottomSheet();
                                                                                });
                                                                          },
                                                                          child: Container(
                                                                            height: getIt<Functions>().getWidgetHeight(height: 24),
                                                                            padding: EdgeInsets.symmetric(
                                                                                horizontal:
                                                                                getIt<Functions>().getWidgetWidth(width: 16)),
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              color: const Color(0xffCCCED1),
                                                                            ),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                SvgPicture.asset(
                                                                                  "assets/general/assigning_image.svg",
                                                                                  height:
                                                                                  getIt<Functions>().getWidgetHeight(height: 14),
                                                                                  width: getIt<Functions>().getWidgetWidth(width: 14),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: getIt<Functions>().getWidgetWidth(width: 8),
                                                                                ),
                                                                                Text("Not Assigned",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontSize: getIt<Functions>()
                                                                                            .getTextSize(fontSize: 12),
                                                                                        color: const Color(0xff282F3A)))
                                                                              ],
                                                                            ),
                                                                          ))
                                                                          : Row(
                                                                        children: [
                                                                          InkWell(
                                                                              splashColor: Colors.transparent,
                                                                              splashFactory: NoSplash.splashFactory,
                                                                              highlightColor: Colors.transparent,
                                                                              onTap: () {
                                                                                showModalBottomSheet(
                                                                                    context: context,
                                                                                    enableDrag: false,
                                                                                    isDismissible: false,
                                                                                    isScrollControlled: true,
                                                                                    builder: (BuildContext context) {
                                                                                      return const AssigningPersonBottomSheet();
                                                                                    });
                                                                              },
                                                                              child: Container(
                                                                                height:
                                                                                getIt<Functions>().getWidgetHeight(height: 24),
                                                                                padding: EdgeInsets.symmetric(
                                                                                    horizontal: getIt<Functions>()
                                                                                        .getWidgetWidth(width: 16)),
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  color: const Color(0xffffffff),
                                                                                  border: Border.all(
                                                                                      color: const Color(0xff007AFF), width: 1),
                                                                                ),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    SvgPicture.asset(
                                                                                      "assets/general/assigning_image_blue.svg",
                                                                                      height: getIt<Functions>()
                                                                                          .getWidgetHeight(height: 14),
                                                                                      width: getIt<Functions>()
                                                                                          .getWidgetWidth(width: 14),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: getIt<Functions>()
                                                                                          .getWidgetWidth(width: 8),
                                                                                    ),
                                                                                    Text("Re-Assign",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w600,
                                                                                            fontSize: getIt<Functions>()
                                                                                                .getTextSize(fontSize: 12),
                                                                                            color: const Color(0xff007AFF)))
                                                                                  ],
                                                                                ),
                                                                              )),
                                                                          SizedBox(
                                                                            width: getIt<Functions>().getWidgetWidth(width: 8),
                                                                          ),
                                                                          Container(
                                                                            height: getIt<Functions>().getWidgetHeight(height: 24),
                                                                            padding: EdgeInsets.symmetric(
                                                                                horizontal:
                                                                                getIt<Functions>().getWidgetWidth(width: 16)),
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              color: const Color(0xff007AFF),
                                                                            ),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                SvgPicture.asset(
                                                                                  "assets/general/assigned_image.svg",
                                                                                  height:
                                                                                  getIt<Functions>().getWidgetHeight(height: 14),
                                                                                  width:
                                                                                  getIt<Functions>().getWidgetWidth(width: 14),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: getIt<Functions>().getWidgetWidth(width: 8),
                                                                                ),
                                                                                Text("Assigned to : Arjun",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontSize: getIt<Functions>()
                                                                                            .getTextSize(fontSize: 12),
                                                                                        color: const Color(0xffffffff)))
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 12),
                                                          ),
                                                          const Divider(
                                                            height: 0,
                                                            thickness: 1,
                                                            color: Color(0xffE0E7EC),
                                                          ),
                                                          SizedBox(
                                                            height: getIt<Functions>().getWidgetHeight(height: 50),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  "ISSUE : STOCK DEPLETED – PACKING HALTED",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                      fontWeight: FontWeight.w600,
                                                                      color: const Color(0xff282F3A)),
                                                                ),
                                                                Text(
                                                                  "LOCATION : COLONIAL",
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                                      fontWeight: FontWeight.w600,
                                                                      color: const Color(0xff282F3A)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )))
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 16)),
                                      ],
                                    ),
                                  )),
                            ),
                          );
                        })),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget textBars({required TextEditingController controller}) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (BuildContext context, TaskState state) {
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
                           /*if (value.isNotEmpty) {
                            context.read<BackToStoreBloc>().searchText = value.toLowerCase();
                            context.read<BackToStoreBloc>().pageIndex = 1;
                            context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: false));
                          } else {
                            context.read<BackToStoreBloc>().searchText = "";
                            context.read<BackToStoreBloc>().pageIndex = 1;
                            context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: false));
                          }*/
                        });
                      },
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
                        hintText: getIt<Variables>().generalVariables.currentLanguage.search,
                        hintStyle: TextStyle(
                            color: const Color(0xff8F9BB3),
                            fontWeight: FontWeight.w400,
                            fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                        suffixIcon: controller.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  controller.clear();
                            /*  FocusManager.instance.primaryFocus!.unfocus();
                              context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                              context.read<BackToStoreBloc>().searchText = "";
                              context.read<BackToStoreBloc>().pageIndex = 1;
                              context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: false));*/
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
}

class AssigningPersonBottomSheet extends StatefulWidget {
  const AssigningPersonBottomSheet({super.key});

  @override
  State<AssigningPersonBottomSheet> createState() => _AssigningPersonBottomSheetState();
}

class _AssigningPersonBottomSheetState extends State<AssigningPersonBottomSheet> {
  TextEditingController searchBar = TextEditingController();
  Timer? timer;
  List<bool> checkList = List.generate(150, (i) => false);
  bool isPersonSelected=false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: getIt<Functions>().getWidgetHeight(height: 600),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet?23:12),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet?16:8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                            splashFactory: NoSplash.splashFactory,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back,size:getIt<Variables>().generalVariables.isDeviceTablet?22:20)),
                        SizedBox(width: getIt<Variables>().generalVariables.isDeviceTablet?12:6,),
                        Text("Assign to",
                            style: TextStyle(
                                fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet?22:16),
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff282F3A))),
                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet?12:6)),
                        isPersonSelected?const SizedBox():textBars(controller: searchBar),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.highlight_off))
                  ],
                )),
            SizedBox(
              height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet?23:12),
            ),
            const Divider(
              height: 0,
              thickness: 1,
              color: Color(0xffE0E7EC),
            ),
            SizedBox(
              height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet?23:12),
            ),
            Expanded(
              child: isPersonSelected?Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("SELECTED PERSON",style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet?12:10),fontWeight: FontWeight.w700,color: const Color(0xff282F3A)),),
                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet?22:14),),
                  Center(
                    child: Container(
                      width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet?180:150),
                      padding: EdgeInsets.symmetric(
                          vertical: getIt<Functions>().getWidgetHeight(height: 9)),
                      decoration: BoxDecoration(color: const Color(0xff96D367), borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.person_outline_outlined,size: getIt<Variables>().generalVariables.isDeviceTablet?25:20,),
                          SizedBox(width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet?12:10),),
                          Text(
                            "ARJUN",
                            style: TextStyle(
                                fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet?16:12), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ):
              ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: 150,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      splashColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        if (checkList[index]) {
                          checkList[index] = false;
                        } else {
                          checkList.clear();
                          checkList = List.generate(150, (i) => false);
                          checkList[index] = true;
                        }
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: getIt<Functions>().getWidgetHeight(height: 16),
                            horizontal: getIt<Functions>().getWidgetWidth(width: 25)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            checkList[index]
                                ? Container(
                                    height: getIt<Functions>().getWidgetHeight(height: 15),
                                    width: getIt<Functions>().getWidgetWidth(width: 15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: const Color(0xff29B473),
                                        border: Border.all(color: const Color(0xff8A8D8E), width: 0.75)),
                                    child: const Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: getIt<Functions>().getWidgetHeight(height: 15),
                                    width: getIt<Functions>().getWidgetWidth(width: 15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                        border: Border.all(color: const Color(0xff8A8D8E), width: 0.75))),
                            SizedBox(
                              width: getIt<Functions>().getWidgetWidth(width: 16),
                            ),
                            Expanded(
                              child: Text("ARJUN",
                                  style: TextStyle(
                                      fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet?16:12),
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff282F3A))),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: getIt<Functions>().getWidgetHeight(height: 12),
            ),
            Center(
              child: InkWell(
                splashColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
                onTap: () {
                  if(isPersonSelected){

                  }else{
                    isPersonSelected=!isPersonSelected;
                  }
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet?135:75),
                      vertical: getIt<Functions>().getWidgetHeight(height: 9)),
                  decoration: BoxDecoration(color: const Color(0xff007AFF), borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    isPersonSelected?getIt<Variables>().generalVariables.currentLanguage.assign.toUpperCase():getIt<Variables>().generalVariables.currentLanguage.next,
                    style: TextStyle(
                        fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet?16:12), fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getIt<Functions>().getWidgetHeight(height: 23),
            ),
          ],
        ),
      ),
    );
  }

  Widget textBars({required TextEditingController controller}) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (BuildContext context, TaskState state) {
        return Padding(
          padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet?15:8)),
          child: SizedBox(
            height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 36 :30),
            width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 250 : 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 36 :30),
                    child: TextFormField(
                      controller: controller,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        if (timer?.isActive ?? false) timer?.cancel();
                        timer = Timer(const Duration(milliseconds: 500), () {
                          /* if (value.isNotEmpty) {
                            context.read<BackToStoreBloc>().searchText = value.toLowerCase();
                            context.read<BackToStoreBloc>().pageIndex = 1;
                            context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: false));
                          } else {
                            context.read<BackToStoreBloc>().searchText = "";
                            context.read<BackToStoreBloc>().pageIndex = 1;
                            context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: false));
                          }*/
                        });
                      },
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
                        hintText: getIt<Variables>().generalVariables.currentLanguage.search,
                        hintStyle: TextStyle(
                            color: const Color(0xff8F9BB3),
                            fontWeight: FontWeight.w400,
                            fontSize: getIt<Functions>().getTextSize(fontSize: 15)),
                        suffixIcon: controller.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  controller.clear();
                              /*FocusManager.instance.primaryFocus!.unfocus();
                              context.read<BackToStoreBloc>().add(const BackToStoreSetStateEvent());
                              context.read<BackToStoreBloc>().searchText = "";
                              context.read<BackToStoreBloc>().pageIndex = 1;
                              context.read<BackToStoreBloc>().add(const BackToStoreTabChangingEvent(isLoading: false));*/
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
}
