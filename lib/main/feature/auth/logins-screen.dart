import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:refactory_test/main/feature/auth/register-screen.dart';
import 'package:refactory_test/main/main-screen.dart';
import 'package:refactory_test/util/db/dbhelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String lat,long;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  StreamSubscription<Position> positionStream;
  Position position;


  checkUser() async {
    var db = DbHelper();
    var checkCounterEmail = await db.getEmailCounter(email.text).then((value) {
      if(value[0]['counter'] > 0 && value[0]['counter'] != null){
        return value[0]['counter'];
      }
    }).catchError((error) => print("Error => $error"));
    if(checkCounterEmail == null){
      showToast("You have not registered, Please create account", Toast.LENGTH_SHORT);
    }else if(checkCounterEmail > 0){
      var login = await db.loginUser(email.text, password.text).then((value) {
        if(value != null){
          return value[0];
        }
      }).catchError((error) => print("Error => $error"));
      if(login == null){
        showToast("Your email or Password is Incorrect", Toast.LENGTH_SHORT);
      }else {
        checkCounterEmail += 1;
        var counter = await db.setCounter(checkCounterEmail, login['email']).then((_) {
           var counterEmail = db.getEmailCounter(login['email']).then((value) {
            if(value[0]['counter'] > 0 && value[0]['counter'] != null){
              print("value Counter : ${value[0]['counter']}");
              return value[0]['counter'];
            }
          }).catchError((error) => print("Error => $error"));
           return counterEmail;
        });
        showToast("You have logged in with email : ${login['email']} $counter times", Toast.LENGTH_LONG);
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => MainScreen()
        ));
      }
    }
  }

  getLatLong() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lat = prefs.getString("lat") ?? "-";
      long = prefs.getString("long") ?? "-";
    });
  }
  @override
  void initState() {
    super.initState();
    positionStream = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high ,distanceFilter: 10)
        .listen((event) async {
      position = event;
      setState(() {
        lat = position?.latitude.toString()??"-";
        long = position?.longitude.toString()??"-";
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("lat", position.latitude.toString());
      prefs.setString("long", position.longitude.toString());
    });
    getLatLong();
  }


  @override
  void dispose() {
    super.dispose();
    positionStream.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.indigo.withOpacity(0.7),
                      Colors.blue.withOpacity(0.7)
                    ]
                )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(vertical: 24),
                    child: Image.network("https://gitlab.com/Daffaal/data-json/-/raw/master/refactory-hd.png")
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "Welcome to Refactory ",
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all()
                  ),
                  child: TextField(
                    controller: email,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: "Email",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.black
                        )
                    ),
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                  padding: EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all()
                  ),
                  child: TextField(
                    controller: password,
                    obscureText: true,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: "Password",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.black
                        )
                    ),
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Create new account?"),
                          GestureDetector(
                            onTap: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(
                                  builder: (context) => RegisterScreen()
                                )
                              );
                            },
                            child: Text("Register",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Colors.white
                              ),
                            ),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          if(email.text.isNotEmpty && password.text.isNotEmpty){
                            checkUser();
                          }else{
                            showToast("Field can't be blank", Toast.LENGTH_SHORT);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          width: 140,
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Login",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20
                                ),
                              ),
                              Icon(Icons.arrow_forward, color: Colors.white,)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Your Current Position", style: TextStyle(fontWeight: FontWeight.w500),),
                      lat == "-" || long == "-" ?
                      Row(
                        children: [
                          Container(
                            width: 200,
                            child: Text("Please Refresh the location to get your current location",
                            softWrap: true,
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              positionStream = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high ,distanceFilter: 10)
                                  .listen((event) async {
                                position = event;
                                setState(() {
                                  lat = position?.latitude??"-".toString();
                                  long = position?.longitude??"-".toString();
                                });
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString("lat", position.latitude.toString());
                                prefs.setString("long", position.longitude.toString());
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle
                              ),
                              child: Icon(Icons.refresh,)
                            )
                          )
                        ],
                      ):
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Latitude"),
                          Text("$lat"),
                          Text("Longitude"),
                          Text("$long"),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  showToast(String msg, Toast toast){
    Fluttertoast.showToast(msg: msg,toastLength: toast);
  }
}
