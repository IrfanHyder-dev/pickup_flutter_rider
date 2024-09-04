import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/app/locator.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:pickup/src/theme/base_theme.dart';
import 'package:pickup/ui/views/home/home_viewmodel.dart';
import 'package:pickup/ui/views/home/widgets/home_current_service_widget.dart';
import 'package:pickup/ui/views/notification/notification_view.dart';
import 'package:pickup/ui/views/pick_drop_map/map_view/map_view.dart';
import 'package:pickup/ui/widgets/app_bar_widget.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController childNameScrolCntrlr = ScrollController();
  dynamic selectedChildIndex = -1;
  List selectedChild = [];
  List childList = ['Aslam', 'Salman', 'Ali', 'Mounim', 'Usman'];
  Color firstGradientColor = lightThemeFirstGradientColor;
  Color secondGradientColor = lightThemeSecondGradientColor;
  bool isLocationDiff = false;

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Stack(
            children: [
              SizedBox(
                height: mediaH * 0.313,
                width: mediaW,
                child: SvgPicture.asset(
                  'assets/bg_image.svg',
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PreferredSize(
                    preferredSize: Size.fromHeight(kToolbarHeight),
                    child: AppBarWidget(
                      title: '',
                      titleStyle: textTheme.titleLarge!,
                      actionIcon: 'assets/black_bell_icon.svg',
                      actonIconOnTap: () =>
                          // viewModel.setUserLocation()
                          Get.to(() => const NotificationView()),
                    ),
                  ),
                  (mediaH * 0.026).vSpace(),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 23),
                    child: Text(
                      'Welcome ${StaticInfo.driverModel?.name ?? ""}',
                      style: textTheme.displayLarge!.copyWith(fontSize: 24),
                    ),
                  ),
                  (mediaH * 0.07).vSpace(),
                  (StaticInfo.driverModel!.approvalStatus &&
                      StaticInfo.driverModel!.driverDropOffLat != null &&
                      StaticInfo.driverModel!.driverDropOffLong != null && viewModel.isQuotationsExist)?
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      // child: GestureDetector(onTap: ()=> viewModel.checkRideTime(),child: HomeCurrentServiceWidget()),
                      child: GestureDetector(
                          onTap: () => viewModel.moveToMapScreen(context: context),
                          child: HomeCurrentServiceWidget(
                            homeViewModel: viewModel,
                          )),
                    ): Column(
                      children: [
                        (0.2 * mediaH).vSpace(),
                        Center(
                        child: Text(
                          'Currently you have no service',
                          style: textTheme.displayMedium!.copyWith(height: 0),
                          textAlign: TextAlign.center,
                        ),
                                          ),
                      ],
                    ),
                  (0.2 * mediaH).vSpace(),
                  if (StaticInfo.driverModel!.approvalStatus == false)
                    Center(
                      child: Text(
                        'Please be patient while we review your submitted documents',
                        style: textTheme.displayMedium!.copyWith(height: 0),
                        textAlign: TextAlign.center,
                      ),
                    )
                ],
              )
            ],
          ),
        );
      },
      viewModelBuilder: () => locator<HomeViewModel>(),
      disposeViewModel: false,
      onViewModelReady: (model) => SchedulerBinding.instance
          .addPostFrameCallback((_) => model.initialise()),
    );
  }
}
