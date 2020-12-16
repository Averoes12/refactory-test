part of 'see_on_bloc.dart';

@immutable
abstract class SeeOnState {}

class InitialSeeOnState extends SeeOnState {}

class SeeOnSuccess extends SeeOnState{
  final List<SeeOnModel> seeOnModel;

  SeeOnSuccess({@required this.seeOnModel});
}

class SeeOnError extends SeeOnState{
  final String errMessage;
  SeeOnError({this.errMessage});
}

class SeeOnLoading extends SeeOnState{}