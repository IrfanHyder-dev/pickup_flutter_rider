import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/auth/change_password/change_password_viewmodel.dart';
import 'package:pickup/ui/widgets/button_widget.dart';
import 'package:pickup/ui/widgets/input_field_widget.dart';
import 'package:stacked/stacked.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;


  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<ChangePasswordViewModel>.reactive(
      builder: (context, viewModel, child) {
        return Scaffold(
          //resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: hMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (mediaH * 0.08).vSpace(),
                  SizedBox(
                    // height: logoH,
                    width: logoW,
                    child: Image.asset('assets/papne_cab.png'),
                    //Image.asset('assets/logo.png'),
                  ),
                  (0.038 * mediaH).vSpace(),
                  Center(
                    child: Text(changePassekey.tr,
                        style: textTheme.displayLarge,
                        textAlign: TextAlign.center),
                  ),
                  (0.06 * mediaH).vSpace(),
                  Container(
                    //color: Colors.green,
                    height: 320,
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: _autoValidate,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: margin16),
                              child: Text(
                                oldPassKey.tr,
                                style: textTheme.displayMedium,
                              ),
                            ),
                            6.vSpace(),
                            InputField(
                              fillColor: theme.primaryColorDark,
                              keyboardType: TextInputType.visiblePassword,
                              hint: enterOldPassKey.tr,
                              controller: viewModel.oldPasswordCon,
                              hintStyle: textTheme.displayMedium!
                                  .copyWith(color: theme.cardColor),
                              prefixImage: 'assets/lock_icon.svg',
                              borderRadius: 10,
                              borderColor: theme.primaryColorDark,
                              maxLines: 1,
                              obscure: true,
                              onChange: (val){
                                setState(() {

                                });
                              },
                              validator: (val) {
                                if (val.toString().isEmpty) {
                                  return 'Please enter valid password';
                                }
                              },
                            ),
                            25.vSpace(),
                            Container(
                              margin: const EdgeInsets.only(left: margin16),
                              child: Text(
                                newPassKey.tr,
                                style: textTheme.displayMedium,
                              ),
                            ),
                            6.vSpace(),
                            InputField(
                              fillColor: theme.primaryColorDark,
                              keyboardType: TextInputType.visiblePassword,
                              hint: enterNewPassKey.tr,
                              controller: viewModel.newPasswordCon,
                              hintStyle: textTheme.displayMedium!
                                  .copyWith(color: theme.cardColor),
                              prefixImage: 'assets/lock_icon.svg',
                              borderRadius: 10,
                              borderColor: theme.primaryColorDark,
                              maxLines: 1,
                              obscure: true,
                              onChange: (val){
                                setState(() {

                                });
                              },
                              validator: (val) {
                                RegExp regex = RegExp(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                if (val.toString().isEmpty) {
                                  return 'Please enter valid password';
                                }
                                else if (!regex.hasMatch(val.toString())) {
                                  //return 'Password contains at least 8 characters, including at \nleast one symbol, one number and one uppercase letter';
                                  return 'Please include 8 char, symbol, number, uppercas';
                                }
                                else {
                                  return null;
                                }
                              },
                            ),
                            25.vSpace(),
                            Container(
                              margin: const EdgeInsets.only(left: margin16),
                              child: Text(
                                cnfrmPassKey.tr,
                                style: textTheme.displayMedium,
                              ),
                            ),
                            6.vSpace(),
                            InputField(
                              fillColor: theme.primaryColorDark,
                              keyboardType: TextInputType.visiblePassword,
                              hint: enterCnfrmPassKey.tr,
                              controller: viewModel.confirmPasswordCon,
                              hintStyle: textTheme.displayMedium!
                                  .copyWith(color: theme.cardColor),
                              prefixImage: 'assets/lock_icon.svg',
                              borderRadius: 10,
                              borderColor: theme.primaryColorDark,
                              maxLines: 1,
                              obscure: true,
                              onChange: (val){
                                setState(() {

                                });
                              },
                              validator: (val) {
                                RegExp regex = RegExp(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                if (val.toString().isEmpty) {
                                  return 'Please enter valid password';
                                }
                                else if (!regex.hasMatch(val.toString())) {
                                  //return 'Password contains at least 8 characters, including at \nleast one symbol, one number and one uppercase letter';
                                  return 'Please include 8 char, symbol, number, uppercas';
                                }
                                else if(val.toString() != viewModel.newPasswordCon.text.trim()){
                                  return "Your password does not match confirm password";
                                }
                                else {
                                  return null;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  (0.047 * mediaH).vSpace(),
                  ButtonWidget(
                    radius: 76,
                    btnText: resetKey.tr,
                    textStyle: textTheme.titleLarge!
                        .copyWith(color: theme.unselectedWidgetColor),
                    onTap: (){
                      FocusScope.of(context).unfocus();
                      if(_formKey.currentState!.validate()){
                        viewModel.changePassword();
                      }else{
                        _autoValidate = AutovalidateMode.onUserInteraction;
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => ChangePasswordViewModel(),
    );
  }
}
