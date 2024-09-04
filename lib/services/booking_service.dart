import 'package:injectable/injectable.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/app/static_info.dart';
import 'package:http/http.dart' as http;

@injectable
class BookingService {
  Future getBookings() async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
    };
    http.Response response = await http
        .get('${baseUrl}drivers/driver_quotations'.toUri(), headers: headers);
   return response;
  }

  Future acceptOrRejectOffer(
      {required int offerId, required String status}) async {
    http.Response response = await http.put(
        '${baseUrl}/quotations/$offerId/update_status?status=$status'.toUri());
    return response;
  }

  Future getPaidServices()async{
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
    };
    http.Response response= await http.get('${baseUrl}drivers/paid_quotations'.toUri(),headers: headers);
    print('paid sevices are ${StaticInfo.authToken}');
    return response;
  }
}
