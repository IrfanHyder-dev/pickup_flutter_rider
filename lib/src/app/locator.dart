import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pickup/notification_messages_handler.dart';
import 'package:pickup/services/auth_service.dart';
import 'package:pickup/services/booking_service.dart';
import 'package:pickup/services/history_service.dart';
import 'package:pickup/services/home_service.dart';
import 'package:pickup/services/notification_service.dart';
import 'package:pickup/services/profile_service.dart';
import 'package:pickup/services/routes_services.dart';
import 'package:pickup/services/shared_preference.dart';
import 'package:pickup/ui/views/bottom_bar/bottom_bar_viewmodel.dart';
import 'package:pickup/ui/views/home/home_viewmodel.dart';
import 'package:pickup/ui/views/profile/driver_profile/driver_profile_viewmodel.dart';

final locator = GetIt.instance;

@injectableInit
Future<void> setupLocator() async {
  await SharedPreferencesService().init();
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => ProfileService());
  locator.registerLazySingleton(() => HomeService());
  locator.registerLazySingleton(() => DriverProfileViewModel());
  locator.registerLazySingleton(() => NotificationService());
  locator.registerLazySingleton(() => BookingService());
  locator.registerLazySingleton(()=> RoutesServices());
  locator.registerLazySingleton(()=> HistoryService());
  // locator.registerLazySingleton(() => HomeViewModel());
  locator.registerSingleton<HomeViewModel>(HomeViewModel());
  locator.registerLazySingleton(() => NotificationMessagesHandler());
  // locator.registerLazySingleton(() => BottomBarViewModel());
  // locator.registerSingleton<HomeViewModel>(HomeViewModel());

  /// ViewModel register
  locator.registerSingleton<BottomBarViewModel>(BottomBarViewModel());
}
