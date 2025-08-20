import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:oda/local_database/pick_list_box/pick_list.dart';
import 'package:oda/repository_model/general/general_variables.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/variables.dart';

part 'pick_list_event.dart';
part 'pick_list_state.dart';

class PickListBloc extends Bloc<PickListEvent, PickListState> {
  String? selectedLocation;
  String selectedLocationId = "";
  bool fieldEmpty = false;
  bool hideKeyBoardLocation = false;
  bool isLocationSelected = false;
  bool searchBarEnabled = false;
  String searchText = "";
  int pageIndex = 1;
  PickListMainResponse pickListMainResponse = PickListMainResponse.fromJson({});
  List<FloorLocation> searchedFloorData = [];
  List<StagingLocation> stagingAreaList = [];
  List<PicklistItem> searchedPickList = [];

  List<Map<String, dynamic>> optionsDataLocal = [];
  List<Map<String, dynamic>> pickListMainDataListLocal = [];
  Box pickListMainDataListLocalBox = Hive.box('pick_list_main_data_list_local');
  List<Map<String, dynamic>> pickListMainData = [];

  PickListBloc() : super(PickListLoading()) {
    on<PickListInitialEvent>(pickListInitialFunction);
    on<PickListTabChangingEvent>(pickListTabChangingFunction);
    on<PickListSetStateEvent>(pickListSetStateFunction);
    on<PickListLocationChangedEvent>(pickListLocationChangedFunction);
  }

