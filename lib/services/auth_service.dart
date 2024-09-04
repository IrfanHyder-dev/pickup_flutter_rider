import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:pickup/services/shared_preference.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/app/static_info.dart';

@injectable
class AuthService {
  Future signUpDriver({
    required String name,
    required String surName,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    Map<String, dynamic> body = {
      "name": name,
      "surname": surName,
      "contact_number": phoneNumber,
      "email": email,
      "password": password,
      "address": '',
      "fcm_token[]": StaticInfo.fcmToken,
    };

    http.Response response =
        await http.post("${baseUrl}drivers".toUri(), body: body);
    return response;
  }

  Future loginDriver({
    String? email,
    String? phoneNo,
    String? password,
  }) async {
    try {
      print('fcm token is ${StaticInfo.fcmToken}');
      Map<String, dynamic> body = {
        'email': email,
        'password': password,
        'contact_no': phoneNo,
        "fcm_token[]": StaticInfo.fcmToken,
      };
      http.Response response =
          await http.post('${baseUrl}driver/driver_login'.toUri(), body: body);
      print('login method auth service');
      response.statusCode.debugPrint();
      response.body.debugPrint();
      return response;
    } catch (e) {
      print("error = $e");
    }
  }

  Future resetPassword({required String email}) async {
    http.Response response = await http.get(
      '${baseUrl}drivers/forgot_password?email=$email'.toUri(),
      //headers: headers
    );

    return response;
  }

  Future otpVerificationCode({required otpCode}) async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
    };

    print('auth token is ${StaticInfo.authToken}');
    http.Response response = await http.get(
        '${baseUrl}drivers/verify_otp?otp=$otpCode'.toUri(),
        headers: headers);
    print('otp response is  ${response.body}');

    return response;
  }

  Future logout() async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
    };
    http.Response response =
        await http.post('${baseUrl}drivers/logout'.toUri(), headers: headers);
    SharedPreferencesService().clearUser();
    print('logout response is ${response.body}');
  }

  Future changePassword(
      {required String oldPassword, required String newPassword}) async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
    };
    Map<String, dynamic> body = {
      'current_password': oldPassword,
      'new_password': newPassword,
    };

    http.Response response = await http.post(
        '${baseUrl}drivers/change_password'.toUri(),
        headers: headers,
        body: body);

    print('logout response is ${response.body}');
    return response;
  }

  Future authTokenVerification(String authToken) async {
    Map<String, String> headers = {
      'Authorization': authToken,
    };
    http.Response? response;
    try {
      response = await http.get('${baseUrl}drivers/check_user_token'.toUri(),
          headers: headers);
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        print(decodedResponse);
        if (decodedResponse['success'] == true) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
