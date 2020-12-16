import 'dart:async';
import 'dart:convert';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:refactory_test/model/detailcourse-model.dart';
import 'package:refactory_test/repo/api-repository.dart';

part 'detail_course_event.dart';

part 'detail_course_state.dart';

class DetailCourseBloc extends Bloc<DetailCourseEvent, DetailCourseState> {
  DetailCourseBloc() : super(InitialDetailCourseState());

  @override
  Stream<DetailCourseState> mapEventToState(
      DetailCourseEvent event
      ) async* {
      if(event is GetDetailCourse){
        yield* getDetailCourseData();
      }
  }

  Stream<DetailCourseState> getDetailCourseData() async* {
    ApiRepository apiRepository = ApiRepository();
    yield DetailCourseLoading();
    try{
      DetailCourseModel detailCourseData = await apiRepository.getDetailCourse();
      yield DetailCourseSuccess(detailCourseModel: detailCourseData);
      print("Detail Course Data : ${detailCourseData.toJson()}");
    }catch (e){
      yield DetailCourseError(errMessage: e);
    }
  }
}
