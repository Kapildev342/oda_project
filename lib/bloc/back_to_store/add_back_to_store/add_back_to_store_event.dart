part of 'add_back_to_store_bloc.dart';

sealed class AddBackToStoreEvent extends Equatable {
  const AddBackToStoreEvent();
}

class AddBackToStoreInitialEvent extends AddBackToStoreEvent {
  const AddBackToStoreInitialEvent();

  @override
  List<Object?> get props => [];
}

class AddBackToStoreSetStateEvent extends AddBackToStoreEvent {
  final bool stillLoading;
  const AddBackToStoreSetStateEvent({this.stillLoading=false});

  @override
  List<Object?> get props => [stillLoading];
}

class AddBackToStoreAddEvent extends AddBackToStoreEvent {
  const AddBackToStoreAddEvent();

  @override
  List<Object?> get props => [];
}

