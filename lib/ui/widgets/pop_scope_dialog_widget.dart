import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup/src/language/language_keys.dart';



class PopScopeDialogWidget extends StatelessWidget {
  const PopScopeDialogWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(exitKey.tr),
      content:  Text(exitAppKey.tr),
      actions: [
        TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.transparent),
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(yesKey.tr),
        ),
        TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.transparent),
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text(
            'No',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}