import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:refactory_test/model/home-model.dart';
import 'package:refactory_test/model/partner-model.dart';
import 'package:refactory_test/model/seeon-model.dart';

class ApiRepository {

  var baseUrl = "https://raw.githubusercontent.com/cahyo-refactory/RSP-DataSet-SkilTest-FE/main";
  var cusUrl = "https://gitlab.com/Daffaal/data-json/-/raw/master";
  Dio dio = Dio();
  Response response;

  Future<List<PartnerModel>> getListPost() async {
    List<PartnerModel> listPartner;
    try{
      await dio.get("$baseUrl/partner.json").then((value) {
        print("Value data : ${jsonDecode(value.data)['data']}");
        listPartner = (jsonDecode(value.data)['data'] as List).map((list) => PartnerModel.fromJson(list)).toList();
      }).catchError((e) => print("Error : $e"));
      print("List Partner : $listPartner");
      return listPartner;
    } catch(e){
      print("Exception : $e");
      throw Exception(e);
    }
  }

  Future<HomeModel> getHomeData() async {
    HomeModel homeModel;
    try{
      await dio.get("$cusUrl/home-refactory.json").then((value) {
        homeModel = HomeModel.fromJson(jsonDecode(value.data));
      }).catchError((e) => print("Error : $e"));
      print("Home Model : $homeModel");
      return homeModel;
    }catch (e){
      print("Exception : $e");
      throw Exception(e);
    }
  }

  Future<List<SeeOnModel>> getSeeOnData() async {
    List<SeeOnModel> seeOnModel;
    try{
      await dio.get("$baseUrl/seen_on.json").then((value) {
        seeOnModel = (jsonDecode(value.data)['data'] as List).map((list) => SeeOnModel.fromJson(list)).toList();
      }).catchError((e) => print("Error see on : $e"));
      print("SeeOn : $seeOnModel");
      return seeOnModel;
    }catch(e){
      print("Exception See On : $e");
      throw Exception(e);
    }
  }

}