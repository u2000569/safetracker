import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsModel{
  final String? id;
  String appName;
  String appLogo;

  /// Constructor
  SettingsModel({
    this.id,
    this.appName = '',
    this.appLogo = '',
  });

  /// Convert model to JSON structure for storing data in Firebase.
  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'appLogo': appLogo,
    };
  }

  /// Factory method to create a SettingModel from a Firebase document snapshot.
  factory SettingsModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return SettingsModel(
        id: document.id,
        appName: data.containsKey('appName') ? data['appName'] ?? '' : '',
        appLogo: data.containsKey('appLogo') ? data['appLogo'] ?? '' : '',
      );
    } else {
      return SettingsModel();
    }
  }
}