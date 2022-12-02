import 'package:flutter/material.dart';

class CustomSnackbar {
  static snackbar(String text, GlobalKey<ScaffoldState> scaffoldKey) {
    final snackBar = SnackBar(
      
      content: Text('$text '),
      duration: const Duration(seconds: 3),
    );
    //_scaffoldKey.currentState!.removeCurrentSnackBar();
   // _scaffoldKey.currentState!.showSnackBar(snackBar);
  }
}
