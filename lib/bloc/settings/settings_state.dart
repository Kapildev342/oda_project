part of 'settings_bloc.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();
}

final class SettingsLoading extends SettingsState {
  @override
  List<Object> get props => [];
}

final class SettingsLoaded extends SettingsState {
  @override
  List<Object> get props => [];
}

final class SettingsSuccess extends SettingsState {
  @override
  List<Object> get props => [];
}

final class SettingsLogoutSuccess extends SettingsState {
  @override
  List<Object> get props => [];
}

final class SettingsDialogSuccess extends SettingsState {
  @override
  List<Object> get props => [];
}

final class SettingsDialogChangedSuccess extends SettingsState {
  @override
  List<Object> get props => [];
}

final class SettingsFailure extends SettingsState {
  final String message;
  const SettingsFailure({required this.message});
  @override
  List<Object> get props => [message];
}

final class SettingsError extends SettingsState {
  @override
  List<Object> get props => [];
}

final class SettingsDummy extends SettingsState {
  @override
  List<Object> get props => [];
}
