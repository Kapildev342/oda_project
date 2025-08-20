// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oda/local_database/pick_list_box/pick_list.dart';

// Project imports:
import 'package:oda/local_database/trip_box/trip_list.dart';
import 'package:oda/local_database/user_box/user.dart';
import 'package:oda/repository/api_end_points.dart';
import 'package:oda/repository_model/trip_list/trip_list_time_line_info_model.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';
import 'package:oda/resources/variables.dart';

part 'out_bound_detail_event.dart';
part 'out_bound_detail_state.dart';

class OutBoundDetailBloc extends Bloc<OutBoundDetailEvent, OutBoundDetailState> {
  bool searchBarEnabled = false;
  bool updateLoader = false;
  bool formatError = false;
  bool moreQuantityError = false;
  bool nonCheckError = false;
  bool allFieldsEmpty = false;
  String searchText = "";
  String commentText = "";
  String selectedTripListItemId = "";
  String selectedItemId = "";
  Map<String, dynamic> sortedQuantityData = {};
  List<String> sortedCatchWeightData = [];
  int pageIndex = 1;
  List<ItemsList> searchedItemsList = [];
  List<BatchesList> searchedBatchesList = [];
  List<ItemsList> singleTabItemsList = [];
  List<List<ItemsList>> singleTabGroupedItemsList = [];
  List<List<ItemsList>> singleTabGroupingItemsList = [];
  List<SoList> selectedSoList = [];
  Box<TripList> tripListBox = Hive.box<TripList>('trip_list');
  Box<SoList> soListBox = Hive.box<SoList>('so_list');
  Box<ItemsList> itemsListBox = Hive.box<ItemsList>('items_list');
  Box<BatchesList> batchesListBox = Hive.box<BatchesList>('batches_list');
  Box<PartialItemsList> partialItemsListBox = Hive.box<PartialItemsList>('partial_items_list');
  Box<LocalTempDataList> localTempDataList = Hive.box<LocalTempDataList>('local_temp_data_list_out_bound');
  int currentListIndex = 0;
  int tabIndex = 0;
  String tabName = "Pending";
  List<String> groupedKeepersNameList = [];
  bool selectedReasonEmpty = false;
  bool commentTextEmpty = false;
  String selectedReason = "";
  String? selectedReasonName;
  ItemsList selectedForSortedItem = ItemsList.fromJson({});
  SoList selectedForSortedSo = SoList.fromJson({});
  TripList selectedForSortedTrip = TripList.fromJson({});
  List<UnavailableReason> searchReasons=[];

  OutBoundDetailBloc() : super(OutBoundDetailLoading()) {
    on<OutBoundDetailInitialEvent>(outBoundDetailInitialFunction);
    on<OutBoundDetailTabChangingEvent>(outBoundDetailTabChangingFunction);
    on<OutBoundDetailSetStateEvent>(outBoundDetailSetStateFunction);
    on<OutBoundDetailFilterEvent>(outBoundDetailFilterFunction);
    on<OutBoundDetailSortedEvent>(outBoundDetailSortedFunction);
    on<OutBoundDetailUndoSortedEvent>(outBoundDetailUndoSortedFunction);
    on<OutBoundDetailUnavailableEvent>(outBoundDetailUnavailableFunction);
    on<OutBoundDetailSessionCloseEvent>(outBoundDetailSessionCloseFunction);
    on<OutBoundDetailTimeLineEvent>(outBoundDetailTimeLineFunction);
  }

