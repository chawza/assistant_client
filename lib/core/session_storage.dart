import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  int id = 0;
  String email = "";
}

class SessionStorage {
  SharedPreferences? preferences;
  String token = "";
  UserData user = UserData();

  SessionStorage();

  static Future<SessionStorage> get() async {
    var preferences = await SharedPreferences.getInstance();
    var storage = SessionStorage();
    storage.preferences = preferences;
    storage.syncUserData();
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
}
