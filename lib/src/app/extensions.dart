import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


extension StringExtension on String {
  ///--------------Capitalize
  String get capitalizeFirst =>
      length == 0 ? this : "${this[0].toUpperCase()}${substring(1)}";

  ///--------------TO URI
  Uri toUri() {
    return Uri.parse(this);
  }
}

extension Print on dynamic {
  void debugPrint() {
    if (kDebugMode) {
      log(toString());
    }
  }
}

extension WidgetSpacer on num {
  Widget vSpace() {
    return SizedBox(
      height: toDouble(),
    );
  }

  Widget hSpace() {
    return SizedBox(
      width: toDouble(),
    );
  }
}
