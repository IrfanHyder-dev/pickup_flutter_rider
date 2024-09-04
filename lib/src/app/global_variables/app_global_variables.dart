import 'dart:async';

import 'package:location/location.dart';

StreamSubscription<LocationData>? locationSubscription;
Timer? checkDriverIsInRadiusTimer;