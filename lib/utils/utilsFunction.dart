import 'package:flutter/material.dart';

class UtilsFunction {
  closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
