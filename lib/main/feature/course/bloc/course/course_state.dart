part of 'course_bloc.dart';

@immutable
abstract class CourseState {}

class InitialCourseState extends CourseState {}

class CourseSuccess extends CourseState{
  final CourseModel courseModel;

  CourseSuccess({@required this.courseModel});
}

class CourseError extends CourseState{
  final String errMessage;

  CourseError({this.errMessage});
}

class CourseLoading extends CourseState {}