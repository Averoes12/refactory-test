import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:refactory_test/model/user-model.dart';
import 'package:refactory_test/util/db/dbhelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if(event is GetProfileData){
      yield* getProfileData();
    }
  }

  Stream<ProfileState> getProfileData() async*{
    var db = DbHelper();
    yield ProfileLoading();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.get("email");
      var profile = await db.getUserData(email).then((value) =>
        value[0]
      ).catchError((error) => print("Error get User data => $error"));
      print("Profile $profile}");
      var userData = UserModel.map(profile);
      yield ProfileSuccess(userModel: userData);
    }catch (e){
      print("Exception => $e");
      yield ProfileError(errMessage: e);
    }
  }

}
