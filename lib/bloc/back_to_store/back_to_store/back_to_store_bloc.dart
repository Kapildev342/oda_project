// Dart imports:
import 'dart:async';

// Package imports:
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:oda/local_database/user_box/user.dart';
import 'package:oda/repository/api_end_points.dart';
import 'package:oda/repository_model/back_to_store/add_back_to_store_init_model.dart';
import 'package:oda/repository_model/back_to_store/back_to_store_filter_model.dart';
import 'package:oda/repository_model/back_to_store/back_to_store_list.dart';
import 'package:oda/repository_model/general/filter_options_model.dart';
import 'package:oda/repository_model/general/socket_message_response_model.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/variables.dart';

part 'back_to_store_event.dart';
part 'back_to_store_state.dart';

class BackToStoreBloc extends Bloc<BackToStoreEvent, BackToStoreState> {
  BackToStoreResponse backToStoreListResponse = BackToStoreResponse.fromJson({});
  String searchText = "";
  int pageIndex = 1;
  String tabName = "Submitted";
  int tabIndex = 0;
  String? selectedReason;
  String? selectedReasonName;
  bool selectedReasonEmpty = false;
  bool textFieldEmpty = false;
  bool updateLoader = false;
  bool formatError = false;
  bool isZeroValue = false;
  bool moreQuantityError = false;
  bool searchBarEnabled = false;
  CancelToken? listCancelToken = CancelToken();
  bool hideKeyBoardReason = false;
  AddBackToStoreInitModel addBackToStoreInitModel=AddBackToStoreInitModel.fromJson({});

  BackToStoreBloc() : super(BackToStoreLoading()) {
    on<BackToStoreInitialEvent>(backToScreenInitialFunction);
    on<BackToStoreTabChangingEvent>(backToStoreTabChangingFunction);
    on<BackToStoreUnAvailableEvent>(backToStoreUnAvailableFunction);
    on<BackToStorePickedQtyEvent>(backToStorePickedQtyFunction);
    on<BackToStoreSetStateEvent>(backToStoreSetStateFunction);
    on<BackToStoreRemoveEvent>(backToStoreRemoveFunction);
    on<BackToStoreRefreshEvent>(btsRefreshFunction);
  }

