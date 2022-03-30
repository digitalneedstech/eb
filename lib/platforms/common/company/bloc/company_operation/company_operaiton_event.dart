
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/company/model/resource_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';

class CompanyOperationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddResourcesEvent extends CompanyOperationEvent{
  final List<String> companyResources;
  final String companyId,userName,shareLink;
  AddResourcesEvent({required this.companyResources,
    this.userName="",this.shareLink="",this.companyId=""});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class UpdateResourceEvent extends CompanyOperationEvent{
  final UserDTOModel companyResource;
  UpdateResourceEvent({required this.companyResource});

}



class UpdateResourceConfirmEvent extends CompanyOperationEvent{
  final String userId,companyId,status;
  UpdateResourceConfirmEvent({required this.userId,this.companyId="",this.status=""});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
