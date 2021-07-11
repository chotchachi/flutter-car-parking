import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_car_parking/data/model/booking.dart';
import 'package:flutter_car_parking/data/model/location_place.dart';

class MyPaymentPage extends StatefulWidget {
  final ParkingPlace parkingPlace;

  const MyPaymentPage({Key key, this.parkingPlace}) : super(key: key);

  @override
  State createState() => _MyPaymentPageState();
}

class _MyPaymentPageState extends State<MyPaymentPage> {
  List _paymentMethod = ['Google Pay', 'Momo', 'Zalo Pay', 'Card'];
  String currentPayment = "";
  int selectedPriceIndex = 0;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _currentUser;

  getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this._currentUser = firebaseUser;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, true);
                },
                child: Icon(
                  Icons.clear,
                  color: Colors.black,
                  size: 22,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                widget.parkingPlace.name,
                style: TextStyle(
                  fontSize: 34.4,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                widget.parkingPlace.address,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(
                height: 74,
              ),
              Text(
                'Parking Time',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400],
                    fontSize: 12.4),
              ),
              SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 104,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Card(
                            color: (this.selectedPriceIndex == index)
                                ? Colors.blue
                                : Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Container(
                              width: 134,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '${index + 1} hours',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          letterSpacing: 0.1),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      '${(index + 1) * widget.parkingPlace.price} \$',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[500]),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            this.selectedPriceIndex = index;
                          });
                        },
                      );
                    }),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'Payment Type',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400],
                    fontSize: 12.4),
              ),
              SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 104,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Card(
                            color: (this.currentPayment ==
                                    this._paymentMethod[index])
                                ? Colors.blue
                                : Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Container(
                              width: 134,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '${_paymentMethod[index]}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          letterSpacing: 0.1),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            this.currentPayment = _paymentMethod[index];
                          });
                        },
                      );
                    }),
              ),
              SizedBox(
                height: 34,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 24.0, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total : ',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.4,
                          letterSpacing: 0.2),
                    ),
                    Text(
                      "${(selectedPriceIndex + 1) * widget.parkingPlace.price} \$",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    onPressed: () {
                      addBooking();
                    },
                    color: Colors.black87,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'PAY NOW',
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addBooking() {
    CollectionReference usersBooking = FirebaseFirestore.instance
        .collection('booking_history')
        .doc(this._currentUser.uid)
        .collection("booking_history");

    BookingParking bookingParking = BookingParking(
        widget.parkingPlace.name,
        widget.parkingPlace.address,
        widget.parkingPlace.location,
        widget.parkingPlace.price,
        selectedPriceIndex + 1,
        Timestamp.fromDate(DateTime.now()));

    return usersBooking
        .add(bookingParking.toJson())
        .then((value) => {
              print("Booking Added"),
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Booking successfully"),
              ))
            })
        .catchError((error) => {
              print("Failed to add booking: $error"),
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Booking failed"),
              ))
            });
  }
}
