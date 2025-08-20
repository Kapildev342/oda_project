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
import 'package:oda/repository/api_end_points.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/variables.dart';

part 'warehouse_pickup_event.dart';
part 'warehouse_pickup_state.dart';

class WarehousePickupBloc extends Bloc<WarehousePickupEvent, WarehousePickupState> {
  bool searchBarEnabled = false;
  String searchText = "";
  List<SoList> soListEmpty = [];
  List<SoList> searchedSoList = [];
  List<Map<String, dynamic>> offlineCsvData = [];

  WarehousePickupBloc() : super(WarehousePickupLoading()) {
    on<WarehousePickupInitialEvent>(warehouseInitialFunction);
    on<WarehousePickupSetStateEvent>(warehouseSetStateFunction);
    on<WarehousePickupTabChangingEvent>(warehouseTabChangingFunction);
    on<WarehousePickupFilterEvent>(warehouseFilterFunction);
  }

  FutureOr<void> warehouseInitialFunction(WarehousePickupInitialEvent event, Emitter<WarehousePickupState> emit) async {
    emit(WarehousePickupLoading());
    searchBarEnabled = false;
    searchText = "";
    getIt<Variables>().generalVariables.filters.clear();
    getIt<Variables>().generalVariables.selectedFilters.clear();
    getIt<Variables>().generalVariables.selectedFiltersName.clear();
    getIt<Variables>().generalVariables.filterSearchController.clear();
    getIt<Variables>().generalVariables.searchedResultFilterOption.clear();
    getIt<Variables>().generalVariables.filterSelectedMainIndex = 0;
    List<Map<String, dynamic>> warehousePickupMainDataList = [];
    List<Map<String, dynamic>> optionsData = [];
    if (!getIt<Variables>().generalVariables.isNetworkOffline) {
      int i = 1;
      do {
        await getIt<Variables>().repoImpl.getSorterTripListData(
            query: {"trip_classification": "pickup", "page": i}, method: "post", module: ApiEndPoints().loaderModule).onError((error, stackTrace) {
          warehousePickupMainDataList = [];
          emit(WarehousePickupError(message: error.toString()));
        }).then((value) {
          if (value != null) {
            if (value["status"] == "1") {
              optionsData = List<Map<String, dynamic>>.from((value["response"]["triplist"] ?? []).map((x) => x as Map<String, dynamic>));
              warehousePickupMainDataList.addAll(optionsData);
            }
          }
        });
        i++;
      } while (optionsData.isNotEmpty);
    }
    await initDbFunction(warehousePickupMainDataList: warehousePickupMainDataList);
    emit(WarehousePickupDummy());
    emit(WarehousePickupLoaded());
  }

  FutureOr<void> warehouseTabChangingFunction(WarehousePickupTabChangingEvent event, Emitter<WarehousePickupState> emit) async {
    emit(WarehousePickupDummy());
    emit(WarehousePickupLoaded());
  }

  FutureOr<void> warehouseSetStateFunction(WarehousePickupSetStateEvent event, Emitter<WarehousePickupState> emit) async {
    emit(WarehousePickupDummy());
    event.stillLoading ? emit(WarehousePickupLoading()) : emit(WarehousePickupLoaded());
  }

