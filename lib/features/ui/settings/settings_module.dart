

import 'package:aurudu_nakath/features/ui/settings/data/repostories/settings_repository.dart';
import 'package:aurudu_nakath/features/ui/settings/data/repostories/settings_repository_impl.dart';
import 'package:aurudu_nakath/features/ui/settings/presentation/bloc/settings_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;


class SettingsModule {
  static void configureDependencies() {
    // Register repository
    sl.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl());

    // Register bloc
    sl.registerFactory<SettingsBloc>(() => SettingsBloc(sl()));
  }
}
