import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/language/language_keys.dart';

class PickupDropOffInfoWidget extends StatelessWidget {
  final double locationWidth;
  final double dividerWidth;
  final String pickupAddress;
  final String dropOffAddress;
  final DateTime? pickupTime;
  final DateTime? dropOffTime;
  final String? startHeading;
  final String? endHeading;

  PickupDropOffInfoWidget({
    super.key,
    required this.dividerWidth,
    required this.locationWidth,
    required this.pickupAddress,
    required this.dropOffAddress,
    required this.pickupTime,
    required this.dropOffTime,
    this.startHeading,
    this.endHeading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            5.vSpace(),
            SvgPicture.asset('assets/pickup_icon.svg'),
            5.vSpace(),
            SizedBox(
                child: SvgPicture.asset(
              'assets/large_line_icon.svg',
              height: 55,
              fit: BoxFit.cover,
            )),
            5.vSpace(),
            SvgPicture.asset('assets/dropoff_icon.svg'),
          ],
        ),
        16.hSpace(),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (startHeading != null) ? startHeading! : pickUpKey.tr,
              style: textTheme.bodyLarge!.copyWith(color: theme.cardColor),
            ),
            4.vSpace(),
            Container(
              //width: mediaW * 0.7,
              //color: Colors.red,
              width: locationWidth,
              child: Text(
                pickupAddress,
                overflow: TextOverflow.fade,
                maxLines: 1,
                style: textTheme.bodyLarge!.copyWith(height: 0),
                //overflow:TextOverflow.clip,
              ),
            ),
            2.vSpace(),
            SizedBox(
              height: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/clock_grey.svg',
                    height: 18,
                  ),
                  8.hSpace(),
                  Text(
                    pickupTime != null
                        ? DateFormat('hh:mm a').format(pickupTime!)
                        : "",
                    style: textTheme.displayMedium!.copyWith(
                        color: theme.canvasColor, fontSize: 14, height: 0),
                  ),
                ],
              ),
            ),
            5.vSpace(),
            SizedBox(
              //width: mediaW * 0.546,
              width: dividerWidth,
              child: const Divider(
                thickness: 1,
              ),
            ),
            5.vSpace(),
            Text(
              (endHeading != null) ? endHeading! : dropOffKey.tr,
              style: textTheme.bodyLarge!.copyWith(color: theme.cardColor),
            ),
            4.vSpace(),
            Container(
              //width: mediaW * 0.7,
              width: locationWidth,
              child: Text(
                dropOffAddress,
                overflow: TextOverflow.fade,
                maxLines: 1,
                style: textTheme.bodyLarge!.copyWith(height: 0),
              ),
            ),
            2.vSpace(),
            SizedBox(
              height: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/clock_grey.svg',
                    height: 18,
                  ),
                  8.hSpace(),
                  Text(
                    dropOffTime != null
                        ? DateFormat('hh:mm a').format(dropOffTime!)
                        : "",
                    style: textTheme.displayMedium!.copyWith(
                        color: theme.canvasColor, fontSize: 14, height: 0),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
