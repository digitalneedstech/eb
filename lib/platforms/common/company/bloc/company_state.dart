
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/company/model/resource_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';

abstract class CompanyState extends Equatable{}
class CompanyLoadedState extends CompanyState{
  @override
  // TODO: implement props
  List<Object> get props => [];

}
class FetchResourcesState extends CompanyState{
  dynamic resources;
  FetchResourcesState({required this.resources});
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class LoadingCompanyState extends CompanyState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}