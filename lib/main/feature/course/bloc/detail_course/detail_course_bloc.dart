import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:refactory_test/model/detailcourse-model.dart';

part 'detail_course_event.dart';

part 'detail_course_state.dart';

class DetailCourseBloc extends HydratedBloc<DetailCourseEvent, DetailCourseState> {
  DetailCourseBloc() : super(InitialDetailCourseState());

  @override
  DetailCourseState get initialState => InitialDetailCourseState();

  @override
  Stream<DetailCourseState> mapEventToState(DetailCourseEvent event) async* {
    // TODO: Add your event logic
  }

  Stream<DetailCourseState> getDetailCourseData() async* {
    
  }

  @override
  DetailCourseState fromJson(Map<String, dynamic> json) {
    var parsed = json['detailCourse'];
    var detailCourseData = DetailCourseModel.fromJson(parsed);
    return DetailCourseSuccess(detailCourseModel: detailCourseData);
  }

  @override
  Map<String, dynamic> toJson(DetailCourseState state) {
    if(state is DetailCourseSuccess){
        return {
          "detailCourse" : state.detailCourseModel
        };
    }
    return null;
  }
}
