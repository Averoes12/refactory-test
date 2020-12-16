import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:refactory_test/model/seeon-model.dart';
import 'package:refactory_test/repo/api-repository.dart';

part 'see_on_event.dart';

part 'see_on_state.dart';

class SeeOnBloc extends HydratedBloc<SeeOnEvent, SeeOnState> {
  SeeOnBloc() : super(InitialSeeOnState()){
    hydrate();
  }

  @override
  Stream<SeeOnState> mapEventToState(
      SeeOnEvent event
      ) async* {
    if(event is GetSeeOnData){
      yield* getSeeOnData();
    }
  }

  Stream<SeeOnState> getSeeOnData () async* {
    ApiRepository apiRepository = ApiRepository();
    yield SeeOnLoading();
    try{
      List<SeeOnModel> data = await apiRepository.getSeeOnData();
      yield SeeOnSuccess(seeOnModel: data);
      print("Gotten");
    }catch(ex){
      yield SeeOnError(errMessage: ex.message.toString());
    }
  }

  @override
  SeeOnState fromJson(Map<String, dynamic> json) {
    var parsed = json['seeOn'];
    var seeOnData = List<SeeOnModel>.from(parsed.map<SeeOnModel>((i) => SeeOnModel.fromJson(i)));
    return SeeOnSuccess(seeOnModel: seeOnData);
  }

  @override
  Map<String, dynamic> toJson(SeeOnState state) {
    if(state is SeeOnSuccess){
      return {
        'seeOn' : state.seeOnModel
      };
    }
    return null;
  }
}
