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
  MapResult _mapResult = MapResult.emptyResult();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation App'),
        leading: const Icon(
          Icons.directions_walk_outlined,
          size: 27.0,
        ),
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
                        return 'Please enter an address';
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
                        return 'Please enter an address';
                      }
                      return null;
                    },
                    controller: _destinationAddressController,
                    decoration:
                        const InputDecoration(labelText: 'Destination Address'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _calculateRoute();
                      }
                    },
                    child: const Text('Calculate Route'),
                  ),
                ),
              ])),
          if (_mapResult.route != null && !_mapResult.route!.isOkay)
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
                  points: _mapResult.routePoints ?? [],
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
          if (_mapResult.route != null && _mapResult.distance != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('Walking Distance: ${_mapResult.distance}')],
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
    final result = await _mapService.calculateRoute(
        _startAddressController.text,
        _destinationAddressController.text,
        TravelMode.walking);

    setState(() {
      _mapResult = result;
    });

    if (result.bounds != null) {
      _mapController
          .animateCamera(CameraUpdate.newLatLngBounds(result.bounds!, 50));
    }
  }
}
