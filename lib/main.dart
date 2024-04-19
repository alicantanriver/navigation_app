import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show CameraPosition, CameraUpdate, GoogleMap, GoogleMapController, LatLng, LatLngBounds, Polyline, PolylineId;
import 'package:google_maps_webservice/directions.dart' hide Polyline;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NavigationPage(),
    );
  }
}

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  NavigationPageState createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationPage> {
  late GoogleMapController _mapController;
  final TextEditingController _startAddressController = TextEditingController();
  final TextEditingController _destinationAddressController = TextEditingController();
  late DirectionsResponse _route;
  final List<LatLng> _routePoints = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation App'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _startAddressController,
              decoration: const InputDecoration(
                labelText: 'Start Address',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _destinationAddressController,
              decoration: const InputDecoration(
                labelText: 'Destination Address',
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              polylines: {
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: _routePoints,
                  color: Colors.blue,
                  width: 5,
                ),
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 10,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _calculateRoute,
            child: const Text('Calculate Route'),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  Future<void> _calculateRoute() async {
    final directions = GoogleMapsDirections(apiKey: 'AIzaSyB7D2exC22ybsWoKOhed_xQAVSvUP1rqak');
    final route = await directions.directionsWithAddress(
      _startAddressController.text,
      _destinationAddressController.text,
      travelMode: TravelMode.walking,
    );

    setState(() {
      _route = route;
      _routePoints.clear();
      if (route.isOkay) {
        for (var step in route.routes.first.legs.first.steps) {
          _routePoints.addAll(_decodePolyline(step.polyline.points));
        }
      }
    });

    _mapController.animateCamera(CameraUpdate.newLatLngBounds(
        _boundsFromLatLngList(_routePoints), 50));
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

