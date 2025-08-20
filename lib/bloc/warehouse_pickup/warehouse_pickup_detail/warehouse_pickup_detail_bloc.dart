// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:oda/local_database/pick_list_box/pick_list.dart';
import 'package:oda/local_database/trip_box/trip_list.dart';
import 'package:oda/local_database/user_box/user.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/variables.dart';

part 'warehouse_pickup_detail_event.dart';
part 'warehouse_pickup_detail_state.dart';

class WarehousePickupDetailBloc extends Bloc<WarehousePickupDetailEvent, WarehousePickupDetailState> {
  String searchText = "";
  int pageIndex = 1;
  String? selectedStagingArea;
  String? selectedItem;
  String? selectedFloor;
  String? selectedRoom;
  String? selectedZone;
  int tabIndex = 0;
  bool isCatchWeightData = true;
  List<String> availQtyParticulars = [];
  List<String> languages = ['Android', 'IOS', 'Flutter', 'Node', 'Java', 'Python', 'PHP'];
  List<ItemsList> searchedItemsList = [];
  List<BatchesList> searchedBatchesList = [];
  String tabName = "Pending";
  List<ItemsList> singleTabItemsList = [];
  List<List<ItemsList>> singleTabGroupedItemsList = [];
  List<List<ItemsList>> singleTabGroupingItemsList = [];
  bool searchBarEnabled = false;
  bool updateLoader = false;
  List<String> groupedKeepersNameList = [];
  String selectedReason = "";
  String? selectedReasonName;
  bool selectedReasonEmpty = false;
  bool commentTextEmpty = false;

  ItemsList selectedForDeliveredItem = ItemsList.fromJson({});
  Map<String, dynamic> deliveredQuantityData = {};
  List<String> deliveredCatchWeightData = [];
  String commentText = "";
  String selectedItemId = "";
  List<UnavailableReason> searchReasons = [];

  WarehousePickupDetailBloc() : super(WarehousePickupDetailLoading()) {
    on<WarehousePickupDetailInitialEvent>(warehousePickupDetailInitialFunction);
    on<WarehousePickupDetailSetStateEvent>(warehousePickupDetailSetStateFunction);
    on<WarehousePickupDetailTabChangingEvent>(warehousePickupDetailTabChangingFunction);
    on<WarehousePickupDetailFilterEvent>(warehousePickupDetailFilterFunction);
    on<WarehousePickupDetailDeliveredEvent>(warehousePickupDetailDeliveredFunction);
    on<WarehousePickupDetailUndoDeliveredEvent>(warehousePickupDetailUndoDeliveredFunction);
    on<WarehousePickupDetailUnavailableEvent>(warehousePickupDetailUnavailableFunction);
  }

  FutureOr<void> warehousePickupDetailInitialFunction(WarehousePickupDetailInitialEvent event, Emitter<WarehousePickupDetailState> emit) async {
    searchedItemsList.clear();
    singleTabItemsList.clear();
    singleTabGroupedItemsList.clear();
    singleTabGroupingItemsList.clear();
    searchBarEnabled = false;
    searchText = "";
    pageIndex = 1;
    tabIndex = 0;
    tabName = "Pending";
    searchedBatchesList.clear();
    getIt<Variables>().generalVariables.filters.clear();
    getIt<Variables>().generalVariables.selectedFilters.clear();
    getIt<Variables>().generalVariables.selectedFiltersName.clear();
    getIt<Variables>().generalVariables.filterSearchController.clear();
    getIt<Variables>().generalVariables.searchedResultFilterOption.clear();
    getIt<Variables>().generalVariables.filterSelectedMainIndex = 0;
    Box<SoList> soListBox = Hive.box<SoList>('so_list_pickup');
    Box<ItemsList> itemsListBox = Hive.box<ItemsList>('items_list_pickup');
    Box<BatchesList> batchesListBox = Hive.box<BatchesList>('batches_list_pickup');
    Box<UnavailableReason> unavailableReasonData = await Hive.openBox<UnavailableReason>('unavailable_reason');
    searchReasons = unavailableReasonData.values.toList();
    getIt<Variables>().generalVariables.soListMainIdData =
        soListBox.values.toList().firstWhere((element) => element.soId == getIt<Variables>().generalVariables.soListMainIdData.soId);
    searchedItemsList
        .addAll(itemsListBox.values.toList().where((element) => element.soId == getIt<Variables>().generalVariables.soListMainIdData.soId).toList());
    searchedBatchesList.addAll(
        batchesListBox.values.toList().where((element) => element.soId == getIt<Variables>().generalVariables.soListMainIdData.soId).toList());
    Map<String, List<BatchesList>> groupedForBatchesList = groupBy(searchedBatchesList, (BatchesList item) => item.itemId);
    for (int i = 0; i < searchedItemsList.length; i++) {
      searchedItemsList[i].itemBatchesList.clear();
      searchedItemsList[i].itemBatchesList.addAll(groupedForBatchesList[searchedItemsList[i].lineItemId] ?? []);
    }
    singleTabItemsList = searchedItemsList.where((element) => element.itemLoadedStatus == tabName).toList();
    Map<String, List<ItemsList>> grouped = groupBy(singleTabItemsList, (ItemsList item) => item.stagingArea);
    singleTabGroupedItemsList = grouped.values.toList();
    getIt<Variables>().generalVariables.filters = List<Filter>.from([
      {
        "type": "item_code",
        "label": getIt<Variables>().generalVariables.currentLanguage.itemCode,
        "selection": "multiple",
        "get_options": false,
        "options": List.generate(searchedItemsList.length, (i) => {"id": searchedItemsList[i].itemCode, "label": searchedItemsList[i].itemCode})
            .map((map) => jsonEncode(map))
            .toSet()
            .map((str) => jsonDecode(str))
            .toList()
      }
    ].map((x) => Filter.fromJson(x)));
    emit(WarehousePickupDetailLoading());
    emit(WarehousePickupDetailLoaded());
  }

