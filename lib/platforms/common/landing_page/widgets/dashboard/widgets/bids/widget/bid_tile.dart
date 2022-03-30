import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/bid_detail_freelancer_view/bid_detail_freelancer.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/bid_detail_user_view/bid_detail.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/bids_bloc/bids_update_bloc/bids_update_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/bids_bloc/bids_update_bloc/bids_update_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/bids_bloc/bids_update_bloc/bids_update_state.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/services/router/routers.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import '../../../mixins/update_status_text_color.dart';
class BidTile extends StatelessWidget with UpdateStatusText{
  final bool isFreelancer;
  final BidModel bidModel;

  final Function callback;
  BidTile(
      {required this.callback,
      required this.isFreelancer,
      required this.bidModel});
  @override
  Widget build(BuildContext context) {
    String status = "Waiting For Approval";

    Color statusColor = Color(0xFFFFEFC5);
    Color statusTextColor = Color(0xFFC18B09);
    if (bidModel.status == "pending")
      status = "Waiting For Approval";
    else if (bidModel.status=="accepted") {
      status = "Accepted";
      statusColor = Color(0xFF1DC39A);
      statusTextColor = Colors.white;
    } else if (bidModel.status=="rejected") {
      status = "Rejected";
      statusColor = Color(0xFFFFDBD9);
      statusTextColor = Color(0xFFF94646);
    };
    return BlocListener<BidsDashboardUpdateBloc,
    BidsDashboardUpdateState>(listener: (context, state) {
      if (state is UpdateBidState) {
        callback(state.isUpdated);
      }
    },
      child: InkWell(
        onTap: () {
          //TOOD- Add new parameter in Biddetail call for freelancer and update bidId parameter to BidDetailFreelancer
          if(kIsWeb){
            isFreelancer ?
            Navigator.pushNamed(context, "bidDetail/"+bidModel.id+"/"+bidModel.userId):
            Navigator.pushNamed(context, "bid/"+bidModel.id+"/"+bidModel.freelancerId);

          }
          else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                  isFreelancer
                      ? BidDetailFreelancerPage(
                    freelancerId: bidModel.freelancerId,
                      bidId: bidModel.id, userIdOfBidder: bidModel.userId)
                      : BidDetailPage(
                      freelancerId: bidModel.freelancerId, bidId: bidModel.id)),
            );
          }
        },
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, blurRadius: 5.0, spreadRadius: 2.0)
                ]),
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                getUserDTOModelObject(context).personalDetails.type == Constants.CUSTOMER
                    ? Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text("Resource Name"),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              bidModel.clientName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          bidModel.status=="pending"?PopupMenuButton<String>(
                            onSelected: (val) {
                              switch (val) {
                                case "Delete":
                                  BlocProvider.of<BidsDashboardUpdateBloc>(
                                          context)
                                      .add(UpdateBidEvent(
                                          userId: bidModel.userId,
                                          freelancerId: bidModel.freelancerId,
                                          bidId: bidModel.id,
                                          type: "delete"));
                                  break;
                                case "Accept":
                                  BlocProvider.of<BidsDashboardUpdateBloc>(
                                          context)
                                      .add(UpdateBidEvent(
                                          userId: bidModel.userId,
                                          freelancerId: bidModel.freelancerId,
                                          bidId: bidModel.id,
                                          type: "accept"));
                                  break;
                                case "Reject":
                                  BlocProvider.of<BidsDashboardUpdateBloc>(
                                          context)
                                      .add(UpdateBidEvent(
                                          userId: bidModel.userId,
                                          freelancerId: bidModel.freelancerId,
                                          bidId: bidModel.id,
                                          type: "reject"));
                                  break;
                                default:
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => isFreelancer
                                              ? BidDetailFreelancerPage(
                                            freelancerId: bidModel.freelancerId,
                                                  bidId: bidModel.id,
                                                  userIdOfBidder: bidModel.userId)
                                              : BidDetailPage(
                                                  freelancerId:
                                                      bidModel.freelancerId,
                                                  bidId: bidModel.id)));
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return {'Accept', 'Reject', 'Edit', 'Delete'}
                                  .map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList();
                            },
                          ):Container()
                        ],
                      )
                    : Container(),
                (getUserDTOModelObject(context).userType ==
                                Constants.ORAGNIZATION) ||
                        (getUserDTOModelObject(context).userType ==
                                Constants.INDIVIDUAL &&
                            isFreelancer)
                    ? Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text("Client Name"),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              bidModel.profileName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          bidModel.status=="pending" &&
                              bidModel.freelancerId==BlocProvider.of<LoginBloc>(context).userDTOModel.userId?PopupMenuButton<String>(
                            onSelected: (val) {
                              switch (val) {
                                case "Delete":
                                  BlocProvider.of<BidsDashboardUpdateBloc>(
                                      context)
                                      .add(UpdateBidEvent(
                                      userId: bidModel.userId,
                                      freelancerId: bidModel.freelancerId,
                                      bidId: bidModel.id,
                                      type: "delete"));
                                  break;
                                case "Accept":
                                  BlocProvider.of<BidsDashboardUpdateBloc>(
                                      context)
                                      .add(UpdateBidEvent(
                                      userId: bidModel.userId,
                                      freelancerId: bidModel.freelancerId,
                                      bidId: bidModel.id,
                                      type: "accept"));
                                  break;
                                case "Reject":
                                  BlocProvider.of<BidsDashboardUpdateBloc>(
                                      context)
                                      .add(UpdateBidEvent(
                                      userId: bidModel.userId,
                                      freelancerId: bidModel.freelancerId,
                                      bidId: bidModel.id,
                                      type: "reject"));
                                  break;
                                default:
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => isFreelancer
                                              ? BidDetailFreelancerPage(
                                            freelancerId: bidModel.freelancerId,
                                              bidId: bidModel.id,
                                              userIdOfBidder: bidModel.userId)
                                              : BidDetailPage(
                                              freelancerId:
                                              bidModel.freelancerId,
                                              bidId: bidModel.id)));
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return {'Accept', 'Reject', 'Edit', 'Delete'}
                                  .map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList();
                            },
                          ):Container()
                        ],
                      )
                    : Container(),
                (getUserDTOModelObject(context).userType ==
                            Constants.INDIVIDUAL &&
                        !isFreelancer)
                    ? Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text("Freelancer Name"),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              bidModel.clientName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          bidModel.status=="pending"?PopupMenuButton<String>(
                            onSelected: (val) {
                              switch (val) {
                                case "Delete":
                                  BlocProvider.of<BidsDashboardUpdateBloc>(
                                      context)
                                      .add(UpdateBidEvent(
                                      userId: bidModel.userId,
                                      freelancerId: bidModel.freelancerId,
                                      bidId: bidModel.id,
                                      type: "delete"));
                                  break;
                                case "Accept":
                                  BlocProvider.of<BidsDashboardUpdateBloc>(
                                      context)
                                      .add(UpdateBidEvent(
                                      userId: bidModel.userId,
                                      freelancerId: bidModel.freelancerId,
                                      bidId: bidModel.id,
                                      type: "accept"));
                                  break;
                                case "Reject":
                                  BlocProvider.of<BidsDashboardUpdateBloc>(
                                      context)
                                      .add(UpdateBidEvent(
                                      userId: bidModel.userId,
                                      freelancerId: bidModel.freelancerId,
                                      bidId: bidModel.id,
                                      type: "reject"));
                                  break;
                                default:
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => isFreelancer
                                              ? BidDetailFreelancerPage(
                                              bidId: bidModel.id,
                                              freelancerId: bidModel.freelancerId,
                                              userIdOfBidder: bidModel.userId)
                                              : BidDetailPage(
                                              freelancerId:
                                              bidModel.freelancerId,
                                              bidId: bidModel.id)));
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return {'Accept', 'Reject', 'Edit', 'Delete'}
                                  .map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList();
                            },
                          ):Container()
                        ],
                      )
                    : Container(),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text("Current Rate"),
                    ),
                    Expanded(
                        flex: 3,
                        child: FutureBuilder<DocumentSnapshot>(
                            future: BlocProvider.of<LoginBloc>(context)
                                .loginRepository
                                .getUserByUid(bidModel.freelancerId),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return Text("Loading",
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left);
                                case ConnectionState.done:
                                case ConnectionState.active:
                                  UserDTOModel user = UserDTOModel.fromJson(
                                      snapshot.data!.data() as Map<String,dynamic>,
                                      snapshot.data!.id);
                                  return Text(
                                      "${user.rateDetails.hourlyRate.toString()}/hr",
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left);
                                default:
                                  return Text("Loading",
                                      style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left);
                              }
                            }))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text("Offered Bid"),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text("${bidModel.bid[bidModel.bid.length-1].amount}/hr",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text("Status", style: TextStyle(color: Colors.blue)),
                    ),
                    Expanded(
                        flex: 3,
                        child: BlocBuilder<BidsDashboardUpdateBloc,
                            BidsDashboardUpdateState>(builder: (context, state) {

                          if(state is UpdateBidInProgressState){
                            return Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: statusColor,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Center(
                                child: Text(
                                  "Updating",
                                  style: TextStyle(color: statusTextColor),
                                ),
                              ),
                            );
                          }
                          return Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Center(
                              child: Text(
                                status,
                                style: TextStyle(color: statusTextColor),
                              ),
                            ),
                          );
                        })),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
