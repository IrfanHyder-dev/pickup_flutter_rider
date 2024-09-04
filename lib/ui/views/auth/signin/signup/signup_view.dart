import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/auth/login/login_view.dart';
import 'package:pickup/ui/views/auth/signin/signup/signup_viewmodel.dart';
import 'package:pickup/ui/widgets/button_widget.dart';
import 'package:pickup/ui/widgets/form_field_heading_widget.dart';
import 'package:pickup/ui/widgets/input_field_widget.dart';
import 'package:stacked/stacked.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  final ScrollController formScrollController = ScrollController();
  final ScrollController screenScrollController = ScrollController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController surNameCon = TextEditingController();
  TextEditingController phoneCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<SignUpViewModel>.reactive(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (mediaH * 0.08).vSpace(),
              SizedBox(
                // height: logoH,
                width: logoW,
                child: Image.asset('assets/papne_cab.png'),
              ),
              (mediaH * 0.038).vSpace(),
              Center(
                  child: Text(
                signUpKey.tr,
                style: textTheme.displayLarge!.copyWith(fontSize: 35),
              )),
              (mediaH * 0.015).vSpace(),
              Text(
                signUpSubKey.tr,
                style:
                    textTheme.displayMedium!.copyWith(color: theme.canvasColor),
              ),
              (mediaH * 0.059).vSpace(),
              Expanded(
                child: FadingEdgeScrollView.fromSingleChildScrollView(
                  child: SingleChildScrollView(
                    controller: formScrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: hMargin),
                    //padding: const EdgeInsets.only(top: 10, bottom: 10, left: margin38, right: margin38),
                    child: Form(
                        key: _formKey,
                        autovalidateMode: _autoValidate,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FormFieldHeadingWidget(headingText: nameKey.tr),
                            6.vSpace(),
                            InputField(
                              fillColor: theme.primaryColorDark,
                              keyboardType: TextInputType.text,
                              hint: enterNameKey.tr,
                              controller: nameCon,
                              textInputAction: TextInputAction.next,
                              hintStyle: textTheme.displayMedium!
                                  .copyWith(color: theme.cardColor),
                              prefixImage: 'assets/user.svg',
                              borderRadius: 10,
                              borderColor: theme.primaryColorDark,
                              maxLines: 1,
                              validator: viewModel.nameValidator,
                            ),
                            26.vSpace(),
                            FormFieldHeadingWidget(headingText: surNameKey.tr),
                            6.vSpace(),
                            InputField(
                              fillColor: theme.primaryColorDark,
                              keyboardType: TextInputType.text,
                              hint: enterSurNamKey.tr,
                              controller: surNameCon,
                              textInputAction: TextInputAction.next,
                              hintStyle: textTheme.displayMedium!
                                  .copyWith(color: theme.cardColor),
                              prefixImage: 'assets/person_icon.svg',
                              borderRadius: 10,
                              borderColor: theme.primaryColorDark,
                              maxLines: 1,
                              validator: viewModel.surNameValidator,
                            ),
                            26.vSpace(),
                            FormFieldHeadingWidget(headingText: phoneNumKey.tr),
                            6.vSpace(),
                            InputField(
                              fillColor: theme.primaryColorDark,
                              keyboardType: TextInputType.phone,
                              hint: '3XXXXXXXXX',
                              controller: phoneCon,
                              textInputAction: TextInputAction.next,
                              maxLength: 10,
                              hintStyle: textTheme.displayMedium!
                                  .copyWith(color: theme.cardColor),
                              prefixWidget: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  5.hSpace(),
                                  SvgPicture.asset('assets/flag.svg'),
                                  5.hSpace(),
                                  Text(
                                    '+92',
                                    style: textTheme.displayMedium,
                                  ),
                                  5.hSpace()
                                ],
                              ),
                              borderRadius: 10,
                              borderColor: theme.primaryColorDark,
                              maxLines: 1,
                              validator: viewModel.phoneValidator,
                            ),
                            26.vSpace(),
                            FormFieldHeadingWidget(
                                headingText: emailAddressKey.tr),
                            6.vSpace(),
                            InputField(
                              fillColor: theme.primaryColorDark,
                              keyboardType: TextInputType.emailAddress,
                              hint: enterEmailKey.tr,
                              controller: emailCon,
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
                              controller: passwordCon,
                              textInputAction: TextInputAction.done,
                              hintStyle: textTheme.displayMedium!
                                  .copyWith(color: theme.cardColor),
                              prefixImage: 'assets/lock_icon.svg',
                              borderRadius: 10,
                              borderColor: theme.primaryColorDark,
                              maxLines: 1,
                              obscure: true,
                              onChange: (val) {},
                              validator: viewModel.passwordValidator,
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            height: mediaH * 0.13,
            padding: const EdgeInsetsDirectional.only(start: 35, end: 23),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: haveAnAccountKey.tr,
                      style: textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: loginKey.tr,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          FocusScope.of(context).unfocus();
                          Get.to(() => const LoginView());
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
                btnText: signUpKey.tr,
                textStyle: textTheme.titleLarge!
                    .copyWith(color: theme.unselectedWidgetColor),
                radius: 76,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  if (_formKey.currentState!.validate()) {
                    viewModel.signUpParent(
                      name: nameCon.text.trim(),
                      surName: surNameCon.text.trim(),
                      phoneNumber: phoneCon.text.trim(),
                      email: emailCon.text.trim(),
                      password: passwordCon.text.trim(),
                    );
                  } else {
                    _autoValidate = AutovalidateMode.onUserInteraction;
                  }
                },
              )
            ]),
          ),
        );
      },
      viewModelBuilder: () => SignUpViewModel(),
    );
  }
}
