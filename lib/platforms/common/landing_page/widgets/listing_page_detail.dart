import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_event.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/bid_popup/bid_popup.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/quick_connect/quick_connect_popup.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/reviews/reviews_list.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/schedule_call/schedule_call.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/search_tile/search_tile.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_model.dart';
import 'package:flutter_eb/platforms/common/schedule/schedule.dart';
import 'package:flutter_eb/shared/utils/schedule_call_functions.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/eb_circle_avatar/eb_circle_avatar.dart';
import 'package:flutter_eb/shared/widgets/eb_outline_button_widget/eb_outline_button_widget.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/widgets/eb_web_app_bar/eb_web_appbar.dart';
import 'package:flutter_eb/shared/widgets/success_alert_box/success_alert_box.dart';
class ListingPageDetail extends StatelessWidget {
  UserDTOModel userDTOModel;
  ListingPageDetail({required this.userDTOModel});
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade300,
      appBar: getScreenWidth(context)>800 ?PreferredSize(
          preferredSize: Size.fromHeight(0.0), // here the desired height
          child: AppBar(
            automaticallyImplyLeading: false,
          )
      ): AppBar(
        title: Text("User Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getScreenWidth(context)>800 ?EbWebAppBarWidget():Container(),
            SizedBox(height: 10.0,),
            Container(
              margin: getScreenWidth(context)>600 ?EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width*0.05,
              ):EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        EbCircleAvatarWidget(profileImageUrl: userDTOModel.personalDetails.profilePic,),
                        Expanded(child: SizedBox()),
                        userDTOModel.profileOverview.totalExperience!="" ?Text(
                          "Total Exp - ${userDTOModel.profileOverview.totalExperience}",
                          style: TextStyle(color: Colors.black54, fontSize: 14.0),
                        ):Container(),
                        IconButton(
                            icon: Icon(Icons.video_collection_outlined),
                            onPressed: null,
                            color: Colors.black54),
                        WishListWidget(
                          freelancerId: userDTOModel.userId,
                          callback: (String val) {

                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    child: Row(
                      children: [
                        Text(
                          userDTOModel.personalDetails.displayName == Constants.UNNAMED
                              ? Constants.UNNAMED
                              : userDTOModel.personalDetails.displayName,
                          style: TextStyle(color: Colors.blue, fontSize: 14.0),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                            child: Container(
                              child: Text(
                                userDTOModel.personalDetails.country == ""
                                    ? "Country Not Added"
                                    : userDTOModel.personalDetails.country,
                                style: TextStyle(color: Colors.grey, fontSize: 14.0),
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
                  SizedBox(
                    height: 20.0,
                  ),
                  Divider(
                    height: 2.0,
                    color: Colors.grey.shade500,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: RaisedButton(
                      onPressed: () {
                        if(userDTOModel.isOnline) {
                          CallModel callModel = CallModel(
                              acceptedPrice: userDTOModel.rateDetails.hourlyRate.toDouble(),
                              userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId,
                              receiverId: [userDTOModel.userId],
                              scheduleId: "",
                              receiverName: userDTOModel.personalDetails
                                  .displayName,
                              userName: BlocProvider.of<LoginBloc>(context).userDTOModel.personalDetails.displayName);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                ScheduleCall(callModel: callModel,buttonTitle: "Call Now",)),
                          );
                        }
                        else{
                          _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("User is Either not online/available to take call."),backgroundColor: Colors.orange,));
                        }
                      },
                      color: Colors.blue.shade300,
                      child: Center(
                        child: Text("Call Now"),
                      ),
                      textColor: Colors.white,
                    ),
                  ),
                  Container(
                    child: Center(
                      child: ButtonBar(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          EbOutlineButtonWidget(
                            buttonText: "Schedule Call",
                            callback: () {
                              if (userDTOModel.rateDetails.hourlyRate == "") {
                                _scaffoldKey.currentState!.showSnackBar(SnackBar(
                                  content: Text(
                                      "Freelancer hasnt configured hourly rate"),
                                  backgroundColor: Colors.red,
                                ));
                              } else {
                                checkIfExistingBidBeforeStartingCall(userDTOModel,context)
                                    .then((BidModel bidModel){
                                  if(bidModel.askedRate==0){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Freelancer Asked Rate is Zero",style: TextStyle(color: Colors.red),)));
                                  }
                                  else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SchedulePage(
                                                bidModel: bidModel,
                                              )),
                                    );
                                  }
                                });
                              }
                            },
                          ),
                          SizedBox(width: 5.0,),
                          EbOutlineButtonWidget(
                            buttonText: "Quick Connect",
                            callback: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return QuickConnectPopup(
                                        freelancerDTOModel: userDTOModel);
                                  },
                                  barrierDismissible: true);
                            },
                          ),
                          SizedBox(width: 5.0,),
                          EbOutlineButtonWidget(
                            buttonText: "Make A Bid",
                            callback: ()async {
                              if (userDTOModel.rateDetails == null ||
                                  userDTOModel.rateDetails.hourlyRate == "") {
                                _scaffoldKey.currentState!.showSnackBar(SnackBar(
                                  content: Text(
                                      "Freelancer hasnt configured hourly rate"),
                                  backgroundColor: Colors.red,
                                ));
                              } else {
                                BlocProvider.of<BidBloc>(context)
                                    .add(ClearBidModel());
                                bool isCreated=await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return BidPopup(
                                        companyId: userDTOModel.companyId,
                                          model: userDTOModel,
                                          bidderId:
                                              BlocProvider.of<LoginBloc>(context)
                                                  .userDTOModel
                                                  .userId,
                                          freelancerId: userDTOModel.userId,callback: (){

                                            _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("Bid Has Been Placed. Thanks"),backgroundColor: Colors.green,));                                  },);
                                    },
                                    barrierDismissible: false);
                                if(isCreated){
                                  showAlertBox(
                                      "Bid Has been placed",
                                          ()=>Navigator.pop(context),
                                          ()=>Navigator.pop(context),
                                      context
                                  );
                                }
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0,),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: getScreenWidth(context)>600 ?EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width*0.05,
                ):EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    /*boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],*/
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("About Me"),
                    userDTOModel.profileOverview.overview==""? Text("No Info available",style: TextStyle(
                        color: Colors.grey
                    ),)
                    :
                    Container(
                      height: MediaQuery.of(context).size.height*0.15,
                      padding: new EdgeInsets.only(right: 13.0),
                      child: Wrap(
                        children: [Text(userDTOModel.profileOverview.overview+" ",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey
                        ),),
                        InkWell(
                          onTap: (){
                            showDialog(context: context,builder: (context){
                              return AlertDialog(
                                content: Text(userDTOModel.profileOverview.overview),
                              );
                            },barrierDismissible:  true);
                          },
                          child: Text("Show More",style: TextStyle(color: Colors.blue),),

                        )],
                      ),
                    ),

                    Divider(
                      color: Colors.grey,
                      thickness: 2.0,
                    ),
                    userDTOModel.skills.isEmpty ?Container():Text("Skills"),
                    userDTOModel.skills.isEmpty ?Text("No Skills added",style: TextStyle(
                        color: Colors.grey
                    ),):Row(
                        children: userDTOModel.skills
                            .map((e) => Container(
                                  padding: const EdgeInsets.all(5.0),
                                  margin: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.skill,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 18.0),
                                      ),
                                      Text(
                                        e.yearsOfExperience.toString(),
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14.0),
                                      )
                                    ],
                                  ),
                                ))
                            .toList()),
                    Divider(
                      color: Colors.grey,
                      thickness: 2.0,
                    ),
                    ReviewsList(feedbackForUserId: userDTOModel.userId,callback: (bool isAdded){
                     _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(isAdded ? "Thanks. Feedback is Added":"Sorry. Feedback could not be added"),
                     backgroundColor: isAdded ? Colors.green:Colors.red,));
                    })
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
