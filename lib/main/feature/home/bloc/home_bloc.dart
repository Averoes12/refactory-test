import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:refactory_test/model/home-model.dart';
import 'package:refactory_test/repo/api-repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends HydratedBloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()){
    hydrate();
  }

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if(event is GetHomeData){
      yield* getHomeData();
    }
  }
  Stream<HomeState> getHomeData() async* {
    ApiRepository apiRepository = ApiRepository();
    yield HomeLoading();
    try{
      HomeModel homeData = await apiRepository.getHomeData();
      yield HomeSuccess(homeModel: homeData);
    }catch (e){
      HomeError(errMessage: e);
    }
  }

  @override
  HomeState fromJson(Map<String, dynamic> json) {
    var parsed  = json['homeData'];
    HomeModel homeModel = HomeModel.fromJson(parsed);
    return HomeSuccess(homeModel: homeModel);
  }

  @override
  Map<String, dynamic> toJson(HomeState state) {
    if(state is HomeSuccess){
      return {
        'homeData' : state.homeModel
      };
    }
    return null;
  }
}
