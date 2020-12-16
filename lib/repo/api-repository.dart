import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:refactory_test/model/couse-model.dart';
import 'package:refactory_test/model/detailcourse-model.dart';
import 'package:refactory_test/model/home-model.dart';
import 'package:refactory_test/model/listcourse-model.dart';
import 'package:refactory_test/model/partner-model.dart';
import 'package:refactory_test/model/seeon-model.dart';
import 'package:refactory_test/model/review-model.dart';

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

  Future<CourseModel> getCourseData() async {
    CourseModel courseModel;
    try{
      await dio.get("$cusUrl/course.json").then((value) {
        courseModel = CourseModel.fromJson(jsonDecode(value.data));
      }).catchError((e) => print("Error Course : $e"));
      print("Course Model : $courseModel");
      return courseModel;
    }catch (e){
      print("Exception : $e");
      throw Exception(e);
    }
  }

  Future<List<ReviewModel>> getReviewData() async {
    List<ReviewModel> reviewModel;
    try{
        await dio.get("$baseUrl/alumni-report.json").then((value) {
        reviewModel = (jsonDecode(value.data)['data'] as List).map((list) => ReviewModel.fromJson(list)).toList();
      }).catchError((e) => print("Error Review : $e"));
        print("Review Model : $reviewModel");
        return reviewModel;
    }catch(e){
      print("Exception Review : $e");
      throw Exception(e);
    }
  }

  Future<List<ListCourseModel>> getListCourseData() async {
    List<ListCourseModel> listCourseModel;
    try{
      await dio.get("$baseUrl/list-course.json").then((value) {
        listCourseModel = (jsonDecode(value.data)['data'] as List).map((list) => ListCourseModel.fromJson(list)).toList();
      }).catchError((e) => print("Error Review : $e"));
      print("List Course Model : $listCourseModel");
      return listCourseModel;
    }catch(e){
      print("Exception ListCourse : $e");
      throw Exception(e);
    }
  }

  Future<DetailCourseModel> getDetailCourse() async {
    DetailCourseModel detailCourseModel;
    try{
      await dio.get("$baseUrl/detail-course.json").then((value) {
        detailCourseModel = DetailCourseModel.fromJson(jsonDecode(value.data));
      }).catchError((e) => print("Error Detail Course : $e"));
      print("Detail Course Model : $detailCourseModel");
      return detailCourseModel;
    }catch (e){
      print("Exception : $e");
      throw Exception(e);
    }
  }

}