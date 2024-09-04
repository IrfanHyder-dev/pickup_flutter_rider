import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/enums/app_enums.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/profile/vehicle_detail/vehicle_detail_viewmodel.dart';
import 'package:pickup/ui/widgets/app_bar_widget.dart';
import 'package:pickup/ui/widgets/button_widget.dart';
import 'package:pickup/ui/widgets/dropdown_field_widget.dart';
import 'package:pickup/ui/widgets/input_field_widget.dart';
import 'package:pickup/ui/widgets/vehicle_detail/car_images_widget.dart';
import 'package:pickup/ui/widgets/vehicle_detail/document_images_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';

class VehicleDetailView extends StatefulWidget {
  final String address;

  VehicleDetailView({super.key, required this.address});

  @override
  State<VehicleDetailView> createState() => _VehicleDetailViewState();
}

class _VehicleDetailViewState extends State<VehicleDetailView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final textStyle = textTheme.bodyMedium!.copyWith(fontSize: 14);
    return ViewModelBuilder<VehicleDetailViewModel>.reactive(
      builder: (context, viewModel, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBarWidget(
              title: vehicleDetailKey.tr,
              titleStyle: textTheme.titleLarge!,
              leadingIconOnTap: () => Get.back(),
              leadingIcon: 'assets/back_arrow_light.svg',
            ),
          ),
          body: FadingEdgeScrollView.fromSingleChildScrollView(
            gradientFractionOnEnd: 0.01,
            child: SingleChildScrollView(
              controller: viewModel.screenScrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(children: [
                Container(
                  height: mediaH * 0.78,
                  child: FadingEdgeScrollView.fromSingleChildScrollView(
                      child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 20),
                    controller: viewModel.scrollController,
                    child: IgnorePointer(
                      ignoring: StaticInfo.driverModel!.isProfileCompleted,
                      child: Column(
                        children: [
                          41.vSpace(),
                          CarImagesWidget(
                            carImageList: viewModel.carImageList,
                            savedCarImages: viewModel.savedCarImages,
                            addImage: (image) =>
                                viewModel.addNewCarImage(image: image),
                            removeImage: (index, listName, deleteImageId) =>
                                viewModel.deleteImage(
                                    index: index,
                                    listName: listName,
                                    id: deleteImageId),
                            // },
                          ),
                          40.vSpace(),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 24, end: 30),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    DropdownFieldWidget(
                                      items: viewModel.vehicleTypesList
                                          .map<DropdownMenuItem<dynamic>>(
                                              (vehicleType) {
                                        return DropdownMenuItem<dynamic>(
                                            value: vehicleType,
                                            child: Text(vehicleType.label));
                                      }).toList(),
                                      onChange: (newVal) {
                                        setState(() {
                                          viewModel.vehicleTypeVal = newVal;
                                          viewModel.numOfSeats = null;
                                          viewModel.generateList(
                                              minVal: viewModel
                                                  .vehicleTypeVal!.minimumSeat,
                                              maxVal: viewModel
                                                  .vehicleTypeVal!.maximumSeat);
                                        });
                                      },
                                      prefixIcon: 'assets/car_yellow.svg',
                                      hintText:
                                          (viewModel.vehicleTypeVal != null)
                                              ? viewModel.vehicleTypeVal!.label
                                              : vehicleTypeKey.tr,
                                      validator: (val) {
                                        if (viewModel.vehicleTypeVal == null) {
                                          return 'Select Vehicle Type';
                                        }
                                      },
                                    ),
                                    18.vSpace(),
                                    InputField(
                                      isDecorationEnable: true,
                                      isUnderLineBorder: true,
                                      fillColor: Colors.transparent,
                                      controller: viewModel.vehicleMakeCon,
                                      hint: vehicleMakeKey.tr,
                                      hintStyle: textStyle,
                                      borderWidth: 1,
                                      prefixWidget: Container(
                                          height: 24,
                                          width: 24,
                                          margin:
                                              const EdgeInsetsDirectional.only(
                                            end: 15,
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/car_yellow.svg',
                                          )),
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Enter Vehicle Make';
                                        }
                                      },
                                    ),
                                    18.vSpace(),
                                    InputField(
                                      isDecorationEnable: true,
                                      isUnderLineBorder: true,
                                      fillColor: Colors.transparent,
                                      controller: viewModel.vehicleModelYearCon,
                                      hint: vehicleModelYearKey.tr,
                                      hintStyle: textStyle,
                                      borderWidth: 1,
                                      prefixWidget: Container(
                                          height: 24,
                                          width: 24,
                                          margin:
                                              const EdgeInsetsDirectional.only(
                                            end: 15,
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/car_yellow.svg',
                                          )),
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Enter Vehicle model year';
                                        }
                                      },
                                    ),
                                    18.vSpace(),
                                    DropdownFieldWidget(
                                      items: viewModel.numOfSeatsList
                                          .map<DropdownMenuItem<dynamic>>(
                                              (vehicleType) {
                                        return DropdownMenuItem<dynamic>(
                                            value: vehicleType,
                                            child: Text('$vehicleType'));
                                      }).toList(),
                                      onChange: (dynamic newVal) {
                                        print('vehicle type is $newVal');
                                        setState(() {
                                          viewModel.numOfSeats = newVal;
                                        });
                                      },
                                      prefixIcon: 'assets/seat_yellow.svg',
                                      hintText: (viewModel.numOfSeats != null)
                                          ? viewModel.numOfSeats.toString()
                                          : numOfSeatKey.tr,
                                      validator: (val) {
                                        if (viewModel.numOfSeats == null) {
                                          return 'Select Number of seats';
                                        }
                                      },
                                    ),
                                    18.vSpace(),
                                    InputField(
                                      isDecorationEnable: true,
                                      isUnderLineBorder: true,
                                      fillColor: Colors.transparent,
                                      controller: viewModel.numberPlateCon,
                                      hint: numberPlateKey.tr,
                                      hintStyle: textStyle,
                                      borderWidth: 1,
                                      prefixWidget: Container(
                                          height: 24,
                                          width: 24,
                                          margin:
                                              const EdgeInsetsDirectional.only(
                                            end: 15,
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/number_plate_yellow.svg',
                                          )),
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Enter Number plate';
                                        }
                                      },
                                    ),
                                    18.vSpace(),
                                    InputField(
                                      readOnlyField: true,
                                      isDecorationEnable: true,
                                      controller: viewModel.maintenanceDateCon,
                                      isUnderLineBorder: true,
                                      fillColor: Colors.transparent,
                                      hint: maintenanceKey.tr,
                                      hintStyle: textStyle,
                                      borderWidth: 1,
                                      prefixWidget: Container(
                                          height: 24,
                                          width: 24,
                                          margin:
                                              const EdgeInsetsDirectional.only(
                                            end: 15,
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/maintenance_yellow.svg',
                                          )),
                                      suffixWidget: Container(
                                        height: 24,
                                        width: 24,
                                        margin:
                                            const EdgeInsetsDirectional.only(
                                          end: 15,
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/calendar_yellow.svg',
                                        ),
                                      ),
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "Enter Maintenance date";
                                        }
                                      },
                                      onTap: () async {
                                        BottomPicker.date(
                                          pickerTextStyle: TextStyle(
                                            color: theme.primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                          titleStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                          descriptionStyle: const TextStyle(
                                              color: Colors.red, fontSize: 14),
                                          closeIconColor: Colors.black,
                                          iconColor: Colors.black,
                                          buttonSingleColor: theme.primaryColor,
                                          title: maintenanceKey.tr,
                                          onSubmit: (date) {
                                            var outputFormat =
                                                DateFormat('dd-MM-yyyy');
                                            var outputDate =
                                                outputFormat.format(date);
                                            setState(() {
                                              viewModel.maintenanceDateCon
                                                  .text = outputDate;
                                            });
                                            print('$date    $outputDate');
                                          },
                                        ).show(context);
                                      },
                                    ),
                                    20.vSpace(),
                                    Align(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Text(
                                          availablyKey.tr,
                                          style: textTheme.displayMedium!
                                              .copyWith(fontSize: 14),
                                        )),
                                    16.vSpace(),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: mediaW * 0.4,
                                          child: InputField(
                                            controller: viewModel.startTimeCon,
                                            readOnlyField: true,
                                            isDecorationEnable: true,
                                            isUnderLineBorder: true,
                                            fillColor: Colors.transparent,
                                            hint: fromKey.tr,
                                            hintStyle: textStyle,
                                            borderWidth: 1,
                                            contentPadding:
                                                EdgeInsetsDirectional.symmetric(
                                                    horizontal: 0,
                                                    vertical: 15),
                                            suffixWidget: Container(
                                              height: 24,
                                              width: 24,
                                              child: SvgPicture.asset(
                                                'assets/clock_yellow.svg',
                                              ),
                                            ),
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return 'Enter Start time';
                                              }
                                            },
                                            onTap: () async {
                                              BottomPicker.time(
                                                      initialTime: Time(
                                                          hours: DateTime.now()
                                                              .hour,
                                                          minutes:
                                                              DateTime.now()
                                                                  .minute),
                                                      pickerTextStyle:
                                                          TextStyle(
                                                        color:
                                                            theme.primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                      ),
                                                      titleStyle:
                                                          const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                      ),
                                                      descriptionStyle:
                                                          const TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 14),
                                                      closeIconColor:
                                                          Colors.black,
                                                      iconColor: Colors.black,
                                                      buttonSingleColor:
                                                          theme.primaryColor,
                                                      title: startTimeKey.tr,
                                                      onSubmit: (time) {
                                                        var outputFormat =
                                                            DateFormat(
                                                                'hh:mm a');
                                                        var outputDate =
                                                            outputFormat
                                                                .format(time);
                                                        setState(() {
                                                          viewModel
                                                                  .selectedStartTime =
                                                              time;
                                                          viewModel.endTimeCon
                                                              .text = '';
                                                          viewModel.startTimeCon
                                                                  .text =
                                                              outputDate;
                                                        });
                                                        print(
                                                            'time time time $time');
                                                      },
                                                      onClose: () {
                                                        print("Picker closed");
                                                      },
                                                      bottomPickerTheme:
                                                          BottomPickerTheme
                                                              .blue,
                                                      use24hFormat: false)
                                                  .show(context);
                                            },
                                          ),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          width: mediaW * 0.4,
                                          child: IgnorePointer(
                                            ignoring: viewModel
                                                .startTimeCon.text.isEmpty,
                                            child: InputField(
                                              controller: viewModel.endTimeCon,
                                              readOnlyField: true,
                                              isDecorationEnable: true,
                                              isUnderLineBorder: true,
                                              fillColor: Colors.transparent,
                                              hint: toKey.tr,
                                              hintStyle: textStyle,
                                              borderWidth: 1,
                                              contentPadding:
                                                  EdgeInsetsDirectional
                                                      .symmetric(
                                                          horizontal: 0,
                                                          vertical: 15),
                                              suffixWidget: Container(
                                                height: 24,
                                                width: 24,
                                                child: SvgPicture.asset(
                                                  'assets/clock_yellow.svg',
                                                ),
                                              ),
                                              validator: (val) {
                                                if (val!.isEmpty) {
                                                  return 'Enter End time';
                                                }
                                              },
                                              onTap: () async {
                                                BottomPicker.time(
                                                  minTime: Time(
                                                      hours: viewModel
                                                          .selectedStartTime
                                                          .hour,
                                                      minutes: viewModel
                                                              .selectedStartTime
                                                              .minute +
                                                          1),

                                                  //maxDateTime: selectedStartTime.add(Duration(hours: 10,days: 1)),
                                                  pickerTextStyle: TextStyle(
                                                    color: theme.primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                  titleStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                  ),
                                                  descriptionStyle:
                                                      const TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 14),
                                                  closeIconColor: Colors.black,
                                                  iconColor: Colors.black,
                                                  buttonSingleColor:
                                                      theme.primaryColor,
                                                  title: endTimeKey.tr,
                                                  onSubmit: (time) {
                                                    var outputFormat =
                                                        DateFormat('hh:mm a');
                                                    var outputDate =
                                                        outputFormat
                                                            .format(time);
                                                    setState(() {
                                                      viewModel
                                                              .selectedEndTime =
                                                          time;
                                                      viewModel.endTimeCon
                                                          .text = outputDate;
                                                    });
                                                    print(time);
                                                  },
                                                  onClose: () {
                                                    print("Picker closed");
                                                  },
                                                  bottomPickerTheme:
                                                      BottomPickerTheme.blue,
                                                  use24hFormat: false,
                                                  initialTime: Time(
                                                      hours:
                                                          DateTime.now().hour,
                                                      minutes: DateTime.now()
                                                          .minute),
                                                ).show(context);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    18.vSpace(),
                                    InputField(
                                      readOnlyField: true,
                                      isDecorationEnable: true,
                                      controller: viewModel.addressCon,
                                      isUnderLineBorder: true,
                                      fillColor: Colors.transparent,
                                      hint: 'Preferred location',
                                      hintStyle: textStyle,
                                      borderWidth: 1,
                                      suffixWidget: Container(
                                          //color: Colors.red,
                                          child: Text('  ')),
                                      suffixBoxConstraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                      ),
                                      prefixWidget: Container(
                                          height: 24,
                                          width: 24,
                                          margin:
                                              const EdgeInsetsDirectional.only(
                                            end: 15,
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/location_yellow.svg',
                                          )),
                                    ),
                                    18.vSpace(),
                                    DocumentImagesWidget(
                                      documentImagesList:
                                          viewModel.documentImagesList,
                                      savedDocumentImagesList:
                                          viewModel.savedDocumentsImages,
                                      addImage: (image) => viewModel
                                          .addNewDocumentImage(image: image),
                                      removeImage: (index, listName, id) =>
                                          viewModel.deleteDocumentImage(
                                              index: index,
                                              listName: listName,
                                              id: id),
                                    ),
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                  )),
                ),
                10.vSpace(),
                if (!StaticInfo.driverModel!.isProfileCompleted)
                  ButtonWidget(
                    btnText: submitKey.tr,
                    textStyle: textTheme.titleLarge!.copyWith(
                      color: theme.unselectedWidgetColor,
                    ),
                    radius: 76,
                    onTap: () {
                      if (viewModel.selectedStartTime
                          .isAfter(viewModel.selectedEndTime)) {
                        print('time time');
                        viewModel.showSnackBar(
                            "End time must be greater than start time",
                            SnackBarType.universal,
                            color: Theme.of(context).canvasColor,
                            style:
                                TextStyle(color: Colors.white, fontSize: 14));
                      } else if (_formKey.currentState!.validate()) {
                        viewModel.addVehicle(
                            //modelTypeId: selectedModel!.id.toString(),
                            // modelTypeId: viewModel.vehicleTypeVal!.id.toString(),
                            //   modelYear: vehicleModelYearCon.text.trim(),
                            //     vehicleMake: vehicleMakeCon.text.trim(),
                            //   numOfSeats: viewModel.numOfSeats!,
                            //   numberPlate: numberPlateCon.text.trim(),
                            //   maintenanceData: maintenanceDateCon.text.trim(),
                            //   startTime: startTimeCon.text.trim(),
                            //   endTime: endTimeCon.text.trim(),
                            //   address: addressCon.text.trim()
                            );
                      }
                    },
                  )
              ]),
            ),
          ),
        );
      },
      viewModelBuilder: () => VehicleDetailViewModel(),
      onViewModelReady: (model) => SchedulerBinding.instance
          .addPostFrameCallback((_) => model.initialise(widget.address)),
    );
  }
}