  FutureOr<void> backToScreenInitialFunction(BackToStoreInitialEvent event, Emitter<BackToStoreState> emit) async {
    searchText="";
    searchBarEnabled=false;
    if (listCancelToken != null && !listCancelToken!.isCancelled) {
      listCancelToken?.cancel("Previous requests canceled.");
    }
    listCancelToken = CancelToken();
    emit(BackToStoreLoading());
    getIt<Variables>().repoImpl.getBackToStoreFilters(query: {}, method: "get", module: ApiEndPoints().btsModule).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          BackToStoreFilterModel backToStoreFilterModel = BackToStoreFilterModel.fromJson(value);
          getIt<Variables>().generalVariables.filterSearchController.clear();
          getIt<Variables>().generalVariables.selectedFilters.clear();
          getIt<Variables>().generalVariables.selectedFiltersName.clear();
          getIt<Variables>().generalVariables.searchedResultFilterOption.clear();
          getIt<Variables>().generalVariables.filterSelectedMainIndex = 0;
          getIt<Variables>().generalVariables.filters = backToStoreFilterModel.response.filters;
          List<FilterOptionsResponse> optionsData = [];
          for (int j = 0; j < backToStoreFilterModel.response.filters.length; j++) {
            if (backToStoreFilterModel.response.filters[j].getOptions) {
              if(backToStoreFilterModel.response.filters[j].type=="items_list" || backToStoreFilterModel.response.filters[j].type=="customers"){
                switch(backToStoreFilterModel.response.filters[j].type){
                  case "items_list":getIt<Variables>().generalVariables.filters[j].options.addAll(getIt<Variables>().generalVariables.userData.filterItemsListOptions);
                  case "customers":getIt<Variables>().generalVariables.filters[j].options.addAll(getIt<Variables>().generalVariables.userData.filterCustomersOptions);
                  default:getIt<Variables>().generalVariables.filters[j].options.addAll(getIt<Variables>().generalVariables.userData.filterItemsListOptions);
                }
              }
              else{
              getIt<Variables>().generalVariables.filters[j].options.clear();
              int i = 0;
              do {
                await getIt<Variables>().repoImpl.getFiltersOption(query: {"filter_type": backToStoreFilterModel.response.filters[j].type, "page": i}, method: "post").then((value) {
                  if (value != null) {
                    if (value["status"] == "1") {
                      FilterOptionsModel filterOptionsModel = FilterOptionsModel.fromJson(value);
                      optionsData = filterOptionsModel.response;
                      getIt<Variables>().generalVariables.filters[j].options.addAll(optionsData);
                    }
                  }
                });
                i++;
              } while (optionsData.isNotEmpty);}
              getIt<Variables>().generalVariables.searchedResultFilterOption = getIt<Variables>().generalVariables.filters[getIt<Variables>().generalVariables.filterSelectedMainIndex].options;
            } else {
              getIt<Variables>().generalVariables.searchedResultFilterOption = getIt<Variables>().generalVariables.filters[getIt<Variables>().generalVariables.filterSelectedMainIndex].options;
            }
          }
        }
      }
    });
    getIt<Variables>().repoImpl.getAddBackToStoreInit(query: {}, method: "get", module: ApiEndPoints().btsModule).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          addBackToStoreInitModel = AddBackToStoreInitModel.fromJson(value);
        }
      }
    });
    await getIt<Variables>().repoImpl.getBackToStoreList(query: {"search": "", "page": 1, "status": "Submitted", "filters": []}, method: "post", globalCancelToken: listCancelToken, module: ApiEndPoints().btsModule).onError((error, stackTrace) {
      emit(BackToStoreError(message: error.toString()));
      emit(BackToStoreLoading());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          BackToStoreListModel backToStoreListModel = BackToStoreListModel.fromJson(value);
          backToStoreListResponse = backToStoreListModel.response;
          emit(BackToStoreLoaded());
        } else {
          emit(BackToStoreError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(BackToStoreLoading());
        }
      }
    });
  }

  FutureOr<void> backToStoreTabChangingFunction(BackToStoreTabChangingEvent event, Emitter<BackToStoreState> emit) async {
    if (listCancelToken != null && !listCancelToken!.isCancelled) {
      listCancelToken?.cancel("Previous requests canceled.");
    }
    listCancelToken = CancelToken();
    event.isLoading ? null : emit(BackToStoreLoading());
    await getIt<Variables>().repoImpl.getBackToStoreList(
        query: {"search": searchText, "page": pageIndex, "status": tabName, "filters": List.generate(getIt<Variables>().generalVariables.selectedFilters.length, (i) => getIt<Variables>().generalVariables.selectedFilters[i].toJson())},
        method: "post",
        globalCancelToken: listCancelToken, module: ApiEndPoints().btsModule).onError((error, stackTrace) {
      if (!event.isLoading) {
        backToStoreListResponse = BackToStoreResponse.fromJson({});
      }
      emit(BackToStoreError(message: error.toString()));
      event.isLoading?emit(BackToStoreLoaded()):emit(BackToStoreLoading());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          BackToStoreListModel backToStoreListModel = BackToStoreListModel.fromJson(value);
          if (event.isLoading) {
            backToStoreListResponse.items.addAll(backToStoreListModel.response.items);
          } else {
            backToStoreListResponse = backToStoreListModel.response;
          }
          emit(BackToStoreLoaded());
        } else {
          emit(BackToStoreError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          event.isLoading?emit(BackToStoreLoaded()):emit(BackToStoreLoading());
        }
      }
    });
  }

  FutureOr<void> backToStoreUnAvailableFunction(BackToStoreUnAvailableEvent event, Emitter<BackToStoreState> emit) async {
    await getIt<Variables>().repoImpl.getBackToStoreUnavailable(query: {"id": event.id, "status": 'Not Available', "remarks": event.comments, 'reason': selectedReason}, method: "post", module: ApiEndPoints().btsModule).onError((error, stackTrace) {
      emit(BackToStoreError(message: error.toString()));
      emit(BackToStoreLoaded());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          emit(BackToStoreSuccess(message: value["response"]??getIt<Variables>().generalVariables.currentLanguage.itemMarkUnavailable));
          emit(BackToStoreLoaded());
        } else {
          emit(BackToStoreError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(BackToStoreLoaded());
        }
      }
    });
  }

  FutureOr<void> backToStorePickedQtyFunction(BackToStorePickedQtyEvent event, Emitter<BackToStoreState> emit) async {
    emit(BackToStoreLoading());
    await getIt<Variables>().repoImpl.getBackToStorePickedQuantity(query: {"id": event.id, "status": 'Updated', "picked_qty": event.pickedQty, "remarks": event.comments}, method: "post", module: ApiEndPoints().btsModule).onError((error, stackTrace) {
      emit(BackToStoreFailure(message: error.toString()));
      emit(BackToStoreLoaded());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          emit(BackToStoreSuccess(message: value["response"]??getIt<Variables>().generalVariables.currentLanguage.itemPickSuccess));
          emit(BackToStoreLoaded());
        } else {
          emit(BackToStoreFailure(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(BackToStoreLoaded());
        }
      } else {
        emit(BackToStoreFailure(message: getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
        emit(BackToStoreLoaded());
      }
    });
  }

  FutureOr<void> backToStoreRemoveFunction(BackToStoreRemoveEvent event, Emitter<BackToStoreState> emit) async {
    emit(BackToStoreLoading());
    await getIt<Variables>().repoImpl.getRemoveBackToStore(query: {"id":event.btsId}, method: "post", module: ApiEndPoints().btsModule).onError((error, stackTrace) {
      emit(BackToStoreError(message: error.toString()));
      emit(BackToStoreLoaded());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          emit(BackToStoreSuccess(message: value["response"]??getIt<Variables>().generalVariables.currentLanguage.btsRemoved));
          emit(BackToStoreLoaded());
        } else {
          emit(BackToStoreError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(BackToStoreLoaded());
        }
      } else {
        emit(BackToStoreError(message: getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
        emit(BackToStoreLoaded());
      }
    });
  }

  FutureOr<void> backToStoreSetStateFunction(BackToStoreSetStateEvent event, Emitter<BackToStoreState> emit) async {
    emit(BackToStoreDummy());
    event.stillLoading?emit(BackToStoreLoading()):emit(BackToStoreLoaded());
  }

  FutureOr<void> btsRefreshFunction(BackToStoreRefreshEvent event, Emitter<BackToStoreState> emit) async {
    for(int i=0; i<backToStoreListResponse.items.length; i++){
      if(backToStoreListResponse.items[i].id == event.socketMessage.body.btsId){
        backToStoreListResponse.items.removeAt(i);
        emit(BackToStoreDummy());
        emit(BackToStoreLoaded());
      }
    }
  }
}
