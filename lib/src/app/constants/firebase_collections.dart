import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class FBCollections {
  static CollectionReference drivers = db.collection("drivers");
  static CollectionReference rideStatus = db.collection("ride_status");


}
