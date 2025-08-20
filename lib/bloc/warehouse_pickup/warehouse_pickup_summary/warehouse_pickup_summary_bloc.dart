// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:oda/local_database/pick_list_box/pick_list.dart';
import 'package:oda/local_database/trip_box/trip_list.dart';
import 'package:oda/repository/api_end_points.dart';
import 'package:oda/repository_model/trip_list/warehouse_pickup_summary_api_body.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';
import 'package:oda/screens/warehouse_pickup/warehouse_pickup_summary_screen.dart';

part 'warehouse_pickup_summary_event.dart';
part 'warehouse_pickup_summary_state.dart';

class WarehousePickupSummaryBloc extends Bloc<WarehousePickupSummaryEvent, WarehousePickupSummaryState> {
  bool searchBarEnabled = false;
  String searchText = "";
  int pageIndex = 1;
  int tabIndex = 0;
  String? selectPaymentMethod;
  String totalInvoiceAmount = "";
  WareHousePickupSummaryApiBody wareHousePickupSummaryApiBody = WareHousePickupSummaryApiBody.fromJson({});
  bool isCollectPayment = false;
  bool isApplyDiscount = false;
  bool signatureSubmitted = false;
  ByteData? bytes;
  List<ImageDataClass> proofOfDeliveryImages = [];
  List<ImageDataClass> otherImages = [];
  ImageDataClass checkFrontImage = ImageDataClass.fromJson({});
  ImageDataClass checkBackImage = ImageDataClass.fromJson({});
  bool checkFrontLoader = false;
  bool checkBackLoader = false;
  bool podLoader = false;
  bool otherImageLoader = false;
  bool filterCalenderEnabled = false;
  List<bool> loadersList = [];
  List<ImageDataClass> invoiceImagesList = [];
  List<InvoiceData> invoiceDataList = [];
  String discountPercentage = "0";
  String proofOfDelivery = "";
  String signature = "";
  String overAllRemarks = "";
  List<String> paymentMethodImages = [];
  String referenceNo = "";
  String chequeAmount = "";
  String chequeNumber = "";
  String chequeDate = DateTime.now().toString().substring(0, 10);
  String bank = "";
  String branch = "";
  String chequeFront = "";
  String chequeBack = "";
  String paymentMethodComments = "";
  List<ItemsList> itemsListDataMain = [];
  bool completeLoader = false;
  bool completeLoaderFailure = false;
  bool deliveredButton = false;
  String errorMessage = "";

  File checkFrontImageFile = File("");
  File checkBackImageFile = File("");
  List<File> otherImagesFile = [];
  List<File> invoiceImagesListFile = [];
  List<File> proofOfDeliveryImagesFile = [];
  File signatureFile = File("");

  WarehousePickupSummaryBloc() : super(WarehousePickupSummaryLoading()) {
    on<WarehousePickupSummaryInitialEvent>(warehouseSummaryInitialFunction);
    on<WarehousePickupSummarySetStateEvent>(warehouseSummarySetStateFunction);
    on<WarehousePickupCompleteEvent>(warehouseSummaryCompleteFunction);
  }

