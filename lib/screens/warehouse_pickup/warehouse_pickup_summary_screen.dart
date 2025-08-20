// Dart imports:
import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

// Flutter imports:
import 'package:another_flushbar/flushbar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:oda/resources/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

// Project imports:
import 'package:oda/bloc/navigation/navigation_bloc.dart';
import 'package:oda/bloc/warehouse_pickup/warehouse_pickup_summary/warehouse_pickup_summary_bloc.dart';
import 'package:oda/edited_packages/data_table_library/data_table_2.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';

class WarehousePickupSummaryScreen extends StatefulWidget {
  static const String id = "warehouse_pickup_summary_screen";

  const WarehousePickupSummaryScreen({super.key});

  @override
  State<WarehousePickupSummaryScreen> createState() => _WarehousePickupSummaryScreenState();
}

class _WarehousePickupSummaryScreenState extends State<WarehousePickupSummaryScreen> {
  TextEditingController searchBar = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController discountPercentageController = TextEditingController(text: "0");
  TextEditingController discountValueController = TextEditingController(text: "0");
  TextEditingController payableAmountController = TextEditingController(text: "");
  TextEditingController referenceController = TextEditingController();
  TextEditingController checkNoController = TextEditingController();
  TextEditingController checkDateController = TextEditingController(text: DateTime.now().toString().substring(0, 10));
  TextEditingController branchNameController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  Timer? timer;
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  DateRangePickerController? dateController;
  String loadedTime = DateFormat('yyyy-MM-dd, HH:mm').format(DateTime.now());

