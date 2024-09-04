import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/widgets/image_picker_widget.dart';
import 'package:pickup/ui/widgets/vehicle_detail/canel_image_widget.dart';

class CarImagesWidget extends StatefulWidget {
  final List<File> carImageList;
  final List<dynamic> savedCarImages;
  final Function(File image) addImage;
  final Function(int index, String listName, int? id) removeImage;
  //final Widget cancelImage;
   CarImagesWidget({super.key, required this.carImageList,required this.savedCarImages ,required this.addImage, required this.removeImage});

  @override
  State<CarImagesWidget> createState() => _CarImagesWidgetState();
}

class _CarImagesWidgetState extends State<CarImagesWidget> {
  ScrollController carScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Column(children: [
      Container(
        padding:
        const EdgeInsets.symmetric(horizontal: hMargin),
        child: DottedBorder(
          radius: Radius.circular(10),
          borderType: BorderType.RRect,
          child: Container(
            height: 154,
            width: mediaW,
            //decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: (widget.carImageList.length == 0 && widget.savedCarImages.isEmpty)
                ? addPhoto(
              textStyle: textTheme.headlineSmall!
                  .copyWith(height: 1),
              iconWidget: SvgPicture.asset(
                  'assets/camera_yellow.svg'),
            )
                : Column(
              children: [
                SizedBox(
                  height: 125,
                  width: mediaW,
                  child: FadingEdgeScrollView
                      .fromScrollView(
                      child: ListView(
                        controller:
                        carScrollController,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: [
                          if(widget.savedCarImages.isNotEmpty)
                            ListView.separated(

                                physics:
                                const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis
                                    .horizontal,
                                padding:
                                EdgeInsetsDirectional
                                    .only(
                                    start: 13,
                                    end: 13,
                                    top: 22),
                                itemBuilder:
                                    (context, index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        height: 101,
                                        width: 102,
                                        decoration:
                                        BoxDecoration(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              13),
                                          image:
                                          DecorationImage(
                                            fit: BoxFit
                                                .cover,
                                            image: NetworkImage(widget.savedCarImages[index].url),
                                          ),
                                        ),
                                      ),
                                      //widget.cancelImage,
                                      CancelImageWidget(padding: 3, containerHeight: 25, containerWidth: 30, onTap:()=> widget.removeImage(index, 'vehicleImages',widget.savedCarImages[index].id ),),
                                    ],
                                  );
                                },
                                separatorBuilder:
                                    (context, index) =>
                                    15.hSpace(),
                                itemCount:
                               widget.savedCarImages.length),
                          ListView.separated(
                              physics:
                              const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis
                                  .horizontal,
                              padding:
                              EdgeInsetsDirectional
                                  .only(
                                  start: 0,
                                  end: 13,
                                  top: 22),
                              itemBuilder:
                                  (context, index) {
                                return Stack(
                                  children: [
                                    Container(
                                      height: 101,
                                      width: 102,
                                      decoration:
                                      BoxDecoration(
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            13),
                                        image:
                                        DecorationImage(
                                          fit: BoxFit
                                              .cover,
                                          image: FileImage(
                                              widget.carImageList[
                                              index]),
                                        ),
                                      ),
                                    ),
                                    CancelImageWidget(padding: 3, containerHeight: 25, containerWidth: 30, onTap:()=> widget.removeImage( index, 'carImages',0)),
                                  ],
                                );
                              },
                              separatorBuilder:
                                  (context, index) =>
                                  15.hSpace(),
                              itemCount:
                              widget.carImageList.length),
                        ],
                      )),
                ),
                11.vSpace(),
                Text(
                  '${widget.carImageList.length + widget.savedCarImages.length} ${photoAddedKey.tr}',
                  style: textTheme.displaySmall!
                      .copyWith(color: theme.cardColor),
                )
              ],
            ),
          ),
        ),
      ),
      16.vSpace(),
      if (widget.carImageList.length != 0 || widget.savedCarImages.length != 0)
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
                      //widget.carImageList.add(image!);
                    });
                  },
                );
              },
            );
          },
          child: Container(
            height: 40,
            width: mediaW,
            margin: EdgeInsets.symmetric(horizontal: hMargin),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: theme.cardColor.withOpacity(0.3),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/camera_grey.svg'),
                10.hSpace(),
                Text(
                  addPhotoKey.tr,
                  style: textTheme.headlineSmall,
                )
              ],
            ),
          ),
        ),
    ],);
  }
  GestureDetector addPhoto(
      {required TextStyle textStyle,
        required Widget iconWidget}) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
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
