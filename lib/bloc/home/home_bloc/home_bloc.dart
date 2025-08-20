// Dart imports:
import 'dart:async';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/variables.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoading()) {
    on<HomeInitialEvent>(initialFunction);
    on<HomeSetStateEvent>(homeSetStateFunction);
  }

  FutureOr<void> initialFunction(HomeInitialEvent event, Emitter<HomeState> emit) async {
    getIt<Variables>().generalVariables.homeRouteList.clear();
    if (getIt<Variables>().generalVariables.initialSetupValues.appMode != "production") {
      emit(HomeDialogState());
      emit(HomeLoading());
      emit(HomeLoaded());
    } else {
      emit(HomeLoading());
      emit(HomeLoaded());
    }
  }

  FutureOr<void> homeSetStateFunction(HomeSetStateEvent event, Emitter<HomeState> emit) async{
    emit(HomeDummy());
    event.stillLoading?emit(HomeLoading()):emit(HomeLoaded());
  }

}
