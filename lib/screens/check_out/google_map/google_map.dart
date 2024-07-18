import 'package:flutter/material.dart';
import 'package:raj_eat/config/colors.dart';
import 'package:raj_eat/providers/check_out_provider.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CostomGoogleMap extends StatefulWidget {
  const CostomGoogleMap({super.key});

  @override
  _GoogleMapState createState() => _GoogleMapState();
}

class _GoogleMapState extends State<CostomGoogleMap> {
  final LatLng _initialcameraposition = const LatLng(36.7948, 10.0608);
  late GoogleMapController controller;
  final Location _location = Location();
  void _onMapCreated(GoogleMapController value) {
    controller = value;
    _location.onLocationChanged.listen((event) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: _initialcameraposition, zoom: 13),
        ),
      );
    });
    Set<Marker> markers = {};
  }
  @override
  Widget build(BuildContext context) {
    CheckoutProvider checkoutProvider = Provider.of(context);
    return Scaffold(
        body: SafeArea(
        child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
          child: Stack(
           children: [
            GoogleMap(initialCameraPosition: CameraPosition(
              target: _initialcameraposition,zoom: 13,
            ),
              markers: {
              Marker(
                markerId: MarkerId("marker_1"),
                icon: BitmapDescriptor.defaultMarker,
                position: _initialcameraposition
              )
              },
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              width: double.infinity,
              margin:
              const EdgeInsets.only(right: 60, left: 10, bottom: 40, top: 40),
              child: MaterialButton(
                onPressed: () async {
                  await _location.getLocation().then((value) {
                    setState(() {
                      checkoutProvider.setLoaction = value;
                    });
                  });
                  Navigator.of(context).pop();
                },
                color: primaryColor,
                shape: const StadiumBorder(),
                child: const Text("Set Location"),
              ),
            ),
          ),
            ],
    ),
        ),
        ),
    );
  }
  Future<void> getLocationUpdates() async{
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    

  }

