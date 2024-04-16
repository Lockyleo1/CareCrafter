import 'package:care_crafter/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Position? currentPosition;
  Set<Marker> markers = Set();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      currentPosition = position;
    });
    _fetchNearbyPharmacies(position.latitude, position.longitude);
  }

  Future<void> _fetchNearbyPharmacies(double lat, double lng) async {
    final apiKey = 'AIzaSyB1ioL0uyegQCxWVHchU8suDD-93bgG2dM';
    final radius = 10000;

    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
        'location=$lat,$lng'
        '&radius=$radius'
        '&type=pharmacy'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final results = decoded['results'] as List<dynamic>;
      for (var result in results) {
        final pharmacyName = result['name'];
        final pharmacyLat = result['geometry']['location']['lat'];
        final pharmacyLng = result['geometry']['location']['lng'];
        final marker = Marker(
          markerId: MarkerId(pharmacyName),
          position: LatLng(pharmacyLat, pharmacyLng),
          infoWindow: InfoWindow(
            title: pharmacyName,
            snippet: 'Farmacia nelle vicinanze',
          ),
        );
        setState(() {
          markers.add(marker);
        });
      }
    } else {
      throw Exception('Errore nel caricamento farmacie');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmacie vicino a me'),
      ),
      body: currentPosition != null
          ? GoogleMap(
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  currentPosition!.latitude,
                  currentPosition!.longitude,
                ),
                zoom: 15,
              ),
              markers: markers,
              circles: _buildCircles(),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  Set<Circle> _buildCircles() {
    return currentPosition != null
        ? Set.from([
            Circle(
              circleId: CircleId('Current Location Circle'),
              center:
                  LatLng(currentPosition!.latitude, currentPosition!.longitude),
              radius: 100,
              fillColor: Colors.blue.withOpacity(0.3),
              strokeColor: Colors.blue,
              strokeWidth: 2,
            ),
          ])
        : Set();
  }
}
