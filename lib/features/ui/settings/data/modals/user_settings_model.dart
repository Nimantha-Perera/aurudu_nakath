class UserSettingsModel {
  final bool notificationsEnabled;
  final String theme;

  UserSettingsModel({
    required this.notificationsEnabled,
    required this.theme,
  });

  // Convert model to Map (for saving in local storage or Firestore)
  Map<String, dynamic> toMap() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'theme': theme,
    };
  }

  // Factory method to create model from Map
  factory UserSettingsModel.fromMap(Map<String, dynamic> map) {
    return UserSettingsModel(
      notificationsEnabled: map['notificationsEnabled'] ?? false,
      theme: map['theme'] ?? 'light',
    );
  }
}
