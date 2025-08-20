// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:oda/local_database/pick_list_box/pick_list.dart';

// Project imports:
import 'package:oda/local_database/trip_box/trip_list.dart';
import 'package:oda/repository/api_end_points.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/variables.dart';

part 'out_bound_event.dart';
part 'out_bound_state.dart';

class OutBoundBloc extends Bloc<OutBoundEvent, OutBoundState> {
  bool searchBarEnabled = false;
  int currentListIndex = 0;
  String searchText = "";
  List<TripList> tripListDummy = [];
  List<TripList> searchedTripList = [];
  /*Box<TripList>? tripListBox;
  Box<SoList>? soListBox;
  Box<ItemsList>? itemsListBox;
  Box<BatchesList>? batchesListBox;*/
  //List<HandledByForUpdateList> tripHandledByList=[];
  OutBoundBloc() : super(OutBoundLoading()) {
    on<OutBoundInitialEvent>(outBoundInitialFunction);
    on<OutBoundTabChangingEvent>(outBoundTabChangingFunction);
    on<OutBoundSetStateEvent>(outBoundSetStateFunction);
    on<OutBoundFilterEvent>(outBoundFilterFunction);
  }

  FutureOr<void> outBoundInitialFunction(OutBoundInitialEvent event, Emitter<OutBoundState> emit) async {
    event.isInitial ? emit(OutBoundLoading()) : emit(OutBoundTableLoading());
    List<Map<String, dynamic>> tripMainDataList = [];
    List<Map<String, dynamic>> optionsData = [];
    searchBarEnabled = false;
    searchText = "";
    currentListIndex = 0;
    getIt<Variables>().generalVariables.filters.clear();
    getIt<Variables>().generalVariables.selectedFilters.clear();
    getIt<Variables>().generalVariables.selectedFiltersName.clear();
    getIt<Variables>().generalVariables.filterSearchController.clear();
    getIt<Variables>().generalVariables.searchedResultFilterOption.clear();
    getIt<Variables>().generalVariables.filterSelectedMainIndex = 0;
    getIt<Variables>().generalVariables.tripListMainIdData = TripList.fromJson({});
    if (!getIt<Variables>().generalVariables.isNetworkOffline) {
      int i = 1;
      do {
        await getIt<Variables>()
            .repoImpl
            .getSorterTripListData(query: {"page": i}, method: "post", module: ApiEndPoints().loaderModule).onError((error, stackTrace) {
          tripMainDataList = [];
          emit(OutBoundError(message: error.toString()));
        }).then((value) {
          if (value != null) {
            if (value["status"] == "1") {
              optionsData = List<Map<String, dynamic>>.from((value["response"]["triplist"] ?? []).map((x) => x as Map<String, dynamic>));
              tripMainDataList.addAll(optionsData);
            }
          }
        });
        i++;
      } while (optionsData.isNotEmpty);
    }
    /*List<HandledByForUpdateList> tripData=[];
    for(int i=0;i<tripMainDataList.length;i++){
     tripData.addAll(List.from(tripMainDataList[i]["handled_by"].map((x)=>HandledByForUpdateList.fromJson(x))));
    }
    Map<String, List<HandledByForUpdateList>> tripDataValue = groupBy(tripData, (HandledByForUpdateList data) => data.code);
    for(int i=0;i<tripDataValue.values.toList().length;i++){
      num sum=0;
      for(int j=0;j<tripDataValue.values.toList()[i].length;j++){
        sum = sum+ num.parse(tripDataValue.values.toList()[i][j].updatedItems);
      }
      tripDataValue.values.toList()[i][0].updatedItems=sum.toString();
      tripHandledByList.add(tripDataValue.values.toList()[i][0]);
    }*/
    await initDBFunction(tripMainDataList: tripMainDataList);
    emit(OutBoundLoaded());
  }

