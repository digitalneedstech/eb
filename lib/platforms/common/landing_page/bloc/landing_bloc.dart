import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/repo/group_repository.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_state.dart';
import 'package:flutter_eb/platforms/common/landing_page/data/search_listing_repository.dart';
import 'package:flutter_eb/platforms/common/landing_page/model/query_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/assets/countries/countries.dart';
/*
TODO- Update user model with required new model values instead of null
 */
class LandingBloc extends Bloc<LandingEvent, LandingState> {
  final SearchListingRepository searchListingRepository;
  final GroupRepository groupRepository;
  LandingBloc(this.searchListingRepository, this.groupRepository) : super(LandingLoadedState());
  TextEditingController _associateNameController = TextEditingController();
  TextEditingController get associateNameController => _associateNameController;
  Map<String, UserDTOModel> _freelancersToBeAdded = {};
  String _selectedFilterCategory = "languages";
  Map<String, bool> selectedFilterCategoryValues = {};
  QueryModel _queryModel=QueryModel();

  QueryModel get queryModel => _queryModel;

  set queryModel(QueryModel value) {
    _queryModel = value;
  }

  String get selectedFilterCategory => _selectedFilterCategory;

  set selectedFilterCategory(String value) {
    _selectedFilterCategory = value;
  }

  Map<String, UserDTOModel> get freelancersToBeAdded => _freelancersToBeAdded;

  set freelancersToBeAdded(Map<String, UserDTOModel> value) {
    _freelancersToBeAdded = value;
  }

  set associateNameController(TextEditingController value) {
    _associateNameController = value;
  }

//TODO- Make Bloc For this repo and for Patient save
  @override
  Stream<LandingState> mapEventToState(
    LandingEvent event,
  ) async* {
    /*if (event is FetchSearchListingEvent) {
      yield LoadingState();
      List<UserDTOModel> response =
      await getSearchListing(event.query);
      yield FetchFreelancersListState(userModel: response);
    }*/

    if (event is ClearSearchListingFilterEvent) {
      yield ClearSearchListingFilterInProgressState();
      queryModel = QueryModel();
      yield ClearSearchListingFilterState();
    }
    if (event is LoadSearchFilterValuesEvent) {
      yield LoadSearchFilterValuesInProgressState();
      selectedFilterCategory = event.categoryName;
      Map<String, bool> response =
          await getFilterValuesForSearchCategory(event.categoryName);
      if(response.isEmpty){
        switch(event.categoryName){
          case "country":
            List<String> countries=countryCodes.map((country) {
              return country["name"].toString();

            }).toList();
            for(String country in countries){
              response[country]=true;
            }
            break;
        }
      }
      /*
      if (selectedFilterCategoryValues.isNotEmpty) {
        for (MapEntry<String, bool> map in response.entries) {
          if (selectedFilterCategoryValues.containsKey(map.key)) {
            response[map.key] = true;
          }
        }
      }*/
      yield LoadSearchFilterValuesState(categoryValues: response,categoryType: event.categoryType,
      categoryName: event.categoryName);
    }

    if (event is FetchSearchListingFromFirestoreForQueryEvent) {
      yield LoadingState();
      //associateNameController.text="";
      List<UserDTOModel> combinedUserModel = [];
        List<UserDTOModel> response = [];
        List<UserDTOModel> userResponseModelForSearchApi = [];
        if (!queryModel.skills.isEmpty ||
            !queryModel.languages.isEmpty ||
            !queryModel.profileTitle.isEmpty ||
            !queryModel.industry.isEmpty || !queryModel.countries.isEmpty) {
          dynamic responseVal =
          await getSearchListingForAQuery(event.queryModel);
          if(responseVal is String)
            yield FetchFreelancersListState(errorMessage: response.toString(),userModel: []);
          else
            response=responseVal;
        }
        if (event.searchQuery.trim() != "") {
          var result = await getSearchListing(
              event.searchQuery, event.searchParameterType);
          if(result is List<UserDTOModel>) {
            userResponseModelForSearchApi = result;
            if(userResponseModelForSearchApi.isNotEmpty){
              List<String> userIdsFromFirestore=userResponseModelForSearchApi.map((e) => e.userId).toList();
              response=response
                  .where((element) => userIdsFromFirestore.contains(element.userId))
                  .toList();
            }
            else
              response=userResponseModelForSearchApi;
          }
          /*TODO-
          else
            yield FetchFreelancersListState(errorMessage: result);*/
        }
        if(response.isNotEmpty)
          combinedUserModel.addAll(response);
        if (queryModel.skills.isEmpty &&
            queryModel.languages.isEmpty &&
            queryModel.profileTitle.isEmpty &&
            queryModel.industry.isEmpty && queryModel.countries.isEmpty
                &&
        event.searchQuery.trim() == "")
          await searchListingRepository.fetchFreelancersIfQueryModelIsNull(
              combinedUserModel);
        yield FetchFreelancersListState(userModel: combinedUserModel);
      }


    if (event is FetchSearchListingEvent) {
      yield LoadingState();
      List<UserDTOModel> response =
          await getSearchListing(event.query, event.typeOfSearch);
      yield FetchFreelancersListState(userModel: response);
    }
  }

  Future<dynamic> getSearchListing(String query, String type) async {
    return this.searchListingRepository.getSearchListingFromApi(query, type);
  }

  Future<dynamic> getSearchListingForAQuery(
      QueryModel queryModel) async {
    dynamic snapshot= await searchListingRepository
        .getSearchListingFromFirestoreForQuery(queryModel);
    return snapshot;
  }

  Future<Map<String, bool>> getFilterValuesForSearchCategory(
      String categoryName) {
    return this.searchListingRepository.getValuesForCategory(categoryName);
  }

  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}
