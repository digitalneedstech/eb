import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_event.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/bid_popup/bid_popup.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_freelancer_bloc/group_freelancer_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_freelancer_bloc/group_freelancer_event.dart' as freelancer;
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/utils/schedule_call_functions.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/eb_circle_avatar/eb_circle_avatar.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';

class GroupFreelancerTile extends StatelessWidget{
  UserDTOModel freelancerModel;
  final Function callback;
  final String groupAdminId;
  final String groupId;
  GroupFreelancerTile({required this.groupId,required this.groupAdminId,required this.freelancerModel,required this.callback});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              EbCircleAvatarWidget(profileImageUrl: freelancerModel.personalDetails.profilePic),
              SizedBox(width: 10.0,),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(freelancerModel.personalDetails.displayName),


                      ],
                    ),
                  ],
                ),
              ),
              groupAdminId==getUserDTOModelObject(context).userId ?PopupMenuButton<String>(
                onSelected: (val)async{
                  switch(val){
                    case 'Remove From Group':
                      bool isToBeDeleted=await showDialog(context: context,
                          builder: (context){
                            return AlertDialog(
                              actions: [
                                EbRaisedButtonWidget(callback: (){
                                  Navigator.pop(context,true);
                                },buttonText: "Yes",),
                                EbRaisedButtonWidget(callback: (){
                                  Navigator.pop(context,false);
                                },buttonText: "No",)
                              ],
                              content: Container(
                                child: Center(
                                  child: Text("Are you sure to delete the user from group"),
                                ),
                              ),
                            );
                          });
                      if(isToBeDeleted) {
                        BlocProvider.of<GroupFreelancerBloc>(context)
                            .add(freelancer.RemoveFreelancerFromGroupEvent(
                            groupId: groupId,
                            freelancerId: freelancerModel.userId));
                      }
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'Remove From Group'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ):Container()
            ],
          ),
          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder<double>(
                future: getBidAmount(freelancerModel, context),
                builder: (context,snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Expanded(
                        child: Text("Loading",textAlign: TextAlign.right,),

                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      return Expanded(
                        child: Text("\$ ${snapshot.data} /hr",textAlign: TextAlign.right,),

                      );
                  }

              }
              ),
              SizedBox(width: 10.0,),
              Expanded(
                child: InkWell(
                    onTap: (){
                      if (freelancerModel.rateDetails.hourlyRate==0) {
                        callback(false,"Freelancer hasnt configured hourly rate");

                      } else {
                        BlocProvider.of<BidBloc>(context)
                            .add(ClearBidModel());
                        showDialog(
                            context: context,
                            builder: (context) {
                              return BidPopup(
                                model: freelancerModel,
                                bidderId:
                                BlocProvider.of<LoginBloc>(context)
                                    .userDTOModel
                                    .userId,
                                companyId: freelancerModel.companyId,
                                freelancerId: freelancerModel.userId,callback: (){
                                /*showAlertBox(
                                    "Bid Has been placed",
                                        ()=>Navigator.pop(context),
                                        ()=>Navigator.pop(context),
                                    context
                                );*/

                                callback(true,"Bid Has Been Placed. Thanks");

                              },);
                            },
                            barrierDismissible: false);
                      }
                    },
                    child: Text("Make Bid",textAlign: TextAlign.left,style: TextStyle(color: Colors.blue),)),

              )

            ],
          )
        ],
      ),
    );
  }


  Future<double> getBidAmount(UserDTOModel userDTOModel,BuildContext context)async{
    BidModel bidModel=await checkIfExistingBidBeforeStartingCall(userDTOModel,context);
    return bidModel.acceptedRate.toDouble();
  }
}