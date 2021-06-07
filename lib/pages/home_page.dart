import 'package:flutter/material.dart';
import 'package:flutter_car_parking/pages/listparking.dart';
import 'package:flutter_car_parking/pages/map.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter_car_parking/pages/user_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  //page
  List<Widget> page;
  Widget currentPage;
  ProfileView profileView;
  ListParkingView parkingView;
  MapView mapPage;

  @override
  void initState() {
    mapPage = MapView();
    parkingView = ListParkingView();
    profileView = ProfileView();
    page = [
      mapPage,
      parkingView,
      profileView,
    ];
    currentPage = mapPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Positioned.fill(
      //     child: DraggableScrollableSheet(
      //   maxChildSize: 0.7,
      //   builder: (_, controller) {
      //     return Container(
      //       color: Colors.red,
      //       child: ListView.builder(
      //         controller: controller,
      //         itemCount: 20,
      //         itemBuilder: (context, index) {
      //           return ListTile(
      //             title: Text('Index :$index'),
      //           );
      //         },
      //       ),
      //     );
      //   },
      // ))

      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
            currentPage = page[index];
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
            icon: Icon(Icons.local_parking),
            title: Text('List Parking'),
            activeColor: Colors.blueAccent,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.supervised_user_circle_sharp),
            title: Text('My profile'),
            activeColor: Colors.blueAccent,
            inactiveColor: Colors.black,
          ),
        ],
      ),
      body: currentPage,
    );
  }
}
