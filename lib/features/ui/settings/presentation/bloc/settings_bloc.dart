import 'package:aurudu_nakath/features/ui/settings/data/repostories/settings_repository.dart';
import 'package:aurudu_nakath/features/ui/settings/domain/entities/user_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SettingsEvent {}

class LoadSettingsEvent extends SettingsEvent {}

class SaveSettingsEvent extends SettingsEvent {
  final UserSettings settings;

  SaveSettingsEvent(this.settings);
}

class SettingsState {
  final UserSettings settings;

  SettingsState(this.settings);
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository repository;

  SettingsBloc(this.repository) : super(SettingsState(UserSettings(notificationsEnabled: true, theme: 'light'))) {
    on<LoadSettingsEvent>((event, emit) async {
      final settings = await repository.getUserSettings();
      emit(SettingsState(settings));
    });

    on<SaveSettingsEvent>((event, emit) async {
      await repository.saveUserSettings(event.settings);
      emit(SettingsState(event.settings));
    });
  }
}
