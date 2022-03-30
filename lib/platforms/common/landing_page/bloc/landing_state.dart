import 'package:equatable/equatable.dart';
import 'package:flutter_eb/platforms/common/landing_page/model/query_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LandingState extends Equatable {}
class LandingLoadedState extends LandingState {
  @override
  List<Object> get props => [];
}
class FetchFreelancersListState extends LandingState {
  List<UserDTOModel> userModel;
  String errorMessage;
  FetchFreelancersListState({required this.userModel,this.errorMessage=""});
  @override
  List<Object> get props => [];
}

class LoadingState extends LandingState {
  @override
  List<Object> get props => [];
}

class ExceptionState extends LandingState {
  String message;

  ExceptionState({this.message=""});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}

class LoadSearchFilterValuesState extends LandingState{
  final Map<String,bool> categoryValues;
  final String categoryType;
  final String categoryName;
  LoadSearchFilterValuesState({this.categoryName="",this.categoryType="",required this.categoryValues});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadSearchFilterValuesInProgressState extends LandingState {
  @override
  List<Object> get props => [];
}

class ClearSearchListingFilterState extends LandingState {
  ClearSearchListingFilterState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}


class UpdateSearchListingFilterState extends LandingState {
  final QueryModel queryModel;
  final Map<String,bool> categoryValues;
  UpdateSearchListingFilterState({required this.queryModel,required this.categoryValues});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ClearSearchListingFilterInProgressState extends LandingState {
  ClearSearchListingFilterInProgressState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}