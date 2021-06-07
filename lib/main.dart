import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_car_parking/pages/list_place.dart';
import 'package:flutter_car_parking/pages/map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MapView());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoginPage(),
    );
  }
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
bool _success;
String _userEmail;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 370,
              child:
                  Image.asset('assets/images/login_bg.jpg', fit: BoxFit.fill),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: new EdgeInsets.symmetric(horizontal: 4.0),
                  child: new IconButton(
                      icon: IconButton(
                        icon: Image.asset('assets/images/icon-user.png'),
                        onPressed: () {},
                      ),
                      onPressed: () {}),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            TextFormField(
              obscureText: true,
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 20.0, bottom: 20.0),
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints:
                    BoxConstraints.tightFor(width: double.infinity, height: 50),
                child: ElevatedButton(
                  child: Text(
                    'SIGN IN',
                    style: TextStyle(fontSize: 19),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xFF00A79B),
                      shadowColor: Color(0xFF00A79B),
                      elevation: 1),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      // _register();
                    }
                  },
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(_success == null
                  ? ''
                  : (_success
                      ? 'Successfully registered ' + _userEmail
                      : 'Registration failed')),
            )
          ],
        ),
      ),
    );
  }

  // Row generateTextField(controller, icon Icon) {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: <Widget>[
  //       Container(
  //         margin: new EdgeInsets.symmetric(horizontal: 4.0),
  //         child: new IconButton(
  //             icon: IconButton(
  //               icon: Image.asset('assets/images/icon-user.png'),
  //               onPressed: () {},
  //             ),
  //             onPressed: () {}),
  //       ),
  //       Expanded(
  //         child: TextFormField(
  //           controller: controller,
  //           decoration: const InputDecoration(labelText: 'Email'),
  //           validator: (String value) {
  //             if (value.isEmpty) {
  //               return 'Please enter some text';
  //             }
  //             return null;
  //           },
  //         ),
  //       ),
  //     ],
  //   )
  // }

  // void _register() async {
  //   final FirebaseUser user = (await auth.createUserWithEmailAndPassword(
  //     email: _emailController.text,
  //     password: _passwordController.text,
  //   ))
  //       .user;
  //   if (user != null) {
  //     setState(() {
  //       _success = true;
  //       _userEmail = user.email;
  //     });
  //   } else {
  //     setState(() {
  //       _success = true;
  //     });
  //   }
  // }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
