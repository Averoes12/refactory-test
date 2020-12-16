part of 'list_course_bloc.dart';

@immutable
abstract class ListCourseState {}

class InitialListCourseState extends ListCourseState {}

class ListCourseSuccess extends ListCourseState {
  final List<ListCourseModel> listCourseModel;
  ListCourseSuccess({@required this.listCourseModel});
}

class ListCourseError extends ListCourseState {
  final String errMessage;
  ListCourseError({this.errMessage});
}

class ListCourseLoading extends ListCourseState{}