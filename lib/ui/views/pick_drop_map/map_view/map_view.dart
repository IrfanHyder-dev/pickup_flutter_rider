import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/enums/app_enums.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/src/theme/base_theme.dart';
import 'package:pickup/ui/views/pick_drop_map/childrem_bottom_sheet/children_bottom_sheet_view.dart';
import 'package:pickup/ui/views/pick_drop_map/pick_drop_map_viewModel.dart';
import 'package:pickup/ui/widgets/app_bar_widget.dart';
import 'package:pickup/ui/widgets/button_widget.dart';
import 'package:pickup/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';

class PickDropMapView extends StatelessWidget {
  final RideShiftType rideShiftType;

  PickDropMapView({required this.rideShiftType});
  @override
  Widget build(BuildContext context) {
    final mediaH = MediaQuery.of(context).size.height;
    return ViewModelBuilder<PickDropMapViewModel>.reactive(
      builder: (_, viewModel, child) {
        final theme = Theme.of(context);
        final textTheme = theme.textTheme;

        return Scaffold(
          body: ModalProgressHUD(
            inAsyncCall: viewModel.isLoading,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      if ((viewModel.rideStatusModel?.morningRideStatus ==
                                  RideStatus.started ||
                              viewModel.rideStatusModel?.eveningRideStatus ==
                                  RideStatus.started) &&
                          viewModel.isLoading == false)
                        Animarker(
                            mapId: viewModel.mapCompleter.future
                                .then<int>((value) => value.mapId),
                            markers: <Marker>{
                              ...viewModel.driverMarker.values.toSet(),
                            },
                            shouldAnimateCamera: true,
                            duration: Duration(milliseconds: 3500),
                            zoom: 16.4746,
                            child: GoogleMap(
                                polylines:
                                    Set<Polyline>.of(viewModel.polyLines),
                                markers: viewModel.markers,
                                zoomControlsEnabled: false,
                                onMapCreated: (_controller) async {
                                  if (!viewModel.mapCompleter.isCompleted) {
                                    viewModel.mapCompleter
                                        .complete(_controller);
                                    // googleMapController = _controller;
                                  }
                                },
                                initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                        double.parse(
                                            StaticInfo.driverModel?.driverLocation.lat ??
                                                "0"),
                                        double.parse(StaticInfo.driverModel
                                                ?.driverLocation.long ??
                                            "0")),
                                    zoom: 16.4746))),
                      if (viewModel.timeToDisplay.isNotEmpty)
                        TimerWidget(mediaH, textTheme, viewModel.timeToDisplay),
                      if (viewModel.showRideStartButton() &&
                          viewModel.rideStatusModel != null)
                        Container(
                          color: Colors.black12.withOpacity(0.4),
                          child: Center(
                            child: ButtonWidget(
                              onTap: () {
                                viewModel.rideStartOnTap(context);
                              },
                              btnText: startRideKey.tr,
                              textStyle: textTheme.titleLarge!
                                  .copyWith(color: theme.unselectedWidgetColor),
                              radius: 84,
                            ),
                          ),
                        ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: PreferredSize(
                          preferredSize: Size.fromHeight(kToolbarHeight),
                          child: AppBarWidget(
                            title: pickAndDropKey.tr,
                            titleStyle: textTheme.titleLarge!,
                            leadingIcon: 'assets/back_arrow_white.svg',
                            leadingIconOnTap: () => Get.back(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (viewModel.rideStatusModel?.morningRideStatus ==
                        RideStatus.started ||
                    viewModel.rideStatusModel?.eveningRideStatus ==
                        RideStatus.started)
                  ChildrenBottomSheet(viewModel: viewModel)
              ],
            ),
            progressIndicator: CustomDialog().customLoader(context),
          ),
        );
      },
      viewModelBuilder: () => PickDropMapViewModel(),
      onViewModelReady: (model) => SchedulerBinding.instance
          .addPostFrameCallback(
              (_) => model.initialise(rideStartTimeData: rideShiftType, context: context)),
    );
  }

  Container TimerWidget(double mediaH, TextTheme textTheme, String time) {
    return Container(
      height: 45,
      margin: EdgeInsets.only(top: mediaH * 0.15),
      width: double.infinity,
      color: lightScaffoldColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/timer_image.png'),
          6.hSpace(),
          Text(
            'Wait for child for',
            style: textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          17.hSpace(),
          Container(
              height: 27,
              width: 84,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: primaryColor),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 41,
                    child: Text(
                      time,
                      style: textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: lightScaffoldColor,
                        height: 0,
                      ),
                    ),
                  ),
                  // 1.hSpace(),
                  Text(
                    "Min",
                    style: textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w300,
                      color: lightScaffoldColor,
                      height: 0,
                    ),
                  ),
                ],
              )
          )
        ],
      ),
    );
  }
}
