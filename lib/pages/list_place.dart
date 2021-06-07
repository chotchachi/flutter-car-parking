import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_car_parking/widget/Rating.dart';

class ParkingList extends StatefulWidget {
  @override
  State createState() => _ParkingList();
}

class _ParkingList extends State<ParkingList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isLoggedIn = false;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("start");
      }
    });
  }

  getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isLoggedIn = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("booking_history")
            .doc(user.uid)
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
                              '${document.data()['name']}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17.5,
                                  letterSpacing: 0.2),
                            ),
                            subtitle: Text(
                              '${document.data()['address']}',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.5,
                                  letterSpacing: 0.1),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: StarRating(
                                    size: 20,
                                    color: Colors.yellow[600],
                                    rating:
                                        document.data()['rating'].toDouble(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Text(
                                    '${document.data()['price']}',
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
