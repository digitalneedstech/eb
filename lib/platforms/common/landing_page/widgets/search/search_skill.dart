import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';

class SearchSkill extends StatefulWidget {
  String searchQuery;
  final Function callback;
  final String searchPlaceholder;

  SearchSkill(
      {required this.callback, this.searchQuery="", this.searchPlaceholder = "Search Skill"});
  SearchSkillState createState()=>SearchSkillState();
}
class SearchSkillState extends State<SearchSkill>{

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex:3,
      child: Container(
        //margin: const EdgeInsets.only(left: 10.0,top: 10.0),
        decoration: BoxDecoration(
          //border: Border.all(color: Colors.grey,width: 2.0),
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: TextFormField(
          controller: BlocProvider.of<LandingDashboardBloc>(context)
              .associateNameController,
          decoration: new InputDecoration(
            prefixIcon: Icon(Icons.search),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(10.0)
            ),
            suffixIcon: IconButton(
              onPressed: (){
                widget.callback(BlocProvider.of<LandingDashboardBloc>(context)
                    .associateNameController.text);
              },
              icon: Icon(Icons.check),
            ),
            hintText: widget.searchPlaceholder,
          ),
          /*controller: BlocProvider.of<LandingBloc>(context)
              .associateNameController,
          onFieldSubmitted: (String val) {
            callback();
          },*/
        ),
      ),
    );  }
}
