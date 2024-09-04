import 'package:get/get.dart';
import 'package:pickup/models/user_model.dart';
import 'package:pickup/services/auth_service.dart';
import 'package:pickup/services/common_ui_service.dart';
import 'package:pickup/services/shared_preference.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/locator.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/bottom_bar/bottom_bar_view.dart';
import 'package:pickup/ui/views/profile/driver_profile/driver_profile_view.dart';
import 'package:pickup/ui/views/welcome/welcome_view.dart';
import 'package:stacked/stacked.dart';

class SplashViewModel extends BaseViewModel with CommonUiService {
  AuthService authService = locator<AuthService>();

  initialise() async {
    UserModel? newModel = SharedPreferencesService().getUser();
    if (newModel == null) {
      Future.delayed(
          const Duration(seconds: 5), () => Get.off(() => const WelcomeView()));
    } else {
      bool connectivity = await check();
      if (connectivity) {
        bool result =
            await authService.authTokenVerification(newModel.data.authToken!);

        if (result) {
          Future.delayed(Duration(seconds: 5), () {
            StaticInfo.driverModel = newModel.data.driver;
            StaticInfo.vehicleModel = newModel.data.vehicle;
            StaticInfo.authToken = newModel.data.authToken;
            if (StaticInfo.driverModel!.isProfileCompleted) {
              Get.offAll(
                () => BottomBarView(index: 2),
              );
            } else {
              Get.offAll(() => const DriverProfileView());
            }
          });
        } else {
          Future.delayed(const Duration(seconds: 5),
              () => Get.off(() => const WelcomeView()));
        }
      } else {
        showCustomWarningTextToast(
            context: Get.context!, text: checkInternetKey.tr);
      }
    }
  }

// Future driverLogin({required String email, required String phoneNo, required String password}) async {
//   LoadingWidget.showLoadingDialog(Get.context!);
//   bool connection = await check();
//   if(connection){
//
//     http.Response response = await authService.loginDriver(
//         email: email, phoneNo: phoneNo, password: password);
//
//     if (response.statusCode == 200) {
//       var decodedResponse = jsonDecode(response.body);
//       if (decodedResponse['success']) {
//         NewModel newModel = NewModel.fromJson(decodedResponse);
//         StaticInfo.userModel = newModel.data.driver;
//         StaticInfo.vehicleModel = newModel.data.vehicle;
//         StaticInfo.authToken = newModel.data.authToken;
//         SharedPreferencesService().saveUser(newModel);
//         Get.back();
//         if (StaticInfo.userModel!.isProfileCompleted) {
//           Get.offAll(
//                 () => BottomBarView(index: 2),
//           );
//         } else {
//           Get.offAll(() => const DriverProfileView());
//         }
//       } else {
//         Get.back();
//         showCustomErrorTextToast(
//             context: Get.context!, text: decodedResponse['message']);
//       }
//     } else {
//       ApiErrorsMessage().showApiErrorsMessage(response.statusCode);
//     }
//   }else{
//     Get.back();
//     showCustomWarningTextToast(
//         context: Get.context!, text: checkInternetKey.tr);
//   }
// }
}
