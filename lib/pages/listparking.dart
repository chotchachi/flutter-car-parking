import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ListParkingView extends StatefulWidget {
  ListParkingView({Key key}) : super(key: key);

  @override
  _ListParkingViewState createState() => _ListParkingViewState();
}

class _ListParkingViewState extends State<ListParkingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.list,
                  size: 25,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Các bãi đỗ xe lân cận',
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            buildListTile('Bãi đỗ', "41 le duan, da nang"),
            buildContainer(),
            buildListTile('Bãi đỗ', "41 le duan, da nang"),
            buildContainer(), buildListTile('Bãi đỗ', "41 le duan, da nang"),
            buildContainer(), buildListTile('Bãi đỗ', "41 le duan, da nang"),
            buildContainer(),
          ],
        ),
      ),
    );
  }

  ListTile buildListTile(String text, String subtext) {
    return ListTile(
        leading: Icon(
          Icons.arrow_right,
          size: 35.0,
          color: Colors.lightBlue,
        ),
        tileColor: Colors.lightBlueAccent[50],
        title: Text("$text"),
        subtitle: Text("$subtext"),
        onTap: () => Get.snackbar('Hi', 'i am a modern snackbar'));
  }

  Container buildContainer() {
    return Container(
      padding: EdgeInsets.only(top: 7.0, bottom: 7.0),
      height: 1.0,
      color: Colors.grey,
    );
  }
}
