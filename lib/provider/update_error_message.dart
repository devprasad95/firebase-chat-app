import 'package:flutter/cupertino.dart';

class ErrorMessage extends ChangeNotifier {
  String errorMessage = '';
  String get getErrorMessage {
    return errorMessage;
  }

  void newError(String newError) {
    errorMessage = newError;
    notifyListeners();
  }
}
