// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oda/local_database/pick_list_box/pick_list.dart';
import 'package:oda/repository/api_end_points.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/variables.dart';

// Project imports:
import 'package:oda/screens/ro_trip_list/ro_trip_list_screen.dart';

part 'ro_trip_list_main_event.dart';
part 'ro_trip_list_main_state.dart';

class RoTripListMainBloc extends Bloc<RoTripListMainEvent, RoTripListMainState> {
  bool searchBarEnabled = false;
  List<RoTripList> searchedRoTripList = [];
  List<RoTripList> searchedTempRoTripList = [];
  List<RoTripList> tripListDummy = [];
  String searchText = "";

  RoTripListMainBloc() : super(RoTripListMainLoading()) {
    on<RoTripListMainInitialEvent>(roTripListMainInitialFunction);
    on<RoTripListMainTabChangingEvent>(roTripListMainTabChangingFunction);
    on<RoTripListMainSetStateEvent>(roTripListMainSetStateFunction);
    on<RoTripListMainFilterEvent>(roTripListMainFilterFunction);
  }

  Future<FutureOr<void>> roTripListMainInitialFunction(RoTripListMainInitialEvent event, Emitter<RoTripListMainState> emit) async {
    emit(RoTripListMainLoading());
    searchedRoTripList.clear();
    getIt<Variables>().generalVariables.filters.clear();
    getIt<Variables>().generalVariables.selectedFilters.clear();
    getIt<Variables>().generalVariables.selectedFiltersName.clear();
    getIt<Variables>().generalVariables.filterSearchController.clear();
    getIt<Variables>().generalVariables.searchedResultFilterOption.clear();
    getIt<Variables>().generalVariables.filterSelectedMainIndex = 0;
    await getIt<Variables>()
        .repoImpl
        .getSorterTripListData(query: {}, method: "post", module: ApiEndPoints().returnsModule).onError((error, stackTrace) {
      searchedRoTripList = [];
      emit(RoTripListMainError(message: error.toString()));
    }).then((value) {
      if (value != null) {
        if (value["status"] == "1") {
          searchedRoTripList = List<RoTripList>.from(value["response"]["trips_list"].map((x) => RoTripList.fromJson(x)));
          searchedTempRoTripList = List<RoTripList>.from(value["response"]["trips_list"].map((x) => RoTripList.fromJson(x)));
          getIt<Variables>().generalVariables.filters = List<Filter>.from([
            {
              "type": "date_range",
              "label": getIt<Variables>().generalVariables.currentLanguage.dateRange,
              "selection": "date",
              "get_options": false,
              "options": List.generate(
                      searchedRoTripList.length, (i) => {"id": searchedRoTripList[i].tripCreatedTime, "label": searchedRoTripList[i].tripCreatedTime})
                  .map((map) => jsonEncode(map))
                  .toSet()
                  .map((str) => jsonDecode(str))
                  .toList()
            },
            {
              "type": "trip_no",
              "label": getIt<Variables>().generalVariables.currentLanguage.tripNo,
              "selection": "multiple",
              "get_options": false,
              "options":
                  List.generate(searchedRoTripList.length, (i) => {"id": searchedRoTripList[i].tripNum, "label": searchedRoTripList[i].tripNum})
                      .map((map) => jsonEncode(map))
                      .toSet()
                      .map((str) => jsonDecode(str))
                      .toList()
            },
            {
              "type": "vehicle_number",
              "label": getIt<Variables>().generalVariables.currentLanguage.vehicleNo,
              "selection": "multiple",
              "get_options": false,
              "options": List.generate(
                      searchedRoTripList.length, (i) => {"id": searchedRoTripList[i].tripVehicle, "label": searchedRoTripList[i].tripVehicle})
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
              "options": List.generate(searchedRoTripList.length,
                      (i) => {"id": searchedRoTripList[i].tripReconciliationStatus, "label": searchedRoTripList[i].tripReconciliationStatus})
                  .map((map) => jsonEncode(map))
                  .toSet()
                  .map((str) => jsonDecode(str))
                  .toList()
            }
          ].map((x) => Filter.fromJson(x)));
        }
      }
    });
    emit(RoTripListMainLoaded());
  }

  FutureOr<void> roTripListMainTabChangingFunction(RoTripListMainTabChangingEvent event, Emitter<RoTripListMainState> emit) {}

  FutureOr<void> roTripListMainSetStateFunction(RoTripListMainSetStateEvent event, Emitter<RoTripListMainState> emit) {
    emit(RoTripListMainDummy());
    event.stillLoading ? emit(RoTripListMainLoading()) : emit(RoTripListMainLoaded());
  }

  FutureOr<void> roTripListMainFilterFunction(RoTripListMainFilterEvent event, Emitter<RoTripListMainState> emit) {
    filterItemFunction();
    emit(RoTripListMainLoading());
    emit(RoTripListMainLoaded());
  }

  filterItemFunction() async {
    searchedRoTripList.clear();
    searchedRoTripList = searchedTempRoTripList
        .where((element) =>
            element.tripNum.toLowerCase().contains(searchText.toLowerCase()) ||
            element.tripRoute.toLowerCase().contains(searchText.toLowerCase()) ||
            element.tripVehicle.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    List<RoTripList> filteredList = [];
    filteredList.addAll(searchedRoTripList);
    for (int i = 0; i < getIt<Variables>().generalVariables.selectedFilters.length; i++) {
      switch (getIt<Variables>().generalVariables.selectedFilters[i].type) {
        case "date_range":
          {
            DateFormat formatter = DateFormat("dd/MM/yy");
            filteredList = filteredList
                .where((item1) =>
                    formatter
                            .parse(item1.tripCreatedTime)
                            .isAfter(formatter.parse(getIt<Variables>().generalVariables.selectedFilters[i].options[0])) &&
                        formatter
                            .parse(item1.tripCreatedTime)
                            .isBefore(formatter.parse(getIt<Variables>().generalVariables.selectedFilters[i].options[1])) ||
                    formatter
                        .parse(item1.tripCreatedTime)
                        .isAtSameMomentAs(formatter.parse(getIt<Variables>().generalVariables.selectedFilters[i].options[0])) ||
                    formatter
                        .parse(item1.tripCreatedTime)
                        .isAtSameMomentAs(formatter.parse(getIt<Variables>().generalVariables.selectedFilters[i].options[1])))
                .toList();
          }
        case "trip_no":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.tripNum == item2))
                .toList();
          }
        case "vehicle_number":
          {
            filteredList = filteredList
                .where((item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.tripVehicle == item2))
                .toList();
          }
        case "status":
          {
            filteredList = filteredList
                .where(
                    (item1) => getIt<Variables>().generalVariables.selectedFilters[i].options.any((item2) => item1.tripReconciliationStatus == item2))
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
    searchedRoTripList.clear();
    searchedRoTripList.addAll(filteredList);
  }
}
