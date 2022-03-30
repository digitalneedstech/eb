import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_state.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_freelancer_model.dart';
class AddGroupButton extends StatelessWidget {
  Function callback;
  AddGroupButton({required this.callback});
  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupBloc, GroupState>(
        listener: (context, state) {
          if (state is CreateGroupState) {
            BlocProvider.of<GroupBloc>(context).add(FetchGroupsEvent(
                userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId,fetchMyOwnerGroups: true));
          }
        },
        child: RaisedButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AddGroupDialog(callback: (){},);
                  });
            },
            child: Center(
              child: Text("Add Group"),
            )));
  }
}

class AddGroupDialog extends StatefulWidget {
  final Function callback;
  AddGroupDialog({required this.callback});
  AddGroupDialogState createState() => AddGroupDialogState();
}

class AddGroupDialogState extends State<AddGroupDialog> {
  TextEditingController _groupNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text("Add Group Name"),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Center(
          child: TextFormField(
            controller: _groupNameController,
            decoration: InputDecoration(labelText: "Please Enter Group Name"),
          ),
        ),
      ),
      actions: [
        BlocBuilder<GroupBloc, GroupState>(builder: (context, state) {
          if (state is LoadingGroupState) {
            return RaisedButton(
              onPressed: null,
              color: Colors.blue,
              textColor: Colors.white,
              child: Text("Loading"),
            );
          } else {
            return RaisedButton(
              onPressed: () {
                if (_groupNameController.text != "") {
                  UserDTOModel userDTOModel =
                      BlocProvider.of<LoginBloc>(context).userDTOModel;
                  GroupModel model = GroupModel(
                      createdAt: DateTime.now().toIso8601String(),
                      adminName: userDTOModel.personalDetails.displayName,
                      adminId: userDTOModel.userId,
                      groupName: _groupNameController.text,
                      adminPic: userDTOModel.personalDetails.profilePic);
                  BlocProvider.of<GroupBloc>(context)
                      .add(CreateGroupWithoutFreelancerEvent(groupModel: model));
                  widget.callback();
                  Navigator.pop(context);
                }
              },
              color: Colors.blue,
              textColor: Colors.white,
              child: Text("Add"),
            );
          }
        })
      ],
    );
  }
}


class AddGroupDialogForFreelancer extends StatefulWidget {
  final Function callback;
  final UserDTOModel userDTOModel;
  AddGroupDialogForFreelancer({required this.callback,required this.userDTOModel});
  AddGroupDialogForFreelancerState createState() => AddGroupDialogForFreelancerState();
}

class AddGroupDialogForFreelancerState extends State<AddGroupDialogForFreelancer> {
  TextEditingController _groupNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text("Add Group Name"),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Center(
          child: TextFormField(
            controller: _groupNameController,
            decoration: InputDecoration(labelText: "Please Enter Group Name"),
          ),
        ),
      ),
      actions: [
        BlocBuilder<GroupBloc, GroupState>(builder: (context, state) {
          if (state is LoadingGroupState) {
            return RaisedButton(
              onPressed: null,
              color: Colors.blue,
              textColor: Colors.white,
              child: Text("Loading"),
            );
          } else {
            return RaisedButton(
              onPressed: () {
                if (_groupNameController.text != "") {
                  UserDTOModel userDTOModel =
                      BlocProvider.of<LoginBloc>(context).userDTOModel;
                  GroupModel model = GroupModel(
                      createdAt: DateTime.now().toIso8601String(),
                      adminName: userDTOModel.personalDetails.displayName,
                      adminId: userDTOModel.userId,
                      groupName: _groupNameController.text,
                      adminPic: userDTOModel.personalDetails.profilePic);
                  GroupFreelancerModel groupFreelancerModel=new GroupFreelancerModel(
                      freelancerId: widget.userDTOModel.userId,
                      freelancerEmail: widget.userDTOModel.personalDetails.email,
                      isAccept: false,
                      finalRate: widget.userDTOModel.personalDetails.email,
                      freelancerName: widget.userDTOModel.personalDetails.displayName,
                      profilePic: widget.userDTOModel.personalDetails.profilePic,
                      profileTitle: widget.userDTOModel.profileOverview.profileTitle,
                      createdAt: DateTime.now().toIso8601String()
                  );

                  BlocProvider.of<GroupBloc>(context)
                      .add(CreateGroupEvent(groupModel: model,groupFreelancerModel:
                  groupFreelancerModel));
                  widget.callback();
                }
              },
              color: Colors.blue,
              textColor: Colors.white,
              child: Text("Add"),
            );
          }
        })
      ],
    );
  }
}

