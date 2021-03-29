import 'package:flutter/cupertino.dart';

class GarageService extends StatefulWidget {
  GarageService({Key key}) : super(key: key);

  @override
  _GarageServiceState createState() => _GarageServiceState();
}

class _GarageServiceState extends State<GarageService> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Text("Garage"),
      ),
    );
  }
}
