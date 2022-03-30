import 'package:equatable/equatable.dart';
import 'package:flutter_eb/platforms/common/landing_page/model/query_model.dart';

class LandingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchSearchListingEvent extends LandingEvent {
  final String query;
  final String typeOfSearch;
  FetchSearchListingEvent({required this.typeOfSearch,required this.query});
}

class ClearSearchListingFilterEvent extends LandingEvent {
  ClearSearchListingFilterEvent();
}

class FetchSearchListingFromFirestoreForQueryEvent extends LandingEvent {
  final QueryModel queryModel;
  final String searchQuery,searchParameterType;
  FetchSearchListingFromFirestoreForQueryEvent({required this.searchQuery,
    required this.searchParameterType,required this.queryModel});
}

class UpdateSearchListingFilterEvent extends LandingEvent {
  final QueryModel queryModel;
  final Map<String,bool> categoryValues;
  UpdateSearchListingFilterEvent({required this.queryModel,required this.categoryValues});
}
class LoadSearchFilterValuesEvent extends LandingEvent{
  final String categoryName;
  final String categoryType;
  LoadSearchFilterValuesEvent({required this.categoryType,required this.categoryName});
}
