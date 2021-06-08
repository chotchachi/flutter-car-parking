import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_car_parking/data/model/location_place.dart';
import 'package:flutter_car_parking/pages/parking_place_sheet.dart';
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
                markers: snapshot.data.docs.map((DocumentSnapshot document) {
                  ParkingPlace parkingPlace =
                      ParkingPlace.fromJson(document.data());
                  return Marker(
                      markerId: MarkerId(document.id),
                      infoWindow: InfoWindow(title: parkingPlace.name),
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
}
