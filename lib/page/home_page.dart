import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Parking Tracking'),
      //   centerTitle: true,
      // ),
      body: Container(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {},
              initialCameraPosition: CameraPosition(
                  target: LatLng(16.047079, 108.206230), zoom: 15.0),
            ),
            Positioned(
                top: 40,
                left: 20,
                child: FloatingActionButton(
                  child: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  backgroundColor: Colors.white,
                  onPressed: () => null,
                )),
            Positioned.fill(
                child: DraggableScrollableSheet(
              maxChildSize: 0.7,
              builder: (_, controller) {
                return Container(
                  color: Colors.red,
                  child: ListView.builder(
                    controller: controller,
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Index :$index'),
                      );
                    },
                  ),
                );
              },
            ))
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.location_on_outlined),
            title: Text('Find Parking'),
            activeColor: Colors.blueAccent,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.local_gas_station),
            title: Text('Find Petrol'),
            activeColor: Colors.blueAccent,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.miscellaneous_services),
            title: Text('Garage Service'),
            activeColor: Colors.blueAccent,
            inactiveColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
