import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/widgets/image_picker_widget.dart';
import 'package:pickup/ui/widgets/vehicle_detail/canel_image_widget.dart';

class DocumentImagesWidget extends StatefulWidget {
  final List<File> documentImagesList;
  final List<dynamic> savedDocumentImagesList;
  final Function(File image) addImage;
  final Function(int index, String listName, int? id) removeImage;

  DocumentImagesWidget(
      {super.key,
      required this.documentImagesList,
      required this.savedDocumentImagesList,
      required this.addImage,
      required this.removeImage});

  @override
  State<DocumentImagesWidget> createState() => _DocumentImagesWidgetState();
}

class _DocumentImagesWidgetState extends State<DocumentImagesWidget> {
  ScrollController docScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/vehicle_document_yellow.svg'),
        10.hSpace(),
        SizedBox(
          width: 86,
          child: Text(
            vehicleDocKey.tr,
            style: textTheme.bodyMedium!.copyWith(fontSize: 14),
          ),
        ),
        Spacer(),
        Column(
          children: [
            DottedBorder(
              radius: Radius.circular(10),
              borderType: BorderType.RRect,
              child: Container(
                height: 60,
                width: 160,
                child: (widget.documentImagesList.length == 0 &&
                        widget.savedDocumentImagesList.isEmpty)
                    ? addPhoto(
                        textStyle: textTheme.headlineSmall!.copyWith(height: 1),
                        iconWidget: SizedBox(
                            height: 19,
                            width: 19,
                            child:
                                SvgPicture.asset('assets/camera_yellow.svg')),
                      )
                    : FadingEdgeScrollView.fromScrollView(
                        child: ListView(
                        controller: docScrollController,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: [
                          if (widget.savedDocumentImagesList.isNotEmpty)
                            ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                padding: EdgeInsetsDirectional.symmetric(
                                    vertical: 0, horizontal: 10),
                                itemBuilder: (context, index) {
                                  return Center(
                                    child: Stack(
                                      //alignment: Alignment.center,
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 65,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  widget.savedDocumentImagesList[index]
                                                      .url),
                                            ),
                                          ),
                                        ),
                                        CancelImageWidget(
                                            padding: 2,
                                            containerHeight: 20,
                                            containerWidth: 25,
                                            onTap: () => widget.removeImage(
                                                index,
                                                'savedImage',
                                                widget.savedDocumentImagesList[index]
                                                    .id)),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    5.hSpace(),
                                itemCount: widget.savedDocumentImagesList.length),
                          ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              padding: EdgeInsetsDirectional.only(end: 10),
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Stack(
                                    //alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 65,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(13),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(
                                                widget.documentImagesList[index]),
                                          ),
                                        ),
                                      ),
                                      CancelImageWidget(
                                          padding: 2,
                                          containerHeight: 20,
                                          containerWidth: 25,
                                          onTap: () => widget.removeImage(
                                              index, 'documentImage', 0)),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => 5.hSpace(),
                              itemCount: widget.documentImagesList.length),
                        ],
                      )),
              ),
            ),
            if (widget.documentImagesList.length != 0 ||
                widget.savedDocumentImagesList.length != 0)
              10.vSpace(),
            if (widget.documentImagesList.length != 0 || widget.savedDocumentImagesList.length != 0)
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20))),
                    context: context,
                    builder: (context) {
                      return ImagePickerWidget(
                        shape: 2,
                        imagePath: (File? image) {
                         setState(() {
                           widget.addImage(image!);
                         });
                        },
                      );
                    },
                  );
                },
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 19,
                          width: 19,
                          child: SvgPicture.asset('assets/camera_yellow.svg')),
                      5.hSpace(),
                      Text(
                        addPhotoKey.tr,
                        style: textTheme.bodyMedium!.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
          ],
        )
      ],
    );
  }

  GestureDetector addPhoto(
      {required TextStyle textStyle, required Widget iconWidget}) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          context: Get.context!,
          builder: (context) {
            return ImagePickerWidget(
              shape: 2,
              imagePath: (File? image) {
                setState(() {
                  widget.addImage(image!);
                });
              },
            );
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconWidget,
          4.vSpace(),
          Text(
            addPhotoKey.tr,
            style: textStyle,
          )
        ],
      ),
    );
  }
}
