// Dart imports:
import 'dart:async';

// Package imports:
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:oda/local_database/user_box/user.dart';
import 'package:oda/repository/api_end_points.dart';
import 'package:oda/repository_model/dispute/dispute_filter_model.dart';
import 'package:oda/repository_model/dispute/dispute_model.dart';
import 'package:oda/repository_model/general/filter_options_model.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/variables.dart';

part 'dispute_main_event.dart';
part 'dispute_main_state.dart';

class DisputeMainBloc extends Bloc<DisputeMainEvent, DisputeMainState> {
  int tabIndex = 0;
  int selectedIndex = 0;
  bool searchBarEnabled = false;
  bool updateLoader = false;
  String searchText = "";
  int pageIndex = 1;
  String tabName = "Pending";
  CancelToken? listCancelToken = CancelToken();
  DisputeMainResponse disputeMainResponse = DisputeMainResponse.fromJson({});
  String? selectedReason;
  String? selectedReasonName;
  bool selectedReasonEmpty = false;
  String commentText = "";
  bool commentTextEmpty = false;
  bool hideKeyBoardReason = false;

  DisputeMainBloc() : super(DisputeMainLoading()) {
    on<DisputeMainInitialEvent>(disputeMainInitialFunction);
    on<DisputeMainTabChangingEvent>(disputeMainTabChangingFunction);
    on<DisputeMainSetStateEvent>(disputeMainSetStateFunction);
    on<DisputeMainUpdateEvent>(disputeMainUpdateFunction);
  }

  FutureOr<void> disputeMainInitialFunction(DisputeMainInitialEvent event, Emitter<DisputeMainState> emit) async {
    tabIndex = 0;
    searchText="";
    searchBarEnabled=false;
    if (listCancelToken != null && !listCancelToken!.isCancelled) {
      listCancelToken?.cancel("Previous requests canceled.");
    }
    listCancelToken = CancelToken();
    emit(DisputeMainLoading());
    getIt<Variables>().repoImpl.getDisputeFilters(query: {}, method: "get", module: ApiEndPoints().disputeModule).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          DisputeFilterModel disputeFilterModel = DisputeFilterModel.fromJson(value);
          getIt<Variables>().generalVariables.filterSearchController.clear();
          getIt<Variables>().generalVariables.selectedFilters.clear();
          getIt<Variables>().generalVariables.selectedFiltersName.clear();
          getIt<Variables>().generalVariables.searchedResultFilterOption.clear();
          getIt<Variables>().generalVariables.filterSelectedMainIndex = 0;
          getIt<Variables>().generalVariables.filters = disputeFilterModel.response.filters;
          List<FilterOptionsResponse> optionsData = [];
          for (int j = 0; j < disputeFilterModel.response.filters.length; j++) {
              if (disputeFilterModel.response.filters[j].getOptions) {
                if(disputeFilterModel.response.filters[j].type=="items_list" || disputeFilterModel.response.filters[j].type=="customers"){
                  switch(disputeFilterModel.response.filters[j].type){
                    case "items_list":getIt<Variables>().generalVariables.filters[j].options.addAll(getIt<Variables>().generalVariables.userData.filterItemsListOptions);
                    case "customers":getIt<Variables>().generalVariables.filters[j].options.addAll(getIt<Variables>().generalVariables.userData.filterCustomersOptions);
                    default:getIt<Variables>().generalVariables.filters[j].options.addAll(getIt<Variables>().generalVariables.userData.filterItemsListOptions);
                  }
                }
                else{
                getIt<Variables>().generalVariables.filters[j].options.clear();
                int i = 0;
                do {
                  await getIt<Variables>().repoImpl.getFiltersOption(query: {"filter_type": disputeFilterModel.response.filters[j].type, "page": i}, method: "post").then((value) {
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
    await getIt<Variables>().repoImpl.getDisputeList(query: {"search": "", "page": 1, "status": "Pending", "filters": []}, method: "post", globalCancelToken: listCancelToken).onError((error, stackTrace) {
      emit(DisputeMainError(message: error.toString()));
      emit(DisputeMainLoading());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          DisputeListResponse disputeListResponse = DisputeListResponse.fromJson(value);
          disputeMainResponse = disputeListResponse.response;
          emit(DisputeMainLoaded());
        } else {
          emit(DisputeMainError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(DisputeMainLoading());
        }
      }
    });
  }

  FutureOr<void> disputeMainTabChangingFunction(DisputeMainTabChangingEvent event, Emitter<DisputeMainState> emit) async {
    if (listCancelToken != null && !listCancelToken!.isCancelled) {
      listCancelToken?.cancel("Previous requests canceled.");
    }
    listCancelToken = CancelToken();
    event.isLoading ? null : emit(DisputeMainLoading());
    await getIt<Variables>().repoImpl.getDisputeList(
        query: {"search": searchText, "page": pageIndex, "status": tabName, "filters": List.generate(getIt<Variables>().generalVariables.selectedFilters.length, (i) => getIt<Variables>().generalVariables.selectedFilters[i].toJson())},
        method: "post",
        globalCancelToken: listCancelToken).onError((error, stackTrace) {
      if (!event.isLoading) {
        disputeMainResponse = DisputeMainResponse.fromJson({});
      }
      emit(DisputeMainError(message: error.toString()));
      event.isLoading?emit(DisputeMainLoaded()):emit(DisputeMainLoading());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          DisputeListResponse disputeListResponse = DisputeListResponse.fromJson(value);
          if (event.isLoading) {
            disputeMainResponse.disputeList.addAll(disputeListResponse.response.disputeList);
          } else {
            disputeMainResponse = disputeListResponse.response;
          }
          emit(DisputeMainLoaded());
        } else {
          emit(DisputeMainError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          event.isLoading?emit(DisputeMainLoaded()):emit(DisputeMainLoading());
        }
      }
    });
  }

  FutureOr<void> disputeMainSetStateFunction(DisputeMainSetStateEvent event, Emitter<DisputeMainState> emit) async {
    emit(DisputeMainDummy());
    event.stillLoading?emit(DisputeMainLoading()):emit(DisputeMainLoaded());
  }

  FutureOr<void> disputeMainUpdateFunction(DisputeMainUpdateEvent event, Emitter<DisputeMainState> emit) async{
    await getIt<Variables>().repoImpl.getDisputeUpdate(
        query: {
          "dispute_id": disputeMainResponse.disputeList[selectedIndex].id,
          "reason": selectedReason,
          "remarks": commentText,
          "type": event.type
        },
        method: "post", module: ApiEndPoints().disputeModule).onError((error, stackTrace) {
      emit(DisputeMainError(message: error.toString()));
          emit(DisputeMainLoaded());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          disputeMainResponse.disputeList[selectedIndex].reassignAction=false;
          disputeMainResponse.disputeList[selectedIndex].resolveAction=false;
          if(event.type=="resolution"){
            disputeMainResponse.disputeList[selectedIndex].resolutionInfo = Info.fromJson(value["resolution_info"]);
            emit(DisputeMainSuccess(message: value["response"]??getIt<Variables>().generalVariables.currentLanguage.disputeResolved));
          }else{
            emit(DisputeMainSuccess(message: getIt<Variables>().generalVariables.currentLanguage.disputeForwardStoreKeeper));
          }
          emit(DisputeMainLoaded());
        } else {
          emit(DisputeMainError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(DisputeMainLoaded());
        }
      }
    });
  }
}
