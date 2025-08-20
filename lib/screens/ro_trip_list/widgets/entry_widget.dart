// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:oda/bloc/ro_trip_list/ro_trip_list_detail/ro_trip_list_detail_bloc.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/screens/ro_trip_list/widgets/collected_amount_widget.dart';
import 'package:oda/screens/ro_trip_list/widgets/return_items_widget.dart';
import 'package:oda/screens/ro_trip_list/widgets/total_assets_widget.dart';
import 'package:oda/screens/ro_trip_list/widgets/total_expenses_widget.dart';

class EntryWidget extends StatefulWidget {
  static const String id = "entry_widget";
  const EntryWidget({super.key});

  @override
  State<EntryWidget> createState() => _EntryWidgetState();
}

class _EntryWidgetState extends State<EntryWidget> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 480) {
          return SingleChildScrollView(
            child: BlocBuilder<RoTripListDetailBloc, RoTripListDetailState>(
              builder: (BuildContext context, RoTripListDetailState state) {
                if(state is RoTripListDetailLoading){
                  return const SizedBox();
                }else if(state is RoTripListDetailLoaded){
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getIt<Variables>().generalVariables.currentLanguage.tripSummary.toUpperCase()),
                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                        SizedBox(
                          height: getIt<Functions>().getWidgetHeight(height: 110),
                          width: MediaQuery.of(context).orientation == Orientation.landscape
                              ? getIt<Variables>().generalVariables.height
                              : getIt<Variables>().generalVariables.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  context.read<RoTripListDetailBloc>().detailPageId = ReturnItemsWidget.id;
                                  context
                                      .read<RoTripListDetailBloc>()
                                      .add(const RoTripListDetailWidgetChangingEvent(selectedWidget: ReturnItemsWidget.id));
                                },
                                child: Container(
                                  width: (MediaQuery.of(context).orientation == Orientation.landscape
                                      ? getIt<Variables>().generalVariables.height
                                      : getIt<Variables>().generalVariables.width) /
                                      4.5,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: getIt<Functions>().getWidgetWidth(width: 10),
                                      vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/ro_trip_list/total_returns.svg",
                                            height: getIt<Functions>().getWidgetHeight(height: 24),
                                            width: getIt<Functions>().getWidgetWidth(width: 24),
                                            fit: BoxFit.fill,
                                          ),
                                          SvgPicture.asset(
                                            "assets/ro_trip_list/info-circle.svg",
                                            height: getIt<Functions>().getWidgetHeight(height: 16),
                                            width: getIt<Functions>().getWidgetWidth(width: 16),
                                            fit: BoxFit.fill,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        context.read<RoTripListDetailBloc>().roTripDetailModel.response.tripInfo.totalReturnQty.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 24),
                                            color: const Color(0xff282F3A)),
                                      ),
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.totalReturns.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                            color: const Color(0xff282F3A)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer"
                                  ? const SizedBox()
                                  : InkWell(
                                onTap: () {
                                  context.read<RoTripListDetailBloc>().detailPageId = CollectedAmountWidget.id;
                                  context
                                      .read<RoTripListDetailBloc>()
                                      .add(const RoTripListDetailWidgetChangingEvent(selectedWidget: CollectedAmountWidget.id));
                                },
                                child: Container(
                                  width: (MediaQuery.of(context).orientation == Orientation.landscape
                                      ? getIt<Variables>().generalVariables.height
                                      : getIt<Variables>().generalVariables.width) /
                                      4.5,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: getIt<Functions>().getWidgetWidth(width: 10),
                                      vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/ro_trip_list/collected_money.svg",
                                            height: getIt<Functions>().getWidgetHeight(height: 24),
                                            width: getIt<Functions>().getWidgetWidth(width: 24),
                                            fit: BoxFit.fill,
                                          ),
                                          SvgPicture.asset(
                                            "assets/ro_trip_list/info-circle.svg",
                                            height: getIt<Functions>().getWidgetHeight(height: 16),
                                            width: getIt<Functions>().getWidgetWidth(width: 16),
                                            fit: BoxFit.fill,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "RS.${context.read<RoTripListDetailBloc>().roTripDetailModel.response.tripInfo.totalCollectedAmount}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 24),
                                            color: const Color(0xff282F3A)),
                                      ),
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.collectedAmount.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                            color: const Color(0xff282F3A)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer"
                                  ? const SizedBox()
                                  : InkWell(
                                onTap: () {
                                  context.read<RoTripListDetailBloc>().detailPageId = TotalExpensesWidget.id;
                                  context
                                      .read<RoTripListDetailBloc>()
                                      .add(const RoTripListDetailWidgetChangingEvent(selectedWidget: TotalExpensesWidget.id));
                                },
                                child: Container(
                                  width: (MediaQuery.of(context).orientation == Orientation.landscape
                                      ? getIt<Variables>().generalVariables.height
                                      : getIt<Variables>().generalVariables.width) /
                                      4.5,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: getIt<Functions>().getWidgetWidth(width: 10),
                                      vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/ro_trip_list/total_returns.svg",
                                            height: getIt<Functions>().getWidgetHeight(height: 24),
                                            width: getIt<Functions>().getWidgetWidth(width: 24),
                                            fit: BoxFit.fill,
                                          ),
                                          SvgPicture.asset(
                                            "assets/ro_trip_list/green_check.svg",
                                            height: getIt<Functions>().getWidgetHeight(height: 16),
                                            width: getIt<Functions>().getWidgetWidth(width: 16),
                                            fit: BoxFit.fill,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "RS.${context.read<RoTripListDetailBloc>().roTripDetailModel.response.tripInfo.totalExpenseAmount}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 24),
                                            color: const Color(0xff282F3A)),
                                      ),
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.totalExpenses.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                            color: const Color(0xff282F3A)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer"
                                  ? const SizedBox()
                                  : InkWell(
                                onTap: () {
                                  context.read<RoTripListDetailBloc>().detailPageId = TotalAssetsWidget.id;
                                  context
                                      .read<RoTripListDetailBloc>()
                                      .add(const RoTripListDetailWidgetChangingEvent(selectedWidget: TotalAssetsWidget.id));
                                },
                                child: Container(
                                  width: (MediaQuery.of(context).orientation == Orientation.landscape
                                      ? getIt<Variables>().generalVariables.height
                                      : getIt<Variables>().generalVariables.width) /
                                      4.5,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: getIt<Functions>().getWidgetWidth(width: 10),
                                      vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/ro_trip_list/total_returns.svg",
                                            height: getIt<Functions>().getWidgetHeight(height: 24),
                                            width: getIt<Functions>().getWidgetWidth(width: 24),
                                            fit: BoxFit.fill,
                                          ),
                                          SvgPicture.asset(
                                            "assets/ro_trip_list/info-circle.svg",
                                            height: getIt<Functions>().getWidgetHeight(height: 16),
                                            width: getIt<Functions>().getWidgetWidth(width: 16),
                                            fit: BoxFit.fill,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        context.read<RoTripListDetailBloc>().roTripDetailModel.response.tripInfo.totalAssetsQty.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 24),
                                            color: const Color(0xff282F3A)),
                                      ),
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.totalAssets.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                            color: const Color(0xff282F3A)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer"
                            ? const SizedBox()
                            : SizedBox(height: getIt<Functions>().getWidgetHeight(height: 30)),
                        getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer"
                            ? const SizedBox()
                            : Text(getIt<Variables>().generalVariables.currentLanguage.roTripDetails.toUpperCase()),
                        getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer"
                            ? const SizedBox()
                            : SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                        getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer"
                            ? const SizedBox()
                            : Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: getIt<Functions>().getWidgetWidth(width: 16), vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: GridView.builder(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: getIt<Functions>().getWidgetWidth(width: 16),
                                mainAxisSpacing: getIt<Functions>().getWidgetHeight(height: 16),
                                mainAxisExtent: getIt<Functions>().getWidgetHeight(height: 65),
                              ),
                              itemCount: context.read<RoTripListDetailBloc>().selectedData.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: context.read<RoTripListDetailBloc>().selectedData[index].label.toUpperCase(),
                                    labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Color(0xff8A8D8E)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(3.7),
                                        borderSide: BorderSide(color: const Color(0xff282F3A).withOpacity(0.37), width: 0.53)),
                                  ),
                                  child: Text(
                                    context.read<RoTripListDetailBloc>().selectedData[index].name,
                                    style: TextStyle(
                                        fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff282F3A)),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                }else{
                  return const SizedBox();
                }
              },
            ),
          );
        } else {
          return SingleChildScrollView(
            child: BlocBuilder<RoTripListDetailBloc, RoTripListDetailState>(
              builder: (BuildContext context, RoTripListDetailState state) {
                if(state is RoTripListDetailLoading){
                  return const SizedBox();
                }else if(state is RoTripListDetailLoaded){
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getIt<Variables>().generalVariables.currentLanguage.tripSummary.toUpperCase()),
                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                        SizedBox(
                          height: getIt<Functions>().getWidgetHeight(height: 110),
                          width: getIt<Variables>().generalVariables.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  context.read<RoTripListDetailBloc>().detailPageId = ReturnItemsWidget.id;
                                  context
                                      .read<RoTripListDetailBloc>()
                                      .add(const RoTripListDetailWidgetChangingEvent(selectedWidget: ReturnItemsWidget.id));
                                },
                                child: Container(
                                  width: getIt<Variables>().generalVariables.width / 2.2,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: getIt<Functions>().getWidgetWidth(width: 10),
                                      vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/ro_trip_list/total_returns.svg",
                                            height: getIt<Functions>().getWidgetHeight(height: 24),
                                            width: getIt<Functions>().getWidgetWidth(width: 24),
                                            fit: BoxFit.fill,
                                          ),
                                          SvgPicture.asset(
                                            "assets/ro_trip_list/info-circle.svg",
                                            height: getIt<Functions>().getWidgetHeight(height: 16),
                                            width: getIt<Functions>().getWidgetWidth(width: 16),
                                            fit: BoxFit.fill,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        context.read<RoTripListDetailBloc>().roTripDetailModel.response.tripInfo.totalReturnQty.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                            color: const Color(0xff282F3A)),
                                      ),
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.totalReturns.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                            color: const Color(0xff282F3A)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer"
                                  ? const SizedBox()
                                  : InkWell(
                                onTap: () {
                                  context.read<RoTripListDetailBloc>().detailPageId = CollectedAmountWidget.id;
                                  context
                                      .read<RoTripListDetailBloc>()
                                      .add(const RoTripListDetailWidgetChangingEvent(selectedWidget: CollectedAmountWidget.id));
                                },
                                child: Container(
                                  width: getIt<Variables>().generalVariables.width / 2.2,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: getIt<Functions>().getWidgetWidth(width: 10),
                                      vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/ro_trip_list/collected_money.svg",
                                            height: getIt<Functions>().getWidgetHeight(height: 24),
                                            width: getIt<Functions>().getWidgetWidth(width: 24),
                                            fit: BoxFit.fill,
                                          ),
                                          SvgPicture.asset(
                                            "assets/ro_trip_list/info-circle.svg",
                                            height: getIt<Functions>().getWidgetHeight(height: 16),
                                            width: getIt<Functions>().getWidgetWidth(width: 16),
                                            fit: BoxFit.fill,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "RS.${context.read<RoTripListDetailBloc>().roTripDetailModel.response.tripInfo.totalCollectedAmount}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                            color: const Color(0xff282F3A)),
                                      ),
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.collectedAmount.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                            color: const Color(0xff282F3A)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer"
                            ? const SizedBox()
                            : SizedBox(height: getIt<Functions>().getWidgetHeight(height: 15)),
                        getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer"
                            ? const SizedBox()
                            : SizedBox(
                          height: getIt<Functions>().getWidgetHeight(height: 110),
                          width: getIt<Variables>().generalVariables.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  context.read<RoTripListDetailBloc>().detailPageId = TotalExpensesWidget.id;
                                  context
                                      .read<RoTripListDetailBloc>()
                                      .add(const RoTripListDetailWidgetChangingEvent(selectedWidget: TotalExpensesWidget.id));
                                },
                                child: Container(
                                  width: getIt<Variables>().generalVariables.width / 2.2,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: getIt<Functions>().getWidgetWidth(width: 10),
                                      vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/ro_trip_list/total_returns.svg",
                                            height: getIt<Functions>().getWidgetHeight(height: 24),
                                            width: getIt<Functions>().getWidgetWidth(width: 24),
                                            fit: BoxFit.fill,
                                          ),
                                          SvgPicture.asset(
                                            "assets/ro_trip_list/green_check.svg",
                                            height: getIt<Functions>().getWidgetHeight(height: 16),
                                            width: getIt<Functions>().getWidgetWidth(width: 16),
                                            fit: BoxFit.fill,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "RS.${context.read<RoTripListDetailBloc>().roTripDetailModel.response.tripInfo.totalExpenseAmount}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                            color: const Color(0xff282F3A)),
                                      ),
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.totalExpenses.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                            color: const Color(0xff282F3A)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  context.read<RoTripListDetailBloc>().detailPageId = TotalAssetsWidget.id;
                                  context
                                      .read<RoTripListDetailBloc>()
                                      .add(const RoTripListDetailWidgetChangingEvent(selectedWidget: TotalAssetsWidget.id));
                                },
                                child: Container(
                                  width: getIt<Variables>().generalVariables.width / 2.2,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: getIt<Functions>().getWidgetWidth(width: 10),
                                      vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/ro_trip_list/total_returns.svg",
                                            height: getIt<Functions>().getWidgetHeight(height: 24),
                                            width: getIt<Functions>().getWidgetWidth(width: 24),
                                            fit: BoxFit.fill,
                                          ),
                                          SvgPicture.asset(
                                            "assets/ro_trip_list/info-circle.svg",
                                            height: getIt<Functions>().getWidgetHeight(height: 16),
                                            width: getIt<Functions>().getWidgetWidth(width: 16),
                                            fit: BoxFit.fill,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        context.read<RoTripListDetailBloc>().roTripDetailModel.response.tripInfo.totalAssetsQty.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                            color: const Color(0xff282F3A)),
                                      ),
                                      Text(
                                        getIt<Variables>().generalVariables.currentLanguage.totalAssets.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                            color: const Color(0xff282F3A)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer"
                            ? const SizedBox()
                            : SizedBox(height: getIt<Functions>().getWidgetHeight(height: 30)),
                        getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer"
                            ? const SizedBox()
                            : Text(getIt<Variables>().generalVariables.currentLanguage.roTripDetails.toUpperCase()),
                        getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer"
                            ? const SizedBox()
                            : SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                        getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer"
                            ? const SizedBox()
                            : Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: getIt<Functions>().getWidgetWidth(width: 16), vertical: getIt<Functions>().getWidgetHeight(height: 16)),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: GridView.builder(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: getIt<Functions>().getWidgetWidth(width: 16),
                                mainAxisSpacing: getIt<Functions>().getWidgetHeight(height: 16),
                                mainAxisExtent: getIt<Functions>().getWidgetHeight(height: 65),
                              ),
                              itemCount: context.read<RoTripListDetailBloc>().selectedData.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: context.read<RoTripListDetailBloc>().selectedData[index].label.toUpperCase(),
                                    labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Color(0xff8A8D8E)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(3.7),
                                        borderSide: BorderSide(color: const Color(0xff282F3A).withOpacity(0.37), width: 0.53)),
                                  ),
                                  child: Text(
                                    context.read<RoTripListDetailBloc>().selectedData[index].name,
                                    style: TextStyle(
                                        fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff282F3A)),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                }else{
                  return const SizedBox();
                }
              },
            ),
          );
        }
      },
    );
  }
}

class TripListDataModel {
  final String label;
  final String name;

  TripListDataModel({required this.label, required this.name});

  factory TripListDataModel.fromJson(Map<String, dynamic> json) => TripListDataModel(label: json["label"] ?? "", name: json["name"] ?? "");

  Map<String, dynamic> toJson() => {
        "label": label,
        "name": name,
      };
}
