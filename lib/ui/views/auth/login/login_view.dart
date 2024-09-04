import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/auth/login/login_viewmodel.dart';
import 'package:pickup/ui/views/auth/reset_password/reset_password_view.dart';
import 'package:pickup/ui/views/auth/signin/signup/signup_view.dart';
import 'package:pickup/ui/widgets/button_widget.dart';
import 'package:pickup/ui/widgets/form_field_heading_widget.dart';
import 'package:pickup/ui/widgets/input_field_widget.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<LoginViewModel>.reactive(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: FadingEdgeScrollView.fromSingleChildScrollView(
            child: SingleChildScrollView(
              controller: viewModel.scrollController,
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                height: mediaH,
                child: Column(
                  children: [
                    (mediaH * 0.08).vSpace(),
                    SizedBox(
                      // height: logoH,
                      width: logoW,
                      child: Image.asset('assets/papne_cab.png'),
                    ),
                    (0.038 * mediaH).vSpace(),
                    Center(
                      child: Text(
                        loginKey.tr,
                        style: textTheme.displayLarge,
                      ),
                    ),
                    (0.015 * mediaH).vSpace(),
                    Text(
                      welcomeBcKey.tr,
                      style: textTheme.displayMedium!
                          .copyWith(color: theme.canvasColor),
                    ),
                    (0.12 * mediaH).vSpace(),
                    Container(
                      height: mediaH * 0.34,
                      margin: const EdgeInsets.symmetric(horizontal: hMargin),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: _autoValidate,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FormFieldHeadingWidget(
                                headingText: enteremailMobKey.tr),
                            6.vSpace(),
                            InputField(
                              fillColor: theme.primaryColorDark,
                              keyboardType: TextInputType.emailAddress,
                              hint: enterEmailKey.tr,
                              controller: viewModel.emailPhoneCon,
                              textInputAction: TextInputAction.next,
                              hintStyle: textTheme.displayMedium!
                                  .copyWith(color: theme.cardColor),
                              prefixImage: 'assets/mail_icon.svg',
                              borderRadius: 10,
                              borderColor: theme.primaryColorDark,
                              maxLines: 1,
                              validator: viewModel.emailValidator,
                            ),
                            26.vSpace(),
                            FormFieldHeadingWidget(headingText: passwordKey.tr),
                            6.vSpace(),
                            InputField(
                              fillColor: theme.primaryColorDark,
                              keyboardType: TextInputType.visiblePassword,
                              hint: enterPasswordKey.tr,
                              controller: viewModel.passwordCon,
                              textInputAction: TextInputAction.done,
                              hintStyle: textTheme.displayMedium!
                                  .copyWith(color: theme.cardColor),
                              prefixImage: 'assets/lock_icon.svg',
                              borderRadius: 10,
                              borderColor: theme.primaryColorDark,
                              maxLines: 1,
                              obscure: true,
                              onChange: (val) {
                                setState(() {});
                              },
                              validator: viewModel.passwordValidator,
                            ),
                            //36.vSpace(),
                            (0.03 * mediaH).vSpace(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                child: Text(
                                  forgotPassKey.tr,
                                  style: textTheme.titleMedium!
                                      .copyWith(color: theme.primaryColor),
                                ),
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  Get.to(const ResetPasswordView());
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.only(start: 38, end: 25),
                      child: Container(
                        height: mediaH * 0.13,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "${needAnAcKey.tr}\n",
                                      style: textTheme.displayMedium!.copyWith(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text: signUpKey.tr,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          FocusScope.of(context).unfocus();
                                          Get.to(() => const SignUpView());
                                        },
                                      style: textTheme.displayMedium!.copyWith(
                                          color: theme.primaryColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              ButtonWidget(
                                height: 48,
                                width: 142,
                                btnText: loginKey.tr,
                                textStyle: textTheme.titleLarge!.copyWith(
                                    color: theme.unselectedWidgetColor),
                                radius: 76,
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    viewModel.driverLogin();
                                  } else {
                                    _autoValidate =
                                        AutovalidateMode.onUserInteraction;
                                  }
                                  FocusScope.of(context).unfocus();
                                },
                              )
                            ]),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => LoginViewModel(),
    );
  }
}
