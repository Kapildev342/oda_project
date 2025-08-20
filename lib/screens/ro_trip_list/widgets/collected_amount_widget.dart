// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oda/bloc/ro_trip_list/ro_trip_list_detail/ro_trip_list_detail_bloc.dart';
import 'package:oda/edited_packages/data_table_library/data_table_2.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/resources/widgets.dart';

class CollectedAmountWidget extends StatefulWidget {
  static const String id = "collected_amount_widget";
  const CollectedAmountWidget({super.key});

  @override
  State<CollectedAmountWidget> createState() => _CollectedAmountWidgetState();
}

class _CollectedAmountWidgetState extends State<CollectedAmountWidget> {
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
          listener: (BuildContext context, RoTripListDetailState state) {
            if (state is RoTripListDetailSuccess) {
              context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
              context.read<RoTripListDetailBloc>().updateLoader = false;
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is RoTripListDetailFailure) {
              context.read<RoTripListDetailBloc>().updateLoader = false;
              context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
            }
            if (state is RoTripListDetailError) {
              context.read<RoTripListDetailBloc>().updateLoader = false;
              context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
              ScaffoldMessenger.of(context).clearSnackBars();
              getIt<Widgets>().flushBarWidget(context: context, message: state.message);
            }
          },
          builder: (BuildContext context, RoTripListDetailState state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                  child: Text(
                    getIt<Variables>().generalVariables.currentLanguage.amountSummary.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: 12),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: context.read<RoTripListDetailBloc>().selectedAmountSummaryData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: EdgeInsets.symmetric(
                              horizontal: getIt<Functions>().getWidgetWidth(width: 24), vertical: getIt<Functions>().getWidgetHeight(height: 24)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 40),
                                        width: getIt<Functions>().getWidgetWidth(width: 40),
                                        child: SvgPicture.asset("assets/ro_trip_list/amount_summary.svg"),
                                      ),
                                      SizedBox(
                                        width: getIt<Functions>().getWidgetWidth(width: 12),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].customer,
                                              style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xff282F3A))),
                                          RichText(
                                            text: TextSpan(
                                              text: "${getIt<Variables>().generalVariables.currentLanguage.totalAmount.toUpperCase()}  :  ",
                                              style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                  color: const Color(0xff282F3A),
                                                  fontWeight: FontWeight.w400),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        "RS. ${context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].totalAmount}  |  ",
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                        color: const Color(0xff007AFF),
                                                        fontWeight: FontWeight.w700)),
                                                TextSpan(
                                                    text: "${getIt<Variables>().generalVariables.currentLanguage.collectedAmount.toUpperCase()}  :  ",
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                        color: const Color(0xff282F3A),
                                                        fontWeight: FontWeight.w400)),
                                                TextSpan(
                                                    text:
                                                        "RS. ${context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].collectedAmount} ",
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                        color: const Color(0xff007AFF),
                                                        fontWeight: FontWeight.w700)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  context.read<RoTripListDetailBloc>().updateLoader
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
                                          //style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, backgroundColor: selectedData[index].isUpdated ? const Color(0xff29B473) : const Color(0xff007AFF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                                          onTap: context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].isUpdated
                                              ? () {}
                                              : () {
                                                  context.read<RoTripListDetailBloc>().updateLoader = true;
                                                  context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                                                  context.read<RoTripListDetailBloc>().selectedCollectedAmountInvoicesList.clear();
                                                  for (int i = 0;
                                                      i <
                                                          context
                                                              .read<RoTripListDetailBloc>()
                                                              .selectedAmountSummaryData[index]
                                                              .collectedItemsList
                                                              .length;
                                                      i++) {
                                                    context.read<RoTripListDetailBloc>().selectedCollectedAmountInvoicesList.add({
                                                      "invoice_id": context
                                                          .read<RoTripListDetailBloc>()
                                                          .selectedAmountSummaryData[index]
                                                          .collectedItemsList[i]
                                                          .invoiceId,
                                                      "amount": context
                                                          .read<RoTripListDetailBloc>()
                                                          .selectedAmountSummaryData[index]
                                                          .collectedItemsList[i]
                                                          .receivedAmountController
                                                          .text
                                                    });
                                                  }
                                                  context.read<RoTripListDetailBloc>().add(const RoTripListDetailUpdateCollectedAmountEvent());
                                                },
                                          child: Container(
                                            height: getIt<Functions>().getWidgetHeight(height: 35),
                                            width: getIt<Functions>().getWidgetWidth(width: 100),
                                            decoration: BoxDecoration(
                                                color: context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].isUpdated
                                                    ? const Color(0xff29B473)
                                                    : const Color(0xff007AFF),
                                                borderRadius: BorderRadius.circular(6)),
                                            child: Center(
                                              child: Text(
                                                context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].isUpdated
                                                    ? getIt<Variables>().generalVariables.currentLanguage.updated.toUpperCase()
                                                    : getIt<Variables>().generalVariables.currentLanguage.update.toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ))
                                ],
                              ),
                              SizedBox(
                                height: getIt<Functions>().getWidgetHeight(height: 23),
                              ),
                              Scrollbar(
                                child: Container(
                                  height: getIt<Functions>().getWidgetHeight(
                                      height: (context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].collectedItemsList.length >= 4
                                              ? 160
                                              : context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].collectedItemsList.length *
                                                  40) +
                                          50),
                                  padding: EdgeInsets.zero,
                                  child: DataTable2(
                                      columnSpacing: getIt<Functions>().getWidgetWidth(width: 0),
                                      horizontalMargin: getIt<Functions>().getWidgetWidth(width: 15),
                                      headingRowColor: const WidgetStatePropertyAll<Color>(Color(0xffE0E7EC)),
                                      headingRowDecoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                                      headingRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                                      dividerThickness: 0,
                                      dataRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                                      isHorizontalScrollBarVisible: false,
                                      columns: [
                                        DataColumn2(
                                          label: Center(
                                            child: Text(
                                              "${getIt<Variables>().generalVariables.currentLanguage.invoice.toLowerCase().replaceFirst('i', "I")} #",
                                              style: TextStyle(
                                                  color: const Color(0xff282F3A),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: getIt<Functions>()
                                                      .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                            ),
                                          ),
                                          size: ColumnSize.M,
                                        ),
                                        DataColumn2(
                                          label: Center(
                                            child: Text(
                                              getIt<Variables>().generalVariables.currentLanguage.totalItems,
                                              style: TextStyle(
                                                  color: const Color(0xff282F3A),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: getIt<Functions>()
                                                      .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                            ),
                                          ),
                                          size: ColumnSize.L,
                                        ),
                                        DataColumn2(
                                          label: Center(
                                            child: Text(
                                              getIt<Variables>().generalVariables.currentLanguage.collectedAmount,
                                              style: TextStyle(
                                                  color: const Color(0xff282F3A),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: getIt<Functions>()
                                                      .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                            ),
                                          ),
                                          size: ColumnSize.L,
                                        ),
                                        DataColumn2(
                                          label: Center(
                                            child: Text(
                                              getIt<Variables>().generalVariables.currentLanguage.receivedAmount,
                                              style: TextStyle(
                                                  color: const Color(0xff282F3A),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                            ),
                                          ),
                                          size: ColumnSize.L,
                                        ),
                                      ],
                                      rows: List<DataRow>.generate(
                                          context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].collectedItemsList.length, (i) {
                                        return DataRow(cells: [
                                          DataCell(Center(
                                            child: Text(
                                                context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].collectedItemsList[i].invoiceNo,
                                                style: TextStyle(
                                                    color: const Color(0xff282F3A),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: getIt<Functions>()
                                                        .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11))),
                                          )),
                                          DataCell(Center(
                                            child: Text(
                                                context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].collectedItemsList[i].totalItem,
                                                style: TextStyle(
                                                    color: const Color(0xff282F3A),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: getIt<Functions>()
                                                        .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11))),
                                          )),
                                          DataCell(Center(
                                            child: Text(
                                                "RS. ${context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].collectedItemsList[i].collectedAmount}",
                                                style: TextStyle(
                                                    color: const Color(0xff282F3A),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: getIt<Functions>()
                                                        .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11))),
                                          )),
                                          DataCell(Container(
                                            padding: const EdgeInsets.symmetric(vertical: 5),
                                            child: Center(
                                              child: TextFormField(
                                                controller: context
                                                    .read<RoTripListDetailBloc>()
                                                    .selectedAmountSummaryData[index]
                                                    .collectedItemsList[i]
                                                    .receivedAmountController,
                                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                readOnly: context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].isUpdated,
                                                style: TextStyle(
                                                    color: const Color(0xff282F3A),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: getIt<Functions>()
                                                        .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                                onChanged: (value) {
                                                  num totalReceivedValue = 0.0;
                                                  for (int j = 0;
                                                      j <
                                                          context
                                                              .read<RoTripListDetailBloc>()
                                                              .selectedAmountSummaryData[index]
                                                              .collectedItemsList
                                                              .length;
                                                      j++) {
                                                    totalReceivedValue = totalReceivedValue +
                                                        num.parse(context
                                                            .read<RoTripListDetailBloc>()
                                                            .selectedAmountSummaryData[index]
                                                            .collectedItemsList[j]
                                                            .receivedAmountController
                                                            .text);
                                                  }
                                                  context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].totalReceivedAmount =
                                                      totalReceivedValue.toString();
                                                  context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.zero,
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xffE0E7EC))),
                                                  disabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xffE0E7EC))),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xffE0E7EC))),
                                                  errorBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xffE0E7EC))),
                                                  focusedErrorBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xffE0E7EC))),
                                                  prefixIcon: SizedBox(
                                                      width: getIt<Functions>().getWidgetWidth(width: 30), child: const Center(child: Text("Rs."))),
                                                ),
                                              ),
                                              /*Container(
                                                height: getIt<Functions>().getWidgetHeight(height: 30),
                                                width: getIt<Functions>().getWidgetWidth(width: 140),
                                                padding: EdgeInsets.only(
                                                    left: getIt<Functions>().getWidgetWidth(width: 15),
                                                    top: getIt<Functions>().getWidgetHeight(height: 3),
                                                    bottom: getIt<Functions>().getWidgetHeight(height: 3)),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(3), border: Border.all(color: const Color(0xffE0E7EC))),
                                                child: Text("RS. ${selectedData[index].collectedItemsList[i].receivedAmount}",
                                                    style: TextStyle(
                                                        color: const Color(0xff282F3A),
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: getIt<Functions>()
                                                            .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11))),
                                              )*/
                                            ),
                                          )),
                                        ]);
                                      })),
                                ),
                              ),
                              Divider(color: const Color(0xffBFC1C4).withOpacity(0.73), thickness: 0.5),
                              SizedBox(
                                height: getIt<Functions>().getWidgetHeight(height: 20),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(getIt<Variables>().generalVariables.currentLanguage.totalReceivedAmount.toUpperCase(),
                                      style: TextStyle(
                                          color: const Color(0xff282F3A),
                                          fontWeight: FontWeight.w500,
                                          fontSize: getIt<Functions>()
                                              .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 10))),
                                  SizedBox(
                                    width: getIt<Functions>().getWidgetWidth(width: 12),
                                  ),
                                  Container(
                                    height: getIt<Functions>().getWidgetHeight(height: 30),
                                    width: getIt<Functions>().getWidgetWidth(width: 140),
                                    padding: EdgeInsets.only(
                                        left: getIt<Functions>().getWidgetWidth(width: 15),
                                        top: getIt<Functions>().getWidgetHeight(height: 3),
                                        bottom: getIt<Functions>().getWidgetHeight(height: 3)),
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(3), border: Border.all(color: const Color(0xffE0E7EC))),
                                    child: Text("RS. ${context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].totalReceivedAmount}",
                                        style: TextStyle(
                                            color: const Color(0xff282F3A),
                                            fontWeight: FontWeight.w500,
                                            fontSize: getIt<Functions>()
                                                .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 10))),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: getIt<Functions>().getWidgetHeight(height: 20),
                              ),
                            ],
                          ),
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
          listener: (BuildContext context, RoTripListDetailState state) {
            if (state is RoTripListDetailSuccess) {
              context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
              context.read<RoTripListDetailBloc>().updateLoader = false;
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is RoTripListDetailFailure) {
              context.read<RoTripListDetailBloc>().updateLoader = false;
              context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
            }
            if (state is RoTripListDetailError) {
              context.read<RoTripListDetailBloc>().updateLoader = false;
              context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
              ScaffoldMessenger.of(context).clearSnackBars();
              getIt<Widgets>().flushBarWidget(context: context, message: state.message);
            }
          },
          builder: (BuildContext context, RoTripListDetailState state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 15)),
                  child: Text(
                    getIt<Variables>().generalVariables.currentLanguage.amountSummary.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: getIt<Functions>().getWidgetHeight(height: 12),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 15)),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: context.read<RoTripListDetailBloc>().selectedAmountSummaryData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: EdgeInsets.symmetric(
                              horizontal: getIt<Functions>().getWidgetWidth(width: 12), vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 24),
                                        width: getIt<Functions>().getWidgetWidth(width: 24),
                                        child: SvgPicture.asset("assets/ro_trip_list/amount_summary.svg"),
                                      ),
                                      SizedBox(
                                        width: getIt<Functions>().getWidgetWidth(width: 8),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: getIt<Functions>().getWidgetWidth(width: 315),
                                            child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Text(context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].customer,
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                        fontWeight: FontWeight.w600,
                                                        color: const Color(0xff282F3A)))),
                                          ),
                                          SizedBox(
                                            width: getIt<Variables>().generalVariables.width / 1.3,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        text: "${getIt<Variables>().generalVariables.currentLanguage.totalAmount.toUpperCase()}  :  ",
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w400),
                                                        children: [
                                                          TextSpan(
                                                              text:
                                                                  "RS. ${context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].totalAmount} ",
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                  color: const Color(0xff007AFF),
                                                                  fontWeight: FontWeight.w700)),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: getIt<Functions>().getWidgetHeight(height: 8),
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        text:
                                                            "${getIt<Variables>().generalVariables.currentLanguage.collectedAmount.toUpperCase()}  :  ",
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w400),
                                                        children: [
                                                          TextSpan(
                                                              text:
                                                                  "RS. ${context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].collectedAmount} ",
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                  color: const Color(0xff007AFF),
                                                                  fontWeight: FontWeight.w700)),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: getIt<Functions>().getWidgetHeight(height: 8),
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        text:
                                                            "${getIt<Variables>().generalVariables.currentLanguage.receivedAmount.toUpperCase()}  :  ",
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                            color: const Color(0xff282F3A),
                                                            fontWeight: FontWeight.w400),
                                                        children: [
                                                          TextSpan(
                                                              text:
                                                                  "RS. ${context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].totalReceivedAmount}    ",
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                  color: const Color(0xff29B473),
                                                                  fontWeight: FontWeight.w700)),
                                                          /* TextSpan(
                                                              text: selectedData[index].isUpdated ? "${getIt<Variables>().generalVariables.currentLanguage.updated.toUpperCase()} " : "${getIt<Variables>().generalVariables.currentLanguage.update.toUpperCase()} ",
                                                              style: TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 10), color: selectedData[index].isUpdated ? const Color(0xff29B473) : Colors.red, fontWeight: FontWeight.w700, decoration: TextDecoration.underline)),*/
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                context.read<RoTripListDetailBloc>().updateLoader
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
                                                    : ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            padding: EdgeInsets.zero,
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                            maximumSize: Size(getIt<Functions>().getWidgetWidth(width: 100),
                                                                getIt<Functions>().getWidgetHeight(height: 30)),
                                                            minimumSize: Size(getIt<Functions>().getWidgetWidth(width: 100),
                                                                getIt<Functions>().getWidgetHeight(height: 30)),
                                                            backgroundColor:
                                                                context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].isUpdated
                                                                    ? const Color(0xff29B473)
                                                                    : const Color(0xff007AFF)),
                                                        onPressed: context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].isUpdated
                                                            ? () {}
                                                            : () {
                                                                context.read<RoTripListDetailBloc>().updateLoader = true;
                                                                context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                                                                context.read<RoTripListDetailBloc>().selectedCollectedAmountInvoicesList.clear();
                                                                for (int i = 0;
                                                                    i <
                                                                        context
                                                                            .read<RoTripListDetailBloc>()
                                                                            .selectedAmountSummaryData[index]
                                                                            .collectedItemsList
                                                                            .length;
                                                                    i++) {
                                                                  context.read<RoTripListDetailBloc>().selectedCollectedAmountInvoicesList.add({
                                                                    "invoice_id": context
                                                                        .read<RoTripListDetailBloc>()
                                                                        .selectedAmountSummaryData[index]
                                                                        .collectedItemsList[i]
                                                                        .invoiceId,
                                                                    "amount": context
                                                                        .read<RoTripListDetailBloc>()
                                                                        .selectedAmountSummaryData[index]
                                                                        .collectedItemsList[i]
                                                                        .receivedAmountController
                                                                        .text
                                                                  });
                                                                }
                                                                context
                                                                    .read<RoTripListDetailBloc>()
                                                                    .add(const RoTripListDetailUpdateCollectedAmountEvent());
                                                              },
                                                        child: Text(
                                                          context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].isUpdated
                                                              ? "${getIt<Variables>().generalVariables.currentLanguage.updated.toUpperCase()} "
                                                              : "${getIt<Variables>().generalVariables.currentLanguage.update.toUpperCase()} ",
                                                          style: TextStyle(
                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                              color: const Color(0xffffffff),
                                                              fontWeight: FontWeight.w700),
                                                        ))
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: getIt<Functions>().getWidgetHeight(height: 23),
                              ),
                              Scrollbar(
                                child: Container(
                                  height: getIt<Functions>().getWidgetHeight(
                                      height: (context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].collectedItemsList.length >= 4
                                              ? 160
                                              : context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].collectedItemsList.length *
                                                  40) +
                                          50),
                                  padding: EdgeInsets.zero,
                                  child: DataTable2(
                                      columnSpacing: getIt<Functions>().getWidgetWidth(width: 0),
                                      horizontalMargin: getIt<Functions>().getWidgetWidth(width: 15),
                                      headingRowColor: const WidgetStatePropertyAll<Color>(Color(0xffE0E7EC)),
                                      headingRowDecoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                                      headingRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                                      dividerThickness: 0,
                                      dataRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                                      isHorizontalScrollBarVisible: false,
                                      columns: [
                                        DataColumn2(
                                          label: Text(
                                            "${getIt<Variables>().generalVariables.currentLanguage.invoice.toLowerCase().replaceFirst('i', "I")} #",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: const Color(0xff282F3A),
                                                fontWeight: FontWeight.w700,
                                                fontSize: getIt<Functions>()
                                                    .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                          ),
                                          size: ColumnSize.M,
                                        ),
                                        DataColumn2(
                                          label: Center(
                                            child: Text(
                                              getIt<Variables>().generalVariables.currentLanguage.totalItems,
                                              maxLines: 2,
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: const Color(0xff282F3A),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: getIt<Functions>()
                                                      .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                            ),
                                          ),
                                          size: ColumnSize.M,
                                        ),
                                        DataColumn2(
                                          label: Text(
                                            getIt<Variables>().generalVariables.currentLanguage.collectedAmount,
                                            maxLines: 2,
                                            softWrap: true,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: const Color(0xff282F3A),
                                                fontWeight: FontWeight.w700,
                                                fontSize: getIt<Functions>()
                                                    .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                          ),
                                          size: ColumnSize.L,
                                        ),
                                        DataColumn2(
                                          label: Text(
                                            getIt<Variables>().generalVariables.currentLanguage.receivedAmount,
                                            maxLines: 2,
                                            softWrap: true,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: const Color(0xff282F3A),
                                                fontWeight: FontWeight.w700,
                                                fontSize: getIt<Functions>()
                                                    .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                          ),
                                          size: ColumnSize.L,
                                        ),
                                      ],
                                      rows: List<DataRow>.generate(
                                          context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].collectedItemsList.length, (i) {
                                        return DataRow(cells: [
                                          DataCell(Text(
                                              context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].collectedItemsList[i].invoiceNo,
                                              style: TextStyle(
                                                  color: const Color(0xff282F3A),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getIt<Functions>()
                                                      .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 10)))),
                                          DataCell(Center(
                                              child: Text(
                                                  context
                                                      .read<RoTripListDetailBloc>()
                                                      .selectedAmountSummaryData[index]
                                                      .collectedItemsList[i]
                                                      .totalItem,
                                                  style: TextStyle(
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: getIt<Functions>()
                                                          .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 10))))),
                                          DataCell(Text(
                                              "RS. ${context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].collectedItemsList[i].collectedAmount}",
                                              style: TextStyle(
                                                  color: const Color(0xff282F3A),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getIt<Functions>()
                                                      .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 10)))),
                                          DataCell(Container(
                                            padding: const EdgeInsets.symmetric(vertical: 5),
                                            child: Center(
                                              child: TextFormField(
                                                controller: context
                                                    .read<RoTripListDetailBloc>()
                                                    .selectedAmountSummaryData[index]
                                                    .collectedItemsList[i]
                                                    .receivedAmountController,
                                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                readOnly: context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].isUpdated,
                                                style: TextStyle(
                                                    color: const Color(0xff282F3A),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 11)),
                                                onChanged: (value) {
                                                  num totalReceivedValue = 0.0;
                                                  for (int j = 0;
                                                      j <
                                                          context
                                                              .read<RoTripListDetailBloc>()
                                                              .selectedAmountSummaryData[index]
                                                              .collectedItemsList
                                                              .length;
                                                      j++) {
                                                    totalReceivedValue = totalReceivedValue +
                                                        num.parse(context
                                                            .read<RoTripListDetailBloc>()
                                                            .selectedAmountSummaryData[index]
                                                            .collectedItemsList[j]
                                                            .receivedAmountController
                                                            .text);
                                                  }
                                                  context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].totalReceivedAmount =
                                                      totalReceivedValue.toString();
                                                  context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 8)),
                                                  border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xffE0E7EC))),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xffE0E7EC))),
                                                  disabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xffE0E7EC))),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xffE0E7EC))),
                                                  errorBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xffE0E7EC))),
                                                  focusedErrorBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xffE0E7EC))),
                                                  prefix: Text("Rs. ",style: TextStyle(
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 11)),),
                                                ),
                                              ),
                                              /*Container(
                                                height: getIt<Functions>().getWidgetHeight(height: 30),
                                                width: getIt<Functions>().getWidgetWidth(width: 140),
                                                padding: EdgeInsets.only(
                                                    left: getIt<Functions>().getWidgetWidth(width: 15),
                                                    top: getIt<Functions>().getWidgetHeight(height: 3),
                                                    bottom: getIt<Functions>().getWidgetHeight(height: 3)),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(3), border: Border.all(color: const Color(0xffE0E7EC))),
                                                child: Text("RS. ${selectedData[index].collectedItemsList[i].receivedAmount}",
                                                    style: TextStyle(
                                                        color: const Color(0xff282F3A),
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: getIt<Functions>()
                                                            .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11))),
                                              )*/
                                            ),
                                          )
                                              /*Container(
                                            height: getIt<Functions>().getWidgetHeight(height: 30),
                                            width: getIt<Functions>().getWidgetWidth(width: 140),
                                            padding: EdgeInsets.only(
                                                left: getIt<Functions>().getWidgetWidth(width: 15),
                                                top: getIt<Functions>().getWidgetHeight(height: 3),
                                                bottom: getIt<Functions>().getWidgetHeight(height: 3)),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(3), border: Border.all(color: const Color(0xffE0E7EC))),
                                            child: Text(
                                                "RS. ${context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].collectedItemsList[i].receivedAmountController}",
                                                style: TextStyle(
                                                    color: const Color(0xff282F3A),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: getIt<Functions>()
                                                        .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 10))),
                                          )*/
                                              ),
                                        ]);
                                      })),
                                ),
                              ),
                              Divider(color: const Color(0xffBFC1C4).withOpacity(0.73), thickness: 0.5),
                              SizedBox(
                                height: getIt<Functions>().getWidgetHeight(height: 8),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(getIt<Variables>().generalVariables.currentLanguage.totalReceivedAmount.toUpperCase(),
                                      style: TextStyle(
                                          color: const Color(0xff282F3A),
                                          fontWeight: FontWeight.w500,
                                          fontSize: getIt<Functions>()
                                              .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 10))),
                                  SizedBox(
                                    width: getIt<Functions>().getWidgetWidth(width: 12),
                                  ),
                                  Container(
                                    height: getIt<Functions>().getWidgetHeight(height: 30),
                                    width: getIt<Functions>().getWidgetWidth(width: 140),
                                    padding: EdgeInsets.only(
                                        left: getIt<Functions>().getWidgetWidth(width: 15),
                                        top: getIt<Functions>().getWidgetHeight(height: 3),
                                        bottom: getIt<Functions>().getWidgetHeight(height: 3)),
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(3), border: Border.all(color: const Color(0xffE0E7EC))),
                                    child: Text("RS. ${context.read<RoTripListDetailBloc>().selectedAmountSummaryData[index].totalReceivedAmount}",
                                        style: TextStyle(
                                            color: const Color(0xff282F3A),
                                            fontWeight: FontWeight.w500,
                                            fontSize: getIt<Functions>()
                                                .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 10))),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: getIt<Functions>().getWidgetHeight(height: 8),
                              ),
                            ],
                          ),
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
}

