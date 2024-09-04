
import 'package:injectable/injectable.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:http/http.dart' as http;

@injectable
class HistoryService{
  Future driverRideHistory() async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
    };

    http.Response response = await http
        .get('${baseUrl}drivers/ride_histories'.toUri(), headers: headers);
    print('driver ride history ${response.body}');
    return response;
  }

  Future driverPaymentHistory() async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
    };

    http.Response response = await http
        .get('${baseUrl}drivers/payment_history'.toUri(), headers: headers);
    print('driver payment history ${response.body}');
    return response;
  }
}