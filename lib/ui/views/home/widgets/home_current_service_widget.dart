import 'dart:math' as math;
import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/enums/app_enums.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:pickup/src/theme/base_theme.dart';
import 'package:pickup/ui/views/home/home_viewmodel.dart';
import 'package:pickup/ui/widgets/pickup_dropoff_infro_widget.dart';

class HomeCurrentServiceWidget extends StatelessWidget {
  HomeViewModel homeViewModel;

  HomeCurrentServiceWidget({required this.homeViewModel});

  Color firstGradientColor = lightThemeFirstGradientColor;
  Color secondGradientColor = lightThemeSecondGradientColor;
  DateTime dateTime = DateTime.now();
  String startPointAddress = StaticInfo.driverModel!.driverLocation.address!;
  String endPointAddress = StaticInfo.driverModel!.driverDropOffLocation!;

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: (homeViewModel.rideShiftType != RideShiftType.not_available)
            ? LinearGradient(
                colors: [
                  firstGradientColor,
                  secondGradientColor,
                ],
                begin: const Alignment(-1.0, 0.0),
                end: const Alignment(1.0, 0.0),
                transform: const GradientRotation(math.pi / 4),
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: const Color(0xff000000).withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (homeViewModel.rideShiftType == RideShiftType.not_available)
            Text(
              "Service Not Available.",
              style: textTheme.titleLarge?.copyWith(fontSize: 24),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  margin: const EdgeInsetsDirectional.only(
                      start: 34, top: 18, bottom: 10, end: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 190,
                        child: Text(
                          "${DateFormat('MMMM').format(dateTime)}",
                          style: textTheme.displayMedium,
                        ),
                      ),
                    ],
                  )),
              20.vSpace(),
              Padding(
                  padding: const EdgeInsetsDirectional.only(start: 29),
                  child: PickupDropOffInfoWidget(
                    dividerWidth: mediaW * 0.6,
                    locationWidth: mediaW * 0.6,
                    startHeading: 'Start Point',
                    endHeading: 'End Point',
                    pickupTime: homeViewModel.rideShiftType ==
                            RideShiftType.morning
                        ? homeViewModel.morningPickUpTime
                        : homeViewModel.rideShiftType == RideShiftType.evening
                            ? homeViewModel.eveningPickUpTime
                            : null,
                    dropOffTime: homeViewModel.rideShiftType ==
                            RideShiftType.morning
                        ? homeViewModel.morningDropOffTime
                        : homeViewModel.rideShiftType == RideShiftType.evening
                            ? homeViewModel.eveningDropOffTime
                            : null,
                    pickupAddress: homeViewModel.rideShiftType ==
                            RideShiftType.morning
                        ? startPointAddress
                        : homeViewModel.rideShiftType == RideShiftType.evening
                            ? endPointAddress
                            : "",
                    dropOffAddress: homeViewModel.rideShiftType ==
                            RideShiftType.morning
                        ? endPointAddress
                        : homeViewModel.rideShiftType == RideShiftType.evening
                            ? startPointAddress
                            : "",
                  )),
              20.vSpace(),
              SizedBox(
                width: mediaH * 0.7,
                child: SvgPicture.asset('assets/dash_divider.svg'),
              ),
              14.vSpace(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Text(
                      'Total Ride Taken Time',
                      style: textTheme.bodySmall!
                          .copyWith(fontSize: 12, color: darkThemeTextColor),
                    ),
                    Spacer(),
                    Text(
                      '1 Hour',
                      style: textTheme.bodySmall!
                          .copyWith(fontSize: 10, color: darkThemeTextColor),
                    )
                  ],
                ),
              ),
              10.vSpace(),
            ],
          ),
        ],
      ),
    );
  }
}
