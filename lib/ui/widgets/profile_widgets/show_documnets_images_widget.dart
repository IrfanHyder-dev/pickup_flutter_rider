import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShowDocumentsImagesWidget extends StatelessWidget {

  final File? image;
  final String networkImage;
  final Function() onTap;


  const ShowDocumentsImagesWidget({super.key, required this.image, required this.networkImage, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          height: 130,
          width: mediaW,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: (image != null)
                    ? FileImage(image!)
                    : Image.network(networkImage,

                    loadingBuilder: (context, child, loadingProgress) {
                  print('immmmmmmmmmmmmmmmmmmmmmmmmmmage  $loadingProgress');
                      if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                    },).image),
          ),
        ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: 40,
                width: 45,
                //color: Colors.lightBlue,
                padding: EdgeInsets.all(7),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.canvasColor, width: 1),
                    shape: BoxShape.circle,
                    color: theme.unselectedWidgetColor,
                  ),
                  child: SvgPicture.asset('assets/x-close.svg'),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
