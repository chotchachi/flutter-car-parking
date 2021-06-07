import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_car_parking/pages/Login.dart';
import 'SignUp.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> googleSignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        final UserCredential user =
        await _auth.signInWithCredential(credential);

        await Navigator.pushReplacementNamed(context, "/");

        return user;
      } else {
        throw StateError('Missing Google Auth Token');
      }
    } else
      throw StateError('Sign in Aborted');
  }

  navigateToLogin() async {
    Navigator.pushReplacementNamed(context, "Login");
  }

  navigateToRegister() async {
    Navigator.pushReplacementNamed(context, "SignUp");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Colors.black12,
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/5.jpg')
            )
        ),
        child: Column(
          children: <Widget>[
            // Container(
            //   // height: 280,
            //   // width: 900,
            //   child: Image(
            //     image: AssetImage("images/8.jpg"),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            // SizedBox(height: 10),

            // SizedBox(height: 10.0),
            // // Text(
            // //   'We are pleased to welcome you to use the application',
            // //   style: TextStyle(color: Colors.black),
            // // ),
            SizedBox(height: 80.0),
            RichText(
                text: TextSpan(
                  text: 'WELCOME TO YOU PARKING APP',
                  style: TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
            SizedBox(height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    padding: EdgeInsets.fromLTRB(140, 15, 140, 15),
                    onPressed: navigateToLogin,
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.green),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                    padding: EdgeInsets.fromLTRB(120, 15, 120, 15),
                    onPressed: navigateToRegister,
                    child: Text(
                      'REGISTER',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.green),
              ],
            ),
            SizedBox(height: 20.0),
            SignInButton(Buttons.Google,
                text: "Sign up with Google", onPressed: googleSignIn)
          ],
        ),
      ),
    );
  }
}
