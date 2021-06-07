import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_car_parking/data/model/location_place.dart';
import 'package:flutter_car_parking/widget/BottomSheet.dart';
import 'package:flutter_car_parking/widget/marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  @override
  State createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(16.0472484, 108.1716865);

  String searchText = "";

  @override
  void initState() {
    super.initState();
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
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return GoogleMap(
                onMapCreated: _onMapCreated,
                markers: snapshot.data.docs.map((DocumentSnapshot document) {
                  ParkingPlace parkingPlace = ParkingPlace(
                      document.data()['address'],
                      document.data()['contact'],
                      LatLng(document.data()['location'].latitude,
                          document.data()['location'].longitude),
                      document.data()['name'],
                      document.data()['price'],
                      document.data()['rating'],
                      document.data()['spots']);
                  return Marker(
                      markerId: MarkerId(""),
                      infoWindow: InfoWindow(title: parkingPlace.name),
                      icon: BitmapDescriptor.defaultMarker,
                      position: parkingPlace.location,
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return ParkingPlaceInfoSheet(
                                  parkingPlace: parkingPlace);
                            });
                      });
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
        ],
      ),
    );
  }

  _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
