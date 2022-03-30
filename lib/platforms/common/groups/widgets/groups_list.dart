import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_state.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups/group_card_widget/group_card_widget.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/animate_list/animate_list.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class GroupsListPage extends StatelessWidget {
  final bool fetchMyOwnerGroups;
  GroupsListPage({this.fetchMyOwnerGroups = true});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<GroupBloc>(context).add(FetchGroupsEvent(
        userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId,fetchMyOwnerGroups: fetchMyOwnerGroups));
    return BlocBuilder<GroupBloc, GroupState>(
      builder: (context, state) {
        if (state is FetchGroupsState) {
          if (state.listOfGroupModels.isEmpty) {
            return NoDataFound();
          } else {
            BlocProvider.of<LandingBloc>(context).associateNameController.text =
                "";
            return Container(
              width: getScreenWidth(context)> 800?MediaQuery.of(context).size.width*0.8:MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              height: MediaQuery.of(context).size.height * 0.75,
              child:  AnimationLimiter(child: getScreenWidth(context)>800 ?Wrap(
                children:state.listOfGroupModels.map((e) {
                  return GroupCardWidget(groupModel: e,isOwnerGroup: fetchMyOwnerGroups);
                }).toList() ,
              ):ListView.builder(
                shrinkWrap: true,
                itemCount: state.listOfGroupModels.length,
                itemBuilder: (context, int index) {
                  GroupModel groupModel = state.listOfGroupModels[index];
                  return AnimateList(index:index,widget:
                  GroupCardWidget(groupModel: groupModel,isOwnerGroup: fetchMyOwnerGroups));
                },
              )),
            );
          }
        } else if (state is CreateGroupState) {
          return Center(
            child: Text("Fetching the Latest Groups"),
          );
        } else {
          return Center(
            child: Text("Loading Groups..."),
          );
        }
      },
    );
  }
}
