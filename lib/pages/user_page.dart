import 'package:flutter/material.dart';
import 'package:flutter_car_parking/widget/btn_changepassword.dart';
import 'package:flutter_car_parking/widget/btn_edit_profile.dart';
import 'package:flutter_car_parking/widget/btn_logout.dart';
import 'package:flutter_car_parking/widget/btn_setting_profile.dart';
import 'package:get/get.dart';

class ProfileView extends StatefulWidget {
  ProfileView({Key key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _buildSettingProfile();
                      });
                },
                child: Icon(
                  Icons.settings_outlined,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ), 
          SizedBox(
            height: 25.0,
          ),
          _buildAvatarProfile('Tan'),
          SizedBox(
            height: 20.0,
          ),
          BtnSetting(
            icon: Icons.contact_page,
            text: 'Thông tin cá nhân',
            press: (){},
          ),
          BtnSetting(
            text: 'Thanh toán',
            icon: Icons.card_membership
          ),
          BtnSetting(
            text: 'Lịch sử thanh toán',
            icon: Icons.history
          ),
          BtnSetting(
            text: 'Lịch sử bãi đỗ',
            icon: Icons.calendar_today,
          ),
        ],
      ),
    ));
  }

  Row buildTitleSetting(String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Row _buildAvatarProfile(String name) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tân',
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.lightBlueAccent),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              '$name',
              style: TextStyle(fontSize: 13.0, color: Colors.blueGrey),
            )
          ],
        ),
        Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90.0),
              border: Border.all(width: 1, color: Colors.white),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 8,
                )
              ],
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://i.pinimg.com/736x/d1/32/64/d132644360376beb74abb10578952888.jpg'),
              )
            )),
      ],
    );
  }
}

AlertDialog _buildSettingProfile() {
  return AlertDialog(
    content: Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Positioned(
          right: -40.0,
          top: -40.0,
          child: InkResponse(
            onTap: () {
              Get.back();
            },
            child: CircleAvatar(
              child: Icon(Icons.close),
              backgroundColor: Colors.red,
            ),
          ),
        ),
        Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              BtEditProfile(),
              BtChangePassword(),
              BtnLogOut(),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text('ngonngu1'.tr),
              //     Obx(() => DropdownButton(
              //           items: [
              //             DropdownMenuItem(
              //               child: Text('vi'),
              //               value: 'vi',
              //             ),
              //             DropdownMenuItem(
              //               child: Text('en'),
              //               value: 'en',
              //             )
              //           ],
              //           value: controller.selectedLang.value,
              //           onChanged: (value) {
              //             controller.selectedLang.value = value;
              //             Get.updateLocale(
              //                 Locale(controller.selectedLang.value));
              //           },
              //         )),
              //   ],
              // ),
            
            ],
          ),
        ),
      ],
    ),
  );
}
