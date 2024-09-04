// import 'package:flutter/services.dart';
//
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:pickup/services/common_ui_service.dart';
// import 'package:pickup/src/app/extensions.dart';
// import 'constants.dart';
//
// class Utils {
//
//   static Future<String?> pickAndCropImage(
//       {ImageSource imageSource = ImageSource.gallery}) async {
//     try {
//       XFile? picked = await ImagePicker().pickImage(source: imageSource);
//       if (picked != null) {
//         var cropped = await ImageCropper.platform.cropImage(
//           sourcePath: picked.path,
//           cropStyle: CropStyle.circle,
//           compressQuality: 50,
//           aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
//         );
//         if (cropped != null) {
//           return cropped.path;
//         }
//       }
//       return null;
//     } on PlatformException catch (e) {
//       if (e.code == "photo_access_denied") {
//         CommonUiService().showSnackBar(
//             "Please give library permission from system settings",
//             SnackBarType.error);
//       } else if (e.code == "camera_access_denied") {
//         CommonUiService().showSnackBar(
//             "Please give camera permission from system settings",
//             SnackBarType.error);
//       } else {
//         e.code.debugPrint();
//         CommonUiService().showSnackBar(
//             e.message ?? "Some error occurred", SnackBarType.error);
//       }
//       return null;
//     }
//   }
//
//   static setStatusBarColor(Color color) {
//     SystemChrome.setSystemUIOverlayStyle(
//         SystemUiOverlayStyle(statusBarColor: color));
//   }
// }
