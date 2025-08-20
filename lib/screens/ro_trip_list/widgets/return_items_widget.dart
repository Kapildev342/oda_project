// Flutter imports:
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:oda/bloc/ro_trip_list/ro_trip_list_detail/ro_trip_list_detail_bloc.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/screens/warehouse_pickup/warehouse_pickup_summary_screen.dart';
import 'package:shimmer/shimmer.dart';

class ReturnItemsWidget extends StatefulWidget {
  static const String id = "return_items_widget";
  const ReturnItemsWidget({super.key});

  @override
  State<ReturnItemsWidget> createState() => _ReturnItemsWidgetState();
}

class _ReturnItemsWidgetState extends State<ReturnItemsWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth > 480) {
        return BlocConsumer<RoTripListDetailBloc, RoTripListDetailState>(
          listenWhen: (RoTripListDetailState previous, RoTripListDetailState current) {
            return previous != current;
          },
          buildWhen: (RoTripListDetailState previous, RoTripListDetailState current) {
            return previous != current;
          },
          listener: (BuildContext context, RoTripListDetailState state) {},
          builder: (BuildContext context, RoTripListDetailState state) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                  padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                  height: getIt<Functions>().getWidgetHeight(height: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: const Color(0xffCBDBFF),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          "${getIt<Variables>().generalVariables.currentLanguage.totalQuantity} : ${context.read<RoTripListDetailBloc>().collectedQuantity + context.read<RoTripListDetailBloc>().unavailableQuantity}",
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff282F3A), fontWeight: FontWeight.w600)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "${getIt<Variables>().generalVariables.currentLanguage.collectedQuantity} : ",
                              style: TextStyle(
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                  color: const Color(0xff282F3A),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Figtree"),
                              children: [
                                TextSpan(
                                    text: "${context.read<RoTripListDetailBloc>().collectedQuantity}",
                                    style: TextStyle(
                                        fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                        color: const Color(0xff007838),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Figtree")),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: getIt<Functions>().getWidgetWidth(width: 20),
                          ),
                          RichText(
                            text: TextSpan(
                              text: "${getIt<Variables>().generalVariables.currentLanguage.unavailableQuantity} : ",
                              style: TextStyle(
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                  color: const Color(0xff282F3A),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Figtree"),
                              children: [
                                TextSpan(
                                    text: "${context.read<RoTripListDetailBloc>().unavailableQuantity}",
                                    style: TextStyle(
                                        fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                        color: const Color(0xffDC474A),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Figtree")),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: 25),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: context.read<RoTripListDetailBloc>().selectedReturnItemsData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            ExpansionTile(
                              backgroundColor: Colors.white,
                              collapsedBackgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                              collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                              initiallyExpanded: true,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        context.read<RoTripListDetailBloc>().selectedReturnItemsData[index].customer.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                            color: const Color(0xff282F3A)),
                                      ),
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: getIt<Variables>().generalVariables.currentLanguage.totalQty.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                          color: const Color(0xff282F3A),
                                          fontWeight: FontWeight.w500),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: " : ${context.read<RoTripListDetailBloc>().selectedReturnItemsData[index].totalQty}",
                                            style: TextStyle(
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xff007AFF),
                                                fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              children: List.generate(context.read<RoTripListDetailBloc>().selectedReturnItemsData[index].itemsList.length, (i) {
                                return StatefulBuilder(
                                  builder: (BuildContext context, StateSetter modelSetState) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                        left: getIt<Functions>().getWidgetWidth(width: 16),
                                        right: getIt<Functions>().getWidgetWidth(width: 16),
                                        bottom: getIt<Functions>().getWidgetHeight(height: 12),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: getIt<Functions>().getWidgetWidth(width: 20),
                                        vertical: getIt<Functions>().getWidgetHeight(height: 12),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        border: Border.all(
                                          color: const Color(0xffE6E7E9),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Text(
                                                    context.read<RoTripListDetailBloc>().selectedReturnItemsData[index].itemsList[i].itemName,
                                                    style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff282F3A),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: getIt<Functions>().getWidgetWidth(width: 15),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  text: getIt<Variables>().generalVariables.currentLanguage.returnQty.toUpperCase(),
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w500),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text:
                                                            " : ${context.read<RoTripListDetailBloc>().selectedReturnItemsData[index].itemsList[i].returnQty}",
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                            color: const Color(0xff007AFF),
                                                            fontWeight: FontWeight.w700)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: getIt<Functions>().getWidgetHeight(height: 7),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                context.read<RoTripListDetailBloc>().selectedReturnItemsData[index].itemsList[i].itemCode,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                  color: const Color(0xffA0A5BC),
                                                ),
                                              ),
                                              if (getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer" &&
                                                  context
                                                          .read<RoTripListDetailBloc>()
                                                          .roTripDetailModel
                                                          .response
                                                          .tripInfo
                                                          .tripReturnStatus
                                                          .toLowerCase() !=
                                                      "completed")
                                                SizedBox(
                                                  height: getIt<Functions>().getWidgetHeight(height: 32),
                                                  width: getIt<Functions>().getWidgetWidth(width: 255),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      context.read<RoTripListDetailBloc>().selectedReturnItemsData[index].itemsList[i].podLoader
                                                          ? Container(
                                                              height: getIt<Functions>().getWidgetHeight(height: 32),
                                                              width: getIt<Functions>().getWidgetWidth(width: 32),
                                                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                              child: const Center(child: CircularProgressIndicator()),
                                                            )
                                                          : context
                                                                      .read<RoTripListDetailBloc>()
                                                                      .selectedReturnItemsData[index]
                                                                      .itemsList[i]
                                                                      .proofOfDeliveryImages
                                                                      .length <
                                                                  5
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    getIt<Variables>().generalVariables.popUpWidget =
                                                                        cameraAlertDialog(customerIndex: index, listIndex: i);
                                                                    getIt<Functions>().showAnimatedDialog(
                                                                        context: context, isFromTop: false, isCloseDisabled: false);
                                                                  },
                                                                  child: Container(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 32),
                                                                    width: getIt<Functions>().getWidgetWidth(width: 32),
                                                                    padding: EdgeInsets.symmetric(
                                                                      horizontal: getIt<Functions>().getWidgetWidth(width: 5),
                                                                      vertical: getIt<Functions>().getWidgetHeight(height: 5),
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(7),
                                                                        border: Border.all(color: const Color(0xffD0D2D4))),
                                                                    child: SvgPicture.asset("assets/ro_trip_list/gallery_add.svg"),
                                                                  ),
                                                                )
                                                              : Container(
                                                                  height: getIt<Functions>().getWidgetHeight(height: 32),
                                                                  width: getIt<Functions>().getWidgetWidth(width: 32),
                                                                  padding: EdgeInsets.symmetric(
                                                                    horizontal: getIt<Functions>().getWidgetWidth(width: 5),
                                                                    vertical: getIt<Functions>().getWidgetHeight(height: 5),
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.grey.shade300,
                                                                    borderRadius: BorderRadius.circular(12),
                                                                  ),
                                                                  child: SvgPicture.asset("assets/ro_trip_list/gallery_add.svg"),
                                                                ),
                                                      SizedBox(
                                                        width: getIt<Functions>().getWidgetWidth(width: 12),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          height: getIt<Functions>().getWidgetHeight(height: 32),
                                                          width: getIt<Functions>().getWidgetWidth(width: 32),
                                                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 8)),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(7),
                                                              border: Border.all(color: const Color(0xff007838))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Center(
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    if (num.parse(context
                                                                                .read<RoTripListDetailBloc>()
                                                                                .selectedReturnItemsData[index]
                                                                                .itemsList[i]
                                                                                .addingTextEditingController
                                                                                .text) >
                                                                            0 &&
                                                                        num.parse(context
                                                                                .read<RoTripListDetailBloc>()
                                                                                .selectedReturnItemsData[index]
                                                                                .itemsList[i]
                                                                                .addingTextEditingController
                                                                                .text) <=
                                                                            num.parse(context
                                                                                .read<RoTripListDetailBloc>()
                                                                                .selectedReturnItemsData[index]
                                                                                .itemsList[i]
                                                                                .returnQty
                                                                                .toString())) {
                                                                      context
                                                                          .read<RoTripListDetailBloc>()
                                                                          .selectedReturnItemsData[index]
                                                                          .itemsList[i]
                                                                          .moreQuantityError = false;
                                                                      context
                                                                          .read<RoTripListDetailBloc>()
                                                                          .selectedReturnItemsData[index]
                                                                          .itemsList[i]
                                                                          .addingTextEditingController
                                                                          .text = (num.parse(context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[index]
                                                                                  .itemsList[i]
                                                                                  .addingTextEditingController
                                                                                  .text) -
                                                                              1)
                                                                          .toString();
                                                                      context
                                                                          .read<RoTripListDetailBloc>()
                                                                          .selectedReturnItemsData[index]
                                                                          .itemsList[i]
                                                                          .removingTextEditingController
                                                                          .text = (num.parse(context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[index]
                                                                                  .itemsList[i]
                                                                                  .returnQty
                                                                                  .toString()) -
                                                                              num.parse(context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[index]
                                                                                  .itemsList[i]
                                                                                  .addingTextEditingController
                                                                                  .text))
                                                                          .toString();
                                                                    } else if (num.parse(context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .addingTextEditingController
                                                                            .text) >
                                                                        num.parse(context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .returnQty
                                                                            .toString())) {
                                                                      context
                                                                          .read<RoTripListDetailBloc>()
                                                                          .selectedReturnItemsData[index]
                                                                          .itemsList[i]
                                                                          .moreQuantityError = true;
                                                                    }
                                                                    context.read<RoTripListDetailBloc>().collectedQuantity = 0;
                                                                    context.read<RoTripListDetailBloc>().unavailableQuantity = 0;
                                                                    for (int i = 0;
                                                                        i < context.read<RoTripListDetailBloc>().selectedReturnItemsData.length;
                                                                        i++) {
                                                                      for (int j = 0;
                                                                          j <
                                                                              context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[i]
                                                                                  .itemsList
                                                                                  .length;
                                                                          j++) {
                                                                        context.read<RoTripListDetailBloc>().collectedQuantity =
                                                                            context.read<RoTripListDetailBloc>().collectedQuantity +
                                                                                int.parse(context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[i]
                                                                                    .itemsList[j]
                                                                                    .addingTextEditingController
                                                                                    .text);
                                                                        context.read<RoTripListDetailBloc>().unavailableQuantity =
                                                                            context.read<RoTripListDetailBloc>().unavailableQuantity +
                                                                                int.parse(context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[i]
                                                                                    .itemsList[j]
                                                                                    .removingTextEditingController
                                                                                    .text);
                                                                      }
                                                                    }
                                                                    modelSetState(() {});
                                                                    setState(() {});
                                                                  },
                                                                  child: const Icon(
                                                                    Icons.remove,
                                                                    color: Color(0xff007838),
                                                                    size: 14,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  child: TextFormField(
                                                                controller: context
                                                                    .read<RoTripListDetailBloc>()
                                                                    .selectedReturnItemsData[index]
                                                                    .itemsList[i]
                                                                    .addingTextEditingController,
                                                                style: const TextStyle(
                                                                    fontSize: 13.0,
                                                                    color: Color(0xFF282F3A),
                                                                    decoration: TextDecoration.none,
                                                                    fontWeight: FontWeight.w600),
                                                                keyboardType: TextInputType.number,
                                                                textAlign: TextAlign.center,
                                                                showCursor: true,
                                                                maxLines: 1,
                                                                decoration: InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 18)),
                                                                  focusedBorder: InputBorder.none,
                                                                  enabledBorder: InputBorder.none,
                                                                  border: InputBorder.none,
                                                                ),
                                                                onChanged: (value) {
                                                                  if (value.isEmpty) {
                                                                    context
                                                                        .read<RoTripListDetailBloc>()
                                                                        .selectedReturnItemsData[index]
                                                                        .itemsList[i]
                                                                        .moreQuantityError = false;
                                                                    context
                                                                        .read<RoTripListDetailBloc>()
                                                                        .selectedReturnItemsData[index]
                                                                        .itemsList[i]
                                                                        .addingTextEditingController
                                                                        .text = "00";
                                                                    context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .removingTextEditingController
                                                                            .text =
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .returnQty
                                                                            .toString();
                                                                    context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                                                                  } else {
                                                                    if (num.parse(context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .addingTextEditingController
                                                                            .text) ==
                                                                        0) {
                                                                      context
                                                                          .read<RoTripListDetailBloc>()
                                                                          .selectedReturnItemsData[index]
                                                                          .itemsList[i]
                                                                          .moreQuantityError = false;
                                                                      context
                                                                          .read<RoTripListDetailBloc>()
                                                                          .selectedReturnItemsData[index]
                                                                          .itemsList[i]
                                                                          .addingTextEditingController
                                                                          .text = "00";
                                                                      context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .selectedReturnItemsData[index]
                                                                              .itemsList[i]
                                                                              .removingTextEditingController
                                                                              .text =
                                                                          context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .selectedReturnItemsData[index]
                                                                              .itemsList[i]
                                                                              .returnQty
                                                                              .toString();
                                                                      context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                                                                    } else {
                                                                      if (num.parse(context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .selectedReturnItemsData[index]
                                                                              .itemsList[i]
                                                                              .addingTextEditingController
                                                                              .text) <=
                                                                          num.parse(context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .selectedReturnItemsData[index]
                                                                              .itemsList[i]
                                                                              .returnQty
                                                                              .toString())) {
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .moreQuantityError = false;
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .addingTextEditingController
                                                                            .text = num.parse(value).toString();
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .removingTextEditingController
                                                                            .text = (num.parse(context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .returnQty
                                                                                    .toString()) -
                                                                                num.parse(context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .addingTextEditingController
                                                                                    .text))
                                                                            .toString();
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .add(const RoTripListDetailSetStateEvent());
                                                                      } else {
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .moreQuantityError = true;
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .add(const RoTripListDetailSetStateEvent());
                                                                      }
                                                                    }
                                                                  }
                                                                  context.read<RoTripListDetailBloc>().collectedQuantity = 0;
                                                                  context.read<RoTripListDetailBloc>().unavailableQuantity = 0;
                                                                  for (int i = 0;
                                                                      i < context.read<RoTripListDetailBloc>().selectedReturnItemsData.length;
                                                                      i++) {
                                                                    for (int j = 0;
                                                                        j <
                                                                            context
                                                                                .read<RoTripListDetailBloc>()
                                                                                .selectedReturnItemsData[i]
                                                                                .itemsList
                                                                                .length;
                                                                        j++) {
                                                                      context.read<RoTripListDetailBloc>().collectedQuantity =
                                                                          context.read<RoTripListDetailBloc>().collectedQuantity +
                                                                              int.parse(context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[i]
                                                                                  .itemsList[j]
                                                                                  .addingTextEditingController
                                                                                  .text);
                                                                      context.read<RoTripListDetailBloc>().unavailableQuantity =
                                                                          context.read<RoTripListDetailBloc>().unavailableQuantity +
                                                                              int.parse(context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[i]
                                                                                  .itemsList[j]
                                                                                  .removingTextEditingController
                                                                                  .text);
                                                                    }
                                                                  }
                                                                  modelSetState(() {});
                                                                  setState(() {});
                                                                },
                                                              )),
                                                              Center(
                                                                child: InkWell(
                                                                    onTap: () {
                                                                      if (num.parse(context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[index]
                                                                                  .itemsList[i]
                                                                                  .addingTextEditingController
                                                                                  .text) <
                                                                              num.parse(context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[index]
                                                                                  .itemsList[i]
                                                                                  .returnQty
                                                                                  .toString()) &&
                                                                          num.parse(context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[index]
                                                                                  .itemsList[i]
                                                                                  .addingTextEditingController
                                                                                  .text) >=
                                                                              0) {
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .moreQuantityError = false;
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .addingTextEditingController
                                                                            .text = (num.parse(context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .addingTextEditingController
                                                                                    .text) +
                                                                                1)
                                                                            .toString();
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .removingTextEditingController
                                                                            .text = (num.parse(context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .returnQty
                                                                                    .toString()) -
                                                                                num.parse(context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .addingTextEditingController
                                                                                    .text))
                                                                            .toString();
                                                                      } else if (num.parse(context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .selectedReturnItemsData[index]
                                                                              .itemsList[i]
                                                                              .addingTextEditingController
                                                                              .text) >
                                                                          num.parse(context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .selectedReturnItemsData[index]
                                                                              .itemsList[i]
                                                                              .returnQty
                                                                              .toString())) {
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .moreQuantityError = true;
                                                                      }
                                                                      context.read<RoTripListDetailBloc>().collectedQuantity = 0;
                                                                      context.read<RoTripListDetailBloc>().unavailableQuantity = 0;
                                                                      for (int i = 0;
                                                                          i < context.read<RoTripListDetailBloc>().selectedReturnItemsData.length;
                                                                          i++) {
                                                                        for (int j = 0;
                                                                            j <
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[i]
                                                                                    .itemsList
                                                                                    .length;
                                                                            j++) {
                                                                          context.read<RoTripListDetailBloc>().collectedQuantity =
                                                                              context.read<RoTripListDetailBloc>().collectedQuantity +
                                                                                  int.parse(context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[i]
                                                                                      .itemsList[j]
                                                                                      .addingTextEditingController
                                                                                      .text);
                                                                          context.read<RoTripListDetailBloc>().unavailableQuantity =
                                                                              context.read<RoTripListDetailBloc>().unavailableQuantity +
                                                                                  int.parse(context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[i]
                                                                                      .itemsList[j]
                                                                                      .removingTextEditingController
                                                                                      .text);
                                                                        }
                                                                      }
                                                                      modelSetState(() {});
                                                                      setState(() {});
                                                                    },
                                                                    child: const Icon(Icons.add, color: Color(0xff007838), size: 14)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: getIt<Functions>().getWidgetWidth(width: 12),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          height: getIt<Functions>().getWidgetHeight(height: 32),
                                                          width: getIt<Functions>().getWidgetWidth(width: 32),
                                                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 8)),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(7),
                                                              border: Border.all(color: const Color(0xffDC474A))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Center(
                                                                child: InkWell(
                                                                    onTap: () {
                                                                      if (num.parse(context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[index]
                                                                                  .itemsList[i]
                                                                                  .removingTextEditingController
                                                                                  .text) >
                                                                              0 &&
                                                                          num.parse(context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[index]
                                                                                  .itemsList[i]
                                                                                  .removingTextEditingController
                                                                                  .text) <=
                                                                              num.parse(context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[index]
                                                                                  .itemsList[i]
                                                                                  .returnQty
                                                                                  .toString())) {
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .moreQuantityError = false;
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .removingTextEditingController
                                                                            .text = (num.parse(context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .removingTextEditingController
                                                                                    .text) -
                                                                                1)
                                                                            .toString();
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .addingTextEditingController
                                                                            .text = (num.parse(context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .returnQty
                                                                                    .toString()) -
                                                                                num.parse(context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .removingTextEditingController
                                                                                    .text))
                                                                            .toString();
                                                                      } else if (num.parse(context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .selectedReturnItemsData[index]
                                                                              .itemsList[i]
                                                                              .removingTextEditingController
                                                                              .text) >
                                                                          num.parse(context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .selectedReturnItemsData[index]
                                                                              .itemsList[i]
                                                                              .returnQty
                                                                              .toString())) {
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .moreQuantityError = true;
                                                                      }
                                                                      context.read<RoTripListDetailBloc>().collectedQuantity = 0;
                                                                      context.read<RoTripListDetailBloc>().unavailableQuantity = 0;
                                                                      for (int i = 0;
                                                                          i < context.read<RoTripListDetailBloc>().selectedReturnItemsData.length;
                                                                          i++) {
                                                                        for (int j = 0;
                                                                            j <
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[i]
                                                                                    .itemsList
                                                                                    .length;
                                                                            j++) {
                                                                          context.read<RoTripListDetailBloc>().collectedQuantity =
                                                                              context.read<RoTripListDetailBloc>().collectedQuantity +
                                                                                  int.parse(context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[i]
                                                                                      .itemsList[j]
                                                                                      .addingTextEditingController
                                                                                      .text);
                                                                          context.read<RoTripListDetailBloc>().unavailableQuantity =
                                                                              context.read<RoTripListDetailBloc>().unavailableQuantity +
                                                                                  int.parse(context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[i]
                                                                                      .itemsList[j]
                                                                                      .removingTextEditingController
                                                                                      .text);
                                                                        }
                                                                      }
                                                                      modelSetState(() {});
                                                                      setState(() {});
                                                                    },
                                                                    child: const Icon(Icons.remove, color: Color(0xffDC474A), size: 14)),
                                                              ),
                                                              Expanded(
                                                                child: TextFormField(
                                                                  controller: context
                                                                      .read<RoTripListDetailBloc>()
                                                                      .selectedReturnItemsData[index]
                                                                      .itemsList[i]
                                                                      .removingTextEditingController,
                                                                  style: const TextStyle(
                                                                      fontSize: 13.0,
                                                                      color: Color(0xFF282F3A),
                                                                      decoration: TextDecoration.none,
                                                                      fontWeight: FontWeight.w600),
                                                                  textAlign: TextAlign.center,
                                                                  showCursor: true,
                                                                  maxLines: 1,
                                                                  decoration: InputDecoration(
                                                                    contentPadding:
                                                                        EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 18)),
                                                                    focusedBorder: InputBorder.none,
                                                                    enabledBorder: InputBorder.none,
                                                                    border: InputBorder.none,
                                                                  ),
                                                                  onChanged: (value) {
                                                                    if (value.isEmpty) {
                                                                      context
                                                                          .read<RoTripListDetailBloc>()
                                                                          .selectedReturnItemsData[index]
                                                                          .itemsList[i]
                                                                          .moreQuantityError = false;
                                                                      context
                                                                          .read<RoTripListDetailBloc>()
                                                                          .selectedReturnItemsData[index]
                                                                          .itemsList[i]
                                                                          .removingTextEditingController
                                                                          .text = "00";
                                                                      context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .selectedReturnItemsData[index]
                                                                              .itemsList[i]
                                                                              .addingTextEditingController
                                                                              .text =
                                                                          context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .selectedReturnItemsData[index]
                                                                              .itemsList[i]
                                                                              .returnQty
                                                                              .toString();
                                                                      context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                                                                    } else {
                                                                      if (num.parse(context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .selectedReturnItemsData[index]
                                                                              .itemsList[i]
                                                                              .removingTextEditingController
                                                                              .text) ==
                                                                          0) {
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .moreQuantityError = false;
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .removingTextEditingController
                                                                            .text = "00";
                                                                        context
                                                                                .read<RoTripListDetailBloc>()
                                                                                .selectedReturnItemsData[index]
                                                                                .itemsList[i]
                                                                                .addingTextEditingController
                                                                                .text =
                                                                            context
                                                                                .read<RoTripListDetailBloc>()
                                                                                .selectedReturnItemsData[index]
                                                                                .itemsList[i]
                                                                                .returnQty
                                                                                .toString();
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .add(const RoTripListDetailSetStateEvent());
                                                                      } else {
                                                                        if (num.parse(context
                                                                                .read<RoTripListDetailBloc>()
                                                                                .selectedReturnItemsData[index]
                                                                                .itemsList[i]
                                                                                .removingTextEditingController
                                                                                .text) <=
                                                                            num.parse(context
                                                                                .read<RoTripListDetailBloc>()
                                                                                .selectedReturnItemsData[index]
                                                                                .itemsList[i]
                                                                                .returnQty
                                                                                .toString())) {
                                                                          context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .selectedReturnItemsData[index]
                                                                              .itemsList[i]
                                                                              .moreQuantityError = false;
                                                                          context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .selectedReturnItemsData[index]
                                                                              .itemsList[i]
                                                                              .removingTextEditingController
                                                                              .text = num.parse(value).toString();
                                                                          context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .selectedReturnItemsData[index]
                                                                              .itemsList[i]
                                                                              .addingTextEditingController
                                                                              .text = (num.parse(context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[index]
                                                                                      .itemsList[i]
                                                                                      .returnQty
                                                                                      .toString()) -
                                                                                  num.parse(context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[index]
                                                                                      .itemsList[i]
                                                                                      .removingTextEditingController
                                                                                      .text))
                                                                              .toString();
                                                                          context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .add(const RoTripListDetailSetStateEvent());
                                                                        } else {
                                                                          context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .selectedReturnItemsData[index]
                                                                              .itemsList[i]
                                                                              .moreQuantityError = true;
                                                                          context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .add(const RoTripListDetailSetStateEvent());
                                                                        }
                                                                      }
                                                                    }
                                                                    context.read<RoTripListDetailBloc>().collectedQuantity = 0;
                                                                    context.read<RoTripListDetailBloc>().unavailableQuantity = 0;
                                                                    for (int i = 0;
                                                                        i < context.read<RoTripListDetailBloc>().selectedReturnItemsData.length;
                                                                        i++) {
                                                                      for (int j = 0;
                                                                          j <
                                                                              context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[i]
                                                                                  .itemsList
                                                                                  .length;
                                                                          j++) {
                                                                        context.read<RoTripListDetailBloc>().collectedQuantity =
                                                                            context.read<RoTripListDetailBloc>().collectedQuantity +
                                                                                int.parse(context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[i]
                                                                                    .itemsList[j]
                                                                                    .addingTextEditingController
                                                                                    .text);
                                                                        context.read<RoTripListDetailBloc>().unavailableQuantity =
                                                                            context.read<RoTripListDetailBloc>().unavailableQuantity +
                                                                                int.parse(context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[i]
                                                                                    .itemsList[j]
                                                                                    .removingTextEditingController
                                                                                    .text);
                                                                      }
                                                                    }
                                                                    modelSetState(() {});
                                                                    setState(() {});
                                                                  },
                                                                ),
                                                              ),
                                                              Center(
                                                                child: InkWell(
                                                                    onTap: () {
                                                                      if (num.parse(context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[index]
                                                                                  .itemsList[i]
                                                                                  .removingTextEditingController
                                                                                  .text) <
                                                                              num.parse(context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[index]
                                                                                  .itemsList[i]
                                                                                  .returnQty
                                                                                  .toString()) &&
                                                                          num.parse(context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[index]
                                                                                  .itemsList[i]
                                                                                  .removingTextEditingController
                                                                                  .text) >=
                                                                              0) {
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .moreQuantityError = false;
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .removingTextEditingController
                                                                            .text = (num.parse(context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .removingTextEditingController
                                                                                    .text) +
                                                                                1)
                                                                            .toString();
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .addingTextEditingController
                                                                            .text = (num.parse(context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .returnQty
                                                                                    .toString()) -
                                                                                num.parse(context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .removingTextEditingController
                                                                                    .text))
                                                                            .toString();
                                                                      } else if (num.parse(context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .selectedReturnItemsData[index]
                                                                              .itemsList[i]
                                                                              .removingTextEditingController
                                                                              .text) >
                                                                          num.parse(context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .selectedReturnItemsData[index]
                                                                              .itemsList[i]
                                                                              .returnQty
                                                                              .toString())) {
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .moreQuantityError = true;
                                                                      }
                                                                      context.read<RoTripListDetailBloc>().collectedQuantity = 0;
                                                                      context.read<RoTripListDetailBloc>().unavailableQuantity = 0;
                                                                      for (int i = 0;
                                                                          i < context.read<RoTripListDetailBloc>().selectedReturnItemsData.length;
                                                                          i++) {
                                                                        for (int j = 0;
                                                                            j <
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[i]
                                                                                    .itemsList
                                                                                    .length;
                                                                            j++) {
                                                                          context.read<RoTripListDetailBloc>().collectedQuantity =
                                                                              context.read<RoTripListDetailBloc>().collectedQuantity +
                                                                                  int.parse(context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[i]
                                                                                      .itemsList[j]
                                                                                      .addingTextEditingController
                                                                                      .text);
                                                                          context.read<RoTripListDetailBloc>().unavailableQuantity =
                                                                              context.read<RoTripListDetailBloc>().unavailableQuantity +
                                                                                  int.parse(context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[i]
                                                                                      .itemsList[j]
                                                                                      .removingTextEditingController
                                                                                      .text);
                                                                        }
                                                                      }
                                                                      modelSetState(() {});
                                                                      setState(() {});
                                                                    },
                                                                    child: const Icon(Icons.add, color: Color(0xffDC474A), size: 14)),
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
                                          context.read<RoTripListDetailBloc>().selectedReturnItemsData[index].itemsList[i].moreQuantityError
                                              ? SizedBox(
                                                  height: getIt<Functions>().getWidgetHeight(height: 7),
                                                )
                                              : const SizedBox(),
                                          context.read<RoTripListDetailBloc>().selectedReturnItemsData[index].itemsList[i].moreQuantityError
                                              ? Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.moreQuantity,
                                                      style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 10), color: Colors.red),
                                                    )
                                                  ],
                                                )
                                              : const SizedBox(),
                                          context
                                                  .read<RoTripListDetailBloc>()
                                                  .selectedReturnItemsData[index]
                                                  .itemsList[i]
                                                  .proofOfDeliveryImages
                                                  .isNotEmpty
                                              ? SizedBox(
                                                  height: getIt<Functions>().getWidgetHeight(height: 12),
                                                )
                                              : const SizedBox(),
                                          context
                                                  .read<RoTripListDetailBloc>()
                                                  .selectedReturnItemsData[index]
                                                  .itemsList[i]
                                                  .proofOfDeliveryImages
                                                  .isNotEmpty
                                              ? SizedBox(
                                                  height: getIt<Functions>().getWidgetHeight(height: 120),
                                                  child: ListView.builder(
                                                      padding: EdgeInsets.zero,
                                                      physics: const BouncingScrollPhysics(),
                                                      scrollDirection: Axis.horizontal,
                                                      itemCount: context
                                                          .read<RoTripListDetailBloc>()
                                                          .selectedReturnItemsData[index]
                                                          .itemsList[i]
                                                          .proofOfDeliveryImages
                                                          .length,
                                                      itemBuilder: (BuildContext context, int imagesIndex) {
                                                        return Stack(
                                                          alignment: Alignment.topRight,
                                                          children: [
                                                            Container(
                                                                height: getIt<Functions>().getWidgetHeight(height: 120),
                                                                width: getIt<Functions>().getWidgetWidth(width: 120),
                                                                margin: EdgeInsets.only(
                                                                    bottom: getIt<Functions>().getWidgetHeight(height: 20),
                                                                    right: getIt<Functions>().getWidgetWidth(width: 10)),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                clipBehavior: Clip.hardEdge,
                                                                child: Image.network(
                                                                  context
                                                                      .read<RoTripListDetailBloc>()
                                                                      .selectedReturnItemsData[index]
                                                                      .itemsList[i]
                                                                      .proofOfDeliveryImages[imagesIndex]
                                                                      .imagePath,
                                                                  fit: BoxFit.fill,
                                                                  loadingBuilder: (context, child, loadingProgress) => loadingProgress != null
                                                                      ? Shimmer.fromColors(
                                                                          baseColor: Colors.white24,
                                                                          highlightColor: Colors.grey,
                                                                          child: Container(
                                                                            width: getIt<Functions>().getWidgetWidth(width: 82),
                                                                            decoration: const BoxDecoration(color: Colors.red),
                                                                          ),
                                                                        )
                                                                      : child,
                                                                )),
                                                            context
                                                                    .read<RoTripListDetailBloc>()
                                                                    .selectedReturnItemsData[index]
                                                                    .itemsList[i]
                                                                    .proofOfDeliveryImages[imagesIndex]
                                                                    .canRemove
                                                                ? InkWell(
                                                                    onTap: () {
                                                                      context
                                                                          .read<RoTripListDetailBloc>()
                                                                          .selectedReturnItemsData[index]
                                                                          .itemsList[i]
                                                                          .proofOfDeliveryImages[imagesIndex]
                                                                          .canRemove = false;
                                                                      context
                                                                          .read<RoTripListDetailBloc>()
                                                                          .selectedReturnItemsData[index]
                                                                          .itemsList[i]
                                                                          .proofOfDeliveryImages
                                                                          .removeAt(imagesIndex);
                                                                      setState(() {});
                                                                    },
                                                                    child: Container(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 25),
                                                                        width: getIt<Functions>().getWidgetWidth(width: 25),
                                                                        margin: EdgeInsets.only(
                                                                            top: getIt<Functions>().getWidgetHeight(height: 2),
                                                                            right: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                        decoration: BoxDecoration(
                                                                          color: Colors.black26.withOpacity(0.3),
                                                                          shape: BoxShape.circle,
                                                                        ),
                                                                        child: const Icon(Icons.clear, color: Colors.white, size: 15)),
                                                                  )
                                                                : const SizedBox()
                                                          ],
                                                        );
                                                      }),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),
                          ],
                        );
                      }),
                ),
              ],
            );
          },
        );
      } else {
        return BlocConsumer<RoTripListDetailBloc, RoTripListDetailState>(
          listenWhen: (RoTripListDetailState previous, RoTripListDetailState current) {
            return previous != current;
          },
          buildWhen: (RoTripListDetailState previous, RoTripListDetailState current) {
            return previous != current;
          },
          listener: (BuildContext context, RoTripListDetailState state) {},
          builder: (BuildContext context, RoTripListDetailState state) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                  padding: EdgeInsets.symmetric(
                      horizontal: getIt<Functions>().getWidgetWidth(width: 20), vertical: getIt<Functions>().getWidgetHeight(height: 10)),
                  height: getIt<Functions>().getWidgetHeight(height: 75),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: const Color(0xffCBDBFF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          "${getIt<Variables>().generalVariables.currentLanguage.totalQuantity} : ${context.read<RoTripListDetailBloc>().collectedQuantity + context.read<RoTripListDetailBloc>().unavailableQuantity}",
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: 14), color: const Color(0xff282F3A), fontWeight: FontWeight.w600)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "${getIt<Variables>().generalVariables.currentLanguage.collectedQuantity} : ",
                              style: TextStyle(
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                  color: const Color(0xff282F3A),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Figtree"),
                              children: [
                                TextSpan(
                                    text: "${context.read<RoTripListDetailBloc>().collectedQuantity}",
                                    style: TextStyle(
                                        fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                        color: const Color(0xff007838),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Figtree")),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: getIt<Functions>().getWidgetWidth(width: 20),
                          ),
                          RichText(
                            text: TextSpan(
                              text: "${getIt<Variables>().generalVariables.currentLanguage.unavailableQuantity} : ",
                              style: TextStyle(
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                  color: const Color(0xff282F3A),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Figtree"),
                              children: [
                                TextSpan(
                                    text: "${context.read<RoTripListDetailBloc>().unavailableQuantity}",
                                    style: TextStyle(
                                        fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                        color: const Color(0xffDC474A),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Figtree")),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: 15),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: context.read<RoTripListDetailBloc>().selectedReturnItemsData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            ExpansionTile(
                              backgroundColor: Colors.white,
                              collapsedBackgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                              collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                              initiallyExpanded:true,
                              title: Text(
                                context.read<RoTripListDetailBloc>().selectedReturnItemsData[index].customer.toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                    color: const Color(0xff282F3A)),
                              ),
                              subtitle: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  text: getIt<Variables>().generalVariables.currentLanguage.totalQty.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                      color: const Color(0xff282F3A),
                                      fontWeight: FontWeight.w500),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: " : ${context.read<RoTripListDetailBloc>().selectedReturnItemsData[index].totalQty}",
                                        style: TextStyle(
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                            color: const Color(0xff007AFF),
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                              children: List.generate(
                                  context.read<RoTripListDetailBloc>().selectedReturnItemsData[index].itemsList.length,
                                  (i) => StatefulBuilder(builder: (BuildContext context, StateSetter modelSetState) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                            left: getIt<Functions>().getWidgetWidth(width: 12),
                                            right: getIt<Functions>().getWidgetWidth(width: 12),
                                            bottom: getIt<Functions>().getWidgetHeight(height: 7),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                            vertical: getIt<Functions>().getWidgetHeight(height: 8),
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(7),
                                            border: Border.all(
                                              color: const Color(0xffE6E7E9),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Text(
                                                  context.read<RoTripListDetailBloc>().selectedReturnItemsData[index].itemsList[i].itemName,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(0xff282F3A),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: getIt<Functions>().getWidgetHeight(height: 7),
                                              ),
                                              Text(
                                                context.read<RoTripListDetailBloc>().selectedReturnItemsData[index].itemsList[i].itemCode,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                  color: const Color(0xffA0A5BC),
                                                ),
                                              ),
                                              SizedBox(
                                                height: getIt<Functions>().getWidgetHeight(height: 7),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  getIt<Variables>().generalVariables.userData.userProfile.employeeType == "return_officer" &&
                                                          context
                                                                  .read<RoTripListDetailBloc>()
                                                                  .roTripDetailModel
                                                                  .response
                                                                  .tripInfo
                                                                  .tripReturnStatus
                                                                  .toLowerCase() !=
                                                              "completed"
                                                      ? SizedBox(
                                                          height: getIt<Functions>().getWidgetHeight(height: 32),
                                                          width: getIt<Functions>().getWidgetWidth(width: 225),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Expanded(
                                                                child: Container(
                                                                  height: getIt<Functions>().getWidgetHeight(height: 32),
                                                                  width: getIt<Functions>().getWidgetWidth(width: 32),
                                                                  padding:
                                                                      EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 8)),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(7),
                                                                      border: Border.all(color: const Color(0xff007838))),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Center(
                                                                        child: InkWell(
                                                                          onTap: () {
                                                                            if (num.parse(context
                                                                                        .read<RoTripListDetailBloc>()
                                                                                        .selectedReturnItemsData[index]
                                                                                        .itemsList[i]
                                                                                        .addingTextEditingController
                                                                                        .text) >
                                                                                    0 &&
                                                                                num.parse(context
                                                                                        .read<RoTripListDetailBloc>()
                                                                                        .selectedReturnItemsData[index]
                                                                                        .itemsList[i]
                                                                                        .addingTextEditingController
                                                                                        .text) <=
                                                                                    num.parse(context
                                                                                        .read<RoTripListDetailBloc>()
                                                                                        .selectedReturnItemsData[index]
                                                                                        .itemsList[i]
                                                                                        .returnQty
                                                                                        .toString())) {
                                                                              context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[index]
                                                                                  .itemsList[i]
                                                                                  .moreQuantityError = false;
                                                                              context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[index]
                                                                                  .itemsList[i]
                                                                                  .addingTextEditingController
                                                                                  .text = (num.parse(context
                                                                                          .read<RoTripListDetailBloc>()
                                                                                          .selectedReturnItemsData[index]
                                                                                          .itemsList[i]
                                                                                          .addingTextEditingController
                                                                                          .text) -
                                                                                      1)
                                                                                  .toString();
                                                                              context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[index]
                                                                                  .itemsList[i]
                                                                                  .removingTextEditingController
                                                                                  .text = (num.parse(context
                                                                                          .read<RoTripListDetailBloc>()
                                                                                          .selectedReturnItemsData[index]
                                                                                          .itemsList[i]
                                                                                          .returnQty
                                                                                          .toString()) -
                                                                                      num.parse(context
                                                                                          .read<RoTripListDetailBloc>()
                                                                                          .selectedReturnItemsData[index]
                                                                                          .itemsList[i]
                                                                                          .addingTextEditingController
                                                                                          .text))
                                                                                  .toString();
                                                                            } else if (num.parse(context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .addingTextEditingController
                                                                                    .text) >
                                                                                num.parse(context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .returnQty
                                                                                    .toString())) {
                                                                              context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[index]
                                                                                  .itemsList[i]
                                                                                  .moreQuantityError = true;
                                                                            }
                                                                            context.read<RoTripListDetailBloc>().collectedQuantity = 0;
                                                                            context.read<RoTripListDetailBloc>().unavailableQuantity = 0;
                                                                            for (int i = 0;
                                                                                i <
                                                                                    context
                                                                                        .read<RoTripListDetailBloc>()
                                                                                        .selectedReturnItemsData
                                                                                        .length;
                                                                                i++) {
                                                                              for (int j = 0;
                                                                                  j <
                                                                                      context
                                                                                          .read<RoTripListDetailBloc>()
                                                                                          .selectedReturnItemsData[i]
                                                                                          .itemsList
                                                                                          .length;
                                                                                  j++) {
                                                                                context.read<RoTripListDetailBloc>().collectedQuantity =
                                                                                    context.read<RoTripListDetailBloc>().collectedQuantity +
                                                                                        int.parse(context
                                                                                            .read<RoTripListDetailBloc>()
                                                                                            .selectedReturnItemsData[i]
                                                                                            .itemsList[j]
                                                                                            .addingTextEditingController
                                                                                            .text);
                                                                                context.read<RoTripListDetailBloc>().unavailableQuantity =
                                                                                    context.read<RoTripListDetailBloc>().unavailableQuantity +
                                                                                        int.parse(context
                                                                                            .read<RoTripListDetailBloc>()
                                                                                            .selectedReturnItemsData[i]
                                                                                            .itemsList[j]
                                                                                            .removingTextEditingController
                                                                                            .text);
                                                                              }
                                                                            }
                                                                            modelSetState(() {});
                                                                            setState(() {});
                                                                          },
                                                                          child: const Icon(
                                                                            Icons.remove,
                                                                            color: Color(0xff007838),
                                                                            size: 14,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                          child: TextFormField(
                                                                        controller: context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedReturnItemsData[index]
                                                                            .itemsList[i]
                                                                            .addingTextEditingController,
                                                                        style: const TextStyle(
                                                                            fontSize: 13.0,
                                                                            color: Color(0xFF282F3A),
                                                                            decoration: TextDecoration.none,
                                                                            fontWeight: FontWeight.w600),
                                                                        textAlign: TextAlign.center,
                                                                        showCursor: false,
                                                                        decoration: InputDecoration(
                                                                          contentPadding:
                                                                              EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 18)),
                                                                          focusedBorder: InputBorder.none,
                                                                          enabledBorder: InputBorder.none,
                                                                          border: InputBorder.none,
                                                                        ),
                                                                        onChanged: (value) {
                                                                          if (value.isEmpty) {
                                                                            context
                                                                                .read<RoTripListDetailBloc>()
                                                                                .selectedReturnItemsData[index]
                                                                                .itemsList[i]
                                                                                .moreQuantityError = false;
                                                                            context
                                                                                .read<RoTripListDetailBloc>()
                                                                                .selectedReturnItemsData[index]
                                                                                .itemsList[i]
                                                                                .addingTextEditingController
                                                                                .text = "00";
                                                                            context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .removingTextEditingController
                                                                                    .text =
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .returnQty
                                                                                    .toString();
                                                                            context
                                                                                .read<RoTripListDetailBloc>()
                                                                                .add(const RoTripListDetailSetStateEvent());
                                                                          } else {
                                                                            if (num.parse(context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .addingTextEditingController
                                                                                    .text) ==
                                                                                0) {
                                                                              context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[index]
                                                                                  .itemsList[i]
                                                                                  .moreQuantityError = false;
                                                                              context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[index]
                                                                                  .itemsList[i]
                                                                                  .addingTextEditingController
                                                                                  .text = "00";
                                                                              context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[index]
                                                                                      .itemsList[i]
                                                                                      .removingTextEditingController
                                                                                      .text =
                                                                                  context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[index]
                                                                                      .itemsList[i]
                                                                                      .returnQty
                                                                                      .toString();
                                                                              context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .add(const RoTripListDetailSetStateEvent());
                                                                            } else {
                                                                              if (num.parse(context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[index]
                                                                                      .itemsList[i]
                                                                                      .addingTextEditingController
                                                                                      .text) <=
                                                                                  num.parse(context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[index]
                                                                                      .itemsList[i]
                                                                                      .returnQty
                                                                                      .toString())) {
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .moreQuantityError = false;
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .addingTextEditingController
                                                                                    .text = num.parse(value).toString();
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .removingTextEditingController
                                                                                    .text = (num.parse(context
                                                                                            .read<RoTripListDetailBloc>()
                                                                                            .selectedReturnItemsData[index]
                                                                                            .itemsList[i]
                                                                                            .returnQty
                                                                                            .toString()) -
                                                                                        num.parse(context
                                                                                            .read<RoTripListDetailBloc>()
                                                                                            .selectedReturnItemsData[index]
                                                                                            .itemsList[i]
                                                                                            .addingTextEditingController
                                                                                            .text))
                                                                                    .toString();
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .add(const RoTripListDetailSetStateEvent());
                                                                              } else {
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .moreQuantityError = true;
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .add(const RoTripListDetailSetStateEvent());
                                                                              }
                                                                            }
                                                                          }
                                                                          context.read<RoTripListDetailBloc>().collectedQuantity = 0;
                                                                          context.read<RoTripListDetailBloc>().unavailableQuantity = 0;
                                                                          for (int i = 0;
                                                                              i < context.read<RoTripListDetailBloc>().selectedReturnItemsData.length;
                                                                              i++) {
                                                                            for (int j = 0;
                                                                                j <
                                                                                    context
                                                                                        .read<RoTripListDetailBloc>()
                                                                                        .selectedReturnItemsData[i]
                                                                                        .itemsList
                                                                                        .length;
                                                                                j++) {
                                                                              context.read<RoTripListDetailBloc>().collectedQuantity =
                                                                                  context.read<RoTripListDetailBloc>().collectedQuantity +
                                                                                      int.parse(context
                                                                                          .read<RoTripListDetailBloc>()
                                                                                          .selectedReturnItemsData[i]
                                                                                          .itemsList[j]
                                                                                          .addingTextEditingController
                                                                                          .text);
                                                                              context.read<RoTripListDetailBloc>().unavailableQuantity =
                                                                                  context.read<RoTripListDetailBloc>().unavailableQuantity +
                                                                                      int.parse(context
                                                                                          .read<RoTripListDetailBloc>()
                                                                                          .selectedReturnItemsData[i]
                                                                                          .itemsList[j]
                                                                                          .removingTextEditingController
                                                                                          .text);
                                                                            }
                                                                          }
                                                                          modelSetState(() {});
                                                                          setState(() {});
                                                                        },
                                                                        keyboardType: TextInputType.number,
                                                                      )),
                                                                      Center(
                                                                        child: InkWell(
                                                                            onTap: () {
                                                                              if (num.parse(context
                                                                                          .read<RoTripListDetailBloc>()
                                                                                          .selectedReturnItemsData[index]
                                                                                          .itemsList[i]
                                                                                          .addingTextEditingController
                                                                                          .text) <
                                                                                      num.parse(context
                                                                                          .read<RoTripListDetailBloc>()
                                                                                          .selectedReturnItemsData[index]
                                                                                          .itemsList[i]
                                                                                          .returnQty
                                                                                          .toString()) &&
                                                                                  num.parse(context
                                                                                          .read<RoTripListDetailBloc>()
                                                                                          .selectedReturnItemsData[index]
                                                                                          .itemsList[i]
                                                                                          .addingTextEditingController
                                                                                          .text) >=
                                                                                      0) {
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .moreQuantityError = false;
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .addingTextEditingController
                                                                                    .text = (num.parse(context
                                                                                            .read<RoTripListDetailBloc>()
                                                                                            .selectedReturnItemsData[index]
                                                                                            .itemsList[i]
                                                                                            .addingTextEditingController
                                                                                            .text) +
                                                                                        1)
                                                                                    .toString();
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .removingTextEditingController
                                                                                    .text = (num.parse(context
                                                                                            .read<RoTripListDetailBloc>()
                                                                                            .selectedReturnItemsData[index]
                                                                                            .itemsList[i]
                                                                                            .returnQty
                                                                                            .toString()) -
                                                                                        num.parse(context
                                                                                            .read<RoTripListDetailBloc>()
                                                                                            .selectedReturnItemsData[index]
                                                                                            .itemsList[i]
                                                                                            .addingTextEditingController
                                                                                            .text))
                                                                                    .toString();
                                                                              } else if (num.parse(context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[index]
                                                                                      .itemsList[i]
                                                                                      .addingTextEditingController
                                                                                      .text) >
                                                                                  num.parse(context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[index]
                                                                                      .itemsList[i]
                                                                                      .returnQty
                                                                                      .toString())) {
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .moreQuantityError = true;
                                                                              }
                                                                              context.read<RoTripListDetailBloc>().collectedQuantity = 0;
                                                                              context.read<RoTripListDetailBloc>().unavailableQuantity = 0;
                                                                              for (int i = 0;
                                                                                  i <
                                                                                      context
                                                                                          .read<RoTripListDetailBloc>()
                                                                                          .selectedReturnItemsData
                                                                                          .length;
                                                                                  i++) {
                                                                                for (int j = 0;
                                                                                    j <
                                                                                        context
                                                                                            .read<RoTripListDetailBloc>()
                                                                                            .selectedReturnItemsData[i]
                                                                                            .itemsList
                                                                                            .length;
                                                                                    j++) {
                                                                                  context.read<RoTripListDetailBloc>().collectedQuantity =
                                                                                      context.read<RoTripListDetailBloc>().collectedQuantity +
                                                                                          int.parse(context
                                                                                              .read<RoTripListDetailBloc>()
                                                                                              .selectedReturnItemsData[i]
                                                                                              .itemsList[j]
                                                                                              .addingTextEditingController
                                                                                              .text);
                                                                                  context.read<RoTripListDetailBloc>().unavailableQuantity =
                                                                                      context.read<RoTripListDetailBloc>().unavailableQuantity +
                                                                                          int.parse(context
                                                                                              .read<RoTripListDetailBloc>()
                                                                                              .selectedReturnItemsData[i]
                                                                                              .itemsList[j]
                                                                                              .removingTextEditingController
                                                                                              .text);
                                                                                }
                                                                              }
                                                                              modelSetState(() {});
                                                                              setState(() {});
                                                                            },
                                                                            child: const Icon(Icons.add, color: Color(0xff007838), size: 14)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 12),
                                                              ),
                                                              Expanded(
                                                                child: Container(
                                                                  height: getIt<Functions>().getWidgetHeight(height: 32),
                                                                  width: getIt<Functions>().getWidgetWidth(width: 32),
                                                                  padding:
                                                                      EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 8)),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(7),
                                                                      border: Border.all(color: const Color(0xffDC474A))),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Center(
                                                                        child: InkWell(
                                                                            onTap: () {
                                                                              if (num.parse(context
                                                                                          .read<RoTripListDetailBloc>()
                                                                                          .selectedReturnItemsData[index]
                                                                                          .itemsList[i]
                                                                                          .removingTextEditingController
                                                                                          .text) >
                                                                                      0 &&
                                                                                  num.parse(context
                                                                                          .read<RoTripListDetailBloc>()
                                                                                          .selectedReturnItemsData[index]
                                                                                          .itemsList[i]
                                                                                          .removingTextEditingController
                                                                                          .text) <=
                                                                                      num.parse(context
                                                                                          .read<RoTripListDetailBloc>()
                                                                                          .selectedReturnItemsData[index]
                                                                                          .itemsList[i]
                                                                                          .returnQty
                                                                                          .toString())) {
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .moreQuantityError = false;
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .removingTextEditingController
                                                                                    .text = (num.parse(context
                                                                                            .read<RoTripListDetailBloc>()
                                                                                            .selectedReturnItemsData[index]
                                                                                            .itemsList[i]
                                                                                            .removingTextEditingController
                                                                                            .text) -
                                                                                        1)
                                                                                    .toString();
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .addingTextEditingController
                                                                                    .text = (num.parse(context
                                                                                            .read<RoTripListDetailBloc>()
                                                                                            .selectedReturnItemsData[index]
                                                                                            .itemsList[i]
                                                                                            .returnQty
                                                                                            .toString()) -
                                                                                        num.parse(context
                                                                                            .read<RoTripListDetailBloc>()
                                                                                            .selectedReturnItemsData[index]
                                                                                            .itemsList[i]
                                                                                            .removingTextEditingController
                                                                                            .text))
                                                                                    .toString();
                                                                              } else if (num.parse(context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[index]
                                                                                      .itemsList[i]
                                                                                      .removingTextEditingController
                                                                                      .text) >
                                                                                  num.parse(context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[index]
                                                                                      .itemsList[i]
                                                                                      .returnQty
                                                                                      .toString())) {
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .moreQuantityError = true;
                                                                              }
                                                                              context.read<RoTripListDetailBloc>().collectedQuantity = 0;
                                                                              context.read<RoTripListDetailBloc>().unavailableQuantity = 0;
                                                                              for (int i = 0;
                                                                                  i <
                                                                                      context
                                                                                          .read<RoTripListDetailBloc>()
                                                                                          .selectedReturnItemsData
                                                                                          .length;
                                                                                  i++) {
                                                                                for (int j = 0;
                                                                                    j <
                                                                                        context
                                                                                            .read<RoTripListDetailBloc>()
                                                                                            .selectedReturnItemsData[i]
                                                                                            .itemsList
                                                                                            .length;
                                                                                    j++) {
                                                                                  context.read<RoTripListDetailBloc>().collectedQuantity =
                                                                                      context.read<RoTripListDetailBloc>().collectedQuantity +
                                                                                          int.parse(context
                                                                                              .read<RoTripListDetailBloc>()
                                                                                              .selectedReturnItemsData[i]
                                                                                              .itemsList[j]
                                                                                              .addingTextEditingController
                                                                                              .text);
                                                                                  context.read<RoTripListDetailBloc>().unavailableQuantity =
                                                                                      context.read<RoTripListDetailBloc>().unavailableQuantity +
                                                                                          int.parse(context
                                                                                              .read<RoTripListDetailBloc>()
                                                                                              .selectedReturnItemsData[i]
                                                                                              .itemsList[j]
                                                                                              .removingTextEditingController
                                                                                              .text);
                                                                                }
                                                                              }
                                                                              modelSetState(() {});
                                                                              setState(() {});
                                                                            },
                                                                            child: const Icon(Icons.remove, color: Color(0xffDC474A), size: 14)),
                                                                      ),
                                                                      Expanded(
                                                                        child: TextFormField(
                                                                          controller: context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .selectedReturnItemsData[index]
                                                                              .itemsList[i]
                                                                              .removingTextEditingController,
                                                                          style: const TextStyle(
                                                                              fontSize: 13.0,
                                                                              color: Color(0xFF282F3A),
                                                                              decoration: TextDecoration.none,
                                                                              fontWeight: FontWeight.w600),
                                                                          textAlign: TextAlign.center,
                                                                          showCursor: false,
                                                                          decoration: InputDecoration(
                                                                            contentPadding: EdgeInsets.only(
                                                                                bottom: getIt<Functions>().getWidgetHeight(height: 18)),
                                                                            focusedBorder: InputBorder.none,
                                                                            enabledBorder: InputBorder.none,
                                                                            border: InputBorder.none,
                                                                          ),
                                                                          onChanged: (value) {
                                                                            if (value.isEmpty) {
                                                                              context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[index]
                                                                                  .itemsList[i]
                                                                                  .moreQuantityError = false;
                                                                              context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .selectedReturnItemsData[index]
                                                                                  .itemsList[i]
                                                                                  .removingTextEditingController
                                                                                  .text = "00";
                                                                              context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[index]
                                                                                      .itemsList[i]
                                                                                      .addingTextEditingController
                                                                                      .text =
                                                                                  context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[index]
                                                                                      .itemsList[i]
                                                                                      .returnQty
                                                                                      .toString();
                                                                              context
                                                                                  .read<RoTripListDetailBloc>()
                                                                                  .add(const RoTripListDetailSetStateEvent());
                                                                            } else {
                                                                              if (num.parse(context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[index]
                                                                                      .itemsList[i]
                                                                                      .removingTextEditingController
                                                                                      .text) ==
                                                                                  0) {
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .moreQuantityError = false;
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .removingTextEditingController
                                                                                    .text = "00";
                                                                                context
                                                                                        .read<RoTripListDetailBloc>()
                                                                                        .selectedReturnItemsData[index]
                                                                                        .itemsList[i]
                                                                                        .addingTextEditingController
                                                                                        .text =
                                                                                    context
                                                                                        .read<RoTripListDetailBloc>()
                                                                                        .selectedReturnItemsData[index]
                                                                                        .itemsList[i]
                                                                                        .returnQty
                                                                                        .toString();
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .add(const RoTripListDetailSetStateEvent());
                                                                              } else {
                                                                                if (num.parse(context
                                                                                        .read<RoTripListDetailBloc>()
                                                                                        .selectedReturnItemsData[index]
                                                                                        .itemsList[i]
                                                                                        .removingTextEditingController
                                                                                        .text) <=
                                                                                    num.parse(context
                                                                                        .read<RoTripListDetailBloc>()
                                                                                        .selectedReturnItemsData[index]
                                                                                        .itemsList[i]
                                                                                        .returnQty
                                                                                        .toString())) {
                                                                                  context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[index]
                                                                                      .itemsList[i]
                                                                                      .moreQuantityError = false;
                                                                                  context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[index]
                                                                                      .itemsList[i]
                                                                                      .removingTextEditingController
                                                                                      .text = num.parse(value).toString();
                                                                                  context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[index]
                                                                                      .itemsList[i]
                                                                                      .addingTextEditingController
                                                                                      .text = (num.parse(context
                                                                                              .read<RoTripListDetailBloc>()
                                                                                              .selectedReturnItemsData[index]
                                                                                              .itemsList[i]
                                                                                              .returnQty
                                                                                              .toString()) -
                                                                                          num.parse(context
                                                                                              .read<RoTripListDetailBloc>()
                                                                                              .selectedReturnItemsData[index]
                                                                                              .itemsList[i]
                                                                                              .removingTextEditingController
                                                                                              .text))
                                                                                      .toString();
                                                                                  context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .add(const RoTripListDetailSetStateEvent());
                                                                                } else {
                                                                                  context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[index]
                                                                                      .itemsList[i]
                                                                                      .moreQuantityError = true;
                                                                                  context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .add(const RoTripListDetailSetStateEvent());
                                                                                }
                                                                              }
                                                                            }
                                                                            context.read<RoTripListDetailBloc>().collectedQuantity = 0;
                                                                            context.read<RoTripListDetailBloc>().unavailableQuantity = 0;
                                                                            for (int i = 0;
                                                                                i <
                                                                                    context
                                                                                        .read<RoTripListDetailBloc>()
                                                                                        .selectedReturnItemsData
                                                                                        .length;
                                                                                i++) {
                                                                              for (int j = 0;
                                                                                  j <
                                                                                      context
                                                                                          .read<RoTripListDetailBloc>()
                                                                                          .selectedReturnItemsData[i]
                                                                                          .itemsList
                                                                                          .length;
                                                                                  j++) {
                                                                                context.read<RoTripListDetailBloc>().collectedQuantity =
                                                                                    context.read<RoTripListDetailBloc>().collectedQuantity +
                                                                                        int.parse(context
                                                                                            .read<RoTripListDetailBloc>()
                                                                                            .selectedReturnItemsData[i]
                                                                                            .itemsList[j]
                                                                                            .addingTextEditingController
                                                                                            .text);
                                                                                context.read<RoTripListDetailBloc>().unavailableQuantity =
                                                                                    context.read<RoTripListDetailBloc>().unavailableQuantity +
                                                                                        int.parse(context
                                                                                            .read<RoTripListDetailBloc>()
                                                                                            .selectedReturnItemsData[i]
                                                                                            .itemsList[j]
                                                                                            .removingTextEditingController
                                                                                            .text);
                                                                              }
                                                                            }
                                                                            modelSetState(() {});
                                                                            setState(() {});
                                                                          },
                                                                          keyboardType: TextInputType.number,
                                                                        ),
                                                                      ),
                                                                      Center(
                                                                        child: InkWell(
                                                                            onTap: () {
                                                                              if (num.parse(context
                                                                                          .read<RoTripListDetailBloc>()
                                                                                          .selectedReturnItemsData[index]
                                                                                          .itemsList[i]
                                                                                          .removingTextEditingController
                                                                                          .text) <
                                                                                      num.parse(context
                                                                                          .read<RoTripListDetailBloc>()
                                                                                          .selectedReturnItemsData[index]
                                                                                          .itemsList[i]
                                                                                          .returnQty
                                                                                          .toString()) &&
                                                                                  num.parse(context
                                                                                          .read<RoTripListDetailBloc>()
                                                                                          .selectedReturnItemsData[index]
                                                                                          .itemsList[i]
                                                                                          .removingTextEditingController
                                                                                          .text) >=
                                                                                      0) {
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .moreQuantityError = false;
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .removingTextEditingController
                                                                                    .text = (num.parse(context
                                                                                            .read<RoTripListDetailBloc>()
                                                                                            .selectedReturnItemsData[index]
                                                                                            .itemsList[i]
                                                                                            .removingTextEditingController
                                                                                            .text) +
                                                                                        1)
                                                                                    .toString();
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .addingTextEditingController
                                                                                    .text = (num.parse(context
                                                                                            .read<RoTripListDetailBloc>()
                                                                                            .selectedReturnItemsData[index]
                                                                                            .itemsList[i]
                                                                                            .returnQty
                                                                                            .toString()) -
                                                                                        num.parse(context
                                                                                            .read<RoTripListDetailBloc>()
                                                                                            .selectedReturnItemsData[index]
                                                                                            .itemsList[i]
                                                                                            .removingTextEditingController
                                                                                            .text))
                                                                                    .toString();
                                                                              } else if (num.parse(context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[index]
                                                                                      .itemsList[i]
                                                                                      .removingTextEditingController
                                                                                      .text) >
                                                                                  num.parse(context
                                                                                      .read<RoTripListDetailBloc>()
                                                                                      .selectedReturnItemsData[index]
                                                                                      .itemsList[i]
                                                                                      .returnQty
                                                                                      .toString())) {
                                                                                context
                                                                                    .read<RoTripListDetailBloc>()
                                                                                    .selectedReturnItemsData[index]
                                                                                    .itemsList[i]
                                                                                    .moreQuantityError = true;
                                                                              }
                                                                              context.read<RoTripListDetailBloc>().collectedQuantity = 0;
                                                                              context.read<RoTripListDetailBloc>().unavailableQuantity = 0;
                                                                              for (int i = 0;
                                                                                  i <
                                                                                      context
                                                                                          .read<RoTripListDetailBloc>()
                                                                                          .selectedReturnItemsData
                                                                                          .length;
                                                                                  i++) {
                                                                                for (int j = 0;
                                                                                    j <
                                                                                        context
                                                                                            .read<RoTripListDetailBloc>()
                                                                                            .selectedReturnItemsData[i]
                                                                                            .itemsList
                                                                                            .length;
                                                                                    j++) {
                                                                                  context.read<RoTripListDetailBloc>().collectedQuantity =
                                                                                      context.read<RoTripListDetailBloc>().collectedQuantity +
                                                                                          int.parse(context
                                                                                              .read<RoTripListDetailBloc>()
                                                                                              .selectedReturnItemsData[i]
                                                                                              .itemsList[j]
                                                                                              .addingTextEditingController
                                                                                              .text);
                                                                                  context.read<RoTripListDetailBloc>().unavailableQuantity =
                                                                                      context.read<RoTripListDetailBloc>().unavailableQuantity +
                                                                                          int.parse(context
                                                                                              .read<RoTripListDetailBloc>()
                                                                                              .selectedReturnItemsData[i]
                                                                                              .itemsList[j]
                                                                                              .removingTextEditingController
                                                                                              .text);
                                                                                }
                                                                              }
                                                                              modelSetState(() {});
                                                                              setState(() {});
                                                                            },
                                                                            child: const Icon(Icons.add, color: Color(0xffDC474A), size: 14)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: getIt<Functions>().getWidgetWidth(width: 12),
                                                              ),
                                                              context
                                                                      .read<RoTripListDetailBloc>()
                                                                      .selectedReturnItemsData[index]
                                                                      .itemsList[i]
                                                                      .podLoader
                                                                  ? Container(
                                                                      height: getIt<Functions>().getWidgetHeight(height: 32),
                                                                      width: getIt<Functions>().getWidgetWidth(width: 32),
                                                                      decoration:
                                                                          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                                      child: const Center(child: CircularProgressIndicator()),
                                                                    )
                                                                  : context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .selectedReturnItemsData[index]
                                                                              .itemsList[i]
                                                                              .proofOfDeliveryImages
                                                                              .length <
                                                                          5
                                                                      ? InkWell(
                                                                          onTap: () {
                                                                            getIt<Variables>().generalVariables.popUpWidget =
                                                                                cameraAlertDialog(customerIndex: index, listIndex: i);
                                                                            getIt<Functions>().showAnimatedDialog(
                                                                                context: context, isFromTop: false, isCloseDisabled: false);
                                                                          },
                                                                          child: Container(
                                                                            height: getIt<Functions>().getWidgetHeight(height: 32),
                                                                            width: getIt<Functions>().getWidgetWidth(width: 32),
                                                                            padding: EdgeInsets.symmetric(
                                                                              horizontal: getIt<Functions>().getWidgetWidth(width: 5),
                                                                              vertical: getIt<Functions>().getWidgetHeight(height: 5),
                                                                            ),
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(7),
                                                                                border: Border.all(color: const Color(0xffD0D2D4))),
                                                                            child: SvgPicture.asset("assets/ro_trip_list/gallery_add.svg"),
                                                                          ),
                                                                        )
                                                                      : Container(
                                                                          height: getIt<Functions>().getWidgetHeight(height: 32),
                                                                          width: getIt<Functions>().getWidgetWidth(width: 32),
                                                                          padding: EdgeInsets.symmetric(
                                                                            horizontal: getIt<Functions>().getWidgetWidth(width: 5),
                                                                            vertical: getIt<Functions>().getWidgetHeight(height: 5),
                                                                          ),
                                                                          decoration: BoxDecoration(
                                                                            color: Colors.grey.shade300,
                                                                            borderRadius: BorderRadius.circular(12),
                                                                          ),
                                                                          child: SvgPicture.asset("assets/ro_trip_list/gallery_add.svg"),
                                                                        ),
                                                            ],
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                          context
                                                              .read<RoTripListDetailBloc>()
                                                              .selectedReturnItemsData[index]
                                                              .itemsList[i]
                                                              .returnQty
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                              color: const Color(0xff007AFF),
                                                              fontWeight: FontWeight.w700)),
                                                      Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.returnQty.toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w500),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: getIt<Functions>().getWidgetHeight(height: 7),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  context.read<RoTripListDetailBloc>().selectedReturnItemsData[index].itemsList[i].moreQuantityError
                                                      ? Text(
                                                          getIt<Variables>().generalVariables.currentLanguage.moreQuantity,
                                                          style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 10), color: Colors.red),
                                                        )
                                                      : const SizedBox()
                                                ],
                                              ),
                                              SizedBox(
                                                height: getIt<Functions>().getWidgetHeight(height: 7),
                                              ),
                                              context
                                                      .read<RoTripListDetailBloc>()
                                                      .selectedReturnItemsData[index]
                                                      .itemsList[i]
                                                      .proofOfDeliveryImages
                                                      .isNotEmpty
                                                  ? SizedBox(
                                                      height: getIt<Functions>().getWidgetHeight(height: 82),
                                                      child: ListView.builder(
                                                          padding: EdgeInsets.zero,
                                                          physics: const BouncingScrollPhysics(),
                                                          scrollDirection: Axis.horizontal,
                                                          itemCount: context
                                                              .read<RoTripListDetailBloc>()
                                                              .selectedReturnItemsData[index]
                                                              .itemsList[i]
                                                              .proofOfDeliveryImages
                                                              .length,
                                                          itemBuilder: (BuildContext context, int imagesIndex) {
                                                            return Stack(
                                                              alignment: Alignment.topRight,
                                                              children: [
                                                                Container(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 82),
                                                                    width: getIt<Functions>().getWidgetWidth(width: 82),
                                                                    margin: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 10)),
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(12),
                                                                    ),
                                                                    clipBehavior: Clip.hardEdge,
                                                                    child: Image.network(
                                                                      context
                                                                          .read<RoTripListDetailBloc>()
                                                                          .selectedReturnItemsData[index]
                                                                          .itemsList[i]
                                                                          .proofOfDeliveryImages[imagesIndex]
                                                                          .imagePath,
                                                                      fit: BoxFit.fill,
                                                                      loadingBuilder: (context, child, loadingProgress) => loadingProgress != null
                                                                          ? Shimmer.fromColors(
                                                                              baseColor: Colors.white24,
                                                                              highlightColor: Colors.grey,
                                                                              child: Container(
                                                                                width: getIt<Functions>().getWidgetWidth(width: 82),
                                                                                decoration: const BoxDecoration(color: Colors.red),
                                                                              ),
                                                                            )
                                                                          : child,
                                                                    )),
                                                                context
                                                                        .read<RoTripListDetailBloc>()
                                                                        .selectedReturnItemsData[index]
                                                                        .itemsList[i]
                                                                        .proofOfDeliveryImages[imagesIndex]
                                                                        .canRemove
                                                                    ? InkWell(
                                                                        onTap: () {
                                                                          context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .selectedReturnItemsData[index]
                                                                              .itemsList[i]
                                                                              .proofOfDeliveryImages[imagesIndex]
                                                                              .canRemove = false;
                                                                          context
                                                                              .read<RoTripListDetailBloc>()
                                                                              .selectedReturnItemsData[index]
                                                                              .itemsList[i]
                                                                              .proofOfDeliveryImages
                                                                              .removeAt(imagesIndex);
                                                                          setState(() {});
                                                                        },
                                                                        child: Container(
                                                                            height: getIt<Functions>().getWidgetHeight(height: 25),
                                                                            width: getIt<Functions>().getWidgetWidth(width: 25),
                                                                            margin: EdgeInsets.only(
                                                                                top: getIt<Functions>().getWidgetHeight(height: 2),
                                                                                right: getIt<Functions>().getWidgetWidth(width: 12)),
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.black26.withOpacity(0.3),
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child: const Icon(Icons.clear, color: Colors.white, size: 15)),
                                                                      )
                                                                    : const SizedBox()
                                                              ],
                                                            );
                                                          }),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        );
                                      })),
                            ),
                            SizedBox(
                              height: getIt<Functions>().getWidgetHeight(height: 7),
                            )
                          ],
                        );
                      }),
                ),
              ],
            );
          },
        );
      }
    });
  }

  Widget cameraAlertDialog({required int customerIndex, required int listIndex}) {
    return BlocConsumer<RoTripListDetailBloc, RoTripListDetailState>(
      listenWhen: (RoTripListDetailState previous, RoTripListDetailState current) {
        return previous != current;
      },
      buildWhen: (RoTripListDetailState previous, RoTripListDetailState current) {
        return previous != current;
      },
      listener: (BuildContext context1, RoTripListDetailState state) {},
      builder: (BuildContext context1, RoTripListDetailState state) {
        return SizedBox(
          width: getIt<Functions>().getWidgetWidth(width: 600),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getIt<Functions>().getWidgetWidth(width: 16), vertical: getIt<Functions>().getWidgetHeight(height: 5)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    try {
                      int maxFiles = context
                              .read<RoTripListDetailBloc>()
                              .selectedReturnItemsData[customerIndex]
                              .itemsList[listIndex]
                              .proofOfDeliveryImages
                              .isEmpty
                          ? 5
                          : 5 -
                              context
                                  .read<RoTripListDetailBloc>()
                                  .selectedReturnItemsData[customerIndex]
                                  .itemsList[listIndex]
                                  .proofOfDeliveryImages
                                  .length;
                      context.read<RoTripListDetailBloc>().selectedReturnItemsData[customerIndex].itemsList[listIndex].podLoader = true;
                      setState(() {});
                      await getIt<Functions>()
                          .uploadImages(
                              source: ImageSource.gallery,
                              maxImages: maxFiles,
                              context: context,
                              function: () {
                                Navigator.pop(context);
                              })
                          .then((data) {
                        if (data.urlsList.isNotEmpty) {
                          for (int i = 0; i < data.urlsList.length; i++) {
                            context
                                .read<RoTripListDetailBloc>()
                                .selectedReturnItemsData[customerIndex]
                                .itemsList[listIndex]
                                .proofOfDeliveryImages
                                .add(ImageDataClass(imageName: data.urlsNameList[i], imagePath: data.urlsList[i], canRemove: true));
                          }
                          context.read<RoTripListDetailBloc>().selectedReturnItemsData[customerIndex].itemsList[listIndex].imagesList = List.generate(
                              context
                                  .read<RoTripListDetailBloc>()
                                  .selectedReturnItemsData[customerIndex]
                                  .itemsList[listIndex]
                                  .proofOfDeliveryImages
                                  .length,
                              (i) => context
                                  .read<RoTripListDetailBloc>()
                                  .selectedReturnItemsData[customerIndex]
                                  .itemsList[listIndex]
                                  .proofOfDeliveryImages[i]
                                  .imageName).join(",");
                          context.read<RoTripListDetailBloc>().selectedReturnItemsData[customerIndex].itemsList[listIndex].podLoader = false;
                          setState(() {});
                        } else {
                          context.read<RoTripListDetailBloc>().selectedReturnItemsData[customerIndex].itemsList[listIndex].podLoader = false;
                          setState(() {});
                        }
                      });
                    } catch (e) {
                      if (mounted) {
                        context.read<RoTripListDetailBloc>().selectedReturnItemsData[customerIndex].itemsList[listIndex].podLoader = false;
                      }
                      setState(() {});
                      if (mounted) {
                        Flushbar(
                          messageText: Text(
                            "${e.toString()}, Please pick any other picture",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                              color: Colors.white,
                            ),
                          ),
                          flushbarPosition: FlushbarPosition.BOTTOM,
                          flushbarStyle: FlushbarStyle.FLOATING,
                          isDismissible: true,
                          duration: const Duration(seconds: 2),
                          margin: EdgeInsets.only(
                              left: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 300 : 15),
                              right: getIt<Functions>().getWidgetWidth(width: 15),
                              bottom: getIt<Functions>().getWidgetHeight(height: 90)),
                          borderRadius: BorderRadius.circular(15),
                          backgroundColor: Colors.black,
                          animationDuration: const Duration(milliseconds: 1000),
                          maxWidth: getIt<Variables>().generalVariables.isDeviceTablet ? 480 : 400,
                        ).show(context);
                      }
                    }
                  },
                  child: SizedBox(
                    height: getIt<Functions>().getWidgetHeight(height: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.image,
                              color: Color(0xff0060B4),
                              size: 25,
                            ),
                            SizedBox(
                              width: getIt<Functions>().getWidgetWidth(width: 12),
                            ),
                            Text(
                              "${getIt<Variables>().generalVariables.currentLanguage.phoneGallery} ",
                              style:
                                  TextStyle(color: Colors.black, fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey.shade500,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    try {
                      int maxFiles = context
                              .read<RoTripListDetailBloc>()
                              .selectedReturnItemsData[customerIndex]
                              .itemsList[listIndex]
                              .proofOfDeliveryImages
                              .isEmpty
                          ? 5
                          : 5 -
                              context
                                  .read<RoTripListDetailBloc>()
                                  .selectedReturnItemsData[customerIndex]
                                  .itemsList[listIndex]
                                  .proofOfDeliveryImages
                                  .length;
                      context.read<RoTripListDetailBloc>().selectedReturnItemsData[customerIndex].itemsList[listIndex].podLoader = true;
                      setState(() {});
                      await getIt<Functions>()
                          .uploadImages(
                              source: ImageSource.camera,
                              maxImages: maxFiles,
                              context: context,
                              function: () {
                                Navigator.pop(context);
                              })
                          .then((data) {
                        if (data.urlsList.isNotEmpty) {
                          for (int i = 0; i < data.urlsList.length; i++) {
                            context
                                .read<RoTripListDetailBloc>()
                                .selectedReturnItemsData[customerIndex]
                                .itemsList[listIndex]
                                .proofOfDeliveryImages
                                .add(ImageDataClass(imageName: data.urlsNameList[i], imagePath: data.urlsList[i], canRemove: true));
                          }
                          context.read<RoTripListDetailBloc>().selectedReturnItemsData[customerIndex].itemsList[listIndex].imagesList = List.generate(
                              context
                                  .read<RoTripListDetailBloc>()
                                  .selectedReturnItemsData[customerIndex]
                                  .itemsList[listIndex]
                                  .proofOfDeliveryImages
                                  .length,
                              (i) => context
                                  .read<RoTripListDetailBloc>()
                                  .selectedReturnItemsData[customerIndex]
                                  .itemsList[listIndex]
                                  .proofOfDeliveryImages[i]
                                  .imageName).join(",");
                          context.read<RoTripListDetailBloc>().selectedReturnItemsData[customerIndex].itemsList[listIndex].podLoader = false;
                          setState(() {});
                        } else {
                          context.read<RoTripListDetailBloc>().selectedReturnItemsData[customerIndex].itemsList[listIndex].podLoader = false;
                          setState(() {});
                        }
                      });
                    } catch (e) {
                      if (mounted) {
                        context.read<RoTripListDetailBloc>().selectedReturnItemsData[customerIndex].itemsList[listIndex].podLoader = false;
                      }
                      setState(() {});
                      if (mounted) {
                        Flushbar(
                          messageText: Text(
                            "${e.toString()}, Please pick any other picture",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                              color: Colors.white,
                            ),
                          ),
                          flushbarPosition: FlushbarPosition.BOTTOM,
                          flushbarStyle: FlushbarStyle.FLOATING,
                          isDismissible: true,
                          duration: const Duration(seconds: 2),
                          margin: EdgeInsets.only(
                              left: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 300 : 15),
                              right: getIt<Functions>().getWidgetWidth(width: 15),
                              bottom: getIt<Functions>().getWidgetHeight(height: 90)),
                          borderRadius: BorderRadius.circular(15),
                          backgroundColor: Colors.black,
                          animationDuration: const Duration(milliseconds: 1000),
                          maxWidth: getIt<Variables>().generalVariables.isDeviceTablet ? 480 : 400,
                        ).show(context);
                      }
                    }
                  },
                  child: SizedBox(
                    height: getIt<Functions>().getWidgetHeight(height: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.camera_alt,
                              color: Colors.green,
                              size: 25,
                            ),
                            SizedBox(
                              width: getIt<Functions>().getWidgetWidth(width: 12),
                            ),
                            Text(
                              "${getIt<Variables>().generalVariables.currentLanguage.camera} ",
                              style:
                                  TextStyle(color: Colors.black, fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey.shade500,
                          size: 15,
                        ),
                      ],
                    ),
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

class TotalReturnsDataModel {
  String customer;
  int totalQty;
  List<ItemsList> itemsList;

  TotalReturnsDataModel({
    required this.customer,
    required this.totalQty,
    required this.itemsList,
  });

  factory TotalReturnsDataModel.fromJson(Map<String, dynamic> json) => TotalReturnsDataModel(
        customer: json["customer_name"] ?? "",
        totalQty: json["total_qty"] ?? 0,
        itemsList: List<ItemsList>.from((json["items_list"] ?? []).map((x) => ItemsList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "customer": customer,
        "total_qty": totalQty,
        "items_list": List<dynamic>.from(itemsList.map((x) => x.toJson())),
      };
}

class ItemsList {
  String lineItemId;
  String itemId;
  String itemCode;
  String itemName;
  int returnQty;
  String imagesList;
  TextEditingController addingTextEditingController;
  TextEditingController removingTextEditingController;
  bool moreQuantityError;
  bool podLoader;
  List<ImageDataClass> proofOfDeliveryImages;

  ItemsList({
    required this.lineItemId,
    required this.itemId,
    required this.itemCode,
    required this.itemName,
    required this.returnQty,
    required this.imagesList,
    required this.addingTextEditingController,
    required this.removingTextEditingController,
    required this.moreQuantityError,
    required this.podLoader,
    required this.proofOfDeliveryImages,
  });

  factory ItemsList.fromJson(Map<String, dynamic> json) => ItemsList(
        lineItemId: json["id"] ?? "",
        itemId: json["item_id"] ?? "",
        itemCode: json["item_code"] ?? "",
        itemName: json["item_name"] ?? "",
        returnQty: getIt<Functions>()
            .quantityValue(quantity: json["quantity"], returnQuantity: json["return_qty"], tripReturnStatus: json['return_status'] ?? ""),
        imagesList: json["return_proof"] ?? "",
        addingTextEditingController: json["add_controller"] ?? TextEditingController(),
        removingTextEditingController: json["remove_controller"] ?? TextEditingController(),
        moreQuantityError: json["more_quantity_error"] ?? false,
        podLoader: json["pod_loader"] ?? false,
        proofOfDeliveryImages: List<ImageDataClass>.from((json["proof_of_delivery_images"] ?? []).map((x) => ImageDataClass.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": lineItemId,
        "item_id": itemId,
        "item_code": itemCode,
        "item_name": itemName,
        "quantity": returnQty,
        "return_proof": imagesList,
        "add_controller": addingTextEditingController,
        "remove_controller": removingTextEditingController,
        "more_quantity_error": moreQuantityError,
        "pod_loader": podLoader,
        "proof_of_delivery_images": proofOfDeliveryImages,
      };
}
