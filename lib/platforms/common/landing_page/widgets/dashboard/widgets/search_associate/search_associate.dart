import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';

class SearchAssociate extends StatelessWidget {
  String fieldTypeToBeSearched;
  final String searchPlaceholder;
  final Function callback;
  SearchAssociate({this.fieldTypeToBeSearched="",this.searchPlaceholder="",required this.callback});
  @override
  Widget build(BuildContext context) {
    UserDTOModel userDTOModel = getUserDTOModelObject(context);
    BlocProvider.of<LandingDashboardBloc>(context)
        .associateNameController
        .text = "";
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0)),
      child: TextFormField(
        decoration: new InputDecoration(
          prefixIcon: Icon(Icons.search),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(10.0)),
          hintText: searchPlaceholder=="" ?getUserDTOModelObject(context).personalDetails.type==Constants.CUSTOMER && getUserProfileType(context)==Constants.CUSTOMER
              ? 'Search Resources'
              : (fieldTypeToBeSearched == "Client"
              ? "Search Client"
              : "Search Freelancer"):searchPlaceholder,
        ),
        controller: BlocProvider.of<LandingDashboardBloc>(context)
            .associateNameController,
        onFieldSubmitted: (String val) {
          callback();
        },
      ),
    );
  }
}
