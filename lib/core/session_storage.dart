import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  int id = 0;
  String email = "";
}

class ModelConfig {
  String model = "";
  String apiKey = "";
  String baseUrl = "";

  @override
  String toString() {
    return 'ModelConfig{model: $model, baseUrl: $baseUrl}';
  }

  void fromMap(Map<String, dynamic> json) {
    model = json['model'];
    apiKey = json['apiKey'];
    baseUrl = json['baseUrl'];
  }

  Map<String, dynamic> toMap() {
    return {'model': model, 'apiKey': apiKey, 'baseUrl': baseUrl};
  }
}

class SessionStorage {
  SharedPreferences? preferences;
  String token = "";
  UserData user = UserData();
  ModelConfig modelConfig = ModelConfig();

  static Future<SessionStorage> get() async {
    var preferences = await SharedPreferences.getInstance();
    var storage = SessionStorage();
    storage.preferences = preferences;
    storage.syncUserData();
    storage._loadModelConfig();
    return storage;
  }

  Future<void> saveToken(String token) async {
    await preferences?.setString('token', token);
  }

  String getToken() {
    var token = preferences?.getString('token');
    if (token == null) throw Exception('Token not found');
    return token;
  }

  void clearSession() {
    preferences?.remove('token');
  }

  void updateUserData(Map<String, dynamic> data) {
    preferences?.setString('email', data['email']);
    preferences?.setInt('id', data['id']);
  }

  UserData syncUserData() {
    user.email = preferences?.getString('email') ?? "";
    user.id = preferences?.getInt('id') ?? 0;
    return user;
  }

  void _loadModelConfig() {
    var modelConfigJson = preferences?.getString('modelConfig');
    if (modelConfigJson == null) return;

    modelConfig.fromMap(jsonDecode(modelConfigJson));
  }

  Future<void> saveModelConfig() async {
    if (preferences == null) return;
    await preferences!.setString(
      'modelConfig',
      jsonEncode(modelConfig.toMap()),
    );
  }
}
