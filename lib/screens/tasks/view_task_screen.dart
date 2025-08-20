import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/bloc/task/view_task_bloc/view_task_bloc.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';

class ViewTaskScreen extends StatefulWidget {
  static const String id = "view_task_screen";
  const ViewTaskScreen({super.key});

  @override
  State<ViewTaskScreen> createState() => _ViewTaskScreenState();
}

class _ViewTaskScreenState extends State<ViewTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        ViewTaskBloc().add(const ViewTaskSetStateEvent(stillLoading: true));
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
                        ViewTaskBloc().add(const ViewTaskSetStateEvent(stillLoading: true));
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
                      "${getIt<Variables>().generalVariables.currentLanguage.sNo} : #123456789",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: getIt<Functions>().getTextSize(fontSize: 26),
                          color: const Color(0xff282F3A)),
                    ),
                    actions: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: getIt<Functions>().getWidgetWidth(width: 20),
                            vertical: getIt<Functions>().getWidgetHeight(height: 8)),
                        margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 15)),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 15,
                              color: const Color(0xff50566B).withOpacity(0.73),
                            ),
                            SizedBox(
                              width: getIt<Functions>().getWidgetWidth(width: 8),
                            ),
                            Text(
                              "26/05/2025, 09:45 AM",
                              style: TextStyle(
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff50566B)),
                            ),
                          ],
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
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            getIt<Variables>().generalVariables.currentLanguage.taskInfo.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xff282F3A)),
                                          ),
                                        ],
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: "${getIt<Variables>().generalVariables.currentLanguage.taskType} :",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A),
                                              fontFamily: "Figtree"),
                                          children: const <TextSpan>[
                                            TextSpan(
                                                text: " PURCHASE",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xff282F3A),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ]),
                                SizedBox(
                                  height: getIt<Functions>().getWidgetHeight(height: 20),
                                ),
                                Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: getIt<Functions>().getWidgetWidth(width: 14),
                                        vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                                    decoration: BoxDecoration(
                                        color: const Color(0xffF4F5F6),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xffE0E7EC))),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: getIt<Functions>().getWidgetWidth(width: 7),
                                                vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff007AFF),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              "TASK",
                                              style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                          Text(
                                            "Follow up with supplier for missing invoice related to last week’s hardware shipment",
                                            style: TextStyle(
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xff282F3A)),
                                          )
                                        ])),
                                SizedBox(
                                  height: getIt<Functions>().getWidgetHeight(height: 20),
                                ),
                                Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: getIt<Functions>().getWidgetWidth(width: 14),
                                        vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                                    decoration: BoxDecoration(
                                        color: const Color(0xffF4F5F6),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xffE0E7EC))),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: getIt<Functions>().getWidgetWidth(width: 7),
                                                vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff007AFF),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              "ISSUE",
                                              style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                          Text(
                                            "Supplier did not include invoice for PO #4567, causing delay in GRN and payment processing.",
                                            style: TextStyle(
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xff282F3A)),
                                          )
                                        ])),
                                SizedBox(
                                  height: getIt<Functions>().getWidgetHeight(height: 20),
                                ),
                                Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: getIt<Functions>().getWidgetWidth(width: 14),
                                        vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                                    decoration: BoxDecoration(
                                        color: const Color(0xffF4F5F6),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xffE0E7EC))),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: getIt<Functions>().getWidgetWidth(width: 7),
                                                vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff007AFF),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              "REQUIREMENT",
                                              style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                          Text(
                                            "3 rolls of shrink wrap, 18” wide, vendor PO#123 required by EOD",
                                            style: TextStyle(
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xff282F3A)),
                                          )
                                        ])),
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
                                  child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: getIt<Functions>().getWidgetWidth(width: 16),
                                    vertical: getIt<Functions>().getWidgetHeight(height: 22)),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
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
                                          getIt<Variables>().generalVariables.currentLanguage.assignmentAndDepartment.toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                              color: const Color(0xff282F3A)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 16),
                                    ),
                                    const Divider(
                                      height: 0,
                                      thickness: 1,
                                      color: Color(0xffE0E7EC),
                                    ),
                                    SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 16),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          getIt<Variables>().generalVariables.currentLanguage.department,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
                                        ),
                                        Text(
                                          "Inbound",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
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
                                        Text(
                                          getIt<Variables>().generalVariables.currentLanguage.location,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
                                        ),
                                        Text(
                                          "Colonial",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
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
                                        Text(
                                          getIt<Variables>().generalVariables.currentLanguage.priority,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
                                        ),
                                        Text(
                                          "Normal",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
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
                                        Text(
                                          getIt<Variables>().generalVariables.currentLanguage.personCreated,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
                                        ),
                                        Text(
                                          "Ramesh R",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
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
                                        Text(
                                          getIt<Variables>().generalVariables.currentLanguage.assignTo,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
                                        ),
                                        Text(
                                          "Arjun",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
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
                                        Text(
                                          getIt<Variables>().generalVariables.currentLanguage.completeBy,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
                                        ),
                                        Text(
                                          "27/05/2025",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
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
                                        Text(
                                          getIt<Variables>().generalVariables.currentLanguage.daysToComplete,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
                                        ),
                                        Text(
                                          "1 Day",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                              SizedBox(
                                width: getIt<Functions>().getWidgetWidth(width: 16),
                              ),
                              Expanded(
                                  child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: getIt<Functions>().getWidgetWidth(width: 16),
                                    vertical: getIt<Functions>().getWidgetHeight(height: 22)),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
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
                                          getIt<Variables>().generalVariables.currentLanguage.statusAndRemarks.toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                              color: const Color(0xff282F3A)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 16),
                                    ),
                                    const Divider(
                                      height: 0,
                                      thickness: 1,
                                      color: Color(0xffE0E7EC),
                                    ),
                                    SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 16),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          getIt<Variables>().generalVariables.currentLanguage.status,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
                                        ),
                                        Text(
                                          "Not Assigned",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 16),
                                    ),
                                    DottedBorder(
                                      color: const Color(0xffE0E7EC),
                                      strokeWidth: 1,
                                      borderType: BorderType.RRect,
                                      dashPattern: const [6, 3],
                                      radius: const Radius.circular(12),
                                      child: Container(
                                        height: getIt<Functions>().getWidgetHeight(height: 191),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: getIt<Functions>().getWidgetWidth(width: 14),
                                            vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffF4F5F6),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: getIt<Functions>().getWidgetWidth(width: 7),
                                                  vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                              decoration: BoxDecoration(
                                                color: const Color(0xff007AFF),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                "REMARKS",
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                            Text(
                                              "Task delayed due to missing shrink wrap. Expected stock by evening.",
                                              style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color(0xff282F3A)),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 16),
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
                            ViewTaskBloc().add(const ViewTaskSetStateEvent(stillLoading: true));
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
                          "# 123456789",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                              color: const Color(0xff282F3A)),
                        ),
                      ],
                    ),
                    actions:  [Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                          vertical: getIt<Functions>().getWidgetHeight(height: 6)),
                      margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 8)),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 15,
                            color: const Color(0xff50566B).withOpacity(0.73),
                          ),
                          SizedBox(
                            width: getIt<Functions>().getWidgetWidth(width: 4),
                          ),
                          Text(
                            "26/05/2025, 09:45 AM",
                            style: TextStyle(
                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff50566B)),
                          ),
                        ],
                      ),
                    )],
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
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                vertical: getIt<Functions>().getWidgetHeight(height: 14)),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            getIt<Variables>().generalVariables.currentLanguage.taskInfo.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xff282F3A)),
                                          ),
                                        ],
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: "${getIt<Variables>().generalVariables.currentLanguage.taskType} :",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A),
                                              fontFamily: "Figtree"),
                                          children: const <TextSpan>[
                                            TextSpan(
                                                text: " PURCHASE",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xff282F3A),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ]),
                                SizedBox(
                                  height: getIt<Functions>().getWidgetHeight(height: 20),
                                ),
                                Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: getIt<Functions>().getWidgetWidth(width: 14),
                                        vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                                    decoration: BoxDecoration(
                                        color: const Color(0xffF4F5F6),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xffE0E7EC))),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: getIt<Functions>().getWidgetWidth(width: 7),
                                                vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff007AFF),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              "TASK",
                                              style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                          Text(
                                            "Follow up with supplier for missing invoice related to last week’s hardware shipment",
                                            style: TextStyle(
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xff282F3A)),
                                          )
                                        ])),
                                SizedBox(
                                  height: getIt<Functions>().getWidgetHeight(height: 20),
                                ),
                                Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: getIt<Functions>().getWidgetWidth(width: 14),
                                        vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                                    decoration: BoxDecoration(
                                        color: const Color(0xffF4F5F6),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xffE0E7EC))),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: getIt<Functions>().getWidgetWidth(width: 7),
                                                vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff007AFF),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              "ISSUE",
                                              style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                          Text(
                                            "Supplier did not include invoice for PO #4567, causing delay in GRN and payment processing.",
                                            style: TextStyle(
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xff282F3A)),
                                          )
                                        ])),
                                SizedBox(
                                  height: getIt<Functions>().getWidgetHeight(height: 20),
                                ),
                                Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: getIt<Functions>().getWidgetWidth(width: 14),
                                        vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                                    decoration: BoxDecoration(
                                        color: const Color(0xffF4F5F6),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xffE0E7EC))),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: getIt<Functions>().getWidgetWidth(width: 7),
                                                vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff007AFF),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              "REQUIREMENT",
                                              style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                          Text(
                                            "3 rolls of shrink wrap, 18” wide, vendor PO#123 required by EOD",
                                            style: TextStyle(
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xff282F3A)),
                                          )
                                        ])),
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
                                          getIt<Variables>().generalVariables.currentLanguage.assignmentAndDepartment.toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                              color: const Color(0xff282F3A)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 16),
                                    ),
                                    const Divider(
                                      height: 0,
                                      thickness: 1,
                                      color: Color(0xffE0E7EC),
                                    ),
                                    SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 16),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          getIt<Variables>().generalVariables.currentLanguage.department,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
                                        ),
                                        Text(
                                          "Inbound",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
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
                                        Text(
                                          getIt<Variables>().generalVariables.currentLanguage.location,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
                                        ),
                                        Text(
                                          "Colonial",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
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
                                        Text(
                                          getIt<Variables>().generalVariables.currentLanguage.priority,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
                                        ),
                                        Text(
                                          "Normal",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
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
                                        Text(
                                          getIt<Variables>().generalVariables.currentLanguage.personCreated,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
                                        ),
                                        Text(
                                          "Ramesh R",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
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
                                        Text(
                                          getIt<Variables>().generalVariables.currentLanguage.assignTo,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
                                        ),
                                        Text(
                                          "Arjun",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
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
                                        Text(
                                          getIt<Variables>().generalVariables.currentLanguage.completeBy,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
                                        ),
                                        Text(
                                          "27/05/2025",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
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
                                        Text(
                                          getIt<Variables>().generalVariables.currentLanguage.daysToComplete,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
                                        ),
                                        Text(
                                          "1 Day",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
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
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                    vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
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
                                          getIt<Variables>().generalVariables.currentLanguage.statusAndRemarks.toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                              color: const Color(0xff282F3A)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 16),
                                    ),
                                    const Divider(
                                      height: 0,
                                      thickness: 1,
                                      color: Color(0xffE0E7EC),
                                    ),
                                    SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 16),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          getIt<Variables>().generalVariables.currentLanguage.status,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
                                        ),
                                        Text(
                                          "Not Assigned",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              color: const Color(0xff282F3A)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 16),
                                    ),
                                    DottedBorder(
                                      color: const Color(0xffE0E7EC),
                                      strokeWidth: 1,
                                      borderType: BorderType.RRect,
                                      dashPattern: const [6, 3],
                                      radius: const Radius.circular(12),
                                      child: Container(
                                        height: getIt<Functions>().getWidgetHeight(height: 191),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: getIt<Functions>().getWidgetWidth(width: 14),
                                            vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffF4F5F6),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: getIt<Functions>().getWidgetWidth(width: 7),
                                                  vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                              decoration: BoxDecoration(
                                                color: const Color(0xff007AFF),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                "REMARKS",
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                            Text(
                                              "Task delayed due to missing shrink wrap. Expected stock by evening.",
                                              style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color(0xff282F3A)),
                                            )
                                          ],
                                        ),
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
