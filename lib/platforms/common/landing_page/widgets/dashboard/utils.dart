import 'package:flutter/cupertino.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';

String getSearchType(bool isFreelancer,BuildContext context){
  String searchType=isFreelancer ? "Client" : "Freelancer";
  if(getUserDTOModelObject(context).personalDetails.type==Constants.CUSTOMER
      && getUserProfileType(context)==Constants.CUSTOMER){
    searchType="Freelancer";
  }
  else if(getUserDTOModelObject(context).personalDetails.type==Constants.CUSTOMER
      && getUserProfileType(context)==Constants.USER){
    searchType="Client";
  }
  return searchType;
}