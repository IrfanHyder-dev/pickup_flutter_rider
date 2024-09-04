import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/src/theme/base_theme.dart';
import 'package:pickup/ui/views/history/history_viewmodel.dart';
import 'package:pickup/ui/widgets/history/payment_history_widget.dart';
import 'package:pickup/ui/widgets/history/ride_history_widget.dart';
import 'package:stacked/stacked.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<HistoryViewModel>.reactive(
      builder: (context, viewModel, child) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Center(
                  child: Text(
                rideHistoryKey.tr,
                style: textTheme.titleLarge,
              )),
              leading: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsetsDirectional.only(start: 20),
                  height: 18,
                  width: 18,
                  child: SvgPicture.asset('assets/back_arrow_light.svg'),
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 20),
                    child: SvgPicture.asset('assets/black_bell_icon.svg'),
                  ),
                ),
              ],
              bottom: TabBar(
                  indicatorColor: theme.primaryColor,
                  //indicatorSize: TabBarIndicatorSize.label,
                  //dividerColor: theme.cardColor,
                  indicatorPadding:
                      const EdgeInsets.symmetric(horizontal: hMargin),
                  unselectedLabelColor: darkThemeTextColor,
                  labelColor: theme.primaryColor,
                  unselectedLabelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: defaultFontFamily,
                      height: 3),
                  labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: defaultFontFamily,
                      height: 3),
                  tabs: [
                    Text(
                      rideHistoryKey.tr,
                    ),
                    Text(
                      paymentHistoryKey.tr,
                    ),
                  ]),
            ),
            body: TabBarView(
                physics: const BouncingScrollPhysics(),
                dragStartBehavior: DragStartBehavior.start,
                children: [
                  SizedBox(
                      height: mediaH * 0.8,
                      //color: Colors.green,
                      child: RideHistoryWidget(historyViewModel: viewModel,)),
                  PaymentHistoryWidget(historyViewModel: viewModel,),
                ]),
          ),
        );
      },
      viewModelBuilder: () => HistoryViewModel(),
      onViewModelReady: (model) => SchedulerBinding.instance
          .addPostFrameCallback((_) => model.initialise()),
    );
  }
}
