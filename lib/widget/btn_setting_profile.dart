import 'package:flutter/material.dart';

class BtnSetting extends StatelessWidget {
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: Colors.white38,
      primary: Color(0xFFF0F0F0),
      padding: EdgeInsets.all(13),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))));
  final IconData icon;
  final String text;
  final String style;
  final VoidCallback press;
  BtnSetting({this.icon, this.text, this.style, this.press});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextButton(
        style: flatButtonStyle,
        onPressed: press,
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text("$text", style: TextStyle(color: Colors.black)),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
