import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refactory_test/main/feature/auth/logins-screen.dart';
import 'package:refactory_test/main/feature/profile/bloc/profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  ProfileBloc profileBloc;
  String profileUrl;

  @override
  void initState() {
    super.initState();
    profileBloc = BlocProvider.of<ProfileBloc>(context);
    profileBloc.add(GetProfileData());
    getProfileImage();
  }
  @override
  void dispose(){
    super.dispose();
    profileBloc.close();
  }
  getProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var profilePath = prefs.getString("profile");
    FirebaseStorage.instance
        .ref()
        .child('profile/$profilePath').getDownloadURL().then((url){
          setState(() {
            profileUrl = url;
          });
    });
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if(state is ProfileLoading){
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if(state is ProfileError){
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Text("Sorry Something Wrong!"),
                    ),
                  );
                }
                if(state is ProfileInitial){
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Text("Initial Data"),
                    ),
                  );
                }
                return showProfileData(state);
              },
            ),
          ),
        ),
      ),
    );
  }
  Widget showProfileData(ProfileSuccess state) {
    var defaultImgUrl = "https://gitlab.com/Daffaal/data-json/-/raw/master/avatar.png";
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.32,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.indigo, Colors.blueAccent]
            )
          ),
          child: Column(
            children: [
              SizedBox(height: 24,),
              Text("Profile",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.white
                ),
              ),
              SizedBox(height: 24,),
              Container(
                width: 150,
                height: 150,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(profileUrl != null ? profileUrl : defaultImgUrl),
                    fit: BoxFit.cover
                  )
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24),
          margin: EdgeInsets.only(top: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 16, bottom: 16),
                child: Text("Username",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("${state.userModel.username}",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16, bottom: 16),
                child: Text("Email Address",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("${state.userModel.email}",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
              ),
              SizedBox(height: 24,),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => LoginScreen()
                  ));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text("Log Out",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.indigo
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
