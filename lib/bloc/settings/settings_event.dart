part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class SettingsInitialEvent extends SettingsEvent {
  const SettingsInitialEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class SettingsChangeLanguageEvent extends SettingsEvent {
  const SettingsChangeLanguageEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class SettingsLogoutEvent extends SettingsEvent {
  const SettingsLogoutEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class SettingsSetStateEvent extends SettingsEvent {
  final bool stillLoading;
  const SettingsSetStateEvent({this.stillLoading=false});

  @override
  List<Object?> get props => [stillLoading];
}

class SettingsCurrentPasswordValidationEvent extends SettingsEvent {
  const SettingsCurrentPasswordValidationEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class SettingsChangePasswordEvent extends SettingsEvent {
  const SettingsChangePasswordEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}
