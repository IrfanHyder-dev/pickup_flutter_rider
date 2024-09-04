import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:http/http.dart' as http;

@injectable
class NotificationService{
  Future fetchNotifications() async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
    };
    http.Response response = await http.get(
        '${baseUrl}drivers/driver_notifications'.toUri(),
        headers: headers);
    return response;
  }

  Future markNotificationRead({required int id}) async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
    };
    http.Response response = await http.put(
        '${baseUrl}notifications/$id/mark_as_read'.toUri(),
        headers: headers);
    print('read ${response.body}  ${response.statusCode}');
    return response;
  }

  Future deleteNotification({required int id}) async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
    };
    http.Response response = await http.delete(
        '${baseUrl}notifications/$id/delete_notification'.toUri(),
        headers: headers);
    return response;
  }

  Future stopNotification({required bool status}) async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
    };
    http.Response response = await http.put(
      '${baseUrl}notifications/stop_notification'.toUri(),
      headers: headers,
      body: {'driver_id': StaticInfo.driverModel!.id.toString(),'status': status.toString(),},

    );
    print('stop notification ${response.body}');
    return response;
  }
}
