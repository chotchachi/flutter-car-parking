import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_car_parking/data/model/booking.dart';

class ParkingList extends StatefulWidget {
  @override
  State createState() => _ParkingList();
}

class _ParkingList extends State<ParkingList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _currentUser;
  bool _isLoading = false;

  getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this._currentUser = firebaseUser;
        this._isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this._isLoading = true;
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    if (this._isLoading)
      return Center(
        child: CircularProgressIndicator(),
      );
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("booking_history")
            .doc(this._currentUser.uid)
            .collection("booking_history")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              BookingParking bookingParking =
                  BookingParking.fromJson(document.data());

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24),
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 6,
                    color: Colors.black.withOpacity(0.8),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              bookingParking.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17.5,
                                  letterSpacing: 0.2),
                            ),
                            subtitle: Text(
                              bookingParking.address,
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.5,
                                  letterSpacing: 0.1),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Text(
                                    'Total price: ${bookingParking.unitPrice * bookingParking.hours} \$',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 17),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
