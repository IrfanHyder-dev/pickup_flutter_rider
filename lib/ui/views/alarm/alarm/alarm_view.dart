import 'package:alarm/alarm.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/alarm/alarm/alarm_viewmodel.dart';
import 'package:pickup/ui/widgets/app_bar_widget.dart';
import 'package:pickup/ui/widgets/alarm_tile.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';

class AlarmView extends StatefulWidget {
  const AlarmView({super.key});

  @override
  State<AlarmView> createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final mediaH = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<AlarmViewModel>.reactive(builder: (context, viewModel, child) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBarWidget(
            title: alarmKey.tr,
            titleStyle: textTheme.titleLarge!,
            leadingIcon: 'assets/back_arrow_light.svg',
            leadingIconOnTap: () => Get.back(),
          ),
        ),
        body:(viewModel.isDataLoading)?Container():SafeArea(
          child: viewModel.alarms!.isNotEmpty
              ? FadingEdgeScrollView.fromScrollView(
                child: ListView.separated(
                  controller: scrollController,
            physics: const BouncingScrollPhysics(),
            itemCount: viewModel.alarms!.length,
            padding: EdgeInsets.symmetric(horizontal: 10),
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
                return AlarmTile(
                  key: Key(viewModel.alarms![index].id.toString()),
                  title: TimeOfDay(
                    hour: viewModel.alarms![index].dateTime.hour,
                    minute: viewModel.alarms![index].dateTime.minute,
                  ).format(context),
                  onPressed: () => viewModel.navigateToAlarmScreen(viewModel.alarms![index]),
                  onDismissed: () {
                    Alarm.stop(viewModel.alarms![index].id).then((_) => viewModel.loadAlarms());
                  },
                );
            },
          ),
              )
              : Center(
            child: Text(
              "No alarms set",
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              FloatingActionButton(

                backgroundColor: theme.primaryColor,
                onPressed: () => viewModel.navigateToAlarmScreen(null),
                child: const Icon(Icons.alarm_add_rounded, size: 33,color: Colors.black),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    },viewModelBuilder: () => AlarmViewModel(),
      onViewModelReady: (viewModel) => SchedulerBinding.instance.addPostFrameCallback((_)=> viewModel.initialise()),
    );
  }
}
