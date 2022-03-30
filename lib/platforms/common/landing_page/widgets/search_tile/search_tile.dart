import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_event.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/bid_popup/bid_popup.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/add_group_button.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/wishlist/bloc/wishlist_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/wishlist/model/wishlist_model.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/wishlist/widgets/wishlist_popup.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/listing_page_detail.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/quick_connect/quick_connect_popup.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/widgets/eb_circle_avatar/eb_circle_avatar.dart';
import 'package:flutter_eb/shared/widgets/eb_outline_button_widget/eb_outline_button_widget.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/widgets/success_alert_box/success_alert_box.dart';
import 'package:flutter_eb/shared/widgets/video_upload_widget/video_item.dart';
import 'package:video_player/video_player.dart';

class SearchTile extends StatefulWidget {
  final UserDTOModel userDTOModel;
  final Function callback;
  final Function longPress;

  SearchTile({required this.userDTOModel, required this.longPress, required this.callback});
  SearchTileState createState() => SearchTileState();
}

class SearchTileState extends State<SearchTile> {
  late Color tileColor;
  void initState() {
    super.initState();
    tileColor = Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        setState(() {
          //tileColor = Colors.blue.shade300;
          if (tileColor == Colors.white){
            tileColor=Colors.blue.shade100;
            widget.longPress(widget.userDTOModel,"add");
          }
          else{
            tileColor = Colors.white;
            widget.longPress(widget.userDTOModel,"delete");
          }
        });
      },
      onTap: () {
        if(tileColor==Colors.blue.shade100){
          setState(() {
            tileColor=Colors.white;
          });
        }
        else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ListingPageDetail(
                      userDTOModel: widget.userDTOModel,
                    )),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
            color: tileColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  EbCircleAvatarWidget(profileImageUrl: widget.userDTOModel.personalDetails.profilePic,),
                  Expanded(child: SizedBox()),
                  widget.userDTOModel.profileOverview.totalExperience!="" ?Text(
                    "Total Exp - ${widget.userDTOModel.profileOverview.totalExperience}",
                    style: TextStyle(color: Colors.black54, fontSize: 14.0),
                  ):Container(),
                  IconButton(
                      icon: Icon(Icons.video_collection_outlined),
                      onPressed: null,
                      color: Colors.black54),
                  WishListWidget(
                    freelancerId: widget.userDTOModel.userId,
                    callback: (String val) {
                      widget.callback(val);
                    },
                  ),
                  widget.userDTOModel.featuredDetails.isNotEmpty ?
                      IconButton(onPressed: ()async{
                        if(widget.userDTOModel.featuredDetails[widget.userDTOModel.featuredDetails.length-1].fileType==".jpg"){
                          return showDialog(context: context,
                              builder: (context){
                            return AlertDialog(
                              content: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: Image.network(widget.userDTOModel.featuredDetails[widget.userDTOModel.featuredDetails.length-1].fileUrl,fit: BoxFit.cover,)
                              ),
                            );
                              });

                        }
                        else{
                          return showDialog(context: context,
                              builder: (context){
                                return AlertDialog(
                                  content: Container(
                                      height: MediaQuery.of(context).size.height*0.3,
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: VideoItems(
                                        videoPlayerController:
                                        VideoPlayerController.network(widget.userDTOModel.featuredDetails[widget.userDTOModel.featuredDetails.length-1].fileUrl),
                                        autoplay: false,
                                        looping: true,
                                      ))
                                );
                              });

                        }
                      },
                          icon: Icon(Icons.play_arrow)):Container(),
                  PopupMenuButton<String>(
                    onSelected: (val){
                      switch(val){
                        case 'Move To Group':
                          showDialog(context: context,barrierDismissible:true,builder: (context){
                            return AlertDialog(
                              title: Center(child: Text("Move to Group"),),
                              contentPadding: const EdgeInsets.all(0.0),
                              content: WishlistPopOver(freelancerModel: widget.userDTOModel),
                            );
                          });
                          break;
                        default:
                          showDialog(context: context,builder: (context){
                            return AddGroupDialogForFreelancer(callback: (){
                              Navigator.pop(context);
                              widget.callback("group");

                            },userDTOModel: widget.userDTOModel,);
                          });
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return {'Move To Group','Create A New group'}.map((String choice) {
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
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
              child: Row(
                children: [
                  Text(
                    widget.userDTOModel.personalDetails.displayName == Constants.UNNAMED
                        ? Constants.UNNAMED
                        : widget.userDTOModel.personalDetails.displayName,
                    style: TextStyle(color: Colors.blue, fontSize: 14.0),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                      child: Container(
                        child: Text(
                          widget.userDTOModel.personalDetails.country == ""
                              ? "No Country"
                              : widget.userDTOModel.personalDetails.country,
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
                widget.userDTOModel.profileOverview.profileTitle == ""
                    ? Constants.UNTITLED
                    : widget.userDTOModel.profileOverview.profileTitle,
                style: TextStyle(color: Colors.black, fontSize: 14.0),
              ),
            ),
            widget.userDTOModel.companyId!="" ?FutureBuilder<DocumentSnapshot>(
                future: BlocProvider.of<LoginBloc>(context).loginRepository.getUserByUid(widget.userDTOModel.companyId),
                builder: (context,AsyncSnapshot<DocumentSnapshot> snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Text("Loading",
                          style: TextStyle(
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left);
                    default:
                      UserDTOModel user=UserDTOModel.fromJson(snapshot.data!.data() as Map<String,dynamic>,snapshot.data!.id);
                      return Container(
                        width: MediaQuery.of(context).size.width*0.30,
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: Color(0xFFE3F2FD),
                            borderRadius:
                            BorderRadius.circular(10.0)),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("By: ",style: TextStyle(color: Colors.grey),),
                              Text("${user.personalDetails.displayName}",

                                  textAlign: TextAlign.left),
                            ],
                          ),
                        ),
                      );
                  }
                }
            ):Container(),
            widget.userDTOModel.skills.isEmpty ?Container():Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Wrap(children: getSkills(widget.userDTOModel)),
            ),
            Divider(
              height: 2.0,
              color: Colors.grey.shade500,
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(
                          text:
                          " \$ ${widget.userDTOModel.rateDetails.hourlyRate} ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18.0),
                          children: <TextSpan>[
                            TextSpan(
                                text: " /hr",
                                style: TextStyle(color: Colors.grey.shade500))
                          ])),
                  Expanded(child: SizedBox()),
                  InkWell(
                    onTap: ()async {
                      BlocProvider.of<BidBloc>(context).add(ClearBidModel());
                      bool isCreated=await showDialog(
                          context: context,
                          builder: (context) {
                            return BidPopup(
                              companyId: widget.userDTOModel.companyId,
                              model: widget.userDTOModel,
                              bidderId: BlocProvider.of<LoginBloc>(context)
                                  .userDTOModel
                                  .userId,
                              freelancerId: widget.userDTOModel.userId,
                              callback: () {
                                /*showAlertBox(
                                    "Bid Has been placed",
                                        ()=>Navigator.pop(context),
                                        ()=>Navigator.pop(context),
                                    context
                                );*/

                                widget.callback("bid");
                              },
                            );
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
                    },
                    child: Text(
                      "Make Bid",
                      style: TextStyle(color: Colors.blue, fontSize: 16.0),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  EbOutlineButtonWidget(
                    callback: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return QuickConnectPopup(
                                freelancerDTOModel: widget.userDTOModel);
                          },
                          barrierDismissible: true);
                    },
                    buttonText: "Quick Connect",
                  )
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
        margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              e.skill,
              style: TextStyle(color: Colors.black54, fontSize: 14.0),
            ),
            Text(
              e.yearsOfExperience.toString(),textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 14.0),
            )
          ],
        ),
      );
    }).toList();
  }
}

