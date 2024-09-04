import 'package:alarm/alarm.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pickup/src/language/language_keys.dart';
import 'package:pickup/ui/views/alarm/alarm_edit/alarm_edit_viewmodel.dart';
import 'package:pickup/ui/widgets/button_widget.dart';
import 'package:stacked/stacked.dart';

class AlarmEditScreenView extends StatefulWidget {
  final AlarmSettings? alarmSettings;

  const AlarmEditScreenView({Key? key, this.alarmSettings}) : super(key: key);

  @override
  State<AlarmEditScreenView> createState() => _AlarmEditScreenViewState();
}

class _AlarmEditScreenViewState extends State<AlarmEditScreenView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ViewModelBuilder<AlarmEditViewModel>.reactive(
      builder: (context, viewModel, child) {
        return (viewModel.isDataLoading)
            ? Container()
            : Container(
                // height: 100,
                //color: Colors.red,
                padding: const EdgeInsets.only(
                    bottom: 10, top: 20, left: 30, right: 30),
                child: Wrap(
                  children: [
                    Row(
                      children: [
                        Text(
                          '${viewModel.isToday() ? 'Today' : 'Tomorrow'} at: ',
                          style: Theme.of(context).textTheme.displayMedium!,
                        ),
                        Container(
                          padding: EdgeInsetsDirectional.symmetric(
                              horizontal: 10, vertical: 18),
                          child: Text(
                            viewModel.selectedTime!.format(context),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 20),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Time time;
                              if (widget.alarmSettings != null) {
                                time = Time(
                                    hours: widget.alarmSettings!.dateTime.hour,
                                    minutes:
                                        widget.alarmSettings!.dateTime.minute);
                              } else {
                                time = Time(
                                    hours:
                                        viewModel.combinedDateTime?.hour ?? 0,
                                    minutes:
                                        viewModel.combinedDateTime!.minute);
                              }

                              BottomPicker.time(
                                      initialTime: time,
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
                                      title: startTimeKey.tr,
                                      onSubmit: (time) {
                                        var outputFormat =
                                            DateFormat('hh:mm a');

                                        viewModel.selectedAlarmTime(time);
                                        print(time);
                                      },
                                      onClose: () {},
                                      bottomPickerTheme: BottomPickerTheme.blue,
                                      use24hFormat: false)
                                  .show(context);
                            },
                            child:
                                SvgPicture.asset('assets/clock_dark_grey.svg'))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Loop alarm audio',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Switch(
                              activeTrackColor: theme.primaryColor,
                              activeColor: theme.unselectedWidgetColor,
                              value: viewModel.loopAudio!,
                              onChanged: (value) =>
                                  viewModel.loopAudioSwitch(value)),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vibrate',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Switch(
                          activeTrackColor: theme.primaryColor,
                          activeColor: theme.unselectedWidgetColor,
                          value: viewModel.vibrate!,
                          onChanged: (value) => viewModel.vibrateSwitch(value),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Show notification',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Switch(
                          activeTrackColor: theme.primaryColor,
                          activeColor: theme.unselectedWidgetColor,
                          value: viewModel.showNotification,
                          onChanged: (value) =>
                              viewModel.notificationSwitch(value),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sound',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        DropdownButton(
                          value: viewModel.assetAudio,
                          dropdownColor: theme.unselectedWidgetColor,
                          items: const [
                            DropdownMenuItem<String>(
                              value: 'assets/audio/alarm_tune_marimba.mp3',
                              child: Text('Marimba'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'assets/audio/alarm_tune_mozart.mp3',
                              child: Text('Mozart'),
                            ),
                          ],
                          onChanged: (value) {
                            print('tune is $value');
                            viewModel.assetAudio = value!;
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 35,
                            width: 85,
                            child: ButtonWidget(
                                onTap: () => Get.back(),
                                verticalPadding: 0,
                                horizontalPadding: 0,
                                btnText: cancelKey.tr,
                                radius: 10,
                                textStyle: textTheme.titleLarge!.copyWith(
                                    color: theme.unselectedWidgetColor,
                                    fontSize: 16)),
                          ),
                          SizedBox(
                            height: 35,
                            width: 85,
                            child: ButtonWidget(
                                onTap: () => viewModel.saveAlarm(
                                    alarmSettings: widget.alarmSettings),
                                verticalPadding: 0,
                                horizontalPadding: 0,
                                btnText: (!viewModel.creating!)
                                    ? doneKey.tr
                                    : saveKey.tr,
                                radius: 10,
                                textStyle: textTheme.titleLarge!.copyWith(
                                    color: theme.unselectedWidgetColor,
                                    fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(),
                  ],
                ),
              );
      },
      viewModelBuilder: () => AlarmEditViewModel(),
      onViewModelReady: (viewModel) => SchedulerBinding.instance
          .addPostFrameCallback(
              (_) => viewModel.initialise(alarmSettings: widget.alarmSettings)),
    );
  }
}
