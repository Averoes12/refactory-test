import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:refactory_test/model/partner-model.dart';
import 'package:refactory_test/repo/api-repository.dart';

part 'partner_event.dart';
part 'partner_state.dart';

class PartnerBloc extends HydratedBloc<PartnerEvent, PartnerState> {
  PartnerBloc() : super(PartnerInitial()){
    hydrate();
  }

  @override
  Stream<PartnerState> mapEventToState(
    PartnerEvent event,
  ) async* {
    if(event is GetPartnerData){
      yield* getListPartner();
    }
  }

  Stream<PartnerState> getListPartner() async*{
    ApiRepository apiRepository = ApiRepository();
    yield PartnerLoading();
    try{
      List<PartnerModel> data = await apiRepository.getListPost();
      yield PartnerSuccess(listPartner: data);
      print("Masukk");
    }catch(ex){
      PartnerError(errorMessage: ex.message.toString());
    }
  }

  @override
  PartnerState fromJson(Map<String, dynamic> json) {
    var parsed = json['partner'];
    var listPartner = List<PartnerModel>.from(parsed.map<PartnerModel>((i) => PartnerModel.fromJson(i)));
    return PartnerSuccess(listPartner: listPartner);
  }

  @override
  Map<String, dynamic> toJson(PartnerState state) {
    if(state is PartnerSuccess){
      return {
        "partner" : state.listPartner
      };
    }
    return null;
  }
}
