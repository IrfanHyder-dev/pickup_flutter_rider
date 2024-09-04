import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pickup/src/app/enums/app_enums.dart';

mixin class CommonUiService {
  showSnackBar(String msg, SnackBarType type,
      {Color? color, TextStyle? style}) {
    Get.showSnackbar(GetSnackBar(
      snackStyle: SnackStyle.FLOATING,
      messageText: Text(
        msg,
        textAlign: TextAlign.center,
        style: style ?? const TextStyle(color: Colors.white),
      ),
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      borderRadius: 75,
      backgroundColor: color != null
          ? color
          : type == SnackBarType.error
              ? const Color(0xffCA7E8D)
              : const Color(0xff70AE98),
      duration: Duration(seconds: msg.length > 50 ? 4 : 2),
      isDismissible: true,
    ));
  }

  showCustomErrorTextToast(
      {required BuildContext context, required String text}) async {
    MotionToast.error(
      description: Text(
        text,
        style: TextStyle(fontSize: 14),
      ),
      height: 60,
      width: 300,
    ).show(context);
  }

  showCustomSuccessTextToast(
      {required BuildContext context, required String text}) async {
    MotionToast.success(
            description: Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
            height: 60,
            width: 300)
        .show(context);
  }

  showCustomWarningTextToast(
      {required BuildContext context, required String text}) async {
    MotionToast.warning(
            description: Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
            height: 60,
            width: 300)
        .show(context);
  }

  showBottomSheet(BuildContext context, Widget content) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return content;
      },
    );
  }

  showBottomSheetFullScreen(
      BuildContext context, Widget content, double sheetHeight) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
            height: MediaQuery.of(context).size.height *
                sheetHeight, // adjust height as needed
            child: content);
      },
    );
  }
}
