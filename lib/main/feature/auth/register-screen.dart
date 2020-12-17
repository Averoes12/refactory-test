import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:refactory_test/main/feature/auth/logins-screen.dart';
import 'package:refactory_test/model/user-model.dart';
import 'package:refactory_test/util/db/dbhelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  File pathFromDialog;
  String imgUrl;
  Position position;
  String lat,long;
  StreamSubscription<Position> positionStream;
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  uploadProfilePicture(File imageFile) {
    Reference storage = FirebaseStorage.instance
        .ref()
        .child('profile/${Path.basename(imageFile.path)}');
    UploadTask uploadTask = storage.putFile(imageFile);
    saveImageFilePath(Path.basename(imageFile.path));
    showToast("Loading...", Toast.LENGTH_LONG);
    uploadTask.then((res) {
      res.ref.getDownloadURL().then((url){
        print("PROFILE_URL : $url");
        setState(() {
          imgUrl = url;
        });
      });
    });
  }

  saveImageFilePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (path != null) {
      prefs.setString("profile", path);
      print("SAVED SF : $path");
    }
  }

  registerUser() async {
    var db = DbHelper();
    var counter = 0;
    var userData = UserModel(username.text, email.text, password.text);
    await db.saveUserData(userData).then((value) async {
        counter += 1;
        db.setCounter(counter, email.text);
    }).then((value) {
      showToast("Your account has been registered successfully", Toast.LENGTH_SHORT);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => LoginScreen()
      ));
    });
  }

  checkUser() async {
    var db = DbHelper();
    var checkCounterEmail = await db.getEmailCounter(email.text).then((value) {
      if(value[0]['counter'] > 0 && value[0]['counter'] != null){
        showToast("This email has been used before, Please use another email", Toast.LENGTH_LONG);
        return value[0]['counter'];
      }else {
        print("Kosong");
      }
    }).catchError((error) => print("Error => $error"));
    if(checkCounterEmail == null){
      registerUser();
    }
  }

  getLatLong() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lat = prefs.getString("lat")??"-";
      long = prefs.getString("long")??"-";
    });
  }
  @override
  void initState() {
    super.initState();
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
    getLatLong();
  }

  @override
  void dispose() {
    super.dispose();
    positionStream.cancel();
  }

  @override
  Widget build(BuildContext context) {

    var defaultImgUrl = "https://gitlab.com/Daffaal/data-json/-/raw/master/avatar.png";
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
                    "Create A New Account",
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8, right: 8,bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all()
                  ),
                  child: TextField(
                    controller: username,
                    cursorColor: Colors.black,
                    maxLength: 12,
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: "Username",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.black.withOpacity(0.6)
                      )
                    ),
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  child: Text("Upload your profile photo",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                SizedBox(height: 16,),
                GestureDetector(
                  onTap: (){
                    var data = showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx){
                        return MyDialog();
                      }
                    );
                    data.then((path) {
                      pathFromDialog = path;
                      print("pathFromDIalog : $pathFromDialog");
                      if(pathFromDialog != null){
                        uploadProfilePicture(pathFromDialog);
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        image: DecorationImage(
                          image: NetworkImage(imgUrl != null ? imgUrl : defaultImgUrl)
                        )
                      ),
                    )
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
                    controller: email,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: "Email",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.6)
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
                            color: Colors.black.withOpacity(0.6)
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
                          Text("Already have account?"),
                          GestureDetector(
                            onTap: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) => LoginScreen()
                              ));
                            },
                            child: Text("Login",
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
                          if(username.text.isNotEmpty && email.text.isNotEmpty && password.text.isNotEmpty){
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
                              Text("Register",
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
                            ),),
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
                            child:Container(
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

class MyDialog extends StatefulWidget {

  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {

  File imagePath;
  Image image;

  Future pickFromGallery() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((pickedImage) {
      setState(() {
        if(pickedImage != null){
          imagePath = pickedImage;
          image = Image(image: FileImage(pickedImage));
          print("Image Dialog : $imagePath");
        } else {
          Fluttertoast.showToast(
              msg: "No image selected",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM
          );
        }
      });
    });
  }

  Future pickFromCamera() async {
    await ImagePicker.pickImage(source: ImageSource.camera).then((pickedImage) {
      if (pickedImage != null) {
        setState(() {
          imagePath = pickedImage;
          image = Image(image: FileImage(pickedImage));
        });
      } else {
        Fluttertoast.showToast(
            msg: "No image selected",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.80,
          child: Column(
            children: <Widget>[
              GestureDetector(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.camera_alt),
                        SizedBox(width: 8),
                        Text(
                          'Take a picture',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    await pickFromCamera();
                    setState(() {});
                    Navigator.pop(context, imagePath);
                  }),
              GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.image),
                        SizedBox(width: 5),
                        Text(
                          'Choose from gallery',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    await pickFromGallery();
                    setState(() {});
                    Navigator.pop(context, imagePath);
                  }),
              Padding(
                padding: EdgeInsets.all(9),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
