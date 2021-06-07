import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingPlace {
  String address;
  String contact;
  GeoPoint location;
  String name;
  int price;
  int rating = 0;
  int spots = 0;

  ParkingPlace(this.address, this.contact, this.location, this.name, this.price,
      this.rating, this.spots);

  ParkingPlace.fromJson(Map<String, Object> json)
      : this(json['address'], json['contact'], json['location'], json['name'],
            json['price'], json['rating'], json['spots']);

  Map<String, Object> toJson() {
    return {
      'address': this.address,
      'contact': this.contact,
      'location': this.location.latitude,
      'name': this.name,
      'price': this.price,
      'rating': this.rating,
      'spots': this.spots
    };
  }
}

// List recentList = [
//   new ParkingPlace('Bãi đỗ xe An Hải', 'Nại Hiên Đông, Sơn Trà, Đà Nẵng 550000, Việt Nam', '200.000 VND', ParkingLocation(16.089093457282665, 108.236940477456), 3),
//   new ParkingPlace('Bãi đỗ xe Nại Thịnh', 'Nại Hiên Đông, Sơn Trà, Đà Nẵng 550000, Việt Nam', '40', ParkingLocation(16.089093457282665, 108.23463271705602), 3),
//   new ParkingPlace('Bãi đỗ xe Xuân Diệu', 'Thuận Phước, Hải Châu, Đà Nẵng 550000, Việt Nam', '40', ParkingLocation(16.087402389574592, 108.2197218243027), 3),
// ];
