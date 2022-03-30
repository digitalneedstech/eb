import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_state.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_freelancer_model.dart';
class WishlistPopOver extends StatelessWidget{
  final UserDTOModel freelancerModel;
  WishlistPopOver({required this.freelancerModel});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<GroupBloc>(context).add(FetchGroupsEvent(userId: getUserDTOModelObject(context).userId,fetchMyOwnerGroups: true));
    return Container(
      height: MediaQuery.of(context).size.height*0.5,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Divider(),
          BlocBuilder<GroupBloc,GroupState>(
            builder: (context,state){
              if(state is FetchGroupsState){
                if(state.listOfGroupModels.isEmpty)
                  return Center(child: Text("No Data Found"),);
                return Container(
                  height: MediaQuery.of(context).size.height*0.3,
                  child: ListView.builder(itemBuilder: (context,int index){
                    return InkWell(
                      onTap: ()async{
                        String finalRate="";
                        Map<bool,QueryDocumentSnapshot?> snapshot=await BlocProvider.of<BidBloc>(context).bidRepository
                            .getBidsBetweenTwoUsers(getUserDTOModelObject(context).userId, freelancerModel.userId);
                        if(snapshot[true]!=null) {
                          BidModel bidModel = BidModel.fromJson(
                              snapshot[true]!.data() as Map<String, dynamic>,
                              snapshot[true]!.id);
                          finalRate=bidModel.askedRate.toString();
                        }
                        else{
                          finalRate=freelancerModel.rateDetails.hourlyRate.toString();
                        }
                        BlocProvider.of<GroupBloc>(context)
                            .add(AddUserToGroupEvent(
                            groupId: state.listOfGroupModels[index].groupId,userId: getUserDTOModelObject(context).userId,
                        groupFreelancerModel: GroupFreelancerModel(
                          freelancerId: freelancerModel.userId,
                          freelancerEmail: freelancerModel.personalDetails.email,
                          isAccept: false,
                          finalRate: finalRate,
                          freelancerName: freelancerModel.personalDetails.displayName,
                          profilePic: freelancerModel.personalDetails.profilePic,
                          profileTitle: freelancerModel.profileOverview.profileTitle,
                          createdAt: DateTime.now().toIso8601String()
                        )));
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.listOfGroupModels[index].groupName,style: TextStyle(fontStyle: FontStyle.italic)),
                            Text("  (existing group)",style: TextStyle(color: Colors.grey,fontStyle: FontStyle.italic),)
                          ],
                        ),
                      ),
                    );
                  },itemCount: state.listOfGroupModels.length),
                );
              }
              else{
                return Center(child: Text("Loading"),);
              }
            }
          )
        ],
      ),
    );
  }
}