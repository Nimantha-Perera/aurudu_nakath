import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:flutter/material.dart';

void update(BuildContext context) async {
  // Skip update in debug mode
  if (kDebugMode) {
    print('In debug mode, skipping in-app updates.');
    return;
  }

  print('Checking for Update');
  try {
    // First, check for available updates
    AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      if (updateInfo.immediateUpdateAllowed) {
        // Perform immediate update
        print('Immediate update allowed');
        AppUpdateResult immediateResult = await InAppUpdate.performImmediateUpdate();
        if (immediateResult == AppUpdateResult.success) {
          // App update successful
          print('Immediate update successful');
        }
      } else if (updateInfo.flexibleUpdateAllowed) {
        // Perform flexible update
        print('Flexible update allowed');
        AppUpdateResult flexibleResult = await InAppUpdate.startFlexibleUpdate();
        if (flexibleResult == AppUpdateResult.success) {
          // Complete flexible update
          print('Flexible update successful, completing update');
          await InAppUpdate.completeFlexibleUpdate();
        }
      } else {
        print('No update available or allowed');
      }
    } else {
      print('No update available');
    }
  } on PlatformException catch (error) {
    // Check if the error is related to app ownership
    if (error.code == 'TASK_FAILURE' && error.message?.contains('ERROR_APP_NOT_OWNED') == true) {
      handleUpdateOwnershipError(context);
    } else {
      handleUpdateError(error, context);
    }
  }
}

void handleUpdateOwnershipError(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Update Not Available'),
        content: Text(
            'The app update could not be completed because the current user does not own the app. To update the app, please install the app from the Play Store.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

void handleUpdateError(PlatformException error, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Update Failed'),
        content: Text('An error occurred during the update: ${error.message}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