  FutureOr<void> pickListInitialFunction(PickListInitialEvent event, Emitter<PickListState> emit) async {
    searchText = "";
    searchBarEnabled = false;
    /*event.isRefreshing ? emit(PickListTableLoading()) :*/ emit(PickListLoading());
    searchedPickList.clear();
    pickListMainResponse = PickListMainResponse.fromJson({});
    getIt<Variables>().generalVariables.filters.clear();
    getIt<Variables>().generalVariables.selectedFilters.clear();
    getIt<Variables>().generalVariables.selectedFiltersName.clear();
    getIt<Variables>().generalVariables.filterSearchController.clear();
    getIt<Variables>().generalVariables.filterSelectedMainIndex = 0;
    pickListMainDataListLocal.clear();
    if (!getIt<Variables>().generalVariables.isNetworkOffline) {
      await pickListInitialMainFunction();
    }
    await initFloorDBFunction();
    if (getIt<Variables>().generalVariables.popUpTime != null) {
      if (getIt<Variables>().generalVariables.popUpTime!.isBefore(DateTime.now())) {
        emit(PickListDialogState());
        emit(PickListLoading());
      } else {
        String? pickListMainDataListLocalGetString = pickListMainDataListLocalBox.get('myListKey');
        if (pickListMainDataListLocalGetString != null) {
          List<dynamic> decoded = jsonDecode(pickListMainDataListLocalGetString);
          pickListMainData = List<Map<String, dynamic>>.from(decoded);
        }
        List<String> soNumListData = List.generate(pickListMainData.length, (i) => pickListMainData[i]["so_num"]);
        List<String> soNumList = soNumListData.toSet().toList();
        List<String> soTypeListData = List.generate(pickListMainData.length, (i) => pickListMainData[i]["so_type"]);
        List<String> soTypeList = soTypeListData.toSet().toList();
        await initDBFunction();
          getIt<Variables>()
              .generalVariables
              .selectedFilters
              .add(SelectedFilterModel(type: "locations", options: [selectedLocationId]));
          getIt<Variables>()
              .generalVariables
              .selectedFiltersName
              .add("FLOOR : ${getIt<Variables>().generalVariables.selectedFilters[0].options[0]}");
        getIt<Variables>().generalVariables.filters = List<Filter>.from([
          {
            "type": "locations",
            "label": getIt<Variables>().generalVariables.currentLanguage.location,
            "selection": "single",
            "get_options": false,
            "options": List.generate(
                pickListMainResponse.picklist.length,
                (i) => {
                      "id": pickListMainResponse.picklist[i].itemLocation,
                      "label": pickListMainResponse.picklist[i].itemLocation
                    }).map((map) => jsonEncode(map)).toSet().map((str) => jsonDecode(str)).toList()
          },
          {
            "type": "picklist_num",
            "label": getIt<Variables>().generalVariables.currentLanguage.pickListNum,
            "selection": "multiple",
            "get_options": false,
            "options": List.generate(
                pickListMainResponse.picklist.length,
                (i) => {
                      "id": pickListMainResponse.picklist[i].picklistNumber,
                      "label": pickListMainResponse.picklist[i].picklistNumber
                    }).map((map) => jsonEncode(map)).toSet().map((str) => jsonDecode(str)).toList()
          },
          {
            "type": "status",
            "label": getIt<Variables>().generalVariables.currentLanguage.status,
            "selection": "multiple",
            "get_options": false,
            "options": List.generate(pickListMainResponse.picklist.length,
                    (i) => {"id": pickListMainResponse.picklist[i].status, "label": pickListMainResponse.picklist[i].status})
                .map((map) => jsonEncode(map))
                .toSet()
                .map((str) => jsonDecode(str))
                .toList()
          },
          {
            "type": "so_types",
            "label": getIt<Variables>().generalVariables.currentLanguage.pickListType,
            "selection": "multiple",
            "get_options": false,
            "options": List.generate(soTypeList.length, (i) => {"id": soTypeList[i], "label": soTypeList[i]})
                .map((map) => jsonEncode(map))
                .toSet()
                .map((str) => jsonDecode(str))
                .toList()
          },
          {
            "type": "picklist_so",
            "label": getIt<Variables>().generalVariables.currentLanguage.soNum,
            "selection": "multiple",
            "get_options": false,
            "options": List.generate(soNumList.length, (i) => {"id": soNumList[i], "label": soNumList[i]})
                .map((map) => jsonEncode(map))
                .toSet()
                .map((str) => jsonDecode(str))
                .toList()
          },
          {
            "type": "picklist_type",
            "label": getIt<Variables>().generalVariables.currentLanguage.deliveryArea,
            "selection": "multiple",
            "get_options": false,
            "options": List.generate(
                pickListMainResponse.picklist.length,
                (i) => {
                      "id": pickListMainResponse.picklist[i].deliveryArea,
                      "label": pickListMainResponse.picklist[i].deliveryArea
                    }).map((map) => jsonEncode(map)).toSet().map((str) => jsonDecode(str)).toList()
          },
          {
            "type": "picklist_priority",
            "label": getIt<Variables>().generalVariables.currentLanguage.priority,
            "selection": "multiple",
            "get_options": false,
            "options": List.generate(pickListMainResponse.picklist.length,
                    (i) => {"id": pickListMainResponse.picklist[i].orderType, "label": pickListMainResponse.picklist[i].orderType})
                .map((map) => jsonEncode(map))
                .toSet()
                .map((str) => jsonDecode(str))
                .toList()
          },
          {
            "type": "picklist_item_type",
            "label": getIt<Variables>().generalVariables.currentLanguage.itemType,
            "selection": "multiple",
            "get_options": false,
            "options": List.generate(
                pickListMainResponse.picklist.length,
                (i) => {
                      "id": pickListMainResponse.picklist[i].itemsType,
                      "label": pickListMainResponse.picklist[i].itemsType == "D"
                          ? "DRY"
                          : pickListMainResponse.picklist[i].itemsType == "F"
                              ? "FROZEN"
                              : pickListMainResponse.picklist[i].itemsType == "B"
                                  ? "BOTH"
                                  : ""
                    }).map((map) => jsonEncode(map)).toSet().map((str) => jsonDecode(str)).toList()
          },
          {
            "type": "business_dt",
            "label": getIt<Variables>().generalVariables.currentLanguage.businessDate,
            "selection": "single_date",
            "get_options": false,
            "options": []
          }
        ].map((x) => Filter.fromJson(x)));
        emit(PickListDummy());
        emit(PickListLoaded());
      }
    } else {
      emit(PickListDialogState());
      emit(PickListLoading());
    }
  }

  initFloorDBFunction() async {
    Box<FloorLocation> floorLocationData = await Hive.openBox<FloorLocation>('floor_location');
    if (floorLocationData.isNotEmpty) {
      List<FloorLocation> floors = floorLocationData.values.toList();
      searchedFloorData.clear();
      searchedFloorData.addAll(floors);
    }
    Box<StagingLocation> stagingLocationData = await Hive.openBox<StagingLocation>('staging_location');
    if (stagingLocationData.isNotEmpty) {
      List<StagingLocation> staging = stagingLocationData.values.toList();
      stagingAreaList.clear();
      stagingAreaList.addAll(staging);
    }
  }

