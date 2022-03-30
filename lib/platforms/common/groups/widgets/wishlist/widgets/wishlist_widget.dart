import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_event.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/bid_popup/bid_popup.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/add_group_button.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/wishlist/bloc/wishlist_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/wishlist/bloc/wishlist_event.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/wishlist/model/wishlist_model.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/wishlist/widgets/wishlist_popup.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/listing_page_detail.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/quick_connect/quick_connect_popup.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/eb_circle_avatar/eb_circle_avatar.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
import 'package:flutter_eb/shared/widgets/success_alert_box/success_alert_box.dart';
class WishListWidget extends StatelessWidget{
  final UserDTOModel ownerDTOModel;
  final UserDTOModel userDTOModel;
  final Function callback;
  WishListWidget({required this.ownerDTOModel,required this.userDTOModel,required this.callback});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListingPageDetail(userDTOModel: userDTOModel)),
        );
      },
      child: Container(
        width: getScreenWidth(context)>800 ? MediaQuery.of(context).size.width*0.25:
        MediaQuery.of(context).size.width*0.8,
        margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey,width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  EbCircleAvatarWidget(profileImageUrl: userDTOModel.personalDetails.profilePic,),
                  Expanded(child: SizedBox()),
                  IconButton(color: Colors.blue,icon: Icon(Icons.bookmark), onPressed: (){
                    BlocProvider.of<WishListBloc>(context).add(RemoveUserIdToWishListEvent(userId: ownerDTOModel.userId,
                        wishListModel: WishListModel(freelancerId: userDTOModel.userId)));
                  }),
                  PopupMenuButton<String>(
                    onSelected: (val)async{
                      switch(val){
                        case 'Move To Group':
                          showDialog(context: context,barrierDismissible:true,builder: (context){
                            return AlertDialog(
                              title: Center(child: Text("Move to Group"),),
                              contentPadding: const EdgeInsets.all(0.0),
                              content: WishlistPopOver(freelancerModel: userDTOModel),
                            );
                          });
                          break;
                        case 'Create A New Group':
                          showDialog(context: context,builder: (context){
                            return AddGroupDialogForFreelancer(callback: (){
                              Navigator.pop(context);

                            },userDTOModel: userDTOModel,);
                          });
                          break;
                        case 'Remove From Wishlist':
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
                            BlocProvider.of<WishListBloc>(context).add(RemoveUserIdToWishListEvent(userId: ownerDTOModel.userId,
                                wishListModel: WishListModel(freelancerId: userDTOModel.userId)));
                          }
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return {'Move To Group','Create A New Group','Remove From Wishlist'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 0.0),
              child: Row(
                children: [
                  Text(
                    "${userDTOModel.personalDetails.displayName==""? Constants.UNNAMED:userDTOModel.personalDetails.displayName}",
                    style: TextStyle(color: Colors.blue,fontSize: 18.0),
                  ),
                  SizedBox(width: 10.0,),
                  Expanded(
                      child: Container(
                        child: Text(
                          userDTOModel.personalDetails.country,
                          style: TextStyle(color: Colors.grey,fontSize: 18.0),
                        ),
                      ))
                ],
              ),
            ),
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
          child: Text(
            userDTOModel.profileOverview.profileTitle == ""
                ? Constants.UNTITLED
                : userDTOModel.profileOverview.profileTitle,
            style: TextStyle(color: Colors.black, fontSize: 14.0),
          ),
        ),
            userDTOModel.companyId!="" ?FutureBuilder<DocumentSnapshot>(
                future: BlocProvider.of<LoginBloc>(context).loginRepository.getUserByUid(userDTOModel.companyId),
                builder: (context,AsyncSnapshot<DocumentSnapshot> snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Text("Loading",
                          style: TextStyle(
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left);
                    default:
                      late UserDTOModel user;
                      if(snapshot.data!=null)
                        user=UserDTOModel.fromJson(snapshot.data!.data() as Map<String,dynamic>,snapshot.data!.id);
                      return Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: Color(0xFFE3F2FD),
                            borderRadius:
                            BorderRadius.circular(10.0)),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("By:",style: TextStyle(color: Colors.grey),),
                              Text("${user.personalDetails.displayName}",

                                  textAlign: TextAlign.left),
                            ],
                          ),
                        ),
                      );
                  }
                }
            ):Container(),
            userDTOModel.skills!=null ? Wrap(children: getSkills(userDTOModel)):Container(),
            Divider(
              height: 2.0,
              color: Colors.grey.shade500,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(
                          text: "\ ${userDTOModel.rateDetails.hourlyRate}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,fontSize: 18.0),
                          children: <TextSpan>[
                            TextSpan(
                                text: " /hr",
                                style: TextStyle(
                                    color: Colors.grey.shade500))
                          ])),
                  Expanded(child: SizedBox()),
                  InkWell(onTap: ()async{
                    BlocProvider.of<BidBloc>(context).add(ClearBidModel());
                    bool isCreated=await showDialog(context: context,builder: (context){
                      return BidPopup(
                        companyId: userDTOModel.companyId,
                          model: userDTOModel,
                          bidderId: ownerDTOModel.userId,
                          freelancerId: userDTOModel.userId,
                      callback: (){

                      },);
                    },barrierDismissible: false);
                  },child: Text("Make Bid",style: TextStyle(color: Colors.blue,fontSize: 16.0),),),
                  SizedBox(width: 10.0,),
                  OutlineButton(onPressed: (){
                    showDialog(context: context,builder: (context){
                      return QuickConnectPopup(
                        freelancerDTOModel: userDTOModel,
                      );
                    },barrierDismissible: true);
                  }, child: Center(child: Text("Quick Connect",style: TextStyle(fontSize: 16.0),),),color: Colors.blue,textColor: Colors.blue,borderSide: BorderSide(
                    color: Colors.blue, //Color of the border
                    style: BorderStyle.solid, //Style of the border
                    width: 1, //width of the border
                  )),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getSkills(UserDTOModel model) {
    return model.skills.map((e) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Skill",
              style: TextStyle(color: Colors.black,fontSize: 18.0),
            ),
            Text(
              "2 Yrs",
              style: TextStyle(color: Colors.grey,fontSize: 14.0),
            )
          ],
        ),
      );
    }).toList();
  }
}