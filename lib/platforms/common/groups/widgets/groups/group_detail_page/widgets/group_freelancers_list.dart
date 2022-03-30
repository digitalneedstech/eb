import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_freelancer_bloc/group_freelancer_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_freelancer_bloc/group_freelancer_state.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups/group_detail_page/sub_widgets/group_freelancer_tile.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/listing_page.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/constants/routes.dart';
import 'package:flutter_eb/shared/utils/schedule_call_functions.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';

class GroupFreelancersList extends StatelessWidget{
  final GroupModel groupModel;
  final Function callback;
  GroupFreelancersList({required this.callback,required this.groupModel});
  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupFreelancerBloc,GroupFreelancerState>(
      listener: (context,state){
        if(state is RemoveFreelancerFromGroupState){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.isUserDeleted ?
          "User is Deleted. You can see the updated list in next time.":"User is not deleted"),
          backgroundColor: state.isUserDeleted ? Colors.green:Colors.red,));
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: const EdgeInsets.all(10.0),
        color: Colors.white,
        height: MediaQuery.of(context).size.height*0.3,
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${groupModel.groupMembers.length} Members",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                groupModel.adminId==getUserDTOModelObject(context).userId ?InkWell(onTap: (){
                  showDialog(context: context,builder: (context){
                    return AlertDialog(
                      title: Center(child: Text("Add Freelancer"),),
                      content: Container(
                        height: MediaQuery.of(context).size.height*0.2,
                        child: Column(
                          children: [
                            Divider(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: (){
                                    Navigator.pop(context);
                                    Navigator.popAndPushNamed(context, Routes.GROUPS);
                                  },child: Text("Add From Wishlist"),
                                ),
                                InkWell(
                                  onTap: (){
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ListingPage(isFreelancerAdditionEnabled: true,groupId:groupModel.groupId)));
                                  },child: Text("Add From Search Screen"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(0.0),
                    );
                  });
                  //TOOD- Add From Wishlist or search list screen
                },child: Text("Add Freelancer",style: TextStyle(color: Colors.blue),),):Container()
              ],
            ),
            ListView.builder(itemBuilder: (context,int index){
              List<UserDTOModel> freelancers=groupModel.groupMembers.keys.toList();
              return GroupFreelancerTile(
                  groupId: groupModel.groupId,
                  groupAdminId: groupModel.adminId,
                  callback: (bool flag,String message){
                    callback(flag,message);

                  },freelancerModel: freelancers[index],
                );

            },physics: BouncingScrollPhysics(),itemCount: groupModel.groupMembers.length,shrinkWrap: true,)
          ],
        ),
      ),
    );
  }

  Future<double> getBidAmount(UserDTOModel userDTOModel,BuildContext context)async{
    BidModel bidModel=await checkIfExistingBidBeforeStartingCall(userDTOModel,context);
    return bidModel.askedRate.toDouble();
  }
}