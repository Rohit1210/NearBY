import 'dart:async';
import 'package:NearBY/Screens/AskLocation/askLocation.dart';
import 'package:NearBY/Screens/AuthScreen/authScreen.dart';
import 'package:NearBY/Screens/Mainscreen/mainScreen.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:NearBY/Screens/Mainscreen/mainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences sharedPreferences;
  bool isLocationServiceEnabled = false;
  var position;

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.getString("token") == null
        ? Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => AuthScreen()),
            (Route<dynamic> route) => false)
        : 
        isLocationServiceEnabled
            ? Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => MainScreen()),
                (Route<dynamic> route) => false)
            : Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => AskLocation()),
                (Route<dynamic> route) => false);
  }

locationstatus() async {
LocationPermission permission = await GeolocatorPlatform.instance.checkPermission();
    setState(() {
      try {
        permission.index == 2
            ? isLocationServiceEnabled = true
            : isLocationServiceEnabled = false;
      } catch (err) {
        print(err);
      }
    });
  }


  @override
  void initState() {
    super.initState();
    locationstatus();
    Timer(Duration(seconds: 3), () => checkLoginStatus());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      height: size.height,
      width: double.infinity,
      child: SingleChildScrollView(
              child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "NearBY",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: size.height * 0.25,
            ),
            Image.asset("assets/images/location.png"),
            CircularProgressIndicator(
              backgroundColor: Colors.purple,
              strokeWidth: 4.0,
            )
          ],
        ),
      ),
    ));
  }
}