  FutureOr<void> warehouseSummaryInitialFunction(WarehousePickupSummaryInitialEvent event, Emitter<WarehousePickupSummaryState> emit) async {
    emit(WarehousePickupSummaryLoading());
    invoiceDataList.clear();
    loadersList.clear();
    invoiceImagesList.clear();
    itemsListDataMain.clear();
    paymentMethodImages.clear();
    referenceNo = "";
    chequeAmount = "";
    chequeNumber = "";
    chequeDate = DateTime.now().toString().substring(0, 10);
    bank = "";
    branch = "";
    chequeFront = "";
    chequeBack = "";
    paymentMethodComments = "";
    discountPercentage = "0";
    proofOfDelivery = "";
    signature = "";
    overAllRemarks = "";
    checkFrontLoader = false;
    checkBackLoader = false;
    podLoader = false;
    otherImageLoader = false;
    filterCalenderEnabled = false;
    isCollectPayment = false;
    isApplyDiscount = false;
    signatureSubmitted = false;
    bytes;
    proofOfDeliveryImages = [];
    otherImages = [];
    checkFrontImage = ImageDataClass.fromJson({});
    checkBackImage = ImageDataClass.fromJson({});
    wareHousePickupSummaryApiBody = WareHousePickupSummaryApiBody.fromJson({});
    searchBarEnabled = false;
    searchText = "";
    pageIndex = 1;
    tabIndex = 0;
    selectPaymentMethod;
    totalInvoiceAmount = "";
    completeLoader = false;
    completeLoaderFailure = false;
    deliveredButton = false;
    checkFrontImageFile = File("");
    checkBackImageFile = File("");
    otherImagesFile.clear();
    invoiceImagesListFile.clear();
    proofOfDeliveryImagesFile.clear();
    signatureFile = File("");
    Box<InvoiceData> invoiceListBox = Hive.box<InvoiceData>('invoice_data_list_pickup');
    invoiceDataList = invoiceListBox.values.toList().where((e) => e.soId == getIt<Variables>().generalVariables.soListMainIdData.soId).toList();
    loadersList = List.generate(invoiceDataList.length, (i) => false);
    invoiceImagesList = List.generate(invoiceDataList.length, (i) => ImageDataClass.fromJson({}));
    for (int i = 0; i < invoiceDataList.length; i++) {
      invoiceImagesListFile.add(File(""));
      wareHousePickupSummaryApiBody.invoices.add(Invoice.fromJson({}));
      wareHousePickupSummaryApiBody.invoices[i].invoiceId = invoiceDataList[i].invoiceId;
      wareHousePickupSummaryApiBody.invoices[i].proofOfDelivery = "";
      wareHousePickupSummaryApiBody.invoices[i].proofOfDeliveryUrl = "";
      Box<ItemsList> itemsListBox = Hive.box<ItemsList>('items_list_pickup');
      List<ItemsList> itemsListData =
          itemsListBox.values.toList().where((e) => e.soId == getIt<Variables>().generalVariables.soListMainIdData.soId).toList();
      List<ItemsList> itemsListSelectedData = itemsListData.where((e) => e.invoiceId == invoiceDataList[i].invoiceId).toList();
      wareHousePickupSummaryApiBody.invoices[i].items.clear();
      for (int j = 0; j < itemsListSelectedData.length; j++) {
        wareHousePickupSummaryApiBody.invoices[i].items.add(Item.fromJson({
          "item_id": itemsListSelectedData[j].itemId,
          "delivered": itemsListSelectedData[j].itemLoadedStatus == "Loaded" ? itemsListSelectedData[j].quantity : "0",
          "undelivered": itemsListSelectedData[j].itemLoadedStatus == "Unavailable" ? itemsListSelectedData[j].quantity : "0",
          "catchweight_qty": itemsListSelectedData[j].itemLoadedStatus == "Loaded" && itemsListSelectedData[j].catchWeightStatus == "Yes"
              ? itemsListSelectedData[j].catchWeightInfo
              : "",
          "undelivered_reason":
              itemsListSelectedData[j].itemLoadedStatus == "Unavailable" ? itemsListSelectedData[j].itemLoadedUnavailableReasonId : "",
          "undelivered_remarks":
              itemsListSelectedData[j].itemLoadedStatus == "Unavailable" ? itemsListSelectedData[j].itemLoadedUnavailableRemarks : "",
          "line_item_id": itemsListSelectedData[j].lineItemId
        }));
      }
    }
    selectPaymentMethod = null;
    num sum = 0;
    Box<ItemsList> itemsListBox = Hive.box<ItemsList>('items_list_pickup');
    itemsListDataMain = itemsListBox.values.toList().where((e) => e.soId == getIt<Variables>().generalVariables.soListMainIdData.soId).toList();
    for (int i = 0; i < invoiceDataList.length; i++) {
      invoiceDataList[i].invoiceItems = (itemsListDataMain.where((e) => e.invoiceId == invoiceDataList[i].invoiceId).toList().length).toString();
      sum += num.parse(invoiceDataList[i].invoiceTotal);
    }
    totalInvoiceAmount = sum.toString();
    emit(WarehousePickupSummaryDummy());
    emit(WarehousePickupSummaryLoaded());
  }