  @override
  void initState() {
    context.read<WarehousePickupSummaryBloc>().add(const WarehousePickupSummaryInitialEvent());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(seconds: 3), () {
      payableAmountController.text = context.read<WarehousePickupSummaryBloc>().totalInvoiceAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        getIt<Variables>().generalVariables.indexName =
            getIt<Variables>().generalVariables.warehouseRouteList[getIt<Variables>().generalVariables.warehouseRouteList.length - 1];
        context.read<NavigationBloc>().add(const NavigationInitialEvent());
        getIt<Variables>().generalVariables.warehouseRouteList.removeAt(getIt<Variables>().generalVariables.warehouseRouteList.length - 1);
      },
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 480) {
          return Container(
            color: const Color(0xffEEF4FF),
            child: Column(
              children: [
                BlocBuilder<WarehousePickupSummaryBloc, WarehousePickupSummaryState>(
                  builder: (BuildContext context, WarehousePickupSummaryState state) {
                    return SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 152),
                      child: AppBar(
                        backgroundColor: const Color(0xff1D2736),
                        leading: IconButton(
                          onPressed: () {
                            getIt<Variables>().generalVariables.indexName = getIt<Variables>()
                                .generalVariables
                                .warehouseRouteList[getIt<Variables>().generalVariables.warehouseRouteList.length - 1];
                            context.read<NavigationBloc>().add(const NavigationInitialEvent());
                            getIt<Variables>()
                                .generalVariables
                                .warehouseRouteList
                                .removeAt(getIt<Variables>().generalVariables.warehouseRouteList.length - 1);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Color(0xffffffff),
                          ),
                        ),
                        titleSpacing: 0,
                        title: AnimatedCrossFade(
                          firstChild: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${getIt<Variables>().generalVariables.currentLanguage.so} #:${getIt<Variables>().generalVariables.soListMainIdData.soNum}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: getIt<Functions>().getTextSize(fontSize: 22),
                                          color: const Color(0xffffffff)),
                                    ),
                                    Text(
                                      getIt<Variables>().generalVariables.soListMainIdData.soCustomerName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                          color: const Color(0xffAEAEB2)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          secondChild: const SizedBox(),
                          crossFadeState:
                              context.read<WarehousePickupSummaryBloc>().searchBarEnabled ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 100),
                        ),
                        actions: [
                          context.read<WarehousePickupSummaryBloc>().deliveredButton
                              ? Container(
                                  height: getIt<Functions>().getWidgetHeight(height: 35),
                                  width: getIt<Functions>().getWidgetWidth(width: 175),
                                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
                                  child: Center(
                                    child: Text(
                                      getIt<Variables>().generalVariables.currentLanguage.loading.toLowerCase(),
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xffffffff),
                                        fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    context.read<WarehousePickupSummaryBloc>().deliveredButton = true;
                                    context.read<WarehousePickupSummaryBloc>().add(const WarehousePickupSummarySetStateEvent());
                                    context.read<WarehousePickupSummaryBloc>().completeLoader = true;
                                    context.read<WarehousePickupSummaryBloc>().completeLoaderFailure = true;
                                    context.read<WarehousePickupSummaryBloc>().add(const WarehousePickupCompleteEvent(isLoading: false));
                                  },
                                  child: Container(
                                    height: getIt<Functions>().getWidgetHeight(height: 35),
                                    width: getIt<Functions>().getWidgetWidth(width: 175),
                                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
                                    child: Center(
                                      child: Text(
                                        getIt<Variables>().generalVariables.currentLanguage.markAsDelivered.toUpperCase(),
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xffffffff),
                                          fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          SizedBox(width: getIt<Functions>().getWidgetWidth(width: 16)),
                        ],
                        bottom: PreferredSize(
                          preferredSize: Size(
                              getIt<Functions>().getWidgetWidth(
                                  width: Orientation.portrait == MediaQuery.of(context).orientation
                                      ? getIt<Variables>().generalVariables.width
                                      : getIt<Variables>().generalVariables.height),
                              getIt<Functions>().getWidgetHeight(height: 140)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 14)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: getIt<Functions>().getWidgetHeight(height: 40),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: getIt<Variables>().generalVariables.isNetworkOffline
                                            ? () {}
                                            : () {
                                                getIt<Variables>().generalVariables.isStatusDrawer = true;
                                                Scaffold.of(context).openEndDrawer();
                                              },
                                        child: Row(
                                          children: [
                                            Center(
                                              child: SizedBox(
                                                height: getIt<Functions>().getWidgetHeight(height: 20),
                                                width: getIt<Functions>().getWidgetWidth(width: 20),
                                                child: SvgPicture.asset(
                                                  "assets/pick_list/status_image.svg",
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.status,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      color: const Color(0xffffffff)),
                                                ),
                                                Text(
                                                  getIt<Variables>().generalVariables.soListMainIdData.soStatus.toUpperCase(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      color: const Color(0xff5AC8EA)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: getIt<Functions>().getWidgetWidth(width: 17.63)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 30),
                                        width: getIt<Functions>().getWidgetWidth(width: 0),
                                        child: const VerticalDivider(
                                          color: Color(0xffE0E7EC),
                                          width: 1,
                                        ),
                                      ),
                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 17.63)),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.numberOfItems.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xffffffff)),
                                          ),
                                          Text(
                                            "${getIt<Variables>().generalVariables.soListMainIdData.soNoOfLoadedItems} / ${getIt<Variables>().generalVariables.soListMainIdData.soNoOfItems}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xff5AC8EA)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 17.63)),
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 30),
                                        width: getIt<Functions>().getWidgetWidth(width: 0),
                                        child: const VerticalDivider(
                                          color: Color(0xffE0E7EC),
                                          width: 1,
                                        ),
                                      ),
                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 17.63)),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.dateAndTime,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xffffffff)),
                                          ),
                                          Text(
                                            getIt<Variables>().generalVariables.soListMainIdData.soCreatedTime,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xff5AC8EA)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 17.63)),
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 30),
                                        width: getIt<Functions>().getWidgetWidth(width: 0),
                                        child: const VerticalDivider(
                                          color: Color(0xffE0E7EC),
                                          width: 1,
                                        ),
                                      ),
                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 17.63)),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.loader.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xffffffff)),
                                          ),
                                          Text(
                                            getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.isNotEmpty
                                                ? getIt<Variables>().generalVariables.soListMainIdData.soHandledBy[0].name
                                                : "-",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xff5AC8EA)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 17.63)),
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 30),
                                        width: getIt<Functions>().getWidgetWidth(width: 0),
                                        child: const VerticalDivider(
                                          color: Color(0xffE0E7EC),
                                          width: 1,
                                        ),
                                      ),
                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 17.63)),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.loadedTime.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xffffffff)),
                                          ),
                                          Text(
                                            loadedTime,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xff5AC8EA)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 18)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
                BlocConsumer<WarehousePickupSummaryBloc, WarehousePickupSummaryState>(
                  listener: (context, state) {
                    if (state is WarehousePickupSummaryError) {
                      getIt<Widgets>().flushBarWidget(context: context, message: state.message);
                    }
                    if (state is WarehousePickupSummaryDialog) {
                      getIt<Variables>().generalVariables.popUpWidget = deliverySuccessDialog();
                      getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: true);
                    }
                  },
                  builder: (context, state) {
                    if (state is WarehousePickupSummaryLoaded) {
                      return Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 14)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: getIt<Functions>().getWidgetHeight(height: 48),
                                      decoration: const BoxDecoration(
                                        color: Color(0xffE3E7EA),
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(getIt<Variables>().generalVariables.currentLanguage.invoiceDetails,
                                              style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xff282F3A))),
                                          Text(
                                              "${getIt<Variables>().generalVariables.currentLanguage.totalAmount} : RS.${context.read<WarehousePickupSummaryBloc>().totalInvoiceAmount}",
                                              style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xff282F3A))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                    Container(
                                      height: getIt<Functions>()
                                          .getWidgetHeight(height: (context.read<WarehousePickupSummaryBloc>().invoiceDataList.length + 1) * 40),
                                      margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 21)),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                      child: DataTable2(
                                          isVerticalScrollBarVisible: true,
                                          isHorizontalScrollBarVisible: false,
                                          headingRowDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                          columnSpacing: getIt<Functions>().getWidgetWidth(width: 0),
                                          horizontalMargin: getIt<Functions>().getWidgetWidth(width: 15),
                                          minWidth: 380,
                                          headingRowColor: const WidgetStatePropertyAll<Color>(Color(0xffE0E7EC)),
                                          headingRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                                          dividerThickness: 0,
                                          dataRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                                          columns: [
                                            DataColumn2(
                                              label: Text(
                                                getIt<Variables>().generalVariables.currentLanguage.invoice,
                                                style: TextStyle(
                                                    color: const Color(0xff282F3A),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                              ),
                                              size: ColumnSize.S,
                                            ),
                                            DataColumn2(
                                              label: Text(
                                                getIt<Variables>().generalVariables.currentLanguage.numberOfItems,
                                                style: TextStyle(
                                                    color: const Color(0xff282F3A),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                              ),
                                              size: ColumnSize.S,
                                            ),
                                            DataColumn2(
                                              label: Text(
                                                getIt<Variables>().generalVariables.currentLanguage.loadingBay,
                                                style: TextStyle(
                                                    color: const Color(0xff282F3A),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                              ),
                                              size: ColumnSize.S,
                                            ),
                                            DataColumn2(
                                              label: Center(
                                                child: Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.dateAndTime,
                                                  style: TextStyle(
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                ),
                                              ),
                                              size: ColumnSize.S,
                                            ),
                                            DataColumn2(
                                              label: Center(
                                                child: Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.amount,
                                                  style: TextStyle(
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                ),
                                              ),
                                              size: ColumnSize.S,
                                            ),
                                          ],
                                          rows: List<DataRow>.generate(context.read<WarehousePickupSummaryBloc>().invoiceDataList.length, (index) {
                                            return DataRow(cells: [
                                              DataCell(Text(context.read<WarehousePickupSummaryBloc>().invoiceDataList[index].invoiceNum,
                                                  style: TextStyle(
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14)))),
                                              DataCell(Padding(
                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 25)),
                                                child: Text(context.read<WarehousePickupSummaryBloc>().invoiceDataList[index].invoiceItems,
                                                    style: TextStyle(
                                                        color: const Color(0xff282F3A),
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                              )),
                                              DataCell(Text(
                                                  "${getIt<Variables>().generalVariables.soListMainIdData.tripLoadingBayDryName} / ${getIt<Variables>().generalVariables.soListMainIdData.tripLoadingBayFrozenName}",
                                                  style: TextStyle(
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14)))),
                                              DataCell(Center(
                                                child: Text(context.read<WarehousePickupSummaryBloc>().invoiceDataList[index].invoiceDate,
                                                    style: TextStyle(
                                                        color: const Color(0xff282F3A),
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                              )),
                                              DataCell(Center(
                                                  child: Text("RS ${context.read<WarehousePickupSummaryBloc>().invoiceDataList[index].invoiceTotal}",
                                                      style: TextStyle(
                                                          color: const Color(0xff282F3A),
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14))))),
                                            ]);
                                          })),
                                    ),
                                    const Divider(
                                      color: Color(0XffE0E7EC),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 21)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(getIt<Variables>().generalVariables.currentLanguage.applyDiscount,
                                              style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xff282F3A))),
                                          FlutterSwitch(
                                            width: getIt<Functions>().getWidgetWidth(width: 46),
                                            height: getIt<Functions>().getWidgetHeight(height: 28),
                                            toggleSize: getIt<Functions>().getTextSize(fontSize: 20),
                                            value: context.read<WarehousePickupSummaryBloc>().isApplyDiscount,
                                            borderRadius: 13.33,
                                            padding: 1,
                                            showOnOff: false,
                                            activeColor: const Color(0xff34C759),
                                            inactiveColor: const Color(0xffE3E7EA),
                                            activeToggleColor: const Color(0xffFFFFFF),
                                            onToggle: (val) {
                                              context.read<WarehousePickupSummaryBloc>().isApplyDiscount =
                                                  !context.read<WarehousePickupSummaryBloc>().isApplyDiscount;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
                                    context.read<WarehousePickupSummaryBloc>().isApplyDiscount
                                        ? Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 21)),
                                                      child: Text(getIt<Variables>().generalVariables.currentLanguage.discountApplied,
                                                          style: TextStyle(
                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                              fontWeight: FontWeight.w600,
                                                              color: const Color(0xff282F3A))),
                                                    ),
                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 21)),
                                                      child: SizedBox(
                                                        height: getIt<Functions>().getWidgetHeight(height: 44),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: TextFormField(
                                                                  controller: discountPercentageController,
                                                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                                  decoration: InputDecoration(
                                                                    fillColor: const Color(0xffffffff),
                                                                    filled: true,
                                                                    contentPadding: EdgeInsets.symmetric(
                                                                        horizontal: getIt<Functions>().getWidgetWidth(width: 15),
                                                                        vertical: getIt<Functions>().getWidgetHeight(height: 15)),
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
                                                                    hintText: "${getIt<Variables>().generalVariables.currentLanguage.enter} (0-100)",
                                                                    hintStyle: TextStyle(
                                                                      color: const Color(0xff8A8D8E),
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                                    ),
                                                                    prefixIcon: SizedBox(
                                                                        width: getIt<Functions>().getWidgetWidth(width: 50),
                                                                        child: Center(
                                                                            child: Text("%",
                                                                                style: TextStyle(
                                                                                    color: const Color(0xff8A8D8E),
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14))))),
                                                                  ),
                                                                  inputFormatters: [
                                                                    NumberRangeFormatter(), // Restrict to 0–100
                                                                  ],
                                                                  onChanged: (value) {
                                                                    if (value.isNotEmpty) {
                                                                      if (num.parse(value) > 0 && num.parse(value) < 100) {
                                                                        context.read<WarehousePickupSummaryBloc>().discountPercentage = value;
                                                                        discountValueController.text = (num.parse(
                                                                                    context.read<WarehousePickupSummaryBloc>().totalInvoiceAmount) *
                                                                                num.parse(value) /
                                                                                100)
                                                                            .toStringAsFixed(2);
                                                                        payableAmountController.text = (num.parse(
                                                                                    context.read<WarehousePickupSummaryBloc>().totalInvoiceAmount) -
                                                                                num.parse(discountValueController.text))
                                                                            .toStringAsFixed(2);
                                                                      } else if (num.parse(value) == 0) {
                                                                        context.read<WarehousePickupSummaryBloc>().discountPercentage = "0";
                                                                        discountValueController.text = "0";
                                                                        payableAmountController.text =
                                                                            context.read<WarehousePickupSummaryBloc>().totalInvoiceAmount;
                                                                      } else if (num.parse(value) == 100) {
                                                                        context.read<WarehousePickupSummaryBloc>().discountPercentage = "100";
                                                                        discountValueController.text =
                                                                            context.read<WarehousePickupSummaryBloc>().totalInvoiceAmount;
                                                                        payableAmountController.text = "0";
                                                                      } else {
                                                                        context.read<WarehousePickupSummaryBloc>().discountPercentage = "0";
                                                                        discountValueController.text = "0";
                                                                        payableAmountController.text =
                                                                            context.read<WarehousePickupSummaryBloc>().totalInvoiceAmount;
                                                                      }
                                                                    } else {
                                                                      context.read<WarehousePickupSummaryBloc>().discountPercentage = "0";
                                                                      discountValueController.text = "0";
                                                                      payableAmountController.text =
                                                                          context.read<WarehousePickupSummaryBloc>().totalInvoiceAmount;
                                                                    }
                                                                  }),
                                                            ),
                                                            SizedBox(width: getIt<Functions>().getWidgetWidth(width: 20)),
                                                            Expanded(
                                                              child: TextFormField(
                                                                controller: discountValueController,
                                                                keyboardType: TextInputType.text,
                                                                readOnly: true,
                                                                decoration: InputDecoration(
                                                                  fillColor: const Color(0xffffffff),
                                                                  filled: true,
                                                                  contentPadding: EdgeInsets.symmetric(
                                                                      horizontal: getIt<Functions>().getWidgetWidth(width: 15),
                                                                      vertical: getIt<Functions>().getWidgetHeight(height: 15)),
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
                                                                  hintText: getIt<Variables>().generalVariables.currentLanguage.enterAmountHere,
                                                                  hintStyle: TextStyle(
                                                                      color: const Color(0xff8A8D8E),
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                                  prefixIcon: SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 50),
                                                                      child: Center(
                                                                          child: Text("Rs.",
                                                                              style: TextStyle(
                                                                                  color: const Color(0xff8A8D8E),
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14))))),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: getIt<Functions>().getWidgetWidth(width: 50)),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 21)),
                                                      child: Text(getIt<Variables>().generalVariables.currentLanguage.payableAmount,
                                                          style: TextStyle(
                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                              fontWeight: FontWeight.w600,
                                                              color: const Color(0xff282F3A))),
                                                    ),
                                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                                    Container(
                                                      height: getIt<Functions>().getWidgetHeight(height: 44),
                                                      padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 21)),
                                                      child: TextFormField(
                                                        controller: payableAmountController,
                                                        keyboardType: TextInputType.text,
                                                        readOnly: true,
                                                        decoration: InputDecoration(
                                                          fillColor: const Color(0xffffffff),
                                                          filled: true,
                                                          contentPadding: EdgeInsets.symmetric(
                                                              horizontal: getIt<Functions>().getWidgetWidth(width: 15),
                                                              vertical: getIt<Functions>().getWidgetHeight(height: 15)),
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
                                                          hintText: getIt<Variables>().generalVariables.currentLanguage.enterAmountHere,
                                                          hintStyle: TextStyle(
                                                              color: const Color(0xff8A8D8E),
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                          prefixIcon: SizedBox(
                                                              width: getIt<Functions>().getWidgetWidth(width: 50),
                                                              child: Center(
                                                                  child: Text("Rs.",
                                                                      style: TextStyle(
                                                                          color: const Color(0xff8A8D8E),
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14))))),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 21)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(getIt<Variables>().generalVariables.currentLanguage.collectPayment,
                                              style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xff282F3A))),
                                          FlutterSwitch(
                                            width: getIt<Functions>().getWidgetWidth(width: 46),
                                            height: getIt<Functions>().getWidgetHeight(height: 28),
                                            toggleSize: getIt<Functions>().getTextSize(fontSize: 20),
                                            value: context.read<WarehousePickupSummaryBloc>().isCollectPayment,
                                            borderRadius: 13.33,
                                            padding: 1,
                                            showOnOff: false,
                                            activeColor: const Color(0xff34C759),
                                            inactiveColor: const Color(0xffE3E7EA),
                                            activeToggleColor: const Color(0xffFFFFFF),
                                            onToggle: (val) {
                                              context.read<WarehousePickupSummaryBloc>().isCollectPayment =
                                                  !context.read<WarehousePickupSummaryBloc>().isCollectPayment;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
                                    context.read<WarehousePickupSummaryBloc>().isCollectPayment
                                        ? Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 21)),
                                                          child: Text(getIt<Variables>().generalVariables.currentLanguage.paymentMethod,
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                                  fontWeight: FontWeight.w600,
                                                                  color: const Color(0xff282F3A))),
                                                        ),
                                                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                                        Container(
                                                          padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 21)),
                                                          height: getIt<Functions>().getWidgetHeight(height: 45),
                                                          child: DropdownButtonHideUnderline(
                                                            child: DropdownButton2<String>(
                                                              isExpanded: true,
                                                              hint: Text(getIt<Variables>().generalVariables.currentLanguage.choosePaymentMethod,
                                                                  style: TextStyle(
                                                                      color: const Color(0xff8A8D8E),
                                                                      fontWeight: FontWeight.w400,
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                                              items: [
                                                                getIt<Variables>().generalVariables.currentLanguage.cash,
                                                                getIt<Variables>().generalVariables.currentLanguage.cheque,
                                                                getIt<Variables>().generalVariables.currentLanguage.online,
                                                                getIt<Variables>().generalVariables.currentLanguage.deposit
                                                              ]
                                                                  .map((element) => DropdownMenuItem<String>(
                                                                        value: element,
                                                                        child: Text(
                                                                          element,
                                                                          style: const TextStyle(
                                                                            fontSize: 14,
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  .toList(),
                                                              value: context.read<WarehousePickupSummaryBloc>().selectPaymentMethod,
                                                              onChanged: (String? suggestion) async {
                                                                context.read<WarehousePickupSummaryBloc>().selectPaymentMethod = suggestion;
                                                                context
                                                                    .read<WarehousePickupSummaryBloc>()
                                                                    .add(const WarehousePickupSummarySetStateEvent());
                                                              },
                                                              iconStyleData: const IconStyleData(
                                                                  icon: Icon(
                                                                    Icons.keyboard_arrow_down,
                                                                  ),
                                                                  iconSize: 15,
                                                                  iconEnabledColor: Color(0xff8A8D8E),
                                                                  iconDisabledColor: Color(0xff8A8D8E)),
                                                              buttonStyleData: ButtonStyleData(
                                                                padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 15)),
                                                                decoration: BoxDecoration(
                                                                    color: const Color(0xffffffff),
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
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: getIt<Functions>().getWidgetWidth(width: 50)),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 21)),
                                                          child: Text(getIt<Variables>().generalVariables.currentLanguage.enterAmount,
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                                  fontWeight: FontWeight.w600,
                                                                  color: const Color(0xff282F3A))),
                                                        ),
                                                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                                        Container(
                                                          height: getIt<Functions>().getWidgetHeight(height: 44),
                                                          padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 21)),
                                                          child: TextFormField(
                                                            controller: amountController,
                                                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                            inputFormatters: [
                                                              DecimalTextInputFormatter(
                                                                maxDigitsBeforeDecimal: 7,
                                                                maxDigitsAfterDecimal: 2,
                                                              ),
                                                            ],
                                                            onChanged: (value) {
                                                              context.read<WarehousePickupSummaryBloc>().chequeAmount = value;
                                                            },
                                                            decoration: InputDecoration(
                                                                fillColor: const Color(0xffffffff),
                                                                filled: true,
                                                                contentPadding: EdgeInsets.symmetric(
                                                                    horizontal: getIt<Functions>().getWidgetWidth(width: 15),
                                                                    vertical: getIt<Functions>().getWidgetHeight(height: 15)),
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
                                                                hintText: getIt<Variables>().generalVariables.currentLanguage.enterAmountHere,
                                                                hintStyle: TextStyle(
                                                                    color: const Color(0xff8A8D8E),
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                                    getIt<Variables>().generalVariables.currentLanguage.online ||
                                                                context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                                    getIt<Variables>().generalVariables.currentLanguage.deposit
                                                            ? Padding(
                                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 21)),
                                                                child: Text(
                                                                    getIt<Variables>()
                                                                        .generalVariables
                                                                        .currentLanguage
                                                                        .referenceId
                                                                        .toLowerCase()
                                                                        .replaceFirst("r", "R"),
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff282F3A))),
                                                              )
                                                            : context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                                    getIt<Variables>().generalVariables.currentLanguage.cheque
                                                                ? Padding(
                                                                    padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 21)),
                                                                    child: Text(
                                                                        getIt<Variables>()
                                                                            .generalVariables
                                                                            .currentLanguage
                                                                            .chequeNumber
                                                                            .toLowerCase()
                                                                            .replaceFirst("c", "C"),
                                                                        style: TextStyle(
                                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                                            fontWeight: FontWeight.w600,
                                                                            color: const Color(0xff282F3A))),
                                                                  )
                                                                : const SizedBox(),
                                                        context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                                    getIt<Variables>().generalVariables.currentLanguage.online ||
                                                                context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                                    getIt<Variables>().generalVariables.currentLanguage.deposit ||
                                                                context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                                    getIt<Variables>().generalVariables.currentLanguage.cheque
                                                            ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12))
                                                            : const SizedBox(),
                                                        context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                                    getIt<Variables>().generalVariables.currentLanguage.online ||
                                                                context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                                    getIt<Variables>().generalVariables.currentLanguage.deposit
                                                            ? Container(
                                                                height: getIt<Functions>().getWidgetHeight(height: 44),
                                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 21)),
                                                                child: TextFormField(
                                                                  controller: referenceController,
                                                                  keyboardType: TextInputType.text,
                                                                  onChanged: (value) {
                                                                    context.read<WarehousePickupSummaryBloc>().referenceNo = value;
                                                                  },
                                                                  decoration: InputDecoration(
                                                                      fillColor: const Color(0xffffffff),
                                                                      filled: true,
                                                                      contentPadding: EdgeInsets.symmetric(
                                                                          horizontal: getIt<Functions>().getWidgetWidth(width: 15),
                                                                          vertical: getIt<Functions>().getWidgetHeight(height: 15)),
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
                                                                      hintText: getIt<Variables>()
                                                                          .generalVariables
                                                                          .currentLanguage
                                                                          .referenceId
                                                                          .toLowerCase(),
                                                                      hintStyle: TextStyle(
                                                                          color: const Color(0xff8A8D8E),
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                                                ),
                                                              )
                                                            : context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                                    getIt<Variables>().generalVariables.currentLanguage.cheque
                                                                ? Container(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 44),
                                                                    padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 21)),
                                                                    child: TextFormField(
                                                                      controller: checkNoController,
                                                                      keyboardType: TextInputType.number,
                                                                      onChanged: (value) {
                                                                        context.read<WarehousePickupSummaryBloc>().chequeNumber = value;
                                                                      },
                                                                      decoration: InputDecoration(
                                                                          fillColor: const Color(0xffffffff),
                                                                          filled: true,
                                                                          contentPadding: EdgeInsets.symmetric(
                                                                              horizontal: getIt<Functions>().getWidgetWidth(width: 15),
                                                                              vertical: getIt<Functions>().getWidgetHeight(height: 15)),
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
                                                                          hintText: getIt<Variables>()
                                                                              .generalVariables
                                                                              .currentLanguage
                                                                              .chequeNumber
                                                                              .toLowerCase(),
                                                                          hintStyle: TextStyle(
                                                                              color: const Color(0xff8A8D8E),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                                                    ),
                                                                  )
                                                                : const SizedBox(),
                                                      ],
                                                    ),
                                                  ),
                                                  context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                              getIt<Variables>().generalVariables.currentLanguage.online ||
                                                          context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                              getIt<Variables>().generalVariables.currentLanguage.deposit ||
                                                          context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                              getIt<Variables>().generalVariables.currentLanguage.cheque
                                                      ? SizedBox(width: getIt<Functions>().getWidgetWidth(width: 50))
                                                      : const SizedBox(),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                                getIt<Variables>().generalVariables.currentLanguage.cheque
                                                            ? Padding(
                                                                padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 21)),
                                                                child: Text(
                                                                    getIt<Variables>()
                                                                        .generalVariables
                                                                        .currentLanguage
                                                                        .chequeDate
                                                                        .toLowerCase()
                                                                        .replaceFirst("c", "C"),
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff282F3A))),
                                                              )
                                                            : const SizedBox(),
                                                        context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                                getIt<Variables>().generalVariables.currentLanguage.cheque
                                                            ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12))
                                                            : const SizedBox(),
                                                        context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                                getIt<Variables>().generalVariables.currentLanguage.cheque
                                                            ? Container(
                                                                height: getIt<Functions>().getWidgetHeight(height: 44),
                                                                padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 21)),
                                                                child: TextFormField(
                                                                  controller: checkDateController,
                                                                  keyboardType: TextInputType.text,
                                                                  readOnly: true,
                                                                  onChanged: (value) {
                                                                    context.read<WarehousePickupSummaryBloc>().chequeDate = value;
                                                                  },
                                                                  onTap: () {
                                                                    context.read<WarehousePickupSummaryBloc>().filterCalenderEnabled =
                                                                        !context.read<WarehousePickupSummaryBloc>().filterCalenderEnabled;
                                                                    setState(() {});
                                                                  },
                                                                  decoration: InputDecoration(
                                                                      fillColor: const Color(0xffffffff),
                                                                      filled: true,
                                                                      contentPadding: EdgeInsets.symmetric(
                                                                          horizontal: getIt<Functions>().getWidgetWidth(width: 15),
                                                                          vertical: getIt<Functions>().getWidgetHeight(height: 15)),
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
                                                                      hintText: getIt<Variables>()
                                                                          .generalVariables
                                                                          .currentLanguage
                                                                          .chequeDate
                                                                          .toLowerCase(),
                                                                      hintStyle: TextStyle(
                                                                          color: const Color(0xff8A8D8E),
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                                                ),
                                                              )
                                                            : const SizedBox(),
                                                        context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                                getIt<Variables>().generalVariables.currentLanguage.cheque
                                                            ? AnimatedCrossFade(
                                                                firstChild: Container(
                                                                  width: getIt<Functions>().getWidgetWidth(width: 300),
                                                                  margin: const EdgeInsets.all(2),
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(15),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        blurRadius: 4,
                                                                        spreadRadius: 0,
                                                                        color: Colors.black.withOpacity(0.3),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  clipBehavior: Clip.hardEdge,
                                                                  child: SfDateRangePicker(
                                                                    selectionMode: DateRangePickerSelectionMode.single,
                                                                    controller: dateController,
                                                                    initialSelectedDate: DateTime.parse(checkDateController.text),
                                                                    backgroundColor: Colors.white,
                                                                    toggleDaySelection: true,
                                                                    showNavigationArrow: true,
                                                                    headerHeight: 50,
                                                                    showActionButtons: true,
                                                                    headerStyle: const DateRangePickerHeaderStyle(
                                                                        textAlign: TextAlign.center,
                                                                        backgroundColor: Color(0xFF0C3788),
                                                                        textStyle: TextStyle(
                                                                            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                                                    onCancel: () {
                                                                      context.read<WarehousePickupSummaryBloc>().filterCalenderEnabled =
                                                                          !context.read<WarehousePickupSummaryBloc>().filterCalenderEnabled;
                                                                      setState(() {});
                                                                    },
                                                                    onSubmit: (value) {
                                                                      context.read<WarehousePickupSummaryBloc>().filterCalenderEnabled =
                                                                          !context.read<WarehousePickupSummaryBloc>().filterCalenderEnabled;
                                                                      setState(() {});
                                                                    },
                                                                    onSelectionChanged: (value) {
                                                                      DateTime selectedDate = value.value;
                                                                      checkDateController.text = selectedDate.toString().substring(0, 10);
                                                                      context.read<WarehousePickupSummaryBloc>().chequeDate =
                                                                          selectedDate.toString().substring(0, 10);
                                                                      setState(() {});
                                                                    },
                                                                    showTodayButton: false,
                                                                    monthFormat: "MMMM",
                                                                    monthViewSettings: const DateRangePickerMonthViewSettings(
                                                                      firstDayOfWeek: 1,
                                                                      dayFormat: "EE",
                                                                      viewHeaderHeight: 50,
                                                                    ),
                                                                    view: DateRangePickerView.month,
                                                                    minDate: DateTime(1800),
                                                                    maxDate: DateTime(2200),
                                                                  ),
                                                                ),
                                                                secondChild: const SizedBox(),
                                                                crossFadeState: context.read<WarehousePickupSummaryBloc>().filterCalenderEnabled
                                                                    ? CrossFadeState.showFirst
                                                                    : CrossFadeState.showSecond,
                                                                duration: const Duration(milliseconds: 500),
                                                              )
                                                            : const SizedBox(),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                                getIt<Variables>().generalVariables.currentLanguage.cheque
                                                            ? Padding(
                                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 21)),
                                                                child: Text(
                                                                    getIt<Variables>()
                                                                        .generalVariables
                                                                        .currentLanguage
                                                                        .bankName
                                                                        .toLowerCase()
                                                                        .replaceFirst("b", "B"),
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff282F3A))),
                                                              )
                                                            : const SizedBox(),
                                                        context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                                getIt<Variables>().generalVariables.currentLanguage.cheque
                                                            ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12))
                                                            : const SizedBox(),
                                                        context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                                getIt<Variables>().generalVariables.currentLanguage.cheque
                                                            ? Container(
                                                                height: getIt<Functions>().getWidgetHeight(height: 44),
                                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 21)),
                                                                child: TextFormField(
                                                                  controller: bankNameController,
                                                                  keyboardType: TextInputType.text,
                                                                  onChanged: (value) {
                                                                    context.read<WarehousePickupSummaryBloc>().bank = value;
                                                                  },
                                                                  decoration: InputDecoration(
                                                                      fillColor: const Color(0xffffffff),
                                                                      filled: true,
                                                                      contentPadding: EdgeInsets.symmetric(
                                                                          horizontal: getIt<Functions>().getWidgetWidth(width: 15),
                                                                          vertical: getIt<Functions>().getWidgetHeight(height: 15)),
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
                                                                      hintText:
                                                                          getIt<Variables>().generalVariables.currentLanguage.bankName.toLowerCase(),
                                                                      hintStyle: TextStyle(
                                                                          color: const Color(0xff8A8D8E),
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                                                ),
                                                              )
                                                            : const SizedBox(),
                                                      ],
                                                    ),
                                                  ),
                                                  context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                          getIt<Variables>().generalVariables.currentLanguage.cheque
                                                      ? SizedBox(width: getIt<Functions>().getWidgetWidth(width: 50))
                                                      : const SizedBox(),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                                getIt<Variables>().generalVariables.currentLanguage.cheque
                                                            ? Padding(
                                                                padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 21)),
                                                                child: Text(
                                                                    getIt<Variables>()
                                                                        .generalVariables
                                                                        .currentLanguage
                                                                        .branchName
                                                                        .toLowerCase()
                                                                        .replaceFirst("b", "B"),
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                                        fontWeight: FontWeight.w600,
                                                                        color: const Color(0xff282F3A))),
                                                              )
                                                            : const SizedBox(),
                                                        context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                                getIt<Variables>().generalVariables.currentLanguage.cheque
                                                            ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12))
                                                            : const SizedBox(),
                                                        context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                                getIt<Variables>().generalVariables.currentLanguage.cheque
                                                            ? Container(
                                                                height: getIt<Functions>().getWidgetHeight(height: 44),
                                                                padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 21)),
                                                                child: TextFormField(
                                                                  controller: branchNameController,
                                                                  keyboardType: TextInputType.text,
                                                                  onChanged: (value) {
                                                                    context.read<WarehousePickupSummaryBloc>().branch = value;
                                                                  },
                                                                  decoration: InputDecoration(
                                                                      fillColor: const Color(0xffffffff),
                                                                      filled: true,
                                                                      contentPadding: EdgeInsets.symmetric(
                                                                          horizontal: getIt<Functions>().getWidgetWidth(width: 15),
                                                                          vertical: getIt<Functions>().getWidgetHeight(height: 15)),
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
                                                                      hintText: getIt<Variables>()
                                                                          .generalVariables
                                                                          .currentLanguage
                                                                          .branchName
                                                                          .toLowerCase(),
                                                                      hintStyle: TextStyle(
                                                                          color: const Color(0xff8A8D8E),
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                                                ),
                                                              )
                                                            : const SizedBox(),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                      getIt<Variables>().generalVariables.currentLanguage.cheque
                                                  ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20))
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                      getIt<Variables>().generalVariables.currentLanguage.cheque
                                                  ? Row(
                                                      children: [
                                                        Expanded(
                                                            child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 21)),
                                                              child: Text(
                                                                  getIt<Variables>()
                                                                      .generalVariables
                                                                      .currentLanguage
                                                                      .chequeFront
                                                                      .toLowerCase()
                                                                      .replaceFirst("c", "C"),
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                                      fontWeight: FontWeight.w600,
                                                                      color: const Color(0xff282F3A))),
                                                            ),
                                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                                            Padding(
                                                                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 21)),
                                                                child: context.read<WarehousePickupSummaryBloc>().checkFrontLoader
                                                                    ? Container(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 150),
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                                        child: DottedBorder(
                                                                          color: const Color(0xffCBD0DC),
                                                                          strokeWidth: 1,
                                                                          borderType: BorderType.RRect,
                                                                          dashPattern: const [6, 3],
                                                                          radius: const Radius.circular(12),
                                                                          child: const Center(
                                                                            child: CircularProgressIndicator(),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : !context.read<WarehousePickupSummaryBloc>().checkFrontImage.canRemove
                                                                        ? InkWell(
                                                                            onTap: () {
                                                                              getIt<Variables>().generalVariables.popUpWidget =
                                                                                  cameraAlertDialog(fromWhere: 'CF', index: 0);
                                                                              getIt<Functions>().showAnimatedDialog(
                                                                                  context: context, isFromTop: false, isCloseDisabled: false);
                                                                            },
                                                                            child: Container(
                                                                              height: getIt<Functions>().getWidgetHeight(height: 150),
                                                                              decoration: BoxDecoration(
                                                                                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                                              child: DottedBorder(
                                                                                color: const Color(0xffCBD0DC),
                                                                                strokeWidth: 1,
                                                                                borderType: BorderType.RRect,
                                                                                dashPattern: const [6, 3],
                                                                                radius: const Radius.circular(12),
                                                                                child: Center(
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                        color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        SizedBox(
                                                                                            height: getIt<Functions>().getWidgetHeight(height: 22),
                                                                                            width: getIt<Functions>().getWidgetWidth(width: 22),
                                                                                            child: const Icon(Icons.add_circle_outline_outlined,
                                                                                                color: Colors.black, weight: 1.5)),
                                                                                        Text(
                                                                                          getIt<Variables>()
                                                                                              .generalVariables
                                                                                              .currentLanguage
                                                                                              .chooseOrCapture,
                                                                                          style: TextStyle(
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                              fontWeight: FontWeight.w500,
                                                                                              color: const Color(0xff282F3A)),
                                                                                          textAlign: TextAlign.start,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : Stack(
                                                                            alignment: Alignment.topRight,
                                                                            children: [
                                                                              Container(
                                                                                  height: getIt<Functions>().getWidgetHeight(height: 150),
                                                                                  width: getIt<Functions>().getWidgetWidth(width: 300),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(12),
                                                                                  ),
                                                                                  clipBehavior: Clip.hardEdge,
                                                                                  /* child: Image.network(
                                                                                    context
                                                                                        .read<WarehousePickupSummaryBloc>()
                                                                                        .checkFrontImage
                                                                                        .imagePath,
                                                                                    fit: BoxFit.fill,
                                                                                    loadingBuilder: (context, child, loadingProgress) =>
                                                                                        loadingProgress != null
                                                                                            ? Shimmer.fromColors(
                                                                                                baseColor: Colors.white24,
                                                                                                highlightColor: Colors.grey,
                                                                                                child: Container(
                                                                                                  width: getIt<Functions>().getWidgetWidth(width: 82),
                                                                                                  decoration: const BoxDecoration(color: Colors.red),
                                                                                                ),
                                                                                              )
                                                                                            : child,
                                                                                  )*/
                                                                                  child: Image.file(
                                                                                    context.read<WarehousePickupSummaryBloc>().checkFrontImageFile,
                                                                                    fit: BoxFit.fill,
                                                                                  )),
                                                                              context.read<WarehousePickupSummaryBloc>().checkFrontImage.canRemove
                                                                                  ? InkWell(
                                                                                      onTap: () {
                                                                                        context
                                                                                            .read<WarehousePickupSummaryBloc>()
                                                                                            .checkFrontImage
                                                                                            .imagePath = "";
                                                                                        context
                                                                                            .read<WarehousePickupSummaryBloc>()
                                                                                            .checkFrontImage
                                                                                            .imageName = "";
                                                                                        context
                                                                                            .read<WarehousePickupSummaryBloc>()
                                                                                            .checkFrontImage
                                                                                            .canRemove = false;
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
                                                                                          child:
                                                                                              const Icon(Icons.clear, color: Colors.white, size: 15)),
                                                                                    )
                                                                                  : const SizedBox()
                                                                            ],
                                                                          ))
                                                          ],
                                                        )),
                                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 50)),
                                                        Expanded(
                                                            child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 21)),
                                                              child: Text(
                                                                  getIt<Variables>()
                                                                      .generalVariables
                                                                      .currentLanguage
                                                                      .chequeBack
                                                                      .toLowerCase()
                                                                      .replaceFirst("c", "C"),
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                                      fontWeight: FontWeight.w600,
                                                                      color: const Color(0xff282F3A))),
                                                            ),
                                                            SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                                            Padding(
                                                                padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 21)),
                                                                child: context.read<WarehousePickupSummaryBloc>().checkBackLoader
                                                                    ? Container(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 150),
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                                        child: DottedBorder(
                                                                          color: const Color(0xffCBD0DC),
                                                                          strokeWidth: 1,
                                                                          borderType: BorderType.RRect,
                                                                          dashPattern: const [6, 3],
                                                                          radius: const Radius.circular(12),
                                                                          child: const Center(
                                                                            child: CircularProgressIndicator(),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : !context.read<WarehousePickupSummaryBloc>().checkBackImage.canRemove
                                                                        ? InkWell(
                                                                            onTap: () {
                                                                              getIt<Variables>().generalVariables.popUpWidget =
                                                                                  cameraAlertDialog(fromWhere: 'CB', index: 0);
                                                                              getIt<Functions>().showAnimatedDialog(
                                                                                  context: context, isFromTop: false, isCloseDisabled: false);
                                                                            },
                                                                            child: Container(
                                                                              height: getIt<Functions>().getWidgetHeight(height: 150),
                                                                              decoration: BoxDecoration(
                                                                                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                                              child: DottedBorder(
                                                                                color: const Color(0xffCBD0DC),
                                                                                strokeWidth: 1,
                                                                                borderType: BorderType.RRect,
                                                                                dashPattern: const [6, 3],
                                                                                radius: const Radius.circular(12),
                                                                                child: Center(
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                        color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        SizedBox(
                                                                                            height: getIt<Functions>().getWidgetHeight(height: 22),
                                                                                            width: getIt<Functions>().getWidgetWidth(width: 22),
                                                                                            child: const Icon(Icons.add_circle_outline_outlined,
                                                                                                color: Colors.black, weight: 1.5)),
                                                                                        Text(
                                                                                          getIt<Variables>()
                                                                                              .generalVariables
                                                                                              .currentLanguage
                                                                                              .chooseOrCapture,
                                                                                          style: TextStyle(
                                                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                              fontWeight: FontWeight.w500,
                                                                                              color: const Color(0xff282F3A)),
                                                                                          textAlign: TextAlign.start,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : Stack(
                                                                            alignment: Alignment.topRight,
                                                                            children: [
                                                                              Container(
                                                                                  height: getIt<Functions>().getWidgetHeight(height: 150),
                                                                                  width: getIt<Functions>().getWidgetWidth(width: 300),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(12),
                                                                                  ),
                                                                                  clipBehavior: Clip.hardEdge,
                                                                                  /* child: Image.network(
                                                                                    context
                                                                                        .read<WarehousePickupSummaryBloc>()
                                                                                        .checkBackImage
                                                                                        .imagePath,
                                                                                    fit: BoxFit.fill,
                                                                                    loadingBuilder: (context, child, loadingProgress) =>
                                                                                        loadingProgress != null
                                                                                            ? Shimmer.fromColors(
                                                                                                baseColor: Colors.white24,
                                                                                                highlightColor: Colors.grey,
                                                                                                child: Container(
                                                                                                  width: getIt<Functions>().getWidgetWidth(width: 82),
                                                                                                  decoration: const BoxDecoration(color: Colors.red),
                                                                                                ),
                                                                                              )
                                                                                            : child,
                                                                                  )*/
                                                                                  child: Image.file(
                                                                                    context.read<WarehousePickupSummaryBloc>().checkBackImageFile,
                                                                                    fit: BoxFit.fill,
                                                                                  )),
                                                                              context.read<WarehousePickupSummaryBloc>().checkBackImage.canRemove
                                                                                  ? InkWell(
                                                                                      onTap: () {
                                                                                        context
                                                                                            .read<WarehousePickupSummaryBloc>()
                                                                                            .checkBackImage
                                                                                            .imagePath = "";
                                                                                        context
                                                                                            .read<WarehousePickupSummaryBloc>()
                                                                                            .checkBackImage
                                                                                            .imageName = "";
                                                                                        context
                                                                                            .read<WarehousePickupSummaryBloc>()
                                                                                            .checkBackImage
                                                                                            .canRemove = false;
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
                                                                                          child:
                                                                                              const Icon(Icons.clear, color: Colors.white, size: 15)),
                                                                                    )
                                                                                  : const SizedBox()
                                                                            ],
                                                                          ))
                                                          ],
                                                        )),
                                                      ],
                                                    )
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                      getIt<Variables>().generalVariables.currentLanguage.cheque
                                                  ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20))
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod != null
                                                  ? Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 21)),
                                                      child: Text(getIt<Variables>().generalVariables.currentLanguage.images,
                                                          style: TextStyle(
                                                              fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                              fontWeight: FontWeight.w600,
                                                              color: const Color(0xff282F3A))),
                                                    )
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod != null
                                                  ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12))
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod != null
                                                  ? SizedBox(
                                                      height: getIt<Functions>().getWidgetHeight(height: 105),
                                                      child: Padding(
                                                        padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 21)),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            context.read<WarehousePickupSummaryBloc>().otherImageLoader
                                                                ? Container(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 82),
                                                                    width: getIt<Functions>().getWidgetWidth(width: 75),
                                                                    margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                                    decoration:
                                                                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                                    child: const Center(child: CircularProgressIndicator()),
                                                                  )
                                                                : context.read<WarehousePickupSummaryBloc>().otherImages.length < 50
                                                                    ? InkWell(
                                                                        onTap: () {
                                                                          getIt<Variables>().generalVariables.popUpWidget =
                                                                              cameraAlertDialog(fromWhere: 'IMG', index: 0);
                                                                          getIt<Functions>().showAnimatedDialog(
                                                                              context: context, isFromTop: false, isCloseDisabled: false);
                                                                        },
                                                                        child: Container(
                                                                          height: getIt<Functions>().getWidgetHeight(height: 82),
                                                                          margin:
                                                                              EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                                          child: DottedBorder(
                                                                            color: const Color(0xffCBD0DC),
                                                                            strokeWidth: 1,
                                                                            borderType: BorderType.RRect,
                                                                            dashPattern: const [6, 3],
                                                                            radius: const Radius.circular(12),
                                                                            child: Container(
                                                                              margin: EdgeInsets.symmetric(
                                                                                  vertical: getIt<Functions>().getWidgetHeight(height: 10),
                                                                                  horizontal: getIt<Functions>().getWidgetWidth(width: 32)),
                                                                              decoration: BoxDecoration(
                                                                                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  SizedBox(
                                                                                      height: getIt<Functions>().getWidgetHeight(height: 22),
                                                                                      width: getIt<Functions>().getWidgetWidth(width: 22),
                                                                                      child: const Icon(Icons.add_circle_outline_outlined,
                                                                                          color: Colors.black, weight: 1.5)),
                                                                                  Text(
                                                                                    getIt<Variables>()
                                                                                        .generalVariables
                                                                                        .currentLanguage
                                                                                        .chooseOrCapture,
                                                                                    style: TextStyle(
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: const Color(0xff282F3A)),
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                  Text(
                                                                                    getIt<Variables>().generalVariables.currentLanguage.upTo50Photos,
                                                                                    style: TextStyle(
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: const Color(0xffA9ACB4)),
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 82),
                                                                        margin:
                                                                            EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12)),
                                                                        child: DottedBorder(
                                                                          color: const Color(0xffCBD0DC),
                                                                          strokeWidth: 1,
                                                                          borderType: BorderType.RRect,
                                                                          dashPattern: const [6, 3],
                                                                          radius: const Radius.circular(12),
                                                                          child: Container(
                                                                            margin: EdgeInsets.symmetric(
                                                                                vertical: getIt<Functions>().getWidgetHeight(height: 10),
                                                                                horizontal: getIt<Functions>().getWidgetWidth(width: 32)),
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12)),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                SizedBox(
                                                                                    height: getIt<Functions>().getWidgetHeight(height: 22),
                                                                                    width: getIt<Functions>().getWidgetWidth(width: 22),
                                                                                    child: const Icon(Icons.add_circle_outline_outlined,
                                                                                        color: Colors.black, weight: 1.5)),
                                                                                Text(
                                                                                  getIt<Variables>().generalVariables.currentLanguage.chooseOrCapture,
                                                                                  style: TextStyle(
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: const Color(0xff282F3A)),
                                                                                  textAlign: TextAlign.start,
                                                                                ),
                                                                                Text(
                                                                                  getIt<Variables>().generalVariables.currentLanguage.upTo50Photos,
                                                                                  style: TextStyle(
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: const Color(0xffA9ACB4)),
                                                                                  textAlign: TextAlign.start,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                            SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                            context.read<WarehousePickupSummaryBloc>().otherImages.isNotEmpty
                                                                ? Expanded(
                                                                    child: ListView.builder(
                                                                        padding: EdgeInsets.zero,
                                                                        physics: const BouncingScrollPhysics(),
                                                                        scrollDirection: Axis.horizontal,
                                                                        itemCount: context.read<WarehousePickupSummaryBloc>().otherImages.length,
                                                                        itemBuilder: (BuildContext context, int index) {
                                                                          return Stack(
                                                                            alignment: Alignment.topRight,
                                                                            children: [
                                                                              Container(
                                                                                  height: getIt<Functions>().getWidgetHeight(height: 82),
                                                                                  width: getIt<Functions>().getWidgetWidth(width: 82),
                                                                                  margin: EdgeInsets.only(
                                                                                      bottom: getIt<Functions>().getWidgetHeight(height: 20),
                                                                                      right: getIt<Functions>().getWidgetWidth(width: 10)),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(12),
                                                                                  ),
                                                                                  clipBehavior: Clip.hardEdge,
                                                                                  /*child: Image.network(
                                                                                    context
                                                                                        .read<WarehousePickupSummaryBloc>()
                                                                                        .otherImages[index]
                                                                                        .imagePath,
                                                                                    fit: BoxFit.fill,
                                                                                    loadingBuilder: (context, child, loadingProgress) =>
                                                                                        loadingProgress != null
                                                                                            ? Shimmer.fromColors(
                                                                                                baseColor: Colors.white24,
                                                                                                highlightColor: Colors.grey,
                                                                                                child: Container(
                                                                                                  width: getIt<Functions>().getWidgetWidth(width: 82),
                                                                                                  decoration: const BoxDecoration(color: Colors.red),
                                                                                                ),
                                                                                              )
                                                                                            : child,
                                                                                  )*/
                                                                                  child: Image.file(
                                                                                    context.read<WarehousePickupSummaryBloc>().otherImagesFile[index],
                                                                                    fit: BoxFit.fill,
                                                                                  )),
                                                                              context.read<WarehousePickupSummaryBloc>().otherImages[index].canRemove
                                                                                  ? InkWell(
                                                                                      onTap: () {
                                                                                        context
                                                                                            .read<WarehousePickupSummaryBloc>()
                                                                                            .otherImages[index]
                                                                                            .canRemove = false;
                                                                                        context
                                                                                            .read<WarehousePickupSummaryBloc>()
                                                                                            .otherImages
                                                                                            .removeAt(index);
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
                                                                                          child:
                                                                                              const Icon(Icons.clear, color: Colors.white, size: 15)),
                                                                                    )
                                                                                  : const SizedBox()
                                                                            ],
                                                                          );
                                                                        }),
                                                                  )
                                                                : const SizedBox(),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 21)),
                                                child: Text(getIt<Variables>().generalVariables.currentLanguage.comments,
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                        fontWeight: FontWeight.w600,
                                                        color: const Color(0xff282F3A))),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                              Container(
                                                height: getIt<Functions>().getWidgetHeight(height: 44),
                                                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 21)),
                                                child: TextFormField(
                                                  controller: commentController,
                                                  keyboardType: TextInputType.text,
                                                  onChanged: (value) {
                                                    context.read<WarehousePickupSummaryBloc>().paymentMethodComments = value;
                                                  },
                                                  decoration: InputDecoration(
                                                      fillColor: const Color(0xffffffff),
                                                      filled: true,
                                                      contentPadding: EdgeInsets.symmetric(
                                                          horizontal: getIt<Functions>().getWidgetWidth(width: 15),
                                                          vertical: getIt<Functions>().getWidgetHeight(height: 15)),
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
                                                      hintText: getIt<Variables>().generalVariables.currentLanguage.writeHere,
                                                      hintStyle: TextStyle(
                                                          color: const Color(0xff8A8D8E),
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                                ),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                            ],
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                              Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 14)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).orientation == Orientation.landscape
                                          ? getIt<Variables>().generalVariables.height
                                          : getIt<Variables>().generalVariables.width,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffE3E7EA),
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: getIt<Functions>().getWidgetWidth(width: 21),
                                          vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                      child: Text(
                                        getIt<Variables>().generalVariables.currentLanguage.proofOfDelivery,
                                        style: TextStyle(
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xff282F3A)),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                    Container(
                                      width: MediaQuery.of(context).orientation == Orientation.landscape
                                          ? getIt<Variables>().generalVariables.height
                                          : getIt<Variables>().generalVariables.width,
                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 21)),
                                      child: Wrap(
                                        alignment: WrapAlignment.start,
                                        spacing: getIt<Functions>().getWidgetWidth(width: 40),
                                        children: List<Widget>.generate(
                                          context.read<WarehousePickupSummaryBloc>().invoiceDataList.length,
                                          (idx) {
                                            return Padding(
                                              padding: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                              child: context.read<WarehousePickupSummaryBloc>().loadersList[idx]
                                                  ? Container(
                                                      height: getIt<Functions>().getWidgetHeight(height: 82),
                                                      width: getIt<Functions>().getWidgetWidth(width: 200),
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                                      child: DottedBorder(
                                                        color: const Color(0xffCBD0DC),
                                                        strokeWidth: 1,
                                                        borderType: BorderType.RRect,
                                                        dashPattern: const [6, 3],
                                                        radius: const Radius.circular(12),
                                                        child: const Center(
                                                          child: CircularProgressIndicator(),
                                                        ),
                                                      ),
                                                    )
                                                  : !context.read<WarehousePickupSummaryBloc>().invoiceImagesList[idx].canRemove
                                                      ? InkWell(
                                                          onTap: () {
                                                            getIt<Variables>().generalVariables.popUpWidget =
                                                                cameraAlertDialog(fromWhere: 'LIST', index: idx);
                                                            getIt<Functions>()
                                                                .showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                                          },
                                                          child: DottedBorder(
                                                            color: const Color(0xffCBD0DC),
                                                            strokeWidth: 1,
                                                            borderType: BorderType.RRect,
                                                            dashPattern: const [6, 3],
                                                            radius: const Radius.circular(12),
                                                            child: Container(
                                                              height: getIt<Functions>().getWidgetHeight(height: 82),
                                                              width: getIt<Functions>().getWidgetWidth(width: 200),
                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                                              child: Center(
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    SizedBox(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 22),
                                                                        width: getIt<Functions>().getWidgetWidth(width: 22),
                                                                        child: const Icon(Icons.add_circle_outline_outlined,
                                                                            color: Colors.black, weight: 1.5)),
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.chooseOrCapture,
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          fontWeight: FontWeight.w500,
                                                                          color: const Color(0xff282F3A)),
                                                                      textAlign: TextAlign.start,
                                                                    ),
                                                                    Text(
                                                                      "invoice # ${context.read<WarehousePickupSummaryBloc>().invoiceDataList[idx].invoiceNum}",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          fontWeight: FontWeight.w500,
                                                                          color: const Color(0xffA9ACB4)),
                                                                      textAlign: TextAlign.start,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Stack(
                                                          alignment: Alignment.topRight,
                                                          children: [
                                                            Container(
                                                                height: getIt<Functions>().getWidgetHeight(height: 82),
                                                                width: getIt<Functions>().getWidgetWidth(width: 200),
                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                                                clipBehavior: Clip.hardEdge,
                                                                /*child: Image.network(
                                                                  context.read<WarehousePickupSummaryBloc>().invoiceImagesList[idx].imagePath,
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
                                                                )*/
                                                                child: Image.file(
                                                                  context.read<WarehousePickupSummaryBloc>().invoiceImagesListFile[idx],
                                                                  fit: BoxFit.fill,
                                                                  /* loadingBuilder: (context, child, loadingProgress) => loadingProgress != null
                                                                      ? Shimmer.fromColors(
                                                                          baseColor: Colors.white24,
                                                                          highlightColor: Colors.grey,
                                                                          child: Container(
                                                                            width: getIt<Functions>().getWidgetWidth(width: 82),
                                                                            decoration: const BoxDecoration(color: Colors.red),
                                                                          ),
                                                                        )
                                                                      : child,*/
                                                                )),
                                                            context.read<WarehousePickupSummaryBloc>().invoiceImagesList[idx].canRemove
                                                                ? InkWell(
                                                                    onTap: () {
                                                                      context.read<WarehousePickupSummaryBloc>().invoiceImagesList[idx].imagePath =
                                                                          "";
                                                                      context.read<WarehousePickupSummaryBloc>().invoiceImagesList[idx].imageName =
                                                                          "";
                                                                      context.read<WarehousePickupSummaryBloc>().invoiceImagesList[idx].canRemove =
                                                                          false;
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
                                                        ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                    Padding(
                                      padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 21)),
                                      child: Text(getIt<Variables>().generalVariables.currentLanguage.others.toLowerCase().replaceFirst("o", "O"),
                                          style: TextStyle(
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff282F3A))),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                    SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 105),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 21)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            context.read<WarehousePickupSummaryBloc>().podLoader
                                                ? Container(
                                                    height: getIt<Functions>().getWidgetHeight(height: 82),
                                                    width: getIt<Functions>().getWidgetWidth(width: 75),
                                                    margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                    child: const Center(child: CircularProgressIndicator()),
                                                  )
                                                : context.read<WarehousePickupSummaryBloc>().proofOfDeliveryImages.length < 5
                                                    ? InkWell(
                                                        onTap: () {
                                                          getIt<Variables>().generalVariables.popUpWidget =
                                                              cameraAlertDialog(fromWhere: 'POD', index: 0);
                                                          getIt<Functions>()
                                                              .showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                                        },
                                                        child: Container(
                                                          height: getIt<Functions>().getWidgetHeight(height: 82),
                                                          margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                          child: DottedBorder(
                                                            color: const Color(0xffCBD0DC),
                                                            strokeWidth: 1,
                                                            borderType: BorderType.RRect,
                                                            dashPattern: const [6, 3],
                                                            radius: const Radius.circular(12),
                                                            child: Container(
                                                              margin: EdgeInsets.symmetric(
                                                                  vertical: getIt<Functions>().getWidgetHeight(height: 10),
                                                                  horizontal: getIt<Functions>().getWidgetWidth(width: 32)),
                                                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  SizedBox(
                                                                      height: getIt<Functions>().getWidgetHeight(height: 22),
                                                                      width: getIt<Functions>().getWidgetWidth(width: 22),
                                                                      child: const Icon(Icons.add_circle_outline_outlined,
                                                                          color: Colors.black, weight: 1.5)),
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.chooseOrCapture,
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        fontWeight: FontWeight.w500,
                                                                        color: const Color(0xff282F3A)),
                                                                    textAlign: TextAlign.start,
                                                                  ),
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.upTo5Photos,
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                        fontWeight: FontWeight.w500,
                                                                        color: const Color(0xffA9ACB4)),
                                                                    textAlign: TextAlign.start,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        height: getIt<Functions>().getWidgetHeight(height: 82),
                                                        margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                        decoration:
                                                            BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12)),
                                                        child: DottedBorder(
                                                          color: const Color(0xffCBD0DC),
                                                          strokeWidth: 1,
                                                          borderType: BorderType.RRect,
                                                          dashPattern: const [6, 3],
                                                          radius: const Radius.circular(12),
                                                          child: Container(
                                                            margin: EdgeInsets.symmetric(
                                                                vertical: getIt<Functions>().getWidgetHeight(height: 10),
                                                                horizontal: getIt<Functions>().getWidgetWidth(width: 32)),
                                                            decoration:
                                                                BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12)),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                SizedBox(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 22),
                                                                    width: getIt<Functions>().getWidgetWidth(width: 22),
                                                                    child: const Icon(Icons.add_circle_outline_outlined,
                                                                        color: Colors.black, weight: 1.5)),
                                                                Text(
                                                                  getIt<Variables>().generalVariables.currentLanguage.chooseOrCapture,
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      fontWeight: FontWeight.w500,
                                                                      color: const Color(0xff282F3A)),
                                                                  textAlign: TextAlign.start,
                                                                ),
                                                                Text(
                                                                  getIt<Variables>().generalVariables.currentLanguage.upTo5Photos,
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                      fontWeight: FontWeight.w500,
                                                                      color: const Color(0xffA9ACB4)),
                                                                  textAlign: TextAlign.start,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                            SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                            context.read<WarehousePickupSummaryBloc>().proofOfDeliveryImages.isNotEmpty
                                                ? Expanded(
                                                    child: ListView.builder(
                                                        padding: EdgeInsets.zero,
                                                        physics: const BouncingScrollPhysics(),
                                                        scrollDirection: Axis.horizontal,
                                                        itemCount: context.read<WarehousePickupSummaryBloc>().proofOfDeliveryImages.length,
                                                        itemBuilder: (BuildContext context, int index) {
                                                          return Stack(
                                                            alignment: Alignment.topRight,
                                                            children: [
                                                              Container(
                                                                  height: getIt<Functions>().getWidgetHeight(height: 82),
                                                                  width: getIt<Functions>().getWidgetWidth(width: 82),
                                                                  margin: EdgeInsets.only(
                                                                      bottom: getIt<Functions>().getWidgetHeight(height: 20),
                                                                      right: getIt<Functions>().getWidgetWidth(width: 10)),
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(12),
                                                                  ),
                                                                  clipBehavior: Clip.hardEdge,
                                                                  /*child: Image.network(
                                                                    context.read<WarehousePickupSummaryBloc>().proofOfDeliveryImages[index].imagePath,
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
                                                                  )*/
                                                                  child: Image.file(
                                                                    context.read<WarehousePickupSummaryBloc>().proofOfDeliveryImagesFile[index],
                                                                    fit: BoxFit.fill,
                                                                    /*loadingBuilder: (context, child, loadingProgress) => loadingProgress != null
                                                                        ? Shimmer.fromColors(
                                                                            baseColor: Colors.white24,
                                                                            highlightColor: Colors.grey,
                                                                            child: Container(
                                                                              width: getIt<Functions>().getWidgetWidth(width: 82),
                                                                              decoration: const BoxDecoration(color: Colors.red),
                                                                            ),
                                                                          )
                                                                        : child,*/
                                                                  )),
                                                              context.read<WarehousePickupSummaryBloc>().proofOfDeliveryImages[index].canRemove
                                                                  ? InkWell(
                                                                      onTap: () {
                                                                        context
                                                                            .read<WarehousePickupSummaryBloc>()
                                                                            .proofOfDeliveryImages[index]
                                                                            .canRemove = false;
                                                                        context
                                                                            .read<WarehousePickupSummaryBloc>()
                                                                            .proofOfDeliveryImages
                                                                            .removeAt(index);
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
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 14)),
                                  ],
                                ),
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                              Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 14)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).orientation == Orientation.landscape
                                          ? getIt<Variables>().generalVariables.height
                                          : getIt<Variables>().generalVariables.width,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffE3E7EA),
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: getIt<Functions>().getWidgetWidth(width: 21),
                                          vertical: getIt<Functions>().getWidgetHeight(height: 14)),
                                      child: Text(
                                        getIt<Variables>().generalVariables.currentLanguage.signature,
                                        style: TextStyle(
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xff282F3A)),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                    Row(
                                      children: [
                                        Container(
                                          height: getIt<Functions>().getWidgetHeight(height: 100),
                                          width: getIt<Functions>().getWidgetWidth(width: 167),
                                          padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 21)),
                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                          child: DottedBorder(
                                            color: const Color(0xffCBD0DC),
                                            strokeWidth: 1,
                                            borderType: BorderType.RRect,
                                            dashPattern: const [6, 3],
                                            radius: const Radius.circular(10),
                                            child: Container(
                                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset('assets/warehouse_list/signature.svg',
                                                        height: getIt<Functions>().getWidgetHeight(height: 22),
                                                        width: getIt<Functions>().getWidgetWidth(width: 22)),
                                                    Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.loaderSignature,
                                                      style: TextStyle(
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                          fontWeight: FontWeight.w600,
                                                          color: const Color(0xff282F3A)),
                                                      textAlign: TextAlign.start,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        getIt<Variables>().generalVariables.popUpWidget = signatureAlertDialog();
                                                        getIt<Functions>()
                                                            .showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: true);
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical: getIt<Functions>().getWidgetHeight(height: 6),
                                                            horizontal: getIt<Functions>().getWidgetWidth(width: 28)),
                                                        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(6)),
                                                        child: Text(
                                                          context.read<WarehousePickupSummaryBloc>().signatureSubmitted
                                                              ? getIt<Variables>().generalVariables.currentLanguage.reSign
                                                              : getIt<Variables>().generalVariables.currentLanguage.sign,
                                                          maxLines: 1,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: const Color(0xffffffff),
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 20)),
                                        context.read<WarehousePickupSummaryBloc>().signatureSubmitted
                                            ? Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  Container(
                                                      height: getIt<Functions>().getWidgetHeight(height: 100),
                                                      width: getIt<Functions>().getWidgetWidth(width: 173),
                                                      padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 21)),
                                                      decoration:
                                                          BoxDecoration(color: const Color(0xffE0E7EC), borderRadius: BorderRadius.circular(10)),
                                                      child: Center(
                                                        child: Image.memory(context.read<WarehousePickupSummaryBloc>().bytes!.buffer.asUint8List()),
                                                      )),
                                                  InkWell(
                                                    onTap: () {
                                                      context.read<WarehousePickupSummaryBloc>().signatureSubmitted = false;
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: getIt<Functions>().getWidgetWidth(width: 2),
                                                            vertical: getIt<Functions>().getWidgetHeight(height: 2)),
                                                        margin: EdgeInsets.symmetric(
                                                            horizontal: getIt<Functions>().getWidgetWidth(width: 3),
                                                            vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                        decoration: const BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.white,
                                                        ),
                                                        child: const Icon(
                                                          Icons.clear,
                                                          size: 15,
                                                        )),
                                                  )
                                                ],
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 21)),
                                      child: Text(
                                        getIt<Variables>().generalVariables.currentLanguage.remarks,
                                        style: TextStyle(
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xff282F3A)),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 21)),
                                      child: TextFormField(
                                        controller: remarksController,
                                        keyboardType: TextInputType.text,
                                        maxLines: 1,
                                        onChanged: (value) {
                                          context.read<WarehousePickupSummaryBloc>().overAllRemarks = value;
                                        },
                                        decoration: InputDecoration(
                                            fillColor: const Color(0xffffffff),
                                            filled: true,
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
                                            hintText: getIt<Variables>().generalVariables.currentLanguage.writeHere,
                                            hintStyle: TextStyle(
                                                color: const Color(0xff8A8D8E),
                                                fontWeight: FontWeight.w500,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 24)),
                                  ],
                                ),
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 30)),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        } else {
          return Container(
            color: const Color(0xffEEF4FF),
            child: Column(
              children: [
                BlocBuilder<WarehousePickupSummaryBloc, WarehousePickupSummaryState>(
                  builder: (BuildContext context, WarehousePickupSummaryState state) {
                    return SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: 250),
                      child: AppBar(
                        backgroundColor: const Color(0xff1D2736),
                        leading: IconButton(
                          onPressed: () {
                            getIt<Variables>().generalVariables.indexName = getIt<Variables>()
                                .generalVariables
                                .warehouseRouteList[getIt<Variables>().generalVariables.warehouseRouteList.length - 1];
                            context.read<NavigationBloc>().add(const NavigationInitialEvent());
                            getIt<Variables>()
                                .generalVariables
                                .warehouseRouteList
                                .removeAt(getIt<Variables>().generalVariables.warehouseRouteList.length - 1);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Color(0xffffffff),
                          ),
                        ),
                        titleSpacing: 0,
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${getIt<Variables>().generalVariables.currentLanguage.so} #:${getIt<Variables>().generalVariables.soListMainIdData.soNum}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 16),
                                  color: const Color(0xffffffff)),
                            ),
                            Text(
                              getIt<Variables>().generalVariables.soListMainIdData.soCustomerName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                  color: const Color(0xffAEAEB2)),
                            ),
                          ],
                        ),
                        actions: [
                          InkWell(
                              onTap: () {},
                              child: const Text(
                                '',
                              ))
                        ],
                        bottom: PreferredSize(
                          preferredSize: Size(
                              getIt<Functions>().getWidgetWidth(
                                  width: Orientation.portrait == MediaQuery.of(context).orientation
                                      ? getIt<Variables>().generalVariables.width
                                      : getIt<Variables>().generalVariables.height),
                              getIt<Functions>().getWidgetHeight(height: 140)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 14)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: getIt<Functions>().getWidgetHeight(height: 40),
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      InkWell(
                                        onTap: getIt<Variables>().generalVariables.isNetworkOffline
                                            ? () {}
                                            : () {
                                                getIt<Variables>().generalVariables.isStatusDrawer = true;
                                                Scaffold.of(context).openEndDrawer();
                                              },
                                        child: Row(
                                          children: [
                                            Center(
                                              child: SizedBox(
                                                height: getIt<Functions>().getWidgetHeight(height: 20),
                                                width: getIt<Functions>().getWidgetWidth(width: 20),
                                                child: SvgPicture.asset(
                                                  "assets/pick_list/status_image.svg",
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.status,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      color: const Color(0xffffffff)),
                                                ),
                                                Text(
                                                  getIt<Variables>().generalVariables.soListMainIdData.soStatus.toUpperCase(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      color: const Color(0xffF8B11D)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: getIt<Functions>().getWidgetWidth(width: 17.63)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 30),
                                        width: getIt<Functions>().getWidgetWidth(width: 0),
                                        child: const VerticalDivider(
                                          color: Color(0xffE0E7EC),
                                          width: 1,
                                        ),
                                      ),
                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 17.63)),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.numberOfItems.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xffffffff)),
                                          ),
                                          Text(
                                            "${getIt<Variables>().generalVariables.soListMainIdData.soNoOfLoadedItems} / ${getIt<Variables>().generalVariables.soListMainIdData.soNoOfItems}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xff5AC8EA)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 17.63)),
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 30),
                                        width: getIt<Functions>().getWidgetWidth(width: 0),
                                        child: const VerticalDivider(
                                          color: Color(0xffE0E7EC),
                                          width: 1,
                                        ),
                                      ),
                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 17.63)),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.dateAndTime,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xffffffff)),
                                          ),
                                          Text(
                                            getIt<Variables>().generalVariables.soListMainIdData.soCreatedTime,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xff5AC8EA)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 17.63)),
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 30),
                                        width: getIt<Functions>().getWidgetWidth(width: 0),
                                        child: const VerticalDivider(
                                          color: Color(0xffE0E7EC),
                                          width: 1,
                                        ),
                                      ),
                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 17.63)),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.loader.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xffffffff)),
                                          ),
                                          Text(
                                            getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.isNotEmpty
                                                ? getIt<Variables>().generalVariables.soListMainIdData.soHandledBy[0].name
                                                : "-",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xff5AC8EA)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 17.63)),
                                      SizedBox(
                                        height: getIt<Functions>().getWidgetHeight(height: 30),
                                        width: getIt<Functions>().getWidgetWidth(width: 0),
                                        child: const VerticalDivider(
                                          color: Color(0xffE0E7EC),
                                          width: 1,
                                        ),
                                      ),
                                      SizedBox(width: getIt<Functions>().getWidgetWidth(width: 17.63)),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getIt<Variables>().generalVariables.currentLanguage.loadedTime.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xffffffff)),
                                          ),
                                          Text(
                                            loadedTime,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                color: const Color(0xff5AC8EA)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 23)),
                                context.read<WarehousePickupSummaryBloc>().deliveredButton
                                    ? Container(
                                        height: getIt<Functions>().getWidgetHeight(height: 35),
                                        width: getIt<Functions>().getWidgetWidth(width: 175),
                                        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
                                        child: Center(
                                          child: Text(
                                            getIt<Variables>().generalVariables.currentLanguage.loading.toLowerCase(),
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: const Color(0xffffffff),
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          context.read<WarehousePickupSummaryBloc>().deliveredButton = true;
                                          context.read<WarehousePickupSummaryBloc>().add(const WarehousePickupSummarySetStateEvent());
                                          context.read<WarehousePickupSummaryBloc>().completeLoader = true;
                                          context.read<WarehousePickupSummaryBloc>().completeLoaderFailure = true;
                                          context.read<WarehousePickupSummaryBloc>().add(const WarehousePickupCompleteEvent(isLoading: false));
                                        },
                                        child: Container(
                                          height: getIt<Functions>().getWidgetHeight(height: 35),
                                          width: getIt<Functions>().getWidgetWidth(width: 175),
                                          decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(4)),
                                          child: Center(
                                            child: Text(
                                              getIt<Variables>().generalVariables.currentLanguage.markAsDelivered.toUpperCase(),
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: const Color(0xffffffff),
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 11),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 15)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: getIt<Functions>().getWidgetHeight(height: 30)),
                BlocConsumer<WarehousePickupSummaryBloc, WarehousePickupSummaryState>(
                  listener: (context, state) {
                    if (state is WarehousePickupSummaryError) {
                      getIt<Widgets>().flushBarWidget(context: context, message: state.message);
                    }
                    if (state is WarehousePickupSummaryDialog) {
                      getIt<Variables>().generalVariables.popUpWidget = deliverySuccessDialog();
                      getIt<Functions>().showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: true);
                    }
                  },
                  builder: (context, state) {
                    if (state is WarehousePickupSummaryLoaded) {
                      return Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: getIt<Functions>().getWidgetHeight(height: 40),
                                      decoration: const BoxDecoration(
                                        color: Color(0xffE3E7EA),
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(getIt<Variables>().generalVariables.currentLanguage.invoiceDetails,
                                              style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xff282F3A))),
                                          Text(
                                              "${getIt<Variables>().generalVariables.currentLanguage.totalAmount} : RS.${context.read<WarehousePickupSummaryBloc>().totalInvoiceAmount}",
                                              style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xff282F3A))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 30)),
                                    Container(
                                      height: getIt<Functions>()
                                          .getWidgetHeight(height: (context.read<WarehousePickupSummaryBloc>().invoiceDataList.length + 1) * 40),
                                      margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                      child: DataTable2(
                                          isVerticalScrollBarVisible: true,
                                          isHorizontalScrollBarVisible: false,
                                          headingRowDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                          columnSpacing: getIt<Functions>().getWidgetWidth(width: 0),
                                          horizontalMargin: getIt<Functions>().getWidgetWidth(width: 15),
                                          minWidth: 500,
                                          headingRowColor: const WidgetStatePropertyAll<Color>(Color(0xffE0E7EC)),
                                          headingRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                                          dividerThickness: 0,
                                          dataRowHeight: getIt<Functions>().getWidgetHeight(height: 40),
                                          columns: [
                                            DataColumn2(
                                              label: Text(
                                                getIt<Variables>().generalVariables.currentLanguage.invoice,
                                                style: TextStyle(
                                                    color: const Color(0xff282F3A),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                              ),
                                              size: ColumnSize.S,
                                            ),
                                            DataColumn2(
                                              label: Center(
                                                child: Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.items,
                                                  style: TextStyle(
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                ),
                                              ),
                                              size: ColumnSize.S,
                                            ),
                                            DataColumn2(
                                              label: Center(
                                                child: Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.loadingBay,
                                                  style: TextStyle(
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                ),
                                              ),
                                              size: ColumnSize.L,
                                            ),
                                            DataColumn2(
                                              label: Center(
                                                child: Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.dateAndTime,
                                                  style: TextStyle(
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                ),
                                              ),
                                              size: ColumnSize.L,
                                            ),
                                            DataColumn2(
                                              label: Center(
                                                child: Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.amount,
                                                  style: TextStyle(
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12)),
                                                ),
                                              ),
                                              size: ColumnSize.L,
                                            ),
                                          ],
                                          rows: List<DataRow>.generate(context.read<WarehousePickupSummaryBloc>().invoiceDataList.length, (index) {
                                            return DataRow(cells: [
                                              DataCell(Text(context.read<WarehousePickupSummaryBloc>().invoiceDataList[index].invoiceNum,
                                                  style: TextStyle(
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12)))),
                                              DataCell(Center(
                                                child: Text(context.read<WarehousePickupSummaryBloc>().invoiceDataList[index].invoiceItems,
                                                    style: TextStyle(
                                                        color: const Color(0xff282F3A),
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12))),
                                              )),
                                              DataCell(Text(
                                                  "${getIt<Variables>().generalVariables.soListMainIdData.tripLoadingBayDryName} / ${getIt<Variables>().generalVariables.soListMainIdData.tripLoadingBayFrozenName}",
                                                  style: TextStyle(
                                                      color: const Color(0xff282F3A),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12)))),
                                              DataCell(Center(
                                                child: Text(context.read<WarehousePickupSummaryBloc>().invoiceDataList[index].invoiceDate,
                                                    style: TextStyle(
                                                        color: const Color(0xff282F3A),
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12))),
                                              )),
                                              DataCell(Center(
                                                  child: Text("RS ${context.read<WarehousePickupSummaryBloc>().invoiceDataList[index].invoiceTotal}",
                                                      style: TextStyle(
                                                          color: const Color(0xff282F3A),
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12))))),
                                            ]);
                                          })),
                                    ),
                                    const Divider(
                                      color: Color(0XffE0E7EC),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(getIt<Variables>().generalVariables.currentLanguage.applyDiscount,
                                              style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xff282F3A))),
                                          FlutterSwitch(
                                            width: getIt<Functions>().getWidgetWidth(width: 46),
                                            height: getIt<Functions>().getWidgetHeight(height: 28),
                                            toggleSize: getIt<Functions>().getTextSize(fontSize: 20),
                                            value: context.read<WarehousePickupSummaryBloc>().isApplyDiscount,
                                            borderRadius: 13.33,
                                            padding: 1,
                                            showOnOff: false,
                                            activeColor: const Color(0xff34C759),
                                            inactiveColor: const Color(0xffE3E7EA),
                                            activeToggleColor: const Color(0xffFFFFFF),
                                            onToggle: (val) {
                                              context.read<WarehousePickupSummaryBloc>().isApplyDiscount =
                                                  !context.read<WarehousePickupSummaryBloc>().isApplyDiscount;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
                                    context.read<WarehousePickupSummaryBloc>().isApplyDiscount
                                        ? Column(
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 12)),
                                                    child: Text(getIt<Variables>().generalVariables.currentLanguage.discountApplied,
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                            fontWeight: FontWeight.w600,
                                                            color: const Color(0xff282F3A))),
                                                  ),
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                    child: SizedBox(
                                                      height: getIt<Functions>().getWidgetHeight(height: 44),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: TextFormField(
                                                                controller: discountPercentageController,
                                                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                                                                  hintText: getIt<Variables>().generalVariables.currentLanguage.enterAmountHere,
                                                                  hintStyle: TextStyle(
                                                                    color: const Color(0xff8A8D8E),
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                                  ),
                                                                  prefixIcon: SizedBox(
                                                                      width: getIt<Functions>().getWidgetWidth(width: 50),
                                                                      child: Center(
                                                                          child: Text("%",
                                                                              style: TextStyle(
                                                                                  color: const Color(0xff8A8D8E),
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14))))),
                                                                ),
                                                                style: TextStyle(
                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                                    fontWeight: FontWeight.w500,
                                                                    color: const Color(0xff282F3A),
                                                                    fontFamily: "Figtree"),
                                                                onChanged: (value) {
                                                                  if (value.isNotEmpty) {
                                                                    if (num.parse(value) > 0 && num.parse(value) < 100) {
                                                                      context.read<WarehousePickupSummaryBloc>().discountPercentage = value;
                                                                      discountValueController.text =
                                                                          (num.parse(context.read<WarehousePickupSummaryBloc>().totalInvoiceAmount) *
                                                                                  num.parse(value) /
                                                                                  100)
                                                                              .toStringAsFixed(2);
                                                                      payableAmountController.text =
                                                                          (num.parse(context.read<WarehousePickupSummaryBloc>().totalInvoiceAmount) -
                                                                                  num.parse(discountValueController.text))
                                                                              .toStringAsFixed(2);
                                                                    } else if (num.parse(value) == 0) {
                                                                      context.read<WarehousePickupSummaryBloc>().discountPercentage = "0";
                                                                      discountValueController.text = "0";
                                                                      payableAmountController.text =
                                                                          context.read<WarehousePickupSummaryBloc>().totalInvoiceAmount;
                                                                    } else if (num.parse(value) == 100) {
                                                                      context.read<WarehousePickupSummaryBloc>().discountPercentage = "100";
                                                                      discountValueController.text =
                                                                          context.read<WarehousePickupSummaryBloc>().totalInvoiceAmount;
                                                                      payableAmountController.text = "0";
                                                                    } else {
                                                                      context.read<WarehousePickupSummaryBloc>().discountPercentage = "0";
                                                                      discountValueController.text = "0";
                                                                      payableAmountController.text =
                                                                          context.read<WarehousePickupSummaryBloc>().totalInvoiceAmount;
                                                                    }
                                                                  } else {
                                                                    context.read<WarehousePickupSummaryBloc>().discountPercentage = "0";
                                                                    discountValueController.text = "0";
                                                                    payableAmountController.text =
                                                                        context.read<WarehousePickupSummaryBloc>().totalInvoiceAmount;
                                                                  }
                                                                }),
                                                          ),
                                                          SizedBox(width: getIt<Functions>().getWidgetWidth(width: 20)),
                                                          Expanded(
                                                            child: TextFormField(
                                                              controller: discountValueController,
                                                              keyboardType: TextInputType.text,
                                                              readOnly: true,
                                                              style: TextStyle(
                                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                                  fontWeight: FontWeight.w500,
                                                                  color: const Color(0xff282F3A),
                                                                  fontFamily: "Figtree"),
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
                                                                hintText: getIt<Variables>().generalVariables.currentLanguage.enterAmountHere,
                                                                hintStyle: TextStyle(
                                                                    color: const Color(0xff8A8D8E),
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                                prefixIcon: SizedBox(
                                                                    width: getIt<Functions>().getWidgetWidth(width: 50),
                                                                    child: Center(
                                                                        child: Text("Rs.",
                                                                            style: TextStyle(
                                                                                color: const Color(0xff8A8D8E),
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 14))))),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 12)),
                                                    child: Text(getIt<Variables>().generalVariables.currentLanguage.payableAmount,
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                            fontWeight: FontWeight.w600,
                                                            color: const Color(0xff282F3A))),
                                                  ),
                                                  SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                                  Container(
                                                    height: getIt<Functions>().getWidgetHeight(height: 44),
                                                    padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                    child: TextFormField(
                                                      controller: payableAmountController,
                                                      keyboardType: TextInputType.text,
                                                      readOnly: true,
                                                      style: TextStyle(
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                          fontWeight: FontWeight.w500,
                                                          color: const Color(0xff282F3A),
                                                          fontFamily: "Figtree"),
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
                                                        hintText: getIt<Variables>().generalVariables.currentLanguage.enterAmountHere,
                                                        hintStyle: TextStyle(
                                                            color: const Color(0xff8A8D8E),
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 14)),
                                                        prefixIcon: SizedBox(
                                                            width: getIt<Functions>().getWidgetWidth(width: 50),
                                                            child: Center(
                                                                child: Text("Rs.",
                                                                    style: TextStyle(
                                                                        color: const Color(0xff8A8D8E),
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 14))))),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(getIt<Variables>().generalVariables.currentLanguage.collectPayment,
                                              style: TextStyle(
                                                  fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xff282F3A))),
                                          FlutterSwitch(
                                            width: getIt<Functions>().getWidgetWidth(width: 40),
                                            height: getIt<Functions>().getWidgetHeight(height: 24),
                                            toggleSize: getIt<Functions>().getTextSize(fontSize: 20),
                                            value: context.read<WarehousePickupSummaryBloc>().isCollectPayment,
                                            borderRadius: 13.33,
                                            padding: 1,
                                            showOnOff: false,
                                            activeColor: const Color(0xff34C759),
                                            inactiveColor: const Color(0xffE3E7EA),
                                            activeToggleColor: const Color(0xffFFFFFF),
                                            onToggle: (val) {
                                              context.read<WarehousePickupSummaryBloc>().isCollectPayment =
                                                  !context.read<WarehousePickupSummaryBloc>().isCollectPayment;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 25)),
                                    context.read<WarehousePickupSummaryBloc>().isCollectPayment
                                        ? Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                child: Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.paymentMethod,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff282F3A),
                                                      fontFamily: "Figtree"),
                                                ),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                height: getIt<Functions>().getWidgetHeight(height: 45),
                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton2<String>(
                                                    isExpanded: true,
                                                    style: TextStyle(
                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                        fontWeight: FontWeight.w500,
                                                        color: const Color(0xff282F3A),
                                                        fontFamily: "Figtree"),
                                                    hint: Text(getIt<Variables>().generalVariables.currentLanguage.choosePaymentMethod,
                                                        style: TextStyle(
                                                            color: const Color(0xff8A8D8E),
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                                    items: [
                                                      getIt<Variables>().generalVariables.currentLanguage.cash,
                                                      getIt<Variables>().generalVariables.currentLanguage.cheque,
                                                      getIt<Variables>().generalVariables.currentLanguage.online,
                                                      getIt<Variables>().generalVariables.currentLanguage.deposit
                                                    ]
                                                        .map((element) => DropdownMenuItem<String>(
                                                              value: element,
                                                              child: Text(
                                                                element,
                                                                style: const TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    value: context.read<WarehousePickupSummaryBloc>().selectPaymentMethod,
                                                    onChanged: (String? suggestion) async {
                                                      context.read<WarehousePickupSummaryBloc>().selectPaymentMethod = suggestion;
                                                      context.read<WarehousePickupSummaryBloc>().add(const WarehousePickupSummarySetStateEvent());
                                                    },
                                                    iconStyleData: const IconStyleData(
                                                        icon: Icon(
                                                          Icons.keyboard_arrow_down,
                                                        ),
                                                        iconSize: 15,
                                                        iconEnabledColor: Color(0xff8A8D8E),
                                                        iconDisabledColor: Color(0xff8A8D8E)),
                                                    buttonStyleData: ButtonStyleData(
                                                      padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 15)),
                                                      decoration: BoxDecoration(
                                                          color: const Color(0xffffffff),
                                                          borderRadius: BorderRadius.circular(4),
                                                          border: Border.all(color: const Color(0xffE0E7EC), width: 0.73)),
                                                    ),
                                                    menuItemStyleData: const MenuItemStyleData(height: 40),
                                                    dropdownStyleData: DropdownStyleData(
                                                        maxHeight: 200,
                                                        decoration:
                                                            BoxDecoration(borderRadius: BorderRadius.circular(15), color: const Color(0xffffffff)),
                                                        elevation: 8,
                                                        offset: const Offset(0, 0)),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                child: Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.enterAmount,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff282F3A),
                                                      fontFamily: "Figtree"),
                                                ),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                              Container(
                                                height: getIt<Functions>().getWidgetHeight(height: 44),
                                                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                child: TextFormField(
                                                  controller: amountController,
                                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                  inputFormatters: [
                                                    DecimalTextInputFormatter(
                                                      maxDigitsBeforeDecimal: 7,
                                                      maxDigitsAfterDecimal: 2,
                                                    ),
                                                  ],
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff282F3A),
                                                      fontFamily: "Figtree"),
                                                  decoration: InputDecoration(
                                                      fillColor: const Color(0xffffffff),
                                                      filled: true,
                                                      contentPadding: EdgeInsets.symmetric(
                                                          horizontal: getIt<Functions>().getWidgetWidth(width: 15),
                                                          vertical: getIt<Functions>().getWidgetHeight(height: 15)),
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
                                                      hintText: getIt<Variables>().generalVariables.currentLanguage.enterAmountHere,
                                                      hintStyle: TextStyle(
                                                          color: const Color(0xff8A8D8E),
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                                  onChanged: (value) {
                                                    context.read<WarehousePickupSummaryBloc>().chequeAmount = value;
                                                  },
                                                ),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                          getIt<Variables>().generalVariables.currentLanguage.online ||
                                                      context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                          getIt<Variables>().generalVariables.currentLanguage.deposit
                                                  ? Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      child: Text(
                                                        getIt<Variables>()
                                                            .generalVariables
                                                            .currentLanguage
                                                            .referenceId
                                                            .toLowerCase()
                                                            .replaceFirst("r", "R"),
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                            fontWeight: FontWeight.w500,
                                                            color: const Color(0xff282F3A),
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    )
                                                  : context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                          getIt<Variables>().generalVariables.currentLanguage.cheque
                                                      ? Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                          child: Text(
                                                            getIt<Variables>()
                                                                .generalVariables
                                                                .currentLanguage
                                                                .chequeNumber
                                                                .toLowerCase()
                                                                .replaceFirst("c", "C"),
                                                            style: TextStyle(
                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                fontWeight: FontWeight.w500,
                                                                color: const Color(0xff282F3A),
                                                                fontFamily: "Figtree"),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                          getIt<Variables>().generalVariables.currentLanguage.online ||
                                                      context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                          getIt<Variables>().generalVariables.currentLanguage.deposit ||
                                                      context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                          getIt<Variables>().generalVariables.currentLanguage.cheque
                                                  ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12))
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                          getIt<Variables>().generalVariables.currentLanguage.online ||
                                                      context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                          getIt<Variables>().generalVariables.currentLanguage.deposit
                                                  ? Container(
                                                      height: getIt<Functions>().getWidgetHeight(height: 44),
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      child: TextFormField(
                                                        controller: referenceController,
                                                        keyboardType: TextInputType.text,
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                            fontWeight: FontWeight.w500,
                                                            color: const Color(0xff282F3A),
                                                            fontFamily: "Figtree"),
                                                        decoration: InputDecoration(
                                                            fillColor: const Color(0xffffffff),
                                                            filled: true,
                                                            contentPadding: EdgeInsets.symmetric(
                                                                horizontal: getIt<Functions>().getWidgetWidth(width: 15),
                                                                vertical: getIt<Functions>().getWidgetHeight(height: 15)),
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
                                                            hintText: getIt<Variables>().generalVariables.currentLanguage.referenceId.toLowerCase(),
                                                            hintStyle: TextStyle(
                                                                color: const Color(0xff8A8D8E),
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                                        onChanged: (value) {
                                                          context.read<WarehousePickupSummaryBloc>().referenceNo = value;
                                                        },
                                                      ),
                                                    )
                                                  : context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                          getIt<Variables>().generalVariables.currentLanguage.cheque
                                                      ? Container(
                                                          height: getIt<Functions>().getWidgetHeight(height: 44),
                                                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                          child: TextFormField(
                                                            controller: checkNoController,
                                                            keyboardType: TextInputType.text,
                                                            onChanged: (value) {
                                                              context.read<WarehousePickupSummaryBloc>().chequeNumber = value;
                                                            },
                                                            style: TextStyle(
                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                                fontWeight: FontWeight.w500,
                                                                color: const Color(0xff282F3A),
                                                                fontFamily: "Figtree"),
                                                            decoration: InputDecoration(
                                                                fillColor: const Color(0xffffffff),
                                                                filled: true,
                                                                contentPadding: EdgeInsets.symmetric(
                                                                    horizontal: getIt<Functions>().getWidgetWidth(width: 15),
                                                                    vertical: getIt<Functions>().getWidgetHeight(height: 15)),
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
                                                                hintText:
                                                                    getIt<Variables>().generalVariables.currentLanguage.chequeNumber.toLowerCase(),
                                                                hintStyle: TextStyle(
                                                                    color: const Color(0xff8A8D8E),
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                          getIt<Variables>().generalVariables.currentLanguage.online ||
                                                      context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                          getIt<Variables>().generalVariables.currentLanguage.deposit ||
                                                      context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                          getIt<Variables>().generalVariables.currentLanguage.cheque
                                                  ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12))
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                      getIt<Variables>().generalVariables.currentLanguage.cheque
                                                  ? Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      child: Text(
                                                        getIt<Variables>()
                                                            .generalVariables
                                                            .currentLanguage
                                                            .chequeDate
                                                            .toLowerCase()
                                                            .replaceFirst("c", "C"),
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                            fontWeight: FontWeight.w500,
                                                            color: const Color(0xff282F3A),
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                      getIt<Variables>().generalVariables.currentLanguage.cheque
                                                  ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12))
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                      getIt<Variables>().generalVariables.currentLanguage.cheque
                                                  ? Container(
                                                      height: getIt<Functions>().getWidgetHeight(height: 44),
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      child: TextFormField(
                                                        controller: checkDateController,
                                                        keyboardType: TextInputType.text,
                                                        readOnly: true,
                                                        onChanged: (value) {
                                                          context.read<WarehousePickupSummaryBloc>().chequeDate = value;
                                                        },
                                                        onTap: () {
                                                          context.read<WarehousePickupSummaryBloc>().filterCalenderEnabled =
                                                              !context.read<WarehousePickupSummaryBloc>().filterCalenderEnabled;
                                                          setState(() {});
                                                        },
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                            fontWeight: FontWeight.w500,
                                                            color: const Color(0xff282F3A),
                                                            fontFamily: "Figtree"),
                                                        decoration: InputDecoration(
                                                            fillColor: const Color(0xffffffff),
                                                            filled: true,
                                                            contentPadding: EdgeInsets.symmetric(
                                                                horizontal: getIt<Functions>().getWidgetWidth(width: 15),
                                                                vertical: getIt<Functions>().getWidgetHeight(height: 15)),
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
                                                            hintText: getIt<Variables>().generalVariables.currentLanguage.chequeDate.toLowerCase(),
                                                            hintStyle: TextStyle(
                                                                color: const Color(0xff8A8D8E),
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                      getIt<Variables>().generalVariables.currentLanguage.cheque
                                                  ? Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      child: AnimatedCrossFade(
                                                        firstChild: Container(
                                                          margin: const EdgeInsets.all(2),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                blurRadius: 4,
                                                                spreadRadius: 0,
                                                                color: Colors.black.withOpacity(0.3),
                                                              ),
                                                            ],
                                                          ),
                                                          clipBehavior: Clip.hardEdge,
                                                          child: SfDateRangePicker(
                                                            selectionMode: DateRangePickerSelectionMode.single,
                                                            controller: dateController,
                                                            initialSelectedDate: DateTime.parse(checkDateController.text),
                                                            backgroundColor: Colors.white,
                                                            toggleDaySelection: true,
                                                            showNavigationArrow: true,
                                                            headerHeight: 50,
                                                            showActionButtons: true,
                                                            headerStyle: const DateRangePickerHeaderStyle(
                                                                textAlign: TextAlign.center,
                                                                backgroundColor: Color(0xFF0C3788),
                                                                textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                                            onCancel: () {
                                                              context.read<WarehousePickupSummaryBloc>().filterCalenderEnabled =
                                                                  !context.read<WarehousePickupSummaryBloc>().filterCalenderEnabled;
                                                              setState(() {});
                                                            },
                                                            onSubmit: (value) {
                                                              context.read<WarehousePickupSummaryBloc>().filterCalenderEnabled =
                                                                  !context.read<WarehousePickupSummaryBloc>().filterCalenderEnabled;
                                                              setState(() {});
                                                            },
                                                            onSelectionChanged: (value) {
                                                              DateTime selectedDate = value.value;
                                                              checkDateController.text = selectedDate.toString().substring(0, 10);
                                                              context.read<WarehousePickupSummaryBloc>().chequeDate =
                                                                  selectedDate.toString().substring(0, 10);
                                                              setState(() {});
                                                            },
                                                            showTodayButton: false,
                                                            monthFormat: "MMMM",
                                                            monthViewSettings: const DateRangePickerMonthViewSettings(
                                                              firstDayOfWeek: 1,
                                                              dayFormat: "EE",
                                                              viewHeaderHeight: 50,
                                                            ),
                                                            view: DateRangePickerView.month,
                                                            minDate: DateTime(1800),
                                                            maxDate: DateTime(2200),
                                                          ),
                                                        ),
                                                        secondChild: const SizedBox(),
                                                        crossFadeState: context.read<WarehousePickupSummaryBloc>().filterCalenderEnabled
                                                            ? CrossFadeState.showFirst
                                                            : CrossFadeState.showSecond,
                                                        duration: const Duration(milliseconds: 500),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                      getIt<Variables>().generalVariables.currentLanguage.cheque
                                                  ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12))
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                      getIt<Variables>().generalVariables.currentLanguage.cheque
                                                  ? Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      child: Text(
                                                        getIt<Variables>()
                                                            .generalVariables
                                                            .currentLanguage
                                                            .bankName
                                                            .toLowerCase()
                                                            .replaceFirst("b", "B"),
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                            fontWeight: FontWeight.w500,
                                                            color: const Color(0xff282F3A),
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                      getIt<Variables>().generalVariables.currentLanguage.cheque
                                                  ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12))
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                      getIt<Variables>().generalVariables.currentLanguage.cheque
                                                  ? Container(
                                                      height: getIt<Functions>().getWidgetHeight(height: 44),
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      child: TextFormField(
                                                        controller: bankNameController,
                                                        keyboardType: TextInputType.text,
                                                        onChanged: (value) {
                                                          context.read<WarehousePickupSummaryBloc>().bank = value;
                                                        },
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                            fontWeight: FontWeight.w500,
                                                            color: const Color(0xff282F3A),
                                                            fontFamily: "Figtree"),
                                                        decoration: InputDecoration(
                                                            fillColor: const Color(0xffffffff),
                                                            filled: true,
                                                            contentPadding: EdgeInsets.symmetric(
                                                                horizontal: getIt<Functions>().getWidgetWidth(width: 15),
                                                                vertical: getIt<Functions>().getWidgetHeight(height: 15)),
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
                                                            hintText: getIt<Variables>().generalVariables.currentLanguage.bankName.toLowerCase(),
                                                            hintStyle: TextStyle(
                                                                color: const Color(0xff8A8D8E),
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                      getIt<Variables>().generalVariables.currentLanguage.cheque
                                                  ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12))
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                      getIt<Variables>().generalVariables.currentLanguage.cheque
                                                  ? Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      child: Text(
                                                        getIt<Variables>()
                                                            .generalVariables
                                                            .currentLanguage
                                                            .branchName
                                                            .toLowerCase()
                                                            .replaceFirst("b", "B"),
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                            fontWeight: FontWeight.w500,
                                                            color: const Color(0xff282F3A),
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                      getIt<Variables>().generalVariables.currentLanguage.cheque
                                                  ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12))
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                      getIt<Variables>().generalVariables.currentLanguage.cheque
                                                  ? Container(
                                                      height: getIt<Functions>().getWidgetHeight(height: 44),
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      child: TextFormField(
                                                        controller: branchNameController,
                                                        keyboardType: TextInputType.text,
                                                        onChanged: (value) {
                                                          context.read<WarehousePickupSummaryBloc>().branch = value;
                                                        },
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                            fontWeight: FontWeight.w500,
                                                            color: const Color(0xff282F3A),
                                                            fontFamily: "Figtree"),
                                                        decoration: InputDecoration(
                                                            fillColor: const Color(0xffffffff),
                                                            filled: true,
                                                            contentPadding: EdgeInsets.symmetric(
                                                                horizontal: getIt<Functions>().getWidgetWidth(width: 15),
                                                                vertical: getIt<Functions>().getWidgetHeight(height: 15)),
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
                                                            hintText: getIt<Variables>().generalVariables.currentLanguage.branchName.toLowerCase(),
                                                            hintStyle: TextStyle(
                                                                color: const Color(0xff8A8D8E),
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                      getIt<Variables>().generalVariables.currentLanguage.cheque
                                                  ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12))
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                      getIt<Variables>().generalVariables.currentLanguage.cheque
                                                  ? Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                          child: Text(
                                                            getIt<Variables>()
                                                                .generalVariables
                                                                .currentLanguage
                                                                .chequeFront
                                                                .toLowerCase()
                                                                .replaceFirst("c", "C"),
                                                            style: TextStyle(
                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                fontWeight: FontWeight.w500,
                                                                color: const Color(0xff282F3A),
                                                                fontFamily: "Figtree"),
                                                          ),
                                                        ),
                                                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                            child: context.read<WarehousePickupSummaryBloc>().checkFrontLoader
                                                                ? Container(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 150),
                                                                    decoration:
                                                                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                                    child: DottedBorder(
                                                                      color: const Color(0xffCBD0DC),
                                                                      strokeWidth: 1,
                                                                      borderType: BorderType.RRect,
                                                                      dashPattern: const [6, 3],
                                                                      radius: const Radius.circular(12),
                                                                      child: const Center(
                                                                        child: CircularProgressIndicator(),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : !context.read<WarehousePickupSummaryBloc>().checkFrontImage.canRemove
                                                                    ? InkWell(
                                                                        onTap: () {
                                                                          getIt<Variables>().generalVariables.popUpWidget =
                                                                              cameraAlertDialog(fromWhere: 'CF', index: 0);
                                                                          getIt<Functions>().showAnimatedDialog(
                                                                              context: context, isFromTop: false, isCloseDisabled: false);
                                                                        },
                                                                        child: Container(
                                                                          height: getIt<Functions>().getWidgetHeight(height: 150),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                                          child: DottedBorder(
                                                                            color: const Color(0xffCBD0DC),
                                                                            strokeWidth: 1,
                                                                            borderType: BorderType.RRect,
                                                                            dashPattern: const [6, 3],
                                                                            radius: const Radius.circular(12),
                                                                            child: Center(
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                    color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                        height: getIt<Functions>().getWidgetHeight(height: 22),
                                                                                        width: getIt<Functions>().getWidgetWidth(width: 22),
                                                                                        child: const Icon(Icons.add_circle_outline_outlined,
                                                                                            color: Colors.black, weight: 1.5)),
                                                                                    Text(
                                                                                      getIt<Variables>()
                                                                                          .generalVariables
                                                                                          .currentLanguage
                                                                                          .chooseOrCapture,
                                                                                      style: TextStyle(
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: const Color(0xff282F3A)),
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Stack(
                                                                        alignment: Alignment.topRight,
                                                                        children: [
                                                                          Container(
                                                                              height: getIt<Functions>().getWidgetHeight(height: 150),
                                                                              width: getIt<Variables>().generalVariables.width,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(12),
                                                                              ),
                                                                              clipBehavior: Clip.hardEdge,
                                                                              /* child: Image.network(
                                                                                context.read<WarehousePickupSummaryBloc>().checkFrontImage.imagePath,
                                                                                fit: BoxFit.fill,
                                                                                loadingBuilder: (context, child, loadingProgress) =>
                                                                                    loadingProgress != null
                                                                                        ? Shimmer.fromColors(
                                                                                            baseColor: Colors.white24,
                                                                                            highlightColor: Colors.grey,
                                                                                            child: Container(
                                                                                              width: getIt<Functions>().getWidgetWidth(width: 82),
                                                                                              decoration: const BoxDecoration(color: Colors.red),
                                                                                            ),
                                                                                          )
                                                                                        : child,
                                                                              )*/
                                                                              child: Image.file(
                                                                                context.read<WarehousePickupSummaryBloc>().checkFrontImageFile,
                                                                                fit: BoxFit.fill,
                                                                                /*loadingBuilder: (context, child, loadingProgress) =>
                                                                                    loadingProgress != null
                                                                                        ? Shimmer.fromColors(
                                                                                            baseColor: Colors.white24,
                                                                                            highlightColor: Colors.grey,
                                                                                            child: Container(
                                                                                              width: getIt<Functions>().getWidgetWidth(width: 82),
                                                                                              decoration: const BoxDecoration(color: Colors.red),
                                                                                            ),
                                                                                          )
                                                                                        : child,*/
                                                                              )),
                                                                          context.read<WarehousePickupSummaryBloc>().checkFrontImage.canRemove
                                                                              ? InkWell(
                                                                                  onTap: () {
                                                                                    context
                                                                                        .read<WarehousePickupSummaryBloc>()
                                                                                        .checkFrontImage
                                                                                        .imagePath = "";
                                                                                    context
                                                                                        .read<WarehousePickupSummaryBloc>()
                                                                                        .checkFrontImage
                                                                                        .imageName = "";
                                                                                    context
                                                                                        .read<WarehousePickupSummaryBloc>()
                                                                                        .checkFrontImage
                                                                                        .canRemove = false;
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
                                                                      )),
                                                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                          child: Text(
                                                            getIt<Variables>()
                                                                .generalVariables
                                                                .currentLanguage
                                                                .chequeBack
                                                                .toLowerCase()
                                                                .replaceFirst("c", "C"),
                                                            style: TextStyle(
                                                                fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                fontWeight: FontWeight.w500,
                                                                color: const Color(0xff282F3A),
                                                                fontFamily: "Figtree"),
                                                          ),
                                                        ),
                                                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                                        Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                            child: context.read<WarehousePickupSummaryBloc>().checkBackLoader
                                                                ? Container(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 150),
                                                                    decoration:
                                                                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                                    child: DottedBorder(
                                                                      color: const Color(0xffCBD0DC),
                                                                      strokeWidth: 1,
                                                                      borderType: BorderType.RRect,
                                                                      dashPattern: const [6, 3],
                                                                      radius: const Radius.circular(12),
                                                                      child: const Center(
                                                                        child: CircularProgressIndicator(),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : !context.read<WarehousePickupSummaryBloc>().checkBackImage.canRemove
                                                                    ? InkWell(
                                                                        onTap: () {
                                                                          getIt<Variables>().generalVariables.popUpWidget =
                                                                              cameraAlertDialog(fromWhere: 'CB', index: 0);
                                                                          getIt<Functions>().showAnimatedDialog(
                                                                              context: context, isFromTop: false, isCloseDisabled: false);
                                                                        },
                                                                        child: Container(
                                                                          height: getIt<Functions>().getWidgetHeight(height: 150),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                                          child: DottedBorder(
                                                                            color: const Color(0xffCBD0DC),
                                                                            strokeWidth: 1,
                                                                            borderType: BorderType.RRect,
                                                                            dashPattern: const [6, 3],
                                                                            radius: const Radius.circular(12),
                                                                            child: Center(
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                    color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                        height: getIt<Functions>().getWidgetHeight(height: 22),
                                                                                        width: getIt<Functions>().getWidgetWidth(width: 22),
                                                                                        child: const Icon(Icons.add_circle_outline_outlined,
                                                                                            color: Colors.black, weight: 1.5)),
                                                                                    Text(
                                                                                      getIt<Variables>()
                                                                                          .generalVariables
                                                                                          .currentLanguage
                                                                                          .chooseOrCapture,
                                                                                      style: TextStyle(
                                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: const Color(0xff282F3A)),
                                                                                      textAlign: TextAlign.start,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Stack(
                                                                        alignment: Alignment.topRight,
                                                                        children: [
                                                                          Container(
                                                                              height: getIt<Functions>().getWidgetHeight(height: 150),
                                                                              width: getIt<Variables>().generalVariables.width,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(12),
                                                                              ),
                                                                              clipBehavior: Clip.hardEdge,
                                                                              /*child: Image.network(
                                                                                context.read<WarehousePickupSummaryBloc>().checkBackImage.imagePath,
                                                                                fit: BoxFit.fill,
                                                                                loadingBuilder: (context, child, loadingProgress) =>
                                                                                    loadingProgress != null
                                                                                        ? Shimmer.fromColors(
                                                                                            baseColor: Colors.white24,
                                                                                            highlightColor: Colors.grey,
                                                                                            child: Container(
                                                                                              width: getIt<Functions>().getWidgetWidth(width: 82),
                                                                                              decoration: const BoxDecoration(color: Colors.red),
                                                                                            ),
                                                                                          )
                                                                                        : child,
                                                                              )*/
                                                                              child: Image.file(
                                                                                context.read<WarehousePickupSummaryBloc>().checkBackImageFile,
                                                                                fit: BoxFit.fill,
                                                                                /*loadingBuilder: (context, child, loadingProgress) =>
                                                                                    loadingProgress != null
                                                                                        ? Shimmer.fromColors(
                                                                                            baseColor: Colors.white24,
                                                                                            highlightColor: Colors.grey,
                                                                                            child: Container(
                                                                                              width: getIt<Functions>().getWidgetWidth(width: 82),
                                                                                              decoration: const BoxDecoration(color: Colors.red),
                                                                                            ),
                                                                                          )
                                                                                        : child,*/
                                                                              )),
                                                                          context.read<WarehousePickupSummaryBloc>().checkBackImage.canRemove
                                                                              ? InkWell(
                                                                                  onTap: () {
                                                                                    context
                                                                                        .read<WarehousePickupSummaryBloc>()
                                                                                        .checkBackImage
                                                                                        .imagePath = "";
                                                                                    context
                                                                                        .read<WarehousePickupSummaryBloc>()
                                                                                        .checkBackImage
                                                                                        .imageName = "";
                                                                                    context
                                                                                        .read<WarehousePickupSummaryBloc>()
                                                                                        .checkBackImage
                                                                                        .canRemove = false;
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
                                                                      ))
                                                      ],
                                                    )
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod ==
                                                      getIt<Variables>().generalVariables.currentLanguage.cheque
                                                  ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12))
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod != null
                                                  ? Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                      child: Text(
                                                        getIt<Variables>().generalVariables.currentLanguage.images,
                                                        style: TextStyle(
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                            fontWeight: FontWeight.w500,
                                                            color: const Color(0xff282F3A),
                                                            fontFamily: "Figtree"),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod != null
                                                  ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12))
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod != null
                                                  ? SizedBox(
                                                      height: getIt<Functions>().getWidgetHeight(height: 82),
                                                      child: Padding(
                                                        padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 12)),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            context.read<WarehousePickupSummaryBloc>().otherImageLoader
                                                                ? Container(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 82),
                                                                    width: getIt<Functions>().getWidgetWidth(width: 75),
                                                                    margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                                    decoration:
                                                                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                                    child: const Center(child: CircularProgressIndicator()),
                                                                  )
                                                                : context.read<WarehousePickupSummaryBloc>().otherImages.length < 50
                                                                    ? InkWell(
                                                                        onTap: () {
                                                                          getIt<Variables>().generalVariables.popUpWidget =
                                                                              cameraAlertDialog(fromWhere: 'IMG', index: 0);
                                                                          getIt<Functions>().showAnimatedDialog(
                                                                              context: context, isFromTop: false, isCloseDisabled: false);
                                                                        },
                                                                        child: Container(
                                                                          height: getIt<Functions>().getWidgetHeight(height: 82),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                                          child: DottedBorder(
                                                                            color: const Color(0xffCBD0DC),
                                                                            strokeWidth: 1,
                                                                            borderType: BorderType.RRect,
                                                                            dashPattern: const [6, 3],
                                                                            radius: const Radius.circular(12),
                                                                            child: Container(
                                                                              margin: EdgeInsets.symmetric(
                                                                                  vertical: getIt<Functions>().getWidgetHeight(height: 10),
                                                                                  horizontal: getIt<Functions>().getWidgetWidth(width: 16)),
                                                                              decoration: BoxDecoration(
                                                                                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  SizedBox(
                                                                                      height: getIt<Functions>().getWidgetHeight(height: 22),
                                                                                      width: getIt<Functions>().getWidgetWidth(width: 22),
                                                                                      child: const Icon(Icons.add_circle_outline_outlined,
                                                                                          color: Colors.black, weight: 1.5)),
                                                                                  Text(
                                                                                    getIt<Variables>().generalVariables.currentLanguage.choose,
                                                                                    style: TextStyle(
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: const Color(0xff282F3A)),
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                  Text(
                                                                                    getIt<Variables>().generalVariables.currentLanguage.upTo50Photos,
                                                                                    style: TextStyle(
                                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 8),
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: const Color(0xffA9ACB4)),
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 82),
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12)),
                                                                        child: DottedBorder(
                                                                          color: const Color(0xffCBD0DC),
                                                                          strokeWidth: 1,
                                                                          borderType: BorderType.RRect,
                                                                          dashPattern: const [6, 3],
                                                                          radius: const Radius.circular(12),
                                                                          child: Container(
                                                                            margin: EdgeInsets.symmetric(
                                                                                vertical: getIt<Functions>().getWidgetHeight(height: 10),
                                                                                horizontal: getIt<Functions>().getWidgetWidth(width: 16)),
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12)),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                SizedBox(
                                                                                    height: getIt<Functions>().getWidgetHeight(height: 22),
                                                                                    width: getIt<Functions>().getWidgetWidth(width: 22),
                                                                                    child: const Icon(Icons.add_circle_outline_outlined,
                                                                                        color: Colors.black, weight: 1.5)),
                                                                                Text(
                                                                                  getIt<Variables>().generalVariables.currentLanguage.choose,
                                                                                  style: TextStyle(
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: const Color(0xff282F3A)),
                                                                                  textAlign: TextAlign.start,
                                                                                ),
                                                                                Text(
                                                                                  getIt<Variables>().generalVariables.currentLanguage.upTo50Photos,
                                                                                  style: TextStyle(
                                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 8),
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: const Color(0xffA9ACB4)),
                                                                                  textAlign: TextAlign.start,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                            SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                                            context.read<WarehousePickupSummaryBloc>().otherImages.isNotEmpty
                                                                ? Expanded(
                                                                    child: ListView.builder(
                                                                        padding: EdgeInsets.zero,
                                                                        physics: const BouncingScrollPhysics(),
                                                                        scrollDirection: Axis.horizontal,
                                                                        itemCount: context.read<WarehousePickupSummaryBloc>().otherImages.length,
                                                                        itemBuilder: (BuildContext context, int index) {
                                                                          return Stack(
                                                                            alignment: Alignment.topRight,
                                                                            children: [
                                                                              Container(
                                                                                  height: getIt<Functions>().getWidgetHeight(height: 82),
                                                                                  width: getIt<Functions>().getWidgetWidth(width: 82),
                                                                                  margin: EdgeInsets.only(
                                                                                      right: getIt<Functions>().getWidgetWidth(width: 10)),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(12),
                                                                                  ),
                                                                                  clipBehavior: Clip.hardEdge,
                                                                                  /*child: Image.network(
                                                                                    context
                                                                                        .read<WarehousePickupSummaryBloc>()
                                                                                        .otherImages[index]
                                                                                        .imagePath,
                                                                                    fit: BoxFit.fill,
                                                                                    loadingBuilder: (context, child, loadingProgress) =>
                                                                                        loadingProgress != null
                                                                                            ? Shimmer.fromColors(
                                                                                                baseColor: Colors.white24,
                                                                                                highlightColor: Colors.grey,
                                                                                                child: Container(
                                                                                                  width: getIt<Functions>().getWidgetWidth(width: 82),
                                                                                                  decoration: const BoxDecoration(color: Colors.red),
                                                                                                ),
                                                                                              )
                                                                                            : child,
                                                                                  )*/
                                                                                  child: Image.file(
                                                                                    context.read<WarehousePickupSummaryBloc>().otherImagesFile[index],
                                                                                    fit: BoxFit.fill,
                                                                                    /*loadingBuilder: (context, child, loadingProgress) =>
                                                                                        loadingProgress != null
                                                                                            ? Shimmer.fromColors(
                                                                                                baseColor: Colors.white24,
                                                                                                highlightColor: Colors.grey,
                                                                                                child: Container(
                                                                                                  width: getIt<Functions>().getWidgetWidth(width: 82),
                                                                                                  decoration: const BoxDecoration(color: Colors.red),
                                                                                                ),
                                                                                              )
                                                                                            : child,*/
                                                                                  )),
                                                                              context.read<WarehousePickupSummaryBloc>().otherImages[index].canRemove
                                                                                  ? InkWell(
                                                                                      onTap: () {
                                                                                        context
                                                                                            .read<WarehousePickupSummaryBloc>()
                                                                                            .otherImages[index]
                                                                                            .canRemove = false;
                                                                                        context
                                                                                            .read<WarehousePickupSummaryBloc>()
                                                                                            .otherImages
                                                                                            .removeAt(index);
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
                                                                                          child:
                                                                                              const Icon(Icons.clear, color: Colors.white, size: 15)),
                                                                                    )
                                                                                  : const SizedBox()
                                                                            ],
                                                                          );
                                                                        }),
                                                                  )
                                                                : const SizedBox(),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod != null
                                                  ? SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12))
                                                  : const SizedBox(),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                child: Text(
                                                  getIt<Variables>().generalVariables.currentLanguage.comments,
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff282F3A),
                                                      fontFamily: "Figtree"),
                                                ),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                              Container(
                                                height: getIt<Functions>().getWidgetHeight(height: 44),
                                                padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                                child: TextFormField(
                                                  controller: commentController,
                                                  keyboardType: TextInputType.text,
                                                  onChanged: (value) {
                                                    context.read<WarehousePickupSummaryBloc>().paymentMethodComments = value;
                                                  },
                                                  style: TextStyle(
                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xff282F3A),
                                                      fontFamily: "Figtree"),
                                                  decoration: InputDecoration(
                                                      fillColor: const Color(0xffffffff),
                                                      filled: true,
                                                      contentPadding: EdgeInsets.symmetric(
                                                          horizontal: getIt<Functions>().getWidgetWidth(width: 15),
                                                          vertical: getIt<Functions>().getWidgetHeight(height: 15)),
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
                                                      hintText: getIt<Variables>().generalVariables.currentLanguage.writeHere,
                                                      hintStyle: TextStyle(
                                                          color: const Color(0xff8A8D8E),
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                                ),
                                              ),
                                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                            ],
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                              Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 14)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: getIt<Variables>().generalVariables.width,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffE3E7EA),
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                          vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                      child: Text(
                                        getIt<Variables>().generalVariables.currentLanguage.proofOfDelivery,
                                        style: TextStyle(
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xff282F3A)),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                    Container(
                                      width: getIt<Variables>().generalVariables.width,
                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 21)),
                                      child: Wrap(
                                        alignment: WrapAlignment.start,
                                        spacing: getIt<Functions>().getWidgetWidth(width: 25),
                                        children: List<Widget>.generate(
                                          context.read<WarehousePickupSummaryBloc>().invoiceDataList.length,
                                          (idx) {
                                            return Padding(
                                              padding: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                              child: context.read<WarehousePickupSummaryBloc>().loadersList[idx]
                                                  ? Container(
                                                      height: getIt<Functions>().getWidgetHeight(height: 82),
                                                      width: getIt<Functions>().getWidgetWidth(width: 90),
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                                      child: DottedBorder(
                                                        color: const Color(0xffCBD0DC),
                                                        strokeWidth: 1,
                                                        borderType: BorderType.RRect,
                                                        dashPattern: const [6, 3],
                                                        radius: const Radius.circular(12),
                                                        child: const Center(
                                                          child: CircularProgressIndicator(),
                                                        ),
                                                      ),
                                                    )
                                                  : !context.read<WarehousePickupSummaryBloc>().invoiceImagesList[idx].canRemove
                                                      ? InkWell(
                                                          onTap: () {
                                                            getIt<Variables>().generalVariables.popUpWidget =
                                                                cameraAlertDialog(fromWhere: 'LIST', index: idx);
                                                            getIt<Functions>()
                                                                .showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                                          },
                                                          child: DottedBorder(
                                                            color: const Color(0xffCBD0DC),
                                                            strokeWidth: 1,
                                                            borderType: BorderType.RRect,
                                                            dashPattern: const [6, 3],
                                                            radius: const Radius.circular(12),
                                                            child: Container(
                                                              height: getIt<Functions>().getWidgetHeight(height: 82),
                                                              width: getIt<Functions>().getWidgetWidth(width: 90),
                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                                              child: Center(
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    SizedBox(
                                                                        height: getIt<Functions>().getWidgetHeight(height: 22),
                                                                        width: getIt<Functions>().getWidgetWidth(width: 22),
                                                                        child: const Icon(Icons.add_circle_outline_outlined,
                                                                            color: Colors.black, weight: 1.5)),
                                                                    Text(
                                                                      getIt<Variables>().generalVariables.currentLanguage.choose,
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                          fontWeight: FontWeight.w500,
                                                                          color: const Color(0xff282F3A)),
                                                                      textAlign: TextAlign.start,
                                                                    ),
                                                                    Text(
                                                                      "# ${context.read<WarehousePickupSummaryBloc>().invoiceDataList[idx].invoiceNum}",
                                                                      style: TextStyle(
                                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 10),
                                                                          fontWeight: FontWeight.w500,
                                                                          color: const Color(0xffA9ACB4)),
                                                                      textAlign: TextAlign.start,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Stack(
                                                          alignment: Alignment.topRight,
                                                          children: [
                                                            Container(
                                                                height: getIt<Functions>().getWidgetHeight(height: 82),
                                                                width: getIt<Functions>().getWidgetWidth(width: 90),
                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                                                clipBehavior: Clip.hardEdge,
                                                                /*child: Image.network(
                                                                  context.read<WarehousePickupSummaryBloc>().invoiceImagesList[idx].imagePath,
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
                                                                )*/
                                                                child: Image.file(
                                                                  context.read<WarehousePickupSummaryBloc>().invoiceImagesListFile[idx],
                                                                  fit: BoxFit.fill,
                                                                  /* loadingBuilder: (context, child, loadingProgress) => loadingProgress != null
                                                                      ? Shimmer.fromColors(
                                                                          baseColor: Colors.white24,
                                                                          highlightColor: Colors.grey,
                                                                          child: Container(
                                                                            width: getIt<Functions>().getWidgetWidth(width: 82),
                                                                            decoration: const BoxDecoration(color: Colors.red),
                                                                          ),
                                                                        )
                                                                      : child,*/
                                                                )),
                                                            context.read<WarehousePickupSummaryBloc>().invoiceImagesList[idx].canRemove
                                                                ? InkWell(
                                                                    onTap: () {
                                                                      context.read<WarehousePickupSummaryBloc>().invoiceImagesList[idx].imagePath =
                                                                          "";
                                                                      context.read<WarehousePickupSummaryBloc>().invoiceImagesList[idx].imageName =
                                                                          "";
                                                                      context.read<WarehousePickupSummaryBloc>().invoiceImagesList[idx].canRemove =
                                                                          false;
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
                                                        ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                    Padding(
                                      padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 21)),
                                      child: Text(getIt<Variables>().generalVariables.currentLanguage.others.toLowerCase().replaceFirst("o", "O"),
                                          style: TextStyle(
                                              fontSize: getIt<Functions>().getTextSize(fontSize: 14),
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff282F3A))),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                    SizedBox(
                                      height: getIt<Functions>().getWidgetHeight(height: 82),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 12)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            context.read<WarehousePickupSummaryBloc>().podLoader
                                                ? Container(
                                                    height: getIt<Functions>().getWidgetHeight(height: 82),
                                                    width: getIt<Functions>().getWidgetWidth(width: 75),
                                                    //margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                    child: const Center(child: CircularProgressIndicator()),
                                                  )
                                                : context.read<WarehousePickupSummaryBloc>().proofOfDeliveryImages.length < 5
                                                    ? InkWell(
                                                        onTap: () {
                                                          getIt<Variables>().generalVariables.popUpWidget =
                                                              cameraAlertDialog(fromWhere: 'POD', index: 0);
                                                          getIt<Functions>()
                                                              .showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: false);
                                                        },
                                                        child: Container(
                                                          height: getIt<Functions>().getWidgetHeight(height: 82),
                                                          //margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                          child: DottedBorder(
                                                            color: const Color(0xffCBD0DC),
                                                            strokeWidth: 1,
                                                            borderType: BorderType.RRect,
                                                            dashPattern: const [6, 3],
                                                            radius: const Radius.circular(12),
                                                            child: Container(
                                                              margin: EdgeInsets.symmetric(
                                                                  vertical: getIt<Functions>().getWidgetHeight(height: 10),
                                                                  horizontal: getIt<Functions>().getWidgetWidth(width: 16)),
                                                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  SizedBox(
                                                                      height: getIt<Functions>().getWidgetHeight(height: 22),
                                                                      width: getIt<Functions>().getWidgetWidth(width: 22),
                                                                      child: const Icon(Icons.add_circle_outline_outlined,
                                                                          color: Colors.black, weight: 1.5)),
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.choose,
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                        fontWeight: FontWeight.w500,
                                                                        color: const Color(0xff282F3A)),
                                                                    textAlign: TextAlign.start,
                                                                  ),
                                                                  Text(
                                                                    getIt<Variables>().generalVariables.currentLanguage.upTo5Photos,
                                                                    style: TextStyle(
                                                                        fontSize: getIt<Functions>().getTextSize(fontSize: 8),
                                                                        fontWeight: FontWeight.w500,
                                                                        color: const Color(0xffA9ACB4)),
                                                                    textAlign: TextAlign.start,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        height: getIt<Functions>().getWidgetHeight(height: 82),
                                                        //margin: EdgeInsets.only(bottom: getIt<Functions>().getWidgetHeight(height: 15)),
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey.shade300,
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        child: DottedBorder(
                                                          color: const Color(0xffCBD0DC),
                                                          strokeWidth: 1,
                                                          borderType: BorderType.RRect,
                                                          dashPattern: const [6, 3],
                                                          radius: const Radius.circular(12),
                                                          child: Container(
                                                            margin: EdgeInsets.symmetric(
                                                                vertical: getIt<Functions>().getWidgetHeight(height: 10),
                                                                horizontal: getIt<Functions>().getWidgetWidth(width: 16)),
                                                            decoration:
                                                                BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12)),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                SizedBox(
                                                                    height: getIt<Functions>().getWidgetHeight(height: 22),
                                                                    width: getIt<Functions>().getWidgetWidth(width: 22),
                                                                    child: const Icon(Icons.add_circle_outline_outlined,
                                                                        color: Colors.black, weight: 1.5)),
                                                                Text(
                                                                  getIt<Variables>().generalVariables.currentLanguage.choose,
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                                      fontWeight: FontWeight.w500,
                                                                      color: const Color(0xff282F3A)),
                                                                  textAlign: TextAlign.start,
                                                                ),
                                                                Text(
                                                                  getIt<Variables>().generalVariables.currentLanguage.upTo5Photos,
                                                                  style: TextStyle(
                                                                      fontSize: getIt<Functions>().getTextSize(fontSize: 8),
                                                                      fontWeight: FontWeight.w500,
                                                                      color: const Color(0xffA9ACB4)),
                                                                  textAlign: TextAlign.start,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                            SizedBox(width: getIt<Functions>().getWidgetWidth(width: 12)),
                                            context.read<WarehousePickupSummaryBloc>().proofOfDeliveryImages.isNotEmpty
                                                ? Expanded(
                                                    child: ListView.builder(
                                                        padding: EdgeInsets.zero,
                                                        physics: const BouncingScrollPhysics(),
                                                        scrollDirection: Axis.horizontal,
                                                        itemCount: context.read<WarehousePickupSummaryBloc>().proofOfDeliveryImages.length,
                                                        itemBuilder: (BuildContext context, int index) {
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
                                                                  /*child: Image.network(
                                                                    context.read<WarehousePickupSummaryBloc>().proofOfDeliveryImages[index].imagePath,
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
                                                                  )*/
                                                                  child: Image.file(
                                                                    context.read<WarehousePickupSummaryBloc>().proofOfDeliveryImagesFile[index],
                                                                    fit: BoxFit.fill,
                                                                    /*loadingBuilder: (context, child, loadingProgress) => loadingProgress != null
                                                                        ? Shimmer.fromColors(
                                                                            baseColor: Colors.white24,
                                                                            highlightColor: Colors.grey,
                                                                            child: Container(
                                                                              width: getIt<Functions>().getWidgetWidth(width: 82),
                                                                              decoration: const BoxDecoration(color: Colors.red),
                                                                            ),
                                                                          )
                                                                        : child,*/
                                                                  )),
                                                              context.read<WarehousePickupSummaryBloc>().proofOfDeliveryImages[index].canRemove
                                                                  ? InkWell(
                                                                      onTap: () {
                                                                        context
                                                                            .read<WarehousePickupSummaryBloc>()
                                                                            .proofOfDeliveryImages[index]
                                                                            .canRemove = false;
                                                                        context
                                                                            .read<WarehousePickupSummaryBloc>()
                                                                            .proofOfDeliveryImages
                                                                            .removeAt(index);
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
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                  ],
                                ),
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                              Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 14)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: getIt<Variables>().generalVariables.width,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffE3E7EA),
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: getIt<Functions>().getWidgetWidth(width: 12),
                                          vertical: getIt<Functions>().getWidgetHeight(height: 12)),
                                      child: Text(
                                        getIt<Variables>().generalVariables.currentLanguage.signature,
                                        style: TextStyle(
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xff282F3A)),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                    Row(
                                      children: [
                                        Container(
                                          height: getIt<Functions>().getWidgetHeight(height: 100),
                                          width: getIt<Functions>().getWidgetWidth(width: 167),
                                          padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 12)),
                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                          child: DottedBorder(
                                            color: const Color(0xffCBD0DC),
                                            strokeWidth: 1,
                                            borderType: BorderType.RRect,
                                            dashPattern: const [6, 3],
                                            radius: const Radius.circular(10),
                                            child: Container(
                                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset('assets/warehouse_list/signature.svg',
                                                        height: getIt<Functions>().getWidgetHeight(height: 22),
                                                        width: getIt<Functions>().getWidgetWidth(width: 22)),
                                                    Text(
                                                      getIt<Variables>().generalVariables.currentLanguage.loaderSignature,
                                                      style: TextStyle(
                                                          fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                          fontWeight: FontWeight.w600,
                                                          color: const Color(0xff282F3A)),
                                                      textAlign: TextAlign.start,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        getIt<Variables>().generalVariables.popUpWidget = signatureAlertDialog();
                                                        getIt<Functions>()
                                                            .showAnimatedDialog(context: context, isFromTop: false, isCloseDisabled: true);
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical: getIt<Functions>().getWidgetHeight(height: 6),
                                                            horizontal: getIt<Functions>().getWidgetWidth(width: 28)),
                                                        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(6)),
                                                        child: Text(
                                                          context.read<WarehousePickupSummaryBloc>().signatureSubmitted
                                                              ? getIt<Variables>().generalVariables.currentLanguage.reSign
                                                              : getIt<Variables>().generalVariables.currentLanguage.sign,
                                                          maxLines: 1,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: const Color(0xffffffff),
                                                            fontSize: getIt<Functions>().getTextSize(fontSize: 12),
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: getIt<Functions>().getWidgetWidth(width: 20)),
                                        context.read<WarehousePickupSummaryBloc>().signatureSubmitted
                                            ? Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  Container(
                                                      height: getIt<Functions>().getWidgetHeight(height: 100),
                                                      width: getIt<Functions>().getWidgetWidth(width: 173),
                                                      padding: EdgeInsets.only(right: getIt<Functions>().getWidgetWidth(width: 21)),
                                                      decoration:
                                                          BoxDecoration(color: const Color(0xffE0E7EC), borderRadius: BorderRadius.circular(10)),
                                                      child: Center(
                                                        child: Image.memory(context.read<WarehousePickupSummaryBloc>().bytes!.buffer.asUint8List()),
                                                      )),
                                                  InkWell(
                                                    onTap: () {
                                                      context.read<WarehousePickupSummaryBloc>().signatureSubmitted = false;
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: getIt<Functions>().getWidgetWidth(width: 2),
                                                            vertical: getIt<Functions>().getWidgetHeight(height: 2)),
                                                        margin: EdgeInsets.symmetric(
                                                            horizontal: getIt<Functions>().getWidgetWidth(width: 3),
                                                            vertical: getIt<Functions>().getWidgetHeight(height: 3)),
                                                        decoration: const BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.white,
                                                        ),
                                                        child: const Icon(
                                                          Icons.clear,
                                                          size: 15,
                                                        )),
                                                  )
                                                ],
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                      child: Text(
                                        getIt<Variables>().generalVariables.currentLanguage.remarks,
                                        style: TextStyle(
                                            fontSize: getIt<Functions>().getTextSize(fontSize: 13),
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xff282F3A)),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                    Container(
                                      height: getIt<Functions>().getWidgetHeight(height: 44),
                                      padding: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 12)),
                                      child: TextFormField(
                                        controller: remarksController,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            fillColor: const Color(0xffffffff),
                                            filled: true,
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
                                            hintText: getIt<Variables>().generalVariables.currentLanguage.writeHere,
                                            hintStyle: TextStyle(
                                                color: const Color(0xff8A8D8E),
                                                fontWeight: FontWeight.w400,
                                                fontSize: getIt<Functions>().getTextSize(fontSize: 14))),
                                      ),
                                    ),
                                    SizedBox(height: getIt<Functions>().getWidgetHeight(height: 12)),
                                  ],
                                ),
                              ),
                              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 20)),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget signatureAlertDialog() {
    return BlocConsumer<WarehousePickupSummaryBloc, WarehousePickupSummaryState>(
      listenWhen: (WarehousePickupSummaryState previous, WarehousePickupSummaryState current) {
        return previous != current;
      },
      buildWhen: (WarehousePickupSummaryState previous, WarehousePickupSummaryState current) {
        return previous != current;
      },
      listener: (BuildContext context, WarehousePickupSummaryState state) {},
      builder: (BuildContext context, WarehousePickupSummaryState state) {
        return SizedBox(
          width: getIt<Functions>().getWidgetWidth(width: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: getIt<Functions>().getWidgetWidth(width: 20)),
                child: Text(
                    '${getIt<Variables>().generalVariables.currentLanguage.customer} ${getIt<Variables>().generalVariables.currentLanguage.signature}',
                    style: TextStyle(
                        fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 20 : 16),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff282F3A))),
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 22)),
              Container(
                height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 286 : 186),
                margin: EdgeInsets.symmetric(horizontal: getIt<Functions>().getWidgetWidth(width: 20)),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: DottedBorder(
                  color: const Color(0xffCBD0DC),
                  strokeWidth: 1,
                  borderType: BorderType.RRect,
                  dashPattern: const [6, 3],
                  radius: const Radius.circular(12),
                  child: SfSignaturePad(
                    key: signatureGlobalKey,
                    backgroundColor: const Color(0xffE0E7EC),
                    strokeColor: Colors.black,
                    minimumStrokeWidth: 1.0,
                    maximumStrokeWidth: 4.0,
                  ),
                ),
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
              Row(children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: _handleClearButtonPressed,
                    child: Container(
                      height: getIt<Functions>().getWidgetHeight(height: 50),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12)),
                        color: Color(0xffE0E7EC),
                      ),
                      child: Center(
                          child: Text(getIt<Variables>().generalVariables.currentLanguage.clear.toUpperCase(),
                              style: TextStyle(
                                  fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 15 : 13),
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff282F3A)))),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: getIt<Functions>().getWidgetHeight(height: 50),
                      decoration: const BoxDecoration(
                        color: Color(0xffF92C38),
                      ),
                      child: Center(
                          child: Text(getIt<Variables>().generalVariables.currentLanguage.cancel.toUpperCase(),
                              style: TextStyle(
                                  fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 15 : 13),
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xffFFFFFF)))),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: _handleSaveButtonPressed,
                    child: Container(
                      height: getIt<Functions>().getWidgetHeight(height: 50),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(12)),
                        color: Color(0xff007838),
                      ),
                      child: Center(
                          child: Text(getIt<Variables>().generalVariables.currentLanguage.submit.toUpperCase(),
                              style: TextStyle(
                                  fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 15 : 13),
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xffFFFFFF)))),
                    ),
                  ),
                ),
              ])
            ],
          ),
        );
      },
    );
  }

  Widget cameraAlertDialog({required String fromWhere, required int index}) {
    return BlocConsumer<WarehousePickupSummaryBloc, WarehousePickupSummaryState>(
      listenWhen: (WarehousePickupSummaryState previous, WarehousePickupSummaryState current) {
        return previous != current;
      },
      buildWhen: (WarehousePickupSummaryState previous, WarehousePickupSummaryState current) {
        return previous != current;
      },
      listener: (BuildContext context1, WarehousePickupSummaryState state) {},
      builder: (BuildContext context1, WarehousePickupSummaryState state) {
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
                      int maxFiles = 0;
                      switch (fromWhere) {
                        case "CF":
                          maxFiles = context.read<WarehousePickupSummaryBloc>().checkFrontImage.imagePath == "" ? 1 : 0;
                          context.read<WarehousePickupSummaryBloc>().checkFrontLoader = true;
                          setState(() {});
                        case "CB":
                          maxFiles = context.read<WarehousePickupSummaryBloc>().checkBackImage.imagePath == "" ? 1 : 0;
                          context.read<WarehousePickupSummaryBloc>().checkBackLoader = true;
                          setState(() {});
                        case "POD":
                          maxFiles = context.read<WarehousePickupSummaryBloc>().proofOfDeliveryImages.isEmpty
                              ? 5
                              : 5 - context.read<WarehousePickupSummaryBloc>().proofOfDeliveryImages.length;
                          context.read<WarehousePickupSummaryBloc>().podLoader = true;
                          setState(() {});
                        case "IMG":
                          maxFiles = context.read<WarehousePickupSummaryBloc>().otherImages.isEmpty
                              ? 50
                              : 50 - context.read<WarehousePickupSummaryBloc>().otherImages.length;
                          context.read<WarehousePickupSummaryBloc>().otherImageLoader = true;
                          setState(() {});
                        case "LIST":
                          maxFiles = context.read<WarehousePickupSummaryBloc>().invoiceImagesList[index].imagePath == "" ? 1 : 0;
                          context.read<WarehousePickupSummaryBloc>().loadersList[index] = true;
                          setState(() {});
                        default:
                          maxFiles = context.read<WarehousePickupSummaryBloc>().checkFrontImage.imagePath == "" ? 1 : 0;
                          context.read<WarehousePickupSummaryBloc>().podLoader = true;
                          setState(() {});
                      }
                      /*await getIt<Functions>()
                            .uploadImages(
                            source: ImageSource.gallery,
                            maxImages: maxFiles,
                            context: context,
                            function: () {
                              Navigator.pop(context);
                            })
                            .then((data) {
                          if(data.urlsList.isNotEmpty){
                            switch (fromWhere) {
                              case "CF":
                                context.read<WarehousePickupSummaryBloc>().checkFrontImage =
                                    ImageDataClass(imageName: data.urlsNameList[0], imagePath: data.urlsList[0], canRemove: true);
                                context.read<WarehousePickupSummaryBloc>().checkFrontLoader = false;
                                context.read<WarehousePickupSummaryBloc>().chequeFront = data.urlsNameList[0];
                                setState(() {});
                              case "CB":
                                context.read<WarehousePickupSummaryBloc>().checkBackImage =
                                    ImageDataClass(imageName: data.urlsNameList[0], imagePath: data.urlsList[0], canRemove: true);
                                context.read<WarehousePickupSummaryBloc>().checkBackLoader = false;
                                context.read<WarehousePickupSummaryBloc>().chequeBack = data.urlsNameList[0];
                                setState(() {});
                              case "POD":
                                for (int i = 0; i < data.urlsList.length; i++) {
                                  context
                                      .read<WarehousePickupSummaryBloc>()
                                      .proofOfDeliveryImages
                                      .add(ImageDataClass(imageName: data.urlsNameList[i], imagePath: data.urlsList[i], canRemove: true));
                                }
                                context.read<WarehousePickupSummaryBloc>().proofOfDelivery =
                                    List.generate(data.urlsList.length, (i) => data.urlsNameList[i]).join(",");
                                context.read<WarehousePickupSummaryBloc>().podLoader = false;
                                setState(() {});
                              case "IMG":
                                for (int i = 0; i < data.urlsList.length; i++) {
                                  context
                                      .read<WarehousePickupSummaryBloc>()
                                      .otherImages
                                      .add(ImageDataClass(imageName: data.urlsNameList[i], imagePath: data.urlsList[i], canRemove: true));
                                }
                                context.read<WarehousePickupSummaryBloc>().paymentMethodImages =
                                    List.generate(data.urlsList.length, (i) => data.urlsNameList[i]);
                                context.read<WarehousePickupSummaryBloc>().otherImageLoader = false;
                                setState(() {});
                              case "LIST":
                                context.read<WarehousePickupSummaryBloc>().invoiceImagesList[index] =
                                    ImageDataClass(imageName: data.urlsNameList[0], imagePath: data.urlsList[0], canRemove: true);
                                context.read<WarehousePickupSummaryBloc>().loadersList[index] = false;
                                for (int i = 0; i < context.read<WarehousePickupSummaryBloc>().wareHousePickupSummaryApiBody.invoices.length; i++) {
                                  if (context.read<WarehousePickupSummaryBloc>().wareHousePickupSummaryApiBody.invoices[i].invoiceId ==
                                      context.read<WarehousePickupSummaryBloc>().invoiceDataList[index].invoiceId) {
                                    context.read<WarehousePickupSummaryBloc>().wareHousePickupSummaryApiBody.invoices[i].proofOfDelivery =
                                    data.urlsNameList[0];
                                    context.read<WarehousePickupSummaryBloc>().wareHousePickupSummaryApiBody.invoices[i].proofOfDeliveryUrl =
                                    data.urlsList[0];
                                  }
                                }
                                setState(() {});
                              default:
                                context.read<WarehousePickupSummaryBloc>().checkFrontImage =
                                    ImageDataClass(imageName: data.urlsNameList[0], imagePath: data.urlsList[0], canRemove: true);
                                context.read<WarehousePickupSummaryBloc>().checkFrontLoader = false;
                                setState(() {});
                            }
                          }
                        });*/
                      await getIt<Functions>()
                          .warehouseUploadImages(
                              source: ImageSource.gallery,
                              maxImages: maxFiles,
                              context: context,
                              function: () {
                                Navigator.pop(context);
                              })
                          .then((data) {
                        if (data.isNotEmpty) {
                          switch (fromWhere) {
                            case "CF":
                              context.read<WarehousePickupSummaryBloc>().checkFrontImage =
                                  ImageDataClass(imageName: data[0].path, imagePath: "", canRemove: true);
                              context.read<WarehousePickupSummaryBloc>().checkFrontImageFile = data[0];
                              context.read<WarehousePickupSummaryBloc>().checkFrontLoader = false;
                              //     context.read<WarehousePickupSummaryBloc>().chequeFront = data.urlsNameList[0];
                              setState(() {});
                            case "CB":
                              context.read<WarehousePickupSummaryBloc>().checkBackImage =
                                  ImageDataClass(imageName: data[0].path, imagePath: "", canRemove: true);
                              context.read<WarehousePickupSummaryBloc>().checkBackImageFile = data[0];
                              context.read<WarehousePickupSummaryBloc>().checkBackLoader = false;
                              //context.read<WarehousePickupSummaryBloc>().chequeBack = data.urlsNameList[0];
                              setState(() {});
                            case "POD":
                              for (int i = 0; i < data.length; i++) {
                                context
                                    .read<WarehousePickupSummaryBloc>()
                                    .proofOfDeliveryImages
                                    .add(ImageDataClass(imageName: data[i].path, imagePath: "", canRemove: true));
                                context.read<WarehousePickupSummaryBloc>().proofOfDeliveryImagesFile.add(data[i]);
                              }
                              /*context.read<WarehousePickupSummaryBloc>().proofOfDelivery =
                                  List.generate(data.urlsList.length, (i) => data.urlsNameList[i]).join(",");*/
                              context.read<WarehousePickupSummaryBloc>().podLoader = false;
                              setState(() {});
                            case "IMG":
                              for (int i = 0; i < data.length; i++) {
                                context
                                    .read<WarehousePickupSummaryBloc>()
                                    .otherImages
                                    .add(ImageDataClass(imageName: data[i].path, imagePath: "", canRemove: true));
                                context.read<WarehousePickupSummaryBloc>().otherImagesFile.add(data[i]);
                              }
                              /*context.read<WarehousePickupSummaryBloc>().paymentMethodImages =
                                  List.generate(data.urlsList.length, (i) => data.urlsNameList[i]);*/
                              context.read<WarehousePickupSummaryBloc>().otherImageLoader = false;
                              setState(() {});
                            case "LIST":
                              context.read<WarehousePickupSummaryBloc>().invoiceImagesList[index] =
                                  ImageDataClass(imageName: data[0].path, imagePath: "", canRemove: true);
                              context.read<WarehousePickupSummaryBloc>().invoiceImagesListFile[index] = data[0];
                              for (int i = 0; i < context.read<WarehousePickupSummaryBloc>().wareHousePickupSummaryApiBody.invoices.length; i++) {
                                if (context.read<WarehousePickupSummaryBloc>().wareHousePickupSummaryApiBody.invoices[i].invoiceId ==
                                    context.read<WarehousePickupSummaryBloc>().invoiceDataList[index].invoiceId) {
                                  context.read<WarehousePickupSummaryBloc>().wareHousePickupSummaryApiBody.invoices[i].proofOfDelivery = data[0].path;
                                  context.read<WarehousePickupSummaryBloc>().wareHousePickupSummaryApiBody.invoices[i].proofOfDeliveryUrl =
                                      data[0].path;
                                }
                              }
                              context.read<WarehousePickupSummaryBloc>().loadersList[index] = false;
                              setState(() {});
                            default:
                              context.read<WarehousePickupSummaryBloc>().checkFrontImage =
                                  ImageDataClass(imageName: data[0].path, imagePath: "", canRemove: true);
                              context.read<WarehousePickupSummaryBloc>().checkFrontImageFile = data[0];
                              context.read<WarehousePickupSummaryBloc>().checkFrontLoader = false;
                              setState(() {});
                          }
                        } else {
                          context.read<WarehousePickupSummaryBloc>().checkFrontLoader = false;
                          context.read<WarehousePickupSummaryBloc>().checkBackLoader = false;
                          context.read<WarehousePickupSummaryBloc>().podLoader = false;
                          context.read<WarehousePickupSummaryBloc>().otherImageLoader = false;
                          context.read<WarehousePickupSummaryBloc>().loadersList[index] = false;
                        }
                        setState(() {});
                      });
                    } catch (e) {
                      if (mounted) {
                        context.read<WarehousePickupSummaryBloc>().checkFrontLoader = false;
                        context.read<WarehousePickupSummaryBloc>().checkBackLoader = false;
                        context.read<WarehousePickupSummaryBloc>().podLoader = false;
                        context.read<WarehousePickupSummaryBloc>().otherImageLoader = false;
                        context.read<WarehousePickupSummaryBloc>().loadersList[index] = false;
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
                      int maxFiles = 0;
                      switch (fromWhere) {
                        case "CF":
                          maxFiles = context.read<WarehousePickupSummaryBloc>().checkFrontImage.imagePath == "" ? 1 : 0;
                          context.read<WarehousePickupSummaryBloc>().checkFrontLoader = true;
                          setState(() {});
                        case "CB":
                          maxFiles = context.read<WarehousePickupSummaryBloc>().checkBackImage.imagePath == "" ? 1 : 0;
                          context.read<WarehousePickupSummaryBloc>().checkBackLoader = true;
                          setState(() {});
                        case "POD":
                          maxFiles = context.read<WarehousePickupSummaryBloc>().proofOfDeliveryImages.isEmpty
                              ? 5
                              : 5 - context.read<WarehousePickupSummaryBloc>().proofOfDeliveryImages.length;
                          context.read<WarehousePickupSummaryBloc>().podLoader = true;
                          setState(() {});
                        case "IMG":
                          maxFiles = context.read<WarehousePickupSummaryBloc>().otherImages.isEmpty
                              ? 50
                              : 50 - context.read<WarehousePickupSummaryBloc>().otherImages.length;
                          context.read<WarehousePickupSummaryBloc>().otherImageLoader = true;
                          setState(() {});
                        case "LIST":
                          maxFiles = context.read<WarehousePickupSummaryBloc>().invoiceImagesList[index].imagePath == "" ? 1 : 0;
                          context.read<WarehousePickupSummaryBloc>().loadersList[index] = true;
                          setState(() {});
                        default:
                          maxFiles = context.read<WarehousePickupSummaryBloc>().checkFrontImage.imagePath == "" ? 1 : 0;
                          context.read<WarehousePickupSummaryBloc>().checkFrontLoader = true;
                          setState(() {});
                      }
                      /* await getIt<Functions>()
                          .uploadImages(
                              source: ImageSource.camera,
                              maxImages: maxFiles,
                              context: context,
                              function: () {
                                Navigator.pop(context);
                              })
                          .then((data) {
                        switch (fromWhere) {
                          case "CF":
                            context.read<WarehousePickupSummaryBloc>().checkFrontImage =
                                ImageDataClass(imageName: data.urlsNameList[0], imagePath: data.urlsList[0], canRemove: true);
                            context.read<WarehousePickupSummaryBloc>().checkFrontLoader = false;
                            context.read<WarehousePickupSummaryBloc>().chequeFront = data.urlsNameList[0];
                            setState(() {});
                          case "CB":
                            context.read<WarehousePickupSummaryBloc>().checkBackImage =
                                ImageDataClass(imageName: data.urlsNameList[0], imagePath: data.urlsList[0], canRemove: true);
                            context.read<WarehousePickupSummaryBloc>().checkBackLoader = false;
                            context.read<WarehousePickupSummaryBloc>().chequeBack = data.urlsNameList[0];
                            setState(() {});
                          case "POD":
                            for (int i = 0; i < data.urlsList.length; i++) {
                              context
                                  .read<WarehousePickupSummaryBloc>()
                                  .proofOfDeliveryImages
                                  .add(ImageDataClass(imageName: data.urlsNameList[i], imagePath: data.urlsList[i], canRemove: true));
                            }
                            context.read<WarehousePickupSummaryBloc>().proofOfDelivery =
                                List.generate(data.urlsList.length, (i) => data.urlsNameList[i]).join(",");
                            context.read<WarehousePickupSummaryBloc>().podLoader = false;
                            setState(() {});
                          case "IMG":
                            for (int i = 0; i < data.urlsList.length; i++) {
                              context
                                  .read<WarehousePickupSummaryBloc>()
                                  .otherImages
                                  .add(ImageDataClass(imageName: data.urlsNameList[i], imagePath: data.urlsList[i], canRemove: true));
                            }
                            context.read<WarehousePickupSummaryBloc>().paymentMethodImages =
                                List.generate(data.urlsList.length, (i) => data.urlsNameList[i]);
                            context.read<WarehousePickupSummaryBloc>().otherImageLoader = false;
                            setState(() {});
                          case "LIST":
                            context.read<WarehousePickupSummaryBloc>().invoiceImagesList[index] =
                                ImageDataClass(imageName: data.urlsNameList[0], imagePath: data.urlsList[0], canRemove: true);
                            context.read<WarehousePickupSummaryBloc>().loadersList[index] = false;
                            for (int i = 0; i < context.read<WarehousePickupSummaryBloc>().wareHousePickupSummaryApiBody.invoices.length; i++) {
                              if (context.read<WarehousePickupSummaryBloc>().wareHousePickupSummaryApiBody.invoices[i].invoiceId ==
                                  context.read<WarehousePickupSummaryBloc>().invoiceDataList[index].invoiceId) {
                                context.read<WarehousePickupSummaryBloc>().wareHousePickupSummaryApiBody.invoices[i].proofOfDelivery =
                                    data.urlsNameList[0];
                                context.read<WarehousePickupSummaryBloc>().wareHousePickupSummaryApiBody.invoices[i].proofOfDeliveryUrl =
                                    data.urlsList[0];
                              }
                            }
                            setState(() {});
                          default:
                            context.read<WarehousePickupSummaryBloc>().checkFrontImage =
                                ImageDataClass(imageName: data.urlsNameList[0], imagePath: data.urlsList[0], canRemove: true);
                            context.read<WarehousePickupSummaryBloc>().checkFrontLoader = false;
                            setState(() {});
                        }
                      });*/
                      await getIt<Functions>()
                          .warehouseUploadImages(
                              source: ImageSource.camera,
                              maxImages: maxFiles,
                              context: context,
                              function: () {
                                Navigator.pop(context);
                              })
                          .then((data) {
                        if (data.isNotEmpty) {
                          switch (fromWhere) {
                            case "CF":
                              context.read<WarehousePickupSummaryBloc>().checkFrontImage =
                                  ImageDataClass(imageName: data[0].path, imagePath: "", canRemove: true);
                              context.read<WarehousePickupSummaryBloc>().checkFrontImageFile = data[0];
                              context.read<WarehousePickupSummaryBloc>().checkFrontLoader = false;
                              //     context.read<WarehousePickupSummaryBloc>().chequeFront = data.urlsNameList[0];
                              setState(() {});
                            case "CB":
                              context.read<WarehousePickupSummaryBloc>().checkBackImage =
                                  ImageDataClass(imageName: data[0].path, imagePath: "", canRemove: true);
                              context.read<WarehousePickupSummaryBloc>().checkBackImageFile = data[0];
                              context.read<WarehousePickupSummaryBloc>().checkBackLoader = false;
                              //context.read<WarehousePickupSummaryBloc>().chequeBack = data.urlsNameList[0];
                              setState(() {});
                            case "POD":
                              for (int i = 0; i < data.length; i++) {
                                context
                                    .read<WarehousePickupSummaryBloc>()
                                    .proofOfDeliveryImages
                                    .add(ImageDataClass(imageName: data[i].path, imagePath: "", canRemove: true));
                                context.read<WarehousePickupSummaryBloc>().proofOfDeliveryImagesFile.add(data[i]);
                              }
                              /*context.read<WarehousePickupSummaryBloc>().proofOfDelivery =
                                  List.generate(data.urlsList.length, (i) => data.urlsNameList[i]).join(",");*/
                              context.read<WarehousePickupSummaryBloc>().podLoader = false;
                              setState(() {});
                            case "IMG":
                              for (int i = 0; i < data.length; i++) {
                                context
                                    .read<WarehousePickupSummaryBloc>()
                                    .otherImages
                                    .add(ImageDataClass(imageName: data[i].path, imagePath: "", canRemove: true));
                                context.read<WarehousePickupSummaryBloc>().otherImagesFile.add(data[i]);
                              }
                              /*context.read<WarehousePickupSummaryBloc>().paymentMethodImages =
                                  List.generate(data.urlsList.length, (i) => data.urlsNameList[i]);*/
                              context.read<WarehousePickupSummaryBloc>().otherImageLoader = false;
                              setState(() {});
                            case "LIST":
                              context.read<WarehousePickupSummaryBloc>().invoiceImagesList[index] =
                                  ImageDataClass(imageName: data[0].path, imagePath: "", canRemove: true);
                              context.read<WarehousePickupSummaryBloc>().invoiceImagesListFile[index] = data[0];
                              for (int i = 0; i < context.read<WarehousePickupSummaryBloc>().wareHousePickupSummaryApiBody.invoices.length; i++) {
                                if (context.read<WarehousePickupSummaryBloc>().wareHousePickupSummaryApiBody.invoices[i].invoiceId ==
                                    context.read<WarehousePickupSummaryBloc>().invoiceDataList[index].invoiceId) {
                                  context.read<WarehousePickupSummaryBloc>().wareHousePickupSummaryApiBody.invoices[i].proofOfDelivery = data[0].path;
                                  context.read<WarehousePickupSummaryBloc>().wareHousePickupSummaryApiBody.invoices[i].proofOfDeliveryUrl =
                                      data[0].path;
                                }
                              }
                              context.read<WarehousePickupSummaryBloc>().loadersList[index] = false;
                              setState(() {});
                            default:
                              context.read<WarehousePickupSummaryBloc>().checkFrontImage =
                                  ImageDataClass(imageName: data[0].path, imagePath: "", canRemove: true);
                              context.read<WarehousePickupSummaryBloc>().checkFrontImageFile = data[0];
                              context.read<WarehousePickupSummaryBloc>().checkFrontLoader = false;
                              setState(() {});
                          }
                        } else {
                          context.read<WarehousePickupSummaryBloc>().checkFrontLoader = false;
                          context.read<WarehousePickupSummaryBloc>().checkBackLoader = false;
                          context.read<WarehousePickupSummaryBloc>().podLoader = false;
                          context.read<WarehousePickupSummaryBloc>().otherImageLoader = false;
                          context.read<WarehousePickupSummaryBloc>().loadersList[index] = false;
                        }
                        setState(() {});
                      });
                    } catch (e) {
                      if (mounted) {
                        context.read<WarehousePickupSummaryBloc>().checkFrontLoader = false;
                        context.read<WarehousePickupSummaryBloc>().checkBackLoader = false;
                        context.read<WarehousePickupSummaryBloc>().podLoader = false;
                        context.read<WarehousePickupSummaryBloc>().otherImageLoader = false;
                        context.read<WarehousePickupSummaryBloc>().loadersList[index] = false;
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

  Widget deliverySuccessDialog() {
    return BlocConsumer<WarehousePickupSummaryBloc, WarehousePickupSummaryState>(
      listener: (BuildContext context, WarehousePickupSummaryState state) {},
      builder: (BuildContext context, WarehousePickupSummaryState state) {
        return SizedBox(
          width: getIt<Functions>().getWidgetWidth(width: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod == null
                  ? const SizedBox()
                  : Text(
                      '${getIt<Variables>().generalVariables.currentLanguage.totalAmount} : RS.${context.read<WarehousePickupSummaryBloc>().wareHousePickupSummaryApiBody.collectedAmount}',
                      style: TextStyle(
                          fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 24 : 18),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff282F3A))),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 36.5)),
              context.read<WarehousePickupSummaryBloc>().completeLoader
                  ? SizedBox(
                      height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 120 : 90),
                      width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 120 : 90),
                      child: const CircularProgressIndicator(color: Colors.green),
                    )
                  : context.read<WarehousePickupSummaryBloc>().completeLoaderFailure
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                                height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 120 : 90),
                                width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 120 : 90),
                                child: const CircularProgressIndicator(color: Colors.red)),
                            SizedBox(
                              height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 100 : 70),
                              width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 100 : 70),
                              child: Icon(Icons.clear, color: Colors.red, size: getIt<Variables>().generalVariables.isDeviceTablet ? 75 : 50),
                            )
                          ],
                        )
                      : SvgPicture.asset('assets/warehouse_list/delivery_success.svg',
                          height: getIt<Functions>().getWidgetHeight(height: getIt<Variables>().generalVariables.isDeviceTablet ? 120 : 90),
                          width: getIt<Functions>().getWidgetWidth(width: getIt<Variables>().generalVariables.isDeviceTablet ? 120 : 90)),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 27.5)),
              Text(
                  context.read<WarehousePickupSummaryBloc>().completeLoader
                      ? '${getIt<Variables>().generalVariables.currentLanguage.inProgress} !'
                      : context.read<WarehousePickupSummaryBloc>().completeLoaderFailure
                          ? 'Failure !'
                          : '${getIt<Variables>().generalVariables.currentLanguage.deliverySuccessful} !',
                  style: TextStyle(
                      fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 24 : 18),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff282F3A))),
              if (context.read<WarehousePickupSummaryBloc>().completeLoaderFailure)
                Text(context.read<WarehousePickupSummaryBloc>().errorMessage,
                    style: TextStyle(
                        fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 14 : 12),
                        fontWeight: FontWeight.w500,
                        color: const Color(0xffDC474A))),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 30)),
              Text(getIt<Variables>().generalVariables.soListMainIdData.soCustomerName,
                  style: TextStyle(
                      fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 16 : 14),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff282F3A))),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 10)),
              Text('${getIt<Variables>().generalVariables.currentLanguage.so} # : ${getIt<Variables>().generalVariables.soListMainIdData.soNum}',
                  style: TextStyle(
                      fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 16 : 14),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff007AFF))),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SvgPicture.asset('assets/warehouse_list/fade_line.svg'),
                  ),
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xffBBC6CD))),
                    padding: EdgeInsets.symmetric(
                        vertical: getIt<Functions>().getWidgetHeight(height: 7), horizontal: getIt<Functions>().getWidgetWidth(width: 53)),
                    child: Column(
                      children: [
                        Text(context.read<WarehousePickupSummaryBloc>().itemsListDataMain.length.toString(),
                            style: TextStyle(
                                fontSize: getIt<Functions>().getTextSize(fontSize: 28), fontWeight: FontWeight.w600, color: const Color(0xff007838))),
                        SizedBox(height: getIt<Functions>().getWidgetHeight(height: 4)),
                        Text(getIt<Variables>().generalVariables.currentLanguage.totalItems,
                            style: TextStyle(
                                fontSize: getIt<Functions>().getTextSize(fontSize: 14), fontWeight: FontWeight.w500, color: const Color(0xff282F3A))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SvgPicture.asset('assets/warehouse_list/fade_line.svg'),
                  ),
                ],
              ),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 30)),
              context.read<WarehousePickupSummaryBloc>().selectPaymentMethod == null
                  ? const SizedBox()
                  : Text(
                      '${getIt<Variables>().generalVariables.currentLanguage.paymentMethod} : ${context.read<WarehousePickupSummaryBloc>().wareHousePickupSummaryApiBody.paymentMethod}',
                      style: TextStyle(
                          fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 16 : 14),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff282F3A))),
              SizedBox(height: getIt<Functions>().getWidgetHeight(height: 40)),
              InkWell(
                onTap: () {
                  if (!context.read<WarehousePickupSummaryBloc>().completeLoader) {
                    if (!context.read<WarehousePickupSummaryBloc>().completeLoaderFailure) {
                      Navigator.pop(context);
                      getIt<Variables>().generalVariables.indexName =
                          getIt<Variables>().generalVariables.warehouseRouteList[getIt<Variables>().generalVariables.warehouseRouteList.length - 2];
                      context.read<NavigationBloc>().add(const NavigationInitialEvent());
                      getIt<Variables>().generalVariables.warehouseRouteList.clear();
                    } else {
                      Navigator.pop(context);
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: getIt<Functions>().getWidgetHeight(height: 18)),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                    color: context.read<WarehousePickupSummaryBloc>().completeLoader
                        ? Colors.grey.shade300
                        : context.read<WarehousePickupSummaryBloc>().completeLoaderFailure
                            ? const Color(0xffDC474A)
                            : const Color(0xff007838),
                  ),
                  child: Center(
                      child: Text(
                          context.read<WarehousePickupSummaryBloc>().completeLoader
                              ? '${getIt<Variables>().generalVariables.currentLanguage.inProgress.toUpperCase()} !'
                              : context.read<WarehousePickupSummaryBloc>().completeLoaderFailure
                                  ? getIt<Variables>().generalVariables.currentLanguage.goToBack.toUpperCase()
                                  : getIt<Variables>().generalVariables.currentLanguage.goToNextOrder.toUpperCase(),
                          style: TextStyle(
                              fontSize: getIt<Functions>().getTextSize(fontSize: getIt<Variables>().generalVariables.isDeviceTablet ? 15 : 13),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xffFFFFFF)))),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  void _handleSaveButtonPressed() async {
    await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0).then((data) async {
      await data.toByteData(format: ui.ImageByteFormat.png).then((value) async {
        context.read<WarehousePickupSummaryBloc>().bytes = value;
        context.read<WarehousePickupSummaryBloc>().signatureSubmitted = true;
        Uint8List intData = value!.buffer.asUint8List();
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/signature.png';
        final file = File(path);
        await file.writeAsBytes(intData);
        if (mounted) {
          /* await getIt<Functions>()
              .uploadImages(
                  source: ImageSource.gallery,
                  context: context,
                  function: () {
                    Navigator.pop(context);
                  },
                  file: file)
              .then((data) {
            context.read<WarehousePickupSummaryBloc>().signature = data.urlsNameList[0];
            context.read<WarehousePickupSummaryBloc>().add(const WarehousePickupSummarySetStateEvent());
          });*/
          await getIt<Functions>()
              .warehouseUploadImages(
                  source: ImageSource.gallery,
                  context: context,
                  function: () {
                    Navigator.pop(context);
                  },
                  file: file)
              .then((data) {
            context.read<WarehousePickupSummaryBloc>().signature = data[0].path;
            context.read<WarehousePickupSummaryBloc>().signatureFile = data[0];
            context.read<WarehousePickupSummaryBloc>().add(const WarehousePickupSummarySetStateEvent());
          });
        }
      });
    });
  }
}

class ImageDataClass {
  String imageName;
  String imagePath;
  bool canRemove;

  ImageDataClass({required this.imageName, required this.imagePath, required this.canRemove});

  factory ImageDataClass.fromJson(Map<String, dynamic> json) =>
      ImageDataClass(imageName: json["image_name"] ?? "", imagePath: json["image_path"] ?? "", canRemove: json["can_remove"] ?? false);

  Map<String, dynamic> toJson() => {
        "image_name": imageName,
        "image_path": imagePath,
        "can_remove": canRemove,
      };
}
