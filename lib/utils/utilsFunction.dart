import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UtilsFunction {
  closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  formatCurrency(dynamic currency) {
    var eurosInUSFormat = NumberFormat.currency(locale: "vi_VN", symbol: "đ");
    return eurosInUSFormat.format(currency);
  }

  formatDateTime(DateTime date) {
    print("DATE $date");
    return " ${date.hour} giờ  ${date.minute} phút - ${date.day}/${date.month}/${date.year} ";
  }
}
