import 'package:chat_app/methods/constants.dart';

class UserApp {
  String message;
  String uid;
  String date;
  UserApp({required this.message, required this.uid, required this.date});
  Map<String, dynamic> toMap() {
    return {
      Constants().messages: message,
      Constants().uid: uid,
      Constants().date: date,
    };
  }
}
