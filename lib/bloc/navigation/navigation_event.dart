part of 'navigation_bloc.dart';

sealed class NavigationEvent extends Equatable {
  const NavigationEvent();
}

class NavigationInitialEvent extends NavigationEvent {
  const NavigationInitialEvent();

  @override
  List<Object?> get props => [];
}

class NavigationSetStateEvent extends NavigationEvent {
  const NavigationSetStateEvent();

  @override
  List<Object?> get props => [];
}

class BottomNavigationEvent extends NavigationEvent {
  final int index;
  const BottomNavigationEvent({required this.index});
  @override
  List<Object?> get props => [index];
}

class SideDrawerNavigationEvent extends NavigationEvent {
  final int index;
  const SideDrawerNavigationEvent({required this.index});
  @override
  List<Object?> get props => [index];
}


class LanguageChangingEvent extends NavigationEvent {
  final int index;
  const LanguageChangingEvent({required this.index});
  @override
  List<Object?> get props => [index];
}

class ListenConnectivity extends NavigationEvent {
  const ListenConnectivity();
  @override
  List<Object?> get props => [];
}
