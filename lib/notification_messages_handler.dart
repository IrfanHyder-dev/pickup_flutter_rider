import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pickup/services/shared_preference.dart';
import 'package:pickup/src/app/locator.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:pickup/ui/views/bottom_bar/bottom_bar_view.dart';
import 'package:pickup/ui/views/bottom_bar/bottom_bar_viewmodel.dart';
import 'package:pickup/ui/views/home/home_viewmodel.dart';
import 'package:pickup/ui/views/profile/driver_profile/driver_profile_view.dart';

@lazySingleton
class NotificationMessagesHandler {
  // HomeViewModel homeViewModel = locator<HomeViewModel>();

  void initialize() {
    onForegroundNotificationReceive();
    tapOnNotifications();
  }

  void onForegroundNotificationReceive() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      showBadge: true,
      //'This channel is used for important notifications.', // description
      importance: Importance.max,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/notification_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      //onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onForeGroundNotificationTap);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          'Just received a notification when driver app is in use   ${message.data['view']}');
      onNotificationReceived(message);
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      Map<String, dynamic>? notificationData = message.data;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        //onNotificationTap(message.data['view']);
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelShowBadge: channel.showBadge,
              icon: android.smallIcon,
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          payload:
              notificationData != null ? jsonEncode(notificationData) : null,
        );
      }
    });
  }

  void tapOnNotifications() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      actionToBePerformOnClick(message.data['view']);
    });
  }

  void actionToBePerformOnClick(String val) {
    switch (val) {
      case 'driverApproval':
        {
          print('driver approved many times');
          HomeViewModel homeViewModel = locator<HomeViewModel>();
          homeViewModel.profileApprovalStatus();
        }
        break;
      case 'makeAnOfferScreen':
        {
          print('new offer received');
          BottomBarViewModel bottomBarViewModel =
          locator<BottomBarViewModel>();
          bottomBarViewModel.pageController?.jumpTo(0);
          bottomBarViewModel.newPageNo(0);
        }
        break;
    }
  }

  void onForeGroundNotificationTap(NotificationResponse data) {
    var decodedData = json.decode(data.payload!);
    actionToBePerformOnClick(decodedData['view']);
    // switch(decodedData['view']){
    //   case 'driverApproval':{
    //       homeViewModel.profileApprovalStatus();
    //   }break;
    // }
  }

  void onNotificationReceived(RemoteMessage message) {
    print('on notification method call ${GetIt.instance.isRegistered<HomeViewModel>()} ');
    switch (message.data['view']) {
      case 'driverApproval':
        {
          if(GetIt.instance.isRegistered<HomeViewModel>() == false){
            GetIt.instance
                .registerSingleton<HomeViewModel>(HomeViewModel())
                .profileApprovalStatus();
          }
          else{
            HomeViewModel homeViewModel1 = locator<HomeViewModel>();
            homeViewModel1.profileApprovalStatus();
          }
          // locator<HomeViewModel>().profileApprovalStatus();
          //  HomeViewModel homeViewModel1 = locator<HomeViewModel>();
          // homeViewModel1.profileApprovalStatus();
        }
        break;
    }
  }
}
