part of 'navigation_bloc.dart';

sealed class NavigationState extends Equatable {
  const NavigationState();
}

final class NavigationConfirm extends NavigationState {
  @override
  List<Object> get props => [];
}

final class NavigationLoaded extends NavigationState {
  @override
  List<Object> get props => [];
}

final class LanguageChanged extends NavigationState {
  @override
  List<Object> get props => [];
}

final class LanguageDummy extends NavigationState {
  @override
  List<Object> get props => [];
}

final class FilterOptionsLoaded extends NavigationState {
  @override
  List<Object> get props => [];
}
