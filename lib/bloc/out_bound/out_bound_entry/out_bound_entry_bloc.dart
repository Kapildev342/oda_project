// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:oda/local_database/pick_list_box/pick_list.dart';

// Project imports:
import 'package:oda/local_database/trip_box/trip_list.dart';
import 'package:oda/repository/api_end_points.dart';
import 'package:oda/repository_model/trip_list/trip_list_time_line_info_model.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/variables.dart';

part 'out_bound_entry_event.dart';
part 'out_bound_entry_state.dart';

class OutBoundEntryBloc extends Bloc<OutBoundEntryEvent, OutBoundEntryState> {
  bool searchBarEnabled = false;
  bool isAllSelected = false;
  int currentListIndex = 0;
  List<SoList> selectedSoList = [];
  String searchText = "";
  List<SoList> soListDummy = [];
  List<SoList> searchedSoList = [];
  Box<SoList> soListBox = Hive.box<SoList>('so_list');


  OutBoundEntryBloc() : super(OutBoundEntryLoading()) {
    on<OutBoundEntryInitialEvent>(outBoundEntryInitialFunction);
    on<OutBoundEntryTabChangingEvent>(outBoundEntryTabChangingFunction);
    on<OutBoundEntrySetStateEvent>(outBoundEntrySetStateFunction);
    on<OutBoundEntryFilterEvent>(outBoundEntryFilterFunction);
    on<OutBoundEntryTimeLineEvent>(outBoundEntryTimeLineFunction);
  }

  FutureOr<void> outBoundEntryInitialFunction(OutBoundEntryInitialEvent event, Emitter<OutBoundEntryState> emit) async {
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
    emit(OutBoundEntryLoaded());
  }

  FutureOr<void> outBoundEntryTabChangingFunction(OutBoundEntryTabChangingEvent event, Emitter<OutBoundEntryState> emit) async {
    emit(OutBoundEntryDummy());
    emit(OutBoundEntryLoaded());
  }

  FutureOr<void> outBoundEntrySetStateFunction(OutBoundEntrySetStateEvent event, Emitter<OutBoundEntryState> emit) async {
    emit(OutBoundEntryDummy());
    event.stillLoading ? emit(OutBoundEntryLoading()) : emit(OutBoundEntryLoaded());
  }

  FutureOr<void> outBoundEntryFilterFunction(OutBoundEntryFilterEvent event, Emitter<OutBoundEntryState> emit) async {
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
    emit(OutBoundEntryLoading());
    emit(OutBoundEntryLoaded());
  }

  FutureOr<void> outBoundEntryTimeLineFunction(OutBoundEntryTimeLineEvent event, Emitter<OutBoundEntryState> emit) async {
    await getIt<Variables>().repoImpl.getSorterTripListTimeLineInfo(query: {"trip_id": getIt<Variables>().generalVariables.tripListMainIdData.tripId}, method: "post", module: ApiEndPoints().loaderModule).then((value) {
      if (value != null) {
        if (value["status"] == "1") {
          TripListTimeLineApiModel tripListTimeLineApiModel =TripListTimeLineApiModel.fromJson(value);
          getIt<Variables>().generalVariables.timelineInfo.clear();
          getIt<Variables>().generalVariables.timelineInfo.addAll(tripListTimeLineApiModel.response.timelineInfo);
          emit(OutBoundEntryFailure());
          emit(OutBoundEntryLoaded());
        }
      }
    });
  }
}
