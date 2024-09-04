import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/src/theme/base_theme.dart';
import 'package:pickup/ui/widgets/button_widget.dart';

class CustomDialog {
  static Future<void> showLoadingDialog(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.16,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Center(
                child: WillPopScope(
                  onWillPop: () async => false,
                  child: LoadingAnimationWidget.discreteCircle(
                      secondRingColor: Theme.of(context).primaryColorLight,
                      color: Theme.of(context).primaryColor,
                      size: 50),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> showSettingDialog({
    required BuildContext context,
    Color dialogBackGroundColor = Colors.white,
    required String infoText,
    required bool showSecondBtn,
    String headingText = '',
    String? secondBtnText,
    double btnHorizontalPadding = 15,
    Function()? onTapBtn,
  }) async {
    double width = MediaQuery.of(context).size.width;
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              backgroundColor: dialogBackGroundColor,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: EdgeInsets.all(24),
                height: MediaQuery.of(context).size.height * 0.34,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: headingText,
                            style: Theme.of(context)
                                .textTheme.displayMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: infoText,
                              style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(height: 0, color: darkThemeDarkColor),

                          ),
                        ],
                      ),
                    ),

                    // Text(
                    //   // "If you want to proceed enable location to Always",
                    //   infoText,
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .displayMedium!
                    //       .copyWith(height: 0, color: darkThemeDarkColor),
                    // ),
                    Spacer(flex: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if(showSecondBtn)
                        ButtonWidget(
                          horizontalPadding: btnHorizontalPadding,
                          btnText: secondBtnText,
                          bgColor: Theme.of(context).primaryColor,
                          textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: defaultFontFamily,
                              color: Colors.white,
                              height: 0),
                          onTap:onTapBtn,
                        ),
                        15.hSpace(),
                        ButtonWidget(
                          btnText: "Back",
                          horizontalPadding: btnHorizontalPadding,
                          textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: defaultFontFamily,
                              color: Colors.white,
                              height: 0),
                          bgColor: darkThemeDarkColor,
                          onTap: () {
                            Get.back();
                          },
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ));
      },
    );
  }

  static Future<void> showInfoDialog({
    required BuildContext context,
    Color dialogBackGroundColor = Colors.white,
    required String infoText,
    required bool showSecondBtn,
    String? secondBtnText,
    double btnHorizontalPadding = 15,
    Function()? onTapBtn,
  }) async {
    double width = MediaQuery.of(context).size.width;
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              backgroundColor: dialogBackGroundColor,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: EdgeInsets.all(24),
                child: Wrap(
                  children: [
                    Column(
                      children: [
                        Text(
                          // "If you want to proceed enable location to Always",
                          infoText,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(height: 0, color: darkThemeDarkColor),
                        ),
                        // Spacer(flex: 2),
                        20.vSpace(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if(showSecondBtn)
                              ButtonWidget(
                                horizontalPadding: btnHorizontalPadding,
                                btnText: secondBtnText,
                                bgColor: Theme.of(context).primaryColor,
                                textStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: defaultFontFamily,
                                    color: Colors.white,
                                    height: 0),
                                onTap:onTapBtn,
                              ),
                            15.hSpace(),
                            ButtonWidget(
                              btnText: "Back",
                              horizontalPadding: btnHorizontalPadding,
                              textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: defaultFontFamily,
                                  color: Colors.white,
                                  height: 0),
                              bgColor: darkThemeDarkColor,
                              onTap: () {
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  static Future<void> showRideFinishedDialog(BuildContext context) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: EdgeInsets.all(24),
                height: MediaQuery.of(context).size.height * 0.25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Your today's Ride Service is Ended. \n Please come again later",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(height: 0, color: Colors.white),
                    ),
                    Spacer(),
                    ButtonWidget(
                      btnText: "Back",
                      textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: defaultFontFamily,
                          color: Colors.white,
                          height: 0),
                      bgColor: darkThemeDarkColor,
                      onTap: () {
                        Get.back();
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Widget customLoader(BuildContext context) {
    return LoadingAnimationWidget.discreteCircle(
        secondRingColor: Theme.of(context).primaryColorLight,
        color: Theme.of(context).primaryColor,
        size: 50);
  }
}