  initDBFunction() async {
    String? pickListMainDataListLocalGetString = pickListMainDataListLocalBox.get('myListKey');
    if (pickListMainDataListLocalGetString != null) {
      List<dynamic> decoded = jsonDecode(pickListMainDataListLocalGetString);
      pickListMainData = List<Map<String, dynamic>>.from(decoded);
    }
    Map<String, List<Map<String, dynamic>>> pickListData = groupBy(pickListMainData, (Map<String, dynamic> data) => data["picklist_id"]);
    List<List<Map<String, dynamic>>> pickListDataValues = pickListData.values.toList();
    List<Map<String, dynamic>> pickListDataMain = List.generate(pickListDataValues.length, (i) => pickListDataValues[i][0]);
    for (int i = 0; i < pickListDataValues.length; i++) {
      Map<String, dynamic> countData = {};
      for (int j = 0; j < pickListDataValues[i].length; j++) {
        for (int k = 0; k < pickListDataValues[i][j]["handled_by"].length; k++) {
          if (countData.containsKey("${pickListDataValues[i][j]["handled_by"][k]["code"]}")) {
            countData["${pickListDataValues[i][j]["handled_by"][k]["code"]}"] =
                (num.parse(countData["${pickListDataValues[i][j]["handled_by"][k]["code"]}"]) +
                        num.parse(pickListDataValues[i][j]["handled_by"][k]["picked_items"]))
                    .toString();
          } else {
            countData["${pickListDataValues[i][j]["handled_by"][k]["code"]}"] =
                pickListDataValues[i][j]["handled_by"][k]["picked_items"];
          }
        }
      }
      List<Map<String, dynamic>> pickListHandledBy = [];
      for (int l = 0; l < countData.keys.length; l++) {
        Map<String, dynamic> matchedUser = getIt<Variables>()
            .generalVariables
            .userData
            .usersList
            .singleWhere((element) => element.code == countData.keys.toList()[l])
            .toJson();
        matchedUser["picked_items"] = countData[countData.keys.toList()[l]];
        pickListHandledBy.add(matchedUser);
      }
      pickListDataMain[i]["handled_by"] = pickListHandledBy;
    }
    pickListMainResponse =
        PickListMainResponse(picklist: List<PicklistItem>.from(pickListDataMain.map((x) => PicklistItem.fromJson(x))));
    searchedPickList.clear();
    searchedPickList
        .addAll(pickListMainResponse.picklist.where((x) => x.itemLocation.toLowerCase() == selectedLocationId.toLowerCase()).toList());
    isLocationSelected = true;
  }

/*  initPickListDBFunction({required List<List<Map<String, dynamic>>> pickListDataValues}) async {
    await Hive.box<PickListDetailsResponse>('pick_list_details_response').clear();
    Box<PickListDetailsResponse> pickListDetailsResponseBoxData = Hive.box<PickListDetailsResponse>('pick_list_details_response');
    Box<UnavailableReason> unavailableReasonData = await Hive.openBox<UnavailableReason>('unavailable_reason');
    Box<UnavailableReason> completeReasonData = await Hive.openBox<UnavailableReason>('complete_reason');
    for (int i = 0; i < pickListMainResponse.picklist.length; i++) {
      List<Map<String, dynamic>> batchesSessionData = [];
      List<Map<String, dynamic>> partialWorkedData = pickListDataValues[i].where((x) => x["picklist_item_status"] == "Partial").toList();
      for (int j = 0; j < pickListDataValues[i].length; j++) {
        if (pickListDataValues[i][j]["is_session_opened"]) {
          batchesSessionData.add(pickListDataValues[i][j]);
        }
      }
      String pendingData = batchesSessionData.where((e) => e["picklist_item_status"] == "Pending").toList().length.toString();
      String pickedData = batchesSessionData.where((e) => e["picklist_item_status"] == "Picked").toList().length.toString();
      String partialData = batchesSessionData.where((e) => e["picklist_item_status"] == "Partial").toList().length.toString();
      String unavailableData = batchesSessionData.where((e) => e["picklist_item_status"] == "Unavailable").toList().length.toString();
      Map<String, List<Map<String, dynamic>>> pickListItemData = groupBy(pickListDataValues[i], (Map<String, dynamic> data) => data["line_item_id"]);
      List<List<Map<String, dynamic>>> pickListItemDataValues = pickListItemData.values.toList();
      List<Map<String, dynamic>> pickListItemDataMain = List.generate(pickListItemDataValues.length, (j) => pickListItemDataValues[j][0]);
      List<PickListDetailsItem> itemsPickListDetailsData = List<PickListDetailsItem>.from(pickListItemDataMain.map((x) => PickListDetailsItem.fromJson(x)));
      PickListSessionInfo sessionData = PickListSessionInfo.fromJson({});
      for (int j = 0; j < pickListDataValues[i].length; j++) {
        if (pickListDataValues[i][j]["is_session_opened"]) {
          sessionData = PickListSessionInfo(
              isOpened: pickListDataValues[i][j]["is_session_opened"],
              id: pickListDataValues[i][j]["session_id"],
              pending: "0",
              picked: "0",
              partial: "0",
              unavailable: "0",
              sessionStartTimestamp: pickListDataValues[i][j]["session_timestamp"],
              timeSpendSeconds: "",
              partialIdsList: [],
              pendingList: [],
              pickedList: [],
              partialList: [],
              unavailableList: []);
          break;
        }
      }
      sessionData.pending = pendingData;
      sessionData.picked = pickedData;
      sessionData.partial = partialData;
      sessionData.unavailable = unavailableData;
      sessionData.partialIdsList = List.generate(partialWorkedData.length, (l) => partialWorkedData[l]["picklist_item_id"]);
      sessionData.pendingList = List<PickListDetailsItem>.from(batchesSessionData
          .where((e) => e["picklist_item_status"] == "Pending")
          .toList()
          .map((x) => PickListDetailsItem.fromJson(x)));
      sessionData.pickedList = List<PickListDetailsItem>.from(
          batchesSessionData.where((e) => e["picklist_item_status"] == "Picked").toList().map((x) => PickListDetailsItem.fromJson(x)));
      sessionData.partialList = List<PickListDetailsItem>.from(batchesSessionData
          .where((e) => e["picklist_item_status"] == "Partial")
          .toList()
          .map((x) => PickListDetailsItem.fromJson(x)));
      sessionData.unavailableList = List<PickListDetailsItem>.from(batchesSessionData
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
      pickListDetailsResponseBoxData.put(i, PickListDetailsResponse(
              picklistId: pickListDataValues[i][0]["picklist_id"] ?? "",
              picklistNum: pickListDataValues[i][0]["picklist_num"] ?? "",
              route: pickListDataValues[i][0]["route"] ?? "",
              picklistStatus: pickListDataValues[i][0]["picklist_status"] ?? "",
              picklistTime: pickListDataValues[i][0]["picklist_created"] ?? "",
              totalItems: pickListDataValues[i][0]["total_picklist_items"] ?? "",
              pickedItems: pickListDataValues[i][0]["total_picklist_picked_items"] ?? "",
              isReadyToMoveComplete: pickListItemDataMain.where((x) => x["picklist_item_status"] == "Pending").toList().isEmpty &&
                  sessionData.isOpened == false &&
                  pickListItemDataMain.where((x) => x["picklist_item_status"] == "Partial").toList().isNotEmpty,
              isCompleted:
                  pickListDataValues[i][0]["picklist_status"] == getIt<Variables>().generalVariables.currentLanguage.completed,
              handledBy: List<HandledByPickList>.from(
                  (pickListDataValues[i][0]["handled_by"] ?? []).map((x) => HandledByPickList.fromJson(x))),
              yetToPick: pickListItemDataMain.where((x) => x["picklist_item_status"] == "Pending").toList().length,
              picked: pickListItemDataMain.where((x) => x["picklist_item_status"] == "Picked").toList().length,
              partial: pickListItemDataMain.where((x) => x["picklist_item_status"] == "Partial").toList().length,
              unavailable: pickListItemDataMain.where((x) => x["picklist_item_status"] == "Unavailable").toList().length,
              items: itemsPickListDetailsData,
              unavailableReasons: unavailableReasonData.values.toList(),
              completeReasons: completeReasonData.values.toList(),
              alternateItems: getIt<Variables>().generalVariables.userData.filterItemsListOptions,
              locationFilter: Filter.fromJson({}),
              sessionInfo: sessionData,
              timelineInfo: List<TimelineInfo>.from([].map((x) => TimelineInfo.fromJson(x)))));
    }
  }*/

