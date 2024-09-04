import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/ui/widgets/image_picker_widget.dart';

class SelectDocumentImageWidget extends StatelessWidget {
  final String title;
  final Function(File image) addImage;
  final Color borderColor;
  final bool showErrorMessage;
  final String errorMessage;
  const SelectDocumentImageWidget({super.key, required this.title, required this.addImage, required this.borderColor, required this.errorMessage, required this.showErrorMessage});

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20), topLeft: Radius.circular(20))),
              context: context,
              builder: (context) {
                return ImagePickerWidget(shape: 2,imagePath: (File? image) {
                  print('child result is $image');
                  addImage(image!);
                });
              },
            );
          },
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(20),
            color: borderColor,
            child: Container(
              height: 130,
              width: mediaW,
              //decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/camera_yellow.svg'),
                  4.vSpace(),
                  Text(
                    title,
                    style: textTheme.headlineSmall!.copyWith(height: 1),
                  )
                ],
              ),
            ),
          ),
        ),
        7.vSpace(),
        if(showErrorMessage)
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 20),
          child: Text(errorMessage, style: textTheme.bodySmall!.copyWith(color: Colors.red),),
        )
      ],
    );
  }
}
