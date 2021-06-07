import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_car_parking/data/model/location_place.dart';
import 'package:flutter_car_parking/widget/BottomSheet.dart';
import 'package:flutter_car_parking/widget/marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
Position _currentPosition;
String _currentAddress;

class MapView extends StatefulWidget {
  @override
  State createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(16.0472484, 108.1716865);

  List<Marker> customMarkers = [];

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
            stream: FirebaseFirestore.instance
                .collection("parking_place")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return GoogleMap(
                onMapCreated: _onMapCreated,
                markers: snapshot.data.docs.map((DocumentSnapshot document) {
                  return Marker(
                    markerId: MarkerId(""),
                    infoWindow: InfoWindow(
                      title: document.data()['name']
                    ),
                    icon: BitmapDescriptor.defaultMarker,
                    position: LatLng(document.data()['location'].latitude,
                        document.data()['location'].longitude),
                    onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return ParkingPlaceInfoSheet(
                                  parkingPlace: ParkingPlace(
                                      document.data()['name'],
                                      document.data()['address'],
                                      document.data()['price'],
                                      ParkingLocation(
                                          document.data()['location'].latitude,
                                          document
                                              .data()['location']
                                              .longitude),
                                      document.data()['rating']));
                            });
                      }
                  );
                }).toSet(),
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 10.0,
                ),
              );
            },
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
                      //TODO()
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

  _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  _getCurrentLocation() {
    geolocator
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
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
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
}
