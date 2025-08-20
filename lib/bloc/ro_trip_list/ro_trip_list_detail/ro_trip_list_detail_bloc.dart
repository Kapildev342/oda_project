// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:oda/local_database/pick_list_box/pick_list.dart';
import 'package:oda/local_database/user_box/user.dart';
import 'package:oda/repository/api_end_points.dart';
import 'package:oda/repository_model/ro_trip_list/return_item_update_api_body.dart';
import 'package:oda/repository_model/ro_trip_list/ro_trip_expenses_model.dart';
import 'package:oda/repository_model/ro_trip_list/ro_trip_list_detail_model.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/variables.dart';

// Project imports:
import 'package:oda/screens/ro_trip_list/widgets/collected_amount_widget.dart';
import 'package:oda/screens/ro_trip_list/widgets/entry_widget.dart';
import 'package:oda/screens/ro_trip_list/widgets/return_items_widget.dart';
import 'package:oda/screens/ro_trip_list/widgets/total_assets_widget.dart';
import 'package:oda/screens/ro_trip_list/widgets/total_expenses_widget.dart';
import 'package:oda/screens/warehouse_pickup/warehouse_pickup_summary_screen.dart';

part 'ro_trip_list_detail_event.dart';
part 'ro_trip_list_detail_state.dart';

class RoTripListDetailBloc extends Bloc<RoTripListDetailEvent, RoTripListDetailState> {
  String? selectedReason;
  String? selectedReasonName;
  bool selectedReasonEmpty = false;
  bool selectedProductEmpty = false;
  bool selectedQuantityEmpty = false;
  bool commentTextEmpty = false;
  bool dateTextEmpty = false;
  bool expenseAmountEmpty = false;
  bool updateLoader = false;
  Widget detailPageWidget = const SizedBox();
  String detailPageId = EntryWidget.id;
  String? selectedLocation;
  String selectedLocationId = "";
  bool allFieldsEmpty = false;
  String commentText = "";
  String dateText = "";
  String expenseAmount = "";
  String productTextId = "";
  String? productText;
  String? quantityText;
  //List<Reason> resolveReasons = [];
  RoTripDetailModel roTripDetailModel = RoTripDetailModel.fromJson({});
  RoTripExpensesModel roTripExpensesModel = RoTripExpensesModel.fromJson({});
  List<TripListDataModel> selectedData = [];
  bool searchBarEnabled = false;
  String searchText = "";
  ReturnItemUpdateApiBody returnItemUpdateApiBody = ReturnItemUpdateApiBody.fromJson({});
  List<Map<String, dynamic>> totalReturnItemData = [];
  List<TotalReturnsDataModel> selectedReturnItemsData = [];
  List<TotalReturnsDataModel> selectedReturnTempItemsData = [];
  int totalQuantity = 0;
  int collectedQuantity = 0;
  int unavailableQuantity = 0;
  FilterOptionsResponse? product;
  List<LoadingLocation> loadingDataList = [];
  List<TotalAssetsDataModel> assetItemsList = [];
  List<TotalAssetsDataModel> assetItemsListTemp = [];
  List<String> updateAssetsList=[];
  List<TotalCollectedDataModel> selectedAmountSummaryData = [];
  List<Map<String,dynamic>> selectedCollectedAmountInvoicesList=[];

  RoTripListDetailBloc() : super(RoTripListDetailLoading()) {
    on<RoTripListDetailInitialEvent>(roTripListDetailInitialFunction);
    on<RoTripListDetailTabChangingEvent>(roTripListDetailTabChangingFunction);
    on<RoTripListDetailSetStateEvent>(roTripListDetailSetStateFunction);
    on<RoTripListDetailFilterEvent>(roTripListDetailFilterFunction);
    on<RoTripListDetailWidgetChangingEvent>(roTripListDetailWidgetChangingFunction);
    on<RoTripListDetailCompleteReturnEvent>(roTripListDetailCompleteReturnFunction);
    on<RoTripListDetailAddNewEvent>(roTripListDetailAddNewFunction);
    on<RoTripListDetailAddNewReturnItemEvent>(roTripListDetailAddNewReturnNewFunction);
    on<RoTripListDetailUpdateAssetsEvent>(roTripListDetailUpdateAssetsFunctions);
    on<RoTripListDetailUpdateCollectedAmountEvent>(roTripListDetailUpdateCollectedAmountFunctions);
  }

