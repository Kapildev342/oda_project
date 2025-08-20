// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oda/bloc/ro_trip_list/ro_trip_list_detail/ro_trip_list_detail_bloc.dart';
import 'package:oda/edited_packages/data_table_library/data_table_2.dart';
import 'package:oda/repository_model/ro_trip_list/ro_trip_expenses_model.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/resources/widgets.dart';

class TotalExpensesWidget extends StatefulWidget {
  static const String id = "total_expenses_widget";
  const TotalExpensesWidget({super.key});

  @override
  State<TotalExpensesWidget> createState() => _TotalExpensesWidgetState();
}

class _TotalExpensesWidgetState extends State<TotalExpensesWidget> {
  TextEditingController reasonSearchFieldController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController expenseAmountBar = TextEditingController();

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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        getIt<Variables>().generalVariables.currentLanguage.totalExpenses.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: const Color(0xff007AFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            maximumSize: Size(getIt<Functions>().getWidgetWidth(width: 100), getIt<Functions>().getWidgetHeight(height: 30)),
                            minimumSize: Size(getIt<Functions>().getWidgetWidth(width: 100), getIt<Functions>().getWidgetHeight(height: 30)),
                          ),
                          onPressed: () {
                            getIt<Variables>().generalVariables.popUpWidget = addNewContent(contextNew: context);
                            getIt<Functions>().showAnimatedDialog(context: context, isFromTop: true, isCloseDisabled: false);
                          },
                          child: Text(
                            getIt<Variables>().generalVariables.currentLanguage.addNew.toUpperCase(),
                            style:
                                TextStyle(fontSize: getIt<Functions>().getTextSize(fontSize: 12), fontWeight: FontWeight.w400, color: Colors.white),
                          ))
                    ],
                  ),
                ),
                Container(
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
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(
                            height: context.read<RoTripListDetailBloc>().roTripExpensesModel.response.expensesList.isEmpty ? 50 : 500),
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
                                  getIt<Variables>().generalVariables.currentLanguage.sNo,
                                  style: TextStyle(
                                      color: const Color(0xff282F3A),
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                ),
                                size: ColumnSize.S,
                              ),
                              DataColumn2(
                                label: Text(
                                  getIt<Variables>().generalVariables.currentLanguage.dateAndTime,
                                  maxLines: 2,
                                  softWrap: true,
                                  style: TextStyle(
                                      color: const Color(0xff282F3A),
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                ),
                                size: ColumnSize.L,
                              ),
                              DataColumn2(
                                label: Text(
                                  getIt<Variables>().generalVariables.currentLanguage.reason,
                                  maxLines: 2,
                                  softWrap: true,
                                  style: TextStyle(
                                      color: const Color(0xff282F3A),
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                ),
                                size: ColumnSize.L,
                              ),
                              DataColumn2(
                                label: Text(
                                  getIt<Variables>().generalVariables.currentLanguage.amount,
                                  maxLines: 2,
                                  softWrap: true,
                                  style: TextStyle(
                                      color: const Color(0xff282F3A),
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                ),
                                size: ColumnSize.M,
                              ),
                            ],
                            rows: List<DataRow>.generate(context.read<RoTripListDetailBloc>().roTripExpensesModel.response.expensesList.length, (i) {
                              return DataRow(cells: [
                                DataCell(Text(((i + 1) < 10) ? "0${i + 1}" : "${i + 1}",
                                    style: TextStyle(
                                        color: const Color(0xff282F3A),
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 10)))),
                                DataCell(Text(
                                    context
                                        .read<RoTripListDetailBloc>()
                                        .roTripExpensesModel
                                        .response
                                        .expensesList[i]
                                        .expenseDate
                                        .toString()
                                        .substring(0, 10),
                                    style: TextStyle(
                                        color: const Color(0xff282F3A),
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 10)))),
                                DataCell(Text(context.read<RoTripListDetailBloc>().roTripExpensesModel.response.expensesList[i].description,
                                    style: TextStyle(
                                        color: const Color(0xff282F3A),
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 10)))),
                                DataCell(Text("RS. ${context.read<RoTripListDetailBloc>().roTripExpensesModel.response.expensesList[i].amount}",
                                    style: TextStyle(
                                        color: const Color(0xff282F3A),
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 10)))),
                              ]);
                            })),
                      ),
                      context.read<RoTripListDetailBloc>().roTripExpensesModel.response.expensesList.isEmpty
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
                                    getIt<Variables>().generalVariables.currentLanguage.expensesListIsEmpty,
                                    style: TextStyle(
                                        fontSize: getIt<Functions>().getTextSize(fontSize: 18),
                                        color: const Color(0xff282F3A),
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : Divider(color: const Color(0xffBFC1C4).withOpacity(0.73), thickness: 0.5),
                      context.read<RoTripListDetailBloc>().roTripExpensesModel.response.expensesList.isEmpty
                          ? const SizedBox()
                          : SizedBox(
                              height: getIt<Functions>().getWidgetHeight(height: 20),
                            ),
                      context.read<RoTripListDetailBloc>().roTripExpensesModel.response.expensesList.isEmpty
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(getIt<Variables>().generalVariables.currentLanguage.totalAmount.toUpperCase(),
                                    style: TextStyle(
                                        color: const Color(0xff282F3A),
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 10))),
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
                                  child: Text("RS. ${context.read<RoTripListDetailBloc>().roTripExpensesModel.response.totalExpenses}",
                                      style: TextStyle(
                                          color: const Color(0xff282F3A),
                                          fontWeight: FontWeight.w500,
                                          fontSize: getIt<Functions>()
                                              .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 10))),
                                )
                              ],
                            ),
                      context.read<RoTripListDetailBloc>().roTripExpensesModel.response.expensesList.isEmpty
                          ? const SizedBox()
                          : SizedBox(
                              height: getIt<Functions>().getWidgetHeight(height: 20),
                            ),
                    ],
                  ),
                )
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getIt<Variables>().generalVariables.currentLanguage.totalExpenses.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              maximumSize: Size(getIt<Functions>().getWidgetWidth(width: 100), getIt<Functions>().getWidgetHeight(height: 30)),
                              minimumSize: Size(getIt<Functions>().getWidgetWidth(width: 100), getIt<Functions>().getWidgetHeight(height: 30)),
                              backgroundColor: const Color(0xff007AFF)),
                          onPressed: () {
                            getIt<Variables>().generalVariables.popUpWidget = addNewContent(contextNew: context);
                            getIt<Functions>().showAnimatedDialog(context: context, isFromTop: true, isCloseDisabled: false);
                          },
                          child: Text(
                            "${getIt<Variables>().generalVariables.currentLanguage.addNew.toUpperCase()} ",
                            style: TextStyle(
                                fontSize: getIt<Functions>().getTextSize(fontSize: 10), color: const Color(0xffffffff), fontWeight: FontWeight.w700),
                          ))
                    ],
                  ),
                ),
                Container(
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
                      SizedBox(
                        height: getIt<Functions>().getWidgetHeight(
                            height: context.read<RoTripListDetailBloc>().roTripExpensesModel.response.expensesList.isEmpty ? 40 : 400),
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
                                  getIt<Variables>().generalVariables.currentLanguage.sNo,
                                  style: TextStyle(
                                      color: const Color(0xff282F3A),
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                ),
                                size: ColumnSize.S,
                              ),
                              DataColumn2(
                                label: Text(
                                  getIt<Variables>().generalVariables.currentLanguage.dateAndTime,
                                  maxLines: 2,
                                  softWrap: true,
                                  style: TextStyle(
                                      color: const Color(0xff282F3A),
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                ),
                                size: ColumnSize.L,
                              ),
                              DataColumn2(
                                label: Text(
                                  getIt<Variables>().generalVariables.currentLanguage.reason,
                                  maxLines: 2,
                                  softWrap: true,
                                  style: TextStyle(
                                      color: const Color(0xff282F3A),
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                ),
                                size: ColumnSize.L,
                              ),
                              DataColumn2(
                                label: Text(
                                  getIt<Variables>().generalVariables.currentLanguage.amount,
                                  maxLines: 2,
                                  softWrap: true,
                                  style: TextStyle(
                                      color: const Color(0xff282F3A),
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 11)),
                                ),
                                size: ColumnSize.M,
                              ),
                            ],
                            rows: List<DataRow>.generate(context.read<RoTripListDetailBloc>().roTripExpensesModel.response.expensesList.length, (i) {
                              return DataRow(cells: [
                                DataCell(Text(((i + 1) < 10) ? "0${i + 1}" : "${i + 1}",
                                    style: TextStyle(
                                        color: const Color(0xff282F3A),
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 10)))),
                                DataCell(Text(
                                    context.read<RoTripListDetailBloc>().roTripExpensesModel.response.expensesList[i].expenseDate.substring(0, 10),
                                    style: TextStyle(
                                        color: const Color(0xff282F3A),
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 10)))),
                                DataCell(Text(context.read<RoTripListDetailBloc>().roTripExpensesModel.response.expensesList[i].description,
                                    style: TextStyle(
                                        color: const Color(0xff282F3A),
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 10)))),
                                DataCell(Text("RS. ${context.read<RoTripListDetailBloc>().roTripExpensesModel.response.expensesList[i].amount}",
                                    style: TextStyle(
                                        color: const Color(0xff282F3A),
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 10)))),
                              ]);
                            })),
                      ),
                      context.read<RoTripListDetailBloc>().roTripExpensesModel.response.expensesList.isEmpty
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
                                    getIt<Variables>().generalVariables.currentLanguage.expensesListIsEmpty,
                                    style: TextStyle(
                                        fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                        color: const Color(0xff282F3A),
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : Divider(color: const Color(0xffBFC1C4).withOpacity(0.73), thickness: 0.5),
                      context.read<RoTripListDetailBloc>().roTripExpensesModel.response.expensesList.isEmpty
                          ? const SizedBox()
                          : SizedBox(
                              height: getIt<Functions>().getWidgetHeight(height: 8),
                            ),
                      context.read<RoTripListDetailBloc>().roTripExpensesModel.response.expensesList.isEmpty
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(getIt<Variables>().generalVariables.currentLanguage.totalAmount.toUpperCase(),
                                    style: TextStyle(
                                        color: const Color(0xff282F3A),
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 10))),
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
                                  child: Text("RS. ${context.read<RoTripListDetailBloc>().roTripExpensesModel.response.totalExpenses}",
                                      style: TextStyle(
                                          color: const Color(0xff282F3A),
                                          fontWeight: FontWeight.w500,
                                          fontSize: getIt<Functions>()
                                              .getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 10))),
                                )
                              ],
                            ),
                      context.read<RoTripListDetailBloc>().roTripExpensesModel.response.expensesList.isEmpty
                          ? const SizedBox()
                          : SizedBox(
                              height: getIt<Functions>().getWidgetHeight(height: 8),
                            ),
                    ],
                  ),
                )
              ],
            );
          },
        );
      }
    });
  }

  Widget addNewContent({required BuildContext contextNew}) {
    context.read<RoTripListDetailBloc>().updateLoader = false;
    context.read<RoTripListDetailBloc>().selectedReasonEmpty = false;
    context.read<RoTripListDetailBloc>().dateTextEmpty = false;
    context.read<RoTripListDetailBloc>().expenseAmountEmpty = false;
    context.read<RoTripListDetailBloc>().selectedReason = "";
    context.read<RoTripListDetailBloc>().selectedReasonName = null;
    reasonSearchFieldController.clear();
    expenseAmountBar.clear();
    dateController.clear();
    return BlocConsumer<RoTripListDetailBloc, RoTripListDetailState>(
      listenWhen: (RoTripListDetailState previous, RoTripListDetailState current) {
        return previous != current;
      },
      buildWhen: (RoTripListDetailState previous, RoTripListDetailState current) {
        return previous != current;
      },
      listener: (BuildContext context, RoTripListDetailState state) {
        if (state is RoTripListDetailSuccess) {
          context.read<RoTripListDetailBloc>().updateLoader = false;
          Navigator.pop(context);
          ScaffoldMessenger.of(context).clearSnackBars();
          if (state.message != "") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        }
        if (state is RoTripListDetailFailure) {
          context.read<RoTripListDetailBloc>().updateLoader = false;
          context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
        }
        if (state is RoTripListDetailError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          getIt<Widgets>().flushBarWidget(context: context, message: state.message);
        }
      },
      builder: (BuildContext context, RoTripListDetailState state) {
        return SizedBox(
          width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 600 : 415),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: context.read<RoTripListDetailBloc>().updateLoader ? () {} : () {},
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xff292D32),
                        )),
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
                              getIt<Variables>().generalVariables.currentLanguage.addExpenses,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 18 : 14),
                                  color: const Color(0xff282F3A)),
                            ),
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
                            child: buildDropButton(isItem: false, isLoading: context.read<RoTripListDetailBloc>().updateLoader),
                          )
                        ],
                      ),
                    ),
                    context.read<RoTripListDetailBloc>().selectedReasonEmpty
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
                            getIt<Variables>().generalVariables.currentLanguage.date.replaceFirst("d", "D"),
                            style: TextStyle(
                                color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 45),
                            child: TextFormField(
                              controller: dateController,
                              readOnly: true,
                              onTap: () {
                                getIt<Widgets>().showCalenderSingleDialog(context: contextNew, controller: dateController, isFilter: false);
                              },
                              /* onChanged: (value) {
                                print("dgsjlkdjsgkljgslk");
                                context.read<RoTripListDetailBloc>().dateTextEmpty = value.isEmpty ? true : false;
                                context.read<RoTripListDetailBloc>().dateText = value.isEmpty ? "" : value;
                                context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                              },*/
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
                                hintText: getIt<Variables>().generalVariables.currentLanguage.selectDate.toLowerCase(),
                                hintStyle: TextStyle(
                                  color: const Color(0xff8A8D8E),
                                  fontWeight: FontWeight.w400,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                ),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? getIt<Variables>().generalVariables.currentLanguage.pleaseSelectDate.toLowerCase() : null,
                            ),
                          )
                        ],
                      ),
                    ),
                    context.read<RoTripListDetailBloc>().dateTextEmpty
                        ? Text(
                            getIt<Variables>().generalVariables.currentLanguage.pleaseSelectDate,
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
                            getIt<Variables>().generalVariables.currentLanguage.expenseAmount,
                            style: TextStyle(
                                color: const Color(0xff282F3A), fontWeight: FontWeight.w600, fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                          ),
                          SizedBox(
                            height: getIt<Functions>().getWidgetHeight(height: 45),
                            child: TextFormField(
                              controller: expenseAmountBar,
                              onChanged: (value) {
                                context.read<RoTripListDetailBloc>().expenseAmountEmpty = value.isEmpty ? true : false;
                                context.read<RoTripListDetailBloc>().expenseAmount = value.isEmpty ? "" : value;
                                context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                              },
                              inputFormatters: [
                                DecimalTextInputFormatter(
                                  maxDigitsBeforeDecimal: 7,
                                  maxDigitsAfterDecimal: 2,
                                ),
                              ],
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                                hintText: getIt<Variables>().generalVariables.currentLanguage.expenseAmount,
                                hintStyle: TextStyle(
                                  color: const Color(0xff8A8D8E),
                                  fontWeight: FontWeight.w400,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                ),
                              ),
                              validator: (value) => value!.isEmpty ? getIt<Variables>().generalVariables.currentLanguage.pleaseEnterAmount : null,
                            ),
                          )
                        ],
                      ),
                    ),
                    context.read<RoTripListDetailBloc>().expenseAmountEmpty
                        ? Text(
                            getIt<Variables>().generalVariables.currentLanguage.pleaseEnterAmount,
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400, fontSize: getIt<Functions>().getTextSize(fontSize: 10)),
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 45),
                    ),
                  ],
                ),
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
                      onTap: () {
                        if (context.read<RoTripListDetailBloc>().selectedReason == "" || dateController.text == "" || expenseAmountBar.text == "") {
                          if (context.read<RoTripListDetailBloc>().selectedReason == "") {
                            context.read<RoTripListDetailBloc>().selectedReasonEmpty = true;
                            context.read<RoTripListDetailBloc>().dateTextEmpty = false;
                            context.read<RoTripListDetailBloc>().expenseAmountEmpty = false;
                            context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                          } else if (dateController.text == "") {
                            context.read<RoTripListDetailBloc>().selectedReasonEmpty = false;
                            context.read<RoTripListDetailBloc>().dateTextEmpty = true;
                            context.read<RoTripListDetailBloc>().expenseAmountEmpty = false;
                            context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                          } else if (expenseAmountBar.text == "") {
                            context.read<RoTripListDetailBloc>().selectedReasonEmpty = false;
                            context.read<RoTripListDetailBloc>().dateTextEmpty = false;
                            context.read<RoTripListDetailBloc>().expenseAmountEmpty = true;
                            context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                          } else {}
                        } else {
                          context.read<RoTripListDetailBloc>().updateLoader = true;
                          context.read<RoTripListDetailBloc>().dateText = dateController.text;
                          context.read<RoTripListDetailBloc>().expenseAmount = expenseAmountBar.text;
                          FocusManager.instance.primaryFocus!.unfocus();
                          context.read<RoTripListDetailBloc>().selectedReasonEmpty = false;
                          context.read<RoTripListDetailBloc>().dateTextEmpty = false;
                          context.read<RoTripListDetailBloc>().expenseAmountEmpty = false;
                          context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent());
                          context.read<RoTripListDetailBloc>().add(const RoTripListDetailAddNewEvent(isEdit: false));
                        }
                      },
                      child: Container(
                        height: getIt<Functions>().getWidgetHeight(height: 50),
                        decoration: const BoxDecoration(
                          color: Color(0xff29B473),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                        ),
                        child: Center(
                          child: Text(
                            getIt<Variables>().generalVariables.currentLanguage.add.toUpperCase(),
                            textAlign: TextAlign.center,
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

  Widget buildDropButton({required bool isItem, required bool isLoading}) {
    return Container(
      height: getIt<Functions>().getWidgetHeight(height: 45),
      decoration: BoxDecoration(
          color: const Color(0xffffffff), borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffE0E7EC), width: 0.73)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: isLoading == false ? changeReason : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  context.read<RoTripListDetailBloc>().selectedReasonName ?? getIt<Variables>().generalVariables.currentLanguage.chooseReason,
                  style: TextStyle(
                      fontSize: context.read<RoTripListDetailBloc>().selectedReasonName == null ? 12 : 15,
                      color: context.read<RoTripListDetailBloc>().selectedReasonName == null ? Colors.grey.shade500 : Colors.black),
                ),
              ),
              context.read<RoTripListDetailBloc>().selectedReasonName != null
                  ? InkWell(
                      onTap: () {
                        context.read<RoTripListDetailBloc>().selectedReasonName = null;
                        context.read<RoTripListDetailBloc>().selectedReasonEmpty = false;
                        context.read<RoTripListDetailBloc>().selectedReason = "";
                        context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent(stillLoading: false));
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
    List<ExpenseReason> searchReasons = context.read<RoTripListDetailBloc>().roTripExpensesModel.response.expenseReasons;
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
                                  context.read<RoTripListDetailBloc>().selectedReasonEmpty = false;
                                  context.read<RoTripListDetailBloc>().selectedReasonName = "";
                                  context.read<RoTripListDetailBloc>().selectedReason = "";
                                  context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent(stillLoading: false));
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
                          .read<RoTripListDetailBloc>()
                          .roTripExpensesModel
                          .response
                          .expenseReasons
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
                          context.read<RoTripListDetailBloc>().selectedReasonName = searchReasons[index].description;
                          context.read<RoTripListDetailBloc>().selectedReasonEmpty = false;
                          context.read<RoTripListDetailBloc>().selectedReason = searchReasons[index].id;
                          context.read<RoTripListDetailBloc>().add(const RoTripListDetailSetStateEvent(stillLoading: false));
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
