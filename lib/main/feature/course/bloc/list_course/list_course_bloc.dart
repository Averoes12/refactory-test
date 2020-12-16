import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:refactory_test/model/listcourse-model.dart';
import 'package:refactory_test/repo/api-repository.dart';

part 'list_course_event.dart';

part 'list_course_state.dart';

class ListCourseBloc extends HydratedBloc<ListCourseEvent, ListCourseState> {
  ListCourseBloc() : super(InitialListCourseState()){
    hydrate();
  }

  @override
  Stream<ListCourseState> mapEventToState(
      ListCourseEvent event
      ) async* {
      if (event is ListCourseEvent) {
          yield* getListCourseData();
      }
  }

  Stream<ListCourseState> getListCourseData() async* {
    ApiRepository apiRepository = ApiRepository();
    yield ListCourseLoading();
    print("Loading List Course Data");
    try{
      var listCourseData = await apiRepository.getListCourseData();
      yield ListCourseSuccess(listCourseModel: listCourseData);
      print("List Course Data gotten");
    }catch(e){
      yield ListCourseError(errMessage: e);
    }
  }

  @override
  ListCourseState fromJson(Map<String, dynamic> json) {
    var parsed = json['listCourse'];
    var listCourseData = List<ListCourseModel>.from(parsed.map<ListCourseModel>((list) => ListCourseModel.fromJson(list)));
    return ListCourseSuccess(listCourseModel: listCourseData);
  }

  @override
  Map<String, dynamic> toJson(ListCourseState state) {
    if (state is ListCourseSuccess) {
        return {
          "listCourse" : state.listCourseModel
        };
    }
    return null;
  }
}
