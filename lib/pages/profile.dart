import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_car_parking/data/model/booking.dart';

class Profile extends StatefulWidget {
  @override
  State createState() => _Profile();
}

class _Profile extends State<Profile> {
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
      body: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 24.0, horizontal: 24),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            elevation: 6,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6)),
            onPressed: () {
              _auth.signOut();
              Navigator.of(context).pushReplacementNamed("start");
            },
            color: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Text(
              'LOG OUT',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  wordSpacing: 4,
                  letterSpacing: 0.3),
            ),
          ),
        ),
      ),
    );
  }
}
