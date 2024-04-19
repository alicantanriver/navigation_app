import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';

class MapResult {
  DirectionsResponse? route;
  List<LatLng>? routePoints;
  String? distance;
  String? duration;
  LatLngBounds? bounds;

  MapResult.emptyResult();

  MapResult(
      this.route, this.routePoints, this.distance, this.duration, this.bounds);
}
