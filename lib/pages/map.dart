import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_car_parking/data/model/location_place.dart';
import 'package:flutter_car_parking/widget/BottomSheet.dart';
import 'package:flutter_car_parking/widget/marker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapView extends StatefulWidget {
  @override
  State createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   leading: Padding(
      //     padding: const EdgeInsets.only(left: 10.0),
      //     child: GestureDetector(
      //       onTap: () {
      //         Navigator.pop(context, true);
      //       },
      //       child: Icon(
      //         Icons.arrow_back,
      //         color: Colors.black.withOpacity(0.6),
      //         size: 20,
      //       ),
      //     ),
      //   ),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      body: Stack(
        children: <Widget>[
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
          StreamBuilder(
            stream:
            FirebaseFirestore.instance.collection("parking_place").snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return FlutterMap(
                options: MapOptions(
                    center: LatLng(16.0472484, 108.1716865),
                    minZoom: 13.5,
                    maxZoom: 14.5,
                    zoom: 14.0),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                      "http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}",
                      subdomains: ['mt0', 'mt1', 'mt2', 'mt3']),
                  MarkerLayerOptions(
                    markers: snapshot.data.docs.map((DocumentSnapshot document) {
                      return Marker(
                          width: 40,
                          height: 40,
                          point: LatLng(document.data()['location'].latitude, document.data()['location'].longitude),
                          builder: (context) {
                            return CustomMarker(Icons.local_parking,'34');
                          }
                      );
                    }).toList()
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
