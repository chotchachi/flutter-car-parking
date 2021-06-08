import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_car_parking/data/model/location_place.dart';
import 'package:flutter_car_parking/pages/parking_place_sheet.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin;

class MapView extends StatefulWidget {
  @override
  State createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  /// Map
  GoogleMapController mapController;
  CameraPosition _initialLocation =
      CameraPosition(target: LatLng(0.0, 0.0), zoom: 10.0);
  Set<Marker> markers = {};

  String _startAddress = '';
  String _destinationAddress = '';
  String _placeDistance = '';

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<bool> _calculateDistance(GeoPoint destinationPoint) async {
    double startLatitude = _startAddress == _currentAddress
        ? _currentPosition.latitude
        : 15.979068614298885;

    double startLongitude = _startAddress == _currentAddress
        ? _currentPosition.longitude
        : 108.25042895766998;

    double destinationLatitude = destinationPoint.latitude;
    double destinationLongitude = destinationPoint.longitude;

    String startCoordinatesString = '($startLatitude, $startLongitude)';
    String destinationCoordinatesString =
        '($destinationLatitude, $destinationLongitude)';

    Marker startMarker = Marker(
      markerId: MarkerId(startCoordinatesString),
      position: LatLng(startLatitude, startLongitude),
      infoWindow: InfoWindow(
        title: 'Start $startCoordinatesString',
        snippet: _startAddress,
      ),
      icon: BitmapDescriptor.defaultMarker,
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId(destinationCoordinatesString),
      position: LatLng(destinationLatitude, destinationLongitude),
      infoWindow: InfoWindow(
        title: 'Destination $destinationCoordinatesString',
        snippet: _destinationAddress,
      ),
      icon: BitmapDescriptor.defaultMarker,
    );

    markers.add(startMarker);
    markers.add(destinationMarker);

    print(
      '>>> START COORDINATES: ($startLatitude, $startLongitude)',
    );
    print(
      '>>> DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
    );

    double miny = (startLatitude <= destinationLatitude)
        ? startLatitude
        : destinationLatitude;
    double minx = (startLongitude <= destinationLongitude)
        ? startLongitude
        : destinationLongitude;
    double maxy = (startLatitude <= destinationLatitude)
        ? destinationLatitude
        : startLatitude;
    double maxx = (startLongitude <= destinationLongitude)
        ? destinationLongitude
        : startLongitude;

    double southWestLatitude = miny;
    double southWestLongitude = minx;

    double northEastLatitude = maxy;
    double northEastLongitude = maxx;

    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(northEastLatitude, northEastLongitude),
          southwest: LatLng(southWestLatitude, southWestLongitude),
        ),
        100.0,
      ),
    );

    await _createPolylines(startLatitude, startLongitude, destinationLatitude,
        destinationLongitude);

    double totalDistance = 0.0;

    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += _coordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude,
      );
    }

    setState(() {
      _placeDistance = totalDistance.toStringAsFixed(2);
      print('>>> DISTANCE: $_placeDistance km');
    });

    return true;
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    print(
        ">>> $startLatitude - $startLongitude - $destinationLatitude - $destinationLongitude");

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBvWYZCRShTbdhMF--MNOFJKhkhZoB2-vc",
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.transit,
    );

    polylineCoordinates.clear();

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

  /// Locator
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;

  _getCurrentLocation() {
    geoLocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geoLocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  /// Search
  String searchText = "";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          /// Map View
          StreamBuilder(
            stream: searchText.isNotEmpty
                ? FirebaseFirestore.instance
                    .collection("parking_place")
                    .where("name", isEqualTo: searchText)
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection("parking_place")
                    .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Something went wrong'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                initialCameraPosition: _initialLocation,
                polylines: Set<Polyline>.of(polylines.values),
                markers: snapshot.data.docs.map((DocumentSnapshot document) {
                  ParkingPlace parkingPlace =
                      ParkingPlace.fromJson(document.data());
                  return Marker(
                      markerId: MarkerId(document.id),
                      infoWindow: InfoWindow(
                          title: parkingPlace.name,
                          snippet: "Tap to direction",
                          onTap: () {
                            _calculateDistance(parkingPlace.location);
                          }),
                      icon: BitmapDescriptor.defaultMarker,
                      position: LatLng(parkingPlace.location.latitude,
                          parkingPlace.location.longitude),
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return ParkingPlaceInfoSheet(
                                  key: Key(document.id),
                                  parkingPlace: parkingPlace);
                            });
                      });
                }).toSet(),
              );
            },
          ),

          /// My Location Button
          SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                child: ClipOval(
                  child: Material(
                    color: Colors.orange.shade100, // button color
                    child: InkWell(
                      splashColor: Colors.orange, // inkwell color
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(Icons.my_location),
                      ),
                      onTap: () {
                        mapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(
                                _currentPosition.latitude,
                                _currentPosition.longitude,
                              ),
                              zoom: 18.0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// Search View
          Padding(
            padding: const EdgeInsets.only(
                left: 28, top: 100, right: 28, bottom: 10),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
                side: BorderSide.none,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListTile(
                  title: TextField(
                    enabled: true,
                    decoration: InputDecoration.collapsed(
                        hintText: 'Search parking place',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.grey[500],
                            letterSpacing: 0.2)),
                    onChanged: (text) {
                      //TODO("")
                    },
                  ),
                  trailing: Icon(
                    Icons.search,
                    size: 27,
                    color: Colors.orange[400],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
