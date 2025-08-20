// Dart imports:
import 'dart:async';

// Package imports:
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:oda/local_database/user_box/user.dart';
import 'package:oda/repository/api_end_points.dart';
import 'package:oda/repository_model/catch_weight/catch_weight_filter_model.dart';
import 'package:oda/repository_model/catch_weight/catch_weight_list_model.dart';
import 'package:oda/repository_model/general/filter_options_model.dart';
import 'package:oda/repository_model/general/socket_message_response_model.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/variables.dart';

part 'catch_weight_event.dart';
part 'catch_weight_state.dart';

class CatchWeightBloc extends Bloc<CatchWeightEvent, CatchWeightState> {
  String? selectedReason;
  String? selectedReasonName;
  bool selectedReasonEmpty = false;
  bool selectItemEmpty = false;
  String selectedItemId = "";
  String? selectedItem;
  String? selectedItemName;
  String availableQtyParticulars = "";
  bool textFieldEmpty = false;
  bool formatError = false;
  bool isZeroValue = false;
  bool moreQuantityError = false;
  bool availableQtyParticularsEmpty = false;
  String searchText = "";
  String commentText = "";
  bool commentTextEmpty = false;
  bool updateLoader = false;
  List<double> chipsContentList = [];
  bool searchBarEnabled = false;
  bool hideKeyBoardReason = false;
  bool hideKeyBoardItem = false;
  int tabIndex = 0;
  int pageIndex = 1;
  String tabName = "Submitted";
  CatchWeightListResponse catchWeightListResponse = CatchWeightListResponse.fromJson({});
  CancelToken? listCancelToken = CancelToken();

  CatchWeightBloc() : super(CatchWeightLoading()) {
    on<CatchWeightInitialEvent>(catchWeightInitialFunction);
    on<CatchWeightTabChangingEvent>(catchWeightTabChangingFunction);
    on<CatchWeightUpdateEvent>(catchWeightUpdateFunction);
    on<CatchWeightUndoEvent>(catchWeightUndoFunction);
    on<CatchWeightSetStateEvent>(catchWeightSetStateFunction);
    on<CatchWeightRefreshEvent>(catchWeightRefreshFunction);
  }

