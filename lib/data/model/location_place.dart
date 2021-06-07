class ParkingLocation {
  double lat, lng;

  ParkingLocation(this.lat, this.lng);
}

class ParkingPlace {
  String name;
  String address;
  String price;
  ParkingLocation location;
  int rating;

  ParkingPlace(this.name, this.address, this.price, this.location, this.rating);
}

// List recentList = [
//   new ParkingPlace('Bãi đỗ xe An Hải', 'Nại Hiên Đông, Sơn Trà, Đà Nẵng 550000, Việt Nam', '200.000 VND', ParkingLocation(16.089093457282665, 108.236940477456), 3),
//   new ParkingPlace('Bãi đỗ xe Nại Thịnh', 'Nại Hiên Đông, Sơn Trà, Đà Nẵng 550000, Việt Nam', '40', ParkingLocation(16.089093457282665, 108.23463271705602), 3),
//   new ParkingPlace('Bãi đỗ xe Xuân Diệu', 'Thuận Phước, Hải Châu, Đà Nẵng 550000, Việt Nam', '40', ParkingLocation(16.087402389574592, 108.2197218243027), 3),
// ];