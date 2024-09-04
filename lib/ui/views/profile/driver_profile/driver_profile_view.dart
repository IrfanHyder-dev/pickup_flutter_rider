import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/profile/current_location/current_location_view.dart';
import 'package:pickup/ui/views/profile/driver_profile/driver_profile_viewmodel.dart';
import 'package:pickup/ui/widgets/app_bar_widget.dart';
import 'package:pickup/ui/widgets/button_widget.dart';
import 'package:pickup/ui/widgets/image_picker_widget.dart';
import 'package:pickup/ui/widgets/input_field_widget.dart';
import 'package:pickup/ui/widgets/pop_scope_dialog_widget.dart';
import 'package:pickup/ui/widgets/profile_widgets/location_suggestion_widget.dart';
import 'package:pickup/ui/widgets/profile_widgets/select_document_image_widget.dart';
import 'package:pickup/ui/widgets/profile_widgets/show_documnets_images_widget.dart';
import 'package:stacked/stacked.dart';

class DriverProfileView extends StatefulWidget {
  const DriverProfileView({super.key});

  @override
  State<DriverProfileView> createState() => _DriverProfileViewState();
}

class _DriverProfileViewState extends State<DriverProfileView> {
  final _addressKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateAddress = AutovalidateMode.disabled;
  AutovalidateMode _autoValidateName = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<DriverProfileViewModel>.reactive(
      builder: (context, viewModel, child) {
        return WillPopScope(
          onWillPop: () async {
            bool? shouldPop;
            (Navigator.canPop(context))
                ? Get.back()
                : shouldPop = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return PopScopeDialogWidget();
                    },
                  );
            if (shouldPop == true) {
              MoveToBackground.moveTaskToBack();
              return false;
            } else {
              return false;
            }
          },
          child: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AppBarWidget(
                title: profileKey.tr,
                titleStyle: textTheme.titleLarge!,
                leadingIconOnTap: () => Get.back(),
                leadingIcon: (StaticInfo.driverModel!.isProfileCompleted)
                    ? 'assets/back_arrow_light.svg'
                    : null,
              ),
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      color: Colors.transparent,
                      height: mediaH * 0.28,
                      width: mediaW,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          SvgPicture.asset(
                            'assets/bg_image.svg',
                            fit: BoxFit.cover,
                            width: mediaW,
                          ),
                          Column(
                            children: [
                              (0.155 * mediaH).vSpace(),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 38),
                                child: IgnorePointer(
                                  ignoring:
                                      StaticInfo.driverModel!.isProfileCompleted,
                                  child: Form(
                                    key: _addressKey,
                                    autovalidateMode: _autoValidateAddress,
                                    child: InputField(
                                      controller: viewModel.addressCon,
                                      fillColor: theme.unselectedWidgetColor,
                                      hint: setLocationKey.tr,
                                      hintStyle: textTheme.displayMedium!
                                          .copyWith(color: theme.cardColor),
                                      borderRadius: 10,
                                      borderColor: theme.primaryColorDark,
                                      maxLines: 1,
                                      suffixWidget:
                                          Container(child: Text('  ')),
                                      suffixBoxConstraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                      ),
                                      prefixWidget: GestureDetector(
                                        onTap: () {
                                          Get.to(() => CurrentLocationView(
                                                userCurrentLocation:
                                                    (String address, double lat,
                                                        double lng) {
                                                  setState(() {
                                                    viewModel.addressCon.text =
                                                        address;
                                                    viewModel.driverLocLatLng =
                                                        LatLng(lat, lng);
                                                  });
                                                },
                                              ));
                                        },
                                        child: Container(
                                            height: 24,
                                            width: 24,
                                            margin: const EdgeInsetsDirectional
                                                .only(end: 15, start: 16),
                                            child: SvgPicture.asset(
                                              'assets/location_icon.svg',
                                            )),
                                      ),
                                      onChange: viewModel.addressOnChange,
                                      validator: viewModel.addressValidator,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //(mediaH * 0.219).vSpace(),
                        ],
                      ),
                    ),
                    Container(
                      height: mediaH * 0.63,
                      // color: Colors.lightBlue,
                      child: FadingEdgeScrollView.fromSingleChildScrollView(
                        child: SingleChildScrollView(
                          controller: viewModel.scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              horizontal: hMargin, vertical: hMargin),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 123,
                                      width: 123,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: theme.primaryColor,
                                              width: 2),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: (viewModel.profileImage !=
                                                    null)
                                                ? Image.file(
                                                    File(viewModel
                                                        .profileImage!.path),
                                                    //fit: BoxFit.contain,
                                                    width: 123,
                                                    height: 123,
                                                  ).image
                                                : (StaticInfo
                                                        .driverModel!
                                                        .profileImage!
                                                        .isNotEmpty)
                                                    ? Image.network(
                                                        StaticInfo.driverModel!
                                                            .profileImage!,
                                                      ).image
                                                    : const AssetImage(
                                                        'assets/person_placeholder.png'),
                                          )),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: SvgPicture.asset(
                                              'assets/camera_icon.svg'),
                                        ),
                                        onTap: () {
                                          if (!StaticInfo
                                              .driverModel!.isProfileCompleted) {
                                            FocusScope.of(context).unfocus();
                                            showModalBottomSheet(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .only(
                                                              topRight: Radius
                                                                  .circular(20),
                                                              topLeft:
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                              context: context,
                                              builder: (context) {
                                                return ImagePickerWidget(
                                                    imagePath: viewModel
                                                        .profileImagePicker);
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              (0.03 * mediaH).vSpace(),

                              IgnorePointer(
                                ignoring:
                                    StaticInfo.driverModel!.isProfileCompleted,
                                child: Form(
                                  key: _nameKey,
                                  autovalidateMode: _autoValidateName,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: margin16),
                                        child: Text(
                                          nameKey.tr,
                                          style: textTheme.displayMedium,
                                        ),
                                      ),
                                      6.vSpace(),
                                      InputField(
                                        fillColor: theme.primaryColorDark,
                                        hint: nameKey.tr,
                                        controller: viewModel.nameCon,
                                        textInputAction: TextInputAction.next,
                                        hintStyle: textTheme.displayMedium!
                                            .copyWith(color: theme.cardColor),
                                        borderRadius: 10,
                                        borderColor: theme.primaryColorDark,
                                        maxLines: 1,
                                        validator: viewModel.nameValidator,
                                      ),
                                      25.vSpace(),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: margin16),
                                        child: Text(
                                          surNameKey.tr,
                                          style: textTheme.displayMedium,
                                        ),
                                      ),
                                      6.vSpace(),
                                      InputField(
                                        fillColor: theme.primaryColorDark,
                                        hint: enterSurNamKey.tr,
                                        controller: viewModel.surNameCon,
                                        textInputAction: TextInputAction.next,
                                        hintStyle: textTheme.displayMedium!
                                            .copyWith(color: theme.cardColor),
                                        //prefixImage: 'assets/user.svg',
                                        borderRadius: 10,
                                        borderColor: theme.primaryColorDark,
                                        maxLines: 1,
                                        validator: viewModel.surNameValidator,
                                      ),
                                      25.vSpace(),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: margin16),
                                        child: Text(
                                          alterNativeContKey.tr,
                                          style: textTheme.displayMedium,
                                        ),
                                      ),
                                      6.vSpace(),
                                      InputField(
                                        fillColor: theme.primaryColorDark,
                                        keyboardType: TextInputType.phone,
                                        hint: '3XXXXXXXXX',
                                        controller: viewModel.phoneCon,
                                        textInputAction: TextInputAction.next,
                                        maxLength: 10,
                                        hintStyle: textTheme.displayMedium!
                                            .copyWith(color: theme.cardColor),
                                        prefixWidget: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            5.hSpace(),
                                            SvgPicture.asset('assets/flag.svg'),
                                            5.hSpace(),
                                            Text(
                                              '+92',
                                              style: textTheme.displayMedium,
                                            ),
                                            5.hSpace()
                                          ],
                                        ),
                                        borderRadius: 10,
                                        borderColor: theme.primaryColorDark,
                                        maxLines: 1,
                                        validator: viewModel.phoneValidator,
                                      ),
                                      25.vSpace(),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: margin16),
                                        child: Text(
                                          cnicKey.tr,
                                          style: textTheme.displayMedium,
                                        ),
                                      ),
                                      6.vSpace(),
                                      InputField(
                                        fillColor: theme.primaryColorDark,
                                        hint: enterCnicKey.tr,
                                        controller: viewModel.cnicCon,
                                        textInputAction: TextInputAction.done,
                                        hintStyle: textTheme.displayMedium!
                                            .copyWith(color: theme.cardColor),
                                        //prefixImage: 'assets/user.svg',
                                        borderRadius: 10,
                                        maxLength: 15,
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          viewModel.maskFormatter
                                        ],
                                        borderColor: theme.primaryColorDark,
                                        maxLines: 1,
                                        validator: viewModel.cnicValidator,
                                      ),
                                      25.vSpace(),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: margin16),
                                        child: Text(
                                          licenseKey.tr,
                                          style: textTheme.displayMedium,
                                        ),
                                      ),
                                      10.vSpace(),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: hMargin),
                                          child: (viewModel.licenseFrontImage !=
                                                      null ||
                                                  viewModel
                                                      .driverLicenseFrontImageLink
                                                      .isNotEmpty)
                                              ? ShowDocumentsImagesWidget(
                                                  image: viewModel
                                                      .licenseFrontImage,
                                                  networkImage: viewModel
                                                      .driverLicenseFrontImageLink,
                                                  onTap: viewModel
                                                      .delLicenseFrontImage,
                                                )
                                              : SelectDocumentImageWidget(
                                                  title: frontPhotoKey.tr,
                                                  errorMessage:
                                                      'License front image is required',
                                                  showErrorMessage: viewModel
                                                      .imageValidationCheck,
                                                  borderColor:
                                                      viewModel.borderColor(
                                                          image: viewModel
                                                              .licenseFrontImage),
                                                  addImage: viewModel
                                                      .selectLicenseFrontImage,
                                                )),
                                      16.vSpace(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: hMargin),
                                        child: (viewModel.licenseBackImage !=
                                                    null ||
                                                viewModel
                                                    .driverLicenseBackImageLink
                                                    .isNotEmpty)
                                            ? ShowDocumentsImagesWidget(
                                                image:
                                                    viewModel.licenseBackImage,
                                                networkImage: viewModel
                                                    .driverLicenseBackImageLink,
                                                onTap: viewModel
                                                    .delLicenseBackImage,
                                              )
                                            : SelectDocumentImageWidget(
                                                title: backPhotoKey.tr,
                                                errorMessage:
                                                    'License back image is required',
                                                showErrorMessage: viewModel
                                                    .imageValidationCheck,
                                                borderColor:
                                                    viewModel.borderColor(
                                                        image: viewModel
                                                            .licenseBackImage),
                                                addImage: viewModel
                                                    .selectLicenseBackImage,
                                              ),
                                      ),
                                      20.vSpace(),
                                      Divider(
                                          color: theme.dividerColor,
                                          thickness: 1),
                                      20.vSpace(),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: margin16),
                                        child: Text(
                                          cnicKey.tr,
                                          style: textTheme.displayMedium,
                                        ),
                                      ),
                                      10.vSpace(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: hMargin),
                                        child: (viewModel.cnicFrontImage !=
                                                    null ||
                                                viewModel
                                                    .driverCnicFrontImageLink
                                                    .isNotEmpty)
                                            ? ShowDocumentsImagesWidget(
                                                image: viewModel.cnicFrontImage,
                                                networkImage: viewModel
                                                    .driverCnicFrontImageLink,
                                                onTap:
                                                    viewModel.delCnicFrontImage)
                                            : SelectDocumentImageWidget(
                                                title: frontPhotoKey.tr,
                                                errorMessage:
                                                    'CNIC front image is required',
                                                showErrorMessage: viewModel
                                                    .imageValidationCheck,
                                                addImage: viewModel
                                                    .selectCnicFrontImage,
                                                borderColor:
                                                    viewModel.borderColor(
                                                        image: viewModel
                                                            .cnicFrontImage),
                                              ),
                                      ),
                                      16.vSpace(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: hMargin),
                                        child: (viewModel.cnicBackImage !=
                                                    null ||
                                                viewModel
                                                    .driverCnicBackImageLink
                                                    .isNotEmpty)
                                            ? ShowDocumentsImagesWidget(
                                                image: viewModel.cnicBackImage,
                                                networkImage: viewModel
                                                    .driverCnicBackImageLink,
                                                onTap:
                                                    viewModel.delCnicBackImage)
                                            : SelectDocumentImageWidget(
                                                title: backPhotoKey.tr,
                                                errorMessage:
                                                    'CNIC back image is required',
                                                showErrorMessage: viewModel
                                                    .imageValidationCheck,
                                                addImage: viewModel
                                                    .selectCnicBackImage,
                                                borderColor:
                                                    viewModel.borderColor(
                                                        image: viewModel
                                                            .cnicBackImage),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //(0.04 * mediaH).vSpace(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    (0.01 * mediaH).vSpace(),
                    Center(
                      child: ButtonWidget(
                        btnText: nextKey.tr,
                        textStyle: textTheme.titleLarge!.copyWith(
                          color: theme.unselectedWidgetColor,
                        ),
                        radius: 76,
                        onTap: () {
                          if (StaticInfo.driverModel!.isProfileCompleted) {
                            viewModel.updateDriverProfile();
                          } else if (_addressKey.currentState!.validate() &&
                              _nameKey.currentState!.validate() &&
                              viewModel.imagesValidation()) {
                            viewModel.updateDriverProfile();
                          } else {
                            _autoValidateName =
                                AutovalidateMode.onUserInteraction;
                            _autoValidateAddress =
                                AutovalidateMode.onUserInteraction;
                          }
                        },
                      ),
                    )
                  ],
                ),
                if (viewModel.showSuggestion &&viewModel.suggestions.length>0)
                  LocationSuggestionWidget(
                    viewModel: viewModel,
                    onTap: (index) {
                      setState(() {
                        viewModel.showSuggestion = false;
                        viewModel.addressCon.text =
                            viewModel.suggestions[index].description;
                        viewModel.addressCon.selection =
                            TextSelection.collapsed(
                                offset: viewModel.addressCon.text.length);
                        viewModel
                            .getLatLng(viewModel.suggestions[index].placeId);
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => DriverProfileViewModel(),
      onViewModelReady: (model) => SchedulerBinding.instance
          .addPostFrameCallback((_) => model.initialise()),
    );
  }
}