  FutureOr<void> outBoundTabChangingFunction(OutBoundTabChangingEvent event, Emitter<OutBoundState> emit) async {
    emit(OutBoundDummy());
    emit(OutBoundLoaded());
  }

  FutureOr<void> outBoundSetStateFunction(OutBoundSetStateEvent event, Emitter<OutBoundState> emit) async {
    emit(OutBoundDummy());
    event.stillLoading ? emit(OutBoundLoading()) : emit(OutBoundLoaded());
  }

  FutureOr<void> outBoundFilterFunction(OutBoundFilterEvent event, Emitter<OutBoundState> emit) async {
    Box<TripList> tripListBox = await Hive.openBox<TripList>('trip_list');
    if (getIt<Variables>().generalVariables.currentBackGround.symbol == "B") {
      searchedTripList = tripListBox.values.toList();
    } else {
      searchedTripList = tripListBox.values
          .toList()
          .where((element) => element.tripItemType == getIt<Variables>().generalVariables.currentBackGround.symbol)
          .toList();
    }
    searchedTripList = searchedTripList
        .where((element) =>
            element.tripNum.toLowerCase().contains(searchText.toLowerCase()) ||
            element.tripVehicle.toLowerCase().contains(searchText.toLowerCase()) ||
            element.tripRoute.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    List<TripList> filteredList = [];
    filteredList.addAll(searchedTripList);
    for (int i = 0; i < getIt<Variables>().generalVariables.selectedFilters.length; i++) {
      switch (getIt<Variables>().generalVariables.selectedFilters[i].type) {
        case "trip_num":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.tripNum == item2))
                .toList();
          }
        case "trip_vehicle":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.tripVehicle == item2))
                .toList();
          }
        case "trip_route":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.tripRoute == item2))
                .toList();
          }
        case "status":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.tripStatus == item2))
                .toList();
          }
        case "picklist_type":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.deliveryArea == item2))
                .toList();
          }
        case "business_dt":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>()
                    .generalVariables
                    .selectedFilters[i]
                    .options
                    .any((item2) => DateFormat('dd/MM/yyyy').format(DateTime.parse(item1.businessDate)) == item2))
                .toList();
          }
        default:
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.tripNum == item2))
                .toList();
          }
      }
    }
    searchedTripList.clear();
    searchedTripList.addAll(filteredList);
    emit(OutBoundLoading());
    emit(OutBoundLoaded());
  }

  initDBFunction({required List<Map<String, dynamic>> tripMainDataList}) async {
    if (getIt<Variables>().generalVariables.isNetworkOffline) {
      Box<TripList> tripListBox = await Hive.openBox<TripList>('trip_list');
      tripListBox = await Hive.openBox<TripList>('trip_list');
      searchedTripList.clear();
      searchedTripList.addAll(tripListBox.values.toList());
      getIt<Variables>().generalVariables.filters = List<Filter>.from([
        {
          "type": "trip_num",
          "label": getIt<Variables>().generalVariables.currentLanguage.tripId,
          "selection": "multiple",
          "get_options": false,
          "options": List.generate(searchedTripList.length, (i) => {"id": searchedTripList[i].tripNum, "label": searchedTripList[i].tripNum})
              .map((map) => jsonEncode(map))
              .toSet()
              .map((str) => jsonDecode(str))
              .toList()
        },
        {
          "type": "trip_vehicle",
          "label": getIt<Variables>().generalVariables.currentLanguage.vehicleNo,
          "selection": "multiple",
          "get_options": false,
          "options": List.generate(searchedTripList.length, (i) => {"id": searchedTripList[i].tripVehicle, "label": searchedTripList[i].tripVehicle})
              .map((map) => jsonEncode(map))
              .toSet()
              .map((str) => jsonDecode(str))
              .toList()
        },
        {
          "type": "trip_route",
          "label": getIt<Variables>().generalVariables.currentLanguage.route,
          "selection": "multiple",
          "get_options": false,
          "options": List.generate(searchedTripList.length, (i) => {"id": searchedTripList[i].tripRoute, "label": searchedTripList[i].tripRoute})
              .map((map) => jsonEncode(map))
              .toSet()
              .map((str) => jsonDecode(str))
              .toList()
        },
        {
          "type": "status",
          "label": getIt<Variables>().generalVariables.currentLanguage.status,
          "selection": "multiple",
          "get_options": false,
          "options": List.generate(searchedTripList.length, (i) => {"id": searchedTripList[i].tripStatus, "label": searchedTripList[i].tripStatus})
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
          "options":
              List.generate(searchedTripList.length, (i) => {"id": searchedTripList[i].deliveryArea, "label": searchedTripList[i].deliveryArea})
                  .map((map) => jsonEncode(map))
                  .toSet()
                  .map((str) => jsonDecode(str))
                  .toList()
        },
        {
          "type": "business_dt",
          "label": getIt<Variables>().generalVariables.currentLanguage.businessDate,
          "selection": "single_date",
          "get_options": false,
          "options": []
        }
      ].map((x) => Filter.fromJson(x)));
    } else {
      Map<String, dynamic> countData = {};
      await Hive.box<TripList>('trip_list').clear();
      await Hive.box<SoList>('so_list').clear();
      await Hive.box<ItemsList>('items_list').clear();
      await Hive.box<BatchesList>('batches_list').clear();
      await Hive.box<PartialItemsList>('partial_items_list').clear();
      Box<TripList> tripListBox = Hive.box<TripList>('trip_list');
      Box<SoList> soListBox = Hive.box<SoList>('so_list');
      Box<ItemsList> itemsListBox = Hive.box<ItemsList>('items_list');
      Box<BatchesList> batchesListBox = Hive.box<BatchesList>('batches_list');
      Map<String, List<Map<String, dynamic>>> tripDataList = groupBy(tripMainDataList, (Map<String, dynamic> data) => data["trip_id"]);
      List<List<Map<String, dynamic>>> tripDataListValues = tripDataList.values.toList();
      List<Map<String, dynamic>> tripListData =[];
      for(int i=0; i<tripDataListValues.length;i++){
        bool isAdded=false;
        for(int j=0; j<tripDataListValues[i].length;j++){
          if(!isAdded){
          if(tripDataListValues[i][j]["session_timestamp"]!=""){
            tripListData.add(tripDataListValues[i][j]);
            isAdded=true;
          }}
        }
        if(!isAdded){
          tripListData.add(tripDataListValues[i][0]);
        }
      }
      for (int i = 0; i < tripDataListValues.length; i++) {
        countData = {};
        for (int j = 0; j < tripDataListValues[i].length; j++) {
          for (int k = 0; k < tripDataListValues[i][j]["handled_by"].length; k++) {
            if (countData.containsKey("${tripDataListValues[i][j]["handled_by"][k]["code"]}")) {
              countData["${tripDataListValues[i][j]["handled_by"][k]["code"]}"] =
                  countData["${tripDataListValues[i][j]["handled_by"][k]["code"]}"] + tripDataListValues[i][j]["handled_by"][k]["updated_items"];
            } else {
              countData["${tripDataListValues[i][j]["handled_by"][k]["code"]}"] = tripDataListValues[i][j]["handled_by"][k]["updated_items"];
            }
          }
        }
        List<Map<String, dynamic>> tripHandledBy = [];
        for (int l = 0; l < countData.keys.length; l++) {
          Map<String, dynamic> matchedUser =
              getIt<Variables>().generalVariables.userData.usersList.singleWhere((element) => element.code == countData.keys.toList()[l]).toJson();
          matchedUser["updated_items"] = countData[countData.keys.toList()[l]];
          tripHandledBy.add(matchedUser);
        }
        tripListData[i]["trip_handled_by"] = tripHandledBy;
      }
      tripListBox.addAll(List<TripList>.from(tripListData.map((x) => TripList.fromJson(x))));
      Map<String, List<Map<String, dynamic>>> soDataList = groupBy(tripMainDataList, (Map<String, dynamic> data) => data["so_id"]);
      List<List<Map<String, dynamic>>> soDataListValues = soDataList.values.toList();
      List<Map<String, dynamic>> soListData = List.generate(soDataListValues.length, (i) => soDataListValues[i][0]);
      for (int i = 0; i < soDataListValues.length; i++) {
        countData = {};
        for (int j = 0; j < soDataListValues[i].length; j++) {
          for (int k = 0; k < soDataListValues[i][j]["handled_by"].length; k++) {
            if (countData.containsKey("${soDataListValues[i][j]["handled_by"][k]["code"]}")) {
              countData["${soDataListValues[i][j]["handled_by"][k]["code"]}"] =
                  countData["${soDataListValues[i][j]["handled_by"][k]["code"]}"] + soDataListValues[i][j]["handled_by"][k]["updated_items"];
            } else {
              countData["${soDataListValues[i][j]["handled_by"][k]["code"]}"] = soDataListValues[i][j]["handled_by"][k]["updated_items"];
            }
          }
        }
        List<Map<String, dynamic>> soHandledBy = [];
        for (int l = 0; l < countData.keys.length; l++) {
          Map<String, dynamic> matchedUser =
              getIt<Variables>().generalVariables.userData.usersList.singleWhere((element) => element.code == countData.keys.toList()[l]).toJson();
          matchedUser["updated_items"] = countData[countData.keys.toList()[l]];
          soHandledBy.add(matchedUser);
        }
        soListData[i]["so_handledBy"] = soHandledBy;
        soListData[i]["soNoOfLoadedItems"] = (List<double>.generate(soHandledBy.length, (i) => soHandledBy[i]["updated_items"].toDouble()))
            .fold<double>(0, (a, b) => a + b)
            .toString();
      }
      soListBox.addAll(List<SoList>.from(soListData.map((x) => SoList.fromJson(x))));
      Map<String, List<Map<String, dynamic>>> itemsDataList = groupBy(tripMainDataList, (Map<String, dynamic> data) => data["line_item_id"]);
      List<List<Map<String, dynamic>>> itemsDataListValues = itemsDataList.values.toList();
      List<Map<String, dynamic>> itemsListData = List.generate(itemsDataListValues.length, (i) => itemsDataListValues[i][0]);
      for (int i = 0; i < itemsDataListValues.length; i++) {
        countData = {};
        for (int j = 0; j < itemsDataListValues[i].length; j++) {
          for (int k = 0; k < itemsDataListValues[i][j]["handled_by"].length; k++) {
            if (countData.containsKey("${itemsDataListValues[i][j]["handled_by"][k]["code"]}")) {
              countData["${itemsDataListValues[i][j]["handled_by"][k]["code"]}"] =
                  countData["${itemsDataListValues[i][j]["handled_by"][k]["code"]}"] + itemsDataListValues[i][j]["handled_by"][k]["updated_items"];
            } else {
              countData["${itemsDataListValues[i][j]["handled_by"][k]["code"]}"] = itemsDataListValues[i][j]["handled_by"][k]["updated_items"];
            }
          }
        }
        List<Map<String, dynamic>> itemHandledBy = [];
        for (int l = 0; l < countData.keys.length; l++) {
          Map<String, dynamic> matchedUser =
              getIt<Variables>().generalVariables.userData.usersList.singleWhere((element) => element.code == countData.keys.toList()[l]).toJson();
          matchedUser["updated_items"] = countData[countData.keys.toList()[l]];
          itemHandledBy.add(matchedUser);
        }
        itemsListData[i]["handled_by"] = itemHandledBy;
      }
      itemsListBox.addAll(List<ItemsList>.from(itemsListData.map((x) => ItemsList.fromJson(x))));
      batchesListBox.addAll(List<BatchesList>.from(tripMainDataList.map((x) => BatchesList.fromJson(x))));
      searchedTripList.clear();
      searchedTripList.addAll(tripListBox.values.toList());
      getIt<Variables>().generalVariables.filters = List<Filter>.from([
        {
          "type": "trip_num",
          "label": getIt<Variables>().generalVariables.currentLanguage.tripId,
          "selection": "multiple",
          "get_options": false,
          "options": List.generate(searchedTripList.length, (i) => {"id": searchedTripList[i].tripNum, "label": searchedTripList[i].tripNum})
              .map((map) => jsonEncode(map))
              .toSet()
              .map((str) => jsonDecode(str))
              .toList()
        },
        {
          "type": "trip_vehicle",
          "label": getIt<Variables>().generalVariables.currentLanguage.vehicleNo,
          "selection": "multiple",
          "get_options": false,
          "options": List.generate(searchedTripList.length, (i) => {"id": searchedTripList[i].tripVehicle, "label": searchedTripList[i].tripVehicle})
              .map((map) => jsonEncode(map))
              .toSet()
              .map((str) => jsonDecode(str))
              .toList()
        },
        {
          "type": "trip_route",
          "label": getIt<Variables>().generalVariables.currentLanguage.route,
          "selection": "multiple",
          "get_options": false,
          "options": List.generate(searchedTripList.length, (i) => {"id": searchedTripList[i].tripRoute, "label": searchedTripList[i].tripRoute})
              .map((map) => jsonEncode(map))
              .toSet()
              .map((str) => jsonDecode(str))
              .toList()
        },
        {
          "type": "status",
          "label": getIt<Variables>().generalVariables.currentLanguage.status,
          "selection": "multiple",
          "get_options": false,
          "options": List.generate(searchedTripList.length, (i) => {"id": searchedTripList[i].tripStatus, "label": searchedTripList[i].tripStatus})
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
          "options":
              List.generate(searchedTripList.length, (i) => {"id": searchedTripList[i].deliveryArea, "label": searchedTripList[i].deliveryArea})
                  .map((map) => jsonEncode(map))
                  .toSet()
                  .map((str) => jsonDecode(str))
                  .toList()
        },
        {
          "type": "business_dt",
          "label": getIt<Variables>().generalVariables.currentLanguage.businessDate,
          "selection": "single_date",
          "get_options": false,
          "options": []
        }
      ].map((x) => Filter.fromJson(x)));
      /*for (int i = 0; i < searchedTripList.length; i++) {
        await getIt<Variables>()
            .repoImpl
            .getSorterTripListInfo(query: {"trip_id": searchedTripList[i].tripId}, method: "post", module: ApiEndPoints().sorterModule).then((value) {
          if (value != null) {
            if (value["status"] == "1") {
              searchedTripList[i].sessionInfo = SessionInfo(
                isOpened: value["response"]["session_info"]["is_opened"],
                id: value["response"]["session_info"]["id"],
                pending: value["response"]["session_info"]["pending"].toString(),
                updated: value["response"]["session_info"]["updated"].toString(),
                partial: value["response"]["session_info"]["partial"].toString(),
                unavailable: value["response"]["session_info"]["unavailable"].toString(),
                sessionStartTimestamp: value["response"]["session_info"]["session_start_timestamp"].toString(),
                timeSpendSeconds: value["response"]["session_info"]["time_spend_seconds"].toString(),
              );
              searchedTripList[i].unavailableReasons =
                  List<UnavailableReason>.from((value["response"]["unavailable_reasons"] ?? []).map((x) => UnavailableReason.fromJson(x)));
            }
          }
        });
        int itemKey = tripListBox.keys.firstWhere((k) => tripListBox.get(k)?.tripId == searchedTripList[i].tripId);
        await tripListBox.put(itemKey, searchedTripList[i]);
      }*/
    }
  }
}