  FutureOr<void> warehouseSummaryCompleteFunction(WarehousePickupCompleteEvent event, Emitter<WarehousePickupSummaryState> emit) async {
    /*  wareHousePickupSummaryApiBody.tripId = getIt<Variables>().generalVariables.soListMainIdData.tripId;
    wareHousePickupSummaryApiBody.stopId = getIt<Variables>().generalVariables.soListMainIdData.stopId;
    errorMessage = "";
    wareHousePickupSummaryApiBody.paymentMethod = selectPaymentMethod ?? "";
    wareHousePickupSummaryApiBody.discountPercentage = discountPercentage;
    wareHousePickupSummaryApiBody.proofOfDelivery = proofOfDelivery;
    wareHousePickupSummaryApiBody.signature = signature;
    wareHousePickupSummaryApiBody.remarks = overAllRemarks;
    wareHousePickupSummaryApiBody.images = paymentMethodImages;
    wareHousePickupSummaryApiBody.referenceNo = referenceNo;
    wareHousePickupSummaryApiBody.chequeAmount = chequeAmount;
    wareHousePickupSummaryApiBody.chequeNumber = chequeNumber;
    wareHousePickupSummaryApiBody.chequeDate = chequeDate;
    wareHousePickupSummaryApiBody.bank = bank;
    wareHousePickupSummaryApiBody.branch = branch;
    wareHousePickupSummaryApiBody.chequeFront = chequeFront;
    wareHousePickupSummaryApiBody.chequeBack = chequeBack;
    wareHousePickupSummaryApiBody.comments = paymentMethodComments;
    wareHousePickupSummaryApiBody.collectedAmount = chequeAmount;
    wareHousePickupSummaryApiBody.startSession = getIt<Variables>().generalVariables.soListMainIdData.sessionInfo.sessionStartTimestamp;
    wareHousePickupSummaryApiBody.endSession = DateTime.now().millisecondsSinceEpoch.toString();*/
    wareHousePickupSummaryApiBody.tripId = getIt<Variables>().generalVariables.soListMainIdData.tripId;
    wareHousePickupSummaryApiBody.stopId = getIt<Variables>().generalVariables.soListMainIdData.stopId;
    errorMessage = "";
    wareHousePickupSummaryApiBody.paymentMethod = selectPaymentMethod ?? "";
    wareHousePickupSummaryApiBody.discountPercentage = discountPercentage;
    wareHousePickupSummaryApiBody.proofOfDelivery =
        List.generate(proofOfDeliveryImagesFile.length, (i) => proofOfDeliveryImagesFile[i].path).join(',');
    wareHousePickupSummaryApiBody.signature = signatureFile.path;
    wareHousePickupSummaryApiBody.remarks = overAllRemarks;
    wareHousePickupSummaryApiBody.images = List.generate(otherImagesFile.length, (i) => otherImagesFile[i].path);
    wareHousePickupSummaryApiBody.referenceNo = referenceNo;
    wareHousePickupSummaryApiBody.chequeAmount = chequeAmount;
    wareHousePickupSummaryApiBody.chequeNumber = chequeNumber;
    wareHousePickupSummaryApiBody.chequeDate = chequeDate;
    wareHousePickupSummaryApiBody.bank = bank;
    wareHousePickupSummaryApiBody.branch = branch;
    wareHousePickupSummaryApiBody.chequeFront = checkFrontImageFile.path;
    wareHousePickupSummaryApiBody.chequeBack = checkBackImageFile.path;
    wareHousePickupSummaryApiBody.comments = paymentMethodComments;
    wareHousePickupSummaryApiBody.collectedAmount = chequeAmount;
    wareHousePickupSummaryApiBody.startSession = getIt<Variables>().generalVariables.soListMainIdData.sessionInfo.sessionStartTimestamp;
    wareHousePickupSummaryApiBody.endSession = DateTime.now().millisecondsSinceEpoch.toString();
    if (isCollectPayment) {
      if (selectPaymentMethod == null) {
        errorMessage = getIt<Variables>().generalVariables.currentLanguage.selectPaymentMethod;
      } else if (selectPaymentMethod == getIt<Variables>().generalVariables.currentLanguage.cash) {
        if (wareHousePickupSummaryApiBody.collectedAmount.isEmpty) {
          errorMessage = getIt<Variables>().generalVariables.currentLanguage.enterCollectedAmount;
        }
      } else if (selectPaymentMethod == getIt<Variables>().generalVariables.currentLanguage.online ||
          selectPaymentMethod == getIt<Variables>().generalVariables.currentLanguage.deposit) {
        if (wareHousePickupSummaryApiBody.chequeAmount.isEmpty) {
          errorMessage = getIt<Variables>().generalVariables.currentLanguage.pleaseEnterAmount;
        } else if (wareHousePickupSummaryApiBody.referenceNo.isEmpty) {
          errorMessage = getIt<Variables>().generalVariables.currentLanguage.pleaseEnterReference;
        }
      } else if (selectPaymentMethod == getIt<Variables>().generalVariables.currentLanguage.cheque) {
        if (wareHousePickupSummaryApiBody.chequeAmount.isEmpty) {
          errorMessage = getIt<Variables>().generalVariables.currentLanguage.pleaseEnterChequeAmount; //"Please enter cheque amount";
        } else if (wareHousePickupSummaryApiBody.chequeNumber.isEmpty) {
          errorMessage = getIt<Variables>().generalVariables.currentLanguage.pleaseEnterChequeNumber; //"Please cheque number";
        } else if (wareHousePickupSummaryApiBody.bank.isEmpty) {
          errorMessage = getIt<Variables>().generalVariables.currentLanguage.pleaseEnterBankName; //"Please enter a bank name";
        } else if (wareHousePickupSummaryApiBody.branch.isEmpty) {
          errorMessage = getIt<Variables>().generalVariables.currentLanguage.pleaseEnterBranchName; //"Please enter a branch name";
        } else if (wareHousePickupSummaryApiBody.chequeFront.isEmpty) {
          errorMessage = getIt<Variables>().generalVariables.currentLanguage.pleaseEnterChequeFrontImage; //"Please upload cheque front image";
        } else if (wareHousePickupSummaryApiBody.chequeBack.isEmpty) {
          errorMessage = getIt<Variables>().generalVariables.currentLanguage.pleaseEnterChequeBackImage; //"Please upload cheque back image";
        }
      }
      if (errorMessage.isEmpty) {
        if (invoiceImagesListFile.any((element) => element.path.isEmpty /* || element.imagePath.isEmpty*/)) {
          errorMessage = getIt<Variables>().generalVariables.currentLanguage.pleaseEnterPod; //"Please upload proof of delivery for all the invoices";
        } else if (signatureFile.path.isEmpty) {
          errorMessage = getIt<Variables>().generalVariables.currentLanguage.pleaseEnterSign; //"Please upload signature";
        }
      }
    } else {
      if (errorMessage.isEmpty) {
        if (invoiceImagesList.any((element) => element.imageName.isEmpty /*|| element.imagePath.isEmpty*/)) {
          errorMessage = getIt<Variables>().generalVariables.currentLanguage.pleaseEnterPod; //"Please upload proof of delivery for all the invoices";
        } else if (signatureFile.path.isEmpty) {
          errorMessage = getIt<Variables>().generalVariables.currentLanguage.pleaseEnterSign; //"Please upload signature";
        }
      }
    }
    if (errorMessage.isEmpty) {
      /* await getIt<Variables>()
          .repoImpl
          .getWarehousePickupUpdate(query: wareHousePickupSummaryApiBody.toJson(), method: "post", module: ApiEndPoints().loaderModule)
          .onError((error, stackTrace) {
        errorMessage = error.toString();
        completeLoader = false;
        completeLoaderFailure = true;
        emit(WarehousePickupSummaryDialog());
      }).then((value) async {
        if (value != null) {
          if (value["status"] == "1") {
            Box<SoList> soListBox = Hive.box<SoList>('so_list_pickup');
            Box<ItemsList> itemsListBox = Hive.box<ItemsList>('items_list_pickup');
            getIt<Variables>().generalVariables.soListMainIdData.soStatus = getIt<Variables>().generalVariables.currentLanguage.completed.toLowerCase().replaceFirst("c", "C");
            int soKey = soListBox.keys.firstWhere((k) => soListBox.get(k)?.tripId == getIt<Variables>().generalVariables.soListMainIdData.tripId && soListBox.get(k)?.soId == getIt<Variables>().generalVariables.soListMainIdData.soId);
            await soListBox.put(soKey, getIt<Variables>().generalVariables.soListMainIdData);
            completeLoader = false;
            completeLoaderFailure = false;
            deliveredButton = false;
            for (var model in itemsListBox.values) {
              if (model.soId == getIt<Variables>().generalVariables.soListMainIdData.soId &&
                  model.itemTrippedStatus == "Loaded" &&
                  model.isProgressStatus &&
                  (model.handledBy.isNotEmpty ? (model.handledBy[0].code == getIt<Variables>().generalVariables.userDataEmployeeCode) : false)) {
                model.isProgressStatus = false;
                await model.save();
              }
            }
            getIt<Variables>().generalVariables.soListMainIdData.sessionInfo.sessionStartTimestamp = "";
            emit(WarehousePickupSummaryDialog());
          } else {
            errorMessage = value["response"];
            completeLoader = false;
            completeLoaderFailure = true;
            deliveredButton = false;
            emit(WarehousePickupSummaryDialog());
          }
        }
      });*/
      emit(WarehousePickupSummaryDialog());
      emit(WarehousePickupSummaryLoaded());
      await apiCalls(queryData: {"activity": "summary", "query_data": wareHousePickupSummaryApiBody.toJson()});
      emit(WarehousePickupSummaryDummy());
      emit(WarehousePickupSummaryLoaded());
    } else {
      completeLoader = false;
      completeLoaderFailure = true;
      deliveredButton = false;
      emit(WarehousePickupSummaryError(message: errorMessage));
      emit(WarehousePickupSummaryDummy());
      emit(WarehousePickupSummaryLoaded());
    }
  }

