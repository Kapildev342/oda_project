// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

// Package imports:
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:oda/local_database/pick_list_box/pick_list.dart';
import 'package:oda/local_database/trip_box/trip_list.dart';
import 'package:oda/local_database/user_box/user.dart';
import 'package:oda/repository/api_end_points.dart';
import 'package:oda/repository_model/general/socket_message_response_model.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/variables.dart';

part 'pick_list_details_event.dart';
part 'pick_list_details_state.dart';

class PickListDetailsBloc extends Bloc<PickListDetailsEvent, PickListDetailsState> {
  bool searchBarEnabled = false;
  String searchText = "";
  String selectedPickListId = "";
  String selectedPickListItemId = "";
  String? selectedItemId;
  String? selectedAltItemId;
  String? selectedAltItemName;
  String? selectedAltItemCode;
  int pageIndex = 1;
  String? selectedStagingArea;
  String? selectedReason;
  String? selectedReasonName;
  String? selectedCompletedReasonName;
  String? selectedCompletedReason;
  String? selectedCompletedRemarks;
  String? selectedItemName;
  String? selectedFloor;
  String? selectedFloorName;
  String? selectedRoom;
  String? selectedZone;
  int tabIndex = 0;
  String? selectedLocation;
  String tabName = "Pending";
  List<String> availQtyParticulars = [];
  PickListDetailsResponse pickListDetailsResponse = PickListDetailsResponse.fromJson({});
  List<List<PickListDetailsItem>> groupedPickedData = [];
  List<List<PickListDetailsItem>> groupedPickingData = [];
  List<String> groupedKeepersNameList = [];
  bool moreQuantityError = false;
  bool allFieldsEmpty = false;
  Map<String, dynamic> pickedQuantityData = {};
  List<String> pickedCatchWeightData = [];
  bool selectedReasonEmpty = false;
  bool selectedCompletedReasonEmpty = false;
  bool selectItemEmpty = false;
  String commentText = "";
  bool commentTextEmpty = false;
  bool updateLoader = false;
  List<StagingLocation> stagingAreaList = [];
  String selectedStagingAreaId = "";
  bool formatError = false;
  CancelToken? listCancelToken = CancelToken();
  List<Map<String, dynamic>> pickListMainDataList = [];
  Box<LocalTempDataPickList> localTempDataPickList = Hive.box<LocalTempDataPickList>('local_temp_data_pick_list');
  PickListDetailsItem selectedItem = PickListDetailsItem.fromJson({});
  PickListSessionInfo sessionInfo=PickListSessionInfo.fromJson({});

  Box<UnavailableReason>? unavailableReasonData;
  Box<UnavailableReason>? completeReasonData;

  PickListDetailsBloc() : super(PickListDetailsInitial()) {
    on<PickListDetailsInitialEvent>(pickListDetailsInitialFunction);
    on<PickListDetailsSetStateEvent>(pickListDetailsSetStateFunction);
    on<PickListDetailsTabChangingEvent>(pickListDetailsTabChangingFunction);
    on<PickListDetailsPickedEvent>(pickListDetailsPickedFunction);
    on<PickListDetailsUndoPickedEvent>(pickListDetailsUndoPickedFunction);
    on<PickListDetailsUnavailableEvent>(pickListDetailsUnavailableFunction);
    on<PickListDetailsLocationUpdateEvent>(pickListDetailsLocationUpdateFunction);
    on<PickListDetailsSessionCloseEvent>(pickListDetailsSessionCloseFunction);
    on<PickListDetailsCompleteEvent>(pickListDetailsCompleteFunction);
    on<PickListDetailsRefreshEvent>(pickListDetailsRefreshFunction);
  }

  ///latest
  /*FutureOr<void> pickListDetailsInitialFunction(PickListDetailsInitialEvent event, Emitter<PickListDetailsState> emit) async {
   // pickListMainDataList = pickListBloc.pickListMainDataList;
    pickListMainDataList = pickListBloc.pickListMainData;
    getIt<Variables>().generalVariables.picklistSocketTempId = selectedPickListId;
    getIt<Variables>().generalVariables.picklistSocketTempStatus = tabName;
    getIt<Variables>().generalVariables.filters.clear();
    getIt<Variables>().generalVariables.selectedFilters.clear();
    getIt<Variables>().generalVariables.selectedFiltersName.clear();
    getIt<Variables>().generalVariables.filterSearchController.clear();
    getIt<Variables>().generalVariables.filterSelectedMainIndex = 0;
    searchText = "";
    searchBarEnabled = false;
    pickListDetailsResponse = PickListDetailsResponse.fromJson({});
    emit(PickListDetailsLoading());
    Box<PickListDetailsResponse> pickListDetailsResponseBoxData = await Hive.openBox<PickListDetailsResponse>('pick_list_details_response');
    List<PickListDetailsResponse> finalData = pickListDetailsResponseBoxData.values.toList();
    pickListDetailsResponse = finalData.firstWhere((model) => model.picklistId == selectedPickListId);
    Box<StagingLocation> stagingLocationData = await Hive.openBox<StagingLocation>('staging_location');
    if (stagingLocationData.isNotEmpty) {
      List<StagingLocation> staging = stagingLocationData.values.toList();
      stagingAreaList.clear();
      stagingAreaList.addAll(staging);
    }
    //getIt<Variables>().generalVariables.filters.add(pickListDetailsResponse.locationFilter);
    getIt<Variables>().generalVariables.filters = List<Filter>.from([
      {
        "type": "item_type",
        "label": getIt<Variables>().generalVariables.currentLanguage.itemType,
        "selection": "multiple",
        "get_options": false,
        "options": List.generate(
            pickListDetailsResponse.items.length,
            (i) => {
                  "id": pickListDetailsResponse.items[i].itemType,
                  "label": pickListDetailsResponse.items[i].itemType == "D"
                      ? "DRY"
                      : pickListDetailsResponse.items[i].itemType == "F"
                          ? "FROZEN"
                          : pickListDetailsResponse.items[i].itemType == "C"
                              ? "CHILL"
                              : pickListDetailsResponse.items[i].itemType == "DC"
                                  ? "Dry Chill"
                                  : ""
                }).map((map) => jsonEncode(map)).toSet().map((str) => jsonDecode(str)).toList()
      },
      {
        "type": "so_num",
        "label": getIt<Variables>().generalVariables.currentLanguage.soNum,
        "selection": "multiple",
        "get_options": false,
        "options": List.generate(pickListDetailsResponse.items.length,
                (i) => {"id": pickListDetailsResponse.items[i].soNum, "label": pickListDetailsResponse.items[i].soNum})
            .map((map) => jsonEncode(map))
            .toSet()
            .map((str) => jsonDecode(str))
            .toList()
      },
      {
        "type": "floor",
        "label": getIt<Variables>().generalVariables.currentLanguage.floor,
        "selection": "multiple",
        "get_options": false,
        "options": List.generate(pickListDetailsResponse.items.length,
                (i) => {"id": pickListDetailsResponse.items[i].floor, "label": "FLOOR ${pickListDetailsResponse.items[i].floor}"})
            .map((map) => jsonEncode(map))
            .toSet()
            .map((str) => jsonDecode(str))
            .toList()
      },
      {
        "type": "item_code",
        "label": getIt<Variables>().generalVariables.currentLanguage.itemCode,
        "selection": "multiple",
        "get_options": false,
        "options": List.generate(pickListDetailsResponse.items.length,
                (i) => {"id": pickListDetailsResponse.items[i].itemCode, "label": pickListDetailsResponse.items[i].itemCode})
            .map((map) => jsonEncode(map))
            .toSet()
            .map((str) => jsonDecode(str))
            .toList()
      },
      {
        "type": "sort_by_location",
        "label": getIt<Variables>().generalVariables.currentLanguage.sortBy,
        "selection": "single",
        "get_options": false,
        "options": [
          {
            "id": "1",
            "label": "ASC",
            "code": "ascending",
          },
          {
            "id": '-1',
            "label": "DESC",
            "code": "descending",
          }
        ],
      }
    ].map((x) => Filter.fromJson(x)));
    Map<String, List<PickListDetailsItem>> grouped = groupBy((pickListDetailsResponse.items.where((e) => e.status == "Pending")).toList(),
            (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
    groupedPickedData.clear();
    for(int i=0;i<grouped.values.toList().length;i++){
      groupedPickedData.add([]);
      List<PickListDetailsItem> firstGroupedPickedData = grouped.values.toList()[i];
      Map<String, List<PickListDetailsItem>> firstGroupedPickedDataGrouped = groupBy(firstGroupedPickedData, (PickListDetailsItem data) => data.itemId);
      List<List<PickListDetailsItem>> firstGroupedPickedDataGroupedList = firstGroupedPickedDataGrouped.values.toList();
      for(int j=0;j<firstGroupedPickedDataGroupedList.length;j++){
        List<PickListDetailsItem> firstFirstGroupedPickedDataGroupedList = firstGroupedPickedDataGroupedList[j];
        PickListDetailsItem selectedPickListItem = PickListDetailsItem(
            id: firstFirstGroupedPickedDataGroupedList[0].id,
            itemId: firstFirstGroupedPickedDataGroupedList[0].itemId,
            picklistNum: firstFirstGroupedPickedDataGroupedList[0].picklistNum,
            status: firstFirstGroupedPickedDataGroupedList[0].status,
            itemCode: firstFirstGroupedPickedDataGroupedList[0].itemCode,
            itemName: firstFirstGroupedPickedDataGroupedList[0].itemName,
            quantity: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].batchesList[0].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
            pickedQty: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].batchesList[0].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
            uom: firstFirstGroupedPickedDataGroupedList[0].uom,
            itemType: firstFirstGroupedPickedDataGroupedList[0].itemType,
            typeColor: firstFirstGroupedPickedDataGroupedList[0].typeColor,
            floor: firstFirstGroupedPickedDataGroupedList[0].floor,
            room: firstFirstGroupedPickedDataGroupedList[0].room,
            zone: firstFirstGroupedPickedDataGroupedList[0].zone,
            stagingArea: firstFirstGroupedPickedDataGroupedList[0].stagingArea,
            isProgressStatus: firstFirstGroupedPickedDataGroupedList[0].isProgressStatus,
            packageTerms: firstFirstGroupedPickedDataGroupedList[0].packageTerms,
            catchWeightStatus: firstFirstGroupedPickedDataGroupedList[0].catchWeightStatus,
            catchWeightInfo: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfo,
            catchWeightInfoForList: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoForList,
            catchWeightInfoPicked: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoPicked,
            handledBy: firstFirstGroupedPickedDataGroupedList[0].handledBy,
            locationDisputeInfo: firstFirstGroupedPickedDataGroupedList[0].locationDisputeInfo,
            unavailableReason: firstFirstGroupedPickedDataGroupedList[0].unavailableReason,
            alternativeItemName: firstFirstGroupedPickedDataGroupedList[0].alternativeItemName,
            alternativeItemCode: firstFirstGroupedPickedDataGroupedList[0].alternativeItemCode,
            batchesList: List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>firstFirstGroupedPickedDataGroupedList[i].batchesList[0]),
            allowUndo: firstFirstGroupedPickedDataGroupedList[0].allowUndo,
            soNum: firstFirstGroupedPickedDataGroupedList[0].soNum);
        groupedPickedData[i].add(selectedPickListItem);
      }
    }
    await getTabsCountData();
    getIt<Variables>().generalVariables.timelineInfo.clear();
    getIt<Variables>().generalVariables.timelineInfo.addAll(pickListDetailsResponse.timelineInfo);
    emit(PickListDetailsDummy());
    emit(PickListDetailsLoaded());
  }*/