  FutureOr<void> warehousePickupDetailTabChangingFunction(WarehousePickupDetailTabChangingEvent event, Emitter<WarehousePickupDetailState> emit) async {
    emit(WarehousePickupDetailLoading());
    if (tabName == "Pending" || tabName == "Unavailable") {
      singleTabItemsList.clear();
      singleTabItemsList = searchedItemsList.where((element) => element.itemLoadedStatus == tabName).toList();
      Map<String, List<ItemsList>> grouped = groupBy(singleTabItemsList, (ItemsList item) => item.stagingArea);
      singleTabGroupedItemsList = grouped.values.toList();
      emit(WarehousePickupDetailLoaded());
    } else {
      singleTabItemsList.clear();
      singleTabItemsList = searchedItemsList.where((element) => element.itemLoadedStatus == tabName).toList();
      List<ItemsList> itemsDeliveredList = singleTabItemsList.where((element) => !element.isProgressStatus).toList();
      Map<String, List<ItemsList>> grouped = groupBy(itemsDeliveredList, (ItemsList item) => item.stagingArea);
      singleTabGroupedItemsList = grouped.values.toList();
      List<ItemsList> itemDeliveringList = singleTabItemsList.where((element) => element.isProgressStatus).toList();
      Map<String, List<ItemsList>> groupedData = {};
      for (ItemsList item in itemDeliveringList) {
        List<HandledByForUpdateList> handledBy = item.handledBy;
        for (HandledByForUpdateList handler in handledBy) {
          String name = handler.name;
          if (!groupedData.containsKey(name)) {
            groupedData[name] = [];
          }
          groupedData[name]!.add(item);
        }
      }
      groupedKeepersNameList = groupedData.keys.toList();
      singleTabGroupingItemsList = groupedData.values.toList();
      emit(WarehousePickupDetailLoaded());
    }
  }

  FutureOr<void> warehousePickupDetailSetStateFunction(WarehousePickupDetailSetStateEvent event, Emitter<WarehousePickupDetailState> emit) async {
    emit(WarehousePickupDetailDummy());
    event.stillLoading ? emit(WarehousePickupDetailLoading()) : emit(WarehousePickupDetailLoaded());
  }

  FutureOr<void> warehousePickupDetailFilterFunction(WarehousePickupDetailFilterEvent event, Emitter<WarehousePickupDetailState> emit) async {
    await filterItemFunction();
    emit(WarehousePickupDetailLoading());
    emit(WarehousePickupDetailLoaded());
  }

