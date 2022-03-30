
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/company/model/resource_model.dart';

class CompanyEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchResourcesEvent extends CompanyEvent{
  String companyId;
  String freelancerSearchText;
  FetchResourcesEvent({required this.companyId,this.freelancerSearchText=""});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}

class AddResourceEvent extends CompanyEvent{
  final String userid,companyId;
  AddResourceEvent({required this.userid,this.companyId=""});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}