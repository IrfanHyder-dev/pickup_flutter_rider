import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:image_cropper/image_cropper.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(File image) imagePath;
  final int? shape;

  const ImagePickerWidget({super.key, required this.imagePath, this.shape});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;
  File? _galleryImage;

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.unselectedWidgetColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(top: (mediaH * 0.085)),
        child: Wrap(
          children: [
            //(mediaH * 0.092).vSpace(),
            InkWell(
              onTap: () async {
                Get.back();
                XFile? result = await _picker.pickImage(
                    source: ImageSource.camera, imageQuality: 100);

                if (result != null) {
                  CroppedFile? croppedImage = await ImageCropper().cropImage(
                    sourcePath: result!.path,
                    cropStyle:(widget.shape ==2)?CropStyle.rectangle :CropStyle.circle,
                    aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 2),
                    uiSettings: [
                      AndroidUiSettings(
                          toolbarTitle: 'Cropper',
                          toolbarColor: Colors.deepOrange,
                          toolbarWidgetColor: Colors.white,
                          lockAspectRatio: false),
                      IOSUiSettings(
                        title: 'Cropper',
                      ),
                    ],
                  );
                  if (croppedImage != null) {
                    widget.imagePath(File(croppedImage.path));
                  }
                }
              },
              child: Container(
                  height: 40,
                  padding: const EdgeInsetsDirectional.only(start: 28),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/yellow_camera_icon.svg'),
                      14.hSpace(),
                      Text(
                        openCameraKey.tr,
                        style: textTheme.displayMedium,
                      )
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: hMargin),
              child: Divider(
                color: theme.dividerColor,
              ),
            ),
            InkWell(
              onTap: () async {
                Get.back();
                XFile? result = await _picker.pickImage(
                    source: ImageSource.gallery, imageQuality: 100);
                if (result != null) {
                  CroppedFile? croppedImage = await ImageCropper().cropImage(
                    sourcePath: result!.path,
                    cropStyle:(widget.shape ==2)?CropStyle.rectangle :CropStyle.circle,
                    aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 2),
                    uiSettings: [
                      AndroidUiSettings(
                          toolbarTitle: 'Cropper',
                          toolbarColor: Colors.deepOrange,
                          toolbarWidgetColor: Colors.white,
                          lockAspectRatio: false),
                      IOSUiSettings(
                        title: 'Cropper',
                      ),
                    ],
                  );
                  if (croppedImage != null) {
                    widget.imagePath(File(croppedImage.path));
                  }
                }
                //Get.back();
              },
              child: Container(
                  height: 40,
                  padding: const EdgeInsetsDirectional.only(start: 28),
                  margin: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/yellow_gallery_icon.svg'),
                      14.hSpace(),
                      Text(
                        openGalleryKey.tr,
                        style: textTheme.displayMedium,
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
