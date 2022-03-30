
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/company/model/resource_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';

abstract class CompanyOperationState extends Equatable{}
class CompanyOperationLoadedState extends CompanyOperationState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}


class AddOrUpdateResourceState extends CompanyOperationState{
  final bool isResourceAdded;
  AddOrUpdateResourceState({required this.isResourceAdded});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadingCompanyOperationState extends CompanyOperationState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}


class UpdateResourceConfirmState extends CompanyOperationState{
  final bool isUpdated;
  UpdateResourceConfirmState({required this.isUpdated});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class UpdateResourceLoadingConfirmState extends CompanyOperationState{

  UpdateResourceLoadingConfirmState();
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}