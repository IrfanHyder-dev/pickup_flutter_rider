import 'package:injectable/injectable.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:http/http.dart' as http;

@injectable
class HomeService {
  Future profileStatus() async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
    };
    http.Response response = await http.get(
        '${baseUrl}drivers/verify_driver_status'.toUri(),
        headers: headers);

    print('driver status response ${response.body}');
    return response;
  }

  Future getRideDateTime() async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
    };
    http.Response response = await http.post(
        '${baseUrl}drivers/driver_shift_time_update'.toUri(),
        headers: headers);
    print('Ride Time status response ${response.body}');
    return response;
  }

  Future getDriverDropOffLocation()async{
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
    };

    http.Response response = await http.get('${baseUrl}drivers/check_user_token'.toUri(),headers: headers);
    print('authtoken status response ${response.body}');
    return response;
  }
}
