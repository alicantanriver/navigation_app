import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';

class MapResult {
  DirectionsResponse? route;
  List<LatLng>? routePoints;
  String? distance;
  String? duration;
  LatLngBounds? bounds;

  MapResult.emptyResult() {}

  MapResult(DirectionsResponse? route, List<LatLng>? routePoints,
      String? distance, String? duration, LatLngBounds? bounds) {
    this.route = route;
    this.routePoints = routePoints;
    this.distance = distance;
    this.duration = duration;
    this.bounds = bounds;
  }
}
