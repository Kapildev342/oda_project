part of 'back_to_store_bloc.dart';

sealed class BackToStoreEvent extends Equatable {
  const BackToStoreEvent();
}

class BackToStoreInitialEvent extends BackToStoreEvent {
  const BackToStoreInitialEvent();

  @override
  List<Object?> get props => [];
}

class BackToStoreTabChangingEvent extends BackToStoreEvent {
  final bool isLoading;
  const BackToStoreTabChangingEvent({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class BackToStoreUnAvailableEvent extends BackToStoreEvent {
  final String comments,id;
  const BackToStoreUnAvailableEvent({required this.comments,required this.id});

  @override
  List<Object?> get props => [comments,id];
}

class BackToStorePickedQtyEvent extends BackToStoreEvent {
  final String comments,id;
  final double pickedQty;
  const BackToStorePickedQtyEvent({required this.comments,required this.pickedQty,required this.id});

  @override
  List<Object?> get props => [comments,pickedQty,id];
}

class BackToStoreRemoveEvent extends BackToStoreEvent {
  final String btsId;
  const BackToStoreRemoveEvent({required this.btsId});

  @override
  List<Object?> get props => [btsId];
}

class BackToStoreRefreshEvent extends BackToStoreEvent {
  final SocketMessageResponse socketMessage;
  const BackToStoreRefreshEvent({required this.socketMessage});

  @override
  List<Object?> get props => [socketMessage];
}

class BackToStoreSetStateEvent extends BackToStoreEvent {
  final bool stillLoading;
  const BackToStoreSetStateEvent({this.stillLoading=false});

  @override
  List<Object?> get props => [stillLoading];
}