// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import 'package:oda/repository/api_end_points.dart';
import 'package:oda/repository/base_api_service.dart';
import 'package:oda/repository/network_api_service.dart';
import 'package:oda/repository/repo.dart';

class RepoImpl extends Repo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<dynamic> getInitialFunction({required Map<String, dynamic> query, required String method}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: ApiEndPoints().getInitialFunction, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getLanguageList({required Map<String, dynamic> query, required String method}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: ApiEndPoints().getLanguageList, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getLanguageValueString({required Map<String, dynamic> query, required String method}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: ApiEndPoints().getLanguageValueString, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getChangeLanguage({required Map<String, dynamic> query, required String method}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: ApiEndPoints().getChangeLanguage, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getLogin({required Map<String, dynamic> query, required String method}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: ApiEndPoints().getLogin, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getProfile({required Map<String, dynamic> query, required String method}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: ApiEndPoints().getProfile, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getLogout({required Map<String, dynamic> query, required String method}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: ApiEndPoints().getLogout, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getCheckPassword({required Map<String, dynamic> query, required String method}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: ApiEndPoints().getCheckPassword, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getChangePassword({required Map<String, dynamic> query, required String method}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: ApiEndPoints().getChangePassword, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getForgetPassword({required Map<String, dynamic> query, required String method}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: ApiEndPoints().getForgetPassword, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getValidateOtp({required Map<String, dynamic> query, required String method}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: ApiEndPoints().getValidateOtp, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getCreatePassword({required Map<String, dynamic> query, required String method}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: ApiEndPoints().getCreatePassword, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getImage({required Map<String, dynamic> query, required String method, required String url}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: url, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getCatchWeightList({required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken, required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module + ApiEndPoints().getCatchWeightList, query: query, method: method, globalCancelToken: globalCancelToken);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getCatchWeightFilters({required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken, required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module + ApiEndPoints().getCatchWeightFilters, query: query, method: method, globalCancelToken: globalCancelToken);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getCatchWeightUpdate({required Map<String, dynamic> query, required String method, required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module+ApiEndPoints().getCatchWeightUpdate, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getCatchWeightUndo({required Map<String, dynamic> query, required String method, required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module+ApiEndPoints().getCatchWeightUndo, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getBackToStoreList({required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken, required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module+ ApiEndPoints().getBackToStoreList, query: query, method: method, globalCancelToken: globalCancelToken);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getBackToStoreUnavailable({required Map<String, dynamic> query, required String method, required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module+ApiEndPoints().getBackToStoreBtsUpdate, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getBackToStorePickedQuantity({required Map<String, dynamic> query, required String method, required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module+ApiEndPoints().getBackToStoreBtsUpdate, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getBackToStoreFilters({required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken, required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module+ApiEndPoints().getBackToStoreFilters, query: query, method: method, globalCancelToken: globalCancelToken);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getAddBackToStoreInit({required Map<String, dynamic> query, required String method, required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module+ApiEndPoints().getAddBackToStoreInit, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getAddBackToStore({required Map<String, dynamic> query, required String method, required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module+ApiEndPoints().getAddBackToStore, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getRemoveBackToStore({required Map<String, dynamic> query, required String method, required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module+ApiEndPoints().getRemoveBackToStore, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getDisputeFilters({required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken, required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module+ApiEndPoints().getDisputeFilters, query: query, method: method, globalCancelToken: globalCancelToken);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getDisputeList({required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: ApiEndPoints().getDispute, query: query, method: method, globalCancelToken: globalCancelToken);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getDisputeUpdate({required Map<String, dynamic> query, required String method, required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module+ApiEndPoints().getDisputeUpdate, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getPickListMain({required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: ApiEndPoints().getPickListMain, query: query, method: method, globalCancelToken: globalCancelToken);
      return response;
    } catch (e) {
      rethrow;
    }
  }

 /* @override
  Future<dynamic> getPickListMainLocal({required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: ApiEndPoints().getPickListMainLocal, query: query, method: method, globalCancelToken: globalCancelToken);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getPickListMainFilters({required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: ApiEndPoints().getPickListMainFilters, query: query, method: method, globalCancelToken: globalCancelToken);
      return response;
    } catch (e) {
      rethrow;
    }
  }*/

  /* @override
  Future<dynamic> getPickListDetails({required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: ApiEndPoints().getPickListDetails, query: query, method: method, globalCancelToken: globalCancelToken);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getPickListDetailsFilters({required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: ApiEndPoints().getPickListDetailsFilters, query: query, method: method, globalCancelToken: globalCancelToken);
      return response;
    } catch (e) {
      rethrow;
    }
  }*/

  @override
  Future<dynamic> getFiltersOption({required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: ApiEndPoints().getFiltersOption, query: query, method: method, globalCancelToken: globalCancelToken);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getPickListDetailsPicked({required Map<String, dynamic> query, required String method, required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module+ApiEndPoints().getPickListDetailsPicked, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getPickListDetailsUnavailable({required Map<String, dynamic> query, required String method, required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module+ApiEndPoints().getPickListDetailsUnavailable, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getPickListDetailsLocationUpdate({required Map<String, dynamic> query, required String method, required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module+ApiEndPoints().getPickListDetailsLocationUpdate, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getPickListDetailsSessionClose({required Map<String, dynamic> query, required String method, required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module+ApiEndPoints().getPickListDetailsSessionClose, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getLocations({required Map<String, dynamic> query, required String method}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: ApiEndPoints().getLocations, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getPickListTimeLineInfo({required Map<String, dynamic> query, required String method, required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module + ApiEndPoints().getPickListTimeLineInfo, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getPicklistComplete({required Map<String, dynamic> query, required String method, required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url:module + ApiEndPoints().getPicklistComplete, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getPicklistUnavailableReasons({required Map<String, dynamic> query, required String method, required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module+ApiEndPoints().getPicklistUnavailableReasons, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getPicklistCompleteReasons({required Map<String, dynamic> query, required String method, required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module + ApiEndPoints().getPicklistCompleteReasons, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getSorterTripListData({required Map<String, dynamic> query, required String method,required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module + ApiEndPoints().getSorterTripListData, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getSorterTripListInfo({required Map<String, dynamic> query, required String method,required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module + ApiEndPoints().getSorterTripListInfo, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getSorterTripListUpdate({required Map<String, dynamic> query, required String method,required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module + ApiEndPoints().getSorterTripListUpdate, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getSorterTripListUndo({required Map<String, dynamic> query, required String method,required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module + ApiEndPoints().getSorterTripListUndo, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getSorterTripListSessionClose({required Map<String, dynamic> query, required String method,required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module + ApiEndPoints().getSorterTripListSessionClose, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getSorterTripListTimeLineInfo({required Map<String, dynamic> query, required String method,required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module + ApiEndPoints().getSorterTripListTimeLineInfo, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getWarehousePickupUpdate({required Map<String, dynamic> query, required String method,required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module + ApiEndPoints().getWarehousePickupUpdate, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getWarehouseTimeLineInfo({required Map<String, dynamic> query, required String method,required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module + ApiEndPoints().getWarehouseTimeLineInfo, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getReturnsTripListData({required Map<String, dynamic> query, required String method,required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module + ApiEndPoints().getSorterTripListData, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getReturnsTripListDetail({required Map<String, dynamic> query, required String method,required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module + ApiEndPoints().getSorterTripListInfo, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getRoTripExpensesList({required Map<String, dynamic> query, required String method,required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module + ApiEndPoints().getRoTripExpensesList, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getRoTripExpensesUpdate({required Map<String, dynamic> query, required String method,required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module + ApiEndPoints().getRoTripExpensesUpdate, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getRoTripUpdateReturnItems({required Map<String, dynamic> query, required String method,required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module + ApiEndPoints().getRoTripUpdateReturnItems, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getRoTripUpdateAssets({required Map<String, dynamic> query, required String method,required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module + ApiEndPoints().getRoTripUpdateAssets, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getRoTripUpdateInvoiceReceivedAmount({required Map<String, dynamic> query, required String method,required String module}) async {
    try {
      dynamic response = await _apiService.getInitialFunction(url: module + ApiEndPoints().getRoTripUpdateInvoiceReceivedAmount, query: query, method: method);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
