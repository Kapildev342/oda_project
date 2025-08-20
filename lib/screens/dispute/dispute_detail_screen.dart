// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Project imports:
import 'package:oda/bloc/dispute/dispute_main/dispute_main_bloc.dart';
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/repository_model/dispute/dispute_model.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/resources/widgets.dart';

class DisputeDetailScreen extends StatefulWidget {
  static const String id = "dispute_detail_screen";
  const DisputeDetailScreen({super.key});

  @override
  State<DisputeDetailScreen> createState() => _DisputeDetailScreenState();
}

class _DisputeDetailScreenState extends State<DisputeDetailScreen> {
  TextEditingController commentsBar = TextEditingController();
  final TextEditingController reasonSearchFieldController = TextEditingController();
  String? selectedReason;

  @override
  void initState() {
    context.read<DisputeMainBloc>().add(const DisputeMainSetStateEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        getIt<Variables>().generalVariables.indexName = getIt<Variables>().generalVariables.disputeRouteList[getIt<Variables>().generalVariables.disputeRouteList.length - 1];
        context.read<NavigationBloc>().add(const NavigationInitialEvent());
        getIt<Variables>().generalVariables.disputeRouteList.removeAt(getIt<Variables>().generalVariables.disputeRouteList.length - 1);
      },
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 480) {
          return Container(
            color: const Color(0xffEEF4FF),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: 274),
                  child: AppBar(
                    backgroundColor: const Color(0xff1D2736),
                    leading: IconButton(
                      onPressed: () {
                        getIt<Variables>().generalVariables.indexName = getIt<Variables>().generalVariables.disputeRouteList[getIt<Variables>().generalVariables.disputeRouteList.length - 1];
                        context.read<NavigationBloc>().add(const NavigationInitialEvent());
                        getIt<Variables>().generalVariables.disputeRouteList.removeAt(getIt<Variables>().generalVariables.disputeRouteList.length - 1);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xffffffff),
                      ),
                    ),
                    title: Text(
                      "${getIt<Variables>().generalVariables.currentLanguage.dispute}  #: ${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].disputeNum}",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: getIt<Functions>().getTextSize(fontSize: 26), color: const Color(0xffffffff)),
                    ),
                    titleSpacing: 0,
                    bottom: PreferredSize(
                      preferredSize: Size(
                        Orientation.portrait == MediaQuery.of(context).orientation ? getIt<Variables>().generalVariables.width : getIt<Variables>().generalVariables.height,
                        getIt<Functions>().getWidgetHeight(height: 200),
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                        Container(
                          height: getIt<Functions>().getWidgetHeight(height: 80),
                          margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 16)),
                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 14), vertical: getIt<Functions>().getWidgetHeight(height: 14)),
                          decoration: BoxDecoration(color: const Color(0xffFFFFFF).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: getIt<Functions>().getWidgetHeight(height: 44),
                                      width: getIt<Functions>().getWidgetWidth(width: 44),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(int.parse('0xFF${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].itemColor}'))),
                                      child: Center(
                                        child: Text(
                                          context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].itemType,
                                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 28), color: const Color(0xffffffff)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: getIt<Functions>().getWidgetWidth(width: 10),
                                    ),
                                    Flexible(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].itemName,
                                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 16), color: const Color(0xffffffff)),
                                            ),
                                          ),
                                          Text(
                                            "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].itemCode}",
                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 11), color: const Color(0xffffffff)),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
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
                                    context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].quantity,
                                    style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 24), fontWeight: FontWeight.w600,color: const Color(0xffFFFFFF)),
                                  ),
                                  Text(
                                    getIt<Variables>().generalVariables.currentLanguage.qty.toUpperCase(),
                                    style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 11), fontWeight: FontWeight.w500, color: const Color(0xffffffff)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 24)),
                        Container(
                          height: getIt<Functions>().getWidgetHeight(height: 45),
                          margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 16)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getIt<Variables>().generalVariables.currentLanguage.picklist.toUpperCase(),
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xffffffff)),
                                  ),
                                  Text(
                                    context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].picklistNum,
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff50D464)),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${getIt<Variables>().generalVariables.currentLanguage.so.toUpperCase()} #",
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xffffffff)),
                                  ),
                                  Text(
                                    context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].soNum,
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff50D464)),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].locationType.toUpperCase(),
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xffffffff)),
                                  ),
                                  Text(
                                    context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].location,
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff50D464)),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getIt<Variables>().generalVariables.currentLanguage.dateAndTime.toUpperCase(),
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xffffffff)),
                                  ),
                                  Text(
                                    context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].created,
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff50D464)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 24)),
                      ]),
                    ),
                    actions: const [SizedBox()],
                  ),
                ),
                BlocConsumer<DisputeMainBloc, DisputeMainState>(
                    listenWhen: (DisputeMainState previous, DisputeMainState current) {
                      return previous != current;
                    },
                    buildWhen: (DisputeMainState previous, DisputeMainState current) {
                      return previous != current;
                    },
                    listener: (BuildContext context, DisputeMainState state) {},
                    builder: (BuildContext context, DisputeMainState state) {
                      if (state is DisputeMainLoaded) {
                        return Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 30)),
                                Container(
                                  height: getIt<Functions>().getWidgetHeight(height: 40),
                                  margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                  padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xffE0E7EC)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        child: Text(
                                          getIt<Variables>().generalVariables.currentLanguage.batch.toUpperCase(),
                                          style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          getIt<Variables>().generalVariables.currentLanguage.stockType,
                                          style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          getIt<Variables>().generalVariables.currentLanguage.requiredQty,
                                          style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          getIt<Variables>().generalVariables.currentLanguage.disputeQty,
                                          style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                SizedBox(
                                    child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        physics: const ScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].batchInfo.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Container(
                                            height: getIt<Functions>().getWidgetHeight(height: 30),
                                            margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 20,right: 5),
                                                    child: Text(
                                                      context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].batchInfo[index].batchNum,
                                                      style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff282F3A)),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 5),
                                                    child: Center(
                                                      child: Text(
                                                        context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].batchInfo[index].stockType,
                                                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff282F3A)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].batchInfo[index].quantity,
                                                      style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff282F3A)),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].batchInfo[index].disputeQty,
                                                      style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff282F3A)),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        })),
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: getIt<Functions>().getWidgetHeight(height: 40),
                                            margin: EdgeInsets.only(
                                                left: getIt<Functions>().getWidgetWidth(width: 20),
                                                right: context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.by.isEmpty
                                                    ? getIt<Functions>().getWidgetWidth(width: 20)
                                                    : 0),
                                            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xffE0E7EC)),
                                            child: Row(
                                              children: [
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.disputeInfo.toUpperCase(),
                                                  style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: getIt<Functions>().getWidgetWidth(width: 20),
                                                right: context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.by.isEmpty
                                                    ? getIt<Functions>().getWidgetWidth(width: 20)
                                                    : 0),
                                            child: Text(
                                              getIt<Variables>().generalVariables.currentLanguage.raisedBy.toUpperCase(),
                                              style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w400, color: const Color(0xff6F6F6F)),
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                          Container(
                                            height: getIt<Functions>().getWidgetHeight(height: 78),
                                            margin: EdgeInsets.only(
                                                left: getIt<Functions>().getWidgetWidth(width: 20),
                                                right: context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.by.isEmpty
                                                    ? getIt<Functions>().getWidgetWidth(width: 20)
                                                    : 0),
                                            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xffffffff)),
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
                                                        image: NetworkImage(context
                                                                .read<DisputeMainBloc>()
                                                                .disputeMainResponse
                                                                .disputeList[context.read<DisputeMainBloc>().selectedIndex]
                                                                .disputeInfo
                                                                .by
                                                                .isNotEmpty
                                                            ? context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].disputeInfo.by.first.image
                                                            : ""),
                                                        fit: BoxFit.fill,
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: getIt<Functions>().getWidgetWidth(width: 10),
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].disputeInfo.by.isNotEmpty
                                                          ? context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].disputeInfo.by.first.name
                                                          : "",
                                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 16), color: const Color(0xff282F3A)),
                                                    ),
                                                    Text(
                                                      "${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].disputeInfo.by.isNotEmpty ? context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].disputeInfo.by.first.employeeType : ""}  |  ${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].disputeInfo.on}",
                                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: const Color(0xff007AFF)),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 28)),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: getIt<Functions>().getWidgetWidth(width: 20),
                                                right: context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.by.isEmpty
                                                    ? getIt<Functions>().getWidgetWidth(width: 20)
                                                    : 0),
                                            child: Text(
                                              context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].disputeInfo.reason,
                                              style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 26), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                          Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.only(
                                                left: getIt<Functions>().getWidgetWidth(width: 20),
                                                right: context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.by.isEmpty
                                                    ? getIt<Functions>().getWidgetWidth(width: 20)
                                                    : 0),
                                            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20), vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xffE0E7EC))),
                                            child: Text(
                                              context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].disputeInfo.remarks,
                                              style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff8A8D8E)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.by.isEmpty
                                        ? const SizedBox()
                                        : SizedBox(width: getIt<Functions>().getWidgetWidth(width: 28)),
                                    context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.by.isEmpty
                                        ? const SizedBox()
                                        : Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: getIt<Functions>().getWidgetHeight(height: 40),
                                                  margin: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 20)),
                                                  padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xffE0E7EC)),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.resolution.toUpperCase(),
                                                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                                Padding(
                                                  padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 20)),
                                                  child: Text(
                                                    getIt<Variables>().generalVariables.currentLanguage.resolvedBy.toUpperCase(),
                                                    style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w400, color: const Color(0xff6F6F6F)),
                                                  ),
                                                ),
                                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                                Container(
                                                  height: getIt<Functions>().getWidgetHeight(height: 78),
                                                  margin: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 20)),
                                                  padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xffffffff)),
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
                                                              image: NetworkImage(context
                                                                      .read<DisputeMainBloc>()
                                                                      .disputeMainResponse
                                                                      .disputeList[context.read<DisputeMainBloc>().selectedIndex]
                                                                      .resolutionInfo
                                                                      .by
                                                                      .isNotEmpty
                                                                  ? context
                                                                      .read<DisputeMainBloc>()
                                                                      .disputeMainResponse
                                                                      .disputeList[context.read<DisputeMainBloc>().selectedIndex]
                                                                      .resolutionInfo
                                                                      .by
                                                                      .first
                                                                      .image
                                                                  : ""),
                                                              fit: BoxFit.fill,
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        width: getIt<Functions>().getWidgetWidth(width: 10),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.by.isNotEmpty
                                                                ? context
                                                                    .read<DisputeMainBloc>()
                                                                    .disputeMainResponse
                                                                    .disputeList[context.read<DisputeMainBloc>().selectedIndex]
                                                                    .resolutionInfo
                                                                    .by
                                                                    .first
                                                                    .name
                                                                : "",
                                                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 16), color: const Color(0xff282F3A)),
                                                          ),
                                                          Text(
                                                            "${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.by.isNotEmpty ? context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.by.first.employeeType : ""}  |  ${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.on}",
                                                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: const Color(0xff007AFF)),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 28)),
                                                Padding(
                                                  padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 20)),
                                                  child: Text(
                                                    context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.reason,
                                                    style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 26), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                                  ),
                                                ),
                                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                                Container(
                                                  width: double.infinity,
                                                  margin: EdgeInsets.only(
                                                      right:  getIt<Functions>().getWidgetWidth(width: 20)),
                                                  padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20), vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xffE0E7EC))),
                                                  child: Text(
                                                    context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.remarks,
                                                    style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff8A8D8E)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
                                context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolveAction ||
                                        context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].reassignAction
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].reassignAction
                                              ? SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12))
                                              : const SizedBox(),
                                          context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].reassignAction
                                              ? ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0xffE0E7EC),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    minimumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                                    maximumSize: Size(getIt<Functions>().getWidgetWidth(width: 250), getIt<Functions>().getWidgetHeight(height: 50)),
                                                  ),
                                                  onPressed: () {
                                                    reasonSearchFieldController.clear();
                                                    selectedReason = "";
                                                    commentsBar.clear();
                                                    getIt<Variables>().generalVariables.popUpWidget = resolvedContent(type: 'reassign');
                                                    getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                                  },
                                                  child: FittedBox(
                                                    child: Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.reassigned.toUpperCase(),
                                                      style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 16), fontWeight: FontWeight.w500, color: const Color(0xff8A8D8E)),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                          context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolveAction
                                              ? SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12))
                                              : const SizedBox(),
                                          context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolveAction
                                              ? ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0xff007838),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    minimumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                                    maximumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                                  ),
                                                  onPressed: () {
                                                    reasonSearchFieldController.clear();
                                                    selectedReason = "";
                                                    commentsBar.clear();
                                                    getIt<Variables>().generalVariables.popUpWidget = resolvedContent(type: 'resolution');
                                                    getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                                  },
                                                  child: FittedBox(
                                                    child: Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.resolved.toUpperCase(),
                                                      style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 16), fontWeight: FontWeight.w500, color: const Color(0xffffffff)),
                                                    ),
                                                  ))
                                              : const SizedBox(),
                                        ],
                                      )
                                    : Center(
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xff007838),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              minimumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                              maximumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                            ),
                                            onPressed: () {
                                              getIt<Variables>().generalVariables.indexName =
                                                  getIt<Variables>().generalVariables.disputeRouteList[getIt<Variables>().generalVariables.disputeRouteList.length - 1];
                                              context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                              getIt<Variables>().generalVariables.disputeRouteList.removeAt(getIt<Variables>().generalVariables.disputeRouteList.length - 1);
                                            },
                                            child: FittedBox(
                                              child: Text(
                                                getIt<Variables>().generalVariables.currentLanguage.goToBack.toUpperCase(),
                                                style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 16), fontWeight: FontWeight.w500, color: const Color(0xffffffff)),
                                              ),
                                            )),
                                      ),
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
                              ],
                            ),
                          ),
                        );
                      }
                      else if (state is DisputeMainLoading) {
                        return Expanded(
                          child: SingleChildScrollView(
                            child: Skeletonizer(
                              enabled: true,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 30)),
                                  Container(
                                    height: getIt<Functions>().getWidgetHeight(height: 40),
                                    margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                    padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xffE0E7EC)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: getIt<Functions>().getWidgetWidth(width: 75),
                                          child: Text(
                                            getIt<Variables>().generalVariables.currentLanguage.batch.toUpperCase(),
                                            style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: getIt<Functions>().getWidgetWidth(width: 75),
                                          child: Text(
                                            getIt<Variables>().generalVariables.currentLanguage.stockType,
                                            style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: getIt<Functions>().getWidgetWidth(width: 90),
                                          child: Text(
                                            getIt<Variables>().generalVariables.currentLanguage.requiredQty,
                                            style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: getIt<Functions>().getWidgetWidth(width: 90),
                                          child: Text(
                                            getIt<Variables>().generalVariables.currentLanguage.disputeQty,
                                            style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                  SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 125),
                                      child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          physics: const ScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: 4,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Container(
                                              height: getIt<Functions>().getWidgetHeight(height: 30),
                                              margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: getIt<Functions>().getWidgetWidth(width: 75),
                                                    child: Text(
                                                      "A1091373",
                                                      style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff282F3A)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: getIt<Functions>().getWidgetWidth(width: 75),
                                                    child: Text(
                                                      "Long Date",
                                                      style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff282F3A)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: getIt<Functions>().getWidgetWidth(width: 90),
                                                    child: Center(
                                                      child: Text(
                                                        "13",
                                                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff282F3A)),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: getIt<Functions>().getWidgetWidth(width: 90),
                                                    child: Center(
                                                      child: Text(
                                                        "13",
                                                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff282F3A)),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          })),
                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: getIt<Functions>().getWidgetHeight(height: 40),
                                              margin: EdgeInsets.only(
                                                  left: getIt<Functions>().getWidgetWidth(width: 20),
                                                  right: getIt<Variables>().generalVariables.disputeTab == "yet_to_resolve" ? getIt<Functions>().getWidgetWidth(width: 20) : 0),
                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xffE0E7EC)),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    getIt<Variables>().generalVariables.currentLanguage.disputeInfo.toUpperCase(),
                                                    style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: getIt<Functions>().getWidgetWidth(width: 20),
                                                  right: getIt<Variables>().generalVariables.disputeTab == "yet_to_resolve" ? getIt<Functions>().getWidgetWidth(width: 20) : 0),
                                              child: Text(
                                                getIt<Variables>().generalVariables.currentLanguage.raisedBy.toUpperCase(),
                                                style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w400, color: const Color(0xff6F6F6F)),
                                              ),
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                            Container(
                                              height: getIt<Functions>().getWidgetHeight(height: 78),
                                              margin: EdgeInsets.only(
                                                  left: getIt<Functions>().getWidgetWidth(width: 20),
                                                  right: getIt<Variables>().generalVariables.disputeTab == "yet_to_resolve" ? getIt<Functions>().getWidgetWidth(width: 20) : 0),
                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xffffffff)),
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
                                                          image: NetworkImage("https://images.pexels.com/photos/2899097/pexels-photo-2899097.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                                                          fit: BoxFit.fill,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    width: getIt<Functions>().getWidgetWidth(width: 10),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "John Matthew ",
                                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 16), color: const Color(0xff282F3A)),
                                                      ),
                                                      Text(
                                                        "SORTER  |  19/05/2024, 10:37 AM",
                                                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: const Color(0xff007AFF)),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 28)),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: getIt<Functions>().getWidgetWidth(width: 20),
                                                  right: getIt<Variables>().generalVariables.disputeTab == "yet_to_resolve" ? getIt<Functions>().getWidgetWidth(width: 20) : 0),
                                              child: Text(
                                                "Unavailable at Location",
                                                style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 26), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                              ),
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: getIt<Functions>().getWidgetWidth(width: 20),
                                                  right: getIt<Variables>().generalVariables.disputeTab == "yet_to_resolve" ? getIt<Functions>().getWidgetWidth(width: 20) : 0),
                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20), vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xffE0E7EC))),
                                              child: Text(
                                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                                                style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff8A8D8E)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      getIt<Variables>().generalVariables.disputeTab == "yet_to_resolve" ? const SizedBox() : SizedBox(width: getIt<Functions>().getWidgetWidth(width: 28)),
                                      getIt<Variables>().generalVariables.disputeTab == "yet_to_resolve"
                                          ? const SizedBox()
                                          : Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: getIt<Functions>().getWidgetHeight(height: 40),
                                                    margin: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 20)),
                                                    padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xffE0E7EC)),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          getIt<Variables>().generalVariables.currentLanguage.resolution.toUpperCase(),
                                                          style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                                  Padding(
                                                    padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 20)),
                                                    child: Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.resolvedBy.toUpperCase(),
                                                      style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w400, color: const Color(0xff6F6F6F)),
                                                    ),
                                                  ),
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                                  Container(
                                                    height: getIt<Functions>().getWidgetHeight(height: 78),
                                                    margin: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 20)),
                                                    padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xffffffff)),
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
                                                                image: NetworkImage("https://images.pexels.com/photos/2899097/pexels-photo-2899097.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                                                                fit: BoxFit.fill,
                                                              )),
                                                        ),
                                                        SizedBox(
                                                          width: getIt<Functions>().getWidgetWidth(width: 10),
                                                        ),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "John Smith ",
                                                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 16), color: const Color(0xff282F3A)),
                                                            ),
                                                            Text(
                                                              "STORE KEEPER  |  19/05/2024, 12:12 PM",
                                                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: const Color(0xff007AFF)),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 28)),
                                                  Padding(
                                                    padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 20)),
                                                    child: Text(
                                                      "Item at the place",
                                                      style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 26), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                                    ),
                                                  ),
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                                  Container(
                                                    margin: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 20)),
                                                    padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20), vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xffE0E7EC))),
                                                    child: Text(
                                                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                                                      style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff8A8D8E)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
                                  getIt<Variables>().generalVariables.disputeTab == "yet_to_resolve"
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xffE0E7EC),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                minimumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                                maximumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                              ),
                                              onPressed: () {
                                                getIt<Variables>().generalVariables.indexName =
                                                    getIt<Variables>().generalVariables.disputeRouteList[getIt<Variables>().generalVariables.disputeRouteList.length - 1];
                                                context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                                getIt<Variables>().generalVariables.disputeRouteList.removeAt(getIt<Variables>().generalVariables.disputeRouteList.length - 1);
                                              },
                                              child: Text(
                                                getIt<Variables>().generalVariables.currentLanguage.cancel.toUpperCase(),
                                                style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff8A8D8E)),
                                              ),
                                            ),
                                            SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xff007838),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  minimumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                                  maximumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                                ),
                                                onPressed: () {},
                                                child: Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.resolved.toUpperCase(),
                                                  style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xffffffff)),
                                                )),
                                          ],
                                        )
                                      : Center(
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xff007838),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                minimumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                                maximumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                              ),
                                              onPressed: () {
                                                getIt<Variables>().generalVariables.indexName =
                                                    getIt<Variables>().generalVariables.disputeRouteList[getIt<Variables>().generalVariables.disputeRouteList.length - 1];
                                                context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                                getIt<Variables>().generalVariables.disputeRouteList.removeAt(getIt<Variables>().generalVariables.disputeRouteList.length - 1);
                                              },
                                              child: Text(
                                                getIt<Variables>().generalVariables.currentLanguage.goToBack.toUpperCase(),
                                                style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xffffffff)),
                                              )),
                                        ),
                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      else {
                        return const SizedBox();
                      }
                    }),
              ],
            ),
          );
        }
        else {
          return Container(
            color: const Color(0xffEEF4FF),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: 269),
                  width: getIt<Variables>().generalVariables.width,
                  child: AppBar(
                    backgroundColor: const Color(0xff1D2736),
                    automaticallyImplyLeading: false,
                    title: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            getIt<Variables>().generalVariables.indexName = getIt<Variables>().generalVariables.disputeRouteList[getIt<Variables>().generalVariables.disputeRouteList.length - 1];
                            context.read<NavigationBloc>().add(const NavigationInitialEvent());
                            getIt<Variables>().generalVariables.disputeRouteList.removeAt(getIt<Variables>().generalVariables.disputeRouteList.length - 1);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Color(0xffffffff),
                          ),
                        ),
                        SizedBox(
                          width: getIt<Functions>().getWidgetWidth(width: 20),
                        ),
                        Text(
                          "${getIt<Variables>().generalVariables.currentLanguage.dispute}  #: ${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].disputeNum}",
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: getIt<Functions>().getTextSize(fontSize: 22), color: const Color(0xffffffff)),
                        ),
                      ],
                    ),
                    bottom: PreferredSize(
                      preferredSize: Size(
                          getIt<Functions>().getWidgetWidth(
                              width: Orientation.portrait == MediaQuery.of(context).orientation ? getIt<Variables>().generalVariables.width : getIt<Variables>().generalVariables.height),
                          getIt<Functions>().getWidgetHeight(height: 173)),
                      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 16)),
                        Container(
                          height: getIt<Functions>().getWidgetHeight(height: 80),
                          margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 16)),
                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12), vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                          decoration: BoxDecoration(color: const Color(0xffFFFFFF).withOpacity(0.36), borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: getIt<Functions>().getWidgetHeight(height: 44),
                                      width: getIt<Functions>().getWidgetWidth(width: 44),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(int.parse('0xFF${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].itemColor}'))),
                                      child: Center(
                                        child: Text(
                                          context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].itemType,
                                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 28), color: const Color(0xffffffff)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: getIt<Functions>().getWidgetWidth(width: 10),
                                    ),
                                    Flexible(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].itemName,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xffffffff), overflow: TextOverflow.ellipsis),
                                            ),
                                          ),
                                          Text(
                                            "${getIt<Variables>().generalVariables.currentLanguage.itemCode.toUpperCase()} : ${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].itemCode}",
                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 11), color: const Color(0xffffffff)),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
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
                                    context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].quantity,
                                    style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 24), fontWeight: FontWeight.w600, color: const Color(0xffFFFFFF)),
                                  ),
                                  Text(
                                    getIt<Variables>().generalVariables.currentLanguage.qty.toUpperCase(),
                                    style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 11), fontWeight: FontWeight.w500, color: const Color(0xffffffff)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 16)),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 16)),
                          height: getIt<Functions>().getWidgetHeight(height: 40),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getIt<Variables>().generalVariables.currentLanguage.picklist.toUpperCase(),
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 11), color: const Color(0xffffffff)),
                                  ),
                                  Text(
                                    context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].picklistNum,
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 11), color: const Color(0xff50D464)),
                                  ),
                                ],
                              ),
                              SizedBox(width: getIt<Functions>().getWidgetWidth(width: 40)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${getIt<Variables>().generalVariables.currentLanguage.so.toUpperCase()} #",
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 11), color: const Color(0xffffffff)),
                                  ),
                                  Text(
                                    context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].soNum,
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 11), color: const Color(0xff50D464)),
                                  ),
                                ],
                              ),
                              SizedBox(width: getIt<Functions>().getWidgetWidth(width: 40)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].locationType.toUpperCase(),
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 11), color: const Color(0xffffffff)),
                                  ),
                                  Text(
                                    context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].location,
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 11), color: const Color(0xff50D464)),
                                  ),
                                ],
                              ),
                              SizedBox(width: getIt<Functions>().getWidgetWidth(width: 40)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getIt<Variables>().generalVariables.currentLanguage.dateAndTime.toUpperCase(),
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 11), color: const Color(0xffffffff)),
                                  ),
                                  Text(
                                    context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].created,
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: getIt<Functions>().getTextSize(fontSize: 11), color: const Color(0xff50D464)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 16)),
                      ]),
                    ),
                    actions: const [SizedBox()],
                  ),
                ),
                BlocConsumer<DisputeMainBloc, DisputeMainState>(
                    listenWhen: (DisputeMainState previous, DisputeMainState current) {
                      return previous != current;
                    },
                    buildWhen: (DisputeMainState previous, DisputeMainState current) {
                      return previous != current;
                    },
                    listener: (BuildContext context, DisputeMainState state) {},
                    builder: (BuildContext context, DisputeMainState state) {
                      if (state is DisputeMainLoaded) {
                        return Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                Container(
                                  height: getIt<Functions>().getWidgetHeight(height: 40),
                                  margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                  padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: const Color(0xffE0E7EC)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.batch.toUpperCase(),
                                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                      ),
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.stockType,
                                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                      ),
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.reqQty,
                                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                      ),
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.disputeQty,
                                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                SizedBox(
                                    child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        physics: const ScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].batchInfo.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Container(
                                            height: getIt<Functions>().getWidgetHeight(height: 30),
                                            margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                                    child: Text(
                                                      context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].batchInfo[index].batchNum,
                                                      style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                        fontWeight: FontWeight.w500,
                                                        color: const Color(0xff282F3A),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                                    child: Center(
                                                      child: Text(
                                                        context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].batchInfo[index].stockType,
                                                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w500, color: const Color(0xff282F3A)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                                    child: Center(
                                                      child: Text(
                                                        context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].batchInfo[index].quantity,
                                                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w500, color: const Color(0xff282F3A)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                                    child: Center(
                                                      child: Text(
                                                        context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].batchInfo[index].disputeQty,
                                                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w500, color: const Color(0xff282F3A)),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        })),
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 30)),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: getIt<Functions>().getWidgetHeight(height: 40),
                                            margin: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 12), right: getIt<Functions>().getWidgetWidth(width: 12)),
                                            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: const Color(0xffE0E7EC)),
                                            child: Row(
                                              children: [
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.disputeInfo.toUpperCase(),
                                                  style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 18)),
                                          Padding(
                                            padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 12), right: getIt<Functions>().getWidgetWidth(width: 20)),
                                            child: Text(
                                              getIt<Variables>().generalVariables.currentLanguage.raisedBy.toUpperCase(),
                                              style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w400, color: const Color(0xff6F6F6F)),
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
                                          Container(
                                            height: getIt<Functions>().getWidgetHeight(height: 78),
                                            margin: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 12), right: getIt<Functions>().getWidgetWidth(width: 12)),
                                            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: const Color(0xffffffff)),
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
                                                        image: NetworkImage(context
                                                                .read<DisputeMainBloc>()
                                                                .disputeMainResponse
                                                                .disputeList[context.read<DisputeMainBloc>().selectedIndex]
                                                                .disputeInfo
                                                                .by
                                                                .isNotEmpty
                                                            ? context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].disputeInfo.by.first.image
                                                            : ""),
                                                        fit: BoxFit.fill,
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: getIt<Functions>().getWidgetWidth(width: 10),
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].disputeInfo.by.isNotEmpty
                                                          ? context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].disputeInfo.by.first.name
                                                          : "",
                                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 16), color: const Color(0xff282F3A)),
                                                    ),
                                                    Text(
                                                      "${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].disputeInfo.by.isNotEmpty ? context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].disputeInfo.by.first.employeeType : ""}  |  ${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].disputeInfo.on}",
                                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: const Color(0xff007AFF)),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 30)),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: getIt<Functions>().getWidgetWidth(width: 12),
                                                right: context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].disputeInfo.by.isEmpty
                                                    ? getIt<Functions>().getWidgetWidth(width: 12)
                                                    : 0),
                                            child: Text(
                                              context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].disputeInfo.reason,
                                              style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 22), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                          Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 12), right: getIt<Functions>().getWidgetWidth(width: 12)),
                                            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12), vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xffE0E7EC))),
                                            child: Text(
                                              context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].disputeInfo.remarks,
                                              style: TextStyle(
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xff8A8D8E),
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                          SizedBox(height: getIt<Functions>().getWidgetHeight(height: 25)),
                                          context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.by.isEmpty
                                              ? const SizedBox()
                                              : SizedBox(width: getIt<Functions>().getWidgetWidth(width: 28)),
                                          context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.by.isEmpty
                                              ? const SizedBox()
                                              : Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: getIt<Functions>().getWidgetHeight(height: 40),
                                                      margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: const Color(0xffE0E7EC)),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            getIt<Variables>().generalVariables.currentLanguage.resolution.toUpperCase(),
                                                            style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 18)),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      child: Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.resolvedBy.toUpperCase(),
                                                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w400, color: const Color(0xff6F6F6F)),
                                                      ),
                                                    ),
                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                                    Container(
                                                      height: getIt<Functions>().getWidgetHeight(height: 78),
                                                      margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: const Color(0xffffffff)),
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
                                                                  image: NetworkImage(context
                                                                          .read<DisputeMainBloc>()
                                                                          .disputeMainResponse
                                                                          .disputeList[context.read<DisputeMainBloc>().selectedIndex]
                                                                          .resolutionInfo
                                                                          .by
                                                                          .isEmpty
                                                                      ? ""
                                                                      : context
                                                                          .read<DisputeMainBloc>()
                                                                          .disputeMainResponse
                                                                          .disputeList[context.read<DisputeMainBloc>().selectedIndex]
                                                                          .resolutionInfo
                                                                          .by
                                                                          .first
                                                                          .image),
                                                                  fit: BoxFit.fill,
                                                                )),
                                                          ),
                                                          SizedBox(
                                                            width: getIt<Functions>().getWidgetWidth(width: 10),
                                                          ),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.by.isEmpty
                                                                    ? ""
                                                                    : context
                                                                        .read<DisputeMainBloc>()
                                                                        .disputeMainResponse
                                                                        .disputeList[context.read<DisputeMainBloc>().selectedIndex]
                                                                        .resolutionInfo
                                                                        .by
                                                                        .first
                                                                        .name,
                                                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 16), color: const Color(0xff282F3A)),
                                                              ),
                                                              Text(
                                                                "${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.by.isEmpty ? "" : context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.by.first.employeeType}  |  ${context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.by.isEmpty ? "" : context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.on}",
                                                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: const Color(0xff007AFF)),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 28)),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      child: Text(
                                                        context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.by.isEmpty
                                                            ? ""
                                                            : context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.reason,
                                                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 22), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                                      ),
                                                    ),
                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                                    Container(
                                                      margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12), vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xffE0E7EC))),
                                                      child: Text(
                                                        context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.by.isEmpty
                                                            ? ""
                                                            : context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolutionInfo.remarks,
                                                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff8A8D8E)),
                                                        textAlign: TextAlign.justify,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
                                context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolveAction ||
                                        context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].reassignAction
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].reassignAction
                                              ? SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12))
                                              : const SizedBox(),
                                          context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].reassignAction
                                              ? ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0xffE0E7EC),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    minimumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                                    maximumSize: Size(getIt<Functions>().getWidgetWidth(width: 250), getIt<Functions>().getWidgetHeight(height: 50)),
                                                  ),
                                                  onPressed: () {
                                                    reasonSearchFieldController.clear();
                                                    selectedReason = "";
                                                    commentsBar.clear();
                                                    getIt<Variables>().generalVariables.popUpWidget = resolvedContent(type: "reassign");
                                                    getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                                  },
                                                  child: FittedBox(
                                                    child: Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.reassigned.toUpperCase(),
                                                      style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff8A8D8E)),
                                                    ),
                                                  ))
                                              : const SizedBox(),
                                          context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolveAction
                                              ? SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12))
                                              : const SizedBox(),
                                          context.read<DisputeMainBloc>().disputeMainResponse.disputeList[context.read<DisputeMainBloc>().selectedIndex].resolveAction
                                              ? ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0xff007838),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    minimumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                                    maximumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                                  ),
                                                  onPressed: () {
                                                    reasonSearchFieldController.clear();
                                                    selectedReason = "";
                                                    commentsBar.clear();
                                                    getIt<Variables>().generalVariables.popUpWidget = resolvedContent(type: "resolution");
                                                    getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                                  },
                                                  child: FittedBox(
                                                    child: Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.resolved.toUpperCase(),
                                                      style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xffffffff)),
                                                    ),
                                                  ))
                                              : const SizedBox(),
                                        ],
                                      )
                                    : Center(
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xff007838),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              minimumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                              maximumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                            ),
                                            onPressed: () {
                                              getIt<Variables>().generalVariables.indexName =
                                                  getIt<Variables>().generalVariables.disputeRouteList[getIt<Variables>().generalVariables.disputeRouteList.length - 1];
                                              context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                              getIt<Variables>().generalVariables.disputeRouteList.removeAt(getIt<Variables>().generalVariables.disputeRouteList.length - 1);
                                            },
                                            child: FittedBox(
                                              child: Text(
                                                getIt<Variables>().generalVariables.currentLanguage.goToBack.toUpperCase(),
                                                style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xffffffff)),
                                              ),
                                            )),
                                      ),
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
                              ],
                            ),
                          ),
                        );
                      } 
                      else if (state is DisputeMainLoading) {
                        return Expanded(
                          child: SingleChildScrollView(
                            child: Skeletonizer(
                              enabled: true,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                  Container(
                                    height: getIt<Functions>().getWidgetHeight(height: 40),
                                    margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                    padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: const Color(0xffE0E7EC)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: getIt<Functions>().getWidgetWidth(width: 75),
                                          child: Text(
                                            getIt<Variables>().generalVariables.currentLanguage.batch.toUpperCase(),
                                            style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: getIt<Functions>().getWidgetWidth(width: 75),
                                          child: Text(
                                            getIt<Variables>().generalVariables.currentLanguage.stockType,
                                            style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: getIt<Functions>().getWidgetWidth(width: 75),
                                          child: Text(
                                            getIt<Variables>().generalVariables.currentLanguage.reqQty,
                                            style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: getIt<Functions>().getWidgetWidth(width: 90),
                                          child: Text(
                                            getIt<Variables>().generalVariables.currentLanguage.disputeQty,
                                            style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                  SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 125),
                                      child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          physics: const ScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: 4,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Container(
                                              height: getIt<Functions>().getWidgetHeight(height: 30),
                                              margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: getIt<Functions>().getWidgetWidth(width: 75),
                                                    child: Text(
                                                      "A1091373",
                                                      style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                        fontWeight: FontWeight.w500,
                                                        color: const Color(0xff282F3A),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: getIt<Functions>().getWidgetWidth(width: 75),
                                                    child: Text(
                                                      "Long Date",
                                                      style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w500, color: const Color(0xff282F3A)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: getIt<Functions>().getWidgetWidth(width: 75),
                                                    child: Text(
                                                      "13",
                                                      style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w500, color: const Color(0xff282F3A)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: getIt<Functions>().getWidgetWidth(width: 90),
                                                    child: Text(
                                                      "13",
                                                      style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w500, color: const Color(0xff282F3A)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          })),
                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 30)),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: getIt<Functions>().getWidgetHeight(height: 40),
                                              margin: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 12), right: getIt<Functions>().getWidgetWidth(width: 12)),
                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: const Color(0xffE0E7EC)),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    getIt<Variables>().generalVariables.currentLanguage.disputeInfo.toUpperCase(),
                                                    style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 18)),
                                            Padding(
                                              padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 12), right: getIt<Functions>().getWidgetWidth(width: 20)),
                                              child: Text(
                                                getIt<Variables>().generalVariables.currentLanguage.raisedBy.toUpperCase(),
                                                style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w400, color: const Color(0xff6F6F6F)),
                                              ),
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
                                            Container(
                                              height: getIt<Functions>().getWidgetHeight(height: 78),
                                              margin: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 12), right: getIt<Functions>().getWidgetWidth(width: 12)),
                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: const Color(0xffffffff)),
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
                                                          image: NetworkImage("https://images.pexels.com/photos/2899097/pexels-photo-2899097.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                                                          fit: BoxFit.fill,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    width: getIt<Functions>().getWidgetWidth(width: 10),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "John Matthew ",
                                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 16), color: const Color(0xff282F3A)),
                                                      ),
                                                      Text(
                                                        "SORTER  |  19/05/2024, 10:37 AM",
                                                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: const Color(0xff007AFF)),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 30)),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: getIt<Functions>().getWidgetWidth(width: 12),
                                                  right: getIt<Variables>().generalVariables.disputeTab == "yet_to_resolve" ? getIt<Functions>().getWidgetWidth(width: 12) : 0),
                                              child: Text(
                                                "Unavailable at Location",
                                                style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 22), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                              ),
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                            Container(
                                              margin: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 12), right: getIt<Functions>().getWidgetWidth(width: 12)),
                                              padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12), vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xffE0E7EC))),
                                              child: Text(
                                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                                                style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color(0xff8A8D8E),
                                                ),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 25)),
                                            getIt<Variables>().generalVariables.disputeTab == "yet_to_resolve" ? const SizedBox() : SizedBox(width: getIt<Functions>().getWidgetWidth(width: 28)),
                                            getIt<Variables>().generalVariables.disputeTab == "yet_to_resolve"
                                                ? const SizedBox()
                                                : Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: getIt<Functions>().getWidgetHeight(height: 40),
                                                        margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                        padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: const Color(0xffE0E7EC)),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              getIt<Variables>().generalVariables.currentLanguage.resolution.toUpperCase(),
                                                              style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 18)),
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                        child: Text(
                                                          getIt<Variables>().generalVariables.currentLanguage.resolvedBy.toUpperCase(),
                                                          style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w400, color: const Color(0xff6F6F6F)),
                                                        ),
                                                      ),
                                                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
                                                      Container(
                                                        height: getIt<Functions>().getWidgetHeight(height: 78),
                                                        margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                        padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: const Color(0xffffffff)),
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
                                                                    image: NetworkImage("https://images.pexels.com/photos/2899097/pexels-photo-2899097.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                                                                    fit: BoxFit.fill,
                                                                  )),
                                                            ),
                                                            SizedBox(
                                                              width: getIt<Functions>().getWidgetWidth(width: 10),
                                                            ),
                                                            Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  "John Smith ",
                                                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 16), color: const Color(0xff282F3A)),
                                                                ),
                                                                Text(
                                                                  "STORE KEEPER  |  19/05/2024, 12:12 PM",
                                                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 12), color: const Color(0xff007AFF)),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 28)),
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                        child: Text(
                                                          "Item at the place",
                                                          style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 22), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
                                                        ),
                                                      ),
                                                      SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                                      Container(
                                                        margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                        padding:
                                                            EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12), vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xffE0E7EC))),
                                                        child: Text(
                                                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                                                          style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff8A8D8E)),
                                                          textAlign: TextAlign.justify,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
                                  getIt<Variables>().generalVariables.disputeTab == "yet_to_resolve"
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xffE0E7EC),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                minimumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                                maximumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                              ),
                                              onPressed: () {
                                                getIt<Variables>().generalVariables.indexName =
                                                    getIt<Variables>().generalVariables.disputeRouteList[getIt<Variables>().generalVariables.disputeRouteList.length - 1];
                                                context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                                getIt<Variables>().generalVariables.disputeRouteList.removeAt(getIt<Variables>().generalVariables.disputeRouteList.length - 1);
                                              },
                                              child: Text(
                                                getIt<Variables>().generalVariables.currentLanguage.cancel.toUpperCase(),
                                                style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff8A8D8E)),
                                              ),
                                            ),
                                            SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xff007838),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  minimumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                                  maximumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                                ),
                                                onPressed: () {},
                                                child: Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.resolved.toUpperCase(),
                                                  style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xffffffff)),
                                                )),
                                          ],
                                        )
                                      : Center(
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xff007838),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                minimumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                                maximumSize: Size(getIt<Functions>().getWidgetWidth(width: 181), getIt<Functions>().getWidgetHeight(height: 50)),
                                              ),
                                              onPressed: () {
                                                getIt<Variables>().generalVariables.indexName =
                                                    getIt<Variables>().generalVariables.disputeRouteList[getIt<Variables>().generalVariables.disputeRouteList.length - 1];
                                                context.read<NavigationBloc>().add(const NavigationInitialEvent());
                                                getIt<Variables>().generalVariables.disputeRouteList.removeAt(getIt<Variables>().generalVariables.disputeRouteList.length - 1);
                                              },
                                              child: Text(
                                                getIt<Variables>().generalVariables.currentLanguage.goToBack.toUpperCase(),
                                                style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xffffffff)),
                                              )),
                                        ),
                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
                                ],
                              ),
                            ),
                          ),
                        );
                      } 
                      else {
                        return const SizedBox();
                      }
                    }),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget resolvedContent({required String type}) {
    reasonSearchFieldController.clear();
    context.read<DisputeMainBloc>().selectedReason = "";
    commentsBar.clear();
    context.read<DisputeMainBloc>().updateLoader = false;
    context.read<DisputeMainBloc>().commentTextEmpty = false;
    context.read<DisputeMainBloc>().selectedReasonEmpty = false;
    context.read<DisputeMainBloc>().hideKeyBoardReason = false;
    return BlocConsumer<DisputeMainBloc, DisputeMainState>(
      buildWhen: (DisputeMainState previous, DisputeMainState current) {
        return previous != current;
      },
      listenWhen: (DisputeMainState previous, DisputeMainState current) {
        return previous != current;
      },
      listener: (BuildContext context, DisputeMainState state) {
        if (state is DisputeMainSuccess) {
          context.read<DisputeMainBloc>().updateLoader = false;
          Navigator.pop(context);
          context.read<DisputeMainBloc>().add(const DisputeMainSetStateEvent());
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is DisputeMainFailure) {
          context.read<DisputeMainBloc>().updateLoader = false;
          context.read<DisputeMainBloc>().add(const DisputeMainSetStateEvent());
        }
        if (state is DisputeMainError) {
          context.read<DisputeMainBloc>().updateLoader = false;
          ScaffoldMessenger.of(context).clearSnackBars();
          getIt<Widgets>().flushBarWidget(context: context, message: state.message);
        }
      },
      builder: (BuildContext context, DisputeMainState state) {
        return SizedBox(
          width: getIt<Functions>().getWidgetWidth(width: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                child: Text(
                  type == "resolution" ? getIt<Variables>().generalVariables.currentLanguage.resolution.toUpperCase() : getIt<Variables>().generalVariables.currentLanguage.reassigned.toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 26 : 24), color: const Color(0xff282F3A)),
                ),
              ),
              SizedBox(
                height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 24 : 20),
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
                      height: getIt<Functions>().getWidgetHeight(height: 18),
                    ),
                    SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 75),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getIt<Variables>().generalVariables.currentLanguage.reason,
                            style: TextStyle(color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 45),
                            child: buildDropButton(type: type),
                          )
                        ],
                      ),
                    ),
                    context.read<DisputeMainBloc>().selectedReasonEmpty
                        ? Text(
                            getIt<Variables>().generalVariables.currentLanguage.pleaseSelectReason,
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 10)),
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 12),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getIt<Variables>().generalVariables.currentLanguage.comments,
                          style: TextStyle(color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                        ),
                        SizedBox(
                          height: getIt<Functions>().getWidgetHeight(height: 13),
                        ),
                        TextFormField(
                          controller: commentsBar,
                          onChanged: (value) {
                            context.read<DisputeMainBloc>().commentTextEmpty = value.isEmpty ? true : false;
                            context.read<DisputeMainBloc>().commentText = value.isEmpty ? "" : value;
                            context.read<DisputeMainBloc>().add(const DisputeMainSetStateEvent());
                          },
                          maxLines: 3,
                          decoration: InputDecoration(
                            fillColor: const Color(0xffffffff),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 15), vertical: getIt<Functions>().getWidgetHeight(height: 15)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                            focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                            hintText: getIt<Variables>().generalVariables.currentLanguage.enterComments,
                            hintStyle: TextStyle(
                              color: const Color(0xff8A8D8E),
                              fontWeight: FontWeight.w400,
                              fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                            ),
                          ),
                          validator: (value) => value!.isEmpty ? getIt<Variables>().generalVariables.currentLanguage.pleaseEnterTheComments : null,
                        )
                      ],
                    ),
                    context.read<DisputeMainBloc>().commentTextEmpty
                        ? Text(
                            getIt<Variables>().generalVariables.currentLanguage.pleaseEnterTheComments,
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 10)),
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 30),
                    ),
                  ],
                ),
              ),
              context.read<DisputeMainBloc>().updateLoader
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
                  : Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              FocusManager.instance.primaryFocus!.unfocus();
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: getIt<Functions>().getWidgetHeight(height: 50),
                              decoration: const BoxDecoration(
                                color: Color(0xffE0E7EC),
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15)),
                              ),
                              child: Center(
                                child: Text(
                                  getIt<Variables>().generalVariables.currentLanguage.cancel.toUpperCase(),
                                  style: TextStyle(
                                      color: const Color(0xff282F3A),
                                      fontWeight: FontWeight.w600,
                                      fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 15 : 13)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (context.read<DisputeMainBloc>().selectedReason == "" || commentsBar.text == "") {
                                if (context.read<DisputeMainBloc>().selectedReason == "") {
                                  context.read<DisputeMainBloc>().selectedReasonEmpty = true;
                                  context.read<DisputeMainBloc>().commentTextEmpty = false;
                                  context.read<DisputeMainBloc>().add(const DisputeMainSetStateEvent());
                                } else if (commentsBar.text == "") {
                                  context.read<DisputeMainBloc>().selectedReasonEmpty = false;
                                  context.read<DisputeMainBloc>().commentTextEmpty = true;
                                  context.read<DisputeMainBloc>().add(const DisputeMainSetStateEvent());
                                } else {}
                              } 
                              else {
                                context.read<DisputeMainBloc>().updateLoader = true;
                                FocusManager.instance.primaryFocus!.unfocus();
                                context.read<DisputeMainBloc>().selectedReasonEmpty = false;
                                context.read<DisputeMainBloc>().commentTextEmpty = false;
                                context.read<DisputeMainBloc>().add(const DisputeMainSetStateEvent());
                                context.read<DisputeMainBloc>().add(DisputeMainUpdateEvent(type: type));
                              }
                            },
                            child: Container(
                              height: getIt<Functions>().getWidgetHeight(height: 50),
                              decoration: const BoxDecoration(
                                color: Color(0xff007838),
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(15)),
                              ),
                              child: Center(
                                child: Text(
                                  getIt<Variables>().generalVariables.currentLanguage.submit.toUpperCase(),
                                  style: TextStyle(
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.w600,
                                      fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 15 : 13)),
                                ),
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

  Widget buildDropButton({required String type}) {
    return Container(
      height: getIt<Functions>().getWidgetHeight(height: 45),
      decoration: BoxDecoration(color: const Color(0xffffffff), borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffE0E7EC), width: 0.73)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: type=="resolution"?changeReason:changeReassign,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  context.read<DisputeMainBloc>().selectedReasonName ?? getIt<Variables>().generalVariables.currentLanguage.chooseReason,
                  style: TextStyle(
                      fontSize: context.read<DisputeMainBloc>().selectedReasonName == null ? 12 : 15,
                      color: context.read<DisputeMainBloc>().selectedReasonName == null ? Colors.grey.shade500 : Colors.black),
                ),
              ),
              context.read<DisputeMainBloc>().selectedReasonName != null
                  ? InkWell(
                  onTap: () {
                    context.read<DisputeMainBloc>().selectedReasonName = null;
                    context.read<DisputeMainBloc>().selectedReasonEmpty = false;
                    context.read<DisputeMainBloc>().selectedReason = "";
                    context.read<DisputeMainBloc>().add(const DisputeMainSetStateEvent(stillLoading: false));
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

   changeReason() async {
    List<Reason> searchReasons = context.read<DisputeMainBloc>().disputeMainResponse.resolveReasons;
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
                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 26), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
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
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        suffixIcon: reasonSearchFieldController.text.isNotEmpty
                            ? IconButton(
                            onPressed: () {
                              reasonSearchFieldController.clear();
                              context.read<DisputeMainBloc>().selectedReasonEmpty = false;
                              context.read<DisputeMainBloc>().selectedReasonName = "";
                              context.read<DisputeMainBloc>().selectedReason = "";
                              context.read<DisputeMainBloc>().add(const DisputeMainSetStateEvent(stillLoading: false));
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
                        hintStyle: TextStyle(color: const Color(0xff8A8D8E), fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                    onChanged: (value) {
                      searchReasons = context.read<DisputeMainBloc>().disputeMainResponse.resolveReasons.where((element) => element.description.toLowerCase().contains(value.toLowerCase())).toList();
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
                          context.read<DisputeMainBloc>().selectedReasonName = searchReasons[index].description;
                          context.read<DisputeMainBloc>().selectedReasonEmpty = false;
                          context.read<DisputeMainBloc>().selectedReason = searchReasons[index].id;
                          context.read<DisputeMainBloc>().add(const DisputeMainSetStateEvent(stillLoading: false));
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

  changeReassign() async {
    List<Reason> searchReasons = context.read<DisputeMainBloc>().disputeMainResponse.reassignReasons;
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
                        style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 26), fontWeight: FontWeight.w600, color: const Color(0xff282F3A)),
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
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xffE0E7EC), width: 0.73)),
                        suffixIcon: reasonSearchFieldController.text.isNotEmpty
                            ? IconButton(
                            onPressed: () {
                              reasonSearchFieldController.clear();
                              context.read<DisputeMainBloc>().selectedReasonEmpty = false;
                              context.read<DisputeMainBloc>().selectedReasonName = "";
                              context.read<DisputeMainBloc>().selectedReason = "";
                              context.read<DisputeMainBloc>().add(const DisputeMainSetStateEvent(stillLoading: false));
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
                        hintStyle: TextStyle(color: const Color(0xff8A8D8E), fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                    onChanged: (value) {
                        searchReasons = context.read<DisputeMainBloc>().disputeMainResponse.reassignReasons.where((element) => element.description.toLowerCase().contains(value.toLowerCase())).toList();
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
                          context.read<DisputeMainBloc>().selectedReasonName = searchReasons[index].description;
                          context.read<DisputeMainBloc>().selectedReasonEmpty = false;
                          context.read<DisputeMainBloc>().selectedReason = searchReasons[index].id;
                          context.read<DisputeMainBloc>().add(const DisputeMainSetStateEvent(stillLoading: false));
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