  Future<FutureOr<void>> roTripListDetailInitialFunction(RoTripListDetailInitialEvent event, Emitter<RoTripListDetailState> emit) async {
    emit(RoTripListDetailLoading());
    totalQuantity = 0;
    collectedQuantity = 0;
    unavailableQuantity = 0;
    returnItemUpdateApiBody.tripId = getIt<Variables>().generalVariables.roTripListMainIdData.tripId;
    Box<LoadingLocation> loadingLocationData = Hive.box<LoadingLocation>('loading_location');
    if (loadingLocationData.isNotEmpty) {
      loadingDataList = loadingLocationData.values.toList();
    }
    await getIt<Variables>().repoImpl.getReturnsTripListDetail(
        query: {"trip_id": getIt<Variables>().generalVariables.roTripListMainIdData.tripId},
        method: "post",
        module: ApiEndPoints().returnsModule).onError((error, stackTrace) {
      emit(RoTripListDetailError(message: error.toString()));
    }).then((value) {
      if (value != null) {
        if (value["status"] == "1") {
          roTripDetailModel = RoTripDetailModel.fromJson(value);
          selectedData = List<TripListDataModel>.from([
            {
              "label": "Vehicle No",
              "name": roTripDetailModel.response.tripInfo.vehicleNumber.toString(),
            },
            {
              "label": "Pink Slip Captured",
              "name": roTripDetailModel.response.tripInfo.pinkSlipCaptured.toString(),
            },
            {
              "label": "Pink Slip Not Captured",
              "name": roTripDetailModel.response.tripInfo.pinkSlipNotCaptured.toString(),
            },
            {
              "label": "Driver Name",
              "name": roTripDetailModel.response.tripInfo.driverName.toString(),
            },
            {
              "label": "Helper - 1",
              "name": roTripDetailModel.response.tripInfo.helper1Name.toString(),
            },
            {
              "label": "Helper - 2",
              "name": roTripDetailModel.response.tripInfo.helper2Name.toString(),
            },
            {
              "label": "OUT - Time",
              "name": roTripDetailModel.response.tripInfo.tripStartTime.toString(),
            },
            {
              "label": "In - Time",
              "name": roTripDetailModel.response.tripInfo.tripEndTime.toString(),
            },
            {
              "label": "DURATION",
              "name": roTripDetailModel.response.tripInfo.tripDuration.toString(),
            },
            {
              "label": "Start Meter",
              "name": roTripDetailModel.response.tripInfo.tripStartMeter.toString(),
            },
            {
              "label": "END Meter",
              "name": roTripDetailModel.response.tripInfo.tripEndMeter.toString(),
            },
            {
              "label": "Total Distance",
              "name": roTripDetailModel.response.tripInfo.tripDistance.toString(),
            }
          ].map((x) => TripListDataModel.fromJson(x)));
          selectedReturnItemsData = List<TotalReturnsDataModel>.from(value["response"]["stops"].map((x) => TotalReturnsDataModel.fromJson(x)));
          List<List<dynamic>> itemsList = [];
          for (int i = 0; i < value["response"]["stops"].length; i++) {
            itemsList.add([]);
            for (int j = 0; j < value["response"]["stops"][i]["invoices"].length; j++) {
              List<dynamic> particularItemsList = (value["response"]["stops"][i]["invoices"][j]["items"]);
              itemsList[i] = itemsList[i]..addAll(particularItemsList);
            }
          }
          itemsList.add(value["response"]["other_items"]);
          num othersTotalQuantity = 0;
          for (int i = 0; i < value["response"]["other_items"].length; i++) {
            othersTotalQuantity = othersTotalQuantity + value["response"]["other_items"][i]["quantity"];
          }
          selectedReturnItemsData.add(TotalReturnsDataModel(customer: 'Others', totalQty: othersTotalQuantity.toInt(), itemsList: []));
          for (int i = 0; i < selectedReturnItemsData.length; i++) {
            selectedReturnItemsData[i].itemsList = List<ItemsList>.from(itemsList[i].map((x) => ItemsList.fromJson(x)));
            totalQuantity = totalQuantity + selectedReturnItemsData[i].totalQty;
            for (int j = 0; j < selectedReturnItemsData[i].itemsList.length; j++) {
              collectedQuantity = collectedQuantity + int.parse(selectedReturnItemsData[i].itemsList[j].returnQty.toString());
            }
            unavailableQuantity = totalQuantity - collectedQuantity;
          }
          for (int i = 0; i < selectedReturnItemsData.length; i++) {
            for (int j = 0; j < selectedReturnItemsData[i].itemsList.length; j++) {
              selectedReturnItemsData[i].itemsList[j].addingTextEditingController.text = selectedReturnItemsData[i].itemsList[j].returnQty.toString();
              selectedReturnItemsData[i].itemsList[j].removingTextEditingController.text = "0";
              if (selectedReturnItemsData[i].itemsList[j].imagesList != "") {
                selectedReturnItemsData[i].itemsList[j].proofOfDeliveryImages = List.generate(
                    (selectedReturnItemsData[i].itemsList[j].imagesList.split(",").toList()).length,
                    (k) => ImageDataClass(
                        imageName: selectedReturnItemsData[i].itemsList[j].imagesList.split(",").toList()[k],
                        imagePath: selectedReturnItemsData[i].itemsList[j].imagesList.split(",").toList()[k],
                        canRemove: false));
              }
            }
          }
          selectedReturnTempItemsData.clear();
          selectedReturnTempItemsData.addAll(selectedReturnItemsData);
          selectedReturnItemsData = selectedReturnItemsData.where((e) => e.itemsList.isNotEmpty).toList();
          assetItemsList =
              List<TotalAssetsDataModel>.from(value["response"]["asset_checklist"].map((x) => TotalAssetsDataModel.fromJson(x)));
          assetItemsListTemp.clear();
          assetItemsListTemp.addAll(assetItemsList);
          selectedAmountSummaryData = List.from(value["response"]["stops"].map((x) => TotalCollectedDataModel.fromJson(x)));
        }
      }
    });
    /* emit(RoTripListDetailDummy());
    emit(RoTripListDetailLoaded());*/
    detailPageWidget = const EntryWidget();
    emit(RoTripListDetailConfirm());
    emit(RoTripListDetailLoaded());
    await getIt<Variables>().repoImpl.getRoTripExpensesList(
        query: {"trip_id": getIt<Variables>().generalVariables.roTripListMainIdData.tripId},
        method: "post",
        module: ApiEndPoints().returnsModule).onError((error, stackTrace) {
      emit(RoTripListDetailError(message: error.toString()));
    }).then((value) {
      if (value != null) {
        if (value["status"] == "1") {
          roTripExpensesModel = RoTripExpensesModel.fromJson(value);
        }
      }
    });
  }

