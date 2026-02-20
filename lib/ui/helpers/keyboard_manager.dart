import 'package:flutter/material.dart';

mixin KeyboardManager<T extends StatefulWidget> on State<T> {
  void hideKeyboard() {
    final currectFocus = FocusScope.of(context);
    if (!currectFocus.hasPrimaryFocus) {
      currectFocus.unfocus();
    }
  }
}