  FutureOr<void> catchWeightInitialFunction(CatchWeightInitialEvent event, Emitter<CatchWeightState> emit) async {
    searchText="";
    searchBarEnabled=false;
    tabIndex = 0;
    getIt<Variables>().generalVariables.filters.clear();
    if (listCancelToken != null && !listCancelToken!.isCancelled) {
      listCancelToken?.cancel("Previous requests canceled.");
    }
    listCancelToken = CancelToken();
    emit(CatchWeightLoading());
    getIt<Variables>().repoImpl.getCatchWeightFilters(query: {}, method: "get", module: ApiEndPoints().catchWeightModule).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          CatchWeightFilterModel catchWeightFilterModel = CatchWeightFilterModel.fromJson(value);
          getIt<Variables>().generalVariables.filterSearchController.clear();
          getIt<Variables>().generalVariables.selectedFilters.clear();
          getIt<Variables>().generalVariables.selectedFiltersName.clear();
          getIt<Variables>().generalVariables.searchedResultFilterOption.clear();
          getIt<Variables>().generalVariables.filterSelectedMainIndex = 0;
          getIt<Variables>().generalVariables.filters = catchWeightFilterModel.response.filters;
          List<FilterOptionsResponse> optionsData = [];
          for (int j = 0; j < catchWeightFilterModel.response.filters.length; j++) {
            if (catchWeightFilterModel.response.filters[j].getOptions) {
              if(catchWeightFilterModel.response.filters[j].type=="items_list" || catchWeightFilterModel.response.filters[j].type=="customers" ){
                switch(catchWeightFilterModel.response.filters[j].type){
                  case "items_list":getIt<Variables>().generalVariables.filters[j].options.addAll(getIt<Variables>().generalVariables.userData.filterItemsListOptions);
                  case "customers":getIt<Variables>().generalVariables.filters[j].options.addAll(getIt<Variables>().generalVariables.userData.filterCustomersOptions);
                  default:getIt<Variables>().generalVariables.filters[j].options.addAll(getIt<Variables>().generalVariables.userData.filterItemsListOptions);
                }
              }
              else{
              getIt<Variables>().generalVariables.filters[j].options.clear();
              int i = 0;
              do {
                await getIt<Variables>().repoImpl.getFiltersOption(query: {"filter_type": catchWeightFilterModel.response.filters[j].type, "page": i}, method: "post").then((value) {
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
    await getIt<Variables>().repoImpl.getCatchWeightList(query: {"search": "", "page": 1, "status": "Submitted", "filters": []}, method: "post", globalCancelToken: listCancelToken, module: ApiEndPoints().catchWeightModule).onError((error, stackTrace) {
      emit(CatchWeightError(message: error.toString()));
      emit(CatchWeightLoading());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          CatchWeightListModel catchWeightListModel = CatchWeightListModel.fromJson(value);
          catchWeightListResponse = catchWeightListModel.response;
          catchWeightListResponse.alternativeItems.clear();
          catchWeightListResponse.alternativeItems=getIt<Variables>().generalVariables.userData.filterItemsListOptions;
          emit(CatchWeightLoaded());
        } else {
          emit(CatchWeightError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(CatchWeightLoading());
        }
      }
    });
  }

  FutureOr<void> catchWeightTabChangingFunction(CatchWeightTabChangingEvent event, Emitter<CatchWeightState> emit) async {
    if (listCancelToken != null && !listCancelToken!.isCancelled) {
      listCancelToken?.cancel("Previous requests canceled.");
    }
    listCancelToken = CancelToken();
    event.isLoading ? null : emit(CatchWeightLoading());
    await getIt<Variables>().repoImpl.getCatchWeightList(
        query: {"search": searchText, "page": pageIndex, "status": tabName, "filters": List.generate(getIt<Variables>().generalVariables.selectedFilters.length, (i) => getIt<Variables>().generalVariables.selectedFilters[i].toJson())},
        method: "post",
        globalCancelToken: listCancelToken, module: ApiEndPoints().catchWeightModule).onError((error, stackTrace) {
      if (!event.isLoading) {
        catchWeightListResponse = CatchWeightListResponse.fromJson({});
      }
      emit(CatchWeightError(message: error.toString()));
      event.isLoading ? emit(CatchWeightLoaded()) : emit(CatchWeightLoading());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          CatchWeightListModel catchWeightListModel = CatchWeightListModel.fromJson(value);
          if (event.isLoading) {
            catchWeightListResponse.items.addAll(catchWeightListModel.response.items);
            catchWeightListResponse.alternativeItems.clear();
            catchWeightListResponse.alternativeItems=getIt<Variables>().generalVariables.userData.filterItemsListOptions;
          } else {
            catchWeightListResponse = catchWeightListModel.response;
            catchWeightListResponse.alternativeItems.clear();
            catchWeightListResponse.alternativeItems=getIt<Variables>().generalVariables.userData.filterItemsListOptions;
          }
          emit(CatchWeightLoaded());
        } else {
          emit(CatchWeightError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          event.isLoading ? emit(CatchWeightLoaded()) : emit(CatchWeightLoading());
        }
      }
    });
  }

  FutureOr<void> catchWeightUpdateFunction(CatchWeightUpdateEvent event, Emitter<CatchWeightState> emit) async {
    Map<String, dynamic> queryData = {};
    if (event.isAvailable) {
      queryData = {"id": selectedItemId, "status": "Updated", "avail_qty_particulars": availableQtyParticulars};
    } else {
      queryData = {"id": selectedItemId, "status": "Not Available", "reason": selectedReason, "remarks": commentText, "alternative_item": selectedItem};
    }
    await getIt<Variables>().repoImpl.getCatchWeightUpdate(query: queryData, method: "post", module: ApiEndPoints().catchWeightModule).onError((error, stackTrace) {
      emit(CatchWeightFailure());
      emit(CatchWeightError(message: error.toString()));
      emit(CatchWeightLoaded());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          emit(CatchWeightSuccess(message: value["response"] ?? (event.isAvailable?getIt<Variables>().generalVariables.currentLanguage.catchWeightMarkAvailable:getIt<Variables>().generalVariables.currentLanguage.catchWeightMarkUnavailable)));
          emit(CatchWeightLoaded());
        } else {
          emit(CatchWeightFailure());
          emit(CatchWeightError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(CatchWeightLoaded());
        }
      }
    });
  }

  FutureOr<void> catchWeightUndoFunction(CatchWeightUndoEvent event, Emitter<CatchWeightState> emit) async {
    await getIt<Variables>().repoImpl.getCatchWeightUndo(query: {"id": selectedItemId, "undo_remarks": "I have updated quantity wrongly"}, method: "post", module: ApiEndPoints().catchWeightModule).onError((error, stackTrace) {
      emit(CatchWeightFailure());
      emit(CatchWeightError(message: error.toString()));
      emit(CatchWeightLoaded());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          emit(CatchWeightSuccess(message: value["response"]??getIt<Variables>().generalVariables.currentLanguage.catchWeightStatusUndone));
          emit(CatchWeightLoaded());
        } else {
          emit(CatchWeightFailure());
          emit(CatchWeightError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(CatchWeightLoaded());
        }
      }
    });
  }

  FutureOr<void> catchWeightSetStateFunction(CatchWeightSetStateEvent event, Emitter<CatchWeightState> emit) async {
    emit(CatchWeightDummy());
    event.stillLoading?emit(CatchWeightLoading()):emit(CatchWeightLoaded());
  }

  FutureOr<void> catchWeightRefreshFunction(CatchWeightRefreshEvent event, Emitter<CatchWeightState> emit) async {
    for(int i=0; i<catchWeightListResponse.items.length; i++){
      if(catchWeightListResponse.items[i].id == event.socketMessage.body.catchWeightId){
        catchWeightListResponse.items.removeAt(i);
        emit(CatchWeightDummy());
        emit(CatchWeightLoaded());
      }
    }
  }
}
