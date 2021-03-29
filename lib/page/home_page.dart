import 'package:flutter/material.dart';
import 'package:flutter_car_parking/page/find_petrol.dart';
import 'package:flutter_car_parking/page/garage_service.dart';
import 'package:flutter_car_parking/page/maps_page.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  //page
  List<Widget> page;
  Widget currentPage;
  FindPetrol findPetrol;
  GarageService garageService;

  MapPage mapPage;

  @override
  void initState() {
    mapPage = MapPage();
    garageService = GarageService();
    findPetrol = FindPetrol();
    page = [
      mapPage,
      findPetrol,
      garageService,
    ];
    currentPage = mapPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          _currentIndex == 1
              ? "Find Petrol"
              : _currentIndex == 2
                  ? "Garage Service"
                  : "",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
      ),

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
      body: currentPage,
    );
  }
}