class WishListWidget extends StatefulWidget {
  final String freelancerId;
  final Function callback;
  WishListWidget({required this.freelancerId,required this.callback});
  WishListWidgetState createState() => WishListWidgetState();
}

class WishListWidgetState extends State<WishListWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: BlocProvider.of<WishListBloc>(context)
            .wishListRepository
            .checkIfUserIsInWhitelist(widget.freelancerId,
            BlocProvider.of<LoginBloc>(context).userDTOModel.userId),
        builder: (context, AsyncSnapshot<bool> isWishListed) {
          switch (isWishListed.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Container();
            case ConnectionState.active:
            case ConnectionState.done:
              bool? isWish = isWishListed.data;
              if(isWish==null)
                return Text("Error");
              return IconButton(
                  icon: Icon(isWish
                      ? Icons.bookmark
                      : Icons.bookmark_border),
                  onPressed: () {
                    BlocProvider
                        .of<WishListBloc>(context)
                        .wishListRepository
                        .addUserToWishList(
                        BlocProvider
                            .of<LoginBloc>(context)
                            .userDTOModel
                            .userId,
                        new WishListModel(
                            freelancerId: widget.freelancerId,
                            createdAt: DateTime.now().toString()))
                        .then((value) {
                      setState(() {});
                      widget.callback("wishlist");
                    });
                  },
                  color: Colors.black54);

            default:
              return Container();
          }
        });
  }
}
