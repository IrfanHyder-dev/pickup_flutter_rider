import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/alarm/alarm/alarm_view.dart';
import 'package:pickup/ui/views/auth/change_password/change_password_view.dart';
import 'package:pickup/ui/views/auth/login/login_view.dart';
import 'package:pickup/ui/views/notification/notification_view.dart';
import 'package:pickup/ui/views/profile/driver_profile/driver_profile_view.dart';
import 'package:pickup/ui/views/settings/settings_viewmodel.dart';
import 'package:pickup/ui/widgets/app_bar_widget.dart';
import 'package:stacked/stacked.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<SettingsViewModel>.reactive(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBarWidget(
              title: settingKey.tr,
              titleStyle: textTheme.titleLarge!,
              // leadingIcon: 'assets/back_arrow_light.svg',
              // leadingIconOnTap: () => Get.back(),
              actionIcon: 'assets/black_bell_icon.svg',
              actonIconOnTap: () => Get.to(() => const NotificationView()),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: hMargin),
            child: Column(
              children: [
                (0.048 * mediaH).vSpace(),
                GestureDetector(
                  onTap: () => Get.to(() => const DriverProfileView()),
                  child: settingOptions(
                    textTheme: textTheme,
                    text: profileKey.tr,
                    image: 'assets/right_angle_icon.svg',
                  ),
                ),
                settingOptions(
                    textTheme: textTheme,
                    text: deleteKey.tr,
                    image: 'assets/right_angle_icon.svg'),
                GestureDetector(
                  onTap: (){
                    Get.to(()=> ChangePasswordView());
                  },
                  child: settingOptions(
                      textTheme: textTheme,
                      text: changePassekey.tr,
                      image: 'assets/right_angle_icon.svg'),
                ),
                settingOptions(
                    textTheme: textTheme,
                    text: pushNotiKey.tr,
                    toggellButton: Switch(
                        activeTrackColor: theme.primaryColor,
                        activeColor: theme.unselectedWidgetColor,
                        value: viewModel.value,
                        onChanged: (val) {
                          viewModel.switchButtonOnChange(val);
                        })),
                GestureDetector(
                  onTap: ()=> Get.to(()=> AlarmView()),
                  child: settingOptions(
                      textTheme: textTheme,
                      text: alarmKey.tr,
                      image: 'assets/right_angle_icon.svg'),
                ),
                GestureDetector(
                  onTap: () {
                    viewModel.logout();
                    Get.offAll(() => LoginView());
                  },
                  child: settingOptions(
                      textTheme: textTheme, text: logoutKey.tr, image: ''),
                ),
                Divider(
                  color: theme.dividerColor,
                  thickness: 1,
                  height: 0,
                )
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => SettingsViewModel(),
    );
  }

  Widget settingOptions({
    required TextTheme textTheme,
    required String text,
    String? image,
    Function()? onTap,
    Widget? toggellButton,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: Theme.of(context).dividerColor))),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: textTheme.displayMedium!.copyWith(fontSize: 16),
            ),
            const Spacer(),
            if (image != null)
              (image.isNotEmpty) ? SvgPicture.asset(image) : Container(),
            if (toggellButton != null) toggellButton,
          ],
        ),
      ),
    );
  }
}