  FutureOr<void> roTripListDetailTabChangingFunction(RoTripListDetailTabChangingEvent event, Emitter<RoTripListDetailState> emit) {}

  FutureOr<void> roTripListDetailSetStateFunction(RoTripListDetailSetStateEvent event, Emitter<RoTripListDetailState> emit) {
    emit(RoTripListDetailDummy());
    event.stillLoading ? emit(RoTripListDetailLoading()) : emit(RoTripListDetailLoaded());
  }

  FutureOr<void> roTripListDetailFilterFunction(RoTripListDetailFilterEvent event, Emitter<RoTripListDetailState> emit) {
    if (searchText != "") {
      selectedReturnItemsData.clear();
      assetItemsList.clear();
      selectedReturnItemsData.addAll(selectedReturnTempItemsData
          .map((model) {
            final matchedItems = model.itemsList
                .where((item) =>
                    item.itemName.toLowerCase().contains(searchText.toLowerCase()) || item.itemCode.toLowerCase().contains(searchText.toLowerCase()))
                .toList();
            return TotalReturnsDataModel(customer: model.customer, totalQty: model.totalQty, itemsList: matchedItems);
          })
          .where((model) => model.itemsList.isNotEmpty)
          .toList());
      assetItemsList.addAll(assetItemsListTemp.where((element)=>element.itemName.toLowerCase().contains(searchText.toLowerCase())).toList());
      emit(RoTripListDetailDummy());
      emit(RoTripListDetailLoaded());
    } else {
      selectedReturnItemsData.clear();
      assetItemsList.clear();
      selectedReturnItemsData.addAll(selectedReturnTempItemsData);
      assetItemsList.addAll(assetItemsListTemp);
      selectedReturnItemsData = selectedReturnItemsData.where((e) => e.itemsList.isNotEmpty).toList();
      emit(RoTripListDetailDummy());
      emit(RoTripListDetailLoaded());
    }
  }

