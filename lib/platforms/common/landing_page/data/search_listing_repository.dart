
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_eb/platforms/common/landing_page/model/query_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/skills/skill_info_dto_model.dart';
import 'package:flutter_eb/shared/constants/constants.dart';

class SearchListingRepository {
  final Dio dio;
  SearchListingRepository(this.dio);
  final collectionInstance = FirebaseFirestore.instance.collection('users');
  final utilsCollectionInstance =
      FirebaseFirestore.instance.collection('utils');
  String SEARCH_LISTING_API_SKILL =
      "https://46mbjojgi3.execute-api.ap-south-1.amazonaws.com/prod/user/skill/";

  String SEARCH_LISTING_API_NAME =
      "https://46mbjojgi3.execute-api.ap-south-1.amazonaws.com/prod/user/name/";
  String NESTED_SEARCH_LISTING_QUERY =
      "https://46mbjojgi3.execute-api.ap-south-1.amazonaws.com/prod/users?";

  /*String SEARCH_FILTER_API="https://46mbjojgi3.execute-api.ap-south-1.amazonaws.com/prod/users?"
      "sk[skills]=nodejs&"
      "sk[exp]=1&rd[hr]=100&po[pt]=cloud&po[indust]=sap&pd[dn]=thomas&pd[con]=India&lang=English";*/

  String SEARCH_FILTER_API="https://46mbjojgi3.execute-api.ap-south-1.amazonaws.com/prod/users?";
  Future<dynamic> getSearchListingFromApi(
      String query, String queryType) async {
    Response response;
    List<UserDTOModel> users = [];
    try {
      response = await dio.get(queryType == "person"
          ? SEARCH_LISTING_API_NAME + query
          : SEARCH_LISTING_API_SKILL + query);
      if (response.statusCode == 200) {
        if (List.from(response.data).isNotEmpty) {
          for (dynamic val in response.data) {
            try {
              users.add(UserDTOModel.fromJson(
                  val as Map<String, dynamic>, val["_id"]));
            } catch (e) {
              return e;
            }
          }
        }
      }
    } on DioError catch (e) {
      //print(e);
      return e.message;
    }
    return users;
  }

  Future<dynamic> getSearchListingFromFirestoreForQuery(
      QueryModel queryModel) async {
    dynamic users =
        await fetchFreelancersIfQueryModelIsNotNull(queryModel);

    return users;
  }

  Future<dynamic> fetchFreelancersIfQueryModelIsNotNull(
      QueryModel queryModel) async {
    List<UserDTOModel> users = [];
    String searchUrl=SEARCH_FILTER_API;
    if(queryModel.skills.isNotEmpty){
      var skills="";
      for(String lang in queryModel.skills){
        skills=skills+lang+",";
      }
      if(skills.lastIndexOf(",")==skills.length-1)
        skills=skills.substring(0,skills.length-1);
      searchUrl=searchUrl+"sk[skills]=$skills&";
    }
    if(queryModel.languages.isNotEmpty) {
      var languages="";
      for(String lang in queryModel.languages){
        languages=languages+lang+",";
      }
      if(languages.lastIndexOf(",")==languages.length-1)
        languages=languages.substring(0,languages.length-1);
      searchUrl = searchUrl + "lang=$languages&";
    }
    if(queryModel.countries.isNotEmpty) {
      var countries="";
      for(String lang in queryModel.countries){
        countries=countries+lang+",";
      }
      if(countries.lastIndexOf(",")==countries.length-1)
        countries=countries.substring(0,countries.length-1);
      searchUrl = searchUrl + "pd[con]=$countries&";
    }

    if(queryModel.profileTitle.isNotEmpty) {
      var profileTitle="";
      for(String lang in queryModel.profileTitle){
        profileTitle=profileTitle+lang+",";
      }
      if(profileTitle.lastIndexOf(",")==profileTitle.length-1)
        profileTitle=profileTitle.substring(0,profileTitle.length-1);
      searchUrl = searchUrl + "po[pt]=$profileTitle&";
    }

    if(queryModel.industry.isNotEmpty) {
      var industry="";
      for(String lang in queryModel.industry){
        industry=industry+lang+",";
      }
      if(industry.lastIndexOf(",")==industry.length-1)
        industry=industry.substring(0,industry.length-1);
      searchUrl = searchUrl + "po[indus]=$industry&";
    }

    if(searchUrl.lastIndexOf("&")==searchUrl.length-1)
      searchUrl=searchUrl.substring(0,searchUrl.length-1);
    Response response;
    try {
      response = await dio.get(searchUrl);
      if (response.statusCode == 200) {
        if (List.from(response.data).isNotEmpty) {
          for (dynamic val in response.data) {
            try {
              users.add(UserDTOModel.fromJson(
                  val as Map<String, dynamic>, val["_id"]));
            } catch (e) {
              return e;
            }
          }
        }
      }
    } on DioError catch (e) {
      //print(e);
      return e.message;
    }
    return users;
  }

  Future fetchFreelancersIfQueryModelIsNull(List<UserDTOModel> users) async {
    QuerySnapshot snapshot = await this
        .collectionInstance
        .where("isVerified", isEqualTo: true)
        .where("personalDetails.type", isEqualTo: Constants.VENDOR)
        .get();
    for (DocumentSnapshot documentSnapshot in snapshot.docs) {
      users.add(UserDTOModel.fromJson(
          documentSnapshot.data() as Map<String, dynamic>,
          documentSnapshot.id));
    }
  }

  Future<Map<String, bool>> getValuesForCategory(String category) async {
    List<dynamic> values = [];
    Map<String, bool> valuesMap = {};
    DocumentSnapshot snapshot =
        await this.utilsCollectionInstance.doc("filters").get();
    if (snapshot.data() != null) {
      var cat=category;
      if(category=="industry")
        cat="services";
      values = ((snapshot.data() as Map<String, dynamic>)[cat]
          as List<dynamic>);
      for (dynamic value in values) {
        valuesMap[value.toString()] = false;
      }
    }
    return valuesMap;
  }
}
