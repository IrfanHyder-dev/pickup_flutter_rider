class RoutesModel {
  String? encodedPolyline;
  List<int>? optimizedIntermediateWaypointIndex;
  LocalizedValues? localizedValues;

  RoutesModel(
      {this.encodedPolyline,
        this.optimizedIntermediateWaypointIndex,
        this.localizedValues});

  RoutesModel.fromJson(Map<String, dynamic> json) {
    encodedPolyline = json['encodedPolyline'];
    optimizedIntermediateWaypointIndex =
        json['optimizedIntermediateWaypointIndex'].cast<int>();
    localizedValues = json['localizedValues'] != null
        ? new LocalizedValues.fromJson(json['localizedValues'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['encodedPolyline'] = this.encodedPolyline;
    data['optimizedIntermediateWaypointIndex'] =
        this.optimizedIntermediateWaypointIndex;
    if (this.localizedValues != null) {
      data['localizedValues'] = this.localizedValues!.toJson();
    }
    return data;
  }
}

class LocalizedValues {
  Distance? distance;
  Distance? duration;
  Distance? staticDuration;

  LocalizedValues({this.distance, this.duration, this.staticDuration});

  LocalizedValues.fromJson(Map<String, dynamic> json) {
    distance = json['distance'] != null
        ? new Distance.fromJson(json['distance'])
        : null;
    duration = json['duration'] != null
        ? new Distance.fromJson(json['duration'])
        : null;
    staticDuration = json['staticDuration'] != null
        ? new Distance.fromJson(json['staticDuration'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.distance != null) {
      data['distance'] = this.distance!.toJson();
    }
    if (this.duration != null) {
      data['duration'] = this.duration!.toJson();
    }
    if (this.staticDuration != null) {
      data['staticDuration'] = this.staticDuration!.toJson();
    }
    return data;
  }
}

class Distance {
  String? text;

  Distance({this.text});

  Distance.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    return data;
  }
}