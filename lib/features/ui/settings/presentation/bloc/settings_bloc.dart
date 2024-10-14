import 'package:aurudu_nakath/features/ui/settings/data/repostories/settings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aurudu_nakath/features/ui/settings/domain/entities/user_settings.dart';

// Settings Events
abstract class SettingsEvent {}

class LoadSettingsEvent extends SettingsEvent {}

class SaveSettingsEvent extends SettingsEvent {
  final UserSettings settings;

  SaveSettingsEvent(this.settings);
}

// Settings State
class SettingsState {
  final UserSettings settings;

  SettingsState(this.settings);
}

// Settings Bloc
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsBloc(this.settingsRepository) : super(SettingsState(UserSettings(notificationsEnabled: true, theme: 'light'))) {
    on<LoadSettingsEvent>((event, emit) async {
      final settings = await settingsRepository.getUserSettings();
      emit(SettingsState(settings));
    });

    on<SaveSettingsEvent>((event, emit) async {
      await settingsRepository.saveUserSettings(event.settings);
      emit(SettingsState(event.settings));
    });
  }
}
