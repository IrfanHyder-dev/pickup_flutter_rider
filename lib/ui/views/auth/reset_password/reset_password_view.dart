import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/auth/reset_password/reset_password_viewmodel.dart';
import 'package:pickup/ui/widgets/button_widget.dart';
import 'package:pickup/ui/widgets/input_field_widget.dart';
import 'package:stacked/stacked.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;


  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<ResetPasswordViewModel>.reactive(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: SizedBox(
            height: mediaH,
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
                    child: Text(resetPassKey.tr,
                        style: textTheme.displayLarge,
                        textAlign: TextAlign.center),
                  ),
                  (0.1 * mediaH).vSpace(),
                  Form(
                    key: _formKey,
                    autovalidateMode: _autoValidate,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: margin16),
                          child: Text(
                            emailAddressKey.tr,
                            style: textTheme.displayMedium,
                          ),
                        ),
                        6.vSpace(),
                        InputField(
                          fillColor: theme.primaryColorDark,
                          keyboardType: TextInputType.emailAddress,
                          hint: enterEmailKey.tr,
                          controller: viewModel.emailCon,
                          textInputAction: TextInputAction.next,
                          hintStyle: textTheme.displayMedium!
                              .copyWith(color: theme.cardColor),
                          prefixImage: 'assets/mail_icon.svg',
                          borderRadius: 10,
                          borderColor: theme.primaryColorDark,
                          maxLines: 1,
                          validator: viewModel.emailValidator,
                        ),
                      ],
                    ),
                  ),
                  (0.047 * mediaH).vSpace(),
                  ButtonWidget(
                    radius: 76,
                    btnText: submitKey.tr,
                    textStyle: textTheme.titleLarge!
                        .copyWith(color: theme.unselectedWidgetColor),
                    onTap: (){
                      FocusScope.of(context).unfocus();
                      if(_formKey.currentState!.validate()){
                        viewModel.resetPassword();
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
      viewModelBuilder: () => ResetPasswordViewModel(),
    );
  }
}
