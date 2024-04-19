import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:navigation_app/map_result.dart';

class MapService {
  final directions =
      GoogleMapsDirections(apiKey: 'AIzaSyB7D2exC22ybsWoKOhed_xQAVSvUP1rqak');

  Future<MapResult> calculateRoute(
      String start, String destination, TravelMode mode) async {
    DirectionsResponse route = await directions.directionsWithAddress(
      start,
      destination,
      travelMode: mode,
    );

    List<LatLng>? routePoints = [];
    String? distance;
    String? duration;
    LatLngBounds? bounds;

    if (route.isOkay) {
      for (var step in route.routes.first.legs.first.steps) {
        routePoints.addAll(_decodePolyline(step.polyline.points));
      }
      distance = route.routes.first.legs.first.distance.text;
      duration = route.routes.first.legs.first.duration.text;
      bounds = _boundsFromLatLngList(routePoints);
    }

    return new MapResult(route, routePoints, distance, duration, bounds);
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
      southwest: LatLng(x0!, y0!),
      northeast: LatLng(x1!, y1!),
    );
  }
}