  FutureOr<void> warehouseSummarySetStateFunction(WarehousePickupSummarySetStateEvent event, Emitter<WarehousePickupSummaryState> emit) async {
    emit(WarehousePickupSummaryDummy());
    event.stillLoading ? emit(WarehousePickupSummaryLoading()) : emit(WarehousePickupSummaryLoaded());
  }

  Future<String> apiCalls({
    required Map<String, dynamic> queryData,
  }) async {
    String responseBool = "";
    String encodeData = jsonEncode(queryData);
    if (getIt<Variables>().generalVariables.isNetworkOffline) {
      Box<LocalTempDataList> localTempDataList = Hive.box<LocalTempDataList>('local_temp_data_list_pickup');
      localTempDataList.add(LocalTempDataList(queryData: encodeData));
      await summaryCompleteFunction(success: true, error: "");
    } else {
      await networkApiCalls();
      WareHousePickupSummaryApiBody wareHousePickupSummaryApiBodyFinal = WareHousePickupSummaryApiBody.fromJson(queryData["query_data"]);
      wareHousePickupSummaryApiBodyFinal.proofOfDelivery =
      await proofOfDeliveryFileConversion(data: wareHousePickupSummaryApiBodyFinal.proofOfDelivery);
      wareHousePickupSummaryApiBodyFinal.signature = await singleFileConversion(data: wareHousePickupSummaryApiBodyFinal.signature);
      wareHousePickupSummaryApiBodyFinal.images = await multipleFileConversion(data: wareHousePickupSummaryApiBodyFinal.images);
      wareHousePickupSummaryApiBodyFinal.chequeFront = await singleFileConversion(data: wareHousePickupSummaryApiBodyFinal.chequeFront);
      wareHousePickupSummaryApiBodyFinal.chequeBack = await singleFileConversion(data: wareHousePickupSummaryApiBodyFinal.chequeBack);
      await loadingInvoicesListImages(data: wareHousePickupSummaryApiBodyFinal.invoices);
      Map<String, dynamic> queryDataFinal = {"activity": "summary", "query_data": wareHousePickupSummaryApiBodyFinal.toJson()};
      if(queryDataFinal["query_data"]["start_session"]==""){
        queryDataFinal["query_data"]["start_session"]=(DateTime.now().subtract(const Duration(hours: 1))).millisecondsSinceEpoch.toString();
      }
      await getIt<Variables>()
          .repoImpl
          .getWarehousePickupUpdate(query: queryDataFinal["query_data"], method: "post", module: ApiEndPoints().loaderModule)
          .onError((error, stackTrace) async {
        await summaryCompleteFunction(success: false, error: error.toString());
      }).then((value) async {
        if (value != null) {
          if (value["status"] == "1") {
            await summaryCompleteFunction(success: true, error: "");
          } else {
            await summaryCompleteFunction(success: false, error: value["response"]);
          }
        }
      });
    }
    return responseBool;
  }