  Future<FutureOr<void>> warehousePickupDetailDeliveredFunction(
      WarehousePickupDetailDeliveredEvent event, Emitter<WarehousePickupDetailState> emit) async {
    String responseValue = await apiCalls(queryData: {
      "activity": "delivered",
      "query_data": {
        "trip_id": getIt<Variables>().generalVariables.tripListMainIdData.tripId,
        "line_item_id": selectedForDeliveredItem.lineItemId,
        "item_id": selectedForDeliveredItem.itemId,
        "update_qty": deliveredQuantityData,
        "catchweight_qty": deliveredCatchWeightData.join(","),
        "timestamp": (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
        "online_mode": getIt<Variables>().generalVariables.isNetworkOffline == false,
      }
    }, sessionTime: "");
    await filterItemFunction();
    responseValue != ""
        ? emit(WarehousePickupDetailError(message: responseValue))
        : emit(WarehousePickupDetailSuccess(message: getIt<Variables>().generalVariables.currentLanguage.deliveredSuccessfully));
    emit(WarehousePickupDetailLoaded());
  }

  Future<FutureOr<void>> warehousePickupDetailUndoDeliveredFunction(
      WarehousePickupDetailUndoDeliveredEvent event, Emitter<WarehousePickupDetailState> emit) async {
    String responseValue = await apiCalls(queryData: {
      "activity": "undo",
      "query_data": {
        "trip_id": getIt<Variables>().generalVariables.tripListMainIdData.tripId,
        "line_item_id": selectedForDeliveredItem.lineItemId,
        "type": "Undo",
        "timestamp": (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
        "online_mode": getIt<Variables>().generalVariables.isNetworkOffline == false,
      }
    }, sessionTime: "");
    await filterItemFunction();
    responseValue != ""
        ? emit(WarehousePickupDetailError(message: responseValue))
        : emit(WarehousePickupDetailSuccess(message: getIt<Variables>().generalVariables.currentLanguage.undoSuccessfully));
    emit(WarehousePickupDetailLoaded());
  }

  Future<FutureOr<void>> warehousePickupDetailUnavailableFunction(
      WarehousePickupDetailUnavailableEvent event, Emitter<WarehousePickupDetailState> emit) async {
    String responseValue = await apiCalls(queryData: {
      "activity": "unavailable",
      "query_data": {
        "trip_id": getIt<Variables>().generalVariables.tripListMainIdData.tripId,
        "line_item_id": selectedForDeliveredItem.lineItemId,
        "remarks": commentText,
        "reason": selectedReason,
        "type": "Unavailable",
        "timestamp": (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
        "online_mode": getIt<Variables>().generalVariables.isNetworkOffline == false,
      }
    }, sessionTime: "");
    await filterItemFunction();
    responseValue != ""
        ? emit(WarehousePickupDetailError(message: responseValue))
        : emit(WarehousePickupDetailSuccess(message: getIt<Variables>().generalVariables.currentLanguage.movedUnavailableSuccessfully));
    emit(WarehousePickupDetailLoaded());
  }

  filterItemFunction() async {
    searchedItemsList.clear();
    searchedBatchesList.clear();
    Box<ItemsList> itemsListBox = Hive.box<ItemsList>('items_list_pickup');
    Box<BatchesList> batchesListBox = Hive.box<BatchesList>('batches_list_pickup');
    searchedItemsList
        .addAll(itemsListBox.values.toList().where((element) => element.soId == getIt<Variables>().generalVariables.soListMainIdData.soId).toList());
    searchedBatchesList.addAll(
        batchesListBox.values.toList().where((element) => element.soId == getIt<Variables>().generalVariables.soListMainIdData.soId).toList());
    Map<String, List<BatchesList>> groupedForBatchesList = groupBy(searchedBatchesList, (BatchesList item) => item.itemId);
    for (int i = 0; i < searchedItemsList.length; i++) {
      searchedItemsList[i].itemBatchesList.clear();
      searchedItemsList[i].itemBatchesList.addAll(groupedForBatchesList[searchedItemsList[i].lineItemId] ?? []);
    }
    searchedItemsList = searchedItemsList
        .where((element) =>
            element.itemName.toLowerCase().contains(searchText.toLowerCase()) || element.itemCode.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    List<ItemsList> filteredList = [];
    filteredList.addAll(searchedItemsList);
    for (int i = 0; i < getIt<Variables>().generalVariables.selectedFilters.length; i++) {
      switch (getIt<Variables>().generalVariables.selectedFilters[i].type) {
        case "item_code":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.itemCode == item2))
                .toList();
          }
        default:
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.itemName == item2))
                .toList();
          }
      }
    }
    searchedItemsList.clear();
    searchedItemsList.addAll(filteredList);
    singleTabItemsList = searchedItemsList.where((element) => element.itemLoadedStatus == tabName).toList();
    List<ItemsList> itemsDeliveredList = singleTabItemsList.where((element) => !element.isProgressStatus).toList();
    Map<String, List<ItemsList>> grouped = groupBy(itemsDeliveredList, (ItemsList item) => item.stagingArea);
    singleTabGroupedItemsList = grouped.values.toList();
    List<ItemsList> itemDeliveringList = singleTabItemsList.where((element) => element.isProgressStatus).toList();
    Map<String, List<ItemsList>> groupedData = {};
    for (ItemsList item in itemDeliveringList) {
      List<HandledByForUpdateList> handledBy = item.handledBy;
      for (HandledByForUpdateList handler in handledBy) {
        String name = handler.name;
        if (!groupedData.containsKey(name)) {
          groupedData[name] = [];
        }
        groupedData[name]!.add(item);
      }
    }
    groupedKeepersNameList = groupedData.keys.toList();
    singleTabGroupingItemsList = groupedData.values.toList();
  }

  Future<String> apiCalls({
    required Map<String, dynamic> queryData,
    required String sessionTime,
  }) async {
    String responseBool = "";
    switch (queryData['activity']) {
      case "delivered":
        {
          await deliveredFunction();
        }
      case "undo":
        {
          await undoDeliveredFunction();
        }
      case "unavailable":
        {
          await unavailableItemFunction();
        }
      default:
        {
          await deliveredFunction();
        }
    }
    return responseBool;
  }

  deliveredFunction() async {
    String userCode = getIt<Variables>().generalVariables.userDataEmployeeCode;
    List<FilterOptionsResponse> usersList = getIt<Variables>().generalVariables.userData.usersList;
    HandledByForUpdateList userHandled = HandledByForUpdateList.fromJson(usersList.singleWhere((user) => user.code == userCode).toJson());
    getIt<Variables>().generalVariables.soListMainIdData.disputeStatus = false;
    if (selectedForDeliveredItem.catchWeightStatus != "No") {
      userHandled.updatedItems = selectedForDeliveredItem.quantity;
      if (getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.isNotEmpty) {
        List<String> soListHandledByCodeList = List.generate(getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.length,
            (i) => getIt<Variables>().generalVariables.soListMainIdData.soHandledBy[i].code);
        if (soListHandledByCodeList.contains(userHandled.code)) {
          getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems =
              (num.parse(getIt<Variables>()
                          .generalVariables
                          .soListMainIdData
                          .soHandledBy
                          .singleWhere((handled) => handled.code == userHandled.code)
                          .updatedItems) +
                      num.parse(userHandled.updatedItems))
                  .toString();
        } else {
          getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.clear();
          getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.add(userHandled);
        }
      } else {
        getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.add(userHandled);
      }
      if (selectedForDeliveredItem.handledBy.isNotEmpty) {
        List<String> itemListHandledByCodeList =
            List.generate(selectedForDeliveredItem.handledBy.length, (i) => selectedForDeliveredItem.handledBy[i].code);
        if (itemListHandledByCodeList.contains(userHandled.code)) {
          selectedForDeliveredItem.handledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems =
              (num.parse(selectedForDeliveredItem.handledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems) +
                      num.parse(userHandled.updatedItems))
                  .toString();
        } else {
          selectedForDeliveredItem.handledBy.clear();
          selectedForDeliveredItem.handledBy.add(userHandled);
        }
      } else {
        selectedForDeliveredItem.handledBy.add(userHandled);
      }
      selectedForDeliveredItem.itemLoadedStatus = "Loaded";
      selectedForDeliveredItem.isProgressStatus = true;
      selectedForDeliveredItem.lineLoadedQty = selectedForDeliveredItem.quantity;
      List<ItemsList> loadedItemsList = searchedItemsList.where((element) => element.itemLoadedStatus == "Loaded").toList();
      Map<String, List<ItemsList>> groupedForLoadedItemsList = groupBy(loadedItemsList, (ItemsList item) => item.soId);
      int loadedCount = (groupedForLoadedItemsList[getIt<Variables>().generalVariables.soListMainIdData.soId] ?? []).length;
      getIt<Variables>().generalVariables.soListMainIdData.soNoOfLoadedItems = loadedCount.toString();
      if (getIt<Variables>().generalVariables.soListMainIdData.soNoOfLoadedItems ==
          getIt<Variables>().generalVariables.soListMainIdData.soNoOfItems) {
        getIt<Variables>().generalVariables.soListMainIdData.soStatus =
            getIt<Variables>().generalVariables.currentLanguage.loaded.toLowerCase().replaceFirst("l", "L");
      } else if (getIt<Variables>().generalVariables.soListMainIdData.soNoOfLoadedItems == "0") {
        getIt<Variables>().generalVariables.soListMainIdData.soStatus =
            getIt<Variables>().generalVariables.currentLanguage.pending.toLowerCase().replaceFirst("p", "P");
      } else {
        getIt<Variables>().generalVariables.soListMainIdData.soStatus =
            getIt<Variables>().generalVariables.currentLanguage.partial.toLowerCase().replaceFirst("p", "P");
      }
      getIt<Variables>().generalVariables.soListMainIdData.sessionInfo.isOpened = true;
      if (getIt<Variables>().generalVariables.soListMainIdData.sessionInfo.sessionStartTimestamp == "") {
        getIt<Variables>().generalVariables.soListMainIdData.sessionInfo.sessionStartTimestamp =
            (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      }
    } else {
      userHandled.updatedItems = selectedForDeliveredItem.quantity;
      if (getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.isNotEmpty) {
        List<String> soListHandledByCodeList = List.generate(getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.length,
            (i) => getIt<Variables>().generalVariables.soListMainIdData.soHandledBy[i].code);
        if (soListHandledByCodeList.contains(userHandled.code)) {
          getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems =
              (num.parse(getIt<Variables>()
                          .generalVariables
                          .soListMainIdData
                          .soHandledBy
                          .singleWhere((handled) => handled.code == userHandled.code)
                          .updatedItems) +
                      num.parse(userHandled.updatedItems))
                  .toString();
        } else {
          getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.clear();
          getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.add(userHandled);
        }
      } else {
        getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.add(userHandled);
      }
      if (selectedForDeliveredItem.handledBy.isNotEmpty) {
        List<String> itemListHandledByCodeList =
            List.generate(selectedForDeliveredItem.handledBy.length, (i) => selectedForDeliveredItem.handledBy[i].code);
        if (itemListHandledByCodeList.contains(userHandled.code)) {
          selectedForDeliveredItem.handledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems =
              (num.parse(selectedForDeliveredItem.handledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems) +
                      num.parse(userHandled.updatedItems))
                  .toString();
        } else {
          selectedForDeliveredItem.handledBy.clear();
          selectedForDeliveredItem.handledBy.add(userHandled);
        }
      } else {
        selectedForDeliveredItem.handledBy.add(userHandled);
      }
      selectedForDeliveredItem.isProgressStatus = true;
      selectedForDeliveredItem.lineLoadedQty = selectedForDeliveredItem.quantity;
      selectedForDeliveredItem.itemLoadedStatus = "Loaded";
      List<ItemsList> loadedItemsList = searchedItemsList.where((element) => element.itemLoadedStatus == "Loaded").toList();
      Map<String, List<ItemsList>> groupedForLoadedItemsList = groupBy(loadedItemsList, (ItemsList item) => item.soId);
      int loadedCount = (groupedForLoadedItemsList[getIt<Variables>().generalVariables.soListMainIdData.soId] ?? []).length;
      getIt<Variables>().generalVariables.soListMainIdData.soNoOfLoadedItems = loadedCount.toString();
      if (getIt<Variables>().generalVariables.soListMainIdData.soNoOfLoadedItems ==
          getIt<Variables>().generalVariables.soListMainIdData.soNoOfItems) {
        getIt<Variables>().generalVariables.soListMainIdData.soStatus =
            getIt<Variables>().generalVariables.currentLanguage.loaded.toLowerCase().replaceFirst("l", "L");
      } else if (getIt<Variables>().generalVariables.soListMainIdData.soNoOfLoadedItems == "0") {
        getIt<Variables>().generalVariables.soListMainIdData.soStatus =
            getIt<Variables>().generalVariables.currentLanguage.pending.toLowerCase().replaceFirst("p", "P");
      } else {
        getIt<Variables>().generalVariables.soListMainIdData.soStatus =
            getIt<Variables>().generalVariables.currentLanguage.partial.toLowerCase().replaceFirst("p", "P");
      }
      getIt<Variables>().generalVariables.soListMainIdData.sessionInfo.isOpened = true;
      if (getIt<Variables>().generalVariables.soListMainIdData.sessionInfo.sessionStartTimestamp == "") {
        getIt<Variables>().generalVariables.soListMainIdData.sessionInfo.sessionStartTimestamp =
            (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      }
    }
    Box<SoList> soListBox = Hive.box<SoList>('so_list_pickup');
    Box<ItemsList> itemsListBox = Hive.box<ItemsList>('items_list_pickup');
    Box<BatchesList> batchesListBox = Hive.box<BatchesList>('batches_list_pickup');
    for (int i = 0; i < selectedForDeliveredItem.itemBatchesList.length; i++) {
      int batchKey = batchesListBox.keys.firstWhere((k) =>
          batchesListBox.get(k)?.tripId == selectedForDeliveredItem.tripId &&
          batchesListBox.get(k)?.batchId == selectedForDeliveredItem.itemBatchesList[i].batchId);
      await batchesListBox.put(batchKey, selectedForDeliveredItem.itemBatchesList[i]);
    }
    int itemKey = itemsListBox.keys.firstWhere((k) =>
        itemsListBox.get(k)?.tripId == selectedForDeliveredItem.tripId && itemsListBox.get(k)?.lineItemId == selectedForDeliveredItem.lineItemId);
    await itemsListBox.put(itemKey, selectedForDeliveredItem);
    int soKey = soListBox.keys
        .firstWhere((k) => soListBox.get(k)?.tripId == selectedForDeliveredItem.tripId && soListBox.get(k)?.soId == selectedForDeliveredItem.soId);
    await soListBox.put(soKey, getIt<Variables>().generalVariables.soListMainIdData);
  }

  undoDeliveredFunction() async {
    String userCode = getIt<Variables>().generalVariables.userDataEmployeeCode;
    List<FilterOptionsResponse> usersList = getIt<Variables>().generalVariables.userData.usersList;
    HandledByForUpdateList userHandled = HandledByForUpdateList.fromJson(usersList.singleWhere((user) => user.code == userCode).toJson());
    if (selectedForDeliveredItem.catchWeightStatus != "No") {
      userHandled.updatedItems = selectedForDeliveredItem.quantity;
      for (int i = 0; i < getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.length; i++) {
        if (getIt<Variables>().generalVariables.soListMainIdData.soHandledBy[i].code == userHandled.code) {
          getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems =
              (num.parse(getIt<Variables>()
                          .generalVariables
                          .soListMainIdData
                          .soHandledBy
                          .singleWhere((handled) => handled.code == userHandled.code)
                          .updatedItems) -
                      num.parse(userHandled.updatedItems))
                  .toString();
          if (num.parse(getIt<Variables>()
                  .generalVariables
                  .soListMainIdData
                  .soHandledBy
                  .singleWhere((handled) => handled.code == userHandled.code)
                  .updatedItems) ==
              0) {
            getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.removeAt(i);
          }
          break;
        }
      }
      for (int i = 0; i < selectedForDeliveredItem.handledBy.length; i++) {
        if (selectedForDeliveredItem.handledBy[i].code == userHandled.code) {
          selectedForDeliveredItem.handledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems =
              (num.parse(selectedForDeliveredItem.handledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems) -
                      num.parse(userHandled.updatedItems))
                  .toString();
          if (num.parse(selectedForDeliveredItem.handledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems) == 0) {
            selectedForDeliveredItem.handledBy.removeAt(i);
          }
          break;
        }
      }
      selectedForDeliveredItem.itemLoadedStatus = "Pending";
      selectedForDeliveredItem.isProgressStatus = false;
      selectedForDeliveredItem.lineLoadedQty = "0";
      List<ItemsList> loadedItemsList = searchedItemsList.where((element) => element.itemLoadedStatus == "Loaded").toList();
      Map<String, List<ItemsList>> groupedForLoadedItemsList = groupBy(loadedItemsList, (ItemsList item) => item.soId);
      int loadedCount = (groupedForLoadedItemsList[getIt<Variables>().generalVariables.soListMainIdData.soId] ?? []).length;
      getIt<Variables>().generalVariables.soListMainIdData.soNoOfLoadedItems = loadedCount.toString();
      if (getIt<Variables>().generalVariables.soListMainIdData.soNoOfLoadedItems ==
          getIt<Variables>().generalVariables.soListMainIdData.soNoOfItems) {
        getIt<Variables>().generalVariables.soListMainIdData.soStatus =
            getIt<Variables>().generalVariables.currentLanguage.loaded.toLowerCase().replaceFirst("l", "L");
      } else if (getIt<Variables>().generalVariables.soListMainIdData.soNoOfLoadedItems == "0") {
        getIt<Variables>().generalVariables.soListMainIdData.soStatus =
            getIt<Variables>().generalVariables.currentLanguage.pending.toLowerCase().replaceFirst("p", "P");
      } else {
        getIt<Variables>().generalVariables.soListMainIdData.soStatus =
            getIt<Variables>().generalVariables.currentLanguage.partial.toLowerCase().replaceFirst("p", "P");
      }
      getIt<Variables>().generalVariables.soListMainIdData.sessionInfo.isOpened = true;
      if (getIt<Variables>().generalVariables.soListMainIdData.sessionInfo.sessionStartTimestamp == "") {
        getIt<Variables>().generalVariables.soListMainIdData.sessionInfo.sessionStartTimestamp =
            (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      }
    } else {
      userHandled.updatedItems = selectedForDeliveredItem.quantity;
      for (int i = 0; i < getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.length; i++) {
        if (getIt<Variables>().generalVariables.soListMainIdData.soHandledBy[i].code == userHandled.code) {
          getIt<Variables>().generalVariables.soListMainIdData.soHandledBy[i].updatedItems =
              (num.parse(getIt<Variables>().generalVariables.soListMainIdData.soHandledBy[i].updatedItems) - num.parse(userHandled.updatedItems))
                  .toString();
          if (num.parse(getIt<Variables>().generalVariables.soListMainIdData.soHandledBy[i].updatedItems) == 0) {
            getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.removeAt(i);
          }
          break;
        }
      }
      for (int i = 0; i < selectedForDeliveredItem.handledBy.length; i++) {
        if (selectedForDeliveredItem.handledBy[i].code == userHandled.code) {
          selectedForDeliveredItem.handledBy[i].updatedItems =
              (num.parse(selectedForDeliveredItem.handledBy[i].updatedItems) - num.parse(userHandled.updatedItems)).toString();
          if (num.parse(selectedForDeliveredItem.handledBy[i].updatedItems) == 0) {
            selectedForDeliveredItem.handledBy.removeAt(i);
          }
          break;
        }
      }
      selectedForDeliveredItem.itemLoadedStatus = "Pending";
      selectedForDeliveredItem.isProgressStatus = false;
      selectedForDeliveredItem.lineLoadedQty = "0";
      List<ItemsList> loadedItemsList = searchedItemsList.where((element) => element.itemTrippedStatus == "Loaded").toList();
      Map<String, List<ItemsList>> groupedForLoadedItemsList = groupBy(loadedItemsList, (ItemsList item) => item.soId);
      int loadedCount = (groupedForLoadedItemsList[getIt<Variables>().generalVariables.soListMainIdData.soId] ?? []).length;
      getIt<Variables>().generalVariables.soListMainIdData.soNoOfLoadedItems = loadedCount.toString();
      if (getIt<Variables>().generalVariables.soListMainIdData.soNoOfLoadedItems ==
          getIt<Variables>().generalVariables.soListMainIdData.soNoOfItems) {
        getIt<Variables>().generalVariables.soListMainIdData.soStatus =
            getIt<Variables>().generalVariables.currentLanguage.loaded.toLowerCase().replaceFirst("l", "L");
      } else if (getIt<Variables>().generalVariables.soListMainIdData.soNoOfLoadedItems == "0") {
        getIt<Variables>().generalVariables.soListMainIdData.soStatus =
            getIt<Variables>().generalVariables.currentLanguage.pending.toLowerCase().replaceFirst("p", "P");
      } else {
        getIt<Variables>().generalVariables.soListMainIdData.soStatus =
            getIt<Variables>().generalVariables.currentLanguage.partial.toLowerCase().replaceFirst("p", "P");
      }
      getIt<Variables>().generalVariables.soListMainIdData.sessionInfo.isOpened = true;
      if (getIt<Variables>().generalVariables.soListMainIdData.sessionInfo.sessionStartTimestamp == "") {
        getIt<Variables>().generalVariables.soListMainIdData.sessionInfo.sessionStartTimestamp =
            (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      }
    }
    Box<SoList> soListBox = Hive.box<SoList>('so_list_pickup');
    Box<ItemsList> itemsListBox = Hive.box<ItemsList>('items_list_pickup');
    Box<BatchesList> batchesListBox = Hive.box<BatchesList>('batches_list_pickup');
    for (int i = 0; i < selectedForDeliveredItem.itemBatchesList.length; i++) {
      int batchKey = batchesListBox.keys.firstWhere((k) =>
          batchesListBox.get(k)?.tripId == selectedForDeliveredItem.tripId &&
          batchesListBox.get(k)?.batchId == selectedForDeliveredItem.itemBatchesList[i].batchId);
      await batchesListBox.put(batchKey, selectedForDeliveredItem.itemBatchesList[i]);
    }
    int itemKey = itemsListBox.keys.firstWhere((k) =>
        itemsListBox.get(k)?.tripId == selectedForDeliveredItem.tripId && itemsListBox.get(k)?.lineItemId == selectedForDeliveredItem.lineItemId);
    await itemsListBox.put(itemKey, selectedForDeliveredItem);
    int soKey = soListBox.keys
        .firstWhere((k) => soListBox.get(k)?.tripId == selectedForDeliveredItem.tripId && soListBox.get(k)?.soId == selectedForDeliveredItem.soId);
    await soListBox.put(soKey, getIt<Variables>().generalVariables.soListMainIdData);
  }

  unavailableItemFunction() async {
    num sum = 0;
    String userCode = getIt<Variables>().generalVariables.userDataEmployeeCode;
    List<FilterOptionsResponse> usersList = getIt<Variables>().generalVariables.userData.usersList;
    HandledByForUpdateList userHandled = HandledByForUpdateList.fromJson(usersList.singleWhere((user) => user.code == userCode).toJson());
    userHandled.updatedItems = sum.toString();
    if (getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.isNotEmpty) {
      List<String> soListHandledByCodeList = List.generate(getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.length,
          (i) => getIt<Variables>().generalVariables.soListMainIdData.soHandledBy[i].code);
      if (soListHandledByCodeList.contains(userHandled.code)) {
        getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems =
            (num.parse(getIt<Variables>()
                        .generalVariables
                        .soListMainIdData
                        .soHandledBy
                        .singleWhere((handled) => handled.code == userHandled.code)
                        .updatedItems) +
                    num.parse(userHandled.updatedItems))
                .toString();
      } else {
        getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.clear();
        getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.add(userHandled);
      }
    } else {
      getIt<Variables>().generalVariables.soListMainIdData.soHandledBy.add(userHandled);
    }
    if (selectedForDeliveredItem.handledBy.isNotEmpty) {
      List<String> itemListHandledByCodeList =
          List.generate(selectedForDeliveredItem.handledBy.length, (i) => selectedForDeliveredItem.handledBy[i].code);
      if (itemListHandledByCodeList.contains(userHandled.code)) {
        selectedForDeliveredItem.handledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems =
            (num.parse(selectedForDeliveredItem.handledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems) +
                    num.parse(userHandled.updatedItems))
                .toString();
      } else {
        selectedForDeliveredItem.handledBy.clear();
        selectedForDeliveredItem.handledBy.add(userHandled);
      }
    } else {
      selectedForDeliveredItem.handledBy.add(userHandled);
    }
    selectedForDeliveredItem.lineLoadedQty = sum.toString();
    selectedForDeliveredItem.itemLoadedStatus = "Unavailable";
    selectedForDeliveredItem.isProgressStatus = true;
    selectedForDeliveredItem.itemLoadedUnavailableReasonId = selectedReason;
    selectedForDeliveredItem.itemLoadedUnavailableReason = selectedReasonName ?? "";
    selectedForDeliveredItem.itemLoadedUnavailableRemarks = commentText;
    getIt<Variables>().generalVariables.soListMainIdData.disputeStatus = true;
    getIt<Variables>().generalVariables.soListMainIdData.sessionInfo.isOpened = true;
    if (getIt<Variables>().generalVariables.soListMainIdData.sessionInfo.sessionStartTimestamp == "") {
      getIt<Variables>().generalVariables.soListMainIdData.sessionInfo.sessionStartTimestamp =
          (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    }
    Box<SoList> soListBox = Hive.box<SoList>('so_list_pickup');
    Box<ItemsList> itemsListBox = Hive.box<ItemsList>('items_list_pickup');
    Box<BatchesList> batchesListBox = Hive.box<BatchesList>('batches_list_pickup');
    for (int i = 0; i < selectedForDeliveredItem.itemBatchesList.length; i++) {
      int batchKey = batchesListBox.keys.firstWhere((k) =>
          batchesListBox.get(k)?.tripId == selectedForDeliveredItem.tripId &&
          batchesListBox.get(k)?.batchId == selectedForDeliveredItem.itemBatchesList[i].batchId);
      await batchesListBox.put(batchKey, selectedForDeliveredItem.itemBatchesList[i]);
    }
    int itemKey = itemsListBox.keys.firstWhere((k) =>
        itemsListBox.get(k)?.tripId == selectedForDeliveredItem.tripId && itemsListBox.get(k)?.lineItemId == selectedForDeliveredItem.lineItemId);
    await itemsListBox.put(itemKey, selectedForDeliveredItem);
    int soKey = soListBox.keys
        .firstWhere((k) => soListBox.get(k)?.tripId == selectedForDeliveredItem.tripId && soListBox.get(k)?.soId == selectedForDeliveredItem.soId);
    await soListBox.put(soKey, getIt<Variables>().generalVariables.soListMainIdData);
  }
}
