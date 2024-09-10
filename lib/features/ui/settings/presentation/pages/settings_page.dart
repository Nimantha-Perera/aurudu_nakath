import 'package:aurudu_nakath/features/ui/permissions/permissions_hadler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aurudu_nakath/features/ui/settings/domain/entities/user_settings.dart';
import 'package:aurudu_nakath/features/ui/settings/presentation/bloc/settings_bloc.dart';
import 'package:permission_handler/permission_handler.dart';


class SettingsPage extends StatelessWidget {
  final PermissionHandler _permissionHandler = PermissionHandler();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(RepositoryProvider.of(context))..add(LoadSettingsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          backgroundColor: Color(0xFFFABC3F),
        ),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            final bloc = context.read<SettingsBloc>();
            final settings = state.settings;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: ListView(
                children: [
                   Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      title: Text('Notification Permission'),
                      subtitle: Text('Manage notification permissions.'),
                      trailing: IconButton(
                        icon: Icon(Icons.toggle_on),
                        onPressed: () async {
                          await _permissionHandler.requestPermissions();
                          // Optionally, update UI or show a confirmation message
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Theme',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                  SizedBox(height: 8),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 5,
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: Text('Light'),
                          value: 'light',
                          groupValue: settings.theme,
                          onChanged: (value) {
                            bloc.add(SaveSettingsEvent(UserSettings(notificationsEnabled: settings.notificationsEnabled, theme: value!)));
                          },
                        ),
                        Divider(height: 1),
                        RadioListTile<String>(
                          title: Text('Dark'),
                          value: 'dark',
                          groupValue: settings.theme,
                          onChanged: (value) {
                            bloc.add(SaveSettingsEvent(UserSettings(notificationsEnabled: settings.notificationsEnabled, theme: value!)));
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'App Version',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                  SizedBox(height: 8),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      title: Text('1.0.0'), // Replace with dynamic version if needed
                      trailing: Icon(Icons.info_outline),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Privacy Policy',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                  SizedBox(height: 8),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      title: Text('View our privacy policy.'),
                      onTap: () {
                        // Navigate to privacy policy page or show privacy policy dialog
                      },
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Permissions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                  SizedBox(height: 8),
                 
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