  FutureOr<void> pickListLocationChangedFunction(PickListLocationChangedEvent event, Emitter<PickListState> emit) async {
    getIt<Variables>().generalVariables.popUpTime = DateTime.now().add(const Duration(hours: 1));
      getIt<Variables>().generalVariables.selectedFilters.add(SelectedFilterModel(type: "locations", options: [selectedLocationId]));
      getIt<Variables>()
          .generalVariables
          .selectedFiltersName
          .add("FLOOR : ${getIt<Variables>().generalVariables.selectedFilters[0].options[0]}");
    String? pickListMainDataListLocalGetString = pickListMainDataListLocalBox.get('myListKey');
    if (pickListMainDataListLocalGetString != null) {
      List<dynamic> decoded = jsonDecode(pickListMainDataListLocalGetString);
      pickListMainData = List<Map<String, dynamic>>.from(decoded);
    }
    List<String> soNumListData = List.generate(pickListMainData.length, (i) => pickListMainData[i]["so_num"]);
    List<String> soNumList = soNumListData.toSet().toList();
    List<String> soTypeListData = List.generate(pickListMainData.length, (i) => pickListMainData[i]["so_type"]);
    List<String> soTypeList = soTypeListData.toSet().toList();
    await initDBFunction();
    getIt<Variables>().generalVariables.filters = List<Filter>.from([
      {
        "type": "locations",
        "label": getIt<Variables>().generalVariables.currentLanguage.location,
        "selection": "single",
        "get_options": false,
        "options": List.generate(pickListMainResponse.picklist.length,
                (i) => {"id": pickListMainResponse.picklist[i].itemLocation, "label": pickListMainResponse.picklist[i].itemLocation})
            .map((map) => jsonEncode(map))
            .toSet()
            .map((str) => jsonDecode(str))
            .toList()
      },
      {
        "type": "picklist_num",
        "label": getIt<Variables>().generalVariables.currentLanguage.pickListNum,
        "selection": "multiple",
        "get_options": false,
        "options": List.generate(
            pickListMainResponse.picklist.length,
            (i) => {
                  "id": pickListMainResponse.picklist[i].picklistNumber,
                  "label": pickListMainResponse.picklist[i].picklistNumber
                }).map((map) => jsonEncode(map)).toSet().map((str) => jsonDecode(str)).toList()
      },
      {
        "type": "status",
        "label": getIt<Variables>().generalVariables.currentLanguage.status,
        "selection": "multiple",
        "get_options": false,
        "options": List.generate(pickListMainResponse.picklist.length,
                (i) => {"id": pickListMainResponse.picklist[i].status, "label": pickListMainResponse.picklist[i].status})
            .map((map) => jsonEncode(map))
            .toSet()
            .map((str) => jsonDecode(str))
            .toList()
      },
      {
        "type": "so_types",
        "label": getIt<Variables>().generalVariables.currentLanguage.pickListType,
        "selection": "multiple",
        "get_options": false,
        "options": List.generate(soTypeList.length, (i) => {"id": soTypeList[i], "label": soTypeList[i]})
            .map((map) => jsonEncode(map))
            .toSet()
            .map((str) => jsonDecode(str))
            .toList()
      },
      {
        "type": "picklist_so",
        "label": getIt<Variables>().generalVariables.currentLanguage.soNum,
        "selection": "multiple",
        "get_options": false,
        "options": List.generate(soNumList.length, (i) => {"id": soNumList[i], "label": soNumList[i]})
            .map((map) => jsonEncode(map))
            .toSet()
            .map((str) => jsonDecode(str))
            .toList()
      },
      {
        "type": "picklist_type",
        "label": getIt<Variables>().generalVariables.currentLanguage.deliveryArea,
        "selection": "multiple",
        "get_options": false,
        "options": List.generate(pickListMainResponse.picklist.length,
                (i) => {"id": pickListMainResponse.picklist[i].deliveryArea, "label": pickListMainResponse.picklist[i].deliveryArea})
            .map((map) => jsonEncode(map))
            .toSet()
            .map((str) => jsonDecode(str))
            .toList()
      },
      {
        "type": "picklist_priority",
        "label": getIt<Variables>().generalVariables.currentLanguage.priority,
        "selection": "multiple",
        "get_options": false,
        "options": List.generate(pickListMainResponse.picklist.length,
                (i) => {"id": pickListMainResponse.picklist[i].orderType, "label": pickListMainResponse.picklist[i].orderType})
            .map((map) => jsonEncode(map))
            .toSet()
            .map((str) => jsonDecode(str))
            .toList()
      },
      {
        "type": "picklist_item_type",
        "label": getIt<Variables>().generalVariables.currentLanguage.itemType,
        "selection": "multiple",
        "get_options": false,
        "options": List.generate(
            pickListMainResponse.picklist.length,
            (i) => {
                  "id": pickListMainResponse.picklist[i].itemsType,
                  "label": pickListMainResponse.picklist[i].itemsType == "D"
                      ? "DRY"
                      : pickListMainResponse.picklist[i].itemsType == "F"
                          ? "FROZEN"
                          : pickListMainResponse.picklist[i].itemsType == "B"
                              ? "BOTH"
                              : ""
                }).map((map) => jsonEncode(map)).toSet().map((str) => jsonDecode(str)).toList()
      },
      {
        "type": "business_dt",
        "label": getIt<Variables>().generalVariables.currentLanguage.businessDate,
        "selection": "single_date",
        "get_options": false,
        "options": []
      }
    ].map((x) => Filter.fromJson(x)));
    emit(PickListDummy());
    emit(PickListLoaded());
  }

