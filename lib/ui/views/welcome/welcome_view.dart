import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/auth/login/login_view.dart';
import 'package:pickup/ui/views/auth/signin/signup/signup_view.dart';
import 'package:pickup/ui/views/welcome/welcome_viewmodel.dart';
import 'package:pickup/ui/widgets/button_widget.dart';
import 'package:stacked/stacked.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.);
    // SystemChrome.restoreSystemUIOverlays();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<WelcomeViewmodel>.reactive(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Container(
            child: Column(
              children: [
                (mediaH * 0.3).vSpace(),
                SizedBox(
                    // height: 63,
                    width: 180,
                    child: Image.asset('assets/papne_cab.png')),
                (mediaH * 0.04).vSpace(),
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 47),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Welcome to ',
                            style: textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.w400, fontSize: 26),
                          ),
                          TextSpan(
                            text: 'Papne',
                            recognizer: TapGestureRecognizer(),
                            style: textTheme.titleLarge!.copyWith(
                                color: theme.primaryColor,
                                fontSize: 30,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                (mediaH * 0.06).vSpace(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 37),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 48,
                        width: 136,
                        child: ButtonWidget(
                          radius: 76,
                          verticalPadding: 0,
                          horizontalPadding: 0,
                          btnText: loginKey.tr,
                          textStyle: textTheme.titleLarge!
                              .copyWith(color: theme.scaffoldBackgroundColor),
                          onTap: () {
                            Get.to(() => const LoginView());
                          },
                        ),
                      ),
                      14.hSpace(),
                      SizedBox(
                        height: 48,
                        width: 136,
                        child: ButtonWidget(
                          radius: 76,
                          verticalPadding: 0,
                          horizontalPadding: 0,
                          btnText: signUpKey.tr,
                          textStyle: textTheme.titleLarge!
                              .copyWith(color: theme.scaffoldBackgroundColor),
                          onTap: () {
                            Get.to(const SignUpView());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // (mediaH * 0.064).vSpace(),
                // Container(
                //   margin: const EdgeInsets.symmetric(horizontal: 20),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //       Container(height: 2,width: 143,color: theme.dividerColor,),
                //       6.hSpace(),
                //       Text(orKey.tr,style: textTheme.displayMedium,),
                //       6.hSpace(),
                //       Container(height: 2,width: 143,color: theme.dividerColor,),
                //     ],))
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => WelcomeViewmodel(),
    );
  }
}
