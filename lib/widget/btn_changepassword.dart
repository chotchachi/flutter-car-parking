import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BtChangePassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BtChangePasswordState();
  }
}

class _BtChangePasswordState extends State<BtChangePassword> {
  bool hide = false;
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: Colors.blueAccent,
      primary: Colors.white,
      padding: EdgeInsets.all(13),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))));
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: TextButton(
              style: flatButtonStyle,
              onPressed: () {},
              child: Row(
                children: [
                  Icon(Icons.admin_panel_settings),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(child: Text('Đổi mật khẩu')),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}