  FutureOr<void> pickListDetailsInitialFunction(PickListDetailsInitialEvent event, Emitter<PickListDetailsState> emit) async {
    emit(PickListDetailsLoading());
    //pickListMainDataList = pickListBloc.pickListMainData;
    getIt<Variables>().generalVariables.picklistSocketTempId = selectedPickListId;
    getIt<Variables>().generalVariables.picklistSocketTempStatus = tabName;
    getIt<Variables>().generalVariables.filters.clear();
    getIt<Variables>().generalVariables.selectedFilters.clear();
    getIt<Variables>().generalVariables.selectedFiltersName.clear();
    getIt<Variables>().generalVariables.filterSearchController.clear();
    getIt<Variables>().generalVariables.filterSelectedMainIndex = 0;
    searchText = "";
    searchBarEnabled = false;
    pickListDetailsResponse = PickListDetailsResponse.fromJson({});
    unavailableReasonData = await Hive.openBox<UnavailableReason>('unavailable_reason');
    completeReasonData = await Hive.openBox<UnavailableReason>('complete_reason');
    Box pickListMainDataListLocalBox = Hive.box('pick_list_main_data_list_local');
    String? pickListMainDataListLocalGetString = pickListMainDataListLocalBox.get('myListKey');
    if (pickListMainDataListLocalGetString != null) {
      List<dynamic> decoded = jsonDecode(pickListMainDataListLocalGetString);
      pickListMainDataList = List<Map<String, dynamic>>.from(decoded);
    }
    List<Map<String,dynamic>> pickListItemDetails=pickListMainDataList.where((e)=>e["picklist_id"]==selectedPickListId).toList();
    Map<String, List<Map<String, dynamic>>> pickListItemData = groupBy(pickListItemDetails, (Map<String, dynamic> data) => data["picklist_item_id"]);
    List<List<Map<String, dynamic>>> pickListItemDataValues = pickListItemData.values.toList();
    List<Map<String, dynamic>> pickListItemDataMain = List.generate(pickListItemDataValues.length, (j) => pickListItemDataValues[j][0]);
    List<PickListDetailsItem> itemsPickListDetailsData = List<PickListDetailsItem>.from(pickListItemDataMain.map((x) => PickListDetailsItem.fromJson(x)));
    sessionInfo = PickListSessionInfo.fromJson({});
    List<Map<String, dynamic>> batchesSessionData = [];
    for (int i = 0; i < pickListItemDetails.length; i++) {
      if (pickListItemDetails[i]["is_session_opened"]) {
        batchesSessionData.add(pickListItemDetails[i]);
      }
    }
    String pendingData = batchesSessionData.where((e) => e["picklist_item_status"] == "Pending").toList().length.toString();
    String pickedData = batchesSessionData.where((e) => e["picklist_item_status"] == "Picked").toList().length.toString();
    String partialData = batchesSessionData.where((e) => e["picklist_item_status"] == "Partial").toList().length.toString();
    String unavailableData = batchesSessionData.where((e) => e["picklist_item_status"] == "Unavailable").toList().length.toString();
    for (int i = 0; i < pickListItemDetails.length; i++) {
      if (pickListItemDetails[i]["is_session_opened"]) {
        sessionInfo = PickListSessionInfo(
            isOpened: pickListItemDetails[i]["is_session_opened"],
            id: pickListItemDetails[i]["session_id"],
            pending: "0",
            picked: "0",
            partial: "0",
            unavailable: "0",
            sessionStartTimestamp: pickListItemDetails[i]["session_timestamp"],
            timeSpendSeconds: "",
            partialIdsList: [],
            pendingList: [],
            pickedList: [],
            partialList: [],
            unavailableList: []);
        break;
      }
    }
    sessionInfo.pending = pendingData;
    sessionInfo.picked = pickedData;
    sessionInfo.partial = partialData;
    sessionInfo.unavailable = unavailableData;
    List<Map<String, dynamic>> partialWorkedData = pickListItemDetails.where((x) => x["picklist_item_status"] == "Partial").toList();
    sessionInfo.partialIdsList = List.generate(partialWorkedData.length, (l) => partialWorkedData[l]["picklist_item_id"]);
    sessionInfo.pendingList = List<PickListDetailsItem>.from(batchesSessionData
        .where((e) => e["picklist_item_status"] == "Pending")
        .toList()
        .map((x) => PickListDetailsItem.fromJson(x)));
    sessionInfo.pickedList = List<PickListDetailsItem>.from(
        batchesSessionData.where((e) => e["picklist_item_status"] == "Picked").toList().map((x) => PickListDetailsItem.fromJson(x)));
    sessionInfo.partialList = List<PickListDetailsItem>.from(batchesSessionData
        .where((e) => e["picklist_item_status"] == "Partial")
        .toList()
        .map((x) => PickListDetailsItem.fromJson(x)));
    sessionInfo.unavailableList = List<PickListDetailsItem>.from(batchesSessionData
        .where((e) => e["picklist_item_status"] == "Unavailable")
        .toList()
        .map((x) => PickListDetailsItem.fromJson(x)));
    for (int k = 0; k < pickListItemDataValues.length; k++) {
      List<PickListBatchesList> batches = [];
      for (int l = 0; l < pickListItemDataValues[k].length; l++) {
        batches.add(PickListBatchesList.fromJson(pickListItemDataValues[k][l]));
      }
      itemsPickListDetailsData[k].batchesList = batches;
    }
    ///pick list handled by
    List<HandledByPickList> handledByPickListData = [];
    for(int i=0; i<pickListItemDetails.length;i++){
      if(pickListItemDetails[i]["handled_by"].isNotEmpty){
        handledByPickListData.add(HandledByPickList.fromJson(pickListItemDetails[i]["handled_by"][0]));
      }
    }
    List<HandledByPickList> handledByData = mergeHandledByPickList(handledByPickListData: handledByPickListData);
    ///item handled by
    for(int i=0;i<pickListItemDataValues.length;i++){
      List<HandledByPickList> handledByPickListDataLoop = [];
      for(int j=0; j<pickListItemDataValues[i].length;j++){
        if(pickListItemDataValues[i][j]["handled_by"].isNotEmpty){
          handledByPickListDataLoop.add(HandledByPickList.fromJson(pickListItemDataValues[i][j]["handled_by"][0]));
        }
      }
      List<HandledByPickList> handledByDataLoop = mergeHandledByPickList(handledByPickListData: handledByPickListData);
      itemsPickListDetailsData[i].handledBy=handledByDataLoop;
    }
    pickListDetailsResponse = PickListDetailsResponse(
        picklistId: selectedPickListId,
        picklistNum: pickListItemDetails[0]["picklist_num"] ?? "",
        route: pickListItemDetails[0]["route"] ?? "",
        picklistStatus: pickListItemDetails[0]["picklist_status"] ?? "",
        picklistTime: pickListItemDetails[0]["picklist_created"] ?? "",
        totalItems: pickListItemDetails[0]["total_picklist_items"] ?? "",
        //need to update
        pickedItems: pickListItemDataMain.where((x) => x["picklist_item_status"] == "Picked").toList().length.toString(),
        isReadyToMoveComplete: pickListItemDetails[0]["picklist_status"] == getIt<Variables>().generalVariables.currentLanguage.completed?false:pickListItemDataMain.where((x) => x["picklist_item_status"] == "Pending").toList().isEmpty && sessionInfo.isOpened == false && pickListItemDataMain.where((x) => x["picklist_item_status"] == "Partial").toList().isNotEmpty,
        //need to update
        isCompleted: pickListItemDetails[0]["picklist_status"] == getIt<Variables>().generalVariables.currentLanguage.completed,
        handledBy: handledByData,
        yetToPick: pickListItemDataMain.where((x) => x["picklist_item_status"] == "Pending").toList().length,
        picked: pickListItemDataMain.where((x) => x["picklist_item_status"] == "Picked").toList().length,
        partial: pickListItemDataMain.where((x) => x["picklist_item_status"] == "Partial").toList().length,
        unavailable: pickListItemDataMain.where((x) => x["picklist_item_status"] == "Unavailable").toList().length,
        items: itemsPickListDetailsData,
        unavailableReasons: unavailableReasonData!.values.toList(),
        completeReasons: completeReasonData!.values.toList(),
        alternateItems: getIt<Variables>().generalVariables.userData.filterItemsListOptions,
        locationFilter: Filter.fromJson({}),
        sessionInfo: sessionInfo,
        timelineInfo: List<TimelineInfo>.from([].map((x) => TimelineInfo.fromJson(x))));


    Box<StagingLocation> stagingLocationData = await Hive.openBox<StagingLocation>('staging_location');
    if (stagingLocationData.isNotEmpty) {
      List<StagingLocation> staging = stagingLocationData.values.toList();
      stagingAreaList.clear();
      stagingAreaList.addAll(staging);
    }
    getIt<Variables>().generalVariables.filters = List<Filter>.from([
      {
        "type": "item_type",
        "label": getIt<Variables>().generalVariables.currentLanguage.itemType,
        "selection": "multiple",
        "get_options": false,
        "options": List.generate(
            pickListDetailsResponse.items.length,
                (i) => {
              "id": pickListDetailsResponse.items[i].itemType,
              "label": pickListDetailsResponse.items[i].itemType == "D"
                  ? "DRY"
                  : pickListDetailsResponse.items[i].itemType == "F"
                  ? "FROZEN"
                  : pickListDetailsResponse.items[i].itemType == "C"
                  ? "CHILL"
                  : pickListDetailsResponse.items[i].itemType == "DC"
                  ? "Dry Chill"
                  : ""
            }).map((map) => jsonEncode(map)).toSet().map((str) => jsonDecode(str)).toList()
      },
      {
        "type": "so_num",
        "label": getIt<Variables>().generalVariables.currentLanguage.soNum,
        "selection": "multiple",
        "get_options": false,
        "options": List.generate(pickListDetailsResponse.items.length,
                (i) => {"id": pickListDetailsResponse.items[i].soNum, "label": pickListDetailsResponse.items[i].soNum})
            .map((map) => jsonEncode(map))
            .toSet()
            .map((str) => jsonDecode(str))
            .toList()
      },
      {
        "type": "floor",
        "label": getIt<Variables>().generalVariables.currentLanguage.floor,
        "selection": "multiple",
        "get_options": false,
        "options": List.generate(pickListDetailsResponse.items.length,
                (i) => {"id": pickListDetailsResponse.items[i].floor, "label": "FLOOR ${pickListDetailsResponse.items[i].floor}"})
            .map((map) => jsonEncode(map))
            .toSet()
            .map((str) => jsonDecode(str))
            .toList()
      },
      {
        "type": "item_code",
        "label": getIt<Variables>().generalVariables.currentLanguage.itemCode,
        "selection": "multiple",
        "get_options": false,
        "options": List.generate(pickListDetailsResponse.items.length,
                (i) => {"id": pickListDetailsResponse.items[i].itemCode, "label": pickListDetailsResponse.items[i].itemCode})
            .map((map) => jsonEncode(map))
            .toSet()
            .map((str) => jsonDecode(str))
            .toList()
      },
      {
        "type": "sort_by_location",
        "label": getIt<Variables>().generalVariables.currentLanguage.sortBy,
        "selection": "single",
        "get_options": false,
        "options": [
          {
            "id": "1",
            "label": "ASC",
            "code": "ascending",
          },
          {
            "id": '-1',
            "label": "DESC",
            "code": "descending",
          }
        ],
      }
    ].map((x) => Filter.fromJson(x)));
    Map<String, List<PickListDetailsItem>> grouped = groupBy((pickListDetailsResponse.items.where((e) => e.status == "Pending")).toList(), (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
    groupedPickedData.clear();
    for(int i=0;i<grouped.values.toList().length;i++){
      groupedPickedData.add([]);
      List<PickListDetailsItem> firstGroupedPickedData = grouped.values.toList()[i];
      Map<String, List<PickListDetailsItem>> firstGroupedPickedDataGrouped = groupBy(firstGroupedPickedData, (PickListDetailsItem data) => data.itemId);
      List<List<PickListDetailsItem>> firstGroupedPickedDataGroupedList = firstGroupedPickedDataGrouped.values.toList();
      for(int j=0;j<firstGroupedPickedDataGroupedList.length;j++){
        List<PickListDetailsItem> firstFirstGroupedPickedDataGroupedList = firstGroupedPickedDataGroupedList[j];
        PickListDetailsItem selectedPickListItem = PickListDetailsItem(
            id: firstFirstGroupedPickedDataGroupedList[0].id,
            itemId: firstFirstGroupedPickedDataGroupedList[0].itemId,
            picklistNum: firstFirstGroupedPickedDataGroupedList[0].picklistNum,
            status: firstFirstGroupedPickedDataGroupedList[0].status,
            itemCode: firstFirstGroupedPickedDataGroupedList[0].itemCode,
            itemName: firstFirstGroupedPickedDataGroupedList[0].itemName,
            quantity: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].batchesList[0].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
            pickedQty: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].batchesList[0].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
            uom: firstFirstGroupedPickedDataGroupedList[0].uom,
            itemType: firstFirstGroupedPickedDataGroupedList[0].itemType,
            typeColor: firstFirstGroupedPickedDataGroupedList[0].typeColor,
            floor: firstFirstGroupedPickedDataGroupedList[0].floor,
            room: firstFirstGroupedPickedDataGroupedList[0].room,
            zone: firstFirstGroupedPickedDataGroupedList[0].zone,
            stagingArea: firstFirstGroupedPickedDataGroupedList[0].stagingArea,
            isProgressStatus: firstFirstGroupedPickedDataGroupedList[0].isProgressStatus,
            packageTerms: firstFirstGroupedPickedDataGroupedList[0].packageTerms,
            catchWeightStatus: firstFirstGroupedPickedDataGroupedList[0].catchWeightStatus,
            catchWeightInfo: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfo,
            catchWeightInfoForList: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoForList,
            catchWeightInfoPicked: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoPicked,
            handledBy: firstFirstGroupedPickedDataGroupedList[0].handledBy,
            locationDisputeInfo: firstFirstGroupedPickedDataGroupedList[0].locationDisputeInfo,
            unavailableReason: firstFirstGroupedPickedDataGroupedList[0].unavailableReason,
            alternativeItemName: firstFirstGroupedPickedDataGroupedList[0].alternativeItemName,
            alternativeItemCode: firstFirstGroupedPickedDataGroupedList[0].alternativeItemCode,
            batchesList: List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>firstFirstGroupedPickedDataGroupedList[i].batchesList[0]),
            allowUndo: firstFirstGroupedPickedDataGroupedList[0].allowUndo,
            soNum: firstFirstGroupedPickedDataGroupedList[0].soNum);
        groupedPickedData[i].add(selectedPickListItem);
      }
    }
   // await getTabsCountData();
    getIt<Variables>().generalVariables.timelineInfo.clear();
    getIt<Variables>().generalVariables.timelineInfo.addAll(pickListDetailsResponse.timelineInfo);
    emit(PickListDetailsDummy());
    emit(PickListDetailsLoaded());
  }

  ///primary
  /* FutureOr<void> pickListDetailsInitialFunction(PickListDetailsInitialEvent event, Emitter<PickListDetailsState> emit) async {
    pickListMainDataList = pickListBloc.pickListMainDataList;
    getIt<Variables>().generalVariables.picklistSocketTempId = selectedPickListId;
    getIt<Variables>().generalVariables.picklistSocketTempStatus = tabName;
    searchText = "";
    searchBarEnabled = false;
    pickListDetailsResponse = PickListDetailsResponse.fromJson({});
    if (listCancelToken != null && !listCancelToken!.isCancelled) {
      listCancelToken?.cancel("Previous requests canceled.");
    }
    listCancelToken = CancelToken();
    emit(PickListDetailsLoading());
    getIt<Variables>().repoImpl.getPickListDetailsFilters(query: {"picklist_id": selectedPickListId}, method: "get").then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          PickListDetailsFilterModel pickListDetailsFilterModel = PickListDetailsFilterModel.fromJson(value);
          getIt<Variables>().generalVariables.filterSearchController.clear();
          getIt<Variables>().generalVariables.selectedFilters.clear();
          getIt<Variables>().generalVariables.selectedFiltersName.clear();
          getIt<Variables>().generalVariables.searchedResultFilterOption.clear();
          getIt<Variables>().generalVariables.filterSelectedMainIndex = 0;
          getIt<Variables>().generalVariables.filters = pickListDetailsFilterModel.response.filters;
          List<FilterOptionsResponse> optionsData = [];
          for (int j = 0; j < pickListDetailsFilterModel.response.filters.length; j++) {
            if (pickListDetailsFilterModel.response.filters[j].getOptions) {
              if (pickListDetailsFilterModel.response.filters[j].type == "items_list" ||
                  pickListDetailsFilterModel.response.filters[j].type == "customers") {
                switch (pickListDetailsFilterModel.response.filters[j].type) {
                  case "items_list":
                    getIt<Variables>()
                        .generalVariables
                        .filters[j]
                        .options
                        .addAll(getIt<Variables>().generalVariables.userData.filterItemsListOptions);
                  case "customers":
                    getIt<Variables>()
                        .generalVariables
                        .filters[j]
                        .options
                        .addAll(getIt<Variables>().generalVariables.userData.filterCustomersOptions);
                  default:
                    getIt<Variables>()
                        .generalVariables
                        .filters[j]
                        .options
                        .addAll(getIt<Variables>().generalVariables.userData.filterItemsListOptions);
                }
              } else {
                getIt<Variables>().generalVariables.filters[j].options.clear();
                int i = 0;
                do {
                  await getIt<Variables>().repoImpl.getFiltersOption(
                      query: {"filter_type": pickListDetailsFilterModel.response.filters[j].type, "page": i}, method: "post").then((value) {
                    if (value != null) {
                      if (value["status"] == "1") {
                        FilterOptionsModel filterOptionsModel = FilterOptionsModel.fromJson(value);
                        optionsData = filterOptionsModel.response;
                        getIt<Variables>().generalVariables.filters[j].options.addAll(optionsData);
                      }
                    }
                  });
                  i++;
                } while (optionsData.isNotEmpty);
              }
              getIt<Variables>().generalVariables.searchedResultFilterOption =
                  getIt<Variables>().generalVariables.filters[getIt<Variables>().generalVariables.filterSelectedMainIndex].options;
            } else {
              getIt<Variables>().generalVariables.searchedResultFilterOption =
                  getIt<Variables>().generalVariables.filters[getIt<Variables>().generalVariables.filterSelectedMainIndex].options;
            }
          }
        }
      }
    });
    getIt<Variables>().repoImpl.getLocations(query: {"type": "staging"}, method: "get").then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          FloorListModel floorListModel = FloorListModel.fromJson(value);
          stagingAreaList = floorListModel.response.locations;
        }
      }
    });
    await getIt<Variables>().repoImpl.getPickListDetails(
        query: {"picklist_id": selectedPickListId, "search": "", "page": 1, "status": "Pending", "filters": []},
        method: "post",
        globalCancelToken: listCancelToken).onError((error, stackTrace) {
      emit(PickListDetailsError(message: error.toString()));
      emit(PickListDetailsLoading());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          PickListDetailsModel pickListDetailsModel = PickListDetailsModel.fromJson(value);
          pickListDetailsResponse = pickListDetailsModel.response;
          pickListDetailsResponse.alternateItems.clear();
          pickListDetailsResponse.alternateItems = getIt<Variables>().generalVariables.userData.filterItemsListOptions;
          getIt<Variables>().generalVariables.filters.add(pickListDetailsModel.response.locationFilter);
          Map<String, List<PickListDetailsItem>> grouped =
              groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
          groupedPickedData = grouped.values.toList();
          getIt<Variables>().generalVariables.timelineInfo.clear();
          getIt<Variables>().generalVariables.timelineInfo.addAll(pickListDetailsResponse.timelineInfo);
          emit(PickListDetailsLoaded());
        } else {
          emit(PickListDetailsError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(PickListDetailsLoading());
        }
      }
    });
  }*/

  ///secondary
  /*FutureOr<void> pickListDetailsInitialFunction(PickListDetailsInitialEvent event, Emitter<PickListDetailsState> emit) async {
    pickListMainDataList = pickListBloc.pickListMainDataList;
    getIt<Variables>().generalVariables.picklistSocketTempId = selectedPickListId;
    getIt<Variables>().generalVariables.picklistSocketTempStatus = tabName;
    searchText = "";
    searchBarEnabled = false;
    pickListDetailsResponse = PickListDetailsResponse.fromJson({});
    if (listCancelToken != null && !listCancelToken!.isCancelled) {
      listCancelToken?.cancel("Previous requests canceled.");
    }
    listCancelToken = CancelToken();
    emit(PickListDetailsLoading());
    if (!getIt<Variables>().generalVariables.isNetworkOffline) {
      getIt<Variables>().repoImpl.getPickListDetailsFilters(query: {"picklist_id": selectedPickListId}, method: "get").then((value) async {
        if (value != null) {
          if (value["status"] == "1") {
            PickListDetailsFilterModel pickListDetailsFilterModel = PickListDetailsFilterModel.fromJson(value);
            getIt<Variables>().generalVariables.filterSearchController.clear();
            getIt<Variables>().generalVariables.selectedFilters.clear();
            getIt<Variables>().generalVariables.selectedFiltersName.clear();
            getIt<Variables>().generalVariables.searchedResultFilterOption.clear();
            getIt<Variables>().generalVariables.filterSelectedMainIndex = 0;
            getIt<Variables>().generalVariables.filters = pickListDetailsFilterModel.response.filters;
            List<FilterOptionsResponse> optionsData = [];
            for (int j = 0; j < pickListDetailsFilterModel.response.filters.length; j++) {
              if (pickListDetailsFilterModel.response.filters[j].getOptions) {
                if (pickListDetailsFilterModel.response.filters[j].type == "items_list" || pickListDetailsFilterModel.response.filters[j].type == "customers") {
                  switch (pickListDetailsFilterModel.response.filters[j].type) {
                    case "items_list":
                      getIt<Variables>().generalVariables.filters[j].options.addAll(getIt<Variables>().generalVariables.userData.filterItemsListOptions);
                    case "customers":
                      getIt<Variables>().generalVariables.filters[j].options.addAll(getIt<Variables>().generalVariables.userData.filterCustomersOptions);
                    default:
                      getIt<Variables>().generalVariables.filters[j].options.addAll(getIt<Variables>().generalVariables.userData.filterItemsListOptions);
                  }
                } else {
                  getIt<Variables>().generalVariables.filters[j].options.clear();
                  int i = 0;
                  do {
                    await getIt<Variables>().repoImpl.getFiltersOption(query: {"filter_type": pickListDetailsFilterModel.response.filters[j].type, "page": i}, method: "post").then((value) {
                      if (value != null) {
                        if (value["status"] == "1") {
                          FilterOptionsModel filterOptionsModel = FilterOptionsModel.fromJson(value);
                          optionsData = filterOptionsModel.response;
                          getIt<Variables>().generalVariables.filters[j].options.addAll(optionsData);
                        }
                      }
                    });
                    i++;
                  } while (optionsData.isNotEmpty);
                }
                getIt<Variables>().generalVariables.searchedResultFilterOption = getIt<Variables>().generalVariables.filters[getIt<Variables>().generalVariables.filterSelectedMainIndex].options;
              } else {
                getIt<Variables>().generalVariables.searchedResultFilterOption = getIt<Variables>().generalVariables.filters[getIt<Variables>().generalVariables.filterSelectedMainIndex].options;
              }
            }
          }
        }
      });
      getIt<Variables>().repoImpl.getLocations(query: {"type": "staging"}, method: "get").then((value) async {
        if (value != null) {
          if (value["status"] == "1") {
            FloorListModel floorListModel = FloorListModel.fromJson(value);
            stagingAreaList = floorListModel.response.locations;
          }
        }
      });
      await getIt<Variables>().repoImpl.getPickListDetails(query: {"picklist_id": selectedPickListId, "search": "", "page": 1, "status": "Pending", "filters": []}, method: "post", globalCancelToken: listCancelToken).onError((error, stackTrace) {
        emit(PickListDetailsError(message: error.toString()));
        emit(PickListDetailsLoading());
      }).then((value) async {
        if (value != null) {
          if (value["status"] == "1") {
            PickListDetailsModel pickListDetailsModel = PickListDetailsModel.fromJson(value);
            pickListDetailsResponse = pickListDetailsModel.response;
            pickListDetailsResponse.alternateItems.clear();
            pickListDetailsResponse.alternateItems = getIt<Variables>().generalVariables.userData.filterItemsListOptions;
            getIt<Variables>().generalVariables.filters.add(pickListDetailsModel.response.locationFilter);
            Map<String, List<PickListDetailsItem>> grouped = groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
            groupedPickedData = grouped.values.toList();
            getIt<Variables>().generalVariables.timelineInfo.clear();
            getIt<Variables>().generalVariables.timelineInfo.addAll(pickListDetailsResponse.timelineInfo);
            emit(PickListDetailsLoaded());
          } else {
            emit(PickListDetailsError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
            emit(PickListDetailsLoading());
          }
        }
      });
    } else {
      Box<PickListDetailsResponse> pickListDetailsResponseBoxData = await Hive.openBox<PickListDetailsResponse>('pick_list_details_response');
      if (pickListDetailsResponseBoxData.values.isEmpty) {
        pickListDetailsResponseBoxData.clear();
        Map<String, List<Map<String, dynamic>>> pickListData = groupBy(pickListMainDataList, (Map<String, dynamic> data) => data["picklist_id"]);
        List<List<Map<String, dynamic>>> pickListDataValues = pickListData.values.toList();
        await Hive.openBox<PickListDetailsResponse>('pick_list_details_response');
        Box<PickListDetailsResponse> pickListTempResponseBoxData = Hive.box<PickListDetailsResponse>('pick_list_details_response');
        for (int i = 0; i < pickListDataValues.length; i++) {
          Map<String, List<Map<String, dynamic>>> pickListItemData = groupBy(pickListDataValues[i], (Map<String, dynamic> data) => data["line_item_id"]);
          List<List<Map<String, dynamic>>> pickListItemDataValues = pickListItemData.values.toList();
          List<Map<String, dynamic>> pickListItemDataMain = List.generate(pickListItemDataValues.length, (j) => pickListItemDataValues[j][0]);
          List<PickListDetailsItem> itemsPickListDetailsData = List<PickListDetailsItem>.from(pickListItemDataMain.map((x) => PickListDetailsItem.fromJson(x)));
          for (int k = 0; k < pickListItemDataValues.length; k++) {
            List<PickListBatchesList> batches = [];
            for (int l = 0; l < pickListItemDataValues[k].length; l++) {
              batches.add(PickListBatchesList.fromJson(pickListItemDataValues[k][l]));
            }
            itemsPickListDetailsData[k].batchesList = batches;
          }
          await Future.delayed(const Duration(milliseconds: 500), () {
            pickListTempResponseBoxData.add(PickListDetailsResponse(
                picklistId: pickListDataValues[i][0]["picklist_id"] ?? "",
                picklistNum: pickListDataValues[i][0]["picklist_num"] ?? "",
                route: pickListDataValues[i][0]["route"] ?? "",
                picklistStatus: pickListDataValues[i][0]["picklist_status"] ?? "",
                picklistTime: pickListDataValues[i][0]["picklist_created"] ?? "",
                totalItems: pickListDataValues[i][0]["total_picklist_items"] ?? "",
                pickedItems: pickListDataValues[i][0]["total_picklist_picked_items"] ?? "",
                isReadyToMoveComplete: false,
                isCompleted: false,
                handledBy: List<HandledByPickList>.from((pickListDataValues[i][0]["handled_by"] ?? []).map((x) => HandledByPickList.fromJson(x))),
                yetToPick: pickListItemDataMain.where((x) => x["picklist_item_status"] == "Pending").toList().length,
                picked: pickListItemDataMain.where((x) => x["picklist_item_status"] == "Picked").toList().length,
                partial: pickListItemDataMain.where((x) => x["picklist_item_status"] == "Partial").toList().length,
                unavailable: pickListItemDataMain.where((x) => x["picklist_item_status"] == "Unavailable").toList().length,
                items: itemsPickListDetailsData,
                unavailableReasons: [],
                completeReasons: [],
                alternateItems: [],
                locationFilter: Filter.fromJson({}),
                sessionInfo: PickListSessionInfo.fromJson({}),
                timelineInfo: []));
          });
        }
        List<PickListDetailsResponse> finalData = pickListDetailsResponseBoxData.values.toList();
        pickListDetailsResponse = finalData.firstWhere((model) => model.picklistId == selectedPickListId);
        pickListDetailsResponse.alternateItems.clear();
        pickListDetailsResponse.alternateItems = getIt<Variables>().generalVariables.userData.filterItemsListOptions;
        getIt<Variables>().generalVariables.filters.add(pickListDetailsResponse.locationFilter);
        Map<String, List<PickListDetailsItem>> grouped = groupBy((pickListDetailsResponse.items.where((e) => e.status == tabName)).toList(), (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
        groupedPickedData = grouped.values.toList();
        getIt<Variables>().generalVariables.timelineInfo.clear();
        getIt<Variables>().generalVariables.timelineInfo.addAll(pickListDetailsResponse.timelineInfo);
        emit(PickListDetailsLoaded());
      } else {
        List<PickListDetailsResponse> finalData = pickListDetailsResponseBoxData.values.toList();
        pickListDetailsResponse = finalData.firstWhere((model) => model.picklistId == selectedPickListId);
        pickListDetailsResponse.alternateItems.clear();
        pickListDetailsResponse.alternateItems = getIt<Variables>().generalVariables.userData.filterItemsListOptions;
        getIt<Variables>().generalVariables.filters.add(pickListDetailsResponse.locationFilter);
        Map<String, List<PickListDetailsItem>> grouped = groupBy((pickListDetailsResponse.items.where((e) => e.status == tabName)).toList(), (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
        groupedPickedData = grouped.values.toList();
        getIt<Variables>().generalVariables.timelineInfo.clear();
        getIt<Variables>().generalVariables.timelineInfo.addAll(pickListDetailsResponse.timelineInfo);
        emit(PickListDetailsLoaded());
      }
    }
  }*/

  FutureOr<void> pickListDetailsTabChangingFunction(PickListDetailsTabChangingEvent event, Emitter<PickListDetailsState> emit) async {
    getIt<Variables>().generalVariables.picklistSocketTempStatus = tabName;
    event.isLoading ? null : emit(PickListDetailsListLoading());
    List<PickListDetailsItem> tabPickListItems = [];
    tabPickListItems.clear();
    tabPickListItems = (pickListDetailsResponse.items.where((e) => e.status == tabName)).toList();
    if (searchText.isNotEmpty) {
      tabPickListItems = tabPickListItems
          .where((x) =>
              x.itemCode.toLowerCase().contains(searchText.toLowerCase()) ||
              x.itemType.toLowerCase().contains(searchText.toLowerCase()) ||
              x.itemName.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
    List<PickListDetailsItem> filteredList = [];
    filteredList.addAll(tabPickListItems);
    for (int i = 0; i < getIt<Variables>().generalVariables.selectedFilters.length; i++) {
      switch (getIt<Variables>().generalVariables.selectedFilters[i].type) {
        case "item_type":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.itemType == item2))
                .toList();
          }
        case "so_num":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.soNum == item2))
                .toList();
          }
        case "floor":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.floor == item2))
                .toList();
          }
        case "item_code":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.itemCode == item2))
                .toList();
          }
        case "sort_by_location":
          {
            for (int j = 0; j < getIt<Variables>().generalVariables.selectedFilters[i].options.length; j++) {
              switch (getIt<Variables>().generalVariables.selectedFilters[i].options[j]) {
                case "1":
                  {
                    filteredList.sort((a, b) => a.floor.toLowerCase().compareTo(b.floor.toLowerCase()));
                  }
                case "-1":
                  {
                    filteredList.sort((a, b) => b.floor.toLowerCase().compareTo(a.floor.toLowerCase()));
                  }
                default:
                  {
                    filteredList.sort((a, b) => a.floor.toLowerCase().compareTo(b.floor.toLowerCase()));
                  }
              }
            }
            /*filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.itemCode == item2))
                .toList();*/
          }
        default:
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.itemType == item2))
                .toList();
          }
      }
    }
    tabPickListItems.clear();
    tabPickListItems.addAll(filteredList);
    switch (tabName) {
      case "Pending":
        {
          ///for picked list grouped by floor,room & zone
          Map<String, List<PickListDetailsItem>> grouped = groupBy(tabPickListItems, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
         // groupedPickedData = grouped.values.toList();
          groupedPickedData.clear();
          for(int i=0;i<grouped.values.toList().length;i++){
            groupedPickedData.add([]);
            List<PickListDetailsItem> firstGroupedPickedData = grouped.values.toList()[i];
            Map<String, List<PickListDetailsItem>> firstGroupedPickedDataGrouped = groupBy(firstGroupedPickedData, (PickListDetailsItem data) => data.itemId);
            List<List<PickListDetailsItem>> firstGroupedPickedDataGroupedList = firstGroupedPickedDataGrouped.values.toList();
            for(int j=0;j<firstGroupedPickedDataGroupedList.length;j++){
              List<PickListDetailsItem> firstFirstGroupedPickedDataGroupedList = firstGroupedPickedDataGroupedList[j];
              PickListDetailsItem selectedPickListItem = PickListDetailsItem(
                  id: firstFirstGroupedPickedDataGroupedList[0].id,
                  itemId: firstFirstGroupedPickedDataGroupedList[0].itemId,
                  picklistNum: firstFirstGroupedPickedDataGroupedList[0].picklistNum,
                  status: firstFirstGroupedPickedDataGroupedList[0].status,
                  itemCode: firstFirstGroupedPickedDataGroupedList[0].itemCode,
                  itemName: firstFirstGroupedPickedDataGroupedList[0].itemName,
                  quantity: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  pickedQty: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  uom: firstFirstGroupedPickedDataGroupedList[0].uom,
                  itemType: firstFirstGroupedPickedDataGroupedList[0].itemType,
                  typeColor: firstFirstGroupedPickedDataGroupedList[0].typeColor,
                  floor: firstFirstGroupedPickedDataGroupedList[0].floor,
                  room: firstFirstGroupedPickedDataGroupedList[0].room,
                  zone: firstFirstGroupedPickedDataGroupedList[0].zone,
                  stagingArea: firstFirstGroupedPickedDataGroupedList[0].stagingArea,
                  isProgressStatus: firstFirstGroupedPickedDataGroupedList[0].isProgressStatus,
                  packageTerms: firstFirstGroupedPickedDataGroupedList[0].packageTerms,
                  catchWeightStatus: firstFirstGroupedPickedDataGroupedList[0].catchWeightStatus,
                  catchWeightInfo: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfo,
                  catchWeightInfoForList: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoForList,
                  catchWeightInfoPicked: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoPicked,
                  handledBy: firstFirstGroupedPickedDataGroupedList[0].handledBy,
                  locationDisputeInfo: firstFirstGroupedPickedDataGroupedList[0].locationDisputeInfo,
                  unavailableReason: firstFirstGroupedPickedDataGroupedList[0].unavailableReason,
                  alternativeItemName: firstFirstGroupedPickedDataGroupedList[0].alternativeItemName,
                  alternativeItemCode: firstFirstGroupedPickedDataGroupedList[0].alternativeItemCode,
                  batchesList: List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>firstFirstGroupedPickedDataGroupedList[i].batchesList[0]),
                  allowUndo: firstFirstGroupedPickedDataGroupedList[0].allowUndo,
                  soNum: firstFirstGroupedPickedDataGroupedList[0].soNum);
              groupedPickedData[i].add(selectedPickListItem);
            }
          }
          //await getTabsCountData();
        }
      case "Picked":
        {
          ///for picked list grouped by floor & staging area
          List<PickListDetailsItem> pickedList = (tabPickListItems.where((element) => !element.isProgressStatus).toList());
          Map<String, List<PickListDetailsItem>> pickedGroup = groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
          //groupedPickedData = pickedGroup.values.toList();
          groupedPickedData.clear();
          for(int i=0;i<pickedGroup.values.toList().length;i++){
            groupedPickedData.add([]);
            List<PickListDetailsItem> firstGroupedPickedData = pickedGroup.values.toList()[i];
            Map<String, List<PickListDetailsItem>> firstGroupedPickedDataGrouped = groupBy(firstGroupedPickedData, (PickListDetailsItem data) => data.itemId);
            List<List<PickListDetailsItem>> firstGroupedPickedDataGroupedList = firstGroupedPickedDataGrouped.values.toList();
            for(int j=0;j<firstGroupedPickedDataGroupedList.length;j++){
              List<PickListDetailsItem> firstFirstGroupedPickedDataGroupedList = firstGroupedPickedDataGroupedList[j];
              PickListDetailsItem selectedPickListItem = PickListDetailsItem(
                  id: firstFirstGroupedPickedDataGroupedList[0].id,
                  itemId: firstFirstGroupedPickedDataGroupedList[0].itemId,
                  picklistNum: firstFirstGroupedPickedDataGroupedList[0].picklistNum,
                  status: firstFirstGroupedPickedDataGroupedList[0].status,
                  itemCode: firstFirstGroupedPickedDataGroupedList[0].itemCode,
                  itemName: firstFirstGroupedPickedDataGroupedList[0].itemName,
                  quantity: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  pickedQty: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  uom: firstFirstGroupedPickedDataGroupedList[0].uom,
                  itemType: firstFirstGroupedPickedDataGroupedList[0].itemType,
                  typeColor: firstFirstGroupedPickedDataGroupedList[0].typeColor,
                  floor: firstFirstGroupedPickedDataGroupedList[0].floor,
                  room: firstFirstGroupedPickedDataGroupedList[0].room,
                  zone: firstFirstGroupedPickedDataGroupedList[0].zone,
                  stagingArea: firstFirstGroupedPickedDataGroupedList[0].stagingArea,
                  isProgressStatus: firstFirstGroupedPickedDataGroupedList[0].isProgressStatus,
                  packageTerms: firstFirstGroupedPickedDataGroupedList[0].packageTerms,
                  catchWeightStatus: firstFirstGroupedPickedDataGroupedList[0].catchWeightStatus,
                  catchWeightInfo: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfo,
                  catchWeightInfoForList: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoForList,
                  catchWeightInfoPicked: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoPicked,
                  handledBy: firstFirstGroupedPickedDataGroupedList[0].handledBy,
                  locationDisputeInfo: firstFirstGroupedPickedDataGroupedList[0].locationDisputeInfo,
                  unavailableReason: firstFirstGroupedPickedDataGroupedList[0].unavailableReason,
                  alternativeItemName: firstFirstGroupedPickedDataGroupedList[0].alternativeItemName,
                  alternativeItemCode: firstFirstGroupedPickedDataGroupedList[0].alternativeItemCode,
                  batchesList: List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>firstFirstGroupedPickedDataGroupedList[i].batchesList[0]),
                  allowUndo: firstFirstGroupedPickedDataGroupedList[0].allowUndo,
                  soNum: firstFirstGroupedPickedDataGroupedList[0].soNum);
              groupedPickedData[i].add(selectedPickListItem);
            }
          }

          ///for picking in progress list grouped by storekeeper
          List<PickListDetailsItem> pickingList = (tabPickListItems.where((element) => element.isProgressStatus).toList());
          Map<String, List<PickListDetailsItem>> groupedData = {};
          for (PickListDetailsItem item in pickingList) {
            List<HandledByPickList> handledBy = item.handledBy;
            for (HandledByPickList handler in handledBy) {
              String name = handler.name;
              if (!groupedData.containsKey(name)) {
                groupedData[name] = [];
              }
              groupedData[name]!.add(item);
            }
          }
          groupedKeepersNameList = groupedData.keys.toList();
          //groupedPickingData = groupedData.values.toList();
          groupedPickingData.clear();
          for(int i=0;i<groupedData.values.toList().length;i++){
            groupedPickingData.add([]);
            List<PickListDetailsItem> firstGroupedPickingData = groupedData.values.toList()[i];
            Map<String, List<PickListDetailsItem>> firstGroupedPickingDataGrouped = groupBy(firstGroupedPickingData, (PickListDetailsItem data) => data.itemId);
            List<List<PickListDetailsItem>> firstGroupedPickingDataGroupedList = firstGroupedPickingDataGrouped.values.toList();
            for(int j=0;j<firstGroupedPickingDataGroupedList.length;j++){
              List<PickListDetailsItem> firstFirstGroupedPickingDataGroupedList = firstGroupedPickingDataGroupedList[j];
              PickListDetailsItem selectedPickListItem = PickListDetailsItem(
                  id: firstFirstGroupedPickingDataGroupedList[0].id,
                  itemId: firstFirstGroupedPickingDataGroupedList[0].itemId,
                  picklistNum: firstFirstGroupedPickingDataGroupedList[0].picklistNum,
                  status: firstFirstGroupedPickingDataGroupedList[0].status,
                  itemCode: firstFirstGroupedPickingDataGroupedList[0].itemCode,
                  itemName: firstFirstGroupedPickingDataGroupedList[0].itemName,
                  quantity: ((List.generate(firstFirstGroupedPickingDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickingDataGroupedList[i].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  pickedQty: ((List.generate(firstFirstGroupedPickingDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickingDataGroupedList[i].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  uom: firstFirstGroupedPickingDataGroupedList[0].uom,
                  itemType: firstFirstGroupedPickingDataGroupedList[0].itemType,
                  typeColor: firstFirstGroupedPickingDataGroupedList[0].typeColor,
                  floor: firstFirstGroupedPickingDataGroupedList[0].floor,
                  room: firstFirstGroupedPickingDataGroupedList[0].room,
                  zone: firstFirstGroupedPickingDataGroupedList[0].zone,
                  stagingArea: firstFirstGroupedPickingDataGroupedList[0].stagingArea,
                  isProgressStatus: firstFirstGroupedPickingDataGroupedList[0].isProgressStatus,
                  packageTerms: firstFirstGroupedPickingDataGroupedList[0].packageTerms,
                  catchWeightStatus: firstFirstGroupedPickingDataGroupedList[0].catchWeightStatus,
                  catchWeightInfo: firstFirstGroupedPickingDataGroupedList[0].catchWeightInfo,
                  catchWeightInfoForList: firstFirstGroupedPickingDataGroupedList[0].catchWeightInfoForList,
                  catchWeightInfoPicked: firstFirstGroupedPickingDataGroupedList[0].catchWeightInfoPicked,
                  handledBy: firstFirstGroupedPickingDataGroupedList[0].handledBy,
                  locationDisputeInfo: firstFirstGroupedPickingDataGroupedList[0].locationDisputeInfo,
                  unavailableReason: firstFirstGroupedPickingDataGroupedList[0].unavailableReason,
                  alternativeItemName: firstFirstGroupedPickingDataGroupedList[0].alternativeItemName,
                  alternativeItemCode: firstFirstGroupedPickingDataGroupedList[0].alternativeItemCode,
                  batchesList: List.generate(firstFirstGroupedPickingDataGroupedList.length, (i)=>firstFirstGroupedPickingDataGroupedList[i].batchesList[0]),
                  allowUndo: firstFirstGroupedPickingDataGroupedList[0].allowUndo,
                  soNum: firstFirstGroupedPickingDataGroupedList[0].soNum);
              groupedPickingData[i].add(selectedPickListItem);
            }
          }
         // await getTabsCountData();
        }
      case "Partial":
        {
          ///for picked list grouped by floor & staging area
          List<PickListDetailsItem> pickedList = (tabPickListItems.where((element) => !element.isProgressStatus).toList());
          Map<String, List<PickListDetailsItem>> pickedGroup = groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
          //groupedPickedData = pickedGroup.values.toList();
          groupedPickedData.clear();
          for(int i=0;i<pickedGroup.values.toList().length;i++){
            groupedPickedData.add([]);
            List<PickListDetailsItem> firstGroupedPickedData = pickedGroup.values.toList()[i];
            Map<String, List<PickListDetailsItem>> firstGroupedPickedDataGrouped = groupBy(firstGroupedPickedData, (PickListDetailsItem data) => data.itemId);
            List<List<PickListDetailsItem>> firstGroupedPickedDataGroupedList = firstGroupedPickedDataGrouped.values.toList();
            for(int j=0;j<firstGroupedPickedDataGroupedList.length;j++){
              List<PickListDetailsItem> firstFirstGroupedPickedDataGroupedList = firstGroupedPickedDataGroupedList[j];
              PickListDetailsItem selectedPickListItem = PickListDetailsItem(
                  id: firstFirstGroupedPickedDataGroupedList[0].id,
                  itemId: firstFirstGroupedPickedDataGroupedList[0].itemId,
                  picklistNum: firstFirstGroupedPickedDataGroupedList[0].picklistNum,
                  status: firstFirstGroupedPickedDataGroupedList[0].status,
                  itemCode: firstFirstGroupedPickedDataGroupedList[0].itemCode,
                  itemName: firstFirstGroupedPickedDataGroupedList[0].itemName,
                  quantity: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  pickedQty: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  uom: firstFirstGroupedPickedDataGroupedList[0].uom,
                  itemType: firstFirstGroupedPickedDataGroupedList[0].itemType,
                  typeColor: firstFirstGroupedPickedDataGroupedList[0].typeColor,
                  floor: firstFirstGroupedPickedDataGroupedList[0].floor,
                  room: firstFirstGroupedPickedDataGroupedList[0].room,
                  zone: firstFirstGroupedPickedDataGroupedList[0].zone,
                  stagingArea: firstFirstGroupedPickedDataGroupedList[0].stagingArea,
                  isProgressStatus: firstFirstGroupedPickedDataGroupedList[0].isProgressStatus,
                  packageTerms: firstFirstGroupedPickedDataGroupedList[0].packageTerms,
                  catchWeightStatus: firstFirstGroupedPickedDataGroupedList[0].catchWeightStatus,
                  catchWeightInfo: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfo,
                  catchWeightInfoForList: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoForList,
                  catchWeightInfoPicked: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoPicked,
                  handledBy: firstFirstGroupedPickedDataGroupedList[0].handledBy,
                  locationDisputeInfo: firstFirstGroupedPickedDataGroupedList[0].locationDisputeInfo,
                  unavailableReason: firstFirstGroupedPickedDataGroupedList[0].unavailableReason,
                  alternativeItemName: firstFirstGroupedPickedDataGroupedList[0].alternativeItemName,
                  alternativeItemCode: firstFirstGroupedPickedDataGroupedList[0].alternativeItemCode,
                  batchesList: List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>firstFirstGroupedPickedDataGroupedList[i].batchesList[0]),
                  allowUndo: firstFirstGroupedPickedDataGroupedList[0].allowUndo,
                  soNum: firstFirstGroupedPickedDataGroupedList[0].soNum);
              groupedPickedData[i].add(selectedPickListItem);
            }
          }

          ///for picking in progress list grouped by storekeeper
          List<PickListDetailsItem> pickingList = (tabPickListItems.where((element) => element.isProgressStatus).toList());
          Map<String, List<PickListDetailsItem>> groupedData = {};
          for (PickListDetailsItem item in pickingList) {
            List<HandledByPickList> handledBy = item.handledBy;
            for (HandledByPickList handler in handledBy) {
              String name = handler.name;
              if (!groupedData.containsKey(name)) {
                groupedData[name] = [];
              }
              groupedData[name]!.add(item);
            }
          }
          groupedKeepersNameList = groupedData.keys.toList();
          //groupedPickingData = groupedData.values.toList();
          groupedPickingData.clear();
          for(int i=0;i<groupedData.values.toList().length;i++){
            groupedPickingData.add([]);
            List<PickListDetailsItem> firstGroupedPickingData = groupedData.values.toList()[i];
            Map<String, List<PickListDetailsItem>> firstGroupedPickingDataGrouped = groupBy(firstGroupedPickingData, (PickListDetailsItem data) => data.itemId);
            List<List<PickListDetailsItem>> firstGroupedPickingDataGroupedList = firstGroupedPickingDataGrouped.values.toList();
            for(int j=0;j<firstGroupedPickingDataGroupedList.length;j++){
              List<PickListDetailsItem> firstFirstGroupedPickingDataGroupedList = firstGroupedPickingDataGroupedList[j];
              PickListDetailsItem selectedPickListItem = PickListDetailsItem(
                  id: firstFirstGroupedPickingDataGroupedList[0].id,
                  itemId: firstFirstGroupedPickingDataGroupedList[0].itemId,
                  picklistNum: firstFirstGroupedPickingDataGroupedList[0].picklistNum,
                  status: firstFirstGroupedPickingDataGroupedList[0].status,
                  itemCode: firstFirstGroupedPickingDataGroupedList[0].itemCode,
                  itemName: firstFirstGroupedPickingDataGroupedList[0].itemName,
                  quantity: ((List.generate(firstFirstGroupedPickingDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickingDataGroupedList[i].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  pickedQty: ((List.generate(firstFirstGroupedPickingDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickingDataGroupedList[i].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  uom: firstFirstGroupedPickingDataGroupedList[0].uom,
                  itemType: firstFirstGroupedPickingDataGroupedList[0].itemType,
                  typeColor: firstFirstGroupedPickingDataGroupedList[0].typeColor,
                  floor: firstFirstGroupedPickingDataGroupedList[0].floor,
                  room: firstFirstGroupedPickingDataGroupedList[0].room,
                  zone: firstFirstGroupedPickingDataGroupedList[0].zone,
                  stagingArea: firstFirstGroupedPickingDataGroupedList[0].stagingArea,
                  isProgressStatus: firstFirstGroupedPickingDataGroupedList[0].isProgressStatus,
                  packageTerms: firstFirstGroupedPickingDataGroupedList[0].packageTerms,
                  catchWeightStatus: firstFirstGroupedPickingDataGroupedList[0].catchWeightStatus,
                  catchWeightInfo: firstFirstGroupedPickingDataGroupedList[0].catchWeightInfo,
                  catchWeightInfoForList: firstFirstGroupedPickingDataGroupedList[0].catchWeightInfoForList,
                  catchWeightInfoPicked: firstFirstGroupedPickingDataGroupedList[0].catchWeightInfoPicked,
                  handledBy: firstFirstGroupedPickingDataGroupedList[0].handledBy,
                  locationDisputeInfo: firstFirstGroupedPickingDataGroupedList[0].locationDisputeInfo,
                  unavailableReason: firstFirstGroupedPickingDataGroupedList[0].unavailableReason,
                  alternativeItemName: firstFirstGroupedPickingDataGroupedList[0].alternativeItemName,
                  alternativeItemCode: firstFirstGroupedPickingDataGroupedList[0].alternativeItemCode,
                  batchesList: List.generate(firstFirstGroupedPickingDataGroupedList.length, (i)=>firstFirstGroupedPickingDataGroupedList[i].batchesList[0]),
                  allowUndo: firstFirstGroupedPickingDataGroupedList[0].allowUndo,
                  soNum: firstFirstGroupedPickingDataGroupedList[0].soNum);
              groupedPickingData[i].add(selectedPickListItem);
            }
          }
         // await getTabsCountData();
        }
      case "Unavailable":
        {
          ///for picked list grouped by floor
          Map<String, List<PickListDetailsItem>> grouped = groupBy(tabPickListItems, (PickListDetailsItem item) => item.floor);
          //groupedPickedData = grouped.values.toList();
          groupedPickedData.clear();
          for(int i=0;i<grouped.values.toList().length;i++){
            groupedPickedData.add([]);
            List<PickListDetailsItem> firstGroupedPickedData = grouped.values.toList()[i];
            Map<String, List<PickListDetailsItem>> firstGroupedPickedDataGrouped = groupBy(firstGroupedPickedData, (PickListDetailsItem data) => data.itemId);
            List<List<PickListDetailsItem>> firstGroupedPickedDataGroupedList = firstGroupedPickedDataGrouped.values.toList();
            for(int j=0;j<firstGroupedPickedDataGroupedList.length;j++){
              List<PickListDetailsItem> firstFirstGroupedPickedDataGroupedList = firstGroupedPickedDataGroupedList[j];
              PickListDetailsItem selectedPickListItem = PickListDetailsItem(
                  id: firstFirstGroupedPickedDataGroupedList[0].id,
                  itemId: firstFirstGroupedPickedDataGroupedList[0].itemId,
                  picklistNum: firstFirstGroupedPickedDataGroupedList[0].picklistNum,
                  status: firstFirstGroupedPickedDataGroupedList[0].status,
                  itemCode: firstFirstGroupedPickedDataGroupedList[0].itemCode,
                  itemName: firstFirstGroupedPickedDataGroupedList[0].itemName,
                  quantity: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  pickedQty: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  uom: firstFirstGroupedPickedDataGroupedList[0].uom,
                  itemType: firstFirstGroupedPickedDataGroupedList[0].itemType,
                  typeColor: firstFirstGroupedPickedDataGroupedList[0].typeColor,
                  floor: firstFirstGroupedPickedDataGroupedList[0].floor,
                  room: firstFirstGroupedPickedDataGroupedList[0].room,
                  zone: firstFirstGroupedPickedDataGroupedList[0].zone,
                  stagingArea: firstFirstGroupedPickedDataGroupedList[0].stagingArea,
                  isProgressStatus: firstFirstGroupedPickedDataGroupedList[0].isProgressStatus,
                  packageTerms: firstFirstGroupedPickedDataGroupedList[0].packageTerms,
                  catchWeightStatus: firstFirstGroupedPickedDataGroupedList[0].catchWeightStatus,
                  catchWeightInfo: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfo,
                  catchWeightInfoForList: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoForList,
                  catchWeightInfoPicked: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoPicked,
                  handledBy: firstFirstGroupedPickedDataGroupedList[0].handledBy,
                  locationDisputeInfo: firstFirstGroupedPickedDataGroupedList[0].locationDisputeInfo,
                  unavailableReason: firstFirstGroupedPickedDataGroupedList[0].unavailableReason,
                  alternativeItemName: firstFirstGroupedPickedDataGroupedList[0].alternativeItemName,
                  alternativeItemCode: firstFirstGroupedPickedDataGroupedList[0].alternativeItemCode,
                  batchesList: List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>firstFirstGroupedPickedDataGroupedList[i].batchesList[0]),
                  allowUndo: firstFirstGroupedPickedDataGroupedList[0].allowUndo,
                  soNum: firstFirstGroupedPickedDataGroupedList[0].soNum);
              groupedPickedData[i].add(selectedPickListItem);
            }
          }
        //  await getTabsCountData();
        }
      default:
        {
          ///for picked list grouped by floor,room & zone
          Map<String, List<PickListDetailsItem>> grouped =
              groupBy(tabPickListItems, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
          //groupedPickedData = grouped.values.toList();
          groupedPickedData.clear();
          for(int i=0;i<grouped.values.toList().length;i++){
            groupedPickedData.add([]);
            List<PickListDetailsItem> firstGroupedPickedData = grouped.values.toList()[i];
            Map<String, List<PickListDetailsItem>> firstGroupedPickedDataGrouped = groupBy(firstGroupedPickedData, (PickListDetailsItem data) => data.itemId);
            List<List<PickListDetailsItem>> firstGroupedPickedDataGroupedList = firstGroupedPickedDataGrouped.values.toList();
            for(int j=0;j<firstGroupedPickedDataGroupedList.length;j++){
              List<PickListDetailsItem> firstFirstGroupedPickedDataGroupedList = firstGroupedPickedDataGroupedList[j];
              PickListDetailsItem selectedPickListItem = PickListDetailsItem(
                  id: firstFirstGroupedPickedDataGroupedList[0].id,
                  itemId: firstFirstGroupedPickedDataGroupedList[0].itemId,
                  picklistNum: firstFirstGroupedPickedDataGroupedList[0].picklistNum,
                  status: firstFirstGroupedPickedDataGroupedList[0].status,
                  itemCode: firstFirstGroupedPickedDataGroupedList[0].itemCode,
                  itemName: firstFirstGroupedPickedDataGroupedList[0].itemName,
                  quantity: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  pickedQty: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  uom: firstFirstGroupedPickedDataGroupedList[0].uom,
                  itemType: firstFirstGroupedPickedDataGroupedList[0].itemType,
                  typeColor: firstFirstGroupedPickedDataGroupedList[0].typeColor,
                  floor: firstFirstGroupedPickedDataGroupedList[0].floor,
                  room: firstFirstGroupedPickedDataGroupedList[0].room,
                  zone: firstFirstGroupedPickedDataGroupedList[0].zone,
                  stagingArea: firstFirstGroupedPickedDataGroupedList[0].stagingArea,
                  isProgressStatus: firstFirstGroupedPickedDataGroupedList[0].isProgressStatus,
                  packageTerms: firstFirstGroupedPickedDataGroupedList[0].packageTerms,
                  catchWeightStatus: firstFirstGroupedPickedDataGroupedList[0].catchWeightStatus,
                  catchWeightInfo: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfo,
                  catchWeightInfoForList: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoForList,
                  catchWeightInfoPicked: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoPicked,
                  handledBy: firstFirstGroupedPickedDataGroupedList[0].handledBy,
                  locationDisputeInfo: firstFirstGroupedPickedDataGroupedList[0].locationDisputeInfo,
                  unavailableReason: firstFirstGroupedPickedDataGroupedList[0].unavailableReason,
                  alternativeItemName: firstFirstGroupedPickedDataGroupedList[0].alternativeItemName,
                  alternativeItemCode: firstFirstGroupedPickedDataGroupedList[0].alternativeItemCode,
                  batchesList: List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>firstFirstGroupedPickedDataGroupedList[i].batchesList[0]),
                  allowUndo: firstFirstGroupedPickedDataGroupedList[0].allowUndo,
                  soNum: firstFirstGroupedPickedDataGroupedList[0].soNum);
              groupedPickedData[i].add(selectedPickListItem);
            }
          }
         // await getTabsCountData();
        }
    }
    emit(PickListDetailsDummy());
    emit(PickListDetailsLoaded());
  }

  ///primary
  /*FutureOr<void> pickListDetailsTabChangingFunction(PickListDetailsTabChangingEvent event, Emitter<PickListDetailsState> emit) async {
    getIt<Variables>().generalVariables.picklistSocketTempStatus = tabName;
    if (listCancelToken != null && !listCancelToken!.isCancelled) {
      listCancelToken?.cancel("Previous requests canceled.");
    }
    listCancelToken = CancelToken();
    event.isLoading ? null : emit(PickListDetailsListLoading());
    await getIt<Variables>().repoImpl.getPickListDetails(query: {
      "picklist_id": selectedPickListId,
      "search": searchText,
      "page": pageIndex,
      "status": tabName,
      "filters": List.generate(
          getIt<Variables>().generalVariables.selectedFilters.length, (i) => getIt<Variables>().generalVariables.selectedFilters[i].toJson())
    }, method: "post", globalCancelToken: listCancelToken).onError((error, stackTrace) {
      if (!event.isLoading) {
        pickListDetailsResponse = PickListDetailsResponse.fromJson({});
      }
      emit(PickListDetailsError(message: error.toString()));
      event.isLoading ? emit(PickListDetailsLoaded()) : emit(PickListDetailsListLoading());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          PickListDetailsModel pickListDetailsModel = PickListDetailsModel.fromJson(value);
          if (event.isLoading) {
            pickListDetailsResponse.items.addAll(pickListDetailsModel.response.items);
          } else {
            pickListDetailsResponse = pickListDetailsModel.response;
            pickListDetailsResponse.alternateItems.clear();
            pickListDetailsResponse.alternateItems = getIt<Variables>().generalVariables.userData.filterItemsListOptions;
          }
          getIt<Variables>().generalVariables.timelineInfo.clear();
          getIt<Variables>().generalVariables.timelineInfo.addAll(pickListDetailsResponse.timelineInfo);
          switch (tabName) {
            case "Pending":
              {
                ///for picked list grouped by floor,room & zone
                Map<String, List<PickListDetailsItem>> grouped =
                    groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
                groupedPickedData = grouped.values.toList();
              }
            case "Picked":
              {
                ///for picked list grouped by floor & staging area
                List<PickListDetailsItem> pickedList = pickListDetailsResponse.items.where((element) => !element.isProgressStatus).toList();
                Map<String, List<PickListDetailsItem>> pickedGroup =
                    groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
                groupedPickedData = pickedGroup.values.toList();

                ///for picking in progress list grouped by storekeeper
                List<PickListDetailsItem> pickingList = pickListDetailsResponse.items.where((element) => element.isProgressStatus).toList();
                Map<String, List<PickListDetailsItem>> groupedData = {};
                for (PickListDetailsItem item in pickingList) {
                  List<HandledByPickList> handledBy = item.handledBy;
                  for (HandledByPickList handler in handledBy) {
                    String name = handler.name;
                    if (!groupedData.containsKey(name)) {
                      groupedData[name] = [];
                    }
                    groupedData[name]!.add(item);
                  }
                }
                groupedKeepersNameList = groupedData.keys.toList();
                groupedPickingData = groupedData.values.toList();
              }
            case "Partial":
              {
                ///for picked list grouped by floor & staging area
                List<PickListDetailsItem> pickedList = pickListDetailsResponse.items.where((element) => !element.isProgressStatus).toList();
                Map<String, List<PickListDetailsItem>> pickedGroup =
                    groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
                groupedPickedData = pickedGroup.values.toList();

                ///for picking in progress list grouped by storekeeper
                List<PickListDetailsItem> pickingList = pickListDetailsResponse.items.where((element) => element.isProgressStatus).toList();
                Map<String, List<PickListDetailsItem>> groupedData = {};
                for (PickListDetailsItem item in pickingList) {
                  List<HandledByPickList> handledBy = item.handledBy;
                  for (HandledByPickList handler in handledBy) {
                    String name = handler.name;
                    if (!groupedData.containsKey(name)) {
                      groupedData[name] = [];
                    }
                    groupedData[name]!.add(item);
                  }
                }
                groupedKeepersNameList = groupedData.keys.toList();
                groupedPickingData = groupedData.values.toList();
              }
            case "Unavailable":
              {
                ///for picked list grouped by floor
                Map<String, List<PickListDetailsItem>> grouped = groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => item.floor);
                groupedPickedData = grouped.values.toList();
              }
            default:
              {
                ///for picked list grouped by floor,room & zone
                Map<String, List<PickListDetailsItem>> grouped =
                    groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
                groupedPickedData = grouped.values.toList();
              }
          }
          emit(PickListDetailsLoaded());
        } else {
          emit(PickListDetailsError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          event.isLoading ? emit(PickListDetailsLoaded()) : emit(PickListDetailsListLoading());
        }
      }
    });
  }*/

  ///secondary
  /*FutureOr<void> pickListDetailsTabChangingFunction(PickListDetailsTabChangingEvent event, Emitter<PickListDetailsState> emit) async {
    getIt<Variables>().generalVariables.picklistSocketTempStatus = tabName;
    if (listCancelToken != null && !listCancelToken!.isCancelled) {
      listCancelToken?.cancel("Previous requests canceled.");
    }
    listCancelToken = CancelToken();
    event.isLoading ? null : emit(PickListDetailsListLoading());
    if (!getIt<Variables>().generalVariables.isNetworkOffline) {
      await getIt<Variables>().repoImpl.getPickListDetails(query: {
        "picklist_id": selectedPickListId,
        "search": searchText,
        "page": pageIndex,
        "status": tabName,
        "filters": List.generate(getIt<Variables>().generalVariables.selectedFilters.length, (i) => getIt<Variables>().generalVariables.selectedFilters[i].toJson())
      }, method: "post", globalCancelToken: listCancelToken).onError((error, stackTrace) {
        if (!event.isLoading) {
          pickListDetailsResponse = PickListDetailsResponse.fromJson({});
        }
        emit(PickListDetailsError(message: error.toString()));
        event.isLoading ? emit(PickListDetailsLoaded()) : emit(PickListDetailsListLoading());
      }).then((value) async {
        if (value != null) {
          if (value["status"] == "1") {
            PickListDetailsModel pickListDetailsModel = PickListDetailsModel.fromJson(value);
            if (event.isLoading) {
              pickListDetailsResponse.items.addAll(pickListDetailsModel.response.items);
            } else {
              pickListDetailsResponse = pickListDetailsModel.response;
              pickListDetailsResponse.alternateItems.clear();
              pickListDetailsResponse.alternateItems = getIt<Variables>().generalVariables.userData.filterItemsListOptions;
            }
            getIt<Variables>().generalVariables.timelineInfo.clear();
            getIt<Variables>().generalVariables.timelineInfo.addAll(pickListDetailsResponse.timelineInfo);
            switch (tabName) {
              case "Pending":
                {
                  ///for picked list grouped by floor,room & zone
                  Map<String, List<PickListDetailsItem>> grouped = groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
                  groupedPickedData = grouped.values.toList();
                }
              case "Picked":
                {
                  ///for picked list grouped by floor & staging area
                  List<PickListDetailsItem> pickedList = pickListDetailsResponse.items.where((element) => !element.isProgressStatus).toList();
                  Map<String, List<PickListDetailsItem>> pickedGroup = groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
                  groupedPickedData = pickedGroup.values.toList();

                  ///for picking in progress list grouped by storekeeper
                  List<PickListDetailsItem> pickingList = pickListDetailsResponse.items.where((element) => element.isProgressStatus).toList();
                  Map<String, List<PickListDetailsItem>> groupedData = {};
                  for (PickListDetailsItem item in pickingList) {
                    List<HandledByPickList> handledBy = item.handledBy;
                    for (HandledByPickList handler in handledBy) {
                      String name = handler.name;
                      if (!groupedData.containsKey(name)) {
                        groupedData[name] = [];
                      }
                      groupedData[name]!.add(item);
                    }
                  }
                  groupedKeepersNameList = groupedData.keys.toList();
                  groupedPickingData = groupedData.values.toList();
                }
              case "Partial":
                {
                  ///for picked list grouped by floor & staging area
                  List<PickListDetailsItem> pickedList = pickListDetailsResponse.items.where((element) => !element.isProgressStatus).toList();
                  Map<String, List<PickListDetailsItem>> pickedGroup = groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
                  groupedPickedData = pickedGroup.values.toList();

                  ///for picking in progress list grouped by storekeeper
                  List<PickListDetailsItem> pickingList = pickListDetailsResponse.items.where((element) => element.isProgressStatus).toList();
                  Map<String, List<PickListDetailsItem>> groupedData = {};
                  for (PickListDetailsItem item in pickingList) {
                    List<HandledByPickList> handledBy = item.handledBy;
                    for (HandledByPickList handler in handledBy) {
                      String name = handler.name;
                      if (!groupedData.containsKey(name)) {
                        groupedData[name] = [];
                      }
                      groupedData[name]!.add(item);
                    }
                  }
                  groupedKeepersNameList = groupedData.keys.toList();
                  groupedPickingData = groupedData.values.toList();
                }
              case "Unavailable":
                {
                  ///for picked list grouped by floor
                  Map<String, List<PickListDetailsItem>> grouped = groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => item.floor);
                  groupedPickedData = grouped.values.toList();
                }
              default:
                {
                  ///for picked list grouped by floor,room & zone
                  Map<String, List<PickListDetailsItem>> grouped = groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
                  groupedPickedData = grouped.values.toList();
                }
            }
            emit(PickListDetailsLoaded());
          } else {
            emit(PickListDetailsError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
            event.isLoading ? emit(PickListDetailsLoaded()) : emit(PickListDetailsListLoading());
          }
        }
      });
    }
    else {
      Box<PickListDetailsResponse> pickListDetailsResponseBoxData = await Hive.openBox<PickListDetailsResponse>('pick_list_details_response');
      List<PickListDetailsResponse> finalData = pickListDetailsResponseBoxData.values.toList();
      pickListDetailsResponse = finalData.firstWhere((model) => model.picklistId == selectedPickListId);
      pickListDetailsResponse.alternateItems.clear();
      pickListDetailsResponse.alternateItems = getIt<Variables>().generalVariables.userData.filterItemsListOptions;
      getIt<Variables>().generalVariables.filters.add(pickListDetailsResponse.locationFilter);
      switch (tabName) {
        case "Pending":
          {
            ///for picked list grouped by floor,room & zone
            Map<String, List<PickListDetailsItem>> grouped = groupBy((pickListDetailsResponse.items.where((e) => e.status == tabName)).toList(), (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
            groupedPickedData = grouped.values.toList();
          }
        case "Picked":
          {
            ///for picked list grouped by floor & staging area
            List<PickListDetailsItem> pickedList = ((pickListDetailsResponse.items.where((e) => e.status == tabName)).toList()).where((element) => !element.isProgressStatus).toList();
            Map<String, List<PickListDetailsItem>> pickedGroup = groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
            groupedPickedData = pickedGroup.values.toList();

            ///for picking in progress list grouped by storekeeper
            List<PickListDetailsItem> pickingList = ((pickListDetailsResponse.items.where((e) => e.status == tabName)).toList()).where((element) => element.isProgressStatus).toList();
            Map<String, List<PickListDetailsItem>> groupedData = {};
            for (PickListDetailsItem item in pickingList) {
              List<HandledByPickList> handledBy = item.handledBy;
              for (HandledByPickList handler in handledBy) {
                String name = handler.name;
                if (!groupedData.containsKey(name)) {
                  groupedData[name] = [];
                }
                groupedData[name]!.add(item);
              }
            }
            groupedKeepersNameList = groupedData.keys.toList();
            groupedPickingData = groupedData.values.toList();
          }
        case "Partial":
          {
            ///for picked list grouped by floor & staging area
            List<PickListDetailsItem> pickedList = ((pickListDetailsResponse.items.where((e) => e.status == tabName)).toList()).where((element) => !element.isProgressStatus).toList();
            Map<String, List<PickListDetailsItem>> pickedGroup = groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
            groupedPickedData = pickedGroup.values.toList();

            ///for picking in progress list grouped by storekeeper
            List<PickListDetailsItem> pickingList = ((pickListDetailsResponse.items.where((e) => e.status == tabName)).toList()).where((element) => element.isProgressStatus).toList();
            Map<String, List<PickListDetailsItem>> groupedData = {};
            for (PickListDetailsItem item in pickingList) {
              List<HandledByPickList> handledBy = item.handledBy;
              for (HandledByPickList handler in handledBy) {
                String name = handler.name;
                if (!groupedData.containsKey(name)) {
                  groupedData[name] = [];
                }
                groupedData[name]!.add(item);
              }
            }
            groupedKeepersNameList = groupedData.keys.toList();
            groupedPickingData = groupedData.values.toList();
          }
        case "Unavailable":
          {
            ///for picked list grouped by floor
            Map<String, List<PickListDetailsItem>> grouped = groupBy((pickListDetailsResponse.items.where((e) => e.status == tabName)).toList(), (PickListDetailsItem item) => item.floor);
            groupedPickedData = grouped.values.toList();
          }
        default:
          {
            ///for picked list grouped by floor,room & zone
            Map<String, List<PickListDetailsItem>> grouped = groupBy((pickListDetailsResponse.items.where((e) => e.status == tabName)).toList(), (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
            groupedPickedData = grouped.values.toList();
          }
      }
      emit(PickListDetailsLoaded());
    }
  }*/

  FutureOr<void> pickListDetailsSetStateFunction(PickListDetailsSetStateEvent event, Emitter<PickListDetailsState> emit) async {
    emit(PickListDetailsDummy());
    event.stillLoading ? emit(PickListDetailsLoading()) : emit(PickListDetailsLoaded());
  }

  FutureOr<void> pickListDetailsPickedFunction(PickListDetailsPickedEvent event, Emitter<PickListDetailsState> emit) async {
    String responseValue = await apiCalls(queryData: {
      "activity": "picked",
      "query_data": {
        "picklist_id": selectedPickListId,
        "picklist_item_id": selectedPickListItemId,
        "item_id": selectedItemId,
        "picked_qty": pickedQuantityData,
        "catchweight_qty": pickedCatchWeightData.join(",")
      }
    }, controllersList: event.controllersList, sessionTime: "");
    //await filterItemFunction();
    /*String responseValue ="success";
    pickedItemFunction();*/
    responseValue != ""
        ? emit(PickListDetailsError(message: responseValue))
        : emit(PickListDetailsSuccess(message: getIt<Variables>().generalVariables.currentLanguage.itemPickSuccess, isUndo: false));
    emit(PickListDetailsLoaded());
  }

  FutureOr<void> pickListDetailsUndoPickedFunction(PickListDetailsUndoPickedEvent event, Emitter<PickListDetailsState> emit) async {
    String responseValue = await apiCalls(queryData: {
      "activity": "undo",
      "query_data": {"picklist_id": selectedPickListId, "picklist_item_id": selectedPickListItemId, "type": "Undo"}
    }, controllersList: [], sessionTime: "");
    //await filterItemFunction();
    /*String responseValue ="success";
    undoPickPickedFunction();*/
    responseValue != ""
        ? emit(PickListDetailsError(message: responseValue))
        : emit(PickListDetailsSuccess(message: getIt<Variables>().generalVariables.currentLanguage.undoSuccessfully, isUndo: true));
    emit(PickListDetailsLoaded());
  }

  FutureOr<void> pickListDetailsUnavailableFunction(PickListDetailsUnavailableEvent event, Emitter<PickListDetailsState> emit) async {
    String responseValue = await apiCalls(queryData: {
      "activity": "unavailable",
      "query_data": {
        "picklist_id": selectedPickListId,
        "picklist_item_id": selectedPickListItemId,
        "remarks": commentText,
        "reason": selectedReason,
        "alternative_item": selectedAltItemId,
        "type": "Unavailable"
      }
    }, controllersList: [], sessionTime: "");
    //await filterItemFunction();
    responseValue != ""
        ? emit(PickListDetailsError(message: responseValue))
        : emit(PickListDetailsSuccess(message: getIt<Variables>().generalVariables.currentLanguage.movedUnavailableSuccessfully, isUndo: false));
    emit(PickListDetailsLoaded());
  }

  FutureOr<void> pickListDetailsLocationUpdateFunction(PickListDetailsLocationUpdateEvent event, Emitter<PickListDetailsState> emit) async {
    String responseValue = await apiCalls(queryData: {
      "activity": "location_update",
      "query_data": {"picklist_item_id": selectedPickListItemId, "floor": event.floor, "room": event.room, "zone": event.zone}
    }, controllersList: [], sessionTime: "");
   // await filterItemFunction();
   /* String responseValue="success";
    pickListLocationUpdateFunction(queryData: {
      "activity": "location_update",
      "query_data": {"picklist_item_id": selectedPickListItemId, "floor": event.floor, "room": event.room, "zone": event.zone}
    });*/
    responseValue != ""
        ? emit(PickListDetailsError(message: responseValue))
        : emit(PickListDetailsSuccess(message: getIt<Variables>().generalVariables.currentLanguage.locationUpdateSuccess, isUndo: false));
    emit(PickListDetailsLoaded());
  }

  FutureOr<void> pickListDetailsSessionCloseFunction(PickListDetailsSessionCloseEvent event, Emitter<PickListDetailsState> emit) async {
    Box<PickListDetailsResponse> pickListDetailsResponseBoxData = await Hive.openBox<PickListDetailsResponse>('pick_list_details_response');
    for (var key in pickListDetailsResponseBoxData.keys) {
      PickListDetailsResponse? pickListDetailsResponseTemp = pickListDetailsResponseBoxData.get(key);
      if (pickListDetailsResponseTemp != null && pickListDetailsResponseTemp.picklistId == selectedPickListId) {
        pickListDetailsResponse = pickListDetailsResponseTemp;
        break;
      }
    }
    String sessionStartTime = "";
    sessionStartTime = pickListDetailsResponse.sessionInfo.sessionStartTimestamp;
    if (sessionStartTime != "") {
      String responseValue = await apiCalls(queryData: {
        "activity": "session_close",
        "query_data": {
          "session_id": pickListDetailsResponse.sessionInfo.id,
          "staging_id": selectedStagingAreaId,
          "picklist_id": selectedPickListId,
          "timestamp": (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
          "online_mode": getIt<Variables>().generalVariables.isNetworkOffline == false,
        }
      }, controllersList: [], sessionTime: sessionStartTime);
      await filterItemFunction();
      responseValue != ""
          ? emit(PickListDetailsError(message: responseValue))
          : emit(PickListDetailsSuccess(message: getIt<Variables>().generalVariables.currentLanguage.sessionClosed, isUndo: false));
      emit(PickListDetailsLoaded());
    }
    else {
      emit(PickListDetailsError(message: getIt<Variables>().generalVariables.currentLanguage.sessionNotStarted));
      emit(PickListDetailsLoaded());
    }
  }

  FutureOr<void> pickListDetailsCompleteFunction(PickListDetailsCompleteEvent event, Emitter<PickListDetailsState> emit) async {
    String responseValue = await apiCalls(queryData: {
      "activity": "complete",
      "query_data": {"picklist_id": selectedPickListId, "reason": selectedCompletedReason, "remarks": selectedCompletedRemarks}
    }, controllersList: [], sessionTime: "");
    //await filterItemFunction();
    responseValue != ""
        ? emit(PickListDetailsError(message: responseValue))
        : emit(PickListDetailsSuccess(message: getIt<Variables>().generalVariables.currentLanguage.picklistClosed, isUndo: false));
    emit(PickListDetailsLoaded());
  }

  ///primary & hold
  /*FutureOr<void> pickListDetailsPickedFunction(PickListDetailsPickedEvent event, Emitter<PickListDetailsState> emit) async {
    Map<String, dynamic> queryData = {
      "picklist_id": selectedPickListId,
      "picklist_item_id": selectedPickListItemId,
      "item_id": selectedItemId,
      "picked_qty": pickedQuantityData,
      "catchweight_qty": pickedCatchWeightData.join(",")
    };
    await getIt<Variables>().repoImpl.getPickListDetailsPicked(query: queryData, method: "post").onError((error, stackTrace) {
      emit(PickListDetailsFailure());
      emit(PickListDetailsError(message: error.toString()));
      emit(PickListDetailsLoaded());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          await getIt<Variables>().repoImpl.getPickListDetails(query: {
            "picklist_id": selectedPickListId,
            "search": searchText,
            "page": pageIndex,
            "status": tabName,
            "filters": List.generate(
                getIt<Variables>().generalVariables.selectedFilters.length, (i) => getIt<Variables>().generalVariables.selectedFilters[i].toJson())
          }, method: "post", globalCancelToken: listCancelToken).then((value) {
            if (value != null) {
              if (value["status"] == "1") {
                PickListDetailsModel pickListDetailsModel = PickListDetailsModel.fromJson(value);
                pickListDetailsResponse = pickListDetailsModel.response;
                pickListDetailsResponse.alternateItems.clear();
                pickListDetailsResponse.alternateItems = getIt<Variables>().generalVariables.userData.filterItemsListOptions;
                getIt<Variables>().generalVariables.timelineInfo.clear();
                getIt<Variables>().generalVariables.timelineInfo.addAll(pickListDetailsResponse.timelineInfo);
                switch (tabName) {
                  case "Pending":
                    {
                      ///for picked list grouped by floor,room & zone
                      Map<String, List<PickListDetailsItem>> grouped =
                          groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
                      groupedPickedData = grouped.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.itemPickSuccess));
                      emit(PickListDetailsLoaded());
                    }
                  case "Picked":
                    {
                      ///for picked list grouped by floor & staging area
                      List<PickListDetailsItem> pickedList = pickListDetailsResponse.items.where((element) => !element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> pickedGroup =
                          groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
                      groupedPickedData = pickedGroup.values.toList();

                      ///for picking in progress list grouped by storekeeper
                      List<PickListDetailsItem> pickingList = pickListDetailsResponse.items.where((element) => element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> groupedData = {};
                      for (PickListDetailsItem item in pickingList) {
                        List<HandledByPickList> handledBy = item.handledBy;
                        for (HandledByPickList handler in handledBy) {
                          String name = handler.name;
                          if (!groupedData.containsKey(name)) {
                            groupedData[name] = [];
                          }
                          groupedData[name]!.add(item);
                        }
                      }
                      groupedKeepersNameList = groupedData.keys.toList();
                      groupedPickingData = groupedData.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.itemPickSuccess));
                      emit(PickListDetailsLoaded());
                    }
                  case "Partial":
                    {
                      ///for picked list grouped by floor & staging area
                      List<PickListDetailsItem> pickedList = pickListDetailsResponse.items.where((element) => !element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> pickedGroup =
                          groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
                      groupedPickedData = pickedGroup.values.toList();

                      ///for picking in progress list grouped by storekeeper
                      List<PickListDetailsItem> pickingList = pickListDetailsResponse.items.where((element) => element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> groupedData = {};
                      for (PickListDetailsItem item in pickingList) {
                        List<HandledByPickList> handledBy = item.handledBy;
                        for (HandledByPickList handler in handledBy) {
                          String name = handler.name;
                          if (!groupedData.containsKey(name)) {
                            groupedData[name] = [];
                          }
                          groupedData[name]!.add(item);
                        }
                      }
                      groupedKeepersNameList = groupedData.keys.toList();
                      groupedPickingData = groupedData.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.itemPickSuccess));
                      emit(PickListDetailsLoaded());
                    }
                  case "Unavailable":
                    {
                      ///for picked list grouped by floor
                      Map<String, List<PickListDetailsItem>> grouped =
                          groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => item.floor);
                      groupedPickedData = grouped.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.itemPickSuccess));
                      emit(PickListDetailsLoaded());
                    }
                  default:
                    {
                      ///for picked list grouped by floor,room & zone
                      Map<String, List<PickListDetailsItem>> grouped =
                          groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
                      groupedPickedData = grouped.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.itemPickSuccess));
                      emit(PickListDetailsLoaded());
                    }
                }
              }
            }
          });
        } else {
          emit(PickListDetailsFailure());
          emit(PickListDetailsError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(PickListDetailsLoaded());
        }
      }
    });
  }

  FutureOr<void> pickListDetailsUndoPickedFunction(PickListDetailsUndoPickedEvent event, Emitter<PickListDetailsState> emit) async {
    Map<String, dynamic> queryData = {"picklist_id": selectedPickListId, "picklist_item_id": selectedPickListItemId, "type": "Undo"};
    await getIt<Variables>().repoImpl.getPickListDetailsUnavailable(query: queryData, method: "post").onError((error, stackTrace) {
      emit(PickListDetailsFailure());
      emit(PickListDetailsError(message: error.toString()));
      emit(PickListDetailsLoaded());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          await getIt<Variables>().repoImpl.getPickListDetails(query: {
            "picklist_id": selectedPickListId,
            "search": searchText,
            "page": pageIndex,
            "status": tabName,
            "filters": List.generate(
                getIt<Variables>().generalVariables.selectedFilters.length, (i) => getIt<Variables>().generalVariables.selectedFilters[i].toJson())
          }, method: "post", globalCancelToken: listCancelToken).then((value) {
            if (value != null) {
              if (value["status"] == "1") {
                PickListDetailsModel pickListDetailsModel = PickListDetailsModel.fromJson(value);
                pickListDetailsResponse = pickListDetailsModel.response;
                pickListDetailsResponse.alternateItems.clear();
                pickListDetailsResponse.alternateItems = getIt<Variables>().generalVariables.userData.filterItemsListOptions;
                getIt<Variables>().generalVariables.timelineInfo.clear();
                getIt<Variables>().generalVariables.timelineInfo.addAll(pickListDetailsResponse.timelineInfo);
                switch (tabName) {
                  case "Pending":
                    {
                      ///for picked list grouped by floor,room & zone
                      Map<String, List<PickListDetailsItem>> grouped =
                          groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
                      groupedPickedData = grouped.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: true, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.undoPickDone));
                      emit(PickListDetailsLoaded());
                    }
                  case "Picked":
                    {
                      ///for picked list grouped by floor & staging area

                      List<PickListDetailsItem> pickedList = pickListDetailsResponse.items.where((element) => !element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> pickedGroup =
                          groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
                      groupedPickedData = pickedGroup.values.toList();

                      ///for picking in progress list grouped by storekeeper
                      List<PickListDetailsItem> pickingList = pickListDetailsResponse.items.where((element) => element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> groupedData = {};
                      for (PickListDetailsItem item in pickingList) {
                        List<HandledByPickList> handledBy = item.handledBy;
                        for (HandledByPickList handler in handledBy) {
                          String name = handler.name;
                          if (!groupedData.containsKey(name)) {
                            groupedData[name] = [];
                          }
                          groupedData[name]!.add(item);
                        }
                      }
                      groupedKeepersNameList = groupedData.keys.toList();
                      groupedPickingData = groupedData.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: true, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.undoPickDone));
                      emit(PickListDetailsLoaded());
                    }
                  case "Partial":
                    {
                      ///for picked list grouped by floor & staging area
                      List<PickListDetailsItem> pickedList = pickListDetailsResponse.items.where((element) => !element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> pickedGroup =
                          groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
                      groupedPickedData = pickedGroup.values.toList();

                      ///for picking in progress list grouped by storekeeper
                      List<PickListDetailsItem> pickingList = pickListDetailsResponse.items.where((element) => element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> groupedData = {};
                      for (PickListDetailsItem item in pickingList) {
                        List<HandledByPickList> handledBy = item.handledBy;
                        for (HandledByPickList handler in handledBy) {
                          String name = handler.name;
                          if (!groupedData.containsKey(name)) {
                            groupedData[name] = [];
                          }
                          groupedData[name]!.add(item);
                        }
                      }
                      groupedKeepersNameList = groupedData.keys.toList();
                      groupedPickingData = groupedData.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: true, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.undoPickDone));
                      emit(PickListDetailsLoaded());
                    }
                  case "Unavailable":
                    {
                      ///for picked list grouped by floor
                      Map<String, List<PickListDetailsItem>> grouped =
                          groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => item.floor);
                      groupedPickedData = grouped.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: true, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.undoPickDone));
                      emit(PickListDetailsLoaded());
                    }
                  default:
                    {
                      ///for picked list grouped by floor,room & zone
                      Map<String, List<PickListDetailsItem>> grouped =
                          groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
                      groupedPickedData = grouped.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: true, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.undoPickDone));
                      emit(PickListDetailsLoaded());
                    }
                }
              }
            }
          });
        } else {
          emit(PickListDetailsFailure());
          emit(PickListDetailsError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(PickListDetailsLoaded());
        }
      }
    });
  }

  FutureOr<void> pickListDetailsUnavailableFunction(PickListDetailsUnavailableEvent event, Emitter<PickListDetailsState> emit) async {
    Map<String, dynamic> queryData = {
      "picklist_id": selectedPickListId,
      "picklist_item_id": selectedPickListItemId,
      "remarks": commentText,
      "reason": selectedReason,
      "alternative_item": selectedAltItemId,
      "type": "Unavailable"
    };
    await getIt<Variables>().repoImpl.getPickListDetailsUnavailable(query: queryData, method: "post").onError((error, stackTrace) {
      emit(PickListDetailsFailure());
      emit(PickListDetailsError(message: error.toString()));
      emit(PickListDetailsLoaded());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          await getIt<Variables>().repoImpl.getPickListDetails(query: {
            "picklist_id": selectedPickListId,
            "search": searchText,
            "page": pageIndex,
            "status": tabName,
            "filters": List.generate(
                getIt<Variables>().generalVariables.selectedFilters.length, (i) => getIt<Variables>().generalVariables.selectedFilters[i].toJson())
          }, method: "post", globalCancelToken: listCancelToken).then((value) {
            if (value != null) {
              if (value["status"] == "1") {
                PickListDetailsModel pickListDetailsModel = PickListDetailsModel.fromJson(value);
                pickListDetailsResponse = pickListDetailsModel.response;
                pickListDetailsResponse.alternateItems.clear();
                pickListDetailsResponse.alternateItems = getIt<Variables>().generalVariables.userData.filterItemsListOptions;
                getIt<Variables>().generalVariables.timelineInfo.clear();
                getIt<Variables>().generalVariables.timelineInfo.addAll(pickListDetailsResponse.timelineInfo);
                switch (tabName) {
                  case "Pending":
                    {
                      ///for picked list grouped by floor,room & zone
                      Map<String, List<PickListDetailsItem>> grouped =
                          groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
                      groupedPickedData = grouped.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.itemMarkUnavailable));
                      emit(PickListDetailsLoaded());
                    }
                  case "Picked":
                    {
                      ///for picked list grouped by floor & staging area
                      List<PickListDetailsItem> pickedList = pickListDetailsResponse.items.where((element) => !element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> pickedGroup =
                          groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
                      groupedPickedData = pickedGroup.values.toList();

                      ///for picking in progress list grouped by storekeeper
                      List<PickListDetailsItem> pickingList = pickListDetailsResponse.items.where((element) => element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> groupedData = {};
                      for (PickListDetailsItem item in pickingList) {
                        List<HandledByPickList> handledBy = item.handledBy;
                        for (HandledByPickList handler in handledBy) {
                          String name = handler.name;
                          if (!groupedData.containsKey(name)) {
                            groupedData[name] = [];
                          }
                          groupedData[name]!.add(item);
                        }
                      }
                      groupedKeepersNameList = groupedData.keys.toList();
                      groupedPickingData = groupedData.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.itemMarkUnavailable));
                      emit(PickListDetailsLoaded());
                    }
                  case "Partial":
                    {
                      ///for picked list grouped by floor & staging area
                      List<PickListDetailsItem> pickedList = pickListDetailsResponse.items.where((element) => !element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> pickedGroup =
                          groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
                      groupedPickedData = pickedGroup.values.toList();

                      ///for picking in progress list grouped by storekeeper
                      List<PickListDetailsItem> pickingList = pickListDetailsResponse.items.where((element) => element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> groupedData = {};
                      for (PickListDetailsItem item in pickingList) {
                        List<HandledByPickList> handledBy = item.handledBy;
                        for (HandledByPickList handler in handledBy) {
                          String name = handler.name;
                          if (!groupedData.containsKey(name)) {
                            groupedData[name] = [];
                          }
                          groupedData[name]!.add(item);
                        }
                      }
                      groupedKeepersNameList = groupedData.keys.toList();
                      groupedPickingData = groupedData.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.itemMarkUnavailable));
                      emit(PickListDetailsLoaded());
                    }
                  case "Unavailable":
                    {
                      ///for picked list grouped by floor
                      Map<String, List<PickListDetailsItem>> grouped =
                          groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => item.floor);
                      groupedPickedData = grouped.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.itemMarkUnavailable));
                      emit(PickListDetailsLoaded());
                    }
                  default:
                    {
                      ///for picked list grouped by floor,room & zone
                      Map<String, List<PickListDetailsItem>> grouped =
                          groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
                      groupedPickedData = grouped.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.itemMarkUnavailable));
                      emit(PickListDetailsLoaded());
                    }
                }
              }
            }
          });
        } else {
          emit(PickListDetailsFailure());
          emit(PickListDetailsError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(PickListDetailsLoaded());
        }
      }
    });
  }

  FutureOr<void> pickListDetailsLocationUpdateFunction(PickListDetailsLocationUpdateEvent event, Emitter<PickListDetailsState> emit) async {
    Map<String, dynamic> queryData = {"picklist_item_id": selectedPickListItemId, "floor": event.floor, "room": event.room, "zone": event.zone};
    await getIt<Variables>().repoImpl.getPickListDetailsLocationUpdate(query: queryData, method: "post").onError((error, stackTrace) {
      emit(PickListDetailsFailure());
      emit(PickListDetailsError(message: error.toString()));
      emit(PickListDetailsLoaded());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          await getIt<Variables>().repoImpl.getPickListDetails(query: {
            "picklist_id": selectedPickListId,
            "search": searchText,
            "page": pageIndex,
            "status": tabName,
            "filters": List.generate(
                getIt<Variables>().generalVariables.selectedFilters.length, (i) => getIt<Variables>().generalVariables.selectedFilters[i].toJson())
          }, method: "post", globalCancelToken: listCancelToken).then((value) {
            if (value != null) {
              if (value["status"] == "1") {
                PickListDetailsModel pickListDetailsModel = PickListDetailsModel.fromJson(value);
                pickListDetailsResponse = pickListDetailsModel.response;
                pickListDetailsResponse.alternateItems.clear();
                pickListDetailsResponse.alternateItems = getIt<Variables>().generalVariables.userData.filterItemsListOptions;
                getIt<Variables>().generalVariables.timelineInfo.clear();
                getIt<Variables>().generalVariables.timelineInfo.addAll(pickListDetailsResponse.timelineInfo);
                switch (tabName) {
                  case "Pending":
                    {
                      ///for picked list grouped by floor,room & zone
                      Map<String, List<PickListDetailsItem>> grouped =
                          groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
                      groupedPickedData = grouped.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.locationUpdateSuccess));
                      emit(PickListDetailsLoaded());
                    }
                  case "Picked":
                    {
                      ///for picked list grouped by floor & staging area
                      List<PickListDetailsItem> pickedList = pickListDetailsResponse.items.where((element) => !element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> pickedGroup =
                          groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
                      groupedPickedData = pickedGroup.values.toList();

                      ///for picking in progress list grouped by storekeeper
                      List<PickListDetailsItem> pickingList = pickListDetailsResponse.items.where((element) => element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> groupedData = {};
                      for (PickListDetailsItem item in pickingList) {
                        List<HandledByPickList> handledBy = item.handledBy;
                        for (HandledByPickList handler in handledBy) {
                          String name = handler.name;
                          if (!groupedData.containsKey(name)) {
                            groupedData[name] = [];
                          }
                          groupedData[name]!.add(item);
                        }
                      }
                      groupedKeepersNameList = groupedData.keys.toList();
                      groupedPickingData = groupedData.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.locationUpdateSuccess));
                      emit(PickListDetailsLoaded());
                    }
                  case "Partial":
                    {
                      ///for picked list grouped by floor & staging area
                      List<PickListDetailsItem> pickedList = pickListDetailsResponse.items.where((element) => !element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> pickedGroup =
                          groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
                      groupedPickedData = pickedGroup.values.toList();

                      ///for picking in progress list grouped by storekeeper
                      List<PickListDetailsItem> pickingList = pickListDetailsResponse.items.where((element) => element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> groupedData = {};
                      for (PickListDetailsItem item in pickingList) {
                        List<HandledByPickList> handledBy = item.handledBy;
                        for (HandledByPickList handler in handledBy) {
                          String name = handler.name;
                          if (!groupedData.containsKey(name)) {
                            groupedData[name] = [];
                          }
                          groupedData[name]!.add(item);
                        }
                      }
                      groupedKeepersNameList = groupedData.keys.toList();
                      groupedPickingData = groupedData.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.locationUpdateSuccess));
                      emit(PickListDetailsLoaded());
                    }
                  case "Unavailable":
                    {
                      ///for picked list grouped by floor
                      Map<String, List<PickListDetailsItem>> grouped =
                          groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => item.floor);
                      groupedPickedData = grouped.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.locationUpdateSuccess));
                      emit(PickListDetailsLoaded());
                    }
                  default:
                    {
                      ///for picked list grouped by floor,room & zone
                      Map<String, List<PickListDetailsItem>> grouped =
                          groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
                      groupedPickedData = grouped.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.locationUpdateSuccess));
                      emit(PickListDetailsLoaded());
                    }
                }
              }
            }
          });
        } else {
          emit(PickListDetailsFailure());
          emit(PickListDetailsError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(PickListDetailsLoaded());
        }
      }
    });
  }

  FutureOr<void> pickListDetailsSessionCloseFunction(PickListDetailsSessionCloseEvent event, Emitter<PickListDetailsState> emit) async {
    Map<String, dynamic> queryData = {"session_id": pickListDetailsResponse.sessionInfo.id, "staging_id": selectedStagingAreaId};
    await getIt<Variables>().repoImpl.getPickListDetailsSessionClose(query: queryData, method: "post").onError((error, stackTrace) {
      emit(PickListDetailsFailure());
      emit(PickListDetailsError(message: error.toString()));
      emit(PickListDetailsLoaded());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          await getIt<Variables>().repoImpl.getPickListDetails(query: {
            "picklist_id": selectedPickListId,
            "search": searchText,
            "page": pageIndex,
            "status": tabName,
            "filters": List.generate(
                getIt<Variables>().generalVariables.selectedFilters.length, (i) => getIt<Variables>().generalVariables.selectedFilters[i].toJson())
          }, method: "post", globalCancelToken: listCancelToken).then((value) {
            if (value != null) {
              if (value["status"] == "1") {
                PickListDetailsModel pickListDetailsModel = PickListDetailsModel.fromJson(value);
                pickListDetailsResponse = pickListDetailsModel.response;
                pickListDetailsResponse.alternateItems.clear();
                pickListDetailsResponse.alternateItems = getIt<Variables>().generalVariables.userData.filterItemsListOptions;
                getIt<Variables>().generalVariables.timelineInfo.clear();
                getIt<Variables>().generalVariables.timelineInfo.addAll(pickListDetailsResponse.timelineInfo);
                switch (tabName) {
                  case "Pending":
                    {
                      ///for picked list grouped by floor,room & zone
                      Map<String, List<PickListDetailsItem>> grouped =
                          groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
                      groupedPickedData = grouped.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.sessionClosed));
                      emit(PickListDetailsLoaded());
                    }
                  case "Picked":
                    {
                      ///for picked list grouped by floor & staging area
                      List<PickListDetailsItem> pickedList = pickListDetailsResponse.items.where((element) => !element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> pickedGroup =
                          groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
                      groupedPickedData = pickedGroup.values.toList();

                      ///for picking in progress list grouped by storekeeper
                      List<PickListDetailsItem> pickingList = pickListDetailsResponse.items.where((element) => element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> groupedData = {};
                      for (PickListDetailsItem item in pickingList) {
                        List<HandledByPickList> handledBy = item.handledBy;
                        for (HandledByPickList handler in handledBy) {
                          String name = handler.name;
                          if (!groupedData.containsKey(name)) {
                            groupedData[name] = [];
                          }
                          groupedData[name]!.add(item);
                        }
                      }
                      groupedKeepersNameList = groupedData.keys.toList();
                      groupedPickingData = groupedData.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.sessionClosed));
                      emit(PickListDetailsLoaded());
                    }
                  case "Partial":
                    {
                      ///for picked list grouped by floor & staging area
                      List<PickListDetailsItem> pickedList = pickListDetailsResponse.items.where((element) => !element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> pickedGroup =
                          groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
                      groupedPickedData = pickedGroup.values.toList();

                      ///for picking in progress list grouped by storekeeper
                      List<PickListDetailsItem> pickingList = pickListDetailsResponse.items.where((element) => element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> groupedData = {};
                      for (PickListDetailsItem item in pickingList) {
                        List<HandledByPickList> handledBy = item.handledBy;
                        for (HandledByPickList handler in handledBy) {
                          String name = handler.name;
                          if (!groupedData.containsKey(name)) {
                            groupedData[name] = [];
                          }
                          groupedData[name]!.add(item);
                        }
                      }
                      groupedKeepersNameList = groupedData.keys.toList();
                      groupedPickingData = groupedData.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.sessionClosed));
                      emit(PickListDetailsLoaded());
                    }
                  case "Unavailable":
                    {
                      ///for picked list grouped by floor
                      Map<String, List<PickListDetailsItem>> grouped =
                          groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => item.floor);
                      groupedPickedData = grouped.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.sessionClosed));
                      emit(PickListDetailsLoaded());
                    }
                  default:
                    {
                      ///for picked list grouped by floor,room & zone
                      Map<String, List<PickListDetailsItem>> grouped =
                          groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
                      groupedPickedData = grouped.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.sessionClosed));
                      emit(PickListDetailsLoaded());
                    }
                }
              }
            }
          });
        } else {
          emit(PickListDetailsFailure());
          emit(PickListDetailsError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(PickListDetailsLoaded());
        }
      }
    });
  }

  FutureOr<void> pickListDetailsCompleteFunction(PickListDetailsCompleteEvent event, Emitter<PickListDetailsState> emit) async {
    Map<String, dynamic> queryData = {"picklist_id": selectedPickListId, "reason": selectedCompletedReason, "remarks": selectedCompletedRemarks};
    await getIt<Variables>().repoImpl.getPicklistComplete(query: queryData, method: "post").onError((error, stackTrace) {
      emit(PickListDetailsFailure());
      emit(PickListDetailsError(message: error.toString()));
      emit(PickListDetailsLoaded());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          pickListDetailsResponse.isReadyToMoveComplete = false;
          await getIt<Variables>().repoImpl.getPickListDetails(query: {
            "picklist_id": selectedPickListId,
            "search": searchText,
            "page": pageIndex,
            "status": tabName,
            "filters": List.generate(
                getIt<Variables>().generalVariables.selectedFilters.length, (i) => getIt<Variables>().generalVariables.selectedFilters[i].toJson())
          }, method: "post", globalCancelToken: listCancelToken).then((value) {
            if (value != null) {
              if (value["status"] == "1") {
                PickListDetailsModel pickListDetailsModel = PickListDetailsModel.fromJson(value);
                pickListDetailsResponse = pickListDetailsModel.response;
                pickListDetailsResponse.alternateItems.clear();
                pickListDetailsResponse.alternateItems = getIt<Variables>().generalVariables.userData.filterItemsListOptions;
                getIt<Variables>().generalVariables.timelineInfo.clear();
                getIt<Variables>().generalVariables.timelineInfo.addAll(pickListDetailsResponse.timelineInfo);
                switch (tabName) {
                  case "Pending":
                    {
                      ///for picked list grouped by floor,room & zone
                      Map<String, List<PickListDetailsItem>> grouped =
                          groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
                      groupedPickedData = grouped.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.picklistClosed));
                      emit(PickListDetailsLoaded());
                    }
                  case "Picked":
                    {
                      ///for picked list grouped by floor & staging area
                      List<PickListDetailsItem> pickedList = pickListDetailsResponse.items.where((element) => !element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> pickedGroup =
                          groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
                      groupedPickedData = pickedGroup.values.toList();

                      ///for picking in progress list grouped by storekeeper
                      List<PickListDetailsItem> pickingList = pickListDetailsResponse.items.where((element) => element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> groupedData = {};
                      for (PickListDetailsItem item in pickingList) {
                        List<HandledByPickList> handledBy = item.handledBy;
                        for (HandledByPickList handler in handledBy) {
                          String name = handler.name;
                          if (!groupedData.containsKey(name)) {
                            groupedData[name] = [];
                          }
                          groupedData[name]!.add(item);
                        }
                      }
                      groupedKeepersNameList = groupedData.keys.toList();
                      groupedPickingData = groupedData.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.picklistClosed));
                      emit(PickListDetailsLoaded());
                    }
                  case "Partial":
                    {
                      ///for picked list grouped by floor & staging area
                      List<PickListDetailsItem> pickedList = pickListDetailsResponse.items.where((element) => !element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> pickedGroup =
                          groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
                      groupedPickedData = pickedGroup.values.toList();

                      ///for picking in progress list grouped by storekeeper
                      List<PickListDetailsItem> pickingList = pickListDetailsResponse.items.where((element) => element.isProgressStatus).toList();
                      Map<String, List<PickListDetailsItem>> groupedData = {};
                      for (PickListDetailsItem item in pickingList) {
                        List<HandledByPickList> handledBy = item.handledBy;
                        for (HandledByPickList handler in handledBy) {
                          String name = handler.name;
                          if (!groupedData.containsKey(name)) {
                            groupedData[name] = [];
                          }
                          groupedData[name]!.add(item);
                        }
                      }
                      groupedKeepersNameList = groupedData.keys.toList();
                      groupedPickingData = groupedData.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.picklistClosed));
                      emit(PickListDetailsLoaded());
                    }
                  case "Unavailable":
                    {
                      ///for picked list grouped by floor
                      Map<String, List<PickListDetailsItem>> grouped =
                          groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => item.floor);
                      groupedPickedData = grouped.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.picklistClosed));
                      emit(PickListDetailsLoaded());
                    }
                  default:
                    {
                      ///for picked list grouped by floor,room & zone
                      Map<String, List<PickListDetailsItem>> grouped =
                          groupBy(pickListDetailsResponse.items, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
                      groupedPickedData = grouped.values.toList();
                      emit(PickListDetailsSuccess(
                          isUndo: false, message: value["message"] ?? getIt<Variables>().generalVariables.currentLanguage.picklistClosed));
                      emit(PickListDetailsLoaded());
                    }
                }
              }
            }
          });
        } else {
          emit(PickListDetailsFailure());
          emit(PickListDetailsError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(PickListDetailsLoaded());
        }
      }
    });
  }*/

  FutureOr<void> pickListDetailsRefreshFunction(PickListDetailsRefreshEvent event, Emitter<PickListDetailsState> emit) async {
    if ((event.socketMessage.body.picklistId == getIt<Variables>().generalVariables.picklistSocketTempId) &&
        tabName.toLowerCase() != event.socketMessage.activity.toLowerCase()) {
      for (int i = 0; i < groupedPickedData.length; i++) {
        for (int j = 0; j < groupedPickedData[i].length; j++) {
          if (groupedPickedData[i][j].id == event.socketMessage.body.picklistItemId) {
            if (groupedPickedData[i].length == 1) {
              groupedPickedData.removeAt(i);
            } else {
              groupedPickedData[i].removeAt(j);
            }
            emit(PickListDetailsDummy());
            emit(PickListDetailsLoaded());
          }
        }
      }
      for (int i = 0; i < groupedPickingData.length; i++) {
        for (int j = 0; j < groupedPickingData[i].length; j++) {
          if (groupedPickingData[i][j].id == event.socketMessage.body.picklistItemId) {
            if (groupedPickingData[i].length == 1) {
              groupedPickingData.removeAt(i);
            } else {
              groupedPickingData[i].removeAt(j);
            }
            emit(PickListDetailsDummy());
            emit(PickListDetailsLoaded());
          }
        }
      }
    }
  }

  Future<String> apiCalls({
    required Map<String, dynamic> queryData,
    required List<String> controllersList,
    required String sessionTime,
  }) async {
    String responseBool = "";
    String encodeData = jsonEncode(queryData);
    if (getIt<Variables>().generalVariables.isNetworkOffline) {
      localTempDataPickList.add(LocalTempDataPickList(queryData: encodeData));
      switch (queryData['activity']) {
        case "picked":
          {
            pickedItemFunction();
           // await pickedItemFunction(controllersList: controllersList);
          }
        case "undo":
          {
            await undoPickedItemFunction();
          }
        case "unavailable":
          {
            await unavailableItemFunction();
          }
        case "location_update":
          {
            await pickListLocationUpdateFunction(queryData: queryData);
          }
        case "session_close":
          {
            await sessionCloseFunction(sessionTime: sessionTime);
          }
        case "complete":
          {
            await completeFunction();
          }
        default:
          {
            pickedItemFunction();
           // await pickedItemFunction(controllersList: controllersList);
          }
      }
    }
    else {
      await networkApiCalls();
      switch (queryData['activity']) {
        case "picked":
          {
            await getIt<Variables>()
                .repoImpl
                .getPickListDetailsPicked(query: queryData["query_data"], method: "post", module: ApiEndPoints().pickListModule)
                .onError((error, stackTrace) {
              responseBool = error.toString();
            }).then((value) async {
              if (value != null) {
                if (value["status"] == "1") {
                  responseBool = "";
                  pickedItemFunction();
                 // await pickedItemFunction(controllersList: controllersList);
                }
              }
            });
          }
        case "undo":
          {
            await getIt<Variables>()
                .repoImpl
                .getPickListDetailsUnavailable(query: queryData["query_data"], method: "post", module: ApiEndPoints().pickListModule)
                .onError((error, stackTrace) {
              responseBool = error.toString();
            }).then((value) async {
              if (value != null) {
                if (value["status"] == "1") {
                  responseBool = "";
                  await undoPickedItemFunction();
                }
              }
            });
          }
        case "unavailable":
          {
            await getIt<Variables>()
                .repoImpl
                .getPickListDetailsUnavailable(query: queryData["query_data"], method: "post", module: ApiEndPoints().pickListModule)
                .onError((error, stackTrace) {
              responseBool = error.toString();
            }).then((value) async {
              if (value != null) {
                if (value["status"] == "1") {
                  responseBool = "";
                  await unavailableItemFunction();
                }
              }
            });
          }
        case "location_update":
          {
            await getIt<Variables>()
                .repoImpl
                .getPickListDetailsLocationUpdate(query: queryData["query_data"], method: "post", module: ApiEndPoints().pickListModule)
                .onError((error, stackTrace) {
              responseBool = error.toString();
            }).then((value) async {
              if (value != null) {
                if (value["status"] == "1") {
                  responseBool = "";
                  await pickListLocationUpdateFunction(queryData: queryData);
                }
              }
            });
          }
        case "session_close":
          {
            await getIt<Variables>()
                .repoImpl
                .getPickListDetailsSessionClose(query: queryData["query_data"], method: "post", module: ApiEndPoints().pickListModule)
                .onError((error, stackTrace) {
              responseBool = error.toString();
            }).then((value) async {
              if (value != null) {
                if (value["status"] == "1") {
                  responseBool = "";
                  await sessionCloseFunction(sessionTime: sessionTime);
                }
              }
            });
          }
        case "complete":
          {
            await getIt<Variables>()
                .repoImpl
                .getPicklistComplete(query: queryData["query_data"], method: "post", module: ApiEndPoints().pickListModule)
                .onError((error, stackTrace) {
              responseBool = error.toString();
            }).then((value) async {
              if (value != null) {
                if (value["status"] == "1") {
                  responseBool = "";
                  await completeFunction();
                }
              }
            });
          }
        default:
          {
            await getIt<Variables>()
                .repoImpl
                .getPickListDetailsPicked(query: queryData["query_data"], method: "post", module: ApiEndPoints().pickListModule)
                .onError((error, stackTrace) {
              responseBool = error.toString();
            }).then((value) async {
              if (value != null) {
                if (value["status"] == "1") {
                  responseBool = "";
                  //await pickedItemFunction(controllersList: controllersList);
                  pickedItemFunction();
                }
              }
            });
          }
      }
    }
    return responseBool;
  }

  networkApiCalls() async {
    if (localTempDataPickList.values.toList().isNotEmpty) {
      int i = 0;
      do {
        try {
          Map<String, dynamic> queryData = jsonDecode(localTempDataPickList.values.toList()[i].queryData);
          switch (queryData["activity"]) {
            case "picked":
              {
                await getIt<Variables>()
                    .repoImpl
                    .getPickListDetailsPicked(query: queryData["query_data"], method: "post", module: ApiEndPoints().pickListModule)
                    .then((value) async {
                  if (value != null) {
                    if (value["status"] == "1") {
                      await localTempDataPickList.deleteAt(i);
                    }
                  }
                });
              }
            case "undo":
              {
                await getIt<Variables>()
                    .repoImpl
                    .getPickListDetailsUnavailable(query: queryData["query_data"], method: "post", module: ApiEndPoints().pickListModule)
                    .then((value) async {
                  if (value != null) {
                    if (value["status"] == "1") {
                      await localTempDataPickList.deleteAt(i);
                    }
                  }
                });
              }
            case "unavailable":
              {
                await getIt<Variables>()
                    .repoImpl
                    .getPickListDetailsUnavailable(query: queryData["query_data"], method: "post", module: ApiEndPoints().pickListModule)
                    .then((value) async {
                  if (value != null) {
                    if (value["status"] == "1") {
                      await localTempDataPickList.deleteAt(i);
                    }
                  }
                });
              }
            case "location_update":
              {
                await getIt<Variables>()
                    .repoImpl
                    .getPickListDetailsLocationUpdate(query: queryData["query_data"], method: "post", module: ApiEndPoints().pickListModule)
                    .then((value) async {
                  if (value != null) {
                    if (value["status"] == "1") {
                      await localTempDataPickList.deleteAt(i);
                    }
                  }
                });
              }
            case "session_close":
              {
                await getIt<Variables>()
                    .repoImpl
                    .getPickListDetailsSessionClose(query: queryData["query_data"], method: "post", module: ApiEndPoints().pickListModule)
                    .then((value) async {
                  if (value != null) {
                    if (value["status"] == "1") {
                      await localTempDataPickList.deleteAt(i);
                    }
                  }
                });
              }
            case "complete":
              {
                await getIt<Variables>()
                    .repoImpl
                    .getPicklistComplete(query: queryData["query_data"], method: "post", module: ApiEndPoints().pickListModule)
                    .then((value) async {
                  if (value != null) {
                    if (value["status"] == "1") {
                      await localTempDataPickList.deleteAt(i);
                    }
                  }
                });
              }
            default:
              {
                await getIt<Variables>()
                    .repoImpl
                    .getPickListDetailsPicked(query: queryData["query_data"], method: "post", module: ApiEndPoints().pickListModule)
                    .then((value) async {
                  if (value != null) {
                    if (value["status"] == "1") {
                      await localTempDataPickList.deleteAt(i);
                    }
                  }
                });
              }
          }
        } catch (e) {
          break;
        }
      } while (localTempDataPickList.isNotEmpty);
    }
  }

  /*pickedItemFunction({required List<String> controllersList}) async {
    Box<PickListDetailsResponse> pickListDetailsResponseBoxData = await Hive.openBox<PickListDetailsResponse>('pick_list_details_response');
    int? keyToUpdate;
    PickListDetailsResponse? pickListDetailsResponseToUpdate;
    String userCode = getIt<Variables>().generalVariables.userDataEmployeeCode;
    List<FilterOptionsResponse> usersList = getIt<Variables>().generalVariables.userData.usersList;
    HandledByPickList userHandled = HandledByPickList.fromJson(usersList.singleWhere((user) => user.code == userCode).toJson());
    num sum = 0;
    for (var key in pickListDetailsResponseBoxData.keys) {
      PickListDetailsResponse? pickListDetailsResponseTemp = pickListDetailsResponseBoxData.get(key);
      if (pickListDetailsResponseTemp != null && pickListDetailsResponseTemp.picklistId == selectedPickListId) {
        keyToUpdate = key;
        pickListDetailsResponseToUpdate = pickListDetailsResponseTemp;
        break;
      }
    }
    if (keyToUpdate != null && pickListDetailsResponseToUpdate != null) {
      for (int x = 0; x < pickListDetailsResponseToUpdate.items.length; x++) {
        if (pickListDetailsResponseToUpdate.items[x].id == selectedItem.id) {
          if (selectedItem.catchWeightStatus != "No") {
            selectedItem.catchWeightInfoPicked = getIt<Functions>().getStringToCatchWeight(value: pickedCatchWeightData.join(","));
            for (int i = 0; i < pickedCatchWeightData.length; i++) {
              sum = sum + num.parse(pickedCatchWeightData[i]);
            }
            userHandled.pickedItems = sum.toStringAsFixed(2);
            selectedItem.catchWeightInfoForList = getIt<Functions>()
                .getStringToList(value: pickedCatchWeightData.join(","), quantity: sum.toStringAsFixed(2), weightUnit: selectedItem.uom);
          }
          else {
            for (int i = 0; i < controllersList.length; i++) {
              if (controllersList[i] != "" && controllersList[i] != ".") {
                if (num.parse(controllersList[i]) != 0) {
                  if (num.parse(controllersList[i]) <= num.parse(selectedItem.batchesList[i].quantity)) {
                    selectedItem.batchesList[i].pickedQty =
                        (num.parse(selectedItem.batchesList[i].pickedQty == "" ? "0" : selectedItem.batchesList[i].pickedQty) +
                                num.parse(controllersList[i]))
                            .toString();
                    sum = sum + num.parse(controllersList[i]);
                  }
                }
              }
            }
            userHandled.pickedItems = sum.toString();
          }
          if (pickListDetailsResponseToUpdate.items[x].handledBy.isNotEmpty) {
            List<String> pickListHandledByCodeList = List.generate(
                pickListDetailsResponseToUpdate.items[x].handledBy.length, (i) => pickListDetailsResponseToUpdate!.items[x].handledBy[i].code);
            if (pickListHandledByCodeList.contains(userHandled.code)) {
              if (selectedItem.catchWeightStatus != "No") {
                pickListDetailsResponseToUpdate.items[x].handledBy.firstWhere((handled) => handled.code == userHandled.code).pickedItems =
                    userHandled.pickedItems;
              } else {
                pickListDetailsResponseToUpdate.items[x].handledBy.firstWhere((handled) => handled.code == userHandled.code).pickedItems = (num.parse(
                            pickListDetailsResponseToUpdate.items[x].handledBy
                                .singleWhere((handled) => handled.code == userHandled.code)
                                .pickedItems) +
                        num.parse(userHandled.pickedItems))
                    .toString();
              }
            }
            else {
              pickListDetailsResponseToUpdate.items[x].handledBy.add(userHandled);
            }
          }
          else {
            pickListDetailsResponseToUpdate.items[x].handledBy.add(userHandled);
          }
          if (selectedItem.catchWeightStatus != "No") {
            pickListDetailsResponseToUpdate.items[x].status =
                num.parse(selectedItem.quantity) == double.parse(sum.toStringAsFixed(2)) ? "Picked" : "Partial";
          }
          else {
            pickListDetailsResponseToUpdate.items[x].status =
                num.parse(selectedItem.quantity) == (num.parse(pickListDetailsResponseToUpdate.items[x].pickedQty) + sum) ? "Picked" : "Partial";
          }
          pickListDetailsResponseToUpdate.items[x].isProgressStatus = true;
          if (selectedItem.catchWeightStatus != "No") {
            pickListDetailsResponseToUpdate.items[x].pickedQty = sum.toStringAsFixed(2);
          }
          else {
            pickListDetailsResponseToUpdate.items[x].pickedQty = (num.parse(pickListDetailsResponseToUpdate.items[x].pickedQty) + sum).toString();
          }
        }
      }
      if (tabName == "Pending") {
        pickListDetailsResponseToUpdate.yetToPick--;
        int index = pickListDetailsResponseToUpdate.sessionInfo.pendingList.indexWhere((e) => e.id == selectedItem.id);
        if (num.parse(selectedItem.quantity) ==
            num.parse(pickListDetailsResponseToUpdate.items.firstWhere((e) => e.id == selectedItem.id).pickedQty)) {
          pickListDetailsResponseToUpdate.picked++;
          //  pickListDetailsResponseToUpdate.pickedItems = (num.parse(pickListDetailsResponseToUpdate.pickedItems) + 1).toString();
          if (index == -1) {
            pickListDetailsResponseToUpdate.sessionInfo.pickedList.add(pickListDetailsResponseToUpdate.items.singleWhere((e) => e.id == selectedItem.id));
          } else {
            pickListDetailsResponseToUpdate.sessionInfo.pickedList.add(pickListDetailsResponseToUpdate.sessionInfo.pendingList[index]);
            pickListDetailsResponseToUpdate.sessionInfo.pendingList.removeAt(index);
          }
        } else {
          pickListDetailsResponseToUpdate.partial++;
          if (index == -1) {
            pickListDetailsResponseToUpdate.sessionInfo.partialList.add(pickListDetailsResponseToUpdate.items.singleWhere((e) => e.id == selectedItem.id));
          } else {
            pickListDetailsResponseToUpdate.sessionInfo.partialList.add(pickListDetailsResponseToUpdate.sessionInfo.pendingList[index]);
            pickListDetailsResponseToUpdate.sessionInfo.pendingList.removeAt(index);
          }
        }
      }
      else if (tabName == "Partial") {
        if (num.parse(selectedItem.quantity) ==
            num.parse(pickListDetailsResponseToUpdate.items.firstWhere((e) => e.id == selectedItem.id).pickedQty)) {
          pickListDetailsResponseToUpdate.partial--;
          pickListDetailsResponseToUpdate.picked++;
          // pickListDetailsResponseToUpdate.pickedItems = (num.parse(pickListDetailsResponseToUpdate.pickedItems) + 1).toString();
          int index = pickListDetailsResponseToUpdate.sessionInfo.partialList.indexWhere((e) => e.id == selectedItem.id);
          if (index == -1) {
            pickListDetailsResponseToUpdate.sessionInfo.pickedList
                .add(pickListDetailsResponseToUpdate.items.singleWhere((e) => e.id == selectedItem.id));
          } else {
            pickListDetailsResponseToUpdate.sessionInfo.pickedList.add(pickListDetailsResponseToUpdate.sessionInfo.partialList[index]);
            pickListDetailsResponseToUpdate.sessionInfo.partialList.removeAt(index);
          }
        } else {
          List<String> currentSessionIdList = List.generate(
              pickListDetailsResponseToUpdate.sessionInfo.partialList.length, (i) => pickListDetailsResponseToUpdate!.sessionInfo.partialList[i].id);
          if (currentSessionIdList.contains(selectedItem.id)) {
            pickListDetailsResponseToUpdate.partial--;
            pickListDetailsResponseToUpdate.partial++;
            int index = pickListDetailsResponseToUpdate.sessionInfo.partialList.indexWhere((e) => e.id == selectedItem.id);
            if (index == -1) {
              pickListDetailsResponseToUpdate.sessionInfo.partialList
                  .add(pickListDetailsResponseToUpdate.items.singleWhere((e) => e.id == selectedItem.id));
            } else {
              pickListDetailsResponseToUpdate.sessionInfo.partialList.add(pickListDetailsResponseToUpdate.sessionInfo.partialList[index]);
              pickListDetailsResponseToUpdate.sessionInfo.partialList.removeAt(index);
            }
          } else {
            pickListDetailsResponseToUpdate.sessionInfo.partialList
                .add(pickListDetailsResponseToUpdate.items.singleWhere((e) => e.id == selectedItem.id));
          }
        }
      }
      else if (tabName == "Unavailable") {
        pickListDetailsResponseToUpdate.unavailable--;
        int index = pickListDetailsResponseToUpdate.sessionInfo.unavailableList.indexWhere((e) => e.id == selectedItem.id);
        if (num.parse(selectedItem.quantity) ==
            num.parse(pickListDetailsResponseToUpdate.items.firstWhere((e) => e.id == selectedItem.id).pickedQty)) {
          pickListDetailsResponseToUpdate.picked++;
          //  pickListDetailsResponseToUpdate.pickedItems = (num.parse(pickListDetailsResponseToUpdate.pickedItems) + 1).toString();
          if (index == -1) {
            pickListDetailsResponseToUpdate.sessionInfo.pickedList
                .add(pickListDetailsResponseToUpdate.items.singleWhere((e) => e.id == selectedItem.id));
          } else {
            pickListDetailsResponseToUpdate.sessionInfo.pickedList.add(pickListDetailsResponseToUpdate.sessionInfo.unavailableList[index]);
            pickListDetailsResponseToUpdate.sessionInfo.unavailableList.removeAt(index);
          }
        } else {
          pickListDetailsResponseToUpdate.partial++;
          if (index == -1) {
            pickListDetailsResponseToUpdate.sessionInfo.partialList
                .add(pickListDetailsResponseToUpdate.items.singleWhere((e) => e.id == selectedItem.id));
          } else {
            pickListDetailsResponseToUpdate.sessionInfo.partialList.add(pickListDetailsResponseToUpdate.sessionInfo.unavailableList[index]);
            pickListDetailsResponseToUpdate.sessionInfo.unavailableList.removeAt(index);
          }
        }
      }
      pickListDetailsResponseToUpdate.pickedItems = (pickListDetailsResponseToUpdate.items.where((e) => e.status == "Picked").toList().length).toString();
      if (pickListDetailsResponseToUpdate.pickedItems == "0") {
        pickListDetailsResponseToUpdate.picklistStatus = "Pending";
      }
      else if (pickListDetailsResponseToUpdate.pickedItems == pickListDetailsResponseToUpdate.totalItems) {
        pickListDetailsResponseToUpdate.picklistStatus = "Completed";
      }
      else {
        pickListDetailsResponseToUpdate.picklistStatus = "Partial";
      }
      List<HandledByPickList> handledByPickListData = [];
      for (int i = 0; i < pickListDetailsResponseToUpdate.items.length; i++) {
        for (int j = 0; j < pickListDetailsResponseToUpdate.items[i].handledBy.length; j++) {
          handledByPickListData.add(pickListDetailsResponseToUpdate.items[i].handledBy[j]);
        }
      }
      pickListDetailsResponseToUpdate.handledBy.clear();
      pickListDetailsResponseToUpdate.handledBy.addAll(mergeHandledByPickList(handledByPickListData: handledByPickListData));
      pickListDetailsResponseToUpdate.isReadyToMoveComplete = false;
      pickListDetailsResponseToUpdate.sessionInfo.isOpened = true;
      pickListDetailsResponseToUpdate.sessionInfo.pending = pickListDetailsResponseToUpdate.sessionInfo.pendingList.length.toString();
      pickListDetailsResponseToUpdate.sessionInfo.picked = pickListDetailsResponseToUpdate.sessionInfo.pickedList.length.toString();
      pickListDetailsResponseToUpdate.sessionInfo.partial = pickListDetailsResponseToUpdate.sessionInfo.partialList.length.toString();
      pickListDetailsResponseToUpdate.sessionInfo.unavailable = pickListDetailsResponseToUpdate.sessionInfo.unavailableList.length.toString();
      if (pickListDetailsResponseToUpdate.sessionInfo.sessionStartTimestamp == "") {
        pickListDetailsResponseToUpdate.sessionInfo.sessionStartTimestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      }
      await pickListDetailsResponseBoxData.put(keyToUpdate, pickListDetailsResponseToUpdate);
    }
    Box<PickListMainResponse> pickListMainResponseBoxData = await Hive.openBox<PickListMainResponse>('pick_list_main_response');
    PickListMainResponse pickListMainResponseToUpdate = pickListMainResponseBoxData.getAt(0)!;
    for (int x = 0; x < pickListMainResponseToUpdate.picklist.length; x++) {
      if (pickListMainResponseToUpdate.picklist[x].id == selectedPickListId) {
        pickListMainResponseToUpdate.picklist[x].handledBy.clear();
        pickListMainResponseToUpdate.picklist[x].handledBy.addAll(pickListDetailsResponseToUpdate!.handledBy);
        pickListMainResponseToUpdate.picklist[x].pickedQty = pickListDetailsResponseToUpdate.pickedItems;
        if (num.parse(pickListDetailsResponseToUpdate.items.where((e) => e.status == "Picked").toList().length.toString()) ==
            num.parse(pickListMainResponseToUpdate.picklist[x].quantity)) {
          pickListMainResponseToUpdate.picklist[x].status = "Completed";
          pickListMainResponseToUpdate.picklist[x].statusColor = "007838";
          pickListMainResponseToUpdate.picklist[x].statusBGColor = "C9F2DC";
          pickListMainResponseToUpdate.picklist[x].inProgress = false;
        }
        else {
          if (pickListMainResponseToUpdate.picklist[x].pickedQty == "0") {
            pickListMainResponseToUpdate.picklist[x].status = "Pending";
            pickListMainResponseToUpdate.picklist[x].statusColor = "DC474A";
            pickListMainResponseToUpdate.picklist[x].statusBGColor = "ffCCCF";
            pickListMainResponseToUpdate.picklist[x].inProgress = false;
          } else {
            pickListMainResponseToUpdate.picklist[x].status = "Partial";
            pickListMainResponseToUpdate.picklist[x].statusColor = "72492B";
            pickListMainResponseToUpdate.picklist[x].statusBGColor = "ffDDC5";
            pickListMainResponseToUpdate.picklist[x].inProgress = true;
          }
        }
      }
    }
    await pickListMainResponseBoxData.put(0, pickListMainResponseToUpdate);
  }*/

  /*undoPickedItemFunction() async {
    Box<PickListDetailsResponse> pickListDetailsResponseBoxData = await Hive.openBox<PickListDetailsResponse>('pick_list_details_response');
    int? keyToUpdate;
    PickListDetailsResponse? pickListDetailsResponseToUpdate;
    for (var key in pickListDetailsResponseBoxData.keys) {
      PickListDetailsResponse? pickListDetailsResponseTemp = pickListDetailsResponseBoxData.get(key);
      if (pickListDetailsResponseTemp != null && pickListDetailsResponseTemp.picklistId == selectedPickListId) {
        keyToUpdate = key;
        pickListDetailsResponseToUpdate = pickListDetailsResponseTemp;
        break;
      }
    }
    if (keyToUpdate != null && pickListDetailsResponseToUpdate != null) {
      for (int l = 0; l < pickListDetailsResponseToUpdate.items.length; l++) {
        if (pickListDetailsResponseToUpdate.items[l].id == selectedItem.id) {
          pickListDetailsResponseToUpdate.items[l].isProgressStatus = false;
          Box<PartialPickListDetailsItem> pickListPartialData = await Hive.openBox<PartialPickListDetailsItem>('partial_pick_list_details_item');
          List<String> partialItemsIdsList = List.generate(pickListPartialData.values.toList().length, (i) => pickListPartialData.values.toList()[i].id);


          if (pickListDetailsResponseToUpdate.items[l].status == "Partial") {
            if (partialItemsIdsList.contains(pickListDetailsResponseToUpdate.items[l].id)) {
              PartialPickListDetailsItem data =
                  pickListPartialData.values.toList().firstWhere((element) => element.id == pickListDetailsResponseToUpdate!.items[l].id);
              Map<String, dynamic> pickData = {
                "id": data.id,
                "item_id": data.itemId,
                "picklist_num": data.picklistNum,
                "status": data.status,
                "item_code": data.itemCode,
                "item_name": data.itemName,
                "quantity": data.quantity,
                "picked_qty": data.pickedQty,
                "uom": data.uom,
                "item_type": data.itemType,
                "type_color": data.typeColor.substring(4, data.typeColor.length),
                "floor": data.floor,
                "room": data.room,
                "zone": data.zone,
                "staging_area": data.stagingArea,
                "progress_status": data.isProgressStatus,
                "package_terms": data.packageTerms,
                "catchweight_status": data.catchWeightStatus,
                "catchweight_info": getStringFromCatchWeightList(data: data.catchWeightInfo),
                "catchweight_info_for_list": data.catchWeightInfoForList,
                "picked_catchweight_info": getStringFromCatchWeightList(data: data.catchWeightInfoPicked),
                "handled_by": getListOfMapFromModel(data: data.handledBy),
                "location_dispute_info": data.locationDisputeInfo,
                "unavail_reason": data.unavailableReason,
                "alternative_item_name": data.alternativeItemName,
                "alternative_item_code": data.alternativeItemCode,
                "allow_undo": data.allowUndo,
                "batches_list": List<dynamic>.from(data.batchesList.map((x) => x.toJson())),
              };
              pickListDetailsResponseToUpdate.items[l] = PickListDetailsItem.fromJson(pickData);
              int index = pickListDetailsResponseToUpdate.sessionInfo.partialList.indexWhere((e) => e.id == selectedItem.id);
              pickListDetailsResponseToUpdate.sessionInfo.partialList.removeAt(index);
            } else {
              for (int i = 0; i < pickListDetailsResponseToUpdate.items[l].batchesList.length; i++) {
                pickListDetailsResponseToUpdate.items[l].batchesList[i].pickedQty = "0";
              }
              pickListDetailsResponseToUpdate.items[l].status = "Pending";
              pickListDetailsResponseToUpdate.items[l].isProgressStatus = false;
              pickListDetailsResponseToUpdate.items[l].pickedQty = "0";
              pickListDetailsResponseToUpdate.partial--;
              pickListDetailsResponseToUpdate.yetToPick++;
              int index = pickListDetailsResponseToUpdate.sessionInfo.partialList.indexWhere((e) => e.id == selectedItem.id);
              pickListDetailsResponseToUpdate.sessionInfo.pendingList.add(pickListDetailsResponseToUpdate.sessionInfo.partialList[index]);
              pickListDetailsResponseToUpdate.sessionInfo.partialList.removeAt(index);
              for (int x = 0; x < pickListDetailsResponseToUpdate.items.length; x++) {
                if (pickListDetailsResponseToUpdate.items[x].id == selectedItem.id) {
                  for (int y = 0; y < pickListDetailsResponseToUpdate.items[x].handledBy.length; y++) {
                    pickListDetailsResponseToUpdate.items[x].handledBy[y].pickedItems = "0";
                  }
                }
              }
            }
          }
          else if (pickListDetailsResponseToUpdate.items[l].status == "Picked") {
            if (partialItemsIdsList.contains(pickListDetailsResponseToUpdate.items[l].id)) {
              PartialPickListDetailsItem data =
                  pickListPartialData.values.toList().firstWhere((element) => element.id == pickListDetailsResponseToUpdate!.items[l].id);
              Map<String, dynamic> pickData = {
                "id": data.id,
                "item_id": data.itemId,
                "picklist_num": data.picklistNum,
                "status": data.status,
                "item_code": data.itemCode,
                "item_name": data.itemName,
                "quantity": data.quantity,
                "picked_qty": data.pickedQty,
                "uom": data.uom,
                "item_type": data.itemType,
                "type_color": data.typeColor.substring(4, data.typeColor.length),
                "floor": data.floor,
                "room": data.room,
                "zone": data.zone,
                "staging_area": data.stagingArea,
                "progress_status": data.isProgressStatus,
                "package_terms": data.packageTerms,
                "catchweight_status": data.catchWeightStatus,
                "catchweight_info": getStringFromCatchWeightList(
                    data: data.catchWeightInfo), //List<dynamic>.from(pickListDetailsItemItems[k].catchWeightInfo.map((x) => x.toJson())),
                "catchweight_info_for_list": data.catchWeightInfoForList,
                "picked_catchweight_info": getStringFromCatchWeightList(
                    data: data.catchWeightInfoPicked), //List<dynamic>.from(pickListDetailsItemItems[k].catchWeightInfoPicked.map((x) => x.toJson())),
                "handled_by":
                    getListOfMapFromModel(data: data.handledBy), //List<dynamic>.from(pickListDetailsItemItems[k].handledBy.map((x) => x.toJson())),
                "location_dispute_info": data.locationDisputeInfo,
                "unavail_reason": data.unavailableReason,
                "alternative_item_name": data.alternativeItemName,
                "alternative_item_code": data.alternativeItemCode,
                "allow_undo": data.allowUndo,
                "batches_list": List<dynamic>.from(data.batchesList.map((x) => x.toJson())),
              };
              pickListDetailsResponseToUpdate.items[l] = PickListDetailsItem.fromJson(pickData);
              pickListDetailsResponseToUpdate.picked--;
              pickListDetailsResponseToUpdate.partial++;
              int index = pickListDetailsResponseToUpdate.sessionInfo.pickedList.indexWhere((e) => e.id == selectedItem.id);
              pickListDetailsResponseToUpdate.sessionInfo.pickedList.removeAt(index);
            } else {
              for (int i = 0; i < pickListDetailsResponseToUpdate.items[l].batchesList.length; i++) {
                pickListDetailsResponseToUpdate.items[l].batchesList[i].pickedQty = "0";
              }
              pickListDetailsResponseToUpdate.items[l].status = "Pending";
              pickListDetailsResponseToUpdate.items[l].isProgressStatus = false;
              pickListDetailsResponseToUpdate.items[l].pickedQty = "0";
              pickListDetailsResponseToUpdate.picked--;
              pickListDetailsResponseToUpdate.yetToPick++;
              int index = pickListDetailsResponseToUpdate.sessionInfo.pickedList.indexWhere((e) => e.id == selectedItem.id);
              pickListDetailsResponseToUpdate.sessionInfo.pendingList.add(pickListDetailsResponseToUpdate.sessionInfo.pickedList[index]);
              pickListDetailsResponseToUpdate.sessionInfo.pickedList.removeAt(index);
              for (int x = 0; x < pickListDetailsResponseToUpdate.items.length; x++) {
                if (pickListDetailsResponseToUpdate.items[x].id == selectedItem.id) {
                  for (int y = 0; y < pickListDetailsResponseToUpdate.items[x].handledBy.length; y++) {
                    pickListDetailsResponseToUpdate.items[x].handledBy[y].pickedItems = "0";
                  }
                }
              }
            }
          }
        }
      }
      pickListDetailsResponseToUpdate.pickedItems = (pickListDetailsResponseToUpdate.items.where((e) => e.status == "Picked").toList().length).toString();
      if (pickListDetailsResponseToUpdate.pickedItems == "0") {
        pickListDetailsResponseToUpdate.picklistStatus = "Pending";
      }
      else if (pickListDetailsResponseToUpdate.pickedItems == pickListDetailsResponseToUpdate.totalItems) {
        pickListDetailsResponseToUpdate.picklistStatus = "Completed";
      }
      else {
        pickListDetailsResponseToUpdate.picklistStatus = "Partial";
      }
      List<HandledByPickList> handledByPickListData = [];
      for (int i = 0; i < pickListDetailsResponseToUpdate.items.length; i++) {
        for (int j = 0; j < pickListDetailsResponseToUpdate.items[i].handledBy.length; j++) {
          handledByPickListData.add(pickListDetailsResponseToUpdate.items[i].handledBy[j]);
        }
      }
      pickListDetailsResponseToUpdate.handledBy.clear();
      pickListDetailsResponseToUpdate.handledBy.addAll(mergeHandledByPickList(handledByPickListData: handledByPickListData));
      pickListDetailsResponseToUpdate.isReadyToMoveComplete = false;
      pickListDetailsResponseToUpdate.sessionInfo.isOpened = true;
      pickListDetailsResponseToUpdate.sessionInfo.pending = pickListDetailsResponseToUpdate.sessionInfo.pendingList.length.toString();
      pickListDetailsResponseToUpdate.sessionInfo.picked = pickListDetailsResponseToUpdate.sessionInfo.pickedList.length.toString();
      pickListDetailsResponseToUpdate.sessionInfo.partial = pickListDetailsResponseToUpdate.sessionInfo.partialList.length.toString();
      pickListDetailsResponseToUpdate.sessionInfo.unavailable = pickListDetailsResponseToUpdate.sessionInfo.unavailableList.length.toString();
      if (pickListDetailsResponseToUpdate.sessionInfo.sessionStartTimestamp == "") {
        pickListDetailsResponseToUpdate.sessionInfo.sessionStartTimestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      }
      await pickListDetailsResponseBoxData.put(keyToUpdate, pickListDetailsResponseToUpdate);
    }


    Box<PickListMainResponse> pickListMainResponseBoxData = await Hive.openBox<PickListMainResponse>('pick_list_main_response');
    PickListMainResponse pickListMainResponseToUpdate = pickListMainResponseBoxData.getAt(0)!;
    for (int x = 0; x < pickListMainResponseToUpdate.picklist.length; x++) {
      if (pickListMainResponseToUpdate.picklist[x].id == selectedPickListId) {
        pickListMainResponseToUpdate.picklist[x].handledBy.clear();
        pickListMainResponseToUpdate.picklist[x].handledBy.addAll(pickListDetailsResponseToUpdate!.handledBy);
        pickListMainResponseToUpdate.picklist[x].pickedQty = pickListDetailsResponseToUpdate.pickedItems;
        if (pickListMainResponseToUpdate.picklist[x].pickedQty == "0") {
          pickListMainResponseToUpdate.picklist[x].status = "Pending";
          pickListMainResponseToUpdate.picklist[x].statusColor = "DC474A";
          pickListMainResponseToUpdate.picklist[x].statusBGColor = "ffCCCF";
          pickListMainResponseToUpdate.picklist[x].inProgress = false;
        } else if (num.parse(pickListDetailsResponseToUpdate.items.where((e) => e.status == "Picked").toList().length.toString()) ==
            num.parse(pickListMainResponseToUpdate.picklist[x].quantity)) {
          pickListMainResponseToUpdate.picklist[x].status = "Completed";
          pickListMainResponseToUpdate.picklist[x].statusColor = "007838";
          pickListMainResponseToUpdate.picklist[x].statusBGColor = "C9F2DC";
          pickListMainResponseToUpdate.picklist[x].inProgress = false;
        } else {
          pickListMainResponseToUpdate.picklist[x].status = "Partial";
          pickListMainResponseToUpdate.picklist[x].statusColor = "72492B";
          pickListMainResponseToUpdate.picklist[x].statusBGColor = "ffDDC5";
          pickListMainResponseToUpdate.picklist[x].inProgress = true;
        }
      }
    }
    await pickListMainResponseBoxData.put(0, pickListMainResponseToUpdate);
  }*/

  /*unavailableItemFunction() async {
    Box<PickListDetailsResponse> pickListDetailsResponseBoxData = await Hive.openBox<PickListDetailsResponse>('pick_list_details_response');
    int? keyToUpdate;
    PickListDetailsResponse? pickListDetailsResponseToUpdate;
    String userCode = getIt<Variables>().generalVariables.userDataEmployeeCode;
    List<FilterOptionsResponse> usersList = getIt<Variables>().generalVariables.userData.usersList;
    HandledByPickList userHandled = HandledByPickList.fromJson(usersList.singleWhere((user) => user.code == userCode).toJson());
    for (var key in pickListDetailsResponseBoxData.keys) {
      PickListDetailsResponse? pickListDetailsResponseTemp = pickListDetailsResponseBoxData.get(key);
      if (pickListDetailsResponseTemp != null && pickListDetailsResponseTemp.picklistId == selectedPickListId) {
        keyToUpdate = key;
        pickListDetailsResponseToUpdate = pickListDetailsResponseTemp;
        break;
      }
    }
    if (keyToUpdate != null && pickListDetailsResponseToUpdate != null) {
      for (int x = 0; x < pickListDetailsResponseToUpdate.items.length; x++) {
        if (pickListDetailsResponseToUpdate.items[x].id == selectedItem.id) {
          if (pickListDetailsResponseToUpdate.items[x].handledBy.isNotEmpty) {
            List<String> pickListHandledByCodeList = List.generate(
                pickListDetailsResponseToUpdate.items[x].handledBy.length, (i) => pickListDetailsResponseToUpdate!.items[x].handledBy[i].code);
            if (pickListHandledByCodeList.contains(userHandled.code)) {
            } else {
              pickListDetailsResponseToUpdate.items[x].handledBy.add(userHandled);
            }
          } else {
            pickListDetailsResponseToUpdate.items[x].handledBy.add(userHandled);
          }
          pickListDetailsResponseToUpdate.items[x].status = "Unavailable";
          pickListDetailsResponseToUpdate.items[x].isProgressStatus = false;
          pickListDetailsResponseToUpdate.items[x].unavailableReason = selectedReasonName ?? "";
          pickListDetailsResponseToUpdate.items[x].alternativeItemName = selectedAltItemName ?? '';
          pickListDetailsResponseToUpdate.items[x].alternativeItemCode = selectedAltItemCode ?? '';
        }
      }
      pickListDetailsResponseToUpdate.yetToPick--;
      pickListDetailsResponseToUpdate.unavailable++;
      int index = pickListDetailsResponseToUpdate.sessionInfo.pendingList.indexWhere((e) => e.id == selectedItem.id);
      if (index == -1) {
        pickListDetailsResponseToUpdate.sessionInfo.unavailableList
            .add(pickListDetailsResponseToUpdate.items.singleWhere((e) => e.id == selectedItem.id));
      } else {
        pickListDetailsResponseToUpdate.sessionInfo.unavailableList.add(pickListDetailsResponseToUpdate.sessionInfo.pendingList[index]);
        pickListDetailsResponseToUpdate.sessionInfo.pendingList.removeAt(index);
      }
      pickListDetailsResponseToUpdate.pickedItems =
          (pickListDetailsResponseToUpdate.items.where((e) => e.status == "Picked").toList().length).toString();
      if (pickListDetailsResponseToUpdate.pickedItems == "0") {
        pickListDetailsResponseToUpdate.picklistStatus = "Pending";
      }
      else if (pickListDetailsResponseToUpdate.pickedItems == pickListDetailsResponseToUpdate.totalItems) {
        pickListDetailsResponseToUpdate.picklistStatus = "Completed";
      }
      else {
        pickListDetailsResponseToUpdate.picklistStatus = "Partial";
      }
      List<HandledByPickList> handledByPickListData = [];
      for (int i = 0; i < pickListDetailsResponseToUpdate.items.length; i++) {
        for (int j = 0; j < pickListDetailsResponseToUpdate.items[i].handledBy.length; j++) {
          handledByPickListData.add(pickListDetailsResponseToUpdate.items[i].handledBy[j]);
        }
      }
      pickListDetailsResponseToUpdate.handledBy.clear();
      pickListDetailsResponseToUpdate.handledBy.addAll(mergeHandledByPickList(handledByPickListData: handledByPickListData));
      pickListDetailsResponseToUpdate.isReadyToMoveComplete = false;
      pickListDetailsResponseToUpdate.sessionInfo.isOpened = true;
      pickListDetailsResponseToUpdate.sessionInfo.pending = pickListDetailsResponseToUpdate.sessionInfo.pendingList.length.toString();
      pickListDetailsResponseToUpdate.sessionInfo.picked = pickListDetailsResponseToUpdate.sessionInfo.pickedList.length.toString();
      pickListDetailsResponseToUpdate.sessionInfo.partial = pickListDetailsResponseToUpdate.sessionInfo.partialList.length.toString();
      pickListDetailsResponseToUpdate.sessionInfo.unavailable = pickListDetailsResponseToUpdate.sessionInfo.unavailableList.length.toString();
      if (pickListDetailsResponseToUpdate.sessionInfo.sessionStartTimestamp == "") {
        pickListDetailsResponseToUpdate.sessionInfo.sessionStartTimestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      }
      await pickListDetailsResponseBoxData.put(keyToUpdate, pickListDetailsResponseToUpdate);
    }


    Box<PickListMainResponse> pickListMainResponseBoxData = await Hive.openBox<PickListMainResponse>('pick_list_main_response');
    PickListMainResponse pickListMainResponseToUpdate = pickListMainResponseBoxData.getAt(0)!;
    for (int x = 0; x < pickListMainResponseToUpdate.picklist.length; x++) {
      if (pickListMainResponseToUpdate.picklist[x].id == selectedPickListId) {
        pickListMainResponseToUpdate.picklist[x].handledBy.clear();
        pickListMainResponseToUpdate.picklist[x].handledBy.addAll(pickListDetailsResponseToUpdate!.handledBy);
        pickListMainResponseToUpdate.picklist[x].pickedQty = pickListDetailsResponseToUpdate.pickedItems;
        if (pickListMainResponseToUpdate.picklist[x].pickedQty == "0") {
          pickListMainResponseToUpdate.picklist[x].status = "Pending";
          pickListMainResponseToUpdate.picklist[x].statusColor = "DC474A";
          pickListMainResponseToUpdate.picklist[x].statusBGColor = "ffCCCF";
          pickListMainResponseToUpdate.picklist[x].inProgress = false;
        } else if (num.parse(pickListDetailsResponseToUpdate.items.where((e) => e.status == "Picked").toList().length.toString()) ==
            num.parse(pickListMainResponseToUpdate.picklist[x].quantity)) {
          pickListMainResponseToUpdate.picklist[x].status = "Completed";
          pickListMainResponseToUpdate.picklist[x].statusColor = "007838";
          pickListMainResponseToUpdate.picklist[x].statusBGColor = "C9F2DC";
          pickListMainResponseToUpdate.picklist[x].inProgress = false;
        } else {
          pickListMainResponseToUpdate.picklist[x].status = "Partial";
          pickListMainResponseToUpdate.picklist[x].statusColor = "72492B";
          pickListMainResponseToUpdate.picklist[x].statusBGColor = "ffDDC5";
          pickListMainResponseToUpdate.picklist[x].inProgress = true;
        }
      }
    }
    await pickListMainResponseBoxData.put(0, pickListMainResponseToUpdate);
  }*/

  /* locationUpdateFunction({required Map<String, dynamic> queryData}) async {
    Box<PickListDetailsResponse> pickListDetailsResponseBoxData = await Hive.openBox<PickListDetailsResponse>('pick_list_details_response');
    int? keyToUpdate;
    PickListDetailsResponse? pickListDetailsResponseToUpdate;
    for (var key in pickListDetailsResponseBoxData.keys) {
      PickListDetailsResponse? pickListDetailsResponseTemp = pickListDetailsResponseBoxData.get(key);
      if (pickListDetailsResponseTemp != null && pickListDetailsResponseTemp.picklistId == selectedPickListId) {
        keyToUpdate = key;
        pickListDetailsResponseToUpdate = pickListDetailsResponseTemp;
        break;
      }
    }
    if (keyToUpdate != null && pickListDetailsResponseToUpdate != null) {
      for (int x = 0; x < pickListDetailsResponseToUpdate.items.length; x++) {
        if (pickListDetailsResponseToUpdate.items[x].id == selectedItem.id) {
          pickListDetailsResponseToUpdate.items[x].locationDisputeInfo = LocationDisputeInfo(
              updatedOn: DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now()),
              floor: queryData["query_data"]["floor"],
              room: queryData["query_data"]["room"],
              zone: queryData["query_data"]["zone"]);
        }
      }
      pickListDetailsResponseToUpdate.sessionInfo.isOpened = true;
      if (pickListDetailsResponseToUpdate.sessionInfo.sessionStartTimestamp == "") {
        pickListDetailsResponseToUpdate.sessionInfo.sessionStartTimestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      }
      await pickListDetailsResponseBoxData.put(keyToUpdate, pickListDetailsResponseToUpdate);
    }
  }*/

  /*completeFunction() async {
    Box<PickListDetailsResponse> pickListDetailsResponseBoxData = await Hive.openBox<PickListDetailsResponse>('pick_list_details_response');
    int? keyToUpdate;
    PickListDetailsResponse? pickListDetailsResponseToUpdate;
    for (var key in pickListDetailsResponseBoxData.keys) {
      PickListDetailsResponse? pickListDetailsResponseTemp = pickListDetailsResponseBoxData.get(key);
      if (pickListDetailsResponseTemp != null && pickListDetailsResponseTemp.picklistId == selectedPickListId) {
        keyToUpdate = key;
        pickListDetailsResponseToUpdate = pickListDetailsResponseTemp;
        break;
      }
    }
    if (keyToUpdate != null && pickListDetailsResponseToUpdate != null) {
      pickListDetailsResponseToUpdate.isReadyToMoveComplete = false;
      pickListDetailsResponseToUpdate.isCompleted = true;
      pickListDetailsResponseToUpdate.picklistStatus = "Completed";
      await pickListDetailsResponseBoxData.put(keyToUpdate, pickListDetailsResponseToUpdate);
    }
    Box<PickListMainResponse> pickListMainResponseBoxData = await Hive.openBox<PickListMainResponse>('pick_list_main_response');
    PickListMainResponse pickListMainResponseToUpdate = pickListMainResponseBoxData.getAt(0)!;
    for (int x = 0; x < pickListMainResponseToUpdate.picklist.length; x++) {
      if (pickListMainResponseToUpdate.picklist[x].id == selectedPickListId) {
        pickListMainResponseToUpdate.picklist[x].status = "Completed";
        pickListMainResponseToUpdate.picklist[x].statusColor = "007838";
        pickListMainResponseToUpdate.picklist[x].statusBGColor = "C9F2DC";
        pickListMainResponseToUpdate.picklist[x].inProgress = false;
      }
    }
    await pickListMainResponseBoxData.put(0, pickListMainResponseToUpdate);
  }*/

  /*sessionCloseFunction({required String sessionTime}) async {
    Box<PickListDetailsResponse> pickListDetailsResponseBoxData = await Hive.openBox<PickListDetailsResponse>('pick_list_details_response');
    int? keyToUpdate;
    PickListDetailsResponse? pickListDetailsResponseToUpdate;
    for (var key in pickListDetailsResponseBoxData.keys) {
      PickListDetailsResponse? pickListDetailsResponseTemp = pickListDetailsResponseBoxData.get(key);
      if (pickListDetailsResponseTemp != null && pickListDetailsResponseTemp.picklistId == selectedPickListId) {
        keyToUpdate = key;
        pickListDetailsResponseToUpdate = pickListDetailsResponseTemp;
        break;
      }
    }
    if (keyToUpdate != null && pickListDetailsResponseToUpdate != null) {
      for (int x = 0; x < pickListDetailsResponseToUpdate.items.length; x++) {
        if ((pickListDetailsResponseToUpdate.items[x].status == "Picked" ||
                pickListDetailsResponseToUpdate.items[x].status == "Partial" ||
                pickListDetailsResponseToUpdate.items[x].status == "Unavailable") &&
            pickListDetailsResponseToUpdate.items[x].isProgressStatus &&
            (pickListDetailsResponseToUpdate.items[x].handledBy.isNotEmpty
                ? (pickListDetailsResponseToUpdate.items[x].handledBy[0].code == getIt<Variables>().generalVariables.userDataEmployeeCode)
                : false)) {
          pickListDetailsResponseToUpdate.items[x].isProgressStatus = false;
        }
      }
      for (int i = 0; i < pickListDetailsResponseToUpdate.items.length; i++) {
        for (int j = 0; j < pickListDetailsResponseToUpdate.sessionInfo.pendingList.length; j++) {
          if (pickListDetailsResponseToUpdate.items[i].id == pickListDetailsResponseToUpdate.sessionInfo.pendingList[j].id) {
            pickListDetailsResponseToUpdate.items[i].stagingArea =
                stagingAreaList.singleWhere((element) => element.id == selectedStagingAreaId).label;
          }
        }
      }
      for (int i = 0; i < pickListDetailsResponseToUpdate.items.length; i++) {
        for (int j = 0; j < pickListDetailsResponseToUpdate.sessionInfo.pickedList.length; j++) {
          if (pickListDetailsResponseToUpdate.items[i].id == pickListDetailsResponseToUpdate.sessionInfo.pickedList[j].id) {
            pickListDetailsResponseToUpdate.items[i].stagingArea =
                stagingAreaList.singleWhere((element) => element.id == selectedStagingAreaId).label;
          }
        }
      }
      for (int i = 0; i < pickListDetailsResponseToUpdate.items.length; i++) {
        for (int j = 0; j < pickListDetailsResponseToUpdate.sessionInfo.partialList.length; j++) {
          if (pickListDetailsResponseToUpdate.items[i].id == pickListDetailsResponseToUpdate.sessionInfo.partialList[j].id) {
            pickListDetailsResponseToUpdate.items[i].stagingArea =
                stagingAreaList.singleWhere((element) => element.id == selectedStagingAreaId).label;
          }
        }
      }
      for (int i = 0; i < pickListDetailsResponseToUpdate.items.length; i++) {
        for (int j = 0; j < pickListDetailsResponseToUpdate.sessionInfo.unavailableList.length; j++) {
          if (pickListDetailsResponseToUpdate.items[i].id == pickListDetailsResponseToUpdate.sessionInfo.unavailableList[j].id) {
            pickListDetailsResponseToUpdate.items[i].stagingArea =
                stagingAreaList.singleWhere((element) => element.id == selectedStagingAreaId).label;
          }
        }
      }
      pickListDetailsResponseToUpdate.sessionInfo.isOpened = false;
      pickListDetailsResponseToUpdate.sessionInfo.id = "";
      pickListDetailsResponseToUpdate.sessionInfo.pending = "0";
      pickListDetailsResponseToUpdate.sessionInfo.picked = "0";
      pickListDetailsResponseToUpdate.sessionInfo.partial = "0";
      pickListDetailsResponseToUpdate.sessionInfo.unavailable = "0";
      pickListDetailsResponseToUpdate.sessionInfo.sessionStartTimestamp = "";
      pickListDetailsResponseToUpdate.sessionInfo.partialIdsList = [];
      pickListDetailsResponseToUpdate.sessionInfo.pendingList = [];
      pickListDetailsResponseToUpdate.sessionInfo.pickedList = [];
      pickListDetailsResponseToUpdate.sessionInfo.partialList = [];
      pickListDetailsResponseToUpdate.sessionInfo.unavailableList = [];
      pickListDetailsResponseToUpdate.isReadyToMoveComplete =
          pickListDetailsResponseToUpdate.items.where((x) => x.status == "Pending").toList().isEmpty &&
              pickListDetailsResponseToUpdate.items.where((x) => x.status == "Partial").toList().isNotEmpty;
      pickListDetailsResponseToUpdate.sessionInfo.partialIdsList = List.generate(
          (pickListDetailsResponseToUpdate.items.where((e) => e.status == "Partial").toList()).length,
          (l) => pickListDetailsResponseToUpdate!.items.where((e) => e.status == "Partial").toList()[l].id);
      pickListDetailsResponse = pickListDetailsResponseToUpdate;
      await pickListDetailsResponseBoxData.put(keyToUpdate, pickListDetailsResponseToUpdate);
    }
    Box<PickListMainResponse> pickListMainResponseBoxData = await Hive.openBox<PickListMainResponse>('pick_list_main_response');
    PickListMainResponse? pickListMainResponseToUpdate = pickListMainResponseBoxData.getAt(0);
    for (int x = 0; x < pickListMainResponseToUpdate!.picklist.length; x++) {
      if (pickListMainResponseToUpdate.picklist[x].id == selectedPickListId) {
        pickListMainResponseToUpdate.picklist[x].inProgress = false;
      }
    }
    await pickListMainResponseBoxData.put(0, pickListMainResponseToUpdate);
    Box<PartialPickListDetailsItem> pickListPartialData = await Hive.openBox<PartialPickListDetailsItem>('partial_pick_list_details_item');
    var keys = pickListPartialData.keys.toList();
    for (var key in keys) {
      PartialPickListDetailsItem? partialPickListItemData = pickListPartialData.get(key);
      if (partialPickListItemData != null && partialPickListItemData.picklistNum == pickListDetailsResponseToUpdate!.picklistNum) {
        await pickListPartialData.delete(key);
      }
    }
    List<PickListDetailsItem> pickListDetailsItemItems = pickListDetailsResponseToUpdate!.items.where((e) => e.status == "Partial").toList();
    List<Map<String, dynamic>> pickListDetailsItemItemsValue = [];
    for (int k = 0; k < pickListDetailsItemItems.length; k++) {
      pickListDetailsItemItemsValue.add({
        "id": pickListDetailsItemItems[k].id,
        "item_id": pickListDetailsItemItems[k].itemId,
        "picklist_num": pickListDetailsItemItems[k].picklistNum,
        "status": pickListDetailsItemItems[k].status,
        "item_code": pickListDetailsItemItems[k].itemCode,
        "item_name": pickListDetailsItemItems[k].itemName,
        "quantity": pickListDetailsItemItems[k].quantity,
        "picked_qty": pickListDetailsItemItems[k].pickedQty,
        "uom": pickListDetailsItemItems[k].uom,
        "item_type": pickListDetailsItemItems[k].itemType,
        "type_color": pickListDetailsItemItems[k].typeColor,
        "floor": pickListDetailsItemItems[k].floor,
        "room": pickListDetailsItemItems[k].room,
        "zone": pickListDetailsItemItems[k].zone,
        "staging_area": stagingAreaList.singleWhere((element) => element.id == selectedStagingAreaId).label,
        "progress_status": pickListDetailsItemItems[k].isProgressStatus,
        "package_terms": pickListDetailsItemItems[k].packageTerms,
        "catchweight_status": pickListDetailsItemItems[k].catchWeightStatus,
        "catchweight_info": getStringFromCatchWeightList(data: pickListDetailsItemItems[k].catchWeightInfo),
        "catchweight_info_for_list": pickListDetailsItemItems[k].catchWeightInfoForList,
        "picked_catchweight_info": getStringFromCatchWeightList(data: pickListDetailsItemItems[k].catchWeightInfoPicked),
        "handled_by": getListOfMapFromModel(data: pickListDetailsItemItems[k].handledBy),
        "location_dispute_info": pickListDetailsItemItems[k].locationDisputeInfo,
        "unavail_reason": pickListDetailsItemItems[k].unavailableReason,
        "alternative_item_name": pickListDetailsItemItems[k].alternativeItemName,
        "alternative_item_code": pickListDetailsItemItems[k].alternativeItemCode,
        "allow_undo": pickListDetailsItemItems[k].allowUndo,
        "batches_list": List<dynamic>.from(pickListDetailsItemItems[k].batchesList.map((x) => x.toJson())),
      });
    }
    pickListPartialData.addAll(List<PartialPickListDetailsItem>.from(pickListDetailsItemItemsValue.map((x) => PartialPickListDetailsItem.fromJson(x))));
  }*/

  filterItemFunction() async {
    // Box<PickListDetailsResponse> pickListDetailsResponseBoxData = await Hive.openBox<PickListDetailsResponse>('pick_list_details_response');
    // for (var key in pickListDetailsResponseBoxData.keys) {
    //   PickListDetailsResponse? pickListDetailsResponseTemp = pickListDetailsResponseBoxData.get(key);
    //   if (pickListDetailsResponseTemp != null && pickListDetailsResponseTemp.picklistId == selectedPickListId) {
    //     pickListDetailsResponse = pickListDetailsResponseTemp;
    //     break;
    //   }
    // }
    getIt<Variables>().generalVariables.picklistSocketTempStatus = tabName;
    List<PickListDetailsItem> tabPickListItems = [];
    tabPickListItems.clear();
    tabPickListItems = (pickListDetailsResponse.items.where((e) => e.status == tabName)).toList();
    if (searchText.isNotEmpty) {
      tabPickListItems = tabPickListItems
          .where((x) =>
              x.itemCode.toLowerCase().contains(searchText.toLowerCase()) ||
              x.itemType.toLowerCase().contains(searchText.toLowerCase()) ||
              x.itemName.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
    List<PickListDetailsItem> filteredList = [];
    filteredList.addAll(tabPickListItems);
    for (int i = 0; i < getIt<Variables>().generalVariables.selectedFilters.length; i++) {
      switch (getIt<Variables>().generalVariables.selectedFilters[i].type) {
        case "item_type":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.itemType == item2))
                .toList();
          }
        case "so_num":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.soNum == item2))
                .toList();
          }
        case "floor":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.floor == item2))
                .toList();
          }
        case "item_code":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.itemCode == item2))
                .toList();
          }
        case "sort_by_location":
          {
            for (int j = 0; j < getIt<Variables>().generalVariables.selectedFilters[i].options.length; j++) {
              switch (getIt<Variables>().generalVariables.selectedFilters[i].options[j]) {
                case "1":
                  {
                    filteredList.sort((a, b) => a.floor.toLowerCase().compareTo(b.floor.toLowerCase()));
                  }
                case "-1":
                  {
                    filteredList.sort((a, b) => a.floor.toLowerCase().compareTo(b.floor.toLowerCase()));
                    filteredList.reversed;
                  }
                default:
                  {
                    filteredList.sort((a, b) => a.floor.toLowerCase().compareTo(b.floor.toLowerCase()));
                  }
              }
            }
            /*filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.itemCode == item2))
                .toList();*/
          }
        default:
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.itemType == item2))
                .toList();
          }
      }
    }
    tabPickListItems.clear();
    tabPickListItems.addAll(filteredList);
    switch (tabName) {
      case "Pending":
        {
          ///for picked list grouped by floor,room & zone
          Map<String, List<PickListDetailsItem>> grouped =
              groupBy(tabPickListItems, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
          groupedPickedData = grouped.values.toList();
        }
      case "Picked":
        {
          ///for picked list grouped by floor & staging area
          List<PickListDetailsItem> pickedList = (tabPickListItems.where((element) => !element.isProgressStatus).toList());
          Map<String, List<PickListDetailsItem>> pickedGroup = groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
          groupedPickedData = pickedGroup.values.toList();

          ///for picking in progress list grouped by storekeeper
          List<PickListDetailsItem> pickingList = (tabPickListItems.where((element) => element.isProgressStatus).toList());
          Map<String, List<PickListDetailsItem>> groupedData = {};
          for (PickListDetailsItem item in pickingList) {
            List<HandledByPickList> handledBy = item.handledBy;
            for (HandledByPickList handler in handledBy) {
              String name = handler.name;
              if (!groupedData.containsKey(name)) {
                groupedData[name] = [];
              }
              groupedData[name]!.add(item);
            }
          }
          groupedKeepersNameList = groupedData.keys.toList();
          groupedPickingData = groupedData.values.toList();
        }
      case "Partial":
        {
          ///for picked list grouped by floor & staging area
          List<PickListDetailsItem> pickedList = (tabPickListItems.where((element) => !element.isProgressStatus).toList());
          Map<String, List<PickListDetailsItem>> pickedGroup = groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
          groupedPickedData = pickedGroup.values.toList();

          ///for picking in progress list grouped by storekeeper
          List<PickListDetailsItem> pickingList = (tabPickListItems.where((element) => element.isProgressStatus).toList());
          Map<String, List<PickListDetailsItem>> groupedData = {};
          for (PickListDetailsItem item in pickingList) {
            List<HandledByPickList> handledBy = item.handledBy;
            for (HandledByPickList handler in handledBy) {
              String name = handler.name;
              if (!groupedData.containsKey(name)) {
                groupedData[name] = [];
              }
              groupedData[name]!.add(item);
            }
          }
          groupedKeepersNameList = groupedData.keys.toList();
          groupedPickingData = groupedData.values.toList();
        }
      case "Unavailable":
        {
          ///for picked list grouped by floor
          Map<String, List<PickListDetailsItem>> grouped = groupBy(tabPickListItems, (PickListDetailsItem item) => item.floor);
          groupedPickedData = grouped.values.toList();
        }
      default:
        {
          ///for picked list grouped by floor,room & zone
          Map<String, List<PickListDetailsItem>> grouped =
              groupBy(tabPickListItems, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
          groupedPickedData = grouped.values.toList();
        }
    }
  }

  String getStringFromCatchWeightList({required List<CatchWeightItem> data}) {
    return List<String>.generate(data.length, (i) => data[i].data).join(",");
  }

  List<Map<String, dynamic>> getListOfMapFromModel({required List<HandledByPickList> data}) {
    return List.generate(data.length, (i) => data[i].toJson());
  }

  List<HandledByPickList> mergeHandledByPickList({required List<HandledByPickList> handledByPickListData}) {
    Map<String, HandledByPickList> mergedMap = {};
    for (int i = 0; i < handledByPickListData.length; i++) {
      if (mergedMap.containsKey(handledByPickListData[i].code)) {
        num existingPicked = num.parse(mergedMap[handledByPickListData[i].code]!.pickedItems);
        num newPicked = num.parse(handledByPickListData[i].pickedItems);
        mergedMap[handledByPickListData[i].code]!.pickedItems = (existingPicked + newPicked).toString();
      } else {
        mergedMap[handledByPickListData[i].code] = HandledByPickList(
          id: handledByPickListData[i].id,
          code: handledByPickListData[i].code,
          name: handledByPickListData[i].name,
          image: handledByPickListData[i].image,
          pickedItems: handledByPickListData[i].pickedItems,
        );
      }
    }
    return mergedMap.values.toList();
  }

  /*Future getTabsCountData() async{
    pickListDetailsResponse.yetToPick=0;
    if(true){
      Map<String, List<PickListDetailsItem>> grouped = groupBy((pickListDetailsResponse.items.where((e) => e.status == "Pending")).toList(),
              (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
      List<List<PickListDetailsItem>> groupedPickedDataPending=[];
      for(int i=0;i<grouped.values.toList().length;i++){
        groupedPickedDataPending.add([]);
        List<PickListDetailsItem> firstGroupedPickedData = grouped.values.toList()[i];
        Map<String, List<PickListDetailsItem>> firstGroupedPickedDataGrouped = groupBy(firstGroupedPickedData, (PickListDetailsItem data) => data.itemId);
        List<List<PickListDetailsItem>> firstGroupedPickedDataGroupedList = firstGroupedPickedDataGrouped.values.toList();
        for(int j=0;j<firstGroupedPickedDataGroupedList.length;j++){
          List<PickListDetailsItem> firstFirstGroupedPickedDataGroupedList = firstGroupedPickedDataGroupedList[j];
          PickListDetailsItem selectedPickListItem = PickListDetailsItem(
              id: firstFirstGroupedPickedDataGroupedList[0].id,
              itemId: firstFirstGroupedPickedDataGroupedList[0].itemId,
              picklistNum: firstFirstGroupedPickedDataGroupedList[0].picklistNum,
              status: firstFirstGroupedPickedDataGroupedList[0].status,
              itemCode: firstFirstGroupedPickedDataGroupedList[0].itemCode,
              itemName: firstFirstGroupedPickedDataGroupedList[0].itemName,
              quantity: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].batchesList[0].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
              pickedQty: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].batchesList[0].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
              uom: firstFirstGroupedPickedDataGroupedList[0].uom,
              itemType: firstFirstGroupedPickedDataGroupedList[0].itemType,
              typeColor: firstFirstGroupedPickedDataGroupedList[0].typeColor,
              floor: firstFirstGroupedPickedDataGroupedList[0].floor,
              room: firstFirstGroupedPickedDataGroupedList[0].room,
              zone: firstFirstGroupedPickedDataGroupedList[0].zone,
              stagingArea: firstFirstGroupedPickedDataGroupedList[0].stagingArea,
              isProgressStatus: firstFirstGroupedPickedDataGroupedList[0].isProgressStatus,
              packageTerms: firstFirstGroupedPickedDataGroupedList[0].packageTerms,
              catchWeightStatus: firstFirstGroupedPickedDataGroupedList[0].catchWeightStatus,
              catchWeightInfo: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfo,
              catchWeightInfoForList: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoForList,
              catchWeightInfoPicked: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoPicked,
              handledBy: firstFirstGroupedPickedDataGroupedList[0].handledBy,
              locationDisputeInfo: firstFirstGroupedPickedDataGroupedList[0].locationDisputeInfo,
              unavailableReason: firstFirstGroupedPickedDataGroupedList[0].unavailableReason,
              alternativeItemName: firstFirstGroupedPickedDataGroupedList[0].alternativeItemName,
              alternativeItemCode: firstFirstGroupedPickedDataGroupedList[0].alternativeItemCode,
              batchesList: List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>firstFirstGroupedPickedDataGroupedList[i].batchesList[0]),
              allowUndo: firstFirstGroupedPickedDataGroupedList[0].allowUndo,
              soNum: firstFirstGroupedPickedDataGroupedList[0].soNum);
          groupedPickedDataPending[i].add(selectedPickListItem);
        }
      }
      for(int i=0;i<groupedPickedDataPending.length;i++){
        pickListDetailsResponse.yetToPick+=groupedPickedDataPending[i].length;
      }
    }
    pickListDetailsResponse.picked=0;
    if(true){
      List<PickListDetailsItem> tabPickListItems = (pickListDetailsResponse.items.where((e) => e.status == "Picked")).toList();
      List<PickListDetailsItem> pickedList = (tabPickListItems.where((element) => !element.isProgressStatus).toList());
      Map<String, List<PickListDetailsItem>> pickedGroup = groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
      List<List<PickListDetailsItem>> tempGroupedPickedData =[];
      for(int i=0;i<pickedGroup.values.toList().length;i++){
        tempGroupedPickedData.add([]);
        List<PickListDetailsItem> firstGroupedPickedData = pickedGroup.values.toList()[i];
        Map<String, List<PickListDetailsItem>> firstGroupedPickedDataGrouped = groupBy(firstGroupedPickedData, (PickListDetailsItem data) => data.itemId);
        List<List<PickListDetailsItem>> firstGroupedPickedDataGroupedList = firstGroupedPickedDataGrouped.values.toList();
        for(int j=0;j<firstGroupedPickedDataGroupedList.length;j++){
          List<PickListDetailsItem> firstFirstGroupedPickedDataGroupedList = firstGroupedPickedDataGroupedList[j];
          PickListDetailsItem selectedPickListItem = PickListDetailsItem(
              id: firstFirstGroupedPickedDataGroupedList[0].id,
              itemId: firstFirstGroupedPickedDataGroupedList[0].itemId,
              picklistNum: firstFirstGroupedPickedDataGroupedList[0].picklistNum,
              status: firstFirstGroupedPickedDataGroupedList[0].status,
              itemCode: firstFirstGroupedPickedDataGroupedList[0].itemCode,
              itemName: firstFirstGroupedPickedDataGroupedList[0].itemName,
              quantity: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
              pickedQty: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
              uom: firstFirstGroupedPickedDataGroupedList[0].uom,
              itemType: firstFirstGroupedPickedDataGroupedList[0].itemType,
              typeColor: firstFirstGroupedPickedDataGroupedList[0].typeColor,
              floor: firstFirstGroupedPickedDataGroupedList[0].floor,
              room: firstFirstGroupedPickedDataGroupedList[0].room,
              zone: firstFirstGroupedPickedDataGroupedList[0].zone,
              stagingArea: firstFirstGroupedPickedDataGroupedList[0].stagingArea,
              isProgressStatus: firstFirstGroupedPickedDataGroupedList[0].isProgressStatus,
              packageTerms: firstFirstGroupedPickedDataGroupedList[0].packageTerms,
              catchWeightStatus: firstFirstGroupedPickedDataGroupedList[0].catchWeightStatus,
              catchWeightInfo: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfo,
              catchWeightInfoForList: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoForList,
              catchWeightInfoPicked: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoPicked,
              handledBy: firstFirstGroupedPickedDataGroupedList[0].handledBy,
              locationDisputeInfo: firstFirstGroupedPickedDataGroupedList[0].locationDisputeInfo,
              unavailableReason: firstFirstGroupedPickedDataGroupedList[0].unavailableReason,
              alternativeItemName: firstFirstGroupedPickedDataGroupedList[0].alternativeItemName,
              alternativeItemCode: firstFirstGroupedPickedDataGroupedList[0].alternativeItemCode,
              batchesList: List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>firstFirstGroupedPickedDataGroupedList[i].batchesList[0]),
              allowUndo: firstFirstGroupedPickedDataGroupedList[0].allowUndo,
              soNum: firstFirstGroupedPickedDataGroupedList[0].soNum);
          tempGroupedPickedData[i].add(selectedPickListItem);
        }
      }
      List<PickListDetailsItem> pickingList = (tabPickListItems.where((element) => element.isProgressStatus).toList());
      Map<String, List<PickListDetailsItem>> groupedData = {};
      for (PickListDetailsItem item in pickingList) {
        List<HandledByPickList> handledBy = item.handledBy;
        for (HandledByPickList handler in handledBy) {
          String name = handler.name;
          if (!groupedData.containsKey(name)) {
            groupedData[name] = [];
          }
          groupedData[name]!.add(item);
        }
      }
      List<List<PickListDetailsItem>> tempGroupedPickingData =[];
      for(int i=0;i<groupedData.values.toList().length;i++){
        tempGroupedPickingData.add([]);
        List<PickListDetailsItem> firstGroupedPickingData = groupedData.values.toList()[i];
        Map<String, List<PickListDetailsItem>> firstGroupedPickingDataGrouped = groupBy(firstGroupedPickingData, (PickListDetailsItem data) => data.itemId);
        List<List<PickListDetailsItem>> firstGroupedPickingDataGroupedList = firstGroupedPickingDataGrouped.values.toList();
        for(int j=0;j<firstGroupedPickingDataGroupedList.length;j++){
          List<PickListDetailsItem> firstFirstGroupedPickingDataGroupedList = firstGroupedPickingDataGroupedList[j];
          PickListDetailsItem selectedPickListItem = PickListDetailsItem(
              id: firstFirstGroupedPickingDataGroupedList[0].id,
              itemId: firstFirstGroupedPickingDataGroupedList[0].itemId,
              picklistNum: firstFirstGroupedPickingDataGroupedList[0].picklistNum,
              status: firstFirstGroupedPickingDataGroupedList[0].status,
              itemCode: firstFirstGroupedPickingDataGroupedList[0].itemCode,
              itemName: firstFirstGroupedPickingDataGroupedList[0].itemName,
              quantity: ((List.generate(firstFirstGroupedPickingDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickingDataGroupedList[i].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
              pickedQty: ((List.generate(firstFirstGroupedPickingDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickingDataGroupedList[i].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
              uom: firstFirstGroupedPickingDataGroupedList[0].uom,
              itemType: firstFirstGroupedPickingDataGroupedList[0].itemType,
              typeColor: firstFirstGroupedPickingDataGroupedList[0].typeColor,
              floor: firstFirstGroupedPickingDataGroupedList[0].floor,
              room: firstFirstGroupedPickingDataGroupedList[0].room,
              zone: firstFirstGroupedPickingDataGroupedList[0].zone,
              stagingArea: firstFirstGroupedPickingDataGroupedList[0].stagingArea,
              isProgressStatus: firstFirstGroupedPickingDataGroupedList[0].isProgressStatus,
              packageTerms: firstFirstGroupedPickingDataGroupedList[0].packageTerms,
              catchWeightStatus: firstFirstGroupedPickingDataGroupedList[0].catchWeightStatus,
              catchWeightInfo: firstFirstGroupedPickingDataGroupedList[0].catchWeightInfo,
              catchWeightInfoForList: firstFirstGroupedPickingDataGroupedList[0].catchWeightInfoForList,
              catchWeightInfoPicked: firstFirstGroupedPickingDataGroupedList[0].catchWeightInfoPicked,
              handledBy: firstFirstGroupedPickingDataGroupedList[0].handledBy,
              locationDisputeInfo: firstFirstGroupedPickingDataGroupedList[0].locationDisputeInfo,
              unavailableReason: firstFirstGroupedPickingDataGroupedList[0].unavailableReason,
              alternativeItemName: firstFirstGroupedPickingDataGroupedList[0].alternativeItemName,
              alternativeItemCode: firstFirstGroupedPickingDataGroupedList[0].alternativeItemCode,
              batchesList: List.generate(firstFirstGroupedPickingDataGroupedList.length, (i)=>firstFirstGroupedPickingDataGroupedList[i].batchesList[0]),
              allowUndo: firstFirstGroupedPickingDataGroupedList[0].allowUndo,
              soNum: firstFirstGroupedPickingDataGroupedList[0].soNum);
          tempGroupedPickingData[i].add(selectedPickListItem);
        }
      }
      for(int i=0;i<tempGroupedPickedData.length;i++){
        pickListDetailsResponse.picked+=tempGroupedPickedData[i].length;
      }
      for(int i=0;i<tempGroupedPickingData.length;i++){
        pickListDetailsResponse.picked+=tempGroupedPickingData[i].length;
      }
    }
    pickListDetailsResponse.partial=0;
    if(true){
      List<PickListDetailsItem> tabPickListItems = (pickListDetailsResponse.items.where((e) => e.status == "Partial")).toList();
      List<PickListDetailsItem> pickedList = (tabPickListItems.where((element) => !element.isProgressStatus).toList());
      Map<String, List<PickListDetailsItem>> pickedGroup = groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
      List<List<PickListDetailsItem>> tempGroupedPickedData =[];
      for(int i=0;i<pickedGroup.values.toList().length;i++){
        tempGroupedPickedData.add([]);
        List<PickListDetailsItem> firstGroupedPickedData = pickedGroup.values.toList()[i];
        Map<String, List<PickListDetailsItem>> firstGroupedPickedDataGrouped = groupBy(firstGroupedPickedData, (PickListDetailsItem data) => data.itemId);
        List<List<PickListDetailsItem>> firstGroupedPickedDataGroupedList = firstGroupedPickedDataGrouped.values.toList();
        for(int j=0;j<firstGroupedPickedDataGroupedList.length;j++){
          List<PickListDetailsItem> firstFirstGroupedPickedDataGroupedList = firstGroupedPickedDataGroupedList[j];
          PickListDetailsItem selectedPickListItem = PickListDetailsItem(
              id: firstFirstGroupedPickedDataGroupedList[0].id,
              itemId: firstFirstGroupedPickedDataGroupedList[0].itemId,
              picklistNum: firstFirstGroupedPickedDataGroupedList[0].picklistNum,
              status: firstFirstGroupedPickedDataGroupedList[0].status,
              itemCode: firstFirstGroupedPickedDataGroupedList[0].itemCode,
              itemName: firstFirstGroupedPickedDataGroupedList[0].itemName,
              quantity: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
              pickedQty: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
              uom: firstFirstGroupedPickedDataGroupedList[0].uom,
              itemType: firstFirstGroupedPickedDataGroupedList[0].itemType,
              typeColor: firstFirstGroupedPickedDataGroupedList[0].typeColor,
              floor: firstFirstGroupedPickedDataGroupedList[0].floor,
              room: firstFirstGroupedPickedDataGroupedList[0].room,
              zone: firstFirstGroupedPickedDataGroupedList[0].zone,
              stagingArea: firstFirstGroupedPickedDataGroupedList[0].stagingArea,
              isProgressStatus: firstFirstGroupedPickedDataGroupedList[0].isProgressStatus,
              packageTerms: firstFirstGroupedPickedDataGroupedList[0].packageTerms,
              catchWeightStatus: firstFirstGroupedPickedDataGroupedList[0].catchWeightStatus,
              catchWeightInfo: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfo,
              catchWeightInfoForList: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoForList,
              catchWeightInfoPicked: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoPicked,
              handledBy: firstFirstGroupedPickedDataGroupedList[0].handledBy,
              locationDisputeInfo: firstFirstGroupedPickedDataGroupedList[0].locationDisputeInfo,
              unavailableReason: firstFirstGroupedPickedDataGroupedList[0].unavailableReason,
              alternativeItemName: firstFirstGroupedPickedDataGroupedList[0].alternativeItemName,
              alternativeItemCode: firstFirstGroupedPickedDataGroupedList[0].alternativeItemCode,
              batchesList: List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>firstFirstGroupedPickedDataGroupedList[i].batchesList[0]),
              allowUndo: firstFirstGroupedPickedDataGroupedList[0].allowUndo,
              soNum: firstFirstGroupedPickedDataGroupedList[0].soNum);
          tempGroupedPickedData[i].add(selectedPickListItem);
        }
      }
      List<PickListDetailsItem> pickingList = (tabPickListItems.where((element) => element.isProgressStatus).toList());
      Map<String, List<PickListDetailsItem>> groupedData = {};
      for (PickListDetailsItem item in pickingList) {
        List<HandledByPickList> handledBy = item.handledBy;
        for (HandledByPickList handler in handledBy) {
          String name = handler.name;
          if (!groupedData.containsKey(name)) {
            groupedData[name] = [];
          }
          groupedData[name]!.add(item);
        }
      }
      List<List<PickListDetailsItem>> tempGroupedPickingData =[];
      for(int i=0;i<groupedData.values.toList().length;i++){
        tempGroupedPickingData.add([]);
        List<PickListDetailsItem> firstGroupedPickingData = groupedData.values.toList()[i];
        Map<String, List<PickListDetailsItem>> firstGroupedPickingDataGrouped = groupBy(firstGroupedPickingData, (PickListDetailsItem data) => data.itemId);
        List<List<PickListDetailsItem>> firstGroupedPickingDataGroupedList = firstGroupedPickingDataGrouped.values.toList();
        for(int j=0;j<firstGroupedPickingDataGroupedList.length;j++){
          List<PickListDetailsItem> firstFirstGroupedPickingDataGroupedList = firstGroupedPickingDataGroupedList[j];
          PickListDetailsItem selectedPickListItem = PickListDetailsItem(
              id: firstFirstGroupedPickingDataGroupedList[0].id,
              itemId: firstFirstGroupedPickingDataGroupedList[0].itemId,
              picklistNum: firstFirstGroupedPickingDataGroupedList[0].picklistNum,
              status: firstFirstGroupedPickingDataGroupedList[0].status,
              itemCode: firstFirstGroupedPickingDataGroupedList[0].itemCode,
              itemName: firstFirstGroupedPickingDataGroupedList[0].itemName,
              quantity: ((List.generate(firstFirstGroupedPickingDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickingDataGroupedList[i].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
              pickedQty: ((List.generate(firstFirstGroupedPickingDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickingDataGroupedList[i].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
              uom: firstFirstGroupedPickingDataGroupedList[0].uom,
              itemType: firstFirstGroupedPickingDataGroupedList[0].itemType,
              typeColor: firstFirstGroupedPickingDataGroupedList[0].typeColor,
              floor: firstFirstGroupedPickingDataGroupedList[0].floor,
              room: firstFirstGroupedPickingDataGroupedList[0].room,
              zone: firstFirstGroupedPickingDataGroupedList[0].zone,
              stagingArea: firstFirstGroupedPickingDataGroupedList[0].stagingArea,
              isProgressStatus: firstFirstGroupedPickingDataGroupedList[0].isProgressStatus,
              packageTerms: firstFirstGroupedPickingDataGroupedList[0].packageTerms,
              catchWeightStatus: firstFirstGroupedPickingDataGroupedList[0].catchWeightStatus,
              catchWeightInfo: firstFirstGroupedPickingDataGroupedList[0].catchWeightInfo,
              catchWeightInfoForList: firstFirstGroupedPickingDataGroupedList[0].catchWeightInfoForList,
              catchWeightInfoPicked: firstFirstGroupedPickingDataGroupedList[0].catchWeightInfoPicked,
              handledBy: firstFirstGroupedPickingDataGroupedList[0].handledBy,
              locationDisputeInfo: firstFirstGroupedPickingDataGroupedList[0].locationDisputeInfo,
              unavailableReason: firstFirstGroupedPickingDataGroupedList[0].unavailableReason,
              alternativeItemName: firstFirstGroupedPickingDataGroupedList[0].alternativeItemName,
              alternativeItemCode: firstFirstGroupedPickingDataGroupedList[0].alternativeItemCode,
              batchesList: List.generate(firstFirstGroupedPickingDataGroupedList.length, (i)=>firstFirstGroupedPickingDataGroupedList[i].batchesList[0]),
              allowUndo: firstFirstGroupedPickingDataGroupedList[0].allowUndo,
              soNum: firstFirstGroupedPickingDataGroupedList[0].soNum);
          tempGroupedPickingData[i].add(selectedPickListItem);
        }
      }
      for(int i=0;i<tempGroupedPickedData.length;i++){
        pickListDetailsResponse.partial+=tempGroupedPickedData[i].length;
      }
      for(int i=0;i<tempGroupedPickingData.length;i++){
        pickListDetailsResponse.partial+=tempGroupedPickingData[i].length;
      }
    }
    pickListDetailsResponse.unavailable=0;
    if(true){
      Map<String, List<PickListDetailsItem>> grouped = groupBy((pickListDetailsResponse.items.where((e) => e.status == "Unavailable")).toList(),
              (PickListDetailsItem item) => item.floor);
      List<List<PickListDetailsItem>> groupedPickedDataUnavailable=[];
      for(int i=0;i<grouped.values.toList().length;i++){
        groupedPickedDataUnavailable.add([]);
        List<PickListDetailsItem> firstGroupedPickedData = grouped.values.toList()[i];
        Map<String, List<PickListDetailsItem>> firstGroupedPickedDataGrouped = groupBy(firstGroupedPickedData, (PickListDetailsItem data) => data.itemId);
        List<List<PickListDetailsItem>> firstGroupedPickedDataGroupedList = firstGroupedPickedDataGrouped.values.toList();
        for(int j=0;j<firstGroupedPickedDataGroupedList.length;j++){
          List<PickListDetailsItem> firstFirstGroupedPickedDataGroupedList = firstGroupedPickedDataGroupedList[j];
          PickListDetailsItem selectedPickListItem = PickListDetailsItem(
              id: firstFirstGroupedPickedDataGroupedList[0].id,
              itemId: firstFirstGroupedPickedDataGroupedList[0].itemId,
              picklistNum: firstFirstGroupedPickedDataGroupedList[0].picklistNum,
              status: firstFirstGroupedPickedDataGroupedList[0].status,
              itemCode: firstFirstGroupedPickedDataGroupedList[0].itemCode,
              itemName: firstFirstGroupedPickedDataGroupedList[0].itemName,
              quantity: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].batchesList[0].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
              pickedQty: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].batchesList[0].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
              uom: firstFirstGroupedPickedDataGroupedList[0].uom,
              itemType: firstFirstGroupedPickedDataGroupedList[0].itemType,
              typeColor: firstFirstGroupedPickedDataGroupedList[0].typeColor,
              floor: firstFirstGroupedPickedDataGroupedList[0].floor,
              room: firstFirstGroupedPickedDataGroupedList[0].room,
              zone: firstFirstGroupedPickedDataGroupedList[0].zone,
              stagingArea: firstFirstGroupedPickedDataGroupedList[0].stagingArea,
              isProgressStatus: firstFirstGroupedPickedDataGroupedList[0].isProgressStatus,
              packageTerms: firstFirstGroupedPickedDataGroupedList[0].packageTerms,
              catchWeightStatus: firstFirstGroupedPickedDataGroupedList[0].catchWeightStatus,
              catchWeightInfo: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfo,
              catchWeightInfoForList: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoForList,
              catchWeightInfoPicked: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoPicked,
              handledBy: firstFirstGroupedPickedDataGroupedList[0].handledBy,
              locationDisputeInfo: firstFirstGroupedPickedDataGroupedList[0].locationDisputeInfo,
              unavailableReason: firstFirstGroupedPickedDataGroupedList[0].unavailableReason,
              alternativeItemName: firstFirstGroupedPickedDataGroupedList[0].alternativeItemName,
              alternativeItemCode: firstFirstGroupedPickedDataGroupedList[0].alternativeItemCode,
              batchesList: List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>firstFirstGroupedPickedDataGroupedList[i].batchesList[0]),
              allowUndo: firstFirstGroupedPickedDataGroupedList[0].allowUndo,
              soNum: firstFirstGroupedPickedDataGroupedList[0].soNum);
          groupedPickedDataUnavailable[i].add(selectedPickListItem);
        }
      }
      for(int i=0;i<groupedPickedDataUnavailable.length;i++){
        pickListDetailsResponse.unavailable+=groupedPickedDataUnavailable[i].length;
      }
    }
  }*/

  pickedItemFunction() async {
    String userCode = getIt<Variables>().generalVariables.userDataEmployeeCode;
    List<FilterOptionsResponse> usersList = getIt<Variables>().generalVariables.userData.usersList;
    HandledByPickList userHandled = HandledByPickList.fromJson(usersList.singleWhere((user) => user.code == userCode).toJson());
    Box pickListMainDataListLocalBox = Hive.box('pick_list_main_data_list_local');
    List<Map<String, dynamic>> pickListMainData = [];
    List<String> pickListDetailsItemBatchesId=List.generate(pickListDetailsResponse.items.singleWhere((e)=>e.id==selectedPickListItemId).batchesList.length, (i)=>pickListDetailsResponse.items.singleWhere((e)=>e.id==selectedPickListItemId).batchesList[i].id);
    String? pickListMainDataListLocalGetString = pickListMainDataListLocalBox.get('myListKey');
    if (pickListMainDataListLocalGetString != null) {
      List<dynamic> decoded = jsonDecode(pickListMainDataListLocalGetString);
      pickListMainData = List<Map<String, dynamic>>.from(decoded);
    }
    num totalPickedQuantity=0;
    for(int i=0;i<pickedQuantityData.keys.toList().length;i++){
      totalPickedQuantity = totalPickedQuantity + num.parse(pickedQuantityData[pickedQuantityData.keys.toList()[i]]);
    }
    for(int i=0;i<pickedCatchWeightData.length;i++){
      totalPickedQuantity=totalPickedQuantity + num.parse(pickedCatchWeightData[i]);
    }
    List<Map<String, dynamic>> matchedPickListList = pickListMainData.where((e)=>e["picklist_id"]==selectedPickListId).toList();
    List<Map<String, dynamic>> matchedPickListItemsList = matchedPickListList.where((e)=>e["picklist_item_id"]==selectedPickListItemId).toList();
    List<Map<String, dynamic>> matchedPickListBatchesList = matchedPickListItemsList.where((item1) => pickListDetailsItemBatchesId.any((item2) => item1["batch_id"] == item2)).toList();
    for (var element in matchedPickListBatchesList) {
      if(element["catchweight_status"]=="No"){
        element["picked_qty"]=(num.parse(element["picked_qty"])+num.parse(pickedQuantityData[element["batch_id"]])).toString();
        userHandled.pickedItems=element["picked_qty"];
      }
      else{
        element["picked_qty"]=(num.parse(element["picked_qty"])+totalPickedQuantity).toString();
        userHandled.pickedItems=element["picked_qty"];
        element["picked_catchweight_info"]= pickedCatchWeightData.join(",");
      }
      List<bool> sessionStartedListBool= List<bool>.generate(matchedPickListList.length,(i)=>matchedPickListList[i]["is_session_opened"]);
      if(sessionStartedListBool.contains(true)){
        debugPrint("Session Already started");
      } else{
        if (element["session_timestamp"] == "") {
          element["session_timestamp"] = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
        }
      }
      element["do_complete_action"] = false;
      element["is_session_opened"] = true;
    }
    for(var itemElement in matchedPickListItemsList){
      itemElement["item_picked_qty"]=(num.parse(itemElement["item_picked_qty"])+totalPickedQuantity).toString();
      itemElement["picklist_item_status"] = (num.parse(itemElement["item_picked_qty"]) == num.parse(itemElement["item_quantity"])) ? "Picked" : "Partial";
      itemElement["progress_status"] = true;
      if (itemElement["handled_by"].isNotEmpty) {
        List<String> pickListHandledByCodeList = List.generate(itemElement["handled_by"].length, (i) => itemElement["handled_by"][i]["code"]);
        if (pickListHandledByCodeList.contains(userHandled.code)) {
          itemElement["handled_by"].firstWhere((handled) => handled["code"] == userHandled.code)["picked_items"] = (num.parse(
              itemElement["handled_by"]
                  .firstWhere((handled) => handled["code"] == userHandled.code)["picked_items"]) +
              totalPickedQuantity)
              .toString();

        } else {
          itemElement["handled_by"].add(userHandled.toJson());
        }
      }
      else {
        itemElement["handled_by"].add(userHandled.toJson());
      }
    }
    for(var itemElement in matchedPickListList){
      itemElement["total_picklist_picked_items"] =matchedPickListItemsList.where((e)=>e["picklist_item_status"]=="Picked").toList().length.toString();
      if(num.parse(itemElement["total_picklist_picked_items"]) == num.parse(itemElement["total_picklist_items"])) {
        itemElement["picklist_status"] = "Partial";
        itemElement["picklist_status_color"] = "72492B";
        itemElement["picklist_status_bg_color"] = "ffDDC5";
        itemElement["in_progress"] = true;
      }
      else if(num.parse(itemElement["total_picklist_picked_items"]) == 0) {
        itemElement["picklist_status"] = "Pending";
        itemElement["picklist_status_color"] = "DC474A";
        itemElement["picklist_status_bg_color"] = "ffCCCF";
        itemElement["in_progress"] = false;
      }
      else {
        itemElement["picklist_status"] = "Partial";
        itemElement["picklist_status_color"] = "72492B";
        itemElement["picklist_status_bg_color"] = "ffDDC5";
        itemElement["in_progress"] = true;
      }
    }
    for (int i = 0; i < pickListMainData.length; i++) {
      for (final updated in matchedPickListList) {
        if (pickListMainData[i]['picklist_id'] == updated['picklist_id'] &&
            pickListMainData[i]['picklist_item_id'] == updated['picklist_item_id'] &&
            pickListMainData[i]['batch_id'] == updated['batch_id']) {
          pickListMainData[i] = updated;
          break;
        }
      }
    }
    await pickListMainDataListLocalBox.put('myListKey', jsonEncode(pickListMainData));
    setFunction();
  }

  undoPickedItemFunction()async{
    String userCode = getIt<Variables>().generalVariables.userDataEmployeeCode;
    List<FilterOptionsResponse> usersList = getIt<Variables>().generalVariables.userData.usersList;
    HandledByPickList userHandled = HandledByPickList.fromJson(usersList.singleWhere((user) => user.code == userCode).toJson());
    Box pickListMainDataListLocalBox = Hive.box('pick_list_main_data_list_local');
    List<Map<String, dynamic>> pickListMainData = [];
    List<String> pickListDetailsItemBatchesId=List.generate(pickListDetailsResponse.items.singleWhere((e)=>e.id==selectedPickListItemId).batchesList.length, (i)=>pickListDetailsResponse.items.singleWhere((e)=>e.id==selectedPickListItemId).batchesList[i].id);
    String? pickListMainDataListLocalGetString = pickListMainDataListLocalBox.get('myListKey');
    if (pickListMainDataListLocalGetString != null) {
      List<dynamic> decoded = jsonDecode(pickListMainDataListLocalGetString);
      pickListMainData = List<Map<String, dynamic>>.from(decoded);
    }
    List<Map<String, dynamic>> matchedPickListList = pickListMainData.where((e)=>e["picklist_id"]==selectedPickListId).toList();
    List<Map<String, dynamic>> matchedPickListItemsList = matchedPickListList.where((e)=>e["picklist_item_id"]==selectedPickListItemId).toList();
    List<Map<String, dynamic>> matchedPickListBatchesList = matchedPickListItemsList.where((item1) => pickListDetailsItemBatchesId.any((item2) => item1["batch_id"] == item2)).toList();
    Box partialPickListMainDataListLocalBox = Hive.box('partial_pick_list_main_data_list_local');
    List<Map<String, dynamic>> partialPickListMainData = [];
    String? partialPickListMainDataListLocalGetString = partialPickListMainDataListLocalBox.get('myPartialListKey');
    if (partialPickListMainDataListLocalGetString != null) {
      List<dynamic> decoded = jsonDecode(partialPickListMainDataListLocalGetString);
      partialPickListMainData = List<Map<String, dynamic>>.from(decoded);
    }
    for(int i=0;i<partialPickListMainData.length;i++){
      log("partialPickListMainData[i].toString()");
      log(partialPickListMainData[i].toString());
    }
    List<String> partialItemsIdsList = List.generate(partialPickListMainData.length, (i) => partialPickListMainData[i]["picklist_item_id"]);
    if(partialItemsIdsList.contains(selectedPickListItemId)){
      Map<String,dynamic> selectedItemData =  partialPickListMainData.firstWhere((e)=>e["picklist_item_id"]==selectedPickListItemId);
      for (int i = 0; i < pickListMainData.length; i++) {
        if (pickListMainData[i]['picklist_item_id'] == selectedItemData['picklist_item_id']) {
          pickListMainData[i] = selectedItemData;
          break;
        }
      }
      await pickListMainDataListLocalBox.put('myListKey', jsonEncode(pickListMainData));
      setFunction();
    }
    else{
      num totalPickedQuantity=0;
      for (var element in matchedPickListBatchesList) {
        totalPickedQuantity=totalPickedQuantity + num.parse(element["picked_qty"]);
      }
      for (var element in matchedPickListBatchesList) {
        if(element["catchweight_status"]=="No"){
          element["picked_qty"]="0";
          userHandled.pickedItems=element["picked_qty"];
        }
        else{
          element["picked_qty"]="0";
          userHandled.pickedItems=element["picked_qty"];
          element["picked_catchweight_info"]= pickedCatchWeightData.join(",");
        }
        List<bool> sessionStartedListBool= List<bool>.generate(matchedPickListList.length,(i)=>matchedPickListList[i]["is_session_opened"]);
        if(sessionStartedListBool.contains(true)){
          debugPrint("Session Already started");
        }
        else{if (element["session_timestamp"] == "") {
          element["session_timestamp"] = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
        }}
        element["do_complete_action"] = false;
        element["is_session_opened"] = true;
      }
      for(var itemElement in matchedPickListItemsList){
        itemElement["item_picked_qty"]=(num.parse(itemElement["item_picked_qty"])-totalPickedQuantity).toString();
        if (num.parse(itemElement["item_picked_qty"]) == 0) {
          itemElement["picklist_item_status"] = "Pending";
        } else if (num.parse(itemElement["item_picked_qty"]) == num.parse(itemElement["item_quantity"])) {
          itemElement["picklist_item_status"] = "Completed";
        } else {
          itemElement["picklist_item_status"] = "Partial";
        }
        itemElement["progress_status"] = false;
        if (itemElement["handled_by"].isNotEmpty) {
          List<String> pickListHandledByCodeList = List.generate(itemElement["handled_by"].length, (i) => itemElement["handled_by"][i]["code"]);
          if (pickListHandledByCodeList.contains(userHandled.code)) {
            itemElement["handled_by"].firstWhere((handled) => handled["code"] == userHandled.code)["picked_items"] = (num.parse(
                itemElement["handled_by"]
                    .firstWhere((handled) => handled["code"] == userHandled.code)["picked_items"]) -
                totalPickedQuantity)
                .toString();
            Map<String,dynamic> selectedUserHandledMap = itemElement["handled_by"].firstWhere((handled) => handled["code"] == userHandled.code);
            if(selectedUserHandledMap["picked_items"]=="0"){
              itemElement["handled_by"].removeWhere((handled) => handled["code"] == userHandled.code);
            }
          } else {
            itemElement["handled_by"].removeWhere((e)=>e.code==userHandled.code);
          }
        } else {
          itemElement["handled_by"].removeWhere((e)=>e.code==userHandled.code);
        }
      }
      for(var itemElement in matchedPickListList){
        itemElement["total_picklist_picked_items"] = matchedPickListItemsList.where((e)=>e["picklist_item_status"]=="Picked").toList().length.toString();
        if(num.parse(itemElement["total_picklist_picked_items"]) == num.parse(itemElement["total_picklist_items"])) {
          itemElement["picklist_status"] = "Partial";
          itemElement["picklist_status_color"] = "72492B";
          itemElement["picklist_status_bg_color"] = "ffDDC5";
          itemElement["in_progress"] = true;
        }
        else if(num.parse(itemElement["total_picklist_picked_items"]) == 0) {
          itemElement["picklist_status"] = "Pending";
          itemElement["picklist_status_color"] = "DC474A";
          itemElement["picklist_status_bg_color"] = "ffCCCF";
          itemElement["in_progress"] = false;
        }
        else {
          itemElement["picklist_status"] = "Partial";
          itemElement["picklist_status_color"] = "72492B";
          itemElement["picklist_status_bg_color"] = "ffDDC5";
          itemElement["in_progress"] = true;
        }
      }
      for (int i = 0; i < pickListMainData.length; i++) {
        for (final updated in matchedPickListList) {
          if (pickListMainData[i]['picklist_id'] == updated['picklist_id'] &&
              pickListMainData[i]['picklist_item_id'] == updated['picklist_item_id'] &&
              pickListMainData[i]['batch_id'] == updated['batch_id']) {
            pickListMainData[i] = updated;
            break;
          }
        }
      }
      await pickListMainDataListLocalBox.put('myListKey', jsonEncode(pickListMainData));
      setFunction();
    }
  }

  unavailableItemFunction()async{
    String userCode = getIt<Variables>().generalVariables.userDataEmployeeCode;
    List<FilterOptionsResponse> usersList = getIt<Variables>().generalVariables.userData.usersList;
    HandledByPickList userHandled = HandledByPickList.fromJson(usersList.singleWhere((user) => user.code == userCode).toJson());
    Box pickListMainDataListLocalBox = Hive.box('pick_list_main_data_list_local');
    List<Map<String, dynamic>> pickListMainData = [];
    List<String> pickListDetailsItemBatchesId=List.generate(pickListDetailsResponse.items.singleWhere((e)=>e.id==selectedPickListItemId).batchesList.length, (i)=>pickListDetailsResponse.items.singleWhere((e)=>e.id==selectedPickListItemId).batchesList[i].id);
    String? pickListMainDataListLocalGetString = pickListMainDataListLocalBox.get('myListKey');
    if (pickListMainDataListLocalGetString != null) {
      List<dynamic> decoded = jsonDecode(pickListMainDataListLocalGetString);
      pickListMainData = List<Map<String, dynamic>>.from(decoded);
    }
    List<Map<String, dynamic>> matchedPickListList = pickListMainData.where((e)=>e["picklist_id"]==selectedPickListId).toList();
    List<Map<String, dynamic>> matchedPickListItemsList = matchedPickListList.where((e)=>e["picklist_item_id"]==selectedPickListItemId).toList();
    List<Map<String, dynamic>> matchedPickListBatchesList = matchedPickListItemsList.where((item1) => pickListDetailsItemBatchesId.any((item2) => item1["batch_id"] == item2)).toList();
    for (var element in matchedPickListBatchesList) {
      element["unavail_reason"] = selectedReasonName ?? "";
      element["alternative_item_name"] = selectedAltItemName ?? '';
      element["alternative_item_code"] = selectedAltItemCode ?? '';
      element["remarks"] = commentText;
      List<bool> sessionStartedListBool= List<bool>.generate(matchedPickListList.length,(i)=>matchedPickListList[i]["is_session_opened"]);
      if(sessionStartedListBool.contains(true)){
        debugPrint("Session Already started");
      }
      else{
      if (element["session_timestamp"] == "") {
        element["session_timestamp"] = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      }
      }
      element["do_complete_action"] = false;
      element["is_session_opened"] = true;
    }
    for(var itemElement in matchedPickListItemsList){
      itemElement["picklist_item_status"] = "Unavailable";
      itemElement["progress_status"] = false;
      if (itemElement["handled_by"].isNotEmpty) {
        List<String> pickListHandledByCodeList = List.generate(itemElement["handled_by"].length, (i) => itemElement["handled_by"][i]["code"]);
        if (pickListHandledByCodeList.contains(userHandled.code)) {
          itemElement["handled_by"].firstWhere((handled) => handled["code"] == userHandled.code)["picked_items"] = (num.parse(itemElement["handled_by"].firstWhere((handled) => handled["code"] == userHandled.code)["picked_items"])).toString();
        } else {
          itemElement["handled_by"].add(userHandled);
        }
      } else {
        itemElement["handled_by"].add(userHandled);
      }
    }
    for(var itemElement in matchedPickListList){
      itemElement["total_picklist_picked_items"] = matchedPickListItemsList.where((e)=>e["picklist_item_status"]=="Picked").toList().length.toString();
      if(num.parse(itemElement["total_picklist_picked_items"]) == num.parse(itemElement["total_picklist_items"])) {
        itemElement["picklist_status"] = "Partial";
        itemElement["picklist_status_color"] = "72492B";
        itemElement["picklist_status_bg_color"] = "ffDDC5";
        itemElement["in_progress"] = true;
      }
      else if(num.parse(itemElement["total_picklist_picked_items"]) == 0) {
        itemElement["picklist_status"] = "Pending";
        itemElement["picklist_status_color"] = "DC474A";
        itemElement["picklist_status_bg_color"] = "ffCCCF";
        itemElement["in_progress"] = false;
      }
      else {
        itemElement["picklist_status"] = "Partial";
        itemElement["picklist_status_color"] = "72492B";
        itemElement["picklist_status_bg_color"] = "ffDDC5";
        itemElement["in_progress"] = true;
      }
    }
    for (int i = 0; i < pickListMainData.length; i++) {
      for (final updated in matchedPickListList) {
        if (pickListMainData[i]['picklist_id'] == updated['picklist_id'] &&
            pickListMainData[i]['picklist_item_id'] == updated['picklist_item_id'] &&
            pickListMainData[i]['batch_id'] == updated['batch_id']) {
          pickListMainData[i] = updated;
          break;
        }
      }
    }
    await pickListMainDataListLocalBox.put('myListKey', jsonEncode(pickListMainData));
    setFunction();
  }

  pickListLocationUpdateFunction({required Map<String, dynamic> queryData})async{
    Box pickListMainDataListLocalBox = Hive.box('pick_list_main_data_list_local');
    List<Map<String, dynamic>> pickListMainData = [];
    List<String> pickListDetailsItemBatchesId=List.generate(pickListDetailsResponse.items.singleWhere((e)=>e.id==selectedPickListItemId).batchesList.length, (i)=>pickListDetailsResponse.items.singleWhere((e)=>e.id==selectedPickListItemId).batchesList[i].id);
    String? pickListMainDataListLocalGetString = pickListMainDataListLocalBox.get('myListKey');
    if (pickListMainDataListLocalGetString != null) {
      List<dynamic> decoded = jsonDecode(pickListMainDataListLocalGetString);
      pickListMainData = List<Map<String, dynamic>>.from(decoded);
    }
    List<Map<String, dynamic>> matchedPickListList = pickListMainData.where((e)=>e["picklist_id"]==selectedPickListId).toList();
    List<Map<String, dynamic>> matchedPickListItemsList = matchedPickListList.where((e)=>e["picklist_item_id"]==selectedPickListItemId).toList();
    List<Map<String, dynamic>> matchedPickListBatchesList = matchedPickListItemsList.where((item1) => pickListDetailsItemBatchesId.any((item2) => item1["batch_id"] == item2)).toList();
    for (var element in matchedPickListBatchesList) {
      element["location_dispute_info"] = {
        "updated_on": DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now()),
        "floor": queryData["query_data"]["floor"],
        "room": queryData["query_data"]["room"],
        "zone": queryData["query_data"]["zone"],
      };
      List<bool> sessionStartedListBool= List<bool>.generate(matchedPickListList.length,(i)=>matchedPickListList[i]["is_session_opened"]);
      if(sessionStartedListBool.contains(true)){
        debugPrint("Session Already started");
      }
      else{
      element["do_complete_action"] = false;
      element["is_session_opened"] = true;
      if (element["session_timestamp"] == "") {
        element["session_timestamp"] = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      }
      }
    }
    for (int i = 0; i < pickListMainData.length; i++) {
      for (final updated in matchedPickListList) {
        if (pickListMainData[i]['picklist_id'] == updated['picklist_id'] &&
            pickListMainData[i]['picklist_item_id'] == updated['picklist_item_id'] &&
            pickListMainData[i]['batch_id'] == updated['batch_id']) {
          pickListMainData[i] = updated;
          break;
        }
      }
    }
    await pickListMainDataListLocalBox.put('myListKey', jsonEncode(pickListMainData));
    setFunction();
  }

  sessionCloseFunction({required String sessionTime})async{
    Box pickListMainDataListLocalBox = Hive.box('pick_list_main_data_list_local');
    Box partialPickListMainDataListLocalBox = Hive.box('partial_pick_list_main_data_list_local');
    List<Map<String, dynamic>> pickListMainData = [];
    String? pickListMainDataListLocalGetString = pickListMainDataListLocalBox.get('myListKey');
    if (pickListMainDataListLocalGetString != null) {
      List<dynamic> decoded = jsonDecode(pickListMainDataListLocalGetString);
      pickListMainData = List<Map<String, dynamic>>.from(decoded);
    }
    List<Map<String, dynamic>> matchedPickListList = pickListMainData.where((e)=>e["picklist_id"]==selectedPickListId).toList();
    for(var itemElement in matchedPickListList){
      if (itemElement["picklist_item_status"] != "Pending" &&
          itemElement["progress_status"] &&
          (itemElement["handled_by"].isNotEmpty ? (itemElement["handled_by"][0]["code"] == getIt<Variables>().generalVariables.userDataEmployeeCode) : false)) {
        itemElement["progress_status"] = false;
      }
      List<List<Map<String, dynamic>>> allLists = [
        List<Map<String,dynamic>>.from(sessionInfo.pendingList.map((x) => x.toJson())),
        List<Map<String,dynamic>>.from(sessionInfo.pickedList.map((x) => x.toJson())),
        List<Map<String,dynamic>>.from(sessionInfo.partialList.map((x) => x.toJson())),
        List<Map<String,dynamic>>.from(sessionInfo.unavailableList.map((x) => x.toJson())),];
        for (var list in allLists) {
          Map<String, dynamic> match = list.firstWhere(
                (item) =>
            item['id'] == itemElement['picklist_item_id'],
            orElse: () => {},
          );

          if (match.isNotEmpty) {
            match["staging_area"] = stagingAreaList.singleWhere((element) => element.id == selectedStagingAreaId).label;
            break;
          }
        }
      itemElement["do_complete_action"] =
          matchedPickListList.where((x) => x["picklist_item_status"] == "Pending").toList().isEmpty &&
              matchedPickListList.where((x) => x["picklist_item_status"] == "Partial").toList().isNotEmpty;
      itemElement["is_session_opened"]=false;
      itemElement["session_id"]="";
      itemElement["session_timestamp"]="";
      itemElement["completed"]=DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.now());
      itemElement["total_picklist_picked_items"] = matchedPickListList.where((e)=>e["picklist_item_status"]=="Picked").toList().length.toString();
      if(num.parse(itemElement["total_picklist_picked_items"]) == num.parse(itemElement["total_picklist_items"])) {
        itemElement["picklist_status"] = "Completed";
        itemElement["picklist_status_color"] = "007838";
        itemElement["picklist_status_bg_color"] = "C9F2DC";
        itemElement["in_progress"] = false;
      }
      else if(num.parse(itemElement["total_picklist_picked_items"]) == 0) {
        itemElement["picklist_status"] = "Pending";
        itemElement["picklist_status_color"] = "DC474A";
        itemElement["picklist_status_bg_color"] = "FFCCCF";
        itemElement["in_progress"] = false;
      }
      else {
        itemElement["picklist_status"] = "Partial";
        itemElement["picklist_status_color"] = "72492B";
        itemElement["picklist_status_bg_color"] = "FFDDC5";
        itemElement["in_progress"] = true;
      }
    }
    sessionInfo.isOpened = false;
    sessionInfo.id = "";
    sessionInfo.pending = "0";
    sessionInfo.picked = "0";
    sessionInfo.partial = "0";
    sessionInfo.unavailable = "0";
    sessionInfo.sessionStartTimestamp = "";
    sessionInfo.partialIdsList = [];
    sessionInfo.pendingList = [];
    sessionInfo.pickedList = [];
    sessionInfo.partialList = [];
    sessionInfo.unavailableList = [];
    sessionInfo.partialIdsList = List.generate(
        (matchedPickListList.where((e) => e["picklist_item_status"] == "Partial").toList()).length,
            (l) => matchedPickListList.where((e) => e["picklist_item_status"] == "Partial").toList()[l]["picklist_item_id"]);
    for (int i = 0; i < pickListMainData.length; i++) {
      for (final updated in matchedPickListList) {
        if (pickListMainData[i]['picklist_id'] == updated['picklist_id'] &&
            pickListMainData[i]['picklist_item_id'] == updated['picklist_item_id'] &&
            pickListMainData[i]['batch_id'] == updated['batch_id']) {
          pickListMainData[i] = updated;
          break;
        }
      }
    }
    await pickListMainDataListLocalBox.put('myListKey', jsonEncode(pickListMainData));
    List<Map<String, dynamic>> partialPickListMainDataListLocal = matchedPickListList.where((e) => e["picklist_item_status"] == "Partial").toList();
    String partialPickListMainDataListLocalString = jsonEncode(partialPickListMainDataListLocal);
    await partialPickListMainDataListLocalBox.put('myPartialListKey', partialPickListMainDataListLocalString);
    setFunction();
  }

  setFunction({bool? isComplete}) {
    Box pickListMainDataListLocalBox = Hive.box('pick_list_main_data_list_local');
    String? pickListMainDataListLocalGetString = pickListMainDataListLocalBox.get('myListKey');
    if (pickListMainDataListLocalGetString != null) {
      List<dynamic> decoded = jsonDecode(pickListMainDataListLocalGetString);
      pickListMainDataList = List<Map<String, dynamic>>.from(decoded);
    }
    List<Map<String,dynamic>> pickListItemDetails=pickListMainDataList.where((e)=>e["picklist_id"]==selectedPickListId).toList();
    Map<String, List<Map<String, dynamic>>> pickListItemData = groupBy(pickListItemDetails, (Map<String, dynamic> data) => data["picklist_item_id"]);
    List<List<Map<String, dynamic>>> pickListItemDataValues = pickListItemData.values.toList();
    List<Map<String, dynamic>> pickListItemDataMain = List.generate(pickListItemDataValues.length, (j) => pickListItemDataValues[j][0]);
    List<PickListDetailsItem> itemsPickListDetailsData = List<PickListDetailsItem>.from(pickListItemDataMain.map((x) => PickListDetailsItem.fromJson(x)));
    sessionInfo = PickListSessionInfo.fromJson({});
    List<Map<String, dynamic>> batchesSessionData = [];
    for (int i = 0; i < pickListItemDetails.length; i++) {
      if (pickListItemDetails[i]["is_session_opened"]) {
        batchesSessionData.add(pickListItemDetails[i]);
      }
    }
    String pendingData = batchesSessionData.where((e) => e["picklist_item_status"] == "Pending").toList().length.toString();
    String pickedData = batchesSessionData.where((e) => e["picklist_item_status"] == "Picked").toList().length.toString();
    String partialData = batchesSessionData.where((e) => e["picklist_item_status"] == "Partial").toList().length.toString();
    String unavailableData = batchesSessionData.where((e) => e["picklist_item_status"] == "Unavailable").toList().length.toString();
    for (int i = 0; i < pickListItemDetails.length; i++) {
      if (pickListItemDetails[i]["is_session_opened"]) {
        sessionInfo = PickListSessionInfo(
            isOpened: pickListItemDetails[i]["is_session_opened"],
            id: pickListItemDetails[i]["session_id"],
            pending: "0",
            picked: "0",
            partial: "0",
            unavailable: "0",
            sessionStartTimestamp: pickListItemDetails[i]["session_timestamp"],
            timeSpendSeconds: "",
            partialIdsList: [],
            pendingList: [],
            pickedList: [],
            partialList: [],
            unavailableList: []);
        break;
      }
    }
    sessionInfo.pending = pendingData;
    sessionInfo.picked = pickedData;
    sessionInfo.partial = partialData;
    sessionInfo.unavailable = unavailableData;
    List<Map<String, dynamic>> partialWorkedData = pickListItemDetails.where((x) => x["picklist_item_status"] == "Partial").toList();
    sessionInfo.partialIdsList = List.generate(partialWorkedData.length, (l) => partialWorkedData[l]["picklist_item_id"]);
    sessionInfo.pendingList = List<PickListDetailsItem>.from(batchesSessionData
        .where((e) => e["picklist_item_status"] == "Pending")
        .toList()
        .map((x) => PickListDetailsItem.fromJson(x)));
    sessionInfo.pickedList = List<PickListDetailsItem>.from(
        batchesSessionData.where((e) => e["picklist_item_status"] == "Picked").toList().map((x) => PickListDetailsItem.fromJson(x)));
    sessionInfo.partialList = List<PickListDetailsItem>.from(batchesSessionData
        .where((e) => e["picklist_item_status"] == "Partial")
        .toList()
        .map((x) => PickListDetailsItem.fromJson(x)));
    sessionInfo.unavailableList = List<PickListDetailsItem>.from(batchesSessionData
        .where((e) => e["picklist_item_status"] == "Unavailable")
        .toList()
        .map((x) => PickListDetailsItem.fromJson(x)));
    for (int k = 0; k < pickListItemDataValues.length; k++) {
      List<PickListBatchesList> batches = [];
      for (int l = 0; l < pickListItemDataValues[k].length; l++) {
        batches.add(PickListBatchesList.fromJson(pickListItemDataValues[k][l]));
      }
      itemsPickListDetailsData[k].batchesList = batches;
    }
    ///pick list handled by
    List<HandledByPickList> handledByPickListData = [];
    for(int i=0; i<pickListItemDetails.length;i++){
      if(pickListItemDetails[i]["handled_by"].isNotEmpty){
        handledByPickListData.add(HandledByPickList.fromJson(pickListItemDetails[i]["handled_by"][0]));
      }
    }
    List<HandledByPickList> handledByData = mergeHandledByPickList(handledByPickListData: handledByPickListData);
    ///item handled by
    for(int i=0;i<pickListItemDataValues.length;i++){
      List<HandledByPickList> handledByPickListDataLoop = [];
      for(int j=0; j<pickListItemDataValues[i].length;j++){
        if(pickListItemDataValues[i][j]["handled_by"].isNotEmpty){
          handledByPickListDataLoop.add(HandledByPickList.fromJson(pickListItemDataValues[i][j]["handled_by"][0]));
        }
      }
      List<HandledByPickList> handledByDataLoop = mergeHandledByPickList(handledByPickListData: handledByPickListData);
      itemsPickListDetailsData[i].handledBy=handledByDataLoop;
    }
    pickListDetailsResponse = PickListDetailsResponse(
        picklistId: selectedPickListId,
        picklistNum: pickListItemDetails[0]["picklist_num"] ?? "",
        route: pickListItemDetails[0]["route"] ?? "",
        picklistStatus: pickListItemDataMain.where((x) => x["picklist_item_status"] == "Picked").toList().isEmpty?"Pending":num.parse(pickListItemDetails[0]["total_picklist_items"]) == pickListItemDataMain.where((x) => x["picklist_item_status"] == "Picked").toList().length?"Completed":"Partial",
        picklistTime: pickListItemDetails[0]["picklist_created"] ?? "",
        totalItems: pickListItemDetails[0]["total_picklist_items"] ?? "",
        //need to update
        pickedItems: pickListItemDataMain.where((x) => x["picklist_item_status"] == "Picked").toList().length.toString(),
        isReadyToMoveComplete: pickListItemDataMain.where((x) => x["picklist_item_status"] == "Pending").toList().isEmpty && sessionInfo.isOpened == false && pickListItemDataMain.where((x) => x["picklist_item_status"] == "Partial").toList().isNotEmpty,
        //need to update
        isCompleted: pickListItemDetails[0]["picklist_status"] == getIt<Variables>().generalVariables.currentLanguage.completed,
        handledBy: handledByData,
        yetToPick: pickListItemDataMain.where((x) => x["picklist_item_status"] == "Pending").toList().length,
        picked: pickListItemDataMain.where((x) => x["picklist_item_status"] == "Picked").toList().length,
        partial: pickListItemDataMain.where((x) => x["picklist_item_status"] == "Partial").toList().length,
        unavailable: pickListItemDataMain.where((x) => x["picklist_item_status"] == "Unavailable").toList().length,
        items: itemsPickListDetailsData,
        unavailableReasons: unavailableReasonData!.values.toList(),
        completeReasons: completeReasonData!.values.toList(),
        alternateItems: getIt<Variables>().generalVariables.userData.filterItemsListOptions,
        locationFilter: Filter.fromJson({}),
        sessionInfo: sessionInfo,
        timelineInfo: List<TimelineInfo>.from([].map((x) => TimelineInfo.fromJson(x))));
    if(isComplete??false){
      pickListDetailsResponse.isReadyToMoveComplete=false;
    }
    getIt<Variables>().generalVariables.picklistSocketTempStatus = tabName;
    List<PickListDetailsItem> tabPickListItems = [];
    tabPickListItems.clear();
    tabPickListItems = (pickListDetailsResponse.items.where((e) => e.status == tabName)).toList();
    if (searchText.isNotEmpty) {
      tabPickListItems = tabPickListItems
          .where((x) =>
      x.itemCode.toLowerCase().contains(searchText.toLowerCase()) ||
          x.itemType.toLowerCase().contains(searchText.toLowerCase()) ||
          x.itemName.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
    List<PickListDetailsItem> filteredList = [];
    filteredList.addAll(tabPickListItems);
    for (int i = 0; i < getIt<Variables>().generalVariables.selectedFilters.length; i++) {
      switch (getIt<Variables>().generalVariables.selectedFilters[i].type) {
        case "item_type":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.itemType == item2))
                .toList();
          }
        case "so_num":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.soNum == item2))
                .toList();
          }
        case "floor":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.floor == item2))
                .toList();
          }
        case "item_code":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.itemCode == item2))
                .toList();
          }
        case "sort_by_location":
          {
            for (int j = 0; j < getIt<Variables>().generalVariables.selectedFilters[i].options.length; j++) {
              switch (getIt<Variables>().generalVariables.selectedFilters[i].options[j]) {
                case "1":
                  {
                    filteredList.sort((a, b) => a.floor.toLowerCase().compareTo(b.floor.toLowerCase()));
                  }
                case "-1":
                  {
                    filteredList.sort((a, b) => b.floor.toLowerCase().compareTo(a.floor.toLowerCase()));
                  }
                default:
                  {
                    filteredList.sort((a, b) => a.floor.toLowerCase().compareTo(b.floor.toLowerCase()));
                  }
              }
            }
          }
        default:
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.itemType == item2))
                .toList();
          }
      }
    }
    tabPickListItems.clear();
    tabPickListItems.addAll(filteredList);
    switch (tabName) {
      case "Pending":
        {
          ///for picked list grouped by floor,room & zone
          Map<String, List<PickListDetailsItem>> grouped = groupBy(tabPickListItems, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
          // groupedPickedData = grouped.values.toList();
          groupedPickedData.clear();
          for(int i=0;i<grouped.values.toList().length;i++){
            groupedPickedData.add([]);
            List<PickListDetailsItem> firstGroupedPickedData = grouped.values.toList()[i];
            Map<String, List<PickListDetailsItem>> firstGroupedPickedDataGrouped = groupBy(firstGroupedPickedData, (PickListDetailsItem data) => data.itemId);
            List<List<PickListDetailsItem>> firstGroupedPickedDataGroupedList = firstGroupedPickedDataGrouped.values.toList();
            for(int j=0;j<firstGroupedPickedDataGroupedList.length;j++){
              List<PickListDetailsItem> firstFirstGroupedPickedDataGroupedList = firstGroupedPickedDataGroupedList[j];
              PickListDetailsItem selectedPickListItem = PickListDetailsItem(
                  id: firstFirstGroupedPickedDataGroupedList[0].id,
                  itemId: firstFirstGroupedPickedDataGroupedList[0].itemId,
                  picklistNum: firstFirstGroupedPickedDataGroupedList[0].picklistNum,
                  status: firstFirstGroupedPickedDataGroupedList[0].status,
                  itemCode: firstFirstGroupedPickedDataGroupedList[0].itemCode,
                  itemName: firstFirstGroupedPickedDataGroupedList[0].itemName,
                  quantity: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  pickedQty: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  uom: firstFirstGroupedPickedDataGroupedList[0].uom,
                  itemType: firstFirstGroupedPickedDataGroupedList[0].itemType,
                  typeColor: firstFirstGroupedPickedDataGroupedList[0].typeColor,
                  floor: firstFirstGroupedPickedDataGroupedList[0].floor,
                  room: firstFirstGroupedPickedDataGroupedList[0].room,
                  zone: firstFirstGroupedPickedDataGroupedList[0].zone,
                  stagingArea: firstFirstGroupedPickedDataGroupedList[0].stagingArea,
                  isProgressStatus: firstFirstGroupedPickedDataGroupedList[0].isProgressStatus,
                  packageTerms: firstFirstGroupedPickedDataGroupedList[0].packageTerms,
                  catchWeightStatus: firstFirstGroupedPickedDataGroupedList[0].catchWeightStatus,
                  catchWeightInfo: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfo,
                  catchWeightInfoForList: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoForList,
                  catchWeightInfoPicked: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoPicked,
                  handledBy: firstFirstGroupedPickedDataGroupedList[0].handledBy,
                  locationDisputeInfo: firstFirstGroupedPickedDataGroupedList[0].locationDisputeInfo,
                  unavailableReason: firstFirstGroupedPickedDataGroupedList[0].unavailableReason,
                  alternativeItemName: firstFirstGroupedPickedDataGroupedList[0].alternativeItemName,
                  alternativeItemCode: firstFirstGroupedPickedDataGroupedList[0].alternativeItemCode,
                  batchesList: List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>firstFirstGroupedPickedDataGroupedList[i].batchesList[0]),
                  allowUndo: firstFirstGroupedPickedDataGroupedList[0].allowUndo,
                  soNum: firstFirstGroupedPickedDataGroupedList[0].soNum);
              groupedPickedData[i].add(selectedPickListItem);
            }
          }
          //getTabsCountData();
        }
      case "Picked":
        {
          ///for picked list grouped by floor & staging area
          List<PickListDetailsItem> pickedList = (tabPickListItems.where((element) => !element.isProgressStatus).toList());
          Map<String, List<PickListDetailsItem>> pickedGroup = groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
          //groupedPickedData = pickedGroup.values.toList();
          groupedPickedData.clear();
          for(int i=0;i<pickedGroup.values.toList().length;i++){
            groupedPickedData.add([]);
            List<PickListDetailsItem> firstGroupedPickedData = pickedGroup.values.toList()[i];
            Map<String, List<PickListDetailsItem>> firstGroupedPickedDataGrouped = groupBy(firstGroupedPickedData, (PickListDetailsItem data) => data.itemId);
            List<List<PickListDetailsItem>> firstGroupedPickedDataGroupedList = firstGroupedPickedDataGrouped.values.toList();
            for(int j=0;j<firstGroupedPickedDataGroupedList.length;j++){
              List<PickListDetailsItem> firstFirstGroupedPickedDataGroupedList = firstGroupedPickedDataGroupedList[j];
              PickListDetailsItem selectedPickListItem = PickListDetailsItem(
                  id: firstFirstGroupedPickedDataGroupedList[0].id,
                  itemId: firstFirstGroupedPickedDataGroupedList[0].itemId,
                  picklistNum: firstFirstGroupedPickedDataGroupedList[0].picklistNum,
                  status: firstFirstGroupedPickedDataGroupedList[0].status,
                  itemCode: firstFirstGroupedPickedDataGroupedList[0].itemCode,
                  itemName: firstFirstGroupedPickedDataGroupedList[0].itemName,
                  quantity: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  pickedQty: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  uom: firstFirstGroupedPickedDataGroupedList[0].uom,
                  itemType: firstFirstGroupedPickedDataGroupedList[0].itemType,
                  typeColor: firstFirstGroupedPickedDataGroupedList[0].typeColor,
                  floor: firstFirstGroupedPickedDataGroupedList[0].floor,
                  room: firstFirstGroupedPickedDataGroupedList[0].room,
                  zone: firstFirstGroupedPickedDataGroupedList[0].zone,
                  stagingArea: firstFirstGroupedPickedDataGroupedList[0].stagingArea,
                  isProgressStatus: firstFirstGroupedPickedDataGroupedList[0].isProgressStatus,
                  packageTerms: firstFirstGroupedPickedDataGroupedList[0].packageTerms,
                  catchWeightStatus: firstFirstGroupedPickedDataGroupedList[0].catchWeightStatus,
                  catchWeightInfo: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfo,
                  catchWeightInfoForList: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoForList,
                  catchWeightInfoPicked: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoPicked,
                  handledBy: firstFirstGroupedPickedDataGroupedList[0].handledBy,
                  locationDisputeInfo: firstFirstGroupedPickedDataGroupedList[0].locationDisputeInfo,
                  unavailableReason: firstFirstGroupedPickedDataGroupedList[0].unavailableReason,
                  alternativeItemName: firstFirstGroupedPickedDataGroupedList[0].alternativeItemName,
                  alternativeItemCode: firstFirstGroupedPickedDataGroupedList[0].alternativeItemCode,
                  batchesList: List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>firstFirstGroupedPickedDataGroupedList[i].batchesList[0]),
                  allowUndo: firstFirstGroupedPickedDataGroupedList[0].allowUndo,
                  soNum: firstFirstGroupedPickedDataGroupedList[0].soNum);
              groupedPickedData[i].add(selectedPickListItem);
            }
          }

          ///for picking in progress list grouped by storekeeper
          List<PickListDetailsItem> pickingList = (tabPickListItems.where((element) => element.isProgressStatus).toList());
          Map<String, List<PickListDetailsItem>> groupedData = {};
          for (PickListDetailsItem item in pickingList) {
            List<HandledByPickList> handledBy = item.handledBy;
            for (HandledByPickList handler in handledBy) {
              String name = handler.name;
              if (!groupedData.containsKey(name)) {
                groupedData[name] = [];
              }
              groupedData[name]!.add(item);
            }
          }
          groupedKeepersNameList = groupedData.keys.toList();
          //groupedPickingData = groupedData.values.toList();
          groupedPickingData.clear();
          for(int i=0;i<groupedData.values.toList().length;i++){
            groupedPickingData.add([]);
            List<PickListDetailsItem> firstGroupedPickingData = groupedData.values.toList()[i];
            Map<String, List<PickListDetailsItem>> firstGroupedPickingDataGrouped = groupBy(firstGroupedPickingData, (PickListDetailsItem data) => data.itemId);
            List<List<PickListDetailsItem>> firstGroupedPickingDataGroupedList = firstGroupedPickingDataGrouped.values.toList();
            for(int j=0;j<firstGroupedPickingDataGroupedList.length;j++){
              List<PickListDetailsItem> firstFirstGroupedPickingDataGroupedList = firstGroupedPickingDataGroupedList[j];
              PickListDetailsItem selectedPickListItem = PickListDetailsItem(
                  id: firstFirstGroupedPickingDataGroupedList[0].id,
                  itemId: firstFirstGroupedPickingDataGroupedList[0].itemId,
                  picklistNum: firstFirstGroupedPickingDataGroupedList[0].picklistNum,
                  status: firstFirstGroupedPickingDataGroupedList[0].status,
                  itemCode: firstFirstGroupedPickingDataGroupedList[0].itemCode,
                  itemName: firstFirstGroupedPickingDataGroupedList[0].itemName,
                  quantity: ((List.generate(firstFirstGroupedPickingDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickingDataGroupedList[i].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  pickedQty: ((List.generate(firstFirstGroupedPickingDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickingDataGroupedList[i].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  uom: firstFirstGroupedPickingDataGroupedList[0].uom,
                  itemType: firstFirstGroupedPickingDataGroupedList[0].itemType,
                  typeColor: firstFirstGroupedPickingDataGroupedList[0].typeColor,
                  floor: firstFirstGroupedPickingDataGroupedList[0].floor,
                  room: firstFirstGroupedPickingDataGroupedList[0].room,
                  zone: firstFirstGroupedPickingDataGroupedList[0].zone,
                  stagingArea: firstFirstGroupedPickingDataGroupedList[0].stagingArea,
                  isProgressStatus: firstFirstGroupedPickingDataGroupedList[0].isProgressStatus,
                  packageTerms: firstFirstGroupedPickingDataGroupedList[0].packageTerms,
                  catchWeightStatus: firstFirstGroupedPickingDataGroupedList[0].catchWeightStatus,
                  catchWeightInfo: firstFirstGroupedPickingDataGroupedList[0].catchWeightInfo,
                  catchWeightInfoForList: firstFirstGroupedPickingDataGroupedList[0].catchWeightInfoForList,
                  catchWeightInfoPicked: firstFirstGroupedPickingDataGroupedList[0].catchWeightInfoPicked,
                  handledBy: firstFirstGroupedPickingDataGroupedList[0].handledBy,
                  locationDisputeInfo: firstFirstGroupedPickingDataGroupedList[0].locationDisputeInfo,
                  unavailableReason: firstFirstGroupedPickingDataGroupedList[0].unavailableReason,
                  alternativeItemName: firstFirstGroupedPickingDataGroupedList[0].alternativeItemName,
                  alternativeItemCode: firstFirstGroupedPickingDataGroupedList[0].alternativeItemCode,
                  batchesList: List.generate(firstFirstGroupedPickingDataGroupedList.length, (i)=>firstFirstGroupedPickingDataGroupedList[i].batchesList[0]),
                  allowUndo: firstFirstGroupedPickingDataGroupedList[0].allowUndo,
                  soNum: firstFirstGroupedPickingDataGroupedList[0].soNum);
              groupedPickingData[i].add(selectedPickListItem);
            }
          }
         // getTabsCountData();
        }
      case "Partial":
        {
          ///for picked list grouped by floor & staging area
          List<PickListDetailsItem> pickedList = (tabPickListItems.where((element) => !element.isProgressStatus).toList());
          Map<String, List<PickListDetailsItem>> pickedGroup = groupBy(pickedList, (PickListDetailsItem item) => '${item.floor}-${item.stagingArea}');
          //groupedPickedData = pickedGroup.values.toList();
          groupedPickedData.clear();
          for(int i=0;i<pickedGroup.values.toList().length;i++){
            groupedPickedData.add([]);
            List<PickListDetailsItem> firstGroupedPickedData = pickedGroup.values.toList()[i];
            Map<String, List<PickListDetailsItem>> firstGroupedPickedDataGrouped = groupBy(firstGroupedPickedData, (PickListDetailsItem data) => data.itemId);
            List<List<PickListDetailsItem>> firstGroupedPickedDataGroupedList = firstGroupedPickedDataGrouped.values.toList();
            for(int j=0;j<firstGroupedPickedDataGroupedList.length;j++){
              List<PickListDetailsItem> firstFirstGroupedPickedDataGroupedList = firstGroupedPickedDataGroupedList[j];
              PickListDetailsItem selectedPickListItem = PickListDetailsItem(
                  id: firstFirstGroupedPickedDataGroupedList[0].id,
                  itemId: firstFirstGroupedPickedDataGroupedList[0].itemId,
                  picklistNum: firstFirstGroupedPickedDataGroupedList[0].picklistNum,
                  status: firstFirstGroupedPickedDataGroupedList[0].status,
                  itemCode: firstFirstGroupedPickedDataGroupedList[0].itemCode,
                  itemName: firstFirstGroupedPickedDataGroupedList[0].itemName,
                  quantity: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  pickedQty: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  uom: firstFirstGroupedPickedDataGroupedList[0].uom,
                  itemType: firstFirstGroupedPickedDataGroupedList[0].itemType,
                  typeColor: firstFirstGroupedPickedDataGroupedList[0].typeColor,
                  floor: firstFirstGroupedPickedDataGroupedList[0].floor,
                  room: firstFirstGroupedPickedDataGroupedList[0].room,
                  zone: firstFirstGroupedPickedDataGroupedList[0].zone,
                  stagingArea: firstFirstGroupedPickedDataGroupedList[0].stagingArea,
                  isProgressStatus: firstFirstGroupedPickedDataGroupedList[0].isProgressStatus,
                  packageTerms: firstFirstGroupedPickedDataGroupedList[0].packageTerms,
                  catchWeightStatus: firstFirstGroupedPickedDataGroupedList[0].catchWeightStatus,
                  catchWeightInfo: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfo,
                  catchWeightInfoForList: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoForList,
                  catchWeightInfoPicked: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoPicked,
                  handledBy: firstFirstGroupedPickedDataGroupedList[0].handledBy,
                  locationDisputeInfo: firstFirstGroupedPickedDataGroupedList[0].locationDisputeInfo,
                  unavailableReason: firstFirstGroupedPickedDataGroupedList[0].unavailableReason,
                  alternativeItemName: firstFirstGroupedPickedDataGroupedList[0].alternativeItemName,
                  alternativeItemCode: firstFirstGroupedPickedDataGroupedList[0].alternativeItemCode,
                  batchesList: List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>firstFirstGroupedPickedDataGroupedList[i].batchesList[0]),
                  allowUndo: firstFirstGroupedPickedDataGroupedList[0].allowUndo,
                  soNum: firstFirstGroupedPickedDataGroupedList[0].soNum);
              groupedPickedData[i].add(selectedPickListItem);
            }
          }

          ///for picking in progress list grouped by storekeeper
          List<PickListDetailsItem> pickingList = (tabPickListItems.where((element) => element.isProgressStatus).toList());
          Map<String, List<PickListDetailsItem>> groupedData = {};
          for (PickListDetailsItem item in pickingList) {
            List<HandledByPickList> handledBy = item.handledBy;
            for (HandledByPickList handler in handledBy) {
              String name = handler.name;
              if (!groupedData.containsKey(name)) {
                groupedData[name] = [];
              }
              groupedData[name]!.add(item);
            }
          }
          groupedKeepersNameList = groupedData.keys.toList();
          //groupedPickingData = groupedData.values.toList();
          groupedPickingData.clear();
          for(int i=0;i<groupedData.values.toList().length;i++){
            groupedPickingData.add([]);
            List<PickListDetailsItem> firstGroupedPickingData = groupedData.values.toList()[i];
            Map<String, List<PickListDetailsItem>> firstGroupedPickingDataGrouped = groupBy(firstGroupedPickingData, (PickListDetailsItem data) => data.itemId);
            List<List<PickListDetailsItem>> firstGroupedPickingDataGroupedList = firstGroupedPickingDataGrouped.values.toList();
            for(int j=0;j<firstGroupedPickingDataGroupedList.length;j++){
              List<PickListDetailsItem> firstFirstGroupedPickingDataGroupedList = firstGroupedPickingDataGroupedList[j];
              PickListDetailsItem selectedPickListItem = PickListDetailsItem(
                  id: firstFirstGroupedPickingDataGroupedList[0].id,
                  itemId: firstFirstGroupedPickingDataGroupedList[0].itemId,
                  picklistNum: firstFirstGroupedPickingDataGroupedList[0].picklistNum,
                  status: firstFirstGroupedPickingDataGroupedList[0].status,
                  itemCode: firstFirstGroupedPickingDataGroupedList[0].itemCode,
                  itemName: firstFirstGroupedPickingDataGroupedList[0].itemName,
                  quantity: ((List.generate(firstFirstGroupedPickingDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickingDataGroupedList[i].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  pickedQty: ((List.generate(firstFirstGroupedPickingDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickingDataGroupedList[i].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  uom: firstFirstGroupedPickingDataGroupedList[0].uom,
                  itemType: firstFirstGroupedPickingDataGroupedList[0].itemType,
                  typeColor: firstFirstGroupedPickingDataGroupedList[0].typeColor,
                  floor: firstFirstGroupedPickingDataGroupedList[0].floor,
                  room: firstFirstGroupedPickingDataGroupedList[0].room,
                  zone: firstFirstGroupedPickingDataGroupedList[0].zone,
                  stagingArea: firstFirstGroupedPickingDataGroupedList[0].stagingArea,
                  isProgressStatus: firstFirstGroupedPickingDataGroupedList[0].isProgressStatus,
                  packageTerms: firstFirstGroupedPickingDataGroupedList[0].packageTerms,
                  catchWeightStatus: firstFirstGroupedPickingDataGroupedList[0].catchWeightStatus,
                  catchWeightInfo: firstFirstGroupedPickingDataGroupedList[0].catchWeightInfo,
                  catchWeightInfoForList: firstFirstGroupedPickingDataGroupedList[0].catchWeightInfoForList,
                  catchWeightInfoPicked: firstFirstGroupedPickingDataGroupedList[0].catchWeightInfoPicked,
                  handledBy: firstFirstGroupedPickingDataGroupedList[0].handledBy,
                  locationDisputeInfo: firstFirstGroupedPickingDataGroupedList[0].locationDisputeInfo,
                  unavailableReason: firstFirstGroupedPickingDataGroupedList[0].unavailableReason,
                  alternativeItemName: firstFirstGroupedPickingDataGroupedList[0].alternativeItemName,
                  alternativeItemCode: firstFirstGroupedPickingDataGroupedList[0].alternativeItemCode,
                  batchesList: List.generate(firstFirstGroupedPickingDataGroupedList.length, (i)=>firstFirstGroupedPickingDataGroupedList[i].batchesList[0]),
                  allowUndo: firstFirstGroupedPickingDataGroupedList[0].allowUndo,
                  soNum: firstFirstGroupedPickingDataGroupedList[0].soNum);
              groupedPickingData[i].add(selectedPickListItem);
            }
          }
          //getTabsCountData();
        }
      case "Unavailable":
        {
          ///for picked list grouped by floor
          Map<String, List<PickListDetailsItem>> grouped = groupBy(tabPickListItems, (PickListDetailsItem item) => item.floor);
          //groupedPickedData = grouped.values.toList();
          groupedPickedData.clear();
          for(int i=0;i<grouped.values.toList().length;i++){
            groupedPickedData.add([]);
            List<PickListDetailsItem> firstGroupedPickedData = grouped.values.toList()[i];
            Map<String, List<PickListDetailsItem>> firstGroupedPickedDataGrouped = groupBy(firstGroupedPickedData, (PickListDetailsItem data) => data.itemId);
            List<List<PickListDetailsItem>> firstGroupedPickedDataGroupedList = firstGroupedPickedDataGrouped.values.toList();
            for(int j=0;j<firstGroupedPickedDataGroupedList.length;j++){
              List<PickListDetailsItem> firstFirstGroupedPickedDataGroupedList = firstGroupedPickedDataGroupedList[j];
              PickListDetailsItem selectedPickListItem = PickListDetailsItem(
                  id: firstFirstGroupedPickedDataGroupedList[0].id,
                  itemId: firstFirstGroupedPickedDataGroupedList[0].itemId,
                  picklistNum: firstFirstGroupedPickedDataGroupedList[0].picklistNum,
                  status: firstFirstGroupedPickedDataGroupedList[0].status,
                  itemCode: firstFirstGroupedPickedDataGroupedList[0].itemCode,
                  itemName: firstFirstGroupedPickedDataGroupedList[0].itemName,
                  quantity: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  pickedQty: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  uom: firstFirstGroupedPickedDataGroupedList[0].uom,
                  itemType: firstFirstGroupedPickedDataGroupedList[0].itemType,
                  typeColor: firstFirstGroupedPickedDataGroupedList[0].typeColor,
                  floor: firstFirstGroupedPickedDataGroupedList[0].floor,
                  room: firstFirstGroupedPickedDataGroupedList[0].room,
                  zone: firstFirstGroupedPickedDataGroupedList[0].zone,
                  stagingArea: firstFirstGroupedPickedDataGroupedList[0].stagingArea,
                  isProgressStatus: firstFirstGroupedPickedDataGroupedList[0].isProgressStatus,
                  packageTerms: firstFirstGroupedPickedDataGroupedList[0].packageTerms,
                  catchWeightStatus: firstFirstGroupedPickedDataGroupedList[0].catchWeightStatus,
                  catchWeightInfo: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfo,
                  catchWeightInfoForList: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoForList,
                  catchWeightInfoPicked: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoPicked,
                  handledBy: firstFirstGroupedPickedDataGroupedList[0].handledBy,
                  locationDisputeInfo: firstFirstGroupedPickedDataGroupedList[0].locationDisputeInfo,
                  unavailableReason: firstFirstGroupedPickedDataGroupedList[0].unavailableReason,
                  alternativeItemName: firstFirstGroupedPickedDataGroupedList[0].alternativeItemName,
                  alternativeItemCode: firstFirstGroupedPickedDataGroupedList[0].alternativeItemCode,
                  batchesList: List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>firstFirstGroupedPickedDataGroupedList[i].batchesList[0]),
                  allowUndo: firstFirstGroupedPickedDataGroupedList[0].allowUndo,
                  soNum: firstFirstGroupedPickedDataGroupedList[0].soNum);
              groupedPickedData[i].add(selectedPickListItem);
            }
          }
          //getTabsCountData();
        }
      default:
        {
          ///for picked list grouped by floor,room & zone
          Map<String, List<PickListDetailsItem>> grouped =
          groupBy(tabPickListItems, (PickListDetailsItem item) => '${item.floor}-${item.room}-${item.zone}');
          //groupedPickedData = grouped.values.toList();
          groupedPickedData.clear();
          for(int i=0;i<grouped.values.toList().length;i++){
            groupedPickedData.add([]);
            List<PickListDetailsItem> firstGroupedPickedData = grouped.values.toList()[i];
            Map<String, List<PickListDetailsItem>> firstGroupedPickedDataGrouped = groupBy(firstGroupedPickedData, (PickListDetailsItem data) => data.itemId);
            List<List<PickListDetailsItem>> firstGroupedPickedDataGroupedList = firstGroupedPickedDataGrouped.values.toList();
            for(int j=0;j<firstGroupedPickedDataGroupedList.length;j++){
              List<PickListDetailsItem> firstFirstGroupedPickedDataGroupedList = firstGroupedPickedDataGroupedList[j];
              PickListDetailsItem selectedPickListItem = PickListDetailsItem(
                  id: firstFirstGroupedPickedDataGroupedList[0].id,
                  itemId: firstFirstGroupedPickedDataGroupedList[0].itemId,
                  picklistNum: firstFirstGroupedPickedDataGroupedList[0].picklistNum,
                  status: firstFirstGroupedPickedDataGroupedList[0].status,
                  itemCode: firstFirstGroupedPickedDataGroupedList[0].itemCode,
                  itemName: firstFirstGroupedPickedDataGroupedList[0].itemName,
                  quantity: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].quantity))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  pickedQty: ((List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>num.parse(firstFirstGroupedPickedDataGroupedList[i].pickedQty))).fold(0, (prev, element) => (prev + element).toInt())).toString(),
                  uom: firstFirstGroupedPickedDataGroupedList[0].uom,
                  itemType: firstFirstGroupedPickedDataGroupedList[0].itemType,
                  typeColor: firstFirstGroupedPickedDataGroupedList[0].typeColor,
                  floor: firstFirstGroupedPickedDataGroupedList[0].floor,
                  room: firstFirstGroupedPickedDataGroupedList[0].room,
                  zone: firstFirstGroupedPickedDataGroupedList[0].zone,
                  stagingArea: firstFirstGroupedPickedDataGroupedList[0].stagingArea,
                  isProgressStatus: firstFirstGroupedPickedDataGroupedList[0].isProgressStatus,
                  packageTerms: firstFirstGroupedPickedDataGroupedList[0].packageTerms,
                  catchWeightStatus: firstFirstGroupedPickedDataGroupedList[0].catchWeightStatus,
                  catchWeightInfo: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfo,
                  catchWeightInfoForList: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoForList,
                  catchWeightInfoPicked: firstFirstGroupedPickedDataGroupedList[0].catchWeightInfoPicked,
                  handledBy: firstFirstGroupedPickedDataGroupedList[0].handledBy,
                  locationDisputeInfo: firstFirstGroupedPickedDataGroupedList[0].locationDisputeInfo,
                  unavailableReason: firstFirstGroupedPickedDataGroupedList[0].unavailableReason,
                  alternativeItemName: firstFirstGroupedPickedDataGroupedList[0].alternativeItemName,
                  alternativeItemCode: firstFirstGroupedPickedDataGroupedList[0].alternativeItemCode,
                  batchesList: List.generate(firstFirstGroupedPickedDataGroupedList.length, (i)=>firstFirstGroupedPickedDataGroupedList[i].batchesList[0]),
                  allowUndo: firstFirstGroupedPickedDataGroupedList[0].allowUndo,
                  soNum: firstFirstGroupedPickedDataGroupedList[0].soNum);
              groupedPickedData[i].add(selectedPickListItem);
            }
          }
         // getTabsCountData();
        }
    }
  }

  completeFunction() async{
    Box pickListMainDataListLocalBox = Hive.box('pick_list_main_data_list_local');
    List<Map<String, dynamic>> pickListMainData = [];
    String? pickListMainDataListLocalGetString = pickListMainDataListLocalBox.get('myListKey');
    if (pickListMainDataListLocalGetString != null) {
      List<dynamic> decoded = jsonDecode(pickListMainDataListLocalGetString);
      pickListMainData = List<Map<String, dynamic>>.from(decoded);
    }
    List<Map<String, dynamic>> matchedPickListList = pickListMainData.where((e)=>e["picklist_id"]==selectedPickListId).toList();
    for (var element in matchedPickListList) {
      element["do_complete_action"] = false;
      element["is_completed"] = true;
      element["picklist_status"] = "Completed";
      element["in_progress"] = false;
      element["picklist_status_color"] = "29B473";
      element["picklist_status_bg_color"] = "C9F2DC";
      element["completed"] = DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.now());
    }
    for (int i = 0; i < pickListMainData.length; i++) {
      for (final updated in matchedPickListList) {
        if (pickListMainData[i]['picklist_id'] == updated['picklist_id'] &&
            pickListMainData[i]['picklist_item_id'] == updated['picklist_item_id'] &&
            pickListMainData[i]['batch_id'] == updated['batch_id']) {
          pickListMainData[i] = updated;
          break;
        }
      }
    }
    await pickListMainDataListLocalBox.put('myListKey', jsonEncode(pickListMainData));
    setFunction(isComplete: true);
  }
}
