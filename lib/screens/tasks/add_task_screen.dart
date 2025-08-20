// Flutter imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

// Project imports:
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/bloc/task/add_task_bloc/add_task_bloc.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/resources/widgets.dart';

class AddTaskScreen extends StatefulWidget {
  static const String id = "add_task_screen";
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String? selectedTaskType;
  List<String> optionsData = ["Purchase", "Fixes", "Problem"];
  bool fieldEmpty = false;
  TextEditingController taskController = TextEditingController();
  TextEditingController issuesController = TextEditingController();
  TextEditingController requirementController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        AddTaskBloc().add(const AddTaskSetStateEvent(stillLoading: true));
        getIt<Variables>().generalVariables.indexName =
            getIt<Variables>().generalVariables.taskRouteList[getIt<Variables>().generalVariables.taskRouteList.length - 1];
        context.read<NavigationBloc>().add(const NavigationInitialEvent());
        getIt<Variables>().generalVariables.taskRouteList.removeAt(getIt<Variables>().generalVariables.taskRouteList.length - 1);
      },
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 480) {
          return Container(
            color: const Color(0xffEEF4FF),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: 117),
                  width: getIt<Functions>().getWidgetWidth(
                      width: Orientation.portrait == MediaQuery.of(context).orientation
                          ? getIt<Variables>().generalVariables.width
                          : getIt<Variables>().generalVariables.height),
                  child: AppBar(
                    backgroundColor: const Color(0xffEEF4FF),
                    leading: IconButton(
                      onPressed: () {
                        AddTaskBloc().add(const AddTaskSetStateEvent(stillLoading: true));
                        getIt<Variables>().generalVariables.indexName = getIt<Variables>()
                            .generalVariables
                            .taskRouteList[getIt<Variables>().generalVariables.taskRouteList.length - 1];
                        context.read<NavigationBloc>().add(const NavigationInitialEvent());
                        getIt<Variables>()
                            .generalVariables
                            .taskRouteList
                            .removeAt(getIt<Variables>().generalVariables.taskRouteList.length - 1);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    titleSpacing: 0,
                    title: Text(
                      getIt<Variables>().generalVariables.currentLanguage.addNewTask,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: getIt<Functions>().getTextSize(fontSize: 26),
                          color: const Color(0xff282F3A)),
                    ),
                    actions: [
                      InkWell(
                        splashColor: Colors.transparent,
                        splashFactory: NoSplash.splashFactory,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          AddTaskBloc().add(const AddTaskSetStateEvent(stillLoading: true));
                          getIt<Variables>().generalVariables.indexName = getIt<Variables>()
                              .generalVariables
                              .taskRouteList[getIt<Variables>().generalVariables.taskRouteList.length - 1];
                          context.read<NavigationBloc>().add(const NavigationInitialEvent());
                          getIt<Variables>()
                              .generalVariables
                              .taskRouteList
                              .removeAt(getIt<Variables>().generalVariables.taskRouteList.length - 1);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: getIt<Functions>().getWidgetWidth(width: 47),
                              vertical: getIt<Functions>().getWidgetHeight(height: 14)),
                          margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 15)),
                          decoration: BoxDecoration(color: const Color(0xff007AFF), borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            getIt<Variables>().generalVariables.currentLanguage.createTask.toUpperCase(),
                            style: TextStyle(
                                fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                    elevation: 0.0,
                    surfaceTintColor: const Color(0xffffffff),
                    forceMaterialTransparency: true,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 22)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/task/task_content.svg",
                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                width: getIt<Functions>().getWidgetWidth(width: 16),
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                width: getIt<Functions>().getWidgetWidth(width: 12),
                              ),
                              Text(
                                getIt<Variables>().generalVariables.currentLanguage.taskContent.toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                    color: const Color(0xff282F3A)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 14),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: getIt<Functions>().getWidgetWidth(width: 16),
                                vertical: getIt<Functions>().getWidgetHeight(height: 22)),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.dateAndTime,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xff282F3A)),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                          SizedBox(
                                            height: getIt<Functions>().getWidgetHeight(height: 44),
                                            child: TextFormField(
                                              initialValue: "14/05/2025, 09:45 AM",
                                              readOnly: true,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                  color: const Color(0xff8A8D8E)),
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                filled: true,
                                                fillColor: const Color(0xffF4F5F6),
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                errorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              ),
                                            ),
                                          )
                                        ])),
                                    SizedBox(
                                      width: getIt<Functions>().getWidgetWidth(width: 16),
                                    ),
                                    Expanded(
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.personCreated,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xff282F3A)),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                          SizedBox(
                                            height: getIt<Functions>().getWidgetHeight(height: 44),
                                            child: TextFormField(
                                              initialValue: "Ramesh R",
                                              readOnly: true,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                  color: const Color(0xff8A8D8E)),
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                filled: true,
                                                fillColor: const Color(0xffF4F5F6),
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                errorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              ),
                                            ),
                                          )
                                        ])),
                                  ],
                                ),
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: getIt<Variables>().generalVariables.currentLanguage.taskType,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                              color: const Color(0xff282F3A),
                                              fontFamily: "Figtree"),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                    color: const Color(0xffDC474A),
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Figtree")),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 45),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2<String>(
                                            isExpanded: true,
                                            hint: Text(
                                              getIt<Variables>().generalVariables.currentLanguage.chooseTaskType,
                                              style: TextStyle(
                                                  color: const Color(0xff282F3A),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                            ),
                                            items: optionsData
                                                .map((element) => DropdownMenuItem<String>(
                                                      value: element,
                                                      child: Text(
                                                        element,
                                                        style: TextStyle(
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                            value: selectedTaskType,
                                            onChanged: (String? suggestion) async {
                                              selectedTaskType = suggestion ?? "";
                                              fieldEmpty = false;
                                              setState(() {});
                                              /*context.read<PickListBloc>().selectedLocationId =
                                                  (context.read<PickListBloc>().searchedFloorData.singleWhere((e) => e.label == suggestion)).id;
                                              context.read<PickListBloc>().add(const PickListSetStateEvent(stillLoading: true));*/
                                            },
                                            iconStyleData: const IconStyleData(
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                ),
                                                iconSize: 24,
                                                iconEnabledColor: Color(0xff8A8D8E),
                                                iconDisabledColor: Color(0xff8A8D8E)),
                                            buttonStyleData: ButtonStyleData(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(4),
                                                  border: Border.all(color: const Color(0xffE0E7EC), width: 0.73)),
                                            ),
                                            menuItemStyleData: const MenuItemStyleData(height: 40),
                                            dropdownStyleData: DropdownStyleData(
                                                maxHeight: 200,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15), color: const Color(0xffffffff)),
                                                elevation: 8,
                                                offset: const Offset(0, 0)),
                                          ),
                                        ),
                                      )
                                    ]),
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: getIt<Variables>().generalVariables.currentLanguage.task,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                              color: const Color(0xff282F3A),
                                              fontFamily: "Figtree"),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                    color: const Color(0xffDC474A),
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Figtree")),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 44),
                                        child: TextFormField(
                                          controller: taskController,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                              color: const Color(0xff282F3A)),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              focusedErrorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              disabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              hintText: "Enter task",
                                              hintStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                  color: const Color(0xff8A8D8E))),
                                        ),
                                      )
                                    ]),
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: getIt<Variables>().generalVariables.currentLanguage.issues,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                              color: const Color(0xff282F3A),
                                              fontFamily: "Figtree"),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                    color: const Color(0xffDC474A),
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Figtree")),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 44),
                                        child: TextFormField(
                                          controller: issuesController,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                              color: const Color(0xff282F3A)),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              focusedErrorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              disabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              hintText: "Enter issues",
                                              hintStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                  color: const Color(0xff8A8D8E))),
                                        ),
                                      )
                                    ]),
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: getIt<Variables>().generalVariables.currentLanguage.requirement,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                              color: const Color(0xff282F3A),
                                              fontFamily: "Figtree"),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                    color: const Color(0xffDC474A),
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Figtree")),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 44),
                                        child: TextFormField(
                                          controller: requirementController,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                              color: const Color(0xff282F3A)),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              focusedErrorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              disabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              hintText: "Enter here",
                                              hintStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                  color: const Color(0xff8A8D8E))),
                                        ),
                                      )
                                    ]),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/task/task_content.svg",
                                        height: getIt<Functions>().getWidgetHeight(height: 16),
                                        width: getIt<Functions>().getWidgetWidth(width: 16),
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(
                                        width: getIt<Functions>().getWidgetWidth(width: 12),
                                      ),
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.departmentAndLocation.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                            color: const Color(0xff282F3A)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: getIt<Functions>().getWidgetHeight(height: 14),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: getIt<Functions>().getWidgetWidth(width: 16),
                                        vertical: getIt<Functions>().getWidgetHeight(height: 22)),
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  text: getIt<Variables>().generalVariables.currentLanguage.department,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      color: const Color(0xff282F3A),
                                                      fontFamily: "Figtree"),
                                                  children: const <TextSpan>[],
                                                ),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                              SizedBox(
                                                height: getIt<Functions>().getWidgetHeight(height: 45),
                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton2<String>(
                                                    isExpanded: true,
                                                    hint: Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.selectDepartment,
                                                      style: TextStyle(
                                                          color: const Color(0xff282F3A),
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                    ),
                                                    items: optionsData
                                                        .map((element) => DropdownMenuItem<String>(
                                                              value: element,
                                                              child: Text(
                                                                element,
                                                                style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    value: selectedTaskType,
                                                    onChanged: (String? suggestion) async {
                                                      selectedTaskType = suggestion ?? "";
                                                      fieldEmpty = false;
                                                      setState(() {});
                                                      /*context.read<PickListBloc>().selectedLocationId =
                                                  (context.read<PickListBloc>().searchedFloorData.singleWhere((e) => e.label == suggestion)).id;
                                              context.read<PickListBloc>().add(const PickListSetStateEvent(stillLoading: true));*/
                                                    },
                                                    iconStyleData: const IconStyleData(
                                                        icon: Icon(
                                                          Icons.keyboard_arrow_down,
                                                        ),
                                                        iconSize: 24,
                                                        iconEnabledColor: Color(0xff8A8D8E),
                                                        iconDisabledColor: Color(0xff8A8D8E)),
                                                    buttonStyleData: ButtonStyleData(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(4),
                                                          border: Border.all(color: const Color(0xffE0E7EC), width: 0.73)),
                                                    ),
                                                    menuItemStyleData: const MenuItemStyleData(height: 40),
                                                    dropdownStyleData: DropdownStyleData(
                                                        maxHeight: 200,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15), color: const Color(0xffffffff)),
                                                        elevation: 8,
                                                        offset: const Offset(0, 0)),
                                                  ),
                                                ),
                                              )
                                            ]),
                                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  text: getIt<Variables>().generalVariables.currentLanguage.location,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      color: const Color(0xff282F3A),
                                                      fontFamily: "Figtree"),
                                                  children: const <TextSpan>[],
                                                ),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                              SizedBox(
                                                height: getIt<Functions>().getWidgetHeight(height: 45),
                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton2<String>(
                                                    isExpanded: true,
                                                    hint: Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.chooseLocation,
                                                      style: TextStyle(
                                                          color: const Color(0xff282F3A),
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                    ),
                                                    items: optionsData
                                                        .map((element) => DropdownMenuItem<String>(
                                                              value: element,
                                                              child: Text(
                                                                element,
                                                                style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    value: selectedTaskType,
                                                    onChanged: (String? suggestion) async {
                                                      selectedTaskType = suggestion ?? "";
                                                      fieldEmpty = false;
                                                      setState(() {});
                                                      /*context.read<PickListBloc>().selectedLocationId =
                                                  (context.read<PickListBloc>().searchedFloorData.singleWhere((e) => e.label == suggestion)).id;
                                              context.read<PickListBloc>().add(const PickListSetStateEvent(stillLoading: true));*/
                                                    },
                                                    iconStyleData: const IconStyleData(
                                                        icon: Icon(
                                                          Icons.keyboard_arrow_down,
                                                        ),
                                                        iconSize: 24,
                                                        iconEnabledColor: Color(0xff8A8D8E),
                                                        iconDisabledColor: Color(0xff8A8D8E)),
                                                    buttonStyleData: ButtonStyleData(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(4),
                                                          border: Border.all(color: const Color(0xffE0E7EC), width: 0.73)),
                                                    ),
                                                    menuItemStyleData: const MenuItemStyleData(height: 40),
                                                    dropdownStyleData: DropdownStyleData(
                                                        maxHeight: 200,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15), color: const Color(0xffffffff)),
                                                        elevation: 8,
                                                        offset: const Offset(0, 0)),
                                                  ),
                                                ),
                                              )
                                            ]),
                                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 85)),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                              SizedBox(
                                width: getIt<Functions>().getWidgetWidth(width: 16),
                              ),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/task/task_content.svg",
                                        height: getIt<Functions>().getWidgetHeight(height: 16),
                                        width: getIt<Functions>().getWidgetWidth(width: 16),
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(
                                        width: getIt<Functions>().getWidgetWidth(width: 12),
                                      ),
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.assignmentAndDeadline.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                            color: const Color(0xff282F3A)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: getIt<Functions>().getWidgetHeight(height: 14),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: getIt<Functions>().getWidgetWidth(width: 16),
                                        vertical: getIt<Functions>().getWidgetHeight(height: 22)),
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  text: getIt<Variables>().generalVariables.currentLanguage.priority,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      color: const Color(0xff282F3A),
                                                      fontFamily: "Figtree"),
                                                  children: const <TextSpan>[],
                                                ),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                              SizedBox(
                                                height: getIt<Functions>().getWidgetHeight(height: 45),
                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton2<String>(
                                                    isExpanded: true,
                                                    hint: Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.selectPriority,
                                                      style: TextStyle(
                                                          color: const Color(0xff282F3A),
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                    ),
                                                    items: optionsData
                                                        .map((element) => DropdownMenuItem<String>(
                                                              value: element,
                                                              child: Text(
                                                                element,
                                                                style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    value: selectedTaskType,
                                                    onChanged: (String? suggestion) async {
                                                      selectedTaskType = suggestion ?? "";
                                                      fieldEmpty = false;
                                                      setState(() {});
                                                      /*context.read<PickListBloc>().selectedLocationId =
                                                  (context.read<PickListBloc>().searchedFloorData.singleWhere((e) => e.label == suggestion)).id;
                                              context.read<PickListBloc>().add(const PickListSetStateEvent(stillLoading: true));*/
                                                    },
                                                    iconStyleData: const IconStyleData(
                                                        icon: Icon(
                                                          Icons.keyboard_arrow_down,
                                                        ),
                                                        iconSize: 24,
                                                        iconEnabledColor: Color(0xff8A8D8E),
                                                        iconDisabledColor: Color(0xff8A8D8E)),
                                                    buttonStyleData: ButtonStyleData(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(4),
                                                          border: Border.all(color: const Color(0xffE0E7EC), width: 0.73)),
                                                    ),
                                                    menuItemStyleData: const MenuItemStyleData(height: 40),
                                                    dropdownStyleData: DropdownStyleData(
                                                        maxHeight: 200,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15), color: const Color(0xffffffff)),
                                                        elevation: 8,
                                                        offset: const Offset(0, 0)),
                                                  ),
                                                ),
                                              )
                                            ]),
                                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  text: getIt<Variables>().generalVariables.currentLanguage.assignTo,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      color: const Color(0xff282F3A),
                                                      fontFamily: "Figtree"),
                                                  children: const <TextSpan>[],
                                                ),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                              SizedBox(
                                                height: getIt<Functions>().getWidgetHeight(height: 45),
                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton2<String>(
                                                    isExpanded: true,
                                                    hint: Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.selectPerson,
                                                      style: TextStyle(
                                                          color: const Color(0xff282F3A),
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                    ),
                                                    items: optionsData
                                                        .map((element) => DropdownMenuItem<String>(
                                                              value: element,
                                                              child: Text(
                                                                element,
                                                                style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    value: selectedTaskType,
                                                    onChanged: (String? suggestion) async {
                                                      selectedTaskType = suggestion ?? "";
                                                      fieldEmpty = false;
                                                      setState(() {});
                                                      /*context.read<PickListBloc>().selectedLocationId =
                                                  (context.read<PickListBloc>().searchedFloorData.singleWhere((e) => e.label == suggestion)).id;
                                              context.read<PickListBloc>().add(const PickListSetStateEvent(stillLoading: true));*/
                                                    },
                                                    iconStyleData: const IconStyleData(
                                                        icon: Icon(
                                                          Icons.keyboard_arrow_down,
                                                        ),
                                                        iconSize: 24,
                                                        iconEnabledColor: Color(0xff8A8D8E),
                                                        iconDisabledColor: Color(0xff8A8D8E)),
                                                    buttonStyleData: ButtonStyleData(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(4),
                                                          border: Border.all(color: const Color(0xffE0E7EC), width: 0.73)),
                                                    ),
                                                    menuItemStyleData: const MenuItemStyleData(height: 40),
                                                    dropdownStyleData: DropdownStyleData(
                                                        maxHeight: 200,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15), color: const Color(0xffffffff)),
                                                        elevation: 8,
                                                        offset: const Offset(0, 0)),
                                                  ),
                                                ),
                                              )
                                            ]),
                                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  text: getIt<Variables>().generalVariables.currentLanguage.completeBy,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      color: const Color(0xff282F3A),
                                                      fontFamily: "Figtree"),
                                                  children: const <TextSpan>[],
                                                ),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                              SizedBox(
                                                height: getIt<Functions>().getWidgetHeight(height: 44),
                                                child: TextFormField(
                                                  onTap: () {
                                                    getIt<Widgets>().showCalenderSingleDialog(
                                                        context: context, controller: dateController, isFilter: false);
                                                  },
                                                  controller: dateController,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                      color: const Color(0xff282F3A)),
                                                  readOnly: true,
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4),
                                                          borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4),
                                                          borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4),
                                                          borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                      errorBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4),
                                                          borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                      focusedErrorBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4),
                                                          borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                      disabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4),
                                                          borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                      hintText: "Select Date",
                                                      hintStyle: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                          color: const Color(0xff8A8D8E)),
                                                      suffixIcon: Icon(
                                                        Icons.calendar_month,
                                                        color: const Color(0xff8A8D8E).withOpacity(0.5),
                                                      )),
                                                ),
                                              )
                                            ]),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                            ],
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 16),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/task/attachments.svg",
                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                width: getIt<Functions>().getWidgetWidth(width: 16),
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                width: getIt<Functions>().getWidgetWidth(width: 12),
                              ),
                              Text(
                                getIt<Variables>().generalVariables.currentLanguage.attachments.toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                    color: const Color(0xff282F3A)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 14),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: getIt<Functions>().getWidgetWidth(width: 16),
                                vertical: getIt<Functions>().getWidgetHeight(height: 22)),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  "assets/task/upload_image.svg",
                                  height: getIt<Functions>().getWidgetHeight(height: 75),
                                  width: getIt<Functions>().getWidgetWidth(width: 167),
                                  fit: BoxFit.fill,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 16),
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
          return Container(
            color: const Color(0xffEEF4FF),
            child: Column(
              children: [
                SizedBox(
                  child: AppBar(
                    backgroundColor: const Color(0xffEEF4FF),
                    automaticallyImplyLeading: false,
                    title: Row(
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          splashFactory: NoSplash.splashFactory,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            AddTaskBloc().add(const AddTaskSetStateEvent(stillLoading: true));
                            getIt<Variables>().generalVariables.indexName = getIt<Variables>()
                                .generalVariables
                                .taskRouteList[getIt<Variables>().generalVariables.taskRouteList.length - 1];
                            context.read<NavigationBloc>().add(const NavigationInitialEvent());
                            getIt<Variables>()
                                .generalVariables
                                .taskRouteList
                                .removeAt(getIt<Variables>().generalVariables.taskRouteList.length - 1);
                          },
                          child: const Icon(Icons.arrow_back),
                        ),
                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 8.58)),
                        Text(
                          getIt<Variables>().generalVariables.currentLanguage.addNewTask,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: getIt<Functions>().getTextSize(fontSize: 22),
                              color: const Color(0xff282F3A)),
                        ),
                      ],
                    ),
                    actions: [InkWell(
                      splashColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        AddTaskBloc().add(const AddTaskSetStateEvent(stillLoading: true));
                        getIt<Variables>().generalVariables.indexName = getIt<Variables>()
                            .generalVariables
                            .taskRouteList[getIt<Variables>().generalVariables.taskRouteList.length - 1];
                        context.read<NavigationBloc>().add(const NavigationInitialEvent());
                        getIt<Variables>()
                            .generalVariables
                            .taskRouteList
                            .removeAt(getIt<Variables>().generalVariables.taskRouteList.length - 1);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                            vertical: getIt<Functions>().getWidgetHeight(height: 6)),
                        margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 15)),
                        decoration: BoxDecoration(color: const Color(0xff007AFF), borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          getIt<Variables>().generalVariables.currentLanguage.create.toUpperCase(),
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    )],
                    elevation: 0.0,
                    surfaceTintColor: const Color(0xffffffff),
                    forceMaterialTransparency: true,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/task/task_content.svg",
                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                width: getIt<Functions>().getWidgetWidth(width: 16),
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                width: getIt<Functions>().getWidgetWidth(width: 12),
                              ),
                              Text(
                                getIt<Variables>().generalVariables.currentLanguage.taskContent.toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                    color: const Color(0xff282F3A)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 14),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.dateAndTime,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xff282F3A)),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                          SizedBox(
                                            height: getIt<Functions>().getWidgetHeight(height: 44),
                                            child: TextFormField(
                                              initialValue: "14/05/2025, 09:45 AM",
                                              readOnly: true,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                  color: const Color(0xff8A8D8E)),
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                filled: true,
                                                fillColor: const Color(0xffF4F5F6),
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                errorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              ),
                                            ),
                                          )
                                        ]),
                                    SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 16),
                                    ),
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.personCreated,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xff282F3A)),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                          SizedBox(
                                            height: getIt<Functions>().getWidgetHeight(height: 44),
                                            child: TextFormField(
                                              initialValue: "Ramesh R",
                                              readOnly: true,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                  color: const Color(0xff8A8D8E)),
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                filled: true,
                                                fillColor: const Color(0xffF4F5F6),
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                errorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                    borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              ),
                                            ),
                                          )
                                        ]),
                                  ],
                                ),
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: getIt<Variables>().generalVariables.currentLanguage.taskType,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                              color: const Color(0xff282F3A),
                                              fontFamily: "Figtree"),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                    color: const Color(0xffDC474A),
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Figtree")),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 45),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2<String>(
                                            isExpanded: true,
                                            hint: Text(
                                              getIt<Variables>().generalVariables.currentLanguage.chooseTaskType,
                                              style: TextStyle(
                                                  color: const Color(0xff282F3A),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                            ),
                                            items: optionsData
                                                .map((element) => DropdownMenuItem<String>(
                                              value: element,
                                              child: Text(
                                                element,
                                                style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                ),
                                              ),
                                            ))
                                                .toList(),
                                            value: selectedTaskType,
                                            onChanged: (String? suggestion) async {
                                              selectedTaskType = suggestion ?? "";
                                              fieldEmpty = false;
                                              setState(() {});
                                              /*context.read<PickListBloc>().selectedLocationId =
                                                  (context.read<PickListBloc>().searchedFloorData.singleWhere((e) => e.label == suggestion)).id;
                                              context.read<PickListBloc>().add(const PickListSetStateEvent(stillLoading: true));*/
                                            },
                                            iconStyleData: const IconStyleData(
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                ),
                                                iconSize: 24,
                                                iconEnabledColor: Color(0xff8A8D8E),
                                                iconDisabledColor: Color(0xff8A8D8E)),
                                            buttonStyleData: ButtonStyleData(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(4),
                                                  border: Border.all(color: const Color(0xffE0E7EC), width: 0.73)),
                                            ),
                                            menuItemStyleData: const MenuItemStyleData(height: 40),
                                            dropdownStyleData: DropdownStyleData(
                                                maxHeight: 200,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15), color: const Color(0xffffffff)),
                                                elevation: 8,
                                                offset: const Offset(0, 0)),
                                          ),
                                        ),
                                      )
                                    ]),
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: getIt<Variables>().generalVariables.currentLanguage.task,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                              color: const Color(0xff282F3A),
                                              fontFamily: "Figtree"),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                    color: const Color(0xffDC474A),
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Figtree")),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 44),
                                        child: TextFormField(
                                          controller: taskController,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                              color: const Color(0xff282F3A)),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              focusedErrorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              disabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              hintText: "Enter task",
                                              hintStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                  color: const Color(0xff8A8D8E))),
                                        ),
                                      )
                                    ]),
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: getIt<Variables>().generalVariables.currentLanguage.issues,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                              color: const Color(0xff282F3A),
                                              fontFamily: "Figtree"),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                    color: const Color(0xffDC474A),
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Figtree")),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 44),
                                        child: TextFormField(
                                          controller: issuesController,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                              color: const Color(0xff282F3A)),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              focusedErrorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              disabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              hintText: "Enter issues",
                                              hintStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                  color: const Color(0xff8A8D8E))),
                                        ),
                                      )
                                    ]),
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: getIt<Variables>().generalVariables.currentLanguage.requirement,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                              color: const Color(0xff282F3A),
                                              fontFamily: "Figtree"),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                    color: const Color(0xffDC474A),
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Figtree")),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 44),
                                        child: TextFormField(
                                          controller: requirementController,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                              color: const Color(0xff282F3A)),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              focusedErrorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              disabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                  borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                              hintText: "Enter here",
                                              hintStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                  color: const Color(0xff8A8D8E))),
                                        ),
                                      )
                                    ]),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 16),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/task/task_content.svg",
                                        height: getIt<Functions>().getWidgetHeight(height: 16),
                                        width: getIt<Functions>().getWidgetWidth(width: 16),
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(
                                        width: getIt<Functions>().getWidgetWidth(width: 12),
                                      ),
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.departmentAndLocation.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                            color: const Color(0xff282F3A)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: getIt<Functions>().getWidgetHeight(height: 14),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                        vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  text: getIt<Variables>().generalVariables.currentLanguage.department,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      color: const Color(0xff282F3A),
                                                      fontFamily: "Figtree"),
                                                  children: const <TextSpan>[],
                                                ),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                              SizedBox(
                                                height: getIt<Functions>().getWidgetHeight(height: 45),
                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton2<String>(
                                                    isExpanded: true,
                                                    hint: Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.selectDepartment,
                                                      style: TextStyle(
                                                          color: const Color(0xff282F3A),
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                    ),
                                                    items: optionsData
                                                        .map((element) => DropdownMenuItem<String>(
                                                      value: element,
                                                      child: Text(
                                                        element,
                                                        style: TextStyle(
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                        ),
                                                      ),
                                                    ))
                                                        .toList(),
                                                    value: selectedTaskType,
                                                    onChanged: (String? suggestion) async {
                                                      selectedTaskType = suggestion ?? "";
                                                      fieldEmpty = false;
                                                      setState(() {});
                                                      /*context.read<PickListBloc>().selectedLocationId =
                                              (context.read<PickListBloc>().searchedFloorData.singleWhere((e) => e.label == suggestion)).id;
                                          context.read<PickListBloc>().add(const PickListSetStateEvent(stillLoading: true));*/
                                                    },
                                                    iconStyleData: const IconStyleData(
                                                        icon: Icon(
                                                          Icons.keyboard_arrow_down,
                                                        ),
                                                        iconSize: 24,
                                                        iconEnabledColor: Color(0xff8A8D8E),
                                                        iconDisabledColor: Color(0xff8A8D8E)),
                                                    buttonStyleData: ButtonStyleData(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(4),
                                                          border: Border.all(color: const Color(0xffE0E7EC), width: 0.73)),
                                                    ),
                                                    menuItemStyleData: const MenuItemStyleData(height: 40),
                                                    dropdownStyleData: DropdownStyleData(
                                                        maxHeight: 200,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15), color: const Color(0xffffffff)),
                                                        elevation: 8,
                                                        offset: const Offset(0, 0)),
                                                  ),
                                                ),
                                              )
                                            ]),
                                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  text: getIt<Variables>().generalVariables.currentLanguage.location,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      color: const Color(0xff282F3A),
                                                      fontFamily: "Figtree"),
                                                  children: const <TextSpan>[],
                                                ),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                              SizedBox(
                                                height: getIt<Functions>().getWidgetHeight(height: 45),
                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton2<String>(
                                                    isExpanded: true,
                                                    hint: Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.chooseLocation,
                                                      style: TextStyle(
                                                          color: const Color(0xff282F3A),
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                    ),
                                                    items: optionsData
                                                        .map((element) => DropdownMenuItem<String>(
                                                      value: element,
                                                      child: Text(
                                                        element,
                                                        style: TextStyle(
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                        ),
                                                      ),
                                                    ))
                                                        .toList(),
                                                    value: selectedTaskType,
                                                    onChanged: (String? suggestion) async {
                                                      selectedTaskType = suggestion ?? "";
                                                      fieldEmpty = false;
                                                      setState(() {});
                                                      /*context.read<PickListBloc>().selectedLocationId =
                                              (context.read<PickListBloc>().searchedFloorData.singleWhere((e) => e.label == suggestion)).id;
                                          context.read<PickListBloc>().add(const PickListSetStateEvent(stillLoading: true));*/
                                                    },
                                                    iconStyleData: const IconStyleData(
                                                        icon: Icon(
                                                          Icons.keyboard_arrow_down,
                                                        ),
                                                        iconSize: 24,
                                                        iconEnabledColor: Color(0xff8A8D8E),
                                                        iconDisabledColor: Color(0xff8A8D8E)),
                                                    buttonStyleData: ButtonStyleData(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(4),
                                                          border: Border.all(color: const Color(0xffE0E7EC), width: 0.73)),
                                                    ),
                                                    menuItemStyleData: const MenuItemStyleData(height: 40),
                                                    dropdownStyleData: DropdownStyleData(
                                                        maxHeight: 200,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15), color: const Color(0xffffffff)),
                                                        elevation: 8,
                                                        offset: const Offset(0, 0)),
                                                  ),
                                                ),
                                              )
                                            ]),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: getIt<Functions>().getWidgetHeight(height: 16),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/task/task_content.svg",
                                        height: getIt<Functions>().getWidgetHeight(height: 16),
                                        width: getIt<Functions>().getWidgetWidth(width: 16),
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(
                                        width: getIt<Functions>().getWidgetWidth(width: 12),
                                      ),
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.assignmentAndDeadline.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                            color: const Color(0xff282F3A)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: getIt<Functions>().getWidgetHeight(height: 14),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                        vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  text: getIt<Variables>().generalVariables.currentLanguage.priority,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      color: const Color(0xff282F3A),
                                                      fontFamily: "Figtree"),
                                                  children: const <TextSpan>[],
                                                ),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                              SizedBox(
                                                height: getIt<Functions>().getWidgetHeight(height: 45),
                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton2<String>(
                                                    isExpanded: true,
                                                    hint: Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.selectPriority,
                                                      style: TextStyle(
                                                          color: const Color(0xff282F3A),
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                    ),
                                                    items: optionsData
                                                        .map((element) => DropdownMenuItem<String>(
                                                      value: element,
                                                      child: Text(
                                                        element,
                                                        style: TextStyle(
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                        ),
                                                      ),
                                                    ))
                                                        .toList(),
                                                    value: selectedTaskType,
                                                    onChanged: (String? suggestion) async {
                                                      selectedTaskType = suggestion ?? "";
                                                      fieldEmpty = false;
                                                      setState(() {});
                                                      /*context.read<PickListBloc>().selectedLocationId =
                                              (context.read<PickListBloc>().searchedFloorData.singleWhere((e) => e.label == suggestion)).id;
                                          context.read<PickListBloc>().add(const PickListSetStateEvent(stillLoading: true));*/
                                                    },
                                                    iconStyleData: const IconStyleData(
                                                        icon: Icon(
                                                          Icons.keyboard_arrow_down,
                                                        ),
                                                        iconSize: 24,
                                                        iconEnabledColor: Color(0xff8A8D8E),
                                                        iconDisabledColor: Color(0xff8A8D8E)),
                                                    buttonStyleData: ButtonStyleData(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(4),
                                                          border: Border.all(color: const Color(0xffE0E7EC), width: 0.73)),
                                                    ),
                                                    menuItemStyleData: const MenuItemStyleData(height: 40),
                                                    dropdownStyleData: DropdownStyleData(
                                                        maxHeight: 200,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15), color: const Color(0xffffffff)),
                                                        elevation: 8,
                                                        offset: const Offset(0, 0)),
                                                  ),
                                                ),
                                              )
                                            ]),
                                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  text: getIt<Variables>().generalVariables.currentLanguage.assignTo,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      color: const Color(0xff282F3A),
                                                      fontFamily: "Figtree"),
                                                  children: const <TextSpan>[],
                                                ),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                              SizedBox(
                                                height: getIt<Functions>().getWidgetHeight(height: 45),
                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton2<String>(
                                                    isExpanded: true,
                                                    hint: Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.selectPerson,
                                                      style: TextStyle(
                                                          color: const Color(0xff282F3A),
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                    ),
                                                    items: optionsData
                                                        .map((element) => DropdownMenuItem<String>(
                                                      value: element,
                                                      child: Text(
                                                        element,
                                                        style: TextStyle(
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                        ),
                                                      ),
                                                    ))
                                                        .toList(),
                                                    value: selectedTaskType,
                                                    onChanged: (String? suggestion) async {
                                                      selectedTaskType = suggestion ?? "";
                                                      fieldEmpty = false;
                                                      setState(() {});
                                                      /*context.read<PickListBloc>().selectedLocationId =
                                              (context.read<PickListBloc>().searchedFloorData.singleWhere((e) => e.label == suggestion)).id;
                                          context.read<PickListBloc>().add(const PickListSetStateEvent(stillLoading: true));*/
                                                    },
                                                    iconStyleData: const IconStyleData(
                                                        icon: Icon(
                                                          Icons.keyboard_arrow_down,
                                                        ),
                                                        iconSize: 24,
                                                        iconEnabledColor: Color(0xff8A8D8E),
                                                        iconDisabledColor: Color(0xff8A8D8E)),
                                                    buttonStyleData: ButtonStyleData(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(4),
                                                          border: Border.all(color: const Color(0xffE0E7EC), width: 0.73)),
                                                    ),
                                                    menuItemStyleData: const MenuItemStyleData(height: 40),
                                                    dropdownStyleData: DropdownStyleData(
                                                        maxHeight: 200,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15), color: const Color(0xffffffff)),
                                                        elevation: 8,
                                                        offset: const Offset(0, 0)),
                                                  ),
                                                ),
                                              )
                                            ]),
                                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  text: getIt<Variables>().generalVariables.currentLanguage.completeBy,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      color: const Color(0xff282F3A),
                                                      fontFamily: "Figtree"),
                                                  children: const <TextSpan>[],
                                                ),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                              SizedBox(
                                                height: getIt<Functions>().getWidgetHeight(height: 44),
                                                child: TextFormField(
                                                  onTap: () {
                                                    getIt<Widgets>().showCalenderSingleDialog(
                                                        context: context, controller: dateController, isFilter: false);
                                                  },
                                                  controller: dateController,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                      color: const Color(0xff282F3A)),
                                                  readOnly: true,
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                      EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 16)),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4),
                                                          borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4),
                                                          borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4),
                                                          borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                      errorBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4),
                                                          borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                      focusedErrorBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4),
                                                          borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                      disabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(4),
                                                          borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 1)),
                                                      hintText: "Select Date",
                                                      hintStyle: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                          color: const Color(0xff8A8D8E)),
                                                      suffixIcon: Icon(
                                                        Icons.calendar_month,
                                                        color: const Color(0xff8A8D8E).withOpacity(0.5),
                                                      )),
                                                ),
                                              )
                                            ]),
                                      ],
                                    ),
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
                              SvgPicture.asset(
                                "assets/task/attachments.svg",
                                height: getIt<Functions>().getWidgetHeight(height: 16),
                                width: getIt<Functions>().getWidgetWidth(width: 16),
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                width: getIt<Functions>().getWidgetWidth(width: 12),
                              ),
                              Text(
                                getIt<Variables>().generalVariables.currentLanguage.attachments.toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                    color: const Color(0xff282F3A)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 14),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  "assets/task/upload_image.svg",
                                  height: getIt<Functions>().getWidgetHeight(height: 75),
                                  width: getIt<Functions>().getWidgetWidth(width: 167),
                                  fit: BoxFit.fill,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
