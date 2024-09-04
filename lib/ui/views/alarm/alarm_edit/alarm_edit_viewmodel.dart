import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pickup/ui/widgets/loading_widget.dart';
import 'package:stacked/stacked.dart';

class AlarmEditViewModel extends BaseViewModel {
  bool loading = false;
  bool isDataLoading = true;
  bool? creating;
  TimeOfDay? selectedTime;
  DateTime? combinedDateTime;
  bool? loopAudio;
  bool? vibrate;
  bool showNotification = false;
  String? assetAudio;
  TextEditingController timeCon = TextEditingController();

  initialise({required AlarmSettings? alarmSettings}) {
    CustomDialog.showLoadingDialog(Get.context!);
    creating = alarmSettings == null;
    if (creating!) {
      final dt = DateTime.now().add(const Duration(minutes: 1));
      selectedTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
      loopAudio = true;
      vibrate = true;
      showNotification = true;
      assetAudio = 'assets/audio/alarm_tune_marimba.mp3';
    } else {
      selectedTime = TimeOfDay(
        hour: alarmSettings!.dateTime.hour,
        minute: alarmSettings.dateTime.minute,
      );
      loopAudio = alarmSettings.loopAudio;
      vibrate = alarmSettings.vibrate;
      showNotification = alarmSettings.notificationTitle.isNotEmpty &&
          alarmSettings.notificationBody.isNotEmpty;
      assetAudio = alarmSettings.assetAudioPath;
    }

    timeCon.text = selectedTime.toString();
    DateTime currentDate = DateTime.now();
    combinedDateTime = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
    isDataLoading = false;
    notifyListeners();
    Get.back();
  }

  bool isToday() {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime!.hour,
      selectedTime!.minute,
      0,
      0,
    );
    print('viewModel today ${now.isBefore(dateTime)}');
    return now.isBefore(dateTime);
  }

  AlarmSettings buildAlarmSettings({required AlarmSettings? alarmSetting}) {
    final now = DateTime.now();
    final id = creating!
        ? DateTime.now().millisecondsSinceEpoch % 100000
        : alarmSetting!.id;

    DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime!.hour,
      selectedTime!.minute,
      0,
      0,
    );
    if (dateTime.isBefore(DateTime.now())) {
      dateTime = dateTime.add(const Duration(days: 1));
    }

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTime,
      loopAudio: loopAudio!,
      vibrate: vibrate!,
      notificationTitle: showNotification ? 'Alarm' : "",
      notificationBody: showNotification
          ? 'Your alarm (${DateFormat('hh:mm a').format(dateTime)}) is ringing'
          : "",
      assetAudioPath: assetAudio!,
      volume: 0,
    );
    return alarmSettings;
  }

  void saveAlarm({required AlarmSettings? alarmSettings}) {
    print('alarm settings are ${alarmSettings}');
    loading = true;
    notifyListeners();
    Alarm.set(alarmSettings: buildAlarmSettings(alarmSetting: alarmSettings))
        .then((res) {
      if (res) Navigator.pop(Get.context!, true);
    });
    loading = false;
    notifyListeners();
  }

  void deleteAlarm({required AlarmSettings alarmSettings}) {
    Alarm.stop(alarmSettings.id).then((res) {
      if (res) Navigator.pop(Get.context!, true);
    });
  }

  void vibrateSwitch(bool val) {
    vibrate = val;
    notifyListeners();
  }

  void loopAudioSwitch(bool val) {
    loopAudio = val;
    notifyListeners();
  }

  void notificationSwitch(bool val) {
    showNotification = val;
    notifyListeners();
  }

  void selectedAlarmTime(DateTime time) {
    selectedTime = TimeOfDay.fromDateTime(DateTime.parse(time.toString()));
    notifyListeners();
  }

  @override
  void dispose() {
    timeCon.dispose();
    super.dispose();
  }
}
