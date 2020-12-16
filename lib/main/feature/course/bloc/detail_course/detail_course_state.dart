part of 'detail_course_bloc.dart';

@immutable
abstract class DetailCourseState {}

class InitialDetailCourseState extends DetailCourseState {}

class DetailCourseSuccess extends DetailCourseState {
  final DetailCourseModel detailCourseModel;
  DetailCourseSuccess({@required this.detailCourseModel});
}

class DetailCourseError extends DetailCourseState{
  final String errMessage;
  DetailCourseError({this.errMessage});
}

class DetailCourseLoading extends DetailCourseState {}