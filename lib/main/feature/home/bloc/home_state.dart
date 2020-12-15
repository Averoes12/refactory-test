part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeSuccess extends HomeState{
  final HomeModel homeModel;

  HomeSuccess({@required this.homeModel});
}

class HomeError extends HomeState{
  final String errMessage;

  HomeError({this.errMessage});
}

class HomeLoading extends HomeState{}