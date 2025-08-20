// Package imports:
import 'package:dio/dio.dart';

class Repo {
  Future<dynamic> getInitialFunction({required Map<String, dynamic> query, required String method}) async {}
  Future<dynamic> getLanguageList({required Map<String, dynamic> query, required String method}) async {}
  Future<dynamic> getLanguageValueString({required Map<String, dynamic> query, required String method}) async {}
  Future<dynamic> getChangeLanguage({required Map<String, dynamic> query, required String method}) async {}
  Future<dynamic> getLogin({required Map<String, dynamic> query, required String method}) async {}
  Future<dynamic> getProfile({required Map<String, dynamic> query, required String method}) async {}
  Future<dynamic> getLogout({required Map<String, dynamic> query, required String method}) async {}
  Future<dynamic> getCheckPassword({required Map<String, dynamic> query, required String method}) async {}
  Future<dynamic> getChangePassword({required Map<String, dynamic> query, required String method}) async {}
  Future<dynamic> getForgetPassword({required Map<String, dynamic> query, required String method}) async {}
  Future<dynamic> getValidateOtp({required Map<String, dynamic> query, required String method}) async {}
  Future<dynamic> getCreatePassword({required Map<String, dynamic> query, required String method}) async {}
  Future<dynamic> getImage({required Map<String, dynamic> query, required String method, required String url}) async {}

  Future<dynamic> getCatchWeightList(
      {required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken, required String module}) async {}
  Future<dynamic> getCatchWeightFilters(
      {required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken, required String module}) async {}
  Future<dynamic> getFiltersOption({required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken}) async {}
  Future<dynamic> getCatchWeightUpdate({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getCatchWeightUndo({required Map<String, dynamic> query, required String method, required String module}) async {}

  Future<dynamic> getBackToStoreList(
      {required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken, required String module}) async {}
  Future<dynamic> getBackToStoreFilters(
      {required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken, required String module}) async {}
  Future<dynamic> getBackToStoreUnavailable({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getBackToStorePickedQuantity({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getAddBackToStoreInit({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getAddBackToStore({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getRemoveBackToStore({required Map<String, dynamic> query, required String method, required String module}) async {}

  Future<dynamic> getDisputeFilters(
      {required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken, required String module}) async {}
  Future<dynamic> getDisputeList({required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken}) async {}
  Future<dynamic> getDisputeUpdate({required Map<String, dynamic> query, required String method, required String module}) async {}

  /*Future<dynamic> getPickListMainLocal({required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken}) async {}
  Future<dynamic> getPickListMainFilters({required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken}) async {}
  Future<dynamic> getPickListDetails({required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken}) async {}
  Future<dynamic> getPickListDetailsFilters({required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken}) async {}*/
  Future<dynamic> getPickListMain({required Map<String, dynamic> query, required String method, CancelToken? globalCancelToken}) async {}
  Future<dynamic> getPickListDetailsPicked({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getPickListDetailsUnavailable({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getPickListDetailsLocationUpdate({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getPickListDetailsSessionClose({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getPicklistUnavailableReasons({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getPicklistCompleteReasons({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getPicklistComplete({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getLocations({required Map<String, dynamic> query, required String method}) async {}
  Future<dynamic> getPickListTimeLineInfo({required Map<String, dynamic> query, required String method, required String module}) async {}

  Future<dynamic> getSorterTripListData({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getSorterTripListInfo({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getSorterTripListUpdate({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getSorterTripListUndo({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getSorterTripListSessionClose({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getSorterTripListTimeLineInfo({required Map<String, dynamic> query, required String method, required String module}) async {}

  Future<dynamic> getWarehousePickupUpdate({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getWarehouseTimeLineInfo({required Map<String, dynamic> query, required String method, required String module}) async {}

  Future<dynamic> getReturnsTripListData({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getReturnsTripListDetail({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getRoTripExpensesList({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getRoTripExpensesUpdate({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getRoTripUpdateReturnItems({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getRoTripUpdateAssets({required Map<String, dynamic> query, required String method, required String module}) async {}
  Future<dynamic> getRoTripUpdateInvoiceReceivedAmount({required Map<String, dynamic> query, required String method, required String module}) async {}
}