  FutureOr<void> warehouseFilterFunction(WarehousePickupFilterEvent event, Emitter<WarehousePickupState> emit) async {
    Box<SoList> soListBox = await Hive.openBox<SoList>('so_list_pickup');
    searchedSoList = soListBox.values
        .toList()
        .where((element) =>
            element.soNum.toLowerCase().contains(searchText.toLowerCase()) || element.soCustomerName.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    List<SoList> filteredList = [];
    filteredList.addAll(searchedSoList);
    for (int i = 0; i < getIt<Variables>().generalVariables.selectedFilters.length; i++) {
      switch (getIt<Variables>().generalVariables.selectedFilters[i].type) {
        case "so_num":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.soNum == item2))
                .toList();
          }
        case "customer_name":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.soCustomerName == item2))
                .toList();
          }
        case "item_type":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.soType == item2))
                .toList();
          }
        case "status":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.soStatus == item2))
                .toList();
          }
        default:
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.soNum == item2))
                .toList();
          }
      }
    }
    searchedSoList.clear();
    searchedSoList.addAll(filteredList);
    emit(WarehousePickupLoading());
    emit(WarehousePickupLoaded());
  }

  initDbFunction({required List<Map<String, dynamic>> warehousePickupMainDataList}) async {
    if (getIt<Variables>().generalVariables.isNetworkOffline) {
      Box<SoList> soListBox = await Hive.openBox<SoList>('so_list_pickup');
      searchedSoList.clear();
      searchedSoList.addAll(soListBox.values.toList());
      getIt<Variables>().generalVariables.filters = List<Filter>.from([
        {
          "type": "so_num",
          "label": getIt<Variables>().generalVariables.currentLanguage.soNum,
          "selection": "multiple",
          "get_options": false,
          //"options": List.generate(searchedSoList.length, (i) => {"id": searchedSoList[i].soNum, "label": searchedSoList[i].soNum})
          "options": List.generate(searchedSoList.length, (i) => {"id": searchedSoList[i].soNum, "label": searchedSoList[i].soNum})
              .map((map) => jsonEncode(map))
              .toSet()
              .map((str) => jsonDecode(str))
              .toList()
        },
        {
          "type": "customer_name",
          "label": getIt<Variables>().generalVariables.currentLanguage.customers,
          "selection": "multiple",
          "get_options": false,
          "options": List.generate(searchedSoList.length, (i) => {"id": searchedSoList[i].soCustomerName, "label": searchedSoList[i].soCustomerName})
              .map((map) => jsonEncode(map))
              .toSet()
              .map((str) => jsonDecode(str))
              .toList()
        },
        {
          "type": "item_type",
          "label": getIt<Variables>().generalVariables.currentLanguage.itemType,
          "selection": "multiple",
          "get_options": false,
          "options": List.generate(
              searchedSoList.length,
              (i) => {
                    "id": searchedSoList[i].soType,
                    "label": searchedSoList[i].soType.toLowerCase() == "store pickup"
                        ? getIt<Variables>().generalVariables.currentLanguage.storePickup
                        : searchedSoList[i].soType
                  }).map((map) => jsonEncode(map)).toSet().map((str) => jsonDecode(str)).toList()
        },
        {
          "type": "status",
          "label": getIt<Variables>().generalVariables.currentLanguage.status,
          "selection": "multiple",
          "get_options": false,
          "options": List.generate(
              searchedSoList.length,
              (i) => {
                    "id": searchedSoList[i].soStatus,
                    "label": searchedSoList[i].soStatus.toLowerCase() == "pending"
                        ? getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase()
                        : searchedSoList[i].soStatus.toLowerCase() == "partial"
                            ? getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase()
                            : searchedSoList[i].soStatus.toLowerCase() == "loaded"
                                ? getIt<Variables>().generalVariables.currentLanguage.loaded.toUpperCase()
                                : searchedSoList[i].soStatus.toLowerCase() == "completed"
                                    ? getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase()
                                    : searchedSoList[i].soStatus.toUpperCase()
                  }).map((map) => jsonEncode(map)).toSet().map((str) => jsonDecode(str)).toList()
        }
      ].map((x) => Filter.fromJson(x)));
    } else {
      ///here we are getting data from api call, but actually we have to get data from csv file if internet not available
      ///if internet is thr, don't do anything.
      ///get function for converting csv to json & vice versa from common functions dart file
      Box<TripList> tripListBoxSample = Hive.box<TripList>('trip_list_pickup');
      if (tripListBoxSample.values.toList().isEmpty) {
        Map<String, dynamic> countData = {};
        await Hive.box<TripList>('trip_list_pickup').clear();
        await Hive.box<SoList>('so_list_pickup').clear();
        await Hive.box<ItemsList>('items_list_pickup').clear();
        await Hive.box<BatchesList>('batches_list_pickup').clear();
        await Hive.box<InvoiceData>('invoice_data_list_pickup').clear();
        Box<TripList> tripListBox = Hive.box<TripList>('trip_list_pickup');
        Box<SoList> soListBox = Hive.box<SoList>('so_list_pickup');
        Box<ItemsList> itemsListBox = Hive.box<ItemsList>('items_list_pickup');
        Box<BatchesList> batchesListBox = Hive.box<BatchesList>('batches_list_pickup');
        Box<InvoiceData> invoiceListBox = Hive.box<InvoiceData>('invoice_data_list_pickup');
        Map<String, List<Map<String, dynamic>>> tripDataList = groupBy(warehousePickupMainDataList, (Map<String, dynamic> data) => data["trip_id"]);
        List<List<Map<String, dynamic>>> tripDataListValues = tripDataList.values.toList();
        List<Map<String, dynamic>> tripListData = [];
        for (int i = 0; i < tripDataListValues.length; i++) {
          bool isAdded = false;
          for (int j = 0; j < tripDataListValues[i].length; j++) {
            if (!isAdded) {
              if (tripDataListValues[i][j]["session_timestamp"] != "") {
                tripListData.add(tripDataListValues[i][j]);
                isAdded = true;
              }
            }
          }
          if (!isAdded) {
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
        Map<String, List<Map<String, dynamic>>> soDataList = groupBy(warehousePickupMainDataList, (Map<String, dynamic> data) => data["so_id"]);
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
          soListData[i]["soNoOfSortedItems"] = (List<double>.generate(soHandledBy.length, (i) => soHandledBy[i]["updated_items"].toDouble()))
              .fold<double>(0, (a, b) => a + b)
              .toString();
        }
        soListBox.addAll(List<SoList>.from(soListData.map((x) => SoList.fromJson(x))));
        Map<String, List<Map<String, dynamic>>> invoiceDataList = groupBy(warehousePickupMainDataList, (Map<String, dynamic> data) => data["invoice_id"]);
        List<List<Map<String, dynamic>>> invoiceDataListValues = invoiceDataList.values.toList();
        List<Map<String, dynamic>> invoiceListData = List.generate(invoiceDataListValues.length, (i) => invoiceDataListValues[i][0]);
        invoiceListBox.addAll(List<InvoiceData>.from(invoiceListData.map((x) => InvoiceData.fromJson(x))));
        Map<String, List<Map<String, dynamic>>> itemsDataList =
            groupBy(warehousePickupMainDataList, (Map<String, dynamic> data) => data["line_item_id"]);
        List<List<Map<String, dynamic>>> itemsDataListValues = itemsDataList.values.toList();
        for (int i = 0; i < itemsDataListValues.length; i++) {
          List<String> statusListData = List.generate(itemsDataListValues[i].length, (j) => itemsDataListValues[i][j]["item_picking_status"]);
          String? differentOne = await findOddOne(list: statusListData);
          if (differentOne != null) {
            if (statusListData.any((item) => item != "Picked") == false) {
              for (int j = 0; j < itemsDataListValues[i].length; j++) {
                itemsDataListValues[i][j]["item_picking_status"] = differentOne;
              }
            }
          }
        }
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
        batchesListBox.addAll(List<BatchesList>.from(warehousePickupMainDataList.map((x) => BatchesList.fromJson(x))));
        searchedSoList.clear();
        searchedSoList.addAll(soListBox.values.toList());
        getIt<Variables>().generalVariables.filters = List<Filter>.from([
          {
            "type": "so_num",
            "label": getIt<Variables>().generalVariables.currentLanguage.soNum,
            "selection": "multiple",
            "get_options": false,
            //"options": List.generate(searchedSoList.length, (i) => {"id": searchedSoList[i].soNum, "label": searchedSoList[i].soNum})
            "options": List.generate(searchedSoList.length, (i) => {"id": searchedSoList[i].soNum, "label": searchedSoList[i].soNum})
                .map((map) => jsonEncode(map))
                .toSet()
                .map((str) => jsonDecode(str))
                .toList()
          },
          {
            "type": "customer_name",
            "label": getIt<Variables>().generalVariables.currentLanguage.customers,
            "selection": "multiple",
            "get_options": false,
            "options":
                List.generate(searchedSoList.length, (i) => {"id": searchedSoList[i].soCustomerName, "label": searchedSoList[i].soCustomerName})
                    .map((map) => jsonEncode(map))
                    .toSet()
                    .map((str) => jsonDecode(str))
                    .toList()
          },
          {
            "type": "item_type",
            "label": getIt<Variables>().generalVariables.currentLanguage.itemType,
            "selection": "multiple",
            "get_options": false,
            "options": List.generate(
                searchedSoList.length,
                    (i) => {
                  "id": searchedSoList[i].soType,
                  "label": searchedSoList[i].soType.toLowerCase() == "store pickup"
                      ? getIt<Variables>().generalVariables.currentLanguage.storePickup
                      : searchedSoList[i].soType
                }).map((map) => jsonEncode(map)).toSet().map((str) => jsonDecode(str)).toList()
          },
          {
            "type": "status",
            "label": getIt<Variables>().generalVariables.currentLanguage.status,
            "selection": "multiple",
            "get_options": false,
            "options": List.generate(
                searchedSoList.length,
                    (i) => {
                  "id": searchedSoList[i].soStatus,
                  "label": searchedSoList[i].soStatus.toLowerCase() == "pending"
                      ? getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase()
                      : searchedSoList[i].soStatus.toLowerCase() == "partial"
                      ? getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase()
                      : searchedSoList[i].soStatus.toLowerCase() == "loaded"
                      ? getIt<Variables>().generalVariables.currentLanguage.loaded.toUpperCase()
                      : searchedSoList[i].soStatus.toLowerCase() == "completed"
                      ? getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase()
                      : searchedSoList[i].soStatus.toUpperCase()
                }).map((map) => jsonEncode(map)).toSet().map((str) => jsonDecode(str)).toList()
          }
        ].map((x) => Filter.fromJson(x)));
      } else {
        Map<String, dynamic> countData = {};
        Box<TripList> tripListBox = Hive.box<TripList>('trip_list_pickup');
        Box<SoList> soListBox = Hive.box<SoList>('so_list_pickup');
        Box<ItemsList> itemsListBox = Hive.box<ItemsList>('items_list_pickup');
        Box<BatchesList> batchesListBox = Hive.box<BatchesList>('batches_list_pickup');
        Box<InvoiceData> invoiceListBox = Hive.box<InvoiceData>('invoice_data_list_pickup');
        List<Map<String, dynamic>> warehousePickupMainDataListReference = [];
        warehousePickupMainDataListReference.addAll(warehousePickupMainDataList);
        for (int i = 0; i < tripListBox.values.toList().length; i++) {
          warehousePickupMainDataList.removeWhere((e) => e["trip_id"] == tripListBox.values.toList()[i].tripId);
        }
        final idsToRemove = warehousePickupMainDataList.map((e) => e["trip_id"]).toSet();
        warehousePickupMainDataListReference.removeWhere((item) => idsToRemove.contains(item["trip_id"]));
        Map<String, List<Map<String, dynamic>>> tripDataList = groupBy(warehousePickupMainDataList, (Map<String, dynamic> data) => data["trip_id"]);
        List<List<Map<String, dynamic>>> tripDataListValues = tripDataList.values.toList();
        List<Map<String, dynamic>> tripListData = [];
        for (int i = 0; i < tripDataListValues.length; i++) {
          bool isAdded = false;
          for (int j = 0; j < tripDataListValues[i].length; j++) {
            if (!isAdded) {
              if (tripDataListValues[i][j]["session_timestamp"] != "") {
                tripListData.add(tripDataListValues[i][j]);
                isAdded = true;
              }
            }
          }
          if (!isAdded) {
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
        Map<String, List<Map<String, dynamic>>> soDataList = groupBy(warehousePickupMainDataList, (Map<String, dynamic> data) => data["so_id"]);
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
          soListData[i]["soNoOfSortedItems"] = (List<double>.generate(soHandledBy.length, (i) => soHandledBy[i]["updated_items"].toDouble()))
              .fold<double>(0, (a, b) => a + b)
              .toString();
        }
        soListBox.addAll(List<SoList>.from(soListData.map((x) => SoList.fromJson(x))));
        Map<String, List<Map<String, dynamic>>> invoiceDataList =
            groupBy(warehousePickupMainDataList, (Map<String, dynamic> data) => data["invoice_id"]);
        List<List<Map<String, dynamic>>> invoiceDataListValues = invoiceDataList.values.toList();
        List<Map<String, dynamic>> invoiceListData = List.generate(invoiceDataListValues.length, (i) => invoiceDataListValues[i][0]);
        invoiceListBox.addAll(List<InvoiceData>.from(invoiceListData.map((x) => InvoiceData.fromJson(x))));
        Map<String, List<Map<String, dynamic>>> itemsDataList = groupBy(warehousePickupMainDataList, (Map<String, dynamic> data) => data["line_item_id"]);
        List<List<Map<String, dynamic>>> itemsDataListValues = itemsDataList.values.toList();
        for (int i = 0; i < itemsDataListValues.length; i++) {
          List<String> statusListData = List.generate(itemsDataListValues[i].length, (j) => itemsDataListValues[i][j]["item_picking_status"]);
          String? differentOne = await findOddOne(list: statusListData);
          if (differentOne != null) {
            if (statusListData.any((item) => item != "Picked") == false) {
              for (int j = 0; j < itemsDataListValues[i].length; j++) {
                itemsDataListValues[i][j]["item_picking_status"] = differentOne;
              }
            }
          }
        }
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
        batchesListBox.addAll(List<BatchesList>.from(warehousePickupMainDataList.map((x) => BatchesList.fromJson(x))));
        Map<String, List<Map<String, dynamic>>> itemsDataListReference =
            groupBy(warehousePickupMainDataListReference, (Map<String, dynamic> data) => data["line_item_id"]);
        List<List<Map<String, dynamic>>> itemsDataListValuesReference = itemsDataListReference.values.toList();
        for (int i = 0; i < itemsDataListValuesReference.length; i++) {
          List<String> statusListData =
              List.generate(itemsDataListValuesReference[i].length, (j) => itemsDataListValuesReference[i][j]["item_picking_status"]);
          String? differentOne = await findOddOne(list: statusListData);
          if (differentOne != null) {
            if (statusListData.any((item) => item != "Picked") == false) {
              for (int j = 0; j < itemsDataListValuesReference[i].length; j++) {
                itemsDataListValuesReference[i][j]["item_picking_status"] = differentOne;
              }
            }
          }
        }
        List<Map<String, dynamic>> itemsDataListValuesReferenceCertain = List.generate(itemsDataListValuesReference.length, (i) => itemsDataListValuesReference[i][0]);
        for (var data in itemsDataListValuesReferenceCertain) {
          final match = itemsListBox.values.toList().firstWhere((item) => item.lineItemId == data["line_item_id"]);
          match.itemPickedStatus = data["item_picking_status"];
          match.save();
        }
        searchedSoList.clear();
        searchedSoList.addAll(soListBox.values.toList());
        getIt<Variables>().generalVariables.filters = List<Filter>.from([
          {
            "type": "so_num",
            "label": getIt<Variables>().generalVariables.currentLanguage.soNum,
            "selection": "multiple",
            "get_options": false,
            //"options": List.generate(searchedSoList.length, (i) => {"id": searchedSoList[i].soNum, "label": searchedSoList[i].soNum})
            "options": List.generate(searchedSoList.length, (i) => {"id": searchedSoList[i].soNum, "label": searchedSoList[i].soNum})
                .map((map) => jsonEncode(map))
                .toSet()
                .map((str) => jsonDecode(str))
                .toList()
          },
          {
            "type": "customer_name",
            "label": getIt<Variables>().generalVariables.currentLanguage.customers,
            "selection": "multiple",
            "get_options": false,
            "options":
                List.generate(searchedSoList.length, (i) => {"id": searchedSoList[i].soCustomerName, "label": searchedSoList[i].soCustomerName})
                    .map((map) => jsonEncode(map))
                    .toSet()
                    .map((str) => jsonDecode(str))
                    .toList()
          },
          {
            "type": "item_type",
            "label": getIt<Variables>().generalVariables.currentLanguage.itemType,
            "selection": "multiple",
            "get_options": false,
            "options": List.generate(
                searchedSoList.length,
                    (i) => {
                  "id": searchedSoList[i].soType,
                  "label": searchedSoList[i].soType.toLowerCase() == "store pickup"
                      ? getIt<Variables>().generalVariables.currentLanguage.storePickup
                      : searchedSoList[i].soType
                }).map((map) => jsonEncode(map)).toSet().map((str) => jsonDecode(str)).toList()
          },
          {
            "type": "status",
            "label": getIt<Variables>().generalVariables.currentLanguage.status,
            "selection": "multiple",
            "get_options": false,
            "options": List.generate(
                searchedSoList.length,
                    (i) => {
                  "id": searchedSoList[i].soStatus,
                  "label": searchedSoList[i].soStatus.toLowerCase() == "pending"
                      ? getIt<Variables>().generalVariables.currentLanguage.pending.toUpperCase()
                      : searchedSoList[i].soStatus.toLowerCase() == "partial"
                      ? getIt<Variables>().generalVariables.currentLanguage.partial.toUpperCase()
                      : searchedSoList[i].soStatus.toLowerCase() == "loaded"
                      ? getIt<Variables>().generalVariables.currentLanguage.loaded.toUpperCase()
                      : searchedSoList[i].soStatus.toLowerCase() == "completed"
                      ? getIt<Variables>().generalVariables.currentLanguage.completed.toUpperCase()
                      : searchedSoList[i].soStatus.toUpperCase()
                }).map((map) => jsonEncode(map)).toSet().map((str) => jsonDecode(str)).toList()
          }
        ].map((x) => Filter.fromJson(x)));
      }
    }
  }

  Future<String?> findOddOne({required List<String> list}) async {
    Map<String, int> frequency = {};

    for (var item in list) {
      frequency[item] = (frequency[item] ?? 0) + 1;
    }

    // Find the key (value) with count 1
    for (var entry in frequency.entries) {
      if (entry.value == 1) {
        return entry.key;
      }
    }

    return null; // No odd one found
  }
}
