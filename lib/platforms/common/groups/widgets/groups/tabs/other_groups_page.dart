import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_state.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/add_group_button.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups_list.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/search/search_skill.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';

class OtherGroupsPage extends StatelessWidget {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupBloc, GroupState>(
      listener: (context, state) {
        if (state is CreateGroupState) {
          _scaffoldKey.currentState!.showSnackBar(SnackBar(
            content: Text("Thanks. Group has been created.."),
            backgroundColor: Colors.green,
          ));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                getSearchBar(context),
                GroupsListPage(
                  fetchMyOwnerGroups: false,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getSearchBar(BuildContext context){
    return Container(
        width: getScreenWidth(context)> 800?MediaQuery.of(context).size.width*0.8:MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          //border: Border.all(color: Colors.grey,width: 2.0),
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: TextFormField(
          decoration: new InputDecoration(
            prefixIcon: Icon(Icons.search),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(10.0)
            ),
            hintText: "Search Group Name",
          ),
          controller: BlocProvider.of<LandingBloc>(context)
              .associateNameController,
          onFieldSubmitted: (String val) {
            if (BlocProvider.of<LandingBloc>(context)
                .associateNameController
                .text !=
                "") {
              BlocProvider.of<GroupBloc>(context).add(FetchGroupsEvent(
                  userId: BlocProvider.of<LoginBloc>(context)
                      .userDTOModel
                      .userId,
                  query: BlocProvider.of<LandingBloc>(context)
                      .associateNameController
                      .text,fetchMyOwnerGroups: false));
            } else {
              BlocProvider.of<GroupBloc>(context).add(FetchGroupsEvent(
                  userId: BlocProvider.of<LoginBloc>(context)
                      .userDTOModel
                      .userId,fetchMyOwnerGroups: false));
            }
          },
        ));
  }
}
