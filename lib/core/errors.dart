class AuthError implements Exception {
  String message;  // must be human readable
  String extra;

  AuthError({this.message = "Auth error, please try to relogin", this.extra = ""});
}
