import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  SharedPreferences? preferences;
  String token;

  SessionStorage({this.token = ""});

  static Future<SessionStorage> get() async {
    var preferences = await SharedPreferences.getInstance();
    var storage = SessionStorage();
    storage.preferences = preferences;
    return storage;
  }

  Future<void> saveToken(String token) async {
    await preferences?.setString('token', token);
  }

  Future<String> getToken() async {
    var token = preferences?.getString('token');
    if (token == null) throw Exception('Token not found');
    return token;
  }

  Future<void> clearToken() async {
    await preferences?.remove('token');
  }
}
