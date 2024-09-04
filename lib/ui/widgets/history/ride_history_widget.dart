import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/src/theme/base_theme.dart';
import 'package:pickup/ui/views/history/history_viewmodel.dart';
import 'package:pickup/ui/widgets/history/history_row_widget.dart';

class RideHistoryWidget extends StatelessWidget {
  final ScrollController controller = ScrollController();
  final Color historyColor = lightThemeHistoryColor;
  final HistoryViewModel historyViewModel;

  RideHistoryWidget({super.key, required this.historyViewModel});

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return (historyViewModel.isHistoryDataLoaded)
        ? (historyViewModel.rideHistory!.data!.isEmpty ||
                historyViewModel.rideHistory!.data == null)
            ? Center(
                child: Text(
                'History not available',
                style: textTheme.displayMedium,
              ))
            : FadingEdgeScrollView.fromScrollView(
                child: ListView.separated(
                  controller: controller,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 42, bottom: 90),
                  itemCount: historyViewModel.rideHistory?.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    var historyData =
                        historyViewModel.rideHistory?.data?[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: hMargin),
                      width: mediaW,
                      decoration: BoxDecoration(
                        color: darkThemeTextLightColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          // 10.hSpace(),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            // child: Text(
                            //   "${driverDroppedKey.tr} ${toSchoolKey.tr}",
                            //   style: textTheme.displayMedium!.copyWith(
                            //       color: theme.unselectedWidgetColor, fontSize: 14),
                            // ),
                          ),
                          Container(
                            //height: 242,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 13, vertical: 22),
                            decoration: BoxDecoration(
                              color: theme.unselectedWidgetColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xff000000).withOpacity(0.1),
                                  //Color.fromARGB(120, 0, 0, 0),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                HistoryRowWidget(
                                    image: 'assets/clock.svg',
                                    containerText:
                                        historyData?.rideStartTime ?? '',
                                    heading: rideStartTimeKey.tr),
                                11.vSpace(),
                                HistoryRowWidget(
                                    image: 'assets/clock.svg',
                                    containerText:
                                        historyData?.rideEndTime ?? '',
                                    heading: rideEndTimeKey.tr),
                                11.vSpace(),
                                HistoryRowWidget(
                                    image: 'assets/shift_type_icon.svg',
                                    containerText: GetStringUtils(
                                                '${historyData?.shiftType?.name}')
                                            .capitalizeFirst ??
                                        '',
                                    heading: rideShiftTypeKey.tr),
                                11.vSpace(),
                                HistoryRowWidget(
                                    image: 'assets/outlined_location_icon.svg',
                                    containerText:
                                        '${historyData?.distanceCovered?.toStringAsFixed(2)} km',
                                    heading: distanceCovredKey.tr),
                                11.vSpace(),
                                HistoryRowWidget(
                                    containerWidth: 175,
                                    image: 'assets/number_plate_icon.svg',
                                    containerText:
                                        '${StaticInfo.vehicleModel?.vehicleMake} (${StaticInfo.vehicleModel?.vehicleNumberPlate})' ??
                                            '',
                                    heading: vehicleDetailKey.tr),
                                20.vSpace(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    historyData?.rideDate ?? '',
                                    style: textTheme.titleSmall!
                                        .copyWith(color: theme.cardColor),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => 23.vSpace(),
                ),
              )
        : Container();
  }
}
