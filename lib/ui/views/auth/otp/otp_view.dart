import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:get/get.dart';
import 'package:action_slider/action_slider.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/ui/widgets/button_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/auth/otp/otp_viewmodel.dart';
import 'package:stacked/stacked.dart';

class OtpView extends StatefulWidget {
  const OtpView({super.key});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  String _verificationCode = '';
  final _verificationCodeCont = TextEditingController();
  ActionSliderController controller = ActionSliderController();
  final ScrollController scrollController = ScrollController();

  bool hasError = false;
  int _start = 50;
  Timer? _timer;
  int iconType = 0;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    print('timer');
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          if (_start < 1) {
            timer.cancel();
            // Timer completed, perform desired actions here
            // For example, show a dialog or navigate to another screen
          } else {
            _start--;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<OtpViewModel>.reactive(
      builder: (context, viewModel, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SizedBox(
            height: mediaH,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          (mediaH * 0.08).vSpace(),
          SizedBox(
            // height: logoH,
            width: logoW,
            child: Image.asset('assets/papne_cab.png'),
          ),
            (0.038 * mediaH).vSpace(),
            Text(phoneVerfKey.tr,
                style: textTheme.displayLarge, textAlign: TextAlign.center),
            19.vSpace(),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(verfiSubKey.tr,
                    style: textTheme.displayMedium!
                        .copyWith(color: theme.canvasColor),
                    textAlign: TextAlign.center),
              ),
            ),
            (0.13 * mediaH).vSpace(),
            Text(
              enterCodeKey.tr,
              style: textTheme.titleLarge,
            ),
            (0.041 * mediaH).vSpace(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: PinCodeTextField(
                cursorColor: theme.primaryColor,
                controller:_verificationCodeCont,
                textStyle: TextStyle(color: theme.primaryColor),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                keyboardAppearance: Brightness.dark,
                // boxShadows: [
                //   BoxShadow(
                //     offset: Offset(0, 4),
                //     color: theme.primaryColor.withOpacity(.3),
                //     blurRadius: 5,
                //   )
                // ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                autoFocus: true,
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 14.0,
                ),
                length: 4,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  activeColor: theme.primaryColorDark,
                  selectedFillColor: theme.primaryColorDark,
                  selectedColor: theme.primaryColorDark,
                  inactiveFillColor: theme.primaryColorDark,
                  inactiveColor: theme.primaryColorDark,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 50,
                  fieldWidth: mediaW * .13,
                  activeFillColor: theme.primaryColorDark,
                ),
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                //errorAnimationController: _errorController,
                //controller: _verificationCodeCont,
                onCompleted: (v) {},
                onChanged: (value) {
                  // formValidation();
                  setState(() {
                  _verificationCode = value;
                  });
                },
                // beforeTextPaste: (text) {
                //   return true;
                // },
              ),
            ),
            (0.042 * mediaH).vSpace(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 39),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(76),
                  color: theme.scaffoldBackgroundColor),
              child: IgnorePointer(
                ignoring: _timer!.isActive,
                child: ActionSlider.custom(
                    toggleMargin: EdgeInsets.zero,
                    controller: controller,
                    toggleWidth: 50.0,
                    height: 50.0,
                    backgroundColor: theme.primaryColorDark,
                    foregroundChild: Container(
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30.0)),
                      ),
                      child: Center(
                        child: (iconType == 0)
                            ? const Icon(
                                Icons.arrow_forward_ios,
                                size: 25,
                                color: Colors.black,
                              )
                            : (iconType == 2)
                                ? const Icon(
                                    Icons.check_rounded,
                                    size: 40,
                                    color: Colors.black,
                                  )
                                : const SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                        color: Colors.black)),
                      ),
                    ),
                    foregroundBuilder: (context, state, child) => child!,
                    backgroundChild: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${codeNotRecKey.tr} ",
                              style: textTheme.bodyMedium!
                                  .copyWith(color: theme.cardColor),
                            ),
                            SizedBox(
                              //color: Colors.red,
                              width: 40,
                              child: Text(
                                '($_start)s',
                                style: textTheme.bodyMedium!
                                    .copyWith(color: theme.cardColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    backgroundBuilder: (context, state, child) => ClipRect(
                        child: OverflowBox(
                            maxWidth: state.standardSize.width,
                            maxHeight: state.toggleSize.height,
                            minWidth: state.standardSize.width,
                            minHeight: state.toggleSize.height,
                            child: child!)),
                    backgroundBorderRadius: BorderRadius.circular(76.0),
                    action: (controller) async {


                      //print('timer');
                      setState(() {
                        iconType = 1;
                      });
                      controller.loading(); //starts loading animation
                      await Future.delayed(const Duration(seconds: 3));
                      setState(() {
                        iconType = 2;
                      });
                      controller.success(); //starts success animation
                      await Future.delayed(const Duration(seconds: 1));
                      setState(() {
                        iconType = 0;
                      });
                      controller.reset();//resets the slider

                      setState(() {
                        _start = 50;
                        _verificationCodeCont.text = '';
                        startTimer();
                      });
                    }),
              ),
            ),
            (0.055 * mediaH).vSpace(),
            ButtonWidget(
              height: 48,
              width: 152,
              radius: 76,
              btnText: confirmKey.tr,
              textStyle: textTheme.titleLarge!
                  .copyWith(color: theme.unselectedWidgetColor),
              onTap: () {
                print('verfi code is ${_verificationCodeCont.text.trim()}');
                viewModel.otpVerification(otpCode: _verificationCode);
              },
            )
            ],
          ),
          ),
        );
      },
      viewModelBuilder: () => OtpViewModel(),
    );
  }
}
