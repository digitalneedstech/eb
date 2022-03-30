import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';

class SearchJob extends StatefulWidget {
  String fieldTypeToBeSearched;
  final String searchPlaceholder;
  final Function callback;

  SearchJob(
      {this.fieldTypeToBeSearched = "", this.searchPlaceholder = "", required this.callback});
  SearchJobState createState()=>SearchJobState();
}
class SearchJobState extends State<SearchJob>{
  String searchVal="";
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0)),
      child: TextFormField(
        initialValue: searchVal,
        onChanged: (String? val){
          if(val!=null) {
            setState(() {
              searchVal = val;
            });
          }
        },
        decoration: new InputDecoration(
          prefixIcon: Icon(Icons.search),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(10.0)),
          hintText: widget.searchPlaceholder=="" ?getUserDTOModelObject(context).personalDetails.type==Constants.CUSTOMER && getUserProfileType(context)==Constants.CUSTOMER
              ? 'Search Resources'
              : (widget.fieldTypeToBeSearched == "Client"
              ? "Search Client"
              : "Search Freelancer"):widget.searchPlaceholder,
        ),
        onFieldSubmitted: (String val) {
          widget.callback(val);
        },
      ),
    );
  }
}
