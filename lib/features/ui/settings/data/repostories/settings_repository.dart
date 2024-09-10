import 'package:aurudu_nakath/features/ui/settings/domain/entities/user_settings.dart';

abstract class SettingsRepository {
  Future<UserSettings> getUserSettings();
  Future<void> saveUserSettings(UserSettings settings);
}