  summaryCompleteFunction({required bool success, required String error}) async {
    if (success) {
      Box<SoList> soListBox = Hive.box<SoList>('so_list_pickup');
      Box<ItemsList> itemsListBox = Hive.box<ItemsList>('items_list_pickup');
      completeLoader = false;
      completeLoaderFailure = false;
      deliveredButton = false;
      for (var model in itemsListBox.values.toList()) {
        if (model.soId == getIt<Variables>().generalVariables.soListMainIdData.soId &&
            model.itemTrippedStatus == "Loaded" &&
            model.isProgressStatus &&
            (model.handledBy.isNotEmpty ? (model.handledBy[0].code == getIt<Variables>().generalVariables.userDataEmployeeCode) : false)) {
          model.isProgressStatus = false;
          await model.save();
        }
      }
      getIt<Variables>().generalVariables.soListMainIdData.soStatus =
          getIt<Variables>().generalVariables.currentLanguage.completed.toLowerCase().replaceFirst("c", "C");
      getIt<Variables>().generalVariables.soListMainIdData.sessionInfo.sessionStartTimestamp = "";
      int soKey = soListBox.keys.firstWhere((k) =>
      soListBox.get(k)?.tripId == getIt<Variables>().generalVariables.soListMainIdData.tripId &&
          soListBox.get(k)?.soId == getIt<Variables>().generalVariables.soListMainIdData.soId);
      await soListBox.put(soKey, getIt<Variables>().generalVariables.soListMainIdData);
    } else {
      errorMessage = error;
      completeLoader = false;
      completeLoaderFailure = true;
      deliveredButton = false;
    }
  }

