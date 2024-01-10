import 'user_model.dart';

class SessionManager {
  static UserMdl? loggedInUser;

  static void setLoggedInUser(UserMdl user) {
    loggedInUser = user;
  }
}