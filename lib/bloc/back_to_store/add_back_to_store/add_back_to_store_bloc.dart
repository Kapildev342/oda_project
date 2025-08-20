// Dart imports:
import 'dart:async';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oda/repository/api_end_points.dart';

// Project imports:
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/variables.dart';

part 'add_back_to_store_event.dart';
part 'add_back_to_store_state.dart';

class AddBackToStoreBloc extends Bloc<AddBackToStoreEvent, AddBackToStoreState> {

  bool hideKeyBoardReason = false;
  bool hideKeyBoardItem = false;
  bool hideKeyBoardLocation = false;

  bool selectedReasonEmpty = false;
  bool selectedItemEmpty = false;
  bool selectedLocationEmpty = false;

  bool reasonFieldEmpty = false;
  bool itemFieldEmpty = false;
  bool locationFieldEmpty = false;
  bool noteTextEmpty = false;
  bool quantityTextEmpty = false;

  bool updateLoader = false;
  bool formatError = false;
  bool isZeroValue = false;

  String? selectedReason;
  String? selectedReasonName;
  String selectedQuantity = "";
  String? selectedItem;
  String? selectedItemName;
  String? selectedLocation;
  String? selectedLocationName;
  String selectedNotes = "";

  AddBackToStoreBloc() : super(AddBackToStoreLoading()) {
    on<AddBackToStoreInitialEvent>(addBackToStoreInitialFunction);
    on<AddBackToStoreSetStateEvent>(addBackToStoreSetStateFunction);
    on<AddBackToStoreAddEvent>(addBackToStoreAddFunction);
  }

  FutureOr<void> addBackToStoreInitialFunction(AddBackToStoreInitialEvent event, Emitter<AddBackToStoreState> emit) async {
    emit(AddBackToStoreLoading());
    selectedItem="";
    selectedItemName=null;
    selectedQuantity="";
    selectedReason="";
    selectedReasonName=null;
    selectedLocation="";
    selectedLocationName=null;
    selectedNotes="";

    itemFieldEmpty=false;
    quantityTextEmpty=false;
    reasonFieldEmpty=false;
    locationFieldEmpty=false;
    noteTextEmpty=false;

    selectedItemEmpty=false;
    selectedReasonEmpty=false;
    selectedLocationEmpty=false;

    hideKeyBoardItem=false;
    hideKeyBoardReason=false;
    hideKeyBoardLocation=false;

    updateLoader = false;
    formatError = false;
    isZeroValue = false;
    emit(AddBackToStoreDummy());
    emit(AddBackToStoreLoaded());
  }

  FutureOr<void> addBackToStoreSetStateFunction(AddBackToStoreSetStateEvent event, Emitter<AddBackToStoreState> emit) async{
    emit(AddBackToStoreDummy());
    event.stillLoading?emit(AddBackToStoreLoading()): emit(AddBackToStoreLoaded());
  }

  FutureOr<void> addBackToStoreAddFunction(AddBackToStoreAddEvent event, Emitter<AddBackToStoreState> emit) async{
    await getIt<Variables>().repoImpl.getAddBackToStore(query: {
      "item_id":selectedItem,
      "quantity":selectedQuantity,
      "reason":selectedReason,
      "location_id":selectedLocation,
      "notes":selectedNotes
    }, method: "post", module: ApiEndPoints().btsModule).onError((error, stackTrace) {
      emit(AddBackToStoreError(message: error.toString()));
      emit(AddBackToStoreLoading());
    }).then((value) async {
      if (value != null) {
        if (value["status"] == "1") {
          emit(AddBackToStoreSuccess(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(AddBackToStoreLoaded());
        } else {
          emit(AddBackToStoreError(message: value["response"] ?? getIt<Variables>().generalVariables.currentLanguage.somethingWentWrong));
          emit(AddBackToStoreLoading());
        }
      }
    });
  }
}