  networkApiCalls() async {
    Box<LocalTempDataList> localTempDataList = Hive.box<LocalTempDataList>('local_temp_data_list_pickup');
    if (localTempDataList.values.toList().isNotEmpty) {
      int i = 0;
      do {
        try {
          Map<String, dynamic> queryData = jsonDecode(localTempDataList.values.toList()[i].queryData);
          WareHousePickupSummaryApiBody wareHousePickupSummaryApiBodyFinal = WareHousePickupSummaryApiBody.fromJson(queryData);
          wareHousePickupSummaryApiBodyFinal.proofOfDelivery =
          await proofOfDeliveryFileConversion(data: wareHousePickupSummaryApiBodyFinal.proofOfDelivery);
          wareHousePickupSummaryApiBodyFinal.signature = await singleFileConversion(data: wareHousePickupSummaryApiBodyFinal.signature);
          wareHousePickupSummaryApiBodyFinal.images = await multipleFileConversion(data: wareHousePickupSummaryApiBodyFinal.images);
          wareHousePickupSummaryApiBodyFinal.chequeFront = await singleFileConversion(data: wareHousePickupSummaryApiBodyFinal.chequeFront);
          wareHousePickupSummaryApiBodyFinal.chequeBack = await singleFileConversion(data: wareHousePickupSummaryApiBodyFinal.chequeBack);
          await loadingInvoicesListImages(data: wareHousePickupSummaryApiBodyFinal.invoices);
          Map<String, dynamic> queryDataFinal = {"activity": "summary", "query_data": wareHousePickupSummaryApiBodyFinal.toJson()};
          if(queryDataFinal["query_data"]["start_session"]==""){
            queryDataFinal["query_data"]["start_session"]=(DateTime.now().subtract(const Duration(hours: 1))).millisecondsSinceEpoch.toString();
          }
          await getIt<Variables>()
              .repoImpl
              .getWarehousePickupUpdate(query: queryData["query_data"], method: "post", module: ApiEndPoints().loaderModule)
              .then((value) async {
            if (value != null) {
              if (value["status"] == "1") {
                await localTempDataList.deleteAt(i);
              }
            }
          });
        } catch (e) {
          break;
        }
      } while (localTempDataList.isNotEmpty);
    }
  }

