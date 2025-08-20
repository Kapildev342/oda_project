// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oda/local_database/pick_list_box/pick_list.dart';

// Project imports:
import 'package:oda/local_database/trip_box/trip_list.dart';
import 'package:oda/repository/api_end_points.dart';
import 'package:oda/repository_model/trip_list/trip_list_time_line_info_model.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/variables.dart';

part 'trip_list_entry_event.dart';
part 'trip_list_entry_state.dart';

class TripListEntryBloc extends Bloc<TripListEntryEvent, TripListEntryState> {
  bool searchBarEnabled = false;
  bool isAllSelected = false;
  int currentListIndex = 0;
  List<SoList> selectedSoList = [];
  String searchText = "";
  List<SoList> soListDummy = [];
  List<SoList> searchedSoList = [];
  Box<SoList> soListBox = Hive.box<SoList>('so_list');

  TripListEntryBloc() : super(TripListEntryLoading()) {
    on<TripListEntryInitialEvent>(tripListEntryInitialFunction);
    on<TripListEntryTabChangingEvent>(tripListEntryTabChangingFunction);
    on<TripListEntrySetStateEvent>(tripListEntrySetStateFunction);
    on<TripListEntryFilterEvent>(tripListEntryFilterFunction);
    on<TripListEntryTimeLineEvent>(tripListEntryTimeLineFunction);
  }

  FutureOr<void> tripListEntryInitialFunction(TripListEntryInitialEvent event, Emitter<TripListEntryState> emit) async {
    currentListIndex = 0;
    isAllSelected = false;
    selectedSoList.clear();
    searchBarEnabled = false;
    isAllSelected = false;
    searchedSoList.clear();
    searchText = "";
    getIt<Variables>().generalVariables.filters.clear();
    getIt<Variables>().generalVariables.selectedFilters.clear();
    getIt<Variables>().generalVariables.selectedFiltersName.clear();
    getIt<Variables>().generalVariables.filterSearchController.clear();
    getIt<Variables>().generalVariables.searchedResultFilterOption.clear();
    getIt<Variables>().generalVariables.filterSelectedMainIndex = 0;
    for (int i = 0; i < soListBox.values.toList().length; i++) {
      soListBox.values.toList()[i].isSelected = false;
    }
    searchedSoList =
        soListBox.values.toList().where((element) => element.tripId == getIt<Variables>().generalVariables.tripListMainIdData.tripId).toList();
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
        "options": List.generate(searchedSoList.length, (i) => {"id": searchedSoList[i].soType, "label": searchedSoList[i].soType})
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
        "options": List.generate(searchedSoList.length, (i) => {"id": searchedSoList[i].soStatus, "label": searchedSoList[i].soStatus})
            .map((map) => jsonEncode(map))
            .toSet()
            .map((str) => jsonDecode(str))
            .toList()
      }
    ].map((x) => Filter.fromJson(x)));
    emit(TripListEntryLoaded());
  }

  FutureOr<void> tripListEntryTabChangingFunction(TripListEntryTabChangingEvent event, Emitter<TripListEntryState> emit) async {
    emit(TripListEntryDummy());
    emit(TripListEntryLoaded());
  }

  FutureOr<void> tripListEntrySetStateFunction(TripListEntrySetStateEvent event, Emitter<TripListEntryState> emit) async {
    emit(TripListEntryDummy());
    event.stillLoading ? emit(TripListEntryLoading()) : emit(TripListEntryLoaded());
  }

  FutureOr<void> tripListEntryFilterFunction(TripListEntryFilterEvent event, Emitter<TripListEntryState> emit) async {
    if (getIt<Variables>().generalVariables.currentBackGround.symbol == "B") {
      searchedSoList = soListBox.values.toList().where((element) => element.tripId == getIt<Variables>().generalVariables.tripListMainIdData.tripId).toList();
    } else {
      searchedSoList =
          soListBox.values.toList().where((element) => element.tripId == getIt<Variables>().generalVariables.tripListMainIdData.tripId && element.soItemType == getIt<Variables>().generalVariables.currentBackGround.symbol).toList();
    }
    searchedSoList = searchedSoList
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
    emit(TripListEntryLoading());
    emit(TripListEntryLoaded());
  }

  FutureOr<void> tripListEntryTimeLineFunction(TripListEntryTimeLineEvent event, Emitter<TripListEntryState> emit) async {
    await getIt<Variables>().repoImpl.getSorterTripListTimeLineInfo(query: {"trip_id": getIt<Variables>().generalVariables.tripListMainIdData.tripId}, method: "post", module: ApiEndPoints().sorterModule).then((value) {
      if (value != null) {
        if (value["status"] == "1") {
          TripListTimeLineApiModel tripListTimeLineApiModel =TripListTimeLineApiModel.fromJson(value);
          getIt<Variables>().generalVariables.timelineInfo.clear();
          getIt<Variables>().generalVariables.timelineInfo.addAll(tripListTimeLineApiModel.response.timelineInfo);
          emit(TripListEntryFailure());
          emit(TripListEntryLoaded());
        }
      }
    });
  }
}
