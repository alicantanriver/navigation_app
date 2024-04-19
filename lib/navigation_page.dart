import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show
        CameraPosition,
        CameraUpdate,
        GoogleMap,
        GoogleMapController,
        LatLng,
        Polyline,
        PolylineId;
import 'package:google_maps_webservice/directions.dart' hide Polyline;
import 'package:navigation_app/map_result.dart';
import 'package:navigation_app/map_service.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  NavigationPageState createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationPage> {
  late GoogleMapController _mapController;
  final _startAddressController = TextEditingController();
  final _destinationAddressController = TextEditingController();
  final _mapService = MapService();
  MapResult mapResult = MapResult.emptyResult();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation App'),
      ),
      body: Column(
        children: <Widget>[
          Form(
              key: _formKey,
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: _startAddressController,
                    decoration:
                        const InputDecoration(labelText: 'Start Address'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: _destinationAddressController,
                    decoration:
                        const InputDecoration(labelText: 'Destination Address'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _calculateRoute();
                    }
                  },
                  child: const Text('Calculate Route'),
                ),
              ])),
          if (mapResult.route != null && !mapResult.route!.isOkay)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No walking route found',
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
            ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              polylines: {
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: mapResult.routePoints ?? [],
                  color: Colors.blue,
                  width: 5,
                ),
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(48.8566, 2.3522), // Paris
                zoom: 10,
              ),
            ),
          ),
          if (mapResult.route != null && mapResult.distance != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('Walking Distance: ${mapResult.distance}')],
              ),
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
    final mapResult1 = await _mapService.calculateRoute(
        _startAddressController.text,
        _destinationAddressController.text,
        TravelMode.walking);

    if (!mapResult1.route!.isOkay) {}

    setState(() {
      mapResult = mapResult1;
    });

    _mapController
        .animateCamera(CameraUpdate.newLatLngBounds(mapResult1.bounds!, 50));
  }
}