class TotalCollectedDataModel {
  String customer;
  String totalAmount;
  String collectedAmount;
  String totalReceivedAmount;
  bool isUpdated;
  List<CollectedItemsList> collectedItemsList;

  TotalCollectedDataModel({
    required this.customer,
    required this.totalAmount,
    required this.collectedAmount,
    required this.isUpdated,
    required this.totalReceivedAmount,
    required this.collectedItemsList,
  });

  factory TotalCollectedDataModel.fromJson(Map<String, dynamic> json) => TotalCollectedDataModel(
        customer: json["customer_name"] ?? "",
        totalAmount: json["stop_invoice_total"] ?? "",
        collectedAmount: json["stop_collected_total"] ?? "",
        totalReceivedAmount: json["stop_received_total"] ?? "",
        isUpdated: json["received_amount_status"] ?? false,
        collectedItemsList: List.from((json["invoices"] ?? []).map((x) => CollectedItemsList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "customer_name": customer,
        "stop_invoice_total": totalAmount,
        "stop_collected_total": collectedAmount,
        "stop_received_total": totalReceivedAmount,
        "received_amount_status": isUpdated,
        "invoices": List<dynamic>.from(collectedItemsList.map((x) => x.toJson())),
      };
}

class CollectedItemsList {
  String invoiceId;
  String invoiceNo;
  String totalItem;
  String collectedAmount;
  TextEditingController receivedAmountController;

  CollectedItemsList({
    required this.invoiceId,
    required this.invoiceNo,
    required this.totalItem,
    required this.collectedAmount,
    required this.receivedAmountController,
  });

  factory CollectedItemsList.fromJson(Map<String, dynamic> json) {
    return CollectedItemsList(
      invoiceId: json["invoice_id"] ?? "",
      invoiceNo: json["invoice_num"] ?? "",
      totalItem: (json["total_items"] ?? "").toString(),
      collectedAmount: json["collected_amount"] ?? "",
      receivedAmountController: json["received_amt_controller"] ?? TextEditingController(text: json["received_amount"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "invoice_id": invoiceNo,
        "invoice_num": invoiceNo,
        "total_items": totalItem,
        "collected_amount": collectedAmount,
        "received_amt_controller": receivedAmountController,
      };
}
