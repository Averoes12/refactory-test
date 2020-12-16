import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:refactory_test/model/couse-model.dart';
import 'package:refactory_test/repo/api-repository.dart';

part 'course_event.dart';

part 'course_state.dart';

class CourseBloc extends HydratedBloc<CourseEvent, CourseState> {
  CourseBloc() : super(InitialCourseState()){
    hydrate();
  }

  @override
  Stream<CourseState> mapEventToState(
      CourseEvent event
      ) async* {
    if (event is GetCourseData) {
      yield* getCourseData();
    }
  }

  Stream<CourseState> getCourseData () async* {
    ApiRepository apiRepository = ApiRepository();
    yield CourseLoading();
    try{
      CourseModel courseData = await apiRepository.getCourseData();
      yield CourseSuccess(courseModel: courseData);
    }catch(e){
      print("Error Course : $e");
      yield CourseError(errMessage: e);
    }
  }

  @override
  CourseState fromJson(Map<String, dynamic> json) {
    var parsed = json ['course'];
    CourseModel courseData = CourseModel.fromJson(parsed);
    return CourseSuccess(courseModel: courseData);
 }

  @override
  Map<String, dynamic> toJson(CourseState state) {
    if(state is CourseSuccess){
      return {
        "course" : state.courseModel
      };
    }
    return null;
  }
}
