import 'package:cloud_firestore/cloud_firestore.dart';

class BookingParking {
  String name;
  String address;
  GeoPoint location;
  int unitPrice;
  int hours;
  Timestamp bookingTime;

  BookingParking(this.name, this.address, this.location, this.unitPrice,
      this.hours, this.bookingTime);

  BookingParking.fromJson(Map<String, Object> json)
      : this(json['name'], json['address'], json['location'], json['unitPrice'],
            json['hours'], json['bookingTime']);

  Map<String, Object> toJson() {
    return {
      'name': this.name,
      'address': this.address,
      'location': this.location,
      'unitPrice': this.unitPrice,
      'hours': this.hours,
      'bookingTime': this.bookingTime
    };
  }

}