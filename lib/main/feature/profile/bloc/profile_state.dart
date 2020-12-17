part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final UserModel userModel;
  ProfileSuccess({@required this.userModel});
}

class ProfileError extends ProfileState {
  final dynamic errMessage;
  ProfileError({this.errMessage});
}

class ProfileLoading extends ProfileState {}

