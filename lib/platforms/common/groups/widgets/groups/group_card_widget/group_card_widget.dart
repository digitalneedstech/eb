import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_operations/group_operations_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_operations/group_operations_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_operations/group_operations_state.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups/group_detail_page/group_detail_page.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/confirm_popup_widget/confirm_popup_widget.dart';

class GroupCardWidget extends StatelessWidget {
  final GroupModel groupModel;
  final bool isOwnerGroup;
  GroupCardWidget({required this.groupModel, required this.isOwnerGroup});
  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupOperationsBloc, GroupOperationsState>(
      listener: (context, state) {
        if (state is DeleteGroupState) {
          BlocProvider.of<GroupBloc>(context).add(FetchGroupsEvent(
             fetchMyOwnerGroups: true,
              userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId));
        }
      },
      child: BlocBuilder<GroupOperationsBloc, GroupOperationsState>(
        builder: (context, state) {
          Widget trailingWidget = PopMenuWidget(groupId: groupModel.groupId);
          if (state is LoadingGroupDeleteOperationsState) {
            trailingWidget = Text(
              "Deleting",
              style: TextStyle(color: Colors.red),
            );
          }
          return InkWell(
            onTap: () {
              if(kIsWeb){
               Navigator.pushNamed(context, "group/"+groupModel.groupId);
              }else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GroupDetailPage(
                                groupId: groupModel.groupId
                            )));
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
              width: getScreenWidth(context)>800 ?MediaQuery.of(context).size.width*.25:
              MediaQuery.of(context).size.width*.80,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          groupModel.groupName,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      trailingWidget
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "${groupModel.groupMembers.length} members",
                      style: TextStyle(color: Colors.grey, fontSize: 16.0),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  isOwnerGroup
                      ? Divider(
                          height: 2.0,
                          color: Colors.grey,
                        )
                      : Container(),
                  isOwnerGroup
                      ? SizedBox(
                          height: 20.0,
                        )
                      : Container(),
                  isOwnerGroup
                      ? InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GroupDetailPage(
                                      groupId: groupModel.groupId,
                                          isScheduleEnabled: true,
                                        )));
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Schedule Call",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ))
                      : Container()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PopMenuWidget extends StatelessWidget {
  String groupId;
  PopMenuWidget({required this.groupId});
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (val) async {
        switch (val) {
          case "Delete":
            bool isDeleteAllowed = await showDialog(
                context: context,
                builder: (context) {
                  return ConfirmPopupWidget(cancelButtonText: "Yes",
                    okButtonText: "No",
                    callback: (bool isDeleteAllowed) {
                      Navigator.pop(context, isDeleteAllowed);
                    },
                    header: "Are you sure to delete Group?",
                  );
                });
            if (isDeleteAllowed) {
              BlocProvider.of<GroupOperationsBloc>(context)
                  .add(DeleteGroupEvent(groupId: groupId));
            }
            break;
          default:
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return {'Delete', 'Settings'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }
}
