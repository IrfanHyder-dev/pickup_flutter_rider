import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';
import 'package:pickup/models/fetch_child_details.dart';
import 'package:pickup/src/app/constants/constants.dart';
import 'package:pickup/src/app/enums/app_enums.dart';
import 'package:pickup/src/app/extensions.dart';
import 'package:pickup/src/app/static_info.dart';

/// eyJhbGciOiJIUzI1NiJ9.eyJkcml2ZXJfaWQiOjE0LCJleHAiOjE3MDgyNTY3NDF9.Q90JPftDNpeJlpRkWgGrAl54FIVYwX7Ht4mdYnL0nbQ

@injectable
class RoutesServices {
  Future fetchChildDetails() async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
    };

    http.Response response = await http
        .get('${baseUrl}drivers/child_list'.toUri(), headers: headers);
    return response;
  }

  Future notifyParentDriverArrivedSoon({required int childId}) async {
    print('=================> notify parent services func called  $childId');
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
    };

    Map<String, dynamic> body = {
      'child_id': childId,
    };
    http.Response response = await http.post(
        '${baseUrl}notifications/send_parent_notification?child_id=$childId'
            .toUri());
    print('=======================> notify parent that driver arrived soon');
    return response;
  }

  Future startRideAndResetRideStatus(
      {required String rideShiftType,
      required Position currentLocation}) async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
    };
    http.Response response = await http.get(
        '${baseUrl}drivers/start_ride?shift_type=$rideShiftType&latitude=${currentLocation.latitude}&longitude=${currentLocation.longitude}'
            .toUri(),
        headers: headers);
    print('start ride status   $response');
    return response;
  }

  Future finishRideStatus(
      {required String rideShiftType,
      required Position currentLocation}) async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
    };
    print(
        'url url url ${baseUrl}drivers/start_ride?shift_type=$rideShiftType&latitude=${currentLocation.latitude}&longitude=${currentLocation.longitude}');
    http.Response response = await http.get(
        '${baseUrl}drivers/end_ride?shift_type=$rideShiftType&latitude=${currentLocation.latitude}&longitude=${currentLocation.longitude}'
            .toUri(),
        headers: headers);
    print('start ride status   ${response.body}');
    return response;
  }

  Future skipChild({
    required int childId,
    required int quotationId,
  }) async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
    };
    Map<String, String> body = {
      'status': 'not_going',
    };
    http.Response response = await http.put(
        '${baseUrl}drivers/$childId/update_child_ride_status?status=not_going&quotation_id=$quotationId'
            .toUri(),
        headers: headers);
    return response;
  }

  Future rideStatus({
    required List<ChangeChildStatus> changeChildStatusList,
    required String status,
  }) async {
    Map<String, String> headers = {
      'Authorization': StaticInfo.authToken,
    };

    http.MultipartRequest request = http.MultipartRequest(
      "POST",
      "${baseUrl}/drivers/change_child_ride_status".toUri(),
    );

    // List<http.MultipartFile> childIdsList = [];
    List<String> encodedChildIdsBody = [];
    List<http.MultipartFile> childIdsQuotationIds = [];
    // for (var id in childIds) {
    //   var f = await http.MultipartFile.fromString("child_ids", id.toString());
    //   childIdsList.add(f);
    // }

    for(ChangeChildStatus child in changeChildStatusList){
      Map<String, int> body = {
        "quotation_id" :  child.quotationId,
        "child_ids" : child.childId,
      };
      encodedChildIdsBody.add(jsonEncode(body));
    }

    for(String data in encodedChildIdsBody){
      var f =http.MultipartFile.fromString("child_id_quotationId[]", data);
      childIdsQuotationIds.add(f);
    }



    // request.files.addAll(childIdsList);
    request.files.addAll(childIdsQuotationIds);
    request.fields["status"] = status;
    // request.fields["quotation_id"] = quotationId.toString();
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print('ride status service ${response.statusCode}');
    return response;
  }
}