  FutureOr<void> roTripListDetailWidgetChangingFunction(RoTripListDetailWidgetChangingEvent event, Emitter<RoTripListDetailState> emit) async {
    switch (event.selectedWidget) {
      case EntryWidget.id:
        {
          detailPageWidget = const EntryWidget();
          emit(RoTripListDetailConfirm());
        }
      case ReturnItemsWidget.id:
        {
          detailPageWidget = const ReturnItemsWidget();
          emit(RoTripListDetailConfirm());
        }
      case CollectedAmountWidget.id:
        {
          detailPageWidget = const CollectedAmountWidget();
          emit(RoTripListDetailConfirm());
        }
      case TotalAssetsWidget.id:
        {
          detailPageWidget = const TotalAssetsWidget();
          emit(RoTripListDetailConfirm());
        }
      case TotalExpensesWidget.id:
        {
          detailPageWidget = const TotalExpensesWidget();
          emit(RoTripListDetailConfirm());
        }
      default:
        {
          detailPageWidget = const EntryWidget();
          emit(RoTripListDetailConfirm());
        }
    }
    emit(RoTripListDetailLoaded());
  }

  FutureOr<void> roTripListDetailCompleteReturnFunction(RoTripListDetailCompleteReturnEvent event, Emitter<RoTripListDetailState> emit) async {
    returnItemUpdateApiBody.otherItems.clear();
    returnItemUpdateApiBody.items.clear();
    for (int i = 0; i < selectedReturnItemsData.length; i++) {
      returnItemUpdateApiBody.tripId = getIt<Variables>().generalVariables.roTripListMainIdData.tripId;
      returnItemUpdateApiBody.locationId = selectedLocationId;
      for (int j = 0; j < selectedReturnItemsData[i].itemsList.length; j++) {
        if (selectedReturnItemsData[i].customer.toLowerCase() == "others") {
          returnItemUpdateApiBody.otherItems.add(Item(
              itemId: selectedReturnItemsData[i].itemsList[j].itemId,
              returnQty: selectedReturnItemsData[i].itemsList[j].addingTextEditingController.text,
              unReturnQty: selectedReturnItemsData[i].itemsList[j].removingTextEditingController.text,
              proofOfReturn: selectedReturnItemsData[i].itemsList[j].imagesList));
        } else {
          returnItemUpdateApiBody.items.add(Item(
              itemId: selectedReturnItemsData[i].itemsList[j].lineItemId,
              returnQty: selectedReturnItemsData[i].itemsList[j].addingTextEditingController.text,
              unReturnQty: selectedReturnItemsData[i].itemsList[j].removingTextEditingController.text,
              proofOfReturn: selectedReturnItemsData[i].itemsList[j].imagesList));
        }
      }
    }
    await getIt<Variables>()
        .repoImpl
        .getRoTripUpdateReturnItems(query: returnItemUpdateApiBody.toJson(), method: "post", module: ApiEndPoints().returnsModule)
        .onError((error, stackTrace) {
      emit(RoTripListDetailError(message: error.toString()));
      emit(RoTripListDetailLoaded());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          await getIt<Variables>().repoImpl.getRoTripExpensesList(
              query: {"trip_id": getIt<Variables>().generalVariables.roTripListMainIdData.tripId},
              method: "post",
              module: ApiEndPoints().returnsModule).onError((error, stackTrace) {
            emit(RoTripListDetailError(message: error.toString()));
          }).then((value) {
            if (value != null) {
              if (value["status"] == "1") {
                roTripExpensesModel = RoTripExpensesModel.fromJson(value);
                emit(RoTripListDetailSuccess(message: getIt<Variables>().generalVariables.currentLanguage.successful));
                emit(RoTripListDetailLoaded());
              }
            }
          });
        }
      }
    });
  }

  FutureOr<void> roTripListDetailAddNewFunction(RoTripListDetailAddNewEvent event, Emitter<RoTripListDetailState> emit) async {
    await getIt<Variables>().repoImpl.getRoTripExpensesUpdate(query: {
      "trip_id": getIt<Variables>().generalVariables.roTripListMainIdData.tripId,
      "description": selectedReasonName,
      "expense_date": dateText,
      "amount": expenseAmount,
      "type": event.isEdit ? "edit" : "add"
    }, method: "post", module: ApiEndPoints().returnsModule).onError((error, stackTrace) {
      emit(RoTripListDetailError(message: error.toString()));
      emit(RoTripListDetailLoaded());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          await getIt<Variables>().repoImpl.getRoTripExpensesList(
              query: {"trip_id": getIt<Variables>().generalVariables.roTripListMainIdData.tripId},
              method: "post",
              module: ApiEndPoints().returnsModule).onError((error, stackTrace) {
            emit(RoTripListDetailError(message: error.toString()));
          }).then((value) {
            if (value != null) {
              if (value["status"] == "1") {
                roTripExpensesModel = RoTripExpensesModel.fromJson(value);
              }
            }
          });
          emit(RoTripListDetailSuccess(message: getIt<Variables>().generalVariables.currentLanguage.successful));
          emit(RoTripListDetailLoaded());
        }
      }
    });
  }

  FutureOr<void> roTripListDetailAddNewReturnNewFunction(RoTripListDetailAddNewReturnItemEvent event, Emitter<RoTripListDetailState> emit) async {
    List<String> customersList = List.generate(selectedReturnItemsData.length, (i) => selectedReturnItemsData[i].customer);
    if (customersList.contains("Others")) {
      int index = selectedReturnItemsData.indexWhere((e) => e.customer == "Others");
      ItemsList item = ItemsList(
        lineItemId: "",
        itemId: product!.id,
        itemCode: product!.code,
        itemName: product!.label,
        returnQty: int.parse(quantityText!),
        imagesList: "",
        addingTextEditingController: TextEditingController(),
        removingTextEditingController: TextEditingController(),
        moreQuantityError: false,
        podLoader: false,
        proofOfDeliveryImages: [],
      );
      selectedReturnItemsData[index].totalQty = int.parse((selectedReturnItemsData[index].totalQty + num.parse(quantityText!)).toString());
      selectedReturnItemsData[index].itemsList.add(item);
      int itemIndex = selectedReturnItemsData[index].itemsList.indexWhere((e) => e.itemCode == product!.code);
      selectedReturnItemsData[index].itemsList[itemIndex].addingTextEditingController.text = quantityText!;
      selectedReturnItemsData[index].itemsList[itemIndex].removingTextEditingController.text = "00";
      totalQuantity = totalQuantity + int.parse(quantityText!);
      collectedQuantity = collectedQuantity + int.parse(quantityText!);
    } else {
      ItemsList item = ItemsList(
        lineItemId: "",
        itemId: product!.id,
        itemCode: product!.code,
        itemName: product!.label,
        returnQty: int.parse(quantityText!),
        imagesList: "",
        addingTextEditingController: TextEditingController(),
        removingTextEditingController: TextEditingController(),
        moreQuantityError: false,
        podLoader: false,
        proofOfDeliveryImages: [],
      );
      selectedReturnItemsData.add(TotalReturnsDataModel(customer: "Others", totalQty: int.parse(quantityText!), itemsList: [item]));
      int index = selectedReturnItemsData.indexWhere((e) => e.customer == "Others");
      selectedReturnItemsData[index].itemsList[0].addingTextEditingController.text = quantityText!;
      selectedReturnItemsData[index].itemsList[0].removingTextEditingController.text = "00";
      totalQuantity = totalQuantity + int.parse(quantityText!);
      collectedQuantity = collectedQuantity + int.parse(quantityText!);
    }
    emit(RoTripListDetailSuccess(message: getIt<Variables>().generalVariables.currentLanguage.successful));
    emit(RoTripListDetailLoaded());
  }

  FutureOr<void> roTripListDetailUpdateAssetsFunctions(RoTripListDetailUpdateAssetsEvent event, Emitter<RoTripListDetailState> emit) async {
    await getIt<Variables>().repoImpl.getRoTripUpdateAssets(query: {
      "trip_id": getIt<Variables>().generalVariables.roTripListMainIdData.tripId,
      "assets": updateAssetsList
    }, method: "post", module: ApiEndPoints().returnsModule).onError((error, stackTrace) {
      emit(RoTripListDetailError(message: error.toString()));
      emit(RoTripListDetailLoaded());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          emit(RoTripListDetailSuccess(message: getIt<Variables>().generalVariables.currentLanguage.successful));
          emit(RoTripListDetailLoaded());
        }
      }
    });
  }

  FutureOr<void> roTripListDetailUpdateCollectedAmountFunctions(RoTripListDetailUpdateCollectedAmountEvent event, Emitter<RoTripListDetailState> emit) async{
    await getIt<Variables>().repoImpl.getRoTripUpdateInvoiceReceivedAmount(query: {
      "trip_id": getIt<Variables>().generalVariables.roTripListMainIdData.tripId,
      "invoices": selectedCollectedAmountInvoicesList
    }, method: "post", module: ApiEndPoints().returnsModule).onError((error, stackTrace) {
      emit(RoTripListDetailError(message: error.toString()));
      emit(RoTripListDetailLoaded());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          totalQuantity = 0;
          collectedQuantity = 0;
          unavailableQuantity = 0;
          returnItemUpdateApiBody.tripId = getIt<Variables>().generalVariables.roTripListMainIdData.tripId;
          Box<LoadingLocation> loadingLocationData = Hive.box<LoadingLocation>('loading_location');
          if (loadingLocationData.isNotEmpty) {
            loadingDataList = loadingLocationData.values.toList();
          }
          await getIt<Variables>().repoImpl.getReturnsTripListDetail(
              query: {"trip_id": getIt<Variables>().generalVariables.roTripListMainIdData.tripId},
              method: "post",
              module: ApiEndPoints().returnsModule).onError((error, stackTrace) {
            emit(RoTripListDetailError(message: error.toString()));
          }).then((value) {
            if (value != null) {
              if (value["status"] == "1") {
                roTripDetailModel = RoTripDetailModel.fromJson(value);
                selectedData = List<TripListDataModel>.from([
                  {
                    "label": "Vehicle No",
                    "name": roTripDetailModel.response.tripInfo.vehicleNumber.toString(),
                  },
                  {
                    "label": "Pink Slip Captured",
                    "name": roTripDetailModel.response.tripInfo.pinkSlipCaptured.toString(),
                  },
                  {
                    "label": "Pink Slip Not Captured",
                    "name": roTripDetailModel.response.tripInfo.pinkSlipNotCaptured.toString(),
                  },
                  {
                    "label": "Driver Name",
                    "name": roTripDetailModel.response.tripInfo.driverName.toString(),
                  },
                  {
                    "label": "Helper - 1",
                    "name": roTripDetailModel.response.tripInfo.helper1Name.toString(),
                  },
                  {
                    "label": "Helper - 2",
                    "name": roTripDetailModel.response.tripInfo.helper2Name.toString(),
                  },
                  {
                    "label": "OUT - Time",
                    "name": roTripDetailModel.response.tripInfo.tripStartTime.toString(),
                  },
                  {
                    "label": "In - Time",
                    "name": roTripDetailModel.response.tripInfo.tripEndTime.toString(),
                  },
                  {
                    "label": "DURATION",
                    "name": roTripDetailModel.response.tripInfo.tripDuration.toString(),
                  },
                  {
                    "label": "Start Meter",
                    "name": roTripDetailModel.response.tripInfo.tripStartMeter.toString(),
                  },
                  {
                    "label": "END Meter",
                    "name": roTripDetailModel.response.tripInfo.tripEndMeter.toString(),
                  },
                  {
                    "label": "Total Distance",
                    "name": roTripDetailModel.response.tripInfo.tripDistance.toString(),
                  }
                ].map((x) => TripListDataModel.fromJson(x)));
                selectedReturnItemsData = List<TotalReturnsDataModel>.from(value["response"]["stops"].map((x) => TotalReturnsDataModel.fromJson(x)));
                List<List<dynamic>> itemsList = [];
                for (int i = 0; i < value["response"]["stops"].length; i++) {
                  itemsList.add([]);
                  for (int j = 0; j < value["response"]["stops"][i]["invoices"].length; j++) {
                    List<dynamic> particularItemsList = (value["response"]["stops"][i]["invoices"][j]["items"]);
                    itemsList[i] = itemsList[i]..addAll(particularItemsList);
                  }
                }
                itemsList.add(value["response"]["other_items"]);
                num othersTotalQuantity = 0;
                for (int i = 0; i < value["response"]["other_items"].length; i++) {
                  othersTotalQuantity = othersTotalQuantity + value["response"]["other_items"][i]["quantity"];
                }
                selectedReturnItemsData.add(TotalReturnsDataModel(customer: 'Others', totalQty: othersTotalQuantity.toInt(), itemsList: []));
                for (int i = 0; i < selectedReturnItemsData.length; i++) {
                  selectedReturnItemsData[i].itemsList = List<ItemsList>.from(itemsList[i].map((x) => ItemsList.fromJson(x)));
                  totalQuantity = totalQuantity + selectedReturnItemsData[i].totalQty;
                  for (int j = 0; j < selectedReturnItemsData[i].itemsList.length; j++) {
                    collectedQuantity = collectedQuantity + int.parse(selectedReturnItemsData[i].itemsList[j].returnQty.toString());
                  }
                  unavailableQuantity = totalQuantity - collectedQuantity;
                }
                for (int i = 0; i < selectedReturnItemsData.length; i++) {
                  for (int j = 0; j < selectedReturnItemsData[i].itemsList.length; j++) {
                    selectedReturnItemsData[i].itemsList[j].addingTextEditingController.text = selectedReturnItemsData[i].itemsList[j].returnQty.toString();
                    selectedReturnItemsData[i].itemsList[j].removingTextEditingController.text = "0";
                    if (selectedReturnItemsData[i].itemsList[j].imagesList != "") {
                      selectedReturnItemsData[i].itemsList[j].proofOfDeliveryImages = List.generate(
                          (selectedReturnItemsData[i].itemsList[j].imagesList.split(",").toList()).length,
                              (k) => ImageDataClass(
                              imageName: selectedReturnItemsData[i].itemsList[j].imagesList.split(",").toList()[k],
                              imagePath: selectedReturnItemsData[i].itemsList[j].imagesList.split(",").toList()[k],
                              canRemove: false));
                    }
                  }
                }
                selectedReturnTempItemsData.clear();
                selectedReturnTempItemsData.addAll(selectedReturnItemsData);
                selectedReturnItemsData = selectedReturnItemsData.where((e) => e.itemsList.isNotEmpty).toList();
                assetItemsList =
                List<TotalAssetsDataModel>.from(value["response"]["asset_checklist"].map((x) => TotalAssetsDataModel.fromJson(x)));
                selectedAmountSummaryData = List.from(value["response"]["stops"].map((x) => TotalCollectedDataModel.fromJson(x)));
              }
            }
          });
          emit(RoTripListDetailSuccess(message: getIt<Variables>().generalVariables.currentLanguage.successful));
          emit(RoTripListDetailLoaded());
        }
      }
    });
  }
}