  FutureOr<void> outBoundDetailInitialFunction(OutBoundDetailInitialEvent event, Emitter<OutBoundDetailState> emit) async {
    searchedItemsList.clear();
    singleTabItemsList.clear();
    singleTabGroupedItemsList.clear();
    singleTabGroupingItemsList.clear();
    searchBarEnabled = false;
    searchText = "";
    pageIndex = 1;
    currentListIndex = 0;
    tabIndex = 0;
    tabName = "Pending";
    searchedBatchesList.clear();
    getIt<Variables>().generalVariables.filters.clear();
    getIt<Variables>().generalVariables.selectedFilters.clear();
    getIt<Variables>().generalVariables.selectedFiltersName.clear();
    getIt<Variables>().generalVariables.filterSearchController.clear();
    getIt<Variables>().generalVariables.searchedResultFilterOption.clear();
    getIt<Variables>().generalVariables.filterSelectedMainIndex = 0;
    Box<UnavailableReason> unavailableReasonData = await Hive.openBox<UnavailableReason>('unavailable_reason');
    searchReasons = unavailableReasonData.values.toList();
    for (int i = 0; i < selectedSoList.length; i++) {
      searchedItemsList.addAll(itemsListBox.values.toList().where((element) => element.tripId == selectedSoList[i].tripId && element.soId == selectedSoList[i].soId).toList());
      searchedBatchesList.addAll(batchesListBox.values.toList().where((element) => element.tripId == selectedSoList[i].tripId && element.soId == selectedSoList[i].soId).toList());
    }
    Map<String, List<BatchesList>> groupedForBatchesList = groupBy(searchedBatchesList, (BatchesList item) => item.itemId);
    for (int i = 0; i < searchedItemsList.length; i++) {
      searchedItemsList[i].itemBatchesList.clear();
      searchedItemsList[i].itemBatchesList.addAll(groupedForBatchesList[searchedItemsList[i].lineItemId] ?? []);
    }
    for (int i = 0; i < searchedItemsList.length; i++) {
      if (searchedItemsList[i].itemLoadedStatus != "Partial") {
        partialItemsListBox.values.toList().removeWhere((element) => element.tripId == searchedItemsList[i].tripId && element.lineItemId == searchedItemsList[i].lineItemId);
      }
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
        "options": List.generate(searchedItemsList.length, (i) => {"id": searchedItemsList[i].itemCode, "label": searchedItemsList[i].itemCode}).map((map) => jsonEncode(map)).toSet().map((str) => jsonDecode(str)).toList()
      },
      {
        "type": "so_num",
        "label": getIt<Variables>().generalVariables.currentLanguage.soNum,
        "selection": "multiple",
        "get_options": false,
        "options": List.generate(selectedSoList.length, (i) => {"id": selectedSoList[i].soId, "label": selectedSoList[i].soNum}).map((map) => jsonEncode(map)).toSet().map((str) => jsonDecode(str)).toList()
      },
      {
        "type": "status",
        "label": getIt<Variables>().generalVariables.currentLanguage.status,
        "selection": "multiple",
        "get_options": false,
        "options": List.generate(searchedItemsList.length, (i) => {"id": searchedItemsList[i].itemLoadedStatus, "label": searchedItemsList[i].itemLoadedStatus}).map((map) => jsonEncode(map)).toSet().map((str) => jsonDecode(str)).toList()
      }
    ].map((x) => Filter.fromJson(x)));
    emit(OutBoundDetailLoading());
    emit(OutBoundDetailLoaded());
  }

  FutureOr<void> outBoundDetailTabChangingFunction(OutBoundDetailTabChangingEvent event, Emitter<OutBoundDetailState> emit) async {
    if (tabName == "Pending" || tabName == "Unavailable") {
      singleTabItemsList.clear();
      singleTabItemsList = searchedItemsList.where((element) => element.itemLoadedStatus == tabName).toList();
      Map<String, List<ItemsList>> grouped = groupBy(singleTabItemsList, (ItemsList item) => item.stagingArea);
      singleTabGroupedItemsList = grouped.values.toList();
      emit(OutBoundDetailLoading());
      emit(OutBoundDetailLoaded());
    } else {
      singleTabItemsList.clear();
      singleTabItemsList = searchedItemsList.where((element) => element.itemLoadedStatus == tabName).toList();
      List<ItemsList> itemsSortedList = singleTabItemsList.where((element) => !element.isProgressStatus).toList();
      Map<String, List<ItemsList>> grouped = groupBy(itemsSortedList, (ItemsList item) => item.stagingArea);
      singleTabGroupedItemsList = grouped.values.toList();
      List<ItemsList> itemSortingList = singleTabItemsList.where((element) => element.isProgressStatus).toList();
      Map<String, List<ItemsList>> groupedData = {};
      for (ItemsList item in itemSortingList) {
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
      emit(OutBoundDetailLoading());
      emit(OutBoundDetailLoaded());
    }
  }

  FutureOr<void> outBoundDetailSetStateFunction(OutBoundDetailSetStateEvent event, Emitter<OutBoundDetailState> emit) async {
    emit(OutBoundDetailDummy());
    event.stillLoading ? emit(OutBoundDetailLoading()) : emit(OutBoundDetailLoaded());
  }

  FutureOr<void> outBoundDetailFilterFunction(OutBoundDetailFilterEvent event, Emitter<OutBoundDetailState> emit) async {
    await filterItemFunction();
    emit(OutBoundDetailLoading());
    emit(OutBoundDetailLoaded());
  }

  FutureOr<void> outBoundDetailSortedFunction(OutBoundDetailSortedEvent event, Emitter<OutBoundDetailState> emit) async {
    String responseValue = await apiCalls(queryData: {
      "activity": "Loaded",
      "query_data": {
        "trip_id": getIt<Variables>().generalVariables.tripListMainIdData.tripId,
        "line_item_id": selectedForSortedItem.lineItemId,
        "item_id": selectedForSortedItem.itemId,
        "update_qty": sortedQuantityData,
        "catchweight_qty": sortedCatchWeightData.join(","),
        "timestamp": (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
        "online_mode": getIt<Variables>().generalVariables.isNetworkOffline == false,
      }
    }, controllersList: event.controllersList, sessionTime: "");
    await filterItemFunction();
    responseValue!=""?emit(OutBoundDetailError(message: responseValue)):emit(OutBoundDetailSuccess(message: getIt<Variables>().generalVariables.currentLanguage.loadedSuccessfully));
    emit(OutBoundDetailLoaded());
  }

  FutureOr<void> outBoundDetailUndoSortedFunction(OutBoundDetailUndoSortedEvent event, Emitter<OutBoundDetailState> emit) async {
    String responseValue = await apiCalls(queryData: {
      "activity": "undo",
      "query_data": {
        "trip_id": getIt<Variables>().generalVariables.tripListMainIdData.tripId,
        "line_item_id": selectedForSortedItem.lineItemId,
        "type": "Undo",
        "timestamp": (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
        "online_mode": getIt<Variables>().generalVariables.isNetworkOffline == false,
      }
    }, controllersList: [], sessionTime: "");
    await filterItemFunction();
    responseValue!=""?emit(OutBoundDetailError(message: responseValue)):emit(OutBoundDetailSuccess(message: getIt<Variables>().generalVariables.currentLanguage.undoSuccessfully));
    emit(OutBoundDetailLoaded());
  }

  FutureOr<void> outBoundDetailUnavailableFunction(OutBoundDetailUnavailableEvent event, Emitter<OutBoundDetailState> emit) async {
    String responseValue = await apiCalls(queryData: {
      "activity": "unavailable",
      "query_data": {
        "trip_id": getIt<Variables>().generalVariables.tripListMainIdData.tripId,
        "line_item_id": selectedForSortedItem.lineItemId,
        "remarks": commentText,
        "reason": selectedReason,
        "type": "Unavailable",
        "timestamp": (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
        "online_mode": getIt<Variables>().generalVariables.isNetworkOffline == false,
      }
    }, controllersList: [], sessionTime: "");
    await filterItemFunction();
    responseValue!=""?emit(OutBoundDetailError(message: responseValue)):emit(OutBoundDetailSuccess(message: getIt<Variables>().generalVariables.currentLanguage.movedUnavailableSuccessfully));
    emit(OutBoundDetailLoaded());
  }

  FutureOr<void> outBoundDetailSessionCloseFunction(OutBoundDetailSessionCloseEvent event, Emitter<OutBoundDetailState> emit) async {
    String sessionStartTime = "";
    sessionStartTime = selectedForSortedTrip.sessionInfo.sessionStartTimestamp;
   // if (sessionStartTime != "") {
      String responseValue = await apiCalls(queryData: {
        "activity": "session_close",
        "query_data": {
          "session_id": getIt<Variables>().generalVariables.tripListMainIdData.sessionInfo.id,
          "trip_id": getIt<Variables>().generalVariables.tripListMainIdData.tripId,
          "timestamp": (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
          "online_mode": getIt<Variables>().generalVariables.isNetworkOffline == false,
        }
      }, controllersList: [], sessionTime: sessionStartTime);
      await filterItemFunction();
      responseValue!=""?emit(OutBoundDetailError(message: responseValue)):emit(OutBoundDetailSuccess(message: getIt<Variables>().generalVariables.currentLanguage.itemsLoadedSuccesfully));
      emit(OutBoundDetailLoaded());
   /* } else {
      emit(OutBoundDetailError(message: getIt<Variables>().generalVariables.currentLanguage.sessionNotStarted));
      emit(OutBoundDetailLoaded());
    }*/
  }

  FutureOr<void> outBoundDetailTimeLineFunction(OutBoundDetailTimeLineEvent event, Emitter<OutBoundDetailState> emit) async {
    await getIt<Variables>().repoImpl.getSorterTripListTimeLineInfo(query: {"trip_id": getIt<Variables>().generalVariables.tripListMainIdData.tripId}, method: "post", module: ApiEndPoints().loaderModule).then((value) {
      if (value != null) {
        if (value["status"] == "1") {
          TripListTimeLineApiModel tripListTimeLineApiModel = TripListTimeLineApiModel.fromJson(value);
          getIt<Variables>().generalVariables.timelineInfo.clear();
          getIt<Variables>().generalVariables.timelineInfo.addAll(tripListTimeLineApiModel.response.timelineInfo);
          emit(const OutBoundDetailFailure(message: ""));
          emit(OutBoundDetailLoaded());
        }
      }
    });
  }

  sortedItemFunction({required List<String> controllersList}) async {
    selectedForSortedSo = soListBox.values.toList().singleWhere((element) => element.tripId == selectedForSortedItem.tripId && element.soId == selectedForSortedItem.soId);
    selectedForSortedTrip = tripListBox.values.toList().singleWhere((element) => element.tripId == selectedForSortedItem.tripId);
    String userCode = getIt<Variables>().generalVariables.userDataEmployeeCode;
    List<FilterOptionsResponse> usersList = getIt<Variables>().generalVariables.userData.usersList;
    HandledByForUpdateList userHandled = HandledByForUpdateList.fromJson(usersList.singleWhere((user) => user.code == userCode).toJson());
    num sum = 0;
    if (selectedForSortedItem.catchWeightStatus != "No") {
      selectedForSortedItem.itemLoadedCatchWeightInfo = sortedCatchWeightData.join(",");
      for (int i = 0; i < sortedCatchWeightData.length; i++) {
        sum = sum + num.parse(sortedCatchWeightData[i]);
      }
      userHandled.updatedItems = sum.toString();
      if (selectedForSortedTrip.tripHandledBy.isNotEmpty) {
        List<String> tripListHandledByCodeList = List.generate(selectedForSortedTrip.tripHandledBy.length, (i) => selectedForSortedTrip.tripHandledBy[i].code);
        if (tripListHandledByCodeList.contains(userHandled.code)) {
          selectedForSortedTrip.tripHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems =
              (num.parse(selectedForSortedTrip.tripHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems) + num.parse(userHandled.updatedItems)).toString();
        } else {
          selectedForSortedTrip.tripHandledBy.clear();
          selectedForSortedTrip.tripHandledBy.add(userHandled);
        }
      } else {
        selectedForSortedTrip.tripHandledBy.add(userHandled);
      }
      if (selectedForSortedSo.soHandledBy.isNotEmpty) {
        List<String> soListHandledByCodeList = List.generate(selectedForSortedSo.soHandledBy.length, (i) => selectedForSortedSo.soHandledBy[i].code);
        if (soListHandledByCodeList.contains(userHandled.code)) {
          selectedForSortedSo.soHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems =
              (num.parse(selectedForSortedSo.soHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems) + num.parse(userHandled.updatedItems)).toString();
        } else {
          selectedForSortedSo.soHandledBy.clear();
          selectedForSortedSo.soHandledBy.add(userHandled);
        }
      } else {
        selectedForSortedSo.soHandledBy.add(userHandled);
      }
      if (selectedForSortedItem.handledBy.isNotEmpty) {
        List<String> itemListHandledByCodeList = List.generate(selectedForSortedItem.handledBy.length, (i) => selectedForSortedItem.handledBy[i].code);
        if (itemListHandledByCodeList.contains(userHandled.code)) {
          selectedForSortedItem.handledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems =
              (num.parse(selectedForSortedItem.handledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems) + num.parse(userHandled.updatedItems)).toString();
        } else {
          selectedForSortedItem.handledBy.clear();
          selectedForSortedItem.handledBy.add(userHandled);
        }
      } else {
        selectedForSortedItem.handledBy.add(userHandled);
      }
      num initialSum = 0;
      for (int i = 0; i < getIt<Functions>().getStringToCatchWeight(value: selectedForSortedItem.catchWeightInfo).length; i++) {
        initialSum = initialSum + num.parse(getIt<Functions>().getStringToCatchWeight(value: selectedForSortedItem.catchWeightInfo)[i].data);
      }
      selectedForSortedItem.itemLoadedStatus = initialSum == sum ? "Loaded" : "Partial";
      selectedForSortedItem.isProgressStatus = true;
      selectedForSortedItem.lineLoadedQty = (num.parse(selectedForSortedItem.lineLoadedQty) + sum).toString();
      //So item count & status Updates
      List<ItemsList> sortedItemsList = searchedItemsList.where((element) => element.itemLoadedStatus == "Loaded" || element.itemLoadedStatus == "Partial").toList();
      Map<String, List<ItemsList>> groupedForSortedItemsList = groupBy(sortedItemsList, (ItemsList item) => item.soId);
      int sortedCount = 0;
      for (int i = 0; i < selectedSoList.length; i++) {
        if (selectedSoList[i].soId == selectedForSortedItem.soId) {
          sortedCount = (groupedForSortedItemsList[selectedSoList[i].soId] ?? []).length;
          selectedForSortedSo.soNoOfLoadedItems = sortedCount.toString();
          if (selectedForSortedSo.soNoOfLoadedItems == selectedForSortedSo.soNoOfItems) {
            selectedForSortedSo.soStatus = "Loaded";
          } else {
            selectedForSortedSo.soStatus = "Pending";
          }
        } else {
          selectedSoList[i].soNoOfLoadedItems = (groupedForSortedItemsList[selectedSoList[i].soId] ?? []).length.toString();
          if (selectedSoList[i].soNoOfLoadedItems == selectedSoList[i].soNoOfItems) {
            selectedSoList[i].soStatus = "Loaded";
          } else {
            selectedSoList[i].soStatus = "Pending";
          }
        }
      }
      /* else if (selectedForSortedSo.soNoOfLoadedItems == "0") {
        selectedForSortedSo.soStatus = "Pending";
      } else {
        selectedForSortedSo.soStatus = "Partial";
      }*/
      //Trip
      /*List<SoList> certainSoList = soListBox.values.toList().where((element) => element.tripId == selectedForSortedItem.tripId).toList();
      List<String> soStatusList = List<String>.generate(certainSoList.length, (i) => certainSoList[i].soStatus);

      if (soStatusList.contains("Pending")) {
        if (soStatusList.contains("Loaded")) {
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "C38C19";
          selectedForSortedTrip.tripStatusBackGroundColor = "E0D4BA";
        } else {
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "DC474A";
          selectedForSortedTrip.tripStatusBackGroundColor = "FFCCCF";
        }
      } else {
        selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase();
        getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase();
        selectedForSortedTrip.tripStatusColor = "007838";
        selectedForSortedTrip.tripStatusBackGroundColor = "C9F2DC";
      }*/
      List<ItemsList> certainItemsList = itemsListBox.values.toList().where((element)=>element.tripId==getIt<Variables>().generalVariables.tripListMainIdData.tripId).toList();
      List<String> itemsStatusList = List<String>.generate(certainItemsList.length, (i) => certainItemsList[i].itemLoadedStatus);
      if(itemsStatusList.contains("Partial")){
        selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
        getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
        selectedForSortedTrip.tripStatusColor = "72492B";
        selectedForSortedTrip.tripStatusBackGroundColor = "FFDDC5";
      } else if (itemsStatusList.contains("Pending")) {
        if (itemsStatusList.contains("Loaded")) {
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "72492B";
          selectedForSortedTrip.tripStatusBackGroundColor = "FFDDC5";
        } else {
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "DC474A";
          selectedForSortedTrip.tripStatusBackGroundColor = "FFCCCF";
        }
      } else if(itemsStatusList.contains("Loaded")) {
        if(itemsStatusList.contains("Unavailable")){
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "72492B";
          selectedForSortedTrip.tripStatusBackGroundColor = "FFDDC5";
        }else{
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "007838";
          selectedForSortedTrip.tripStatusBackGroundColor = "C9F2DC";
        }
      }
      selectedForSortedTrip.sessionInfo.isOpened = true;
      if (selectedForSortedTrip.sessionInfo.sessionStartTimestamp == "") {
        selectedForSortedTrip.sessionInfo.sessionStartTimestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      }
    } else {
      for (int i = 0; i < controllersList.length; i++) {
        if (controllersList[i] != "" && controllersList[i] != ".") {
          if (num.parse(controllersList[i]) != 0) {
            if (num.parse(controllersList[i]) <= num.parse(selectedForSortedItem.itemBatchesList[i].quantity)) {
              selectedForSortedItem.itemBatchesList[i].batchLoadedQty = (num.parse(selectedForSortedItem.itemBatchesList[i].batchLoadedQty == "" ? "0" : selectedForSortedItem.itemBatchesList[i].batchLoadedQty) + num.parse(controllersList[i])).toString();
              sum = sum + num.parse(controllersList[i]);
            }
          }
        }
      }
      userHandled.updatedItems = sum.toString();
      if (selectedForSortedTrip.tripHandledBy.isNotEmpty) {
        List<String> tripListHandledByCodeList = List.generate(selectedForSortedTrip.tripHandledBy.length, (i) => selectedForSortedTrip.tripHandledBy[i].code);
        if (tripListHandledByCodeList.contains(userHandled.code)) {
          selectedForSortedTrip.tripHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems =
              (num.parse(selectedForSortedTrip.tripHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems) + num.parse(userHandled.updatedItems)).toString();
        } else {
          selectedForSortedTrip.tripHandledBy.clear();
          selectedForSortedTrip.tripHandledBy.add(userHandled);
        }
      } else {
        selectedForSortedTrip.tripHandledBy.add(userHandled);
      }
      if (selectedForSortedSo.soHandledBy.isNotEmpty) {
        List<String> soListHandledByCodeList = List.generate(selectedForSortedSo.soHandledBy.length, (i) => selectedForSortedSo.soHandledBy[i].code);
        if (soListHandledByCodeList.contains(userHandled.code)) {
          selectedForSortedSo.soHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems =
              (num.parse(selectedForSortedSo.soHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems) + num.parse(userHandled.updatedItems)).toString();
        } else {
          selectedForSortedSo.soHandledBy.clear();
          selectedForSortedSo.soHandledBy.add(userHandled);
        }
      } else {
        selectedForSortedSo.soHandledBy.add(userHandled);
      }
      if (selectedForSortedItem.handledBy.isNotEmpty) {
        List<String> itemListHandledByCodeList = List.generate(selectedForSortedItem.handledBy.length, (i) => selectedForSortedItem.handledBy[i].code);
        if (itemListHandledByCodeList.contains(userHandled.code)) {
          selectedForSortedItem.handledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems =
              (num.parse(selectedForSortedItem.handledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems) + num.parse(userHandled.updatedItems)).toString();
        } else {
          selectedForSortedItem.handledBy.clear();
          selectedForSortedItem.handledBy.add(userHandled);
        }
      } else {
        selectedForSortedItem.handledBy.add(userHandled);
      }
      selectedForSortedItem.isProgressStatus = true;
      selectedForSortedItem.lineLoadedQty = (num.parse(selectedForSortedItem.lineLoadedQty) + sum).toString();
      selectedForSortedItem.itemLoadedStatus = num.parse(selectedForSortedItem.quantity) == num.parse(selectedForSortedItem.lineLoadedQty) ? "Loaded" : "Partial";
      //So item count & status Updates
      List<ItemsList> sortedItemsList = searchedItemsList.where((element) => element.itemLoadedStatus == "Loaded" || element.itemLoadedStatus == "Partial").toList();
      Map<String, List<ItemsList>> groupedForSortedItemsList = groupBy(sortedItemsList, (ItemsList item) => item.soId);
      int sortedCount = 0;
      for (int i = 0; i < selectedSoList.length; i++) {
        if (selectedSoList[i].soId == selectedForSortedItem.soId) {
          sortedCount = (groupedForSortedItemsList[selectedSoList[i].soId] ?? []).length;
        } else {
          selectedSoList[i].soNoOfLoadedItems = (groupedForSortedItemsList[selectedSoList[i].soId] ?? []).length.toString();
          if (selectedSoList[i].soNoOfLoadedItems == selectedSoList[i].soNoOfItems) {
            selectedSoList[i].soStatus = "Loaded";
          } else {
            selectedSoList[i].soStatus = "Pending";
          }
        }
      }
      selectedForSortedSo.soNoOfLoadedItems = sortedCount.toString();
      if (selectedForSortedSo.soNoOfLoadedItems == selectedForSortedSo.soNoOfItems) {
        selectedForSortedSo.soStatus = "Loaded";
      } else {
        selectedForSortedSo.soStatus = "Pending";
      }
      //Trip
      /*List<SoList> certainSoList = soListBox.values.toList().where((element) => element.tripId == selectedForSortedItem.tripId).toList();
      List<String> soStatusList = List<String>.generate(certainSoList.length, (i) => certainSoList[i].soStatus);

      if (soStatusList.contains("Pending")) {
        if (soStatusList.contains("Loaded")) {
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "C38C19";
          selectedForSortedTrip.tripStatusBackGroundColor = "E0D4BA";
        } else {
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "DC474A";
          selectedForSortedTrip.tripStatusBackGroundColor = "FFCCCF";
        }
      } else {
        selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase();
        getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase();
        selectedForSortedTrip.tripStatusColor = "007838";
        selectedForSortedTrip.tripStatusBackGroundColor = "C9F2DC";
      }*/
      List<ItemsList> certainItemsList = itemsListBox.values.toList().where((element)=>element.tripId==getIt<Variables>().generalVariables.tripListMainIdData.tripId).toList();
      List<String> itemsStatusList = List<String>.generate(certainItemsList.length, (i) => certainItemsList[i].itemLoadedStatus);
      if(itemsStatusList.contains("Partial")){
        selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
        getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
        selectedForSortedTrip.tripStatusColor = "72492B";
        selectedForSortedTrip.tripStatusBackGroundColor = "FFDDC5";
      } else if (itemsStatusList.contains("Pending")) {
        if (itemsStatusList.contains("Loaded")) {
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "72492B";
          selectedForSortedTrip.tripStatusBackGroundColor = "FFDDC5";
        } else {
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "DC474A";
          selectedForSortedTrip.tripStatusBackGroundColor = "FFCCCF";
        }
      } else if(itemsStatusList.contains("Loaded")) {
        if(itemsStatusList.contains("Unavailable")){
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "72492B";
          selectedForSortedTrip.tripStatusBackGroundColor = "FFDDC5";
        }else{
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "007838";
          selectedForSortedTrip.tripStatusBackGroundColor = "C9F2DC";
        }
      }
      selectedForSortedTrip.sessionInfo.isOpened = true;
      if (selectedForSortedTrip.sessionInfo.sessionStartTimestamp == "") {
        selectedForSortedTrip.sessionInfo.sessionStartTimestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      }
    }
    for (int i = 0; i < selectedForSortedItem.itemBatchesList.length; i++) {
      int batchKey = batchesListBox.keys.firstWhere((k) => batchesListBox.get(k)?.tripId == selectedForSortedItem.tripId && batchesListBox.get(k)?.batchId == selectedForSortedItem.itemBatchesList[i].batchId);
      await batchesListBox.put(batchKey, selectedForSortedItem.itemBatchesList[i]);
    }
    int itemKey = itemsListBox.keys.firstWhere((k) => itemsListBox.get(k)?.tripId == selectedForSortedItem.tripId && itemsListBox.get(k)?.lineItemId == selectedForSortedItem.lineItemId);
    await itemsListBox.put(itemKey, selectedForSortedItem);
    int soKey = soListBox.keys.firstWhere((k) => soListBox.get(k)?.tripId == selectedForSortedItem.tripId && soListBox.get(k)?.soId == selectedForSortedItem.soId);
    await soListBox.put(soKey, selectedForSortedSo);
    int tripKey = tripListBox.keys.firstWhere((k) => tripListBox.get(k)?.tripId == selectedForSortedItem.tripId);
    await tripListBox.put(tripKey, selectedForSortedTrip);
  }

  undoSortedItemFunction() async {
    selectedForSortedSo = soListBox.values.toList().singleWhere((element) => element.tripId == selectedForSortedItem.tripId && element.soId == selectedForSortedItem.soId);
    selectedForSortedTrip = tripListBox.values.toList().singleWhere((element) => element.tripId == selectedForSortedItem.tripId);
    String userCode = getIt<Variables>().generalVariables.userDataEmployeeCode;
    List<FilterOptionsResponse> usersList = getIt<Variables>().generalVariables.userData.usersList;
    HandledByForUpdateList userHandled = HandledByForUpdateList.fromJson(usersList.singleWhere((user) => user.code == userCode).toJson());
    num sum = 0;
    if (selectedForSortedItem.catchWeightStatus != "No") {
      for (int i = 0; i < sortedCatchWeightData.length; i++) {
        sum = sum + num.parse(sortedCatchWeightData[i]);
      }
      userHandled.updatedItems = sum.toString();
      for (int i = 0; i < selectedForSortedTrip.tripHandledBy.length; i++) {
        if (selectedForSortedTrip.tripHandledBy[i].code == userHandled.code) {
          selectedForSortedTrip.tripHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems =
              (num.parse(selectedForSortedTrip.tripHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems) - num.parse(userHandled.updatedItems)).toString();
          if (num.parse(selectedForSortedTrip.tripHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems) == 0) {
            selectedForSortedTrip.tripHandledBy.removeAt(i);
          }
          break;
        }
      }
      for (int i = 0; i < selectedForSortedSo.soHandledBy.length; i++) {
        if (selectedForSortedSo.soHandledBy[i].code == userHandled.code) {
          selectedForSortedSo.soHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems =
              (num.parse(selectedForSortedSo.soHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems) - num.parse(userHandled.updatedItems)).toString();
          if (num.parse(selectedForSortedSo.soHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems) == 0) {
            selectedForSortedSo.soHandledBy.removeAt(i);
          }
          break;
        }
      }
      for (int i = 0; i < selectedForSortedItem.handledBy.length; i++) {
        if (selectedForSortedItem.handledBy[i].code == userHandled.code) {
          selectedForSortedItem.handledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems =
              (num.parse(selectedForSortedItem.handledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems) - num.parse(userHandled.updatedItems)).toString();
          if (num.parse(selectedForSortedItem.handledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems) == 0) {
            selectedForSortedItem.handledBy.removeAt(i);
          }
          break;
        }
      }
      if (selectedForSortedItem.itemLoadedStatus == "Partial") {
        List<String> partialItemsIdsList = List.generate(
            tripListBox.values.toList().firstWhere((element) => element.tripId == getIt<Variables>().generalVariables.tripListMainIdData.tripId).partialItemsList.length,
                (i) => tripListBox.values
                .toList()
                .firstWhere((element) => element.tripId == getIt<Variables>().generalVariables.tripListMainIdData.tripId)
                .partialItemsList[i]

            ///
                .lineItemId);

        ///
        if (partialItemsIdsList.contains(selectedForSortedItem.lineItemId)) {
          selectedForSortedItem = tripListBox.values
              .toList()
              .firstWhere((element) => element.tripId == getIt<Variables>().generalVariables.tripListMainIdData.tripId)
              .partialItemsList

          ///
              .singleWhere((element) => element.lineItemId == selectedForSortedItem.lineItemId);
        } else {
          selectedForSortedItem.itemLoadedCatchWeightInfo = "";
          selectedForSortedItem.itemLoadedStatus = "Pending";
          selectedForSortedItem.isProgressStatus = false;
          selectedForSortedItem.lineLoadedQty = "0";
        }
      }
      else if (selectedForSortedItem.itemLoadedStatus == "Loaded") {
        List<String> partialItemsIdsList = List.generate(
            tripListBox.values.toList().firstWhere((element) => element.tripId == getIt<Variables>().generalVariables.tripListMainIdData.tripId).partialItemsList.length,
                (i) => tripListBox.values
                .toList()
                .firstWhere((element) => element.tripId == getIt<Variables>().generalVariables.tripListMainIdData.tripId)
                .partialItemsList[i]

            ///
                .lineItemId);

        ///
        if (partialItemsIdsList.contains(selectedForSortedItem.lineItemId)) {
          selectedForSortedItem = tripListBox.values
              .toList()
              .firstWhere((element) => element.tripId == getIt<Variables>().generalVariables.tripListMainIdData.tripId)
              .partialItemsList

          ///
              .singleWhere((element) => element.lineItemId == selectedForSortedItem.lineItemId);
        } else {
          selectedForSortedItem.itemLoadedCatchWeightInfo = "";
          selectedForSortedItem.itemLoadedStatus = "Pending";
          selectedForSortedItem.isProgressStatus = false;
          selectedForSortedItem.lineLoadedQty = "0";
        }
      }
      else {
        selectedForSortedItem.itemLoadedCatchWeightInfo = "";
        selectedForSortedItem.itemLoadedStatus = "Pending";
        selectedForSortedItem.isProgressStatus = false;
        selectedForSortedItem.lineLoadedQty = "0";
      }
      //So item count & status Updates
      List<ItemsList> sortedItemsList = searchedItemsList.where((element) => element.itemLoadedStatus == "Loaded" || element.itemLoadedStatus == "Partial").toList();
      Map<String, List<ItemsList>> groupedForSortedItemsList = groupBy(sortedItemsList, (ItemsList item) => item.soId);
      int sortedCount = 0;
      for (int i = 0; i < selectedSoList.length; i++) {
        if (selectedSoList[i].soId == selectedForSortedItem.soId) {
          sortedCount = (groupedForSortedItemsList[selectedSoList[i].soId] ?? []).length;
          selectedForSortedSo.soNoOfLoadedItems = sortedCount.toString();
          if (selectedForSortedSo.soNoOfLoadedItems == selectedForSortedSo.soNoOfItems) {
            selectedForSortedSo.soStatus = "Loaded";
          } else {
            selectedForSortedSo.soStatus = "Pending";
          }
        } else {
          selectedSoList[i].soNoOfLoadedItems = sortedCount.toString();
          if (selectedSoList[i].soNoOfLoadedItems == selectedSoList[i].soNoOfItems) {
            selectedSoList[i].soStatus = "Loaded";
          } else {
            selectedSoList[i].soStatus = "Pending";
          }
        }
      }
      //Trip
     /* List<SoList> certainSoList = soListBox.values.toList().where((element) => element.tripId == selectedForSortedItem.tripId).toList();
      List<String> soStatusList = List<String>.generate(certainSoList.length, (i) => certainSoList[i].soStatus);

      if (soStatusList.contains("Pending")) {
        if (soStatusList.contains("Loaded")) {
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "C38C19";
          selectedForSortedTrip.tripStatusBackGroundColor = "E0D4BA";
        } else {
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "DC474A";
          selectedForSortedTrip.tripStatusBackGroundColor = "FFCCCF";
        }
      } else {
        selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase();
        getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase();
        selectedForSortedTrip.tripStatusColor = "007838";
        selectedForSortedTrip.tripStatusBackGroundColor = "C9F2DC";
      }*/
      List<ItemsList> certainItemsList = itemsListBox.values.toList().where((element)=>element.tripId==getIt<Variables>().generalVariables.tripListMainIdData.tripId).toList();
      List<String> itemsStatusList = List<String>.generate(certainItemsList.length, (i) => certainItemsList[i].itemLoadedStatus);
      if(itemsStatusList.contains("Partial")){
        selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
        getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
        selectedForSortedTrip.tripStatusColor = "72492B";
        selectedForSortedTrip.tripStatusBackGroundColor = "FFDDC5";
      } else if (itemsStatusList.contains("Pending")) {
        if (itemsStatusList.contains("Loaded")) {
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "72492B";
          selectedForSortedTrip.tripStatusBackGroundColor = "FFDDC5";
        } else {
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "DC474A";
          selectedForSortedTrip.tripStatusBackGroundColor = "FFCCCF";
        }
      } else if(itemsStatusList.contains("Loaded")) {
        if(itemsStatusList.contains("Unavailable")){
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "72492B";
          selectedForSortedTrip.tripStatusBackGroundColor = "FFDDC5";
        }else{
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "007838";
          selectedForSortedTrip.tripStatusBackGroundColor = "C9F2DC";
        }
      }
      selectedForSortedTrip.sessionInfo.isOpened = true;
      if (selectedForSortedTrip.sessionInfo.sessionStartTimestamp == "") {
        selectedForSortedTrip.sessionInfo.sessionStartTimestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      }
    } else {
      for (int i = 0; i < selectedForSortedItem.itemBatchesList.length; i++) {
        sum = sum + num.parse(selectedForSortedItem.itemBatchesList[i].batchLoadedQty == "" ? "0" : selectedForSortedItem.itemBatchesList[i].batchLoadedQty);
      }
      userHandled.updatedItems = sum.toString();
      for (int i = 0; i < selectedForSortedTrip.tripHandledBy.length; i++) {
        if (selectedForSortedTrip.tripHandledBy[i].code == userHandled.code) {
          selectedForSortedTrip.tripHandledBy[i].updatedItems = (num.parse(selectedForSortedTrip.tripHandledBy[i].updatedItems) - num.parse(userHandled.updatedItems)).toString();
          if (num.parse(selectedForSortedTrip.tripHandledBy[i].updatedItems) == 0) {
            selectedForSortedTrip.tripHandledBy.removeAt(i);
          }
          break;
        }
      }
      for (int i = 0; i < selectedForSortedSo.soHandledBy.length; i++) {
        if (selectedForSortedSo.soHandledBy[i].code == userHandled.code) {
          selectedForSortedSo.soHandledBy[i].updatedItems = (num.parse(selectedForSortedSo.soHandledBy[i].updatedItems) - num.parse(userHandled.updatedItems)).toString();
          if (num.parse(selectedForSortedSo.soHandledBy[i].updatedItems) == 0) {
            selectedForSortedSo.soHandledBy.removeAt(i);
          }
          break;
        }
      }
      for (int i = 0; i < selectedForSortedItem.handledBy.length; i++) {
        if (selectedForSortedItem.handledBy[i].code == userHandled.code) {
          selectedForSortedItem.handledBy[i].updatedItems = (num.parse(selectedForSortedItem.handledBy[i].updatedItems) - num.parse(userHandled.updatedItems)).toString();
          if (num.parse(selectedForSortedItem.handledBy[i].updatedItems) == 0) {
            selectedForSortedItem.handledBy.removeAt(i);
          }
          break;
        }
      }
      if (selectedForSortedItem.itemLoadedStatus == "Partial") {
        List<String> partialItemsIdsList =

        ///
        List.generate(partialItemsListBox.values.toList().length, (i) => partialItemsListBox.values.toList()[i].lineItemId);

        ///
        if (partialItemsIdsList.contains(selectedForSortedItem.lineItemId)) {
          selectedForSortedItem =

          ///
          ItemsList.fromJson(partialItemsListBox.values.toList().firstWhere((element) => element.lineItemId == selectedForSortedItem.lineItemId).toJson());
        } else {
          for (int i = 0; i < selectedForSortedItem.itemBatchesList.length; i++) {
            selectedForSortedItem.itemBatchesList[i].batchLoadedQty = "0";
          }
          selectedForSortedItem.itemLoadedStatus = "Pending";
          selectedForSortedItem.isProgressStatus = false;
          selectedForSortedItem.lineLoadedQty = "0";
        }
      }
      else if (selectedForSortedItem.itemLoadedStatus == "Loaded") {
        List<String> partialItemsIdsList = List.generate(partialItemsListBox.values.toList().length, (i) => partialItemsListBox.values.toList()[i].lineItemId);
        if (partialItemsIdsList.contains(selectedForSortedItem.lineItemId)) {
          selectedForSortedItem = ItemsList.fromJson(partialItemsListBox.values.toList().firstWhere((element) => element.lineItemId == selectedForSortedItem.lineItemId).toJson());
        } else {
          for (int i = 0; i < selectedForSortedItem.itemBatchesList.length; i++) {
            selectedForSortedItem.itemBatchesList[i].batchLoadedQty = "0";
          }
          selectedForSortedItem.itemLoadedStatus = "Pending";
          selectedForSortedItem.isProgressStatus = false;
          selectedForSortedItem.lineLoadedQty = "0";
        }
      }
      else {
        for (int i = 0; i < selectedForSortedItem.itemBatchesList.length; i++) {
          selectedForSortedItem.itemBatchesList[i].batchLoadedQty = "0";
        }
        selectedForSortedItem.itemLoadedStatus = "Pending";
        selectedForSortedItem.isProgressStatus = false;
        selectedForSortedItem.lineLoadedQty = "0";
      }
      //So item count & status Updates
      List<ItemsList> sortedItemsList = searchedItemsList.where((element) => element.itemLoadedStatus == "Loaded" || element.itemLoadedStatus == "Partial").toList();
      Map<String, List<ItemsList>> groupedForSortedItemsList = groupBy(sortedItemsList, (ItemsList item) => item.soId);
      int sortedCount = 0;
      for (int i = 0; i < selectedSoList.length; i++) {
        if (selectedSoList[i].soId == selectedForSortedItem.soId) {
          sortedCount = (groupedForSortedItemsList[selectedSoList[i].soId] ?? []).length;
          selectedForSortedSo.soNoOfLoadedItems = sortedCount.toString();
          if (selectedForSortedSo.soNoOfLoadedItems == selectedForSortedSo.soNoOfItems) {
            selectedForSortedSo.soStatus = "Loaded";
          } else {
            selectedForSortedSo.soStatus = "Pending";
          }
        } else {
          selectedSoList[i].soNoOfLoadedItems = sortedCount.toString();
          if (selectedSoList[i].soNoOfLoadedItems == selectedSoList[i].soNoOfItems) {
            selectedSoList[i].soStatus = "Loaded";
          } else {
            selectedSoList[i].soStatus = "Pending";
          }
        }
      }
      //Trip
      /*List<SoList> certainSoList = soListBox.values.toList().where((element) => element.tripId == selectedForSortedItem.tripId).toList();
      List<String> soStatusList = List<String>.generate(certainSoList.length, (i) => certainSoList[i].soStatus);

      if (soStatusList.contains("Pending")) {
        if (soStatusList.contains("Loaded")) {
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "C38C19";
          selectedForSortedTrip.tripStatusBackGroundColor = "E0D4BA";
        } else {
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "DC474A";
          selectedForSortedTrip.tripStatusBackGroundColor = "FFCCCF";
        }
      } else {
        selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase();
        getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase();
        selectedForSortedTrip.tripStatusColor = "007838";
        selectedForSortedTrip.tripStatusBackGroundColor = "C9F2DC";
      }*/
      List<ItemsList> certainItemsList = itemsListBox.values.toList().where((element)=>element.tripId==getIt<Variables>().generalVariables.tripListMainIdData.tripId).toList();
      List<String> itemsStatusList = List<String>.generate(certainItemsList.length, (i) => certainItemsList[i].itemLoadedStatus);
      if(itemsStatusList.contains("Partial")){
        selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
        getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
        selectedForSortedTrip.tripStatusColor = "72492B";
        selectedForSortedTrip.tripStatusBackGroundColor = "FFDDC5";
      } else if (itemsStatusList.contains("Pending")) {
        if (itemsStatusList.contains("Loaded")) {
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "72492B";
          selectedForSortedTrip.tripStatusBackGroundColor = "FFDDC5";
        } else {
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "DC474A";
          selectedForSortedTrip.tripStatusBackGroundColor = "FFCCCF";
        }
      } else if(itemsStatusList.contains("Loaded")) {
        if(itemsStatusList.contains("Unavailable")){
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "72492B";
          selectedForSortedTrip.tripStatusBackGroundColor = "FFDDC5";
        }else{
          selectedForSortedTrip.tripStatus = getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase();
          getIt<Variables>().generalVariables.tripListMainIdData.tripStatus = getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase();
          selectedForSortedTrip.tripStatusColor = "007838";
          selectedForSortedTrip.tripStatusBackGroundColor = "C9F2DC";
        }
      }
      selectedForSortedTrip.sessionInfo.isOpened = true;
      if (selectedForSortedTrip.sessionInfo.sessionStartTimestamp == "") {
        selectedForSortedTrip.sessionInfo.sessionStartTimestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      }
    }
    for (int i = 0; i < selectedForSortedItem.itemBatchesList.length; i++) {
      int batchKey = batchesListBox.keys.firstWhere((k) => batchesListBox.get(k)?.tripId == selectedForSortedItem.tripId && batchesListBox.get(k)?.batchId == selectedForSortedItem.itemBatchesList[i].batchId);
      await batchesListBox.put(batchKey, selectedForSortedItem.itemBatchesList[i]);
    }
    int itemKey = itemsListBox.keys.firstWhere((k) => itemsListBox.get(k)?.tripId == selectedForSortedItem.tripId && itemsListBox.get(k)?.lineItemId == selectedForSortedItem.lineItemId);
    await itemsListBox.put(itemKey, selectedForSortedItem);
    int soKey = soListBox.keys.firstWhere((k) => soListBox.get(k)?.tripId == selectedForSortedItem.tripId && soListBox.get(k)?.soId == selectedForSortedItem.soId);
    await soListBox.put(soKey, selectedForSortedSo);
    int tripKey = tripListBox.keys.firstWhere((k) => tripListBox.get(k)?.tripId == selectedForSortedItem.tripId);
    await tripListBox.put(tripKey, selectedForSortedTrip);
  }

  unavailableItemFunction() async {
    num sum = 0;
    selectedForSortedSo = soListBox.values.toList().singleWhere((element) => element.tripId == selectedForSortedItem.tripId && element.soId == selectedForSortedItem.soId);
    selectedForSortedTrip = tripListBox.values.toList().singleWhere((element) => element.tripId == selectedForSortedItem.tripId);
    String userCode = getIt<Variables>().generalVariables.userDataEmployeeCode;
    List<FilterOptionsResponse> usersList = getIt<Variables>().generalVariables.userData.usersList;
    HandledByForUpdateList userHandled = HandledByForUpdateList.fromJson(usersList.singleWhere((user) => user.code == userCode).toJson());
    userHandled.updatedItems = sum.toString();
    if (selectedForSortedTrip.tripHandledBy.isNotEmpty) {
      List<String> tripListHandledByCodeList = List.generate(selectedForSortedTrip.tripHandledBy.length, (i) => selectedForSortedTrip.tripHandledBy[i].code);
      if (tripListHandledByCodeList.contains(userHandled.code)) {
        selectedForSortedTrip.tripHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems =
            (num.parse(selectedForSortedTrip.tripHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems) + num.parse(userHandled.updatedItems)).toString();
      } else {
        selectedForSortedTrip.tripHandledBy.clear();
        selectedForSortedTrip.tripHandledBy.add(userHandled);
      }
    } else {
      selectedForSortedTrip.tripHandledBy.add(userHandled);
    }
    if (selectedForSortedSo.soHandledBy.isNotEmpty) {
      List<String> soListHandledByCodeList = List.generate(selectedForSortedSo.soHandledBy.length, (i) => selectedForSortedSo.soHandledBy[i].code);
      if (soListHandledByCodeList.contains(userHandled.code)) {
        selectedForSortedSo.soHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems =
            (num.parse(selectedForSortedSo.soHandledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems) + num.parse(userHandled.updatedItems)).toString();
      } else {
        selectedForSortedSo.soHandledBy.clear();
        selectedForSortedSo.soHandledBy.add(userHandled);
      }
    } else {
      selectedForSortedSo.soHandledBy.add(userHandled);
    }
    if (selectedForSortedItem.handledBy.isNotEmpty) {
      List<String> itemListHandledByCodeList = List.generate(selectedForSortedItem.handledBy.length, (i) => selectedForSortedItem.handledBy[i].code);
      if (itemListHandledByCodeList.contains(userHandled.code)) {
        selectedForSortedItem.handledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems =
            (num.parse(selectedForSortedItem.handledBy.singleWhere((handled) => handled.code == userHandled.code).updatedItems) + num.parse(userHandled.updatedItems)).toString();
      } else {
        selectedForSortedItem.handledBy.clear();
        selectedForSortedItem.handledBy.add(userHandled);
      }
    } else {
      selectedForSortedItem.handledBy.add(userHandled);
    }
    selectedForSortedItem.lineLoadedQty = sum.toString();
    selectedForSortedItem.itemLoadedStatus = "Unavailable";
    selectedForSortedItem.isProgressStatus = true;
    selectedForSortedItem.itemLoadedUnavailableReasonId = selectedReason;
    selectedForSortedItem.itemLoadedUnavailableReason = selectedReasonName ?? "";
    selectedForSortedItem.itemLoadedUnavailableRemarks = commentText;
    selectedForSortedSo.disputeStatus=true;
    selectedForSortedTrip.sessionInfo.isOpened = true;
    if (selectedForSortedTrip.sessionInfo.sessionStartTimestamp == "") {
      selectedForSortedTrip.sessionInfo.sessionStartTimestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    }
    for (int i = 0; i < selectedForSortedItem.itemBatchesList.length; i++) {
      int batchKey = batchesListBox.keys.firstWhere((k) => batchesListBox.get(k)?.tripId == selectedForSortedItem.tripId && batchesListBox.get(k)?.batchId == selectedForSortedItem.itemBatchesList[i].batchId);
      await batchesListBox.put(batchKey, selectedForSortedItem.itemBatchesList[i]);
    }
    int itemKey = itemsListBox.keys.firstWhere((k) => itemsListBox.get(k)?.tripId == selectedForSortedItem.tripId && itemsListBox.get(k)?.lineItemId == selectedForSortedItem.lineItemId);
    await itemsListBox.put(itemKey, selectedForSortedItem);
    int soKey = soListBox.keys.firstWhere((k) => soListBox.get(k)?.tripId == selectedForSortedItem.tripId && soListBox.get(k)?.soId == selectedForSortedItem.soId);
    await soListBox.put(soKey, selectedForSortedSo);
    int tripKey = tripListBox.keys.firstWhere((k) => tripListBox.get(k)?.tripId == selectedForSortedItem.tripId);
    await tripListBox.put(tripKey, selectedForSortedTrip);
  }

  filterItemFunction() async {
    if (getIt<Variables>().generalVariables.currentBackGround.symbol == "B") {
      searchedItemsList.clear();
      searchedBatchesList.clear();
      for (int i = 0; i < selectedSoList.length; i++) {
        searchedItemsList.addAll(itemsListBox.values.toList().where((element) => element.tripId == selectedSoList[i].tripId && element.soId == selectedSoList[i].soId).toList());
        searchedBatchesList.addAll(batchesListBox.values.toList().where((element) => element.tripId == selectedSoList[i].tripId && element.soId == selectedSoList[i].soId).toList());
      }
      Map<String, List<BatchesList>> groupedForBatchesList = groupBy(searchedBatchesList, (BatchesList item) => item.itemId);
      for (int i = 0; i < searchedItemsList.length; i++) {
        searchedItemsList[i].itemBatchesList.clear();

        ///
        searchedItemsList[i].itemBatchesList.addAll(groupedForBatchesList[searchedItemsList[i].lineItemId] ?? []);
      }
    } else {
      searchedItemsList.clear();
      searchedBatchesList.clear();
      for (int i = 0; i < selectedSoList.length; i++) {
        searchedItemsList.addAll(itemsListBox.values.toList().where((element) => element.tripId == selectedSoList[i].tripId && element.soId == selectedSoList[i].soId).toList());
        searchedBatchesList.addAll(batchesListBox.values.toList().where((element) => element.tripId == selectedSoList[i].tripId && element.soId == selectedSoList[i].soId).toList());
      }
      Map<String, List<BatchesList>> groupedForBatchesList = groupBy(searchedBatchesList, (BatchesList item) => item.itemId);
      for (int i = 0; i < searchedItemsList.length; i++) {
        searchedItemsList[i].itemBatchesList.clear();

        ///
        searchedItemsList[i].itemBatchesList.addAll(groupedForBatchesList[searchedItemsList[i].lineItemId] ?? []);
      }
      searchedItemsList = searchedItemsList.where((element) => element.itemType == getIt<Variables>().generalVariables.currentBackGround.symbol).toList();
    }
    searchedItemsList = searchedItemsList.where((element) => element.itemName.toLowerCase().contains(searchText.toLowerCase()) || element.itemCode.toLowerCase().contains(searchText.toLowerCase())).toList();
    List<ItemsList> filteredList = [];
    filteredList.addAll(searchedItemsList);
    for (int i = 0; i < getIt<Variables>().generalVariables.selectedFilters.length; i++) {
      switch (getIt<Variables>().generalVariables.selectedFilters[i].type) {
        case "item_code":
          {
            filteredList = filteredList.where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.itemCode == item2)).toList();
          }
        case "so_num":
          {
            filteredList = filteredList.where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.soId == item2)).toList();
          }
        default:
          {
            filteredList = filteredList.where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.itemName == item2)).toList();
          }
      }
    }
    searchedItemsList.clear();
    searchedItemsList.addAll(filteredList);
    singleTabItemsList = searchedItemsList.where((element) => element.itemLoadedStatus == tabName).toList();
    List<ItemsList> itemsSortedList = singleTabItemsList.where((element) => !element.isProgressStatus).toList();
    Map<String, List<ItemsList>> grouped = groupBy(itemsSortedList, (ItemsList item) => item.stagingArea);
    singleTabGroupedItemsList = grouped.values.toList();
    debugPrint("filter_singleTabGroupedItemsList.length");
    debugPrint(singleTabGroupedItemsList.length.toString());
    debugPrint(List.generate(singleTabGroupedItemsList.length, (i) => List.generate(singleTabGroupedItemsList[i].length, (j) => singleTabGroupedItemsList[i][j].itemLoadedStatus)).toString());
    List<ItemsList> itemSortingList = singleTabItemsList.where((element) => element.isProgressStatus).toList();
    Map<String, List<ItemsList>> groupedData = {};
    for (ItemsList item in itemSortingList) {
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
    debugPrint("filter_singleTabGroupingItemsList.length");
    debugPrint(singleTabGroupingItemsList.length.toString());
    debugPrint(List.generate(singleTabGroupingItemsList.length, (i) => List.generate(singleTabGroupingItemsList[i].length, (j) => singleTabGroupingItemsList[i][j].itemLoadedStatus)).toString());
  }

  sessionMoveFunction({required String sessionTime}) async {
    var itemsBoxList = await Hive.openBox<ItemsList>('items_list');
    var tripsBoxList = await Hive.openBox<TripList>('trip_list');
    for (var model in itemsBoxList.values) {
      if (model.tripId == getIt<Variables>().generalVariables.tripListMainIdData.tripId &&
          model.itemLoadedStatus == "Loaded" &&
          model.isProgressStatus &&
          (model.handledBy.isNotEmpty ? (model.handledBy[0].code == getIt<Variables>().generalVariables.userDataEmployeeCode) : false)) {
        model.isProgressStatus = false;
        await model.save();
      }
      if (model.tripId == getIt<Variables>().generalVariables.tripListMainIdData.tripId &&
          model.itemLoadedStatus == "Partial" &&
          model.isProgressStatus &&
          (model.handledBy.isNotEmpty ? (model.handledBy[0].code == getIt<Variables>().generalVariables.userDataEmployeeCode) : false)) {
        model.isProgressStatus = false;
        await model.save();
      }
      if (model.tripId == getIt<Variables>().generalVariables.tripListMainIdData.tripId &&
          model.itemLoadedStatus == "Unavailable" &&
          model.isProgressStatus &&
          (model.handledBy.isNotEmpty ? (model.handledBy[0].code == getIt<Variables>().generalVariables.userDataEmployeeCode) : false)) {
        model.isProgressStatus = false;
        await model.save();
      }
    }
    for (var model in tripsBoxList.values) {
      if (model.tripId == getIt<Variables>().generalVariables.tripListMainIdData.tripId) {
        model.sessionInfo.isOpened = false;
        model.sessionInfo.id = "";
        model.sessionInfo.sessionStartTimestamp = "";
        selectedForSortedTrip=model;
        await model.save();
      }
    }
    List<ItemsList> partialDataList = [];
    partialDataList = itemsListBox.values
        .toList()
        .where((element) =>
    element.tripId == getIt<Variables>().generalVariables.tripListMainIdData.tripId &&
        element.itemLoadedStatus == "Partial" &&
        (element.handledBy.isNotEmpty ? (element.handledBy[0].code == getIt<Variables>().generalVariables.userDataEmployeeCode) : false))
        .toList();
    partialItemsListBox.values.toList().removeWhere((element) => element.tripId == selectedForSortedItem.tripId);
    List<Map<String, dynamic>> data = List.generate(partialDataList.length, (i) => partialDataList[i].toJson());
    partialItemsListBox.addAll(List.from(data.map((x) => PartialItemsList.fromJson(x))));
  }

  Future<String> apiCalls({required Map<String, dynamic> queryData, required List<String> controllersList, required String sessionTime}) async {
    String responseBool="";
    String encodeData = jsonEncode(queryData);
    if (getIt<Variables>().generalVariables.isNetworkOffline) {
      localTempDataList.add(LocalTempDataList(queryData: encodeData));
      switch (queryData['activity']) {
        case "Loaded":
          {
            await sortedItemFunction(controllersList: controllersList);
          }
        case "undo":
          {
            await undoSortedItemFunction();
          }
        case "unavailable":
          {
            await unavailableItemFunction();
          }
        case "session_close":
          {
            await sessionMoveFunction(sessionTime: sessionTime);
          }
        default:
          {
            await sortedItemFunction(controllersList: controllersList);
          }
      }
    }
    else {
      await networkApiCalls();
      switch (queryData['activity']) {
        case "Loaded":
          {
            await getIt<Variables>().repoImpl.getSorterTripListUpdate(query: queryData["query_data"], method: "post", module: ApiEndPoints().loaderModule)
                .onError((error,stackTrace){
              responseBool= error.toString();
            })
                .then((value) async {
              if (value != null) {
                if (value["status"] == "1") {
                  responseBool= "";
                  debugPrint("Added successfully");
                  await sortedItemFunction(controllersList: controllersList);
                }
              }
            });
          }
        case "undo":
          {
            await getIt<Variables>().repoImpl.getSorterTripListUndo(query: queryData["query_data"], method: "post", module: ApiEndPoints().loaderModule)
                .onError((error,stackTrace){
              responseBool= error.toString();
            })
                .then((value) async {
              if (value != null) {
                if (value["status"] == "1") {
                  responseBool= "";
                  debugPrint("Undo successfully");
                  await undoSortedItemFunction();
                }
              }
            });
          }
        case "unavailable":
          {
            await getIt<Variables>().repoImpl.getSorterTripListUndo(query: queryData["query_data"], method: "post", module: ApiEndPoints().loaderModule)
                .onError((error,stackTrace){
              responseBool= error.toString();
            })
                .then((value) async {
              if (value != null) {
                if (value["status"] == "1") {
                  responseBool= "";
                  debugPrint("unavailable successfully");
                  await unavailableItemFunction();
                }
              }
            });
          }
        case "session_close":
          {
            await getIt<Variables>().repoImpl.getSorterTripListSessionClose(query: queryData["query_data"], method: "post", module: ApiEndPoints().loaderModule)
                .onError((error,stackTrace){
              responseBool= error.toString();
            })
                .then((value) async {
              if (value != null) {
                if (value["status"] == "1") {
                  responseBool= "";
                  debugPrint("session closed successfully");
                  await sessionMoveFunction(sessionTime: sessionTime);
                }
              }
            });
          }
        default:
          {
            await getIt<Variables>().repoImpl.getSorterTripListSessionClose(query: queryData["query_data"], method: "post", module: ApiEndPoints().loaderModule)
                .onError((error,stackTrace){
              responseBool= error.toString();
            })
                .then((value) async {
              if (value != null) {
                if (value["status"] == "1") {
                  responseBool= "";
                  debugPrint("session closed successfully");
                  await sortedItemFunction(controllersList: controllersList);
                }
              }
            });
          }
      }
    }
    return responseBool;
  }

  networkApiCalls() async {
    if (localTempDataList.values.toList().isNotEmpty) {
      int i = 0;
      do {
        Map<String, dynamic> queryData = jsonDecode(localTempDataList.values.toList()[i].queryData);
        switch (queryData["activity"]) {
          case "Loaded":
            {
              await getIt<Variables>().repoImpl.getSorterTripListUpdate(query: queryData["query_data"], method: "post", module: ApiEndPoints().loaderModule).onError((error, stackTrace) {}).then((value) async {
                if (value != null) {
                  if (value["status"] == "1") {
                    debugPrint("Added successfully");
                    await localTempDataList.deleteAt(i);
                  }
                }
              });
            }
          case "undo":
            {
              await getIt<Variables>().repoImpl.getSorterTripListUndo(query: queryData["query_data"], method: "post", module: ApiEndPoints().loaderModule).onError((error, stackTrace) {}).then((value) async {
                if (value != null) {
                  if (value["status"] == "1") {
                    debugPrint("Undo successfully");
                    await localTempDataList.deleteAt(i);
                  }
                }
              });
            }
          case "unavailable":
            {
              await getIt<Variables>().repoImpl.getSorterTripListUndo(query: queryData["query_data"], method: "post", module: ApiEndPoints().loaderModule).onError((error, stackTrace) {}).then((value) async {
                if (value != null) {
                  if (value["status"] == "1") {
                    debugPrint("unavailable successfully");
                    await localTempDataList.deleteAt(i);
                  }
                }
              });
            }
          case "session_close":
            {
              await getIt<Variables>().repoImpl.getSorterTripListSessionClose(query: queryData["query_data"], method: "post", module: ApiEndPoints().loaderModule).onError((error, stackTrace) {}).then((value) async {
                if (value != null) {
                  if (value["status"] == "1") {
                    debugPrint("session closed successfully");
                    await localTempDataList.deleteAt(i);
                  }
                }
              });
            }
          default:
            {
              await getIt<Variables>().repoImpl.getSorterTripListSessionClose(query: queryData["query_data"], method: "post", module: ApiEndPoints().loaderModule).onError((error, stackTrace) {}).then((value) async {
                if (value != null) {
                  if (value["status"] == "1") {
                    debugPrint("session closed successfully");
                    await localTempDataList.deleteAt(i);
                  }
                }
              });
            }
        }
      } while (localTempDataList.isNotEmpty);
    }
  }
}
