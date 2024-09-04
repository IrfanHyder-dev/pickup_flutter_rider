import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:pickup/models/user_firebase_model.dart';
import 'package:pickup/src/app/constants/firebase_collections.dart';

class FirebaseServices {
  /*================== Driver Functions ======================*/
  static Future<String?> checkUserInDB(String userID) async {
    try {
      DocumentSnapshot userDocument =
          await FBCollections.drivers.doc(userID).get();
      if (userDocument.exists) {
        return userDocument.id;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Error in checking user in DB \n\n\n $e");
      return null;
    }
  }

  static Stream<UserFirebaseModel> fetchDriverStreamData(String id) {
    Stream<DocumentSnapshot<Object?>> ref =
        FBCollections.drivers.doc(id).snapshots().asBroadcastStream();
    return ref.map((event) => UserFirebaseModel.fromJson(event.data()));
  }

  static Future<UserFirebaseModel> fetchUSerData(String id) async {
    var ref = await FBCollections.drivers.doc(id).get();
    UserFirebaseModel data = UserFirebaseModel.fromJson(ref.data());
    return data;
  }

  static setUserData(
      {required UserFirebaseModel userFirebaseModel,
      required String id}) async {
    await FBCollections.drivers.doc(id).set(userFirebaseModel.toJson());
  }

  /*================== Ride status Functions ======================*/

  static Future<RideStatusModel?> getRideStatusDoc(
      String? driverFirebaseDocID) async {
    try {
      if (driverFirebaseDocID != null) {
        return await FBCollections.rideStatus
            .where("driver_firebase_id", isEqualTo: driverFirebaseDocID)
            .limit(1)
            .get()
            .then((value) async {
          if (value.docs.length > 0) {
            var data =
                await FBCollections.rideStatus.doc(value.docs.first.id).get();

            RideStatusModel rideStatusModel =
                RideStatusModel.fromJson(data.data());
            return rideStatusModel;
          } else {
            return null;
          }
        });
      }
      return null;
    } catch (e) {
      debugPrint("Error in checking ride status in DB \n\n\n $e");

      return null;
    }
  }

  static setDriverRideStatus({required RideStatusModel rideStatusModel}) async {
    await FBCollections.rideStatus
        .doc(rideStatusModel.rideStatusId)
        .set(rideStatusModel.toJson())
        .then((value) {})
        .onError((error, stackTrace) {
      debugPrint('============================== error ${error}');
    });
  }
}
