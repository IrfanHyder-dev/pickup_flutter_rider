

class AddChildModel{
  String name;
  String startTime;
  String endTime;
  String schoolName;
  double dropOffLat;
  double dropOffLong;
  String dropOffLocation;

  AddChildModel({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.schoolName,
    required this.dropOffLat,
    required this.dropOffLong,
    required this.dropOffLocation,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'start_time': startTime,
      'end_time': endTime,
      'school_name': schoolName,
      'drop_off_lat': dropOffLat,
      'drop_off_long': dropOffLat,
      'drop_off_location': dropOffLocation,
    };
  }

}