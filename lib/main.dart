import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:pickup/notification_messages_handler.dart';
import 'package:pickup/src/app/locator.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:pickup/src/language/languages.dart';
import 'package:pickup/src/language/locales.dart';
import 'package:pickup/src/theme/theme.dart';
import 'package:pickup/ui/views/splash/splash_view.dart';
import 'package:pickup/ui/widgets/pop_scope_dialog_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();

  fcmToken();
  await Alarm.init(showDebugLogs: true);
  runApp(const MyApp());
}

void fcmToken() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  String? token = await FirebaseMessaging.instance.getToken();
  print('fcm token is $token');
  StaticInfo.fcmToken = token;
  locator<NotificationMessagesHandler>().initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('dddddddddddddddddd ${message.data}');
  NotificationMessagesHandler().onNotificationReceived(message);

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    //Utils.setStatusBarColor(Colors.black);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled = false;
    return WillPopScope(
      onWillPop: () async {
        bool? shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return PopScopeDialogWidget();
          },
        );
        if (shouldPop == true) {
          MoveToBackground.moveTaskToBack();
          return false;
        } else {
          return false;
        }
      },
      child: GetMaterialApp(
        //title: appNameKey.tr,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.getTheme(),
        translations: Languages(),
        locale: engLocale,
        fallbackLocale: engLocale,
        supportedLocales: const [
          engLocale,
          urLocale,
        ],
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        home: SplashView(),
        // home: WelcomeView(),
      ),
    );
  }
}
