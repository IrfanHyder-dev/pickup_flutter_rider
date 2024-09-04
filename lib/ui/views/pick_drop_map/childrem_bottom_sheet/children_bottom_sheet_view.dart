import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/enums/app_enums.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/src/theme/base_theme.dart';
import 'package:pickup/ui/views/pick_drop_map/pick_drop_map_viewModel.dart';
import 'dart:math' as math;

import 'package:pickup/ui/widgets/button_widget.dart';
import 'package:pickup/ui/widgets/loading_widget.dart';

class ChildrenBottomSheet extends StatelessWidget {
  final PickDropMapViewModel viewModel;

  const ChildrenBottomSheet({super.key, required this.viewModel});

  final Color firstGradientColor = lightThemeFirstGradientColor;
  final Color secondGradientColor = lightThemeSecondGradientColor;

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return bottomSheetWidget(viewModel, mediaW, theme, mediaH, textTheme);
  }

  Widget bottomSheetWidget(PickDropMapViewModel viewModel, double mediaW,
      ThemeData theme, double mediaH, TextTheme textTheme) {
    return GestureDetector(
      onVerticalDragUpdate: viewModel.handleSwipe,
      child: Container(
        padding: EdgeInsetsDirectional.only(start: hMargin, end: hMargin),
        height: viewModel.containerHeight,
        width: mediaW,
        color: theme.unselectedWidgetColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (mediaH * 0.01).vSpace(),
            bottomSheetHeader(),
            if (viewModel.pickedChildLength ==
                (viewModel.childDetails?.fetchedChildList?.length ?? 0)) ...[
              (mediaH * 0.02).vSpace(),
              selectAllPickedChildren(textTheme, viewModel, theme),
            ],
            (mediaH * 0.02).vSpace(),
            childrenList(viewModel, theme, textTheme),
            if (viewModel.containerHeight >= 130)
              finishRideButton(viewModel, textTheme, theme),
            (mediaH * 0.01).vSpace(),
          ],
        ),
      ),
    );
  }

  Widget selectAllPickedChildren(
      TextTheme textTheme, PickDropMapViewModel viewModel, ThemeData theme) {
    return Row(
      children: [
        Text(
          selectAllKey.tr,
          style: textTheme.displayMedium,
        ),
        Spacer(),
        GestureDetector(
          onTap: viewModel.selectAllCheckBox,
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              height: 24,
              width: 24,
              child: Center(
                child: Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: (viewModel.isSelected)
                        ? theme.primaryColor
                        : darkThemeResendBtn,
                    image: (viewModel.isSelected)
                        ? DecorationImage(
                            image: Image.asset('assets/check.png').image)
                        : null,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget finishRideButton(
      PickDropMapViewModel viewModel, TextTheme textTheme, ThemeData theme) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: ButtonWidget(
        btnText: viewModel.finishRideBtnText(),
        textStyle: textTheme.titleLarge!
            .copyWith(color: theme.unselectedWidgetColor, fontSize: 16),
        radius: 84,
        bgColor: (viewModel.pickedChildLength ==
                    (viewModel.childDetails?.fetchedChildList?.length ?? 0) ||
                viewModel.droppedChildLength ==
                    (viewModel.childDetails?.fetchedChildList?.length ?? 0))
            ? darkThemeTextColor
            : darkThemeResendBtn,
        verticalPadding: 8,
        horizontalPadding: 12,
        onTap: () => viewModel.onTapFinishRideBtn(),
      ),
    );
  }

  Widget childrenList(
      PickDropMapViewModel viewModel, ThemeData theme, TextTheme textTheme) {
    return Expanded(
      child: FadingEdgeScrollView.fromScrollView(
        child: ListView.separated(
          controller: viewModel.scrollController,
          itemCount: viewModel.childDetails?.fetchedChildList?.length ?? 0,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(right: 0, bottom: 0, left: 0, top: 12),
          itemBuilder: (context, index) {
            bool disableField = viewModel
                        .childDetails!.fetchedChildList![index].rideStatus ==
                    ArrivalStatus.dropped ||
                viewModel.childDetails!.fetchedChildList![index].rideStatus ==
                    ArrivalStatus.not_going;
            bool disableSkipBtn = viewModel
                        .childDetails!.fetchedChildList![index].rideStatus ==
                    ArrivalStatus.picked ||
                viewModel.childDetails!.fetchedChildList![index].rideStatus ==
                    ArrivalStatus.dropped ||
                viewModel.childDetails!.fetchedChildList![index].rideStatus ==
                    ArrivalStatus.not_going;
            return Stack(
              alignment: Alignment.topRight,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: theme.cardColor,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        firstGradientColor.withOpacity(0.5),
                        secondGradientColor.withOpacity(0.5),
                      ],
                      begin: const Alignment(-1.0, 0.0),
                      end: const Alignment(1.0, 0.0),
                      transform: const GradientRotation(math.pi / 4),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 2, color: theme.unselectedWidgetColor),
                              image: DecorationImage(
                                  image: Image.asset(
                                          'assets/person_placeholder.png',
                                          fit: BoxFit.fitWidth)
                                      .image)),
                        ),
                        5.hSpace(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 115,
                              child: Text(
                                viewModel.childDetails!.fetchedChildList![index].child
                                        ?.name ??
                                    '',
                                style: textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            3.vSpace(),
                            Text(
                              '5 Minutes',
                              style: textTheme.displaySmall!.copyWith(
                                  fontWeight: FontWeight.w300, height: 1),
                            ),
                          ],
                        ),
                        Spacer(),
                        SizedBox(
                          width: 50,
                          height: 35,
                          child: ButtonWidget(
                            radius: 15,
                            btnText: skipChildBtnTextKey.tr,
                            textStyle: textTheme.displaySmall!.copyWith(
                                fontSize: 11,
                                color: theme.unselectedWidgetColor),
                            horizontalPadding: 0,
                            verticalPadding: 0,
                            bgColor: (disableSkipBtn)
                                ? darkThemeResendBtn.withOpacity(0.5)
                                : redColor,
                            onTap: () {
                              if (!disableSkipBtn) {
                                CustomDialog.showSettingDialog(
                                  context: context,
                                  infoText:
                                      "${skipChildDialogInfoTextKey.tr} ${viewModel.childDetails!.fetchedChildList![index].child?.name ?? ''}",
                                  showSecondBtn: true,
                                  secondBtnText: skipChildBtnTextKey.tr,
                                  onTapBtn: () async {
                                    Get.back();
                                    viewModel.skipChild(
                                        context: context,
                                        indexOfFetchChildList: index,
                                        quotationId: viewModel.childDetails
                                                ?.fetchedChildList?[index].quotationId ??
                                            0,
                                        childId: viewModel.childDetails
                                                ?.fetchedChildList?[index].child?.id ??
                                            0);
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        7.hSpace(),
                        SizedBox(
                          width: 70,
                          child: ButtonWidget(
                            radius: 60,
                            btnText: viewModel.btnText(index),
                            textStyle: textTheme.displaySmall!.copyWith(
                                fontSize: 11,
                                color: theme.unselectedWidgetColor),
                            horizontalPadding: 0,
                            verticalPadding: 0,
                            bgColor: (disableField)
                                ? darkThemeResendBtn.withOpacity(0.5)
                                : null,
                            onTap: () {
                              if (!disableField) {
                                viewModel.onTapRideStatus(
                                    isAllSelected: false, index: index);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (viewModel.pickedChildLength ==
                    viewModel.childDetails!.fetchedChildList!.length)
                  Positioned(
                    top: -12,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => viewModel.checkBoxStatus(index),
                      child: Container(
                        height: 24,
                        width: 24,
                        // color:Colors.pink,
                        child: Center(
                          child: Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: (viewModel.childDetails!
                                      .fetchedChildList![index].child!.isSelected!)
                                  ? theme.primaryColor
                                  : darkThemeResendBtn,
                              image: (viewModel.childDetails!
                                      .fetchedChildList![index].child!.isSelected!)
                                  ? DecorationImage(
                                      image:
                                          Image.asset('assets/check.png').image)
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            );
          },
          separatorBuilder: (context, index) => 10.vSpace(),
        ),
      ),
    );
  }

  Widget bottomSheetHeader() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 6,
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: darkThemeResendBtn,
        ),
      ),
    );
  }
}
