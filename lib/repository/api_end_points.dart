class ApiEndPoints {
  final String pickListModule = "picklist/";
  final String sorterModule = "sorter/";
  final String loaderModule = "loader/";
  final String catchWeightModule = "catchweight/";
  final String btsModule = "bts/";
  final String disputeModule = "dispute/";
  final String returnsModule = "returns/";


  final String getInitialFunction = "init";
  final String getLanguageList = "language-list";
  final String getLanguageValueString = "language-strings";
  final String getChangeLanguage = "language";
  final String getLogin = "login";
  final String getProfile = "profile";
  final String getLogout = "logout";
  final String getCheckPassword = "check-password";
  final String getChangePassword = "change-password";
  final String getForgetPassword = "forgot-password";
  final String getValidateOtp = "validate-reset-password";
  final String getCreatePassword = "reset-password";

  final String getCatchWeightList = "list";
  final String getCatchWeightFilters = "filters";
  final String getFiltersOption = "get-filter-options";
  final String getCatchWeightUpdate = "update";
  final String getCatchWeightUndo = "undo";

  final String getBackToStoreList = "list";
  final String getBackToStoreFilters = "filters";
  final String getBackToStoreBtsUpdate = "update";
  final String getAddBackToStoreInit = "add-init";
  final String getAddBackToStore = "add";
  final String getRemoveBackToStore = "remove";

  final String getDisputeFilters = "filters";
  final String getDispute = "dispute";
  final String getDisputeUpdate = "update";

  final String getPickListMain = "picklist";
  final String getPickListDetailsPicked = "update";
  final String getPickListDetailsUnavailable = "unavailable";
  final String getPickListDetailsLocationUpdate = "update-location";
  final String getPickListDetailsSessionClose = "close-session";
  final String getLocations = "get-locations";
  final String getPicklistComplete = "update-status";
  final String getPicklistUnavailableReasons = "reasons/unavailable";
  final String getPicklistCompleteReasons = "reasons/picklistcomplete";
  final String getPickListTimeLineInfo = "timeline-info";

  final String getSorterTripListData = "triplist";
  final String getSorterTripListInfo = "trip-info";
  final String getSorterTripListUpdate = "trip-update";
  final String getSorterTripListUndo = "trip-unavailable";
  final String getSorterTripListSessionClose = "close-trip-session";
  final String getSorterTripListTimeLineInfo = "timeline-info";

  final String getWarehousePickupUpdate = "update-warehouse-pickup";
  final String getWarehouseTimeLineInfo = "warehouse-timeline-info";

  final String getRoTripExpensesList = "expenses-list";
  final String getRoTripExpensesUpdate = "expenses-update";
  final String getRoTripUpdateReturnItems = "update-item-returns";
  final String getRoTripUpdateAssets = "update-assets";
  final String getRoTripUpdateInvoiceReceivedAmount = "update-invoice-received-amount";
}