  Future<String> proofOfDeliveryFileConversion({required String data}) async {
    if (data != "") {
      List<String> stringList = data.split(",");
      List<String> uploadImageNames = [];
      for (int i = 0; i < stringList.length; i++) {
        String? s3path = await getIt<Functions>().uploadFileUsingAws(
          file: File(stringList[i]),
          accessKey: getIt<Variables>().generalVariables.initialSetupValues.s3.accessKey,
          secretKey: getIt<Variables>().generalVariables.initialSetupValues.s3.secretKey,
          bucket: getIt<Variables>().generalVariables.initialSetupValues.s3.bucketName,
          region: getIt<Variables>().generalVariables.initialSetupValues.s3.region,
          destDir: getIt<Variables>().generalVariables.initialSetupValues.s3.path,
        );
        if (s3path != null) {
          Uri uri = Uri.parse(s3path);
          String fileName = uri.pathSegments.last;
          uploadImageNames.add("${getIt<Variables>().generalVariables.initialSetupValues.s3.path.replaceAll("/", "")}/$fileName");
        }
      }
      return List.generate(uploadImageNames.length, (i) => uploadImageNames[i]).join(",");
    }
    return "";
  }

  Future<String> singleFileConversion({required String data}) async {
    String dataFinalSign = "";
    if (data != "") {
      String? s3path = await getIt<Functions>().uploadFileUsingAws(
        file: File(data),
        accessKey: getIt<Variables>().generalVariables.initialSetupValues.s3.accessKey,
        secretKey: getIt<Variables>().generalVariables.initialSetupValues.s3.secretKey,
        bucket: getIt<Variables>().generalVariables.initialSetupValues.s3.bucketName,
        region: getIt<Variables>().generalVariables.initialSetupValues.s3.region,
        destDir: getIt<Variables>().generalVariables.initialSetupValues.s3.path,
      );
      if (s3path != null) {
        Uri uri = Uri.parse(s3path);
        String fileName = uri.pathSegments.last;
        dataFinalSign = "${getIt<Variables>().generalVariables.initialSetupValues.s3.path.replaceAll("/", "")}/$fileName";
      }
    }
    return dataFinalSign;
  }

  Future<List<String>> multipleFileConversion({required List<String> data}) async {
    List<String> dataFinalSign = [];
    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        String? s3path = await getIt<Functions>().uploadFileUsingAws(
          file: File(data[i]),
          accessKey: getIt<Variables>().generalVariables.initialSetupValues.s3.accessKey,
          secretKey: getIt<Variables>().generalVariables.initialSetupValues.s3.secretKey,
          bucket: getIt<Variables>().generalVariables.initialSetupValues.s3.bucketName,
          region: getIt<Variables>().generalVariables.initialSetupValues.s3.region,
          destDir: getIt<Variables>().generalVariables.initialSetupValues.s3.path,
        );
        if (s3path != null) {
          Uri uri = Uri.parse(s3path);
          String fileName = uri.pathSegments.last;
          dataFinalSign.add("${getIt<Variables>().generalVariables.initialSetupValues.s3.path.replaceAll("/", "")}/$fileName");
        }
      }
    }
    return dataFinalSign;
  }

  Future<List<Invoice>> loadingInvoicesListImages({required List<Invoice> data}) async {
    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        String? s3path = await getIt<Functions>().uploadFileUsingAws(
          file: File(data[i].proofOfDelivery),
          accessKey: getIt<Variables>().generalVariables.initialSetupValues.s3.accessKey,
          secretKey: getIt<Variables>().generalVariables.initialSetupValues.s3.secretKey,
          bucket: getIt<Variables>().generalVariables.initialSetupValues.s3.bucketName,
          region: getIt<Variables>().generalVariables.initialSetupValues.s3.region,
          destDir: getIt<Variables>().generalVariables.initialSetupValues.s3.path,
        );
        if (s3path != null) {
          Uri uri = Uri.parse(s3path);
          String fileName = uri.pathSegments.last;
          data[i].proofOfDeliveryUrl = s3path;
          data[i].proofOfDelivery = "${getIt<Variables>().generalVariables.initialSetupValues.s3.path.replaceAll("/", "")}/$fileName";
        }
      }
      return data;
    }
    return data;
  }
}