  FutureOr<void> pickListTabChangingFunction(PickListTabChangingEvent event, Emitter<PickListState> emit) async {
    event.isLoading ? null : emit(PickListTableLoading());
    searchedPickList.clear();
    searchedPickList.addAll(pickListMainResponse.picklist);
    if (searchText.isNotEmpty) {
      searchedPickList = searchedPickList
          .where((x) =>
              x.picklistNumber.toLowerCase().contains(searchText.toLowerCase()) ||
              x.route.toLowerCase().contains(searchText.toLowerCase()) ||
              x.status.toLowerCase().contains(searchText.toLowerCase()) ||
              x.deliveryArea.toLowerCase().contains(searchText.toLowerCase()) ||
              x.orderType.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
    List<PicklistItem> filteredList = [];
    filteredList.addAll(searchedPickList);
    for (int i = 0; i < getIt<Variables>().generalVariables.selectedFilters.length; i++) {
      switch (getIt<Variables>().generalVariables.selectedFilters[i].type) {
        case "locations":
          {
            filteredList = filteredList
                .where((item1) =>
                    getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.itemLocation == item2))
                .toList();
          }
        case "picklist_num":
          {
            filteredList = filteredList
                .where((item1) =>
                    getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.picklistNumber == item2))
                .toList();
          }
        case "status":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.status == item2))
                .toList();
          }
        case "so_types":
          {
            filteredList = filteredList
                .where((item1) =>
                    getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.soType.contains(item2)))
                .toList();
          }
        case "picklist_so":
          {
            filteredList = filteredList
                .where((item1) =>
                    getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.soNum.contains(item2)))
                .toList();
          }
        case "picklist_type":
          {
            filteredList = filteredList
                .where((item1) =>
                    getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.deliveryArea == item2))
                .toList();
          }
        case "picklist_priority":
          {
            filteredList = filteredList
                .where(
                    (item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.orderType == item2))
                .toList();
          }
        case "picklist_item_type":
          {
            filteredList = filteredList
                .where(
                    (item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.itemsType == item2))
                .toList();
          }
        case "business_dt":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>()
                    .generalVariables
                    .selectedFilters[i]
                    .options
                    .any((item2) => item1.businessDate.split(",")[0] == item2))
                .toList();
          }
        default:
          {
            filteredList = filteredList
                .where((item1) =>
                    getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.picklistNumber == item2))
                .toList();
          }
      }
    }
    searchedPickList.clear();
    searchedPickList.addAll(filteredList);
    emit(PickListDummy());
    emit(PickListLoaded());
  }

  FutureOr<void> pickListSetStateFunction(PickListSetStateEvent event, Emitter<PickListState> emit) async {
    emit(PickListDummy());
    event.stillLoading ? emit(PickListLoading()) : emit(PickListLoaded());
  }

  Future<void> pickListInitialMainFunction() async {
    await pickListMainDataListLocalBox.delete('myListKey');
    int i = 1;
    do {
      await getIt<Variables>()
          .repoImpl
          .getPickListMain(query: {"page": i}, method: "post")
          .onError((error, stackTrace) {})
          .then((value) {
            if (value != null) {
              if (value["status"] == "1") {
                optionsDataLocal =
                    List<Map<String, dynamic>>.from((value["response"]["picklist"] ?? []).map((x) => x as Map<String, dynamic>));
                pickListMainDataListLocal.addAll(optionsDataLocal);
              }
            }
          });
      i++;
    } while (optionsDataLocal.isNotEmpty);
    String pickListMainDataListLocalString = jsonEncode(pickListMainDataListLocal);
    await pickListMainDataListLocalBox.put('myListKey', pickListMainDataListLocalString);
  }
}
