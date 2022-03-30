import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/utils.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/bid_detail_freelancer_view/bid_detail_freelancer.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/bid_detail_user_view/bid_detail.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/contract_bids_bloc/contract_bids.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/contract_bids_bloc/contract_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/contract_bids_bloc/contract_state.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/filter/filter.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/search_associate/search_associate.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/animate_list/animate_list.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../mixins/update_status_text_color.dart';
class ContractBidsMade extends StatelessWidget with UpdateStatusText {
  bool isFreelancer;
  ContractBidsMade({this.isFreelancer = false});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LandingDashboardBloc>(context)
        .selectedFiter=0;
    BlocProvider.of<ContractsBidsBloc>(context).add(FetchContractBidsMadeEvent(
        userId: BlocProvider.of<LoginBloc>(context)
            .userDTOModel.userId,
        userType: BlocProvider.of<LoginBloc>(context)
            .userProfileType,
        associateName: BlocProvider.of<LandingDashboardBloc>(context)
            .associateNameController
            .text,
        fieldTypeToBeSearched: isFreelancer ? "Client" : "Freelancer",dateFilter: 3));
    return Column(
      children: [
        Container(
            margin: EdgeInsets.all(10),
            child:Row(
              children: [
                Expanded(
                  flex:3,
                  child: SearchAssociate(
                    fieldTypeToBeSearched: isFreelancer ? "Client" : "Freelancer",
                    callback: () {
                      BlocProvider.of<ContractsBidsBloc>(context).add(
                          FetchContractBidsMadeEvent(
                              userType: BlocProvider.of<LoginBloc>(context)
                                  .userDTOModel.personalDetails.type,
                              userId: BlocProvider.of<LoginBloc>(context)
                                  .userDTOModel.userId,
                              associateName:
                              BlocProvider.of<LandingDashboardBloc>(context)
                                  .associateNameController
                                  .text,
                              fieldTypeToBeSearched:
                              getSearchType(isFreelancer, context),
                              dateFilter:
                              BlocProvider.of<LandingDashboardBloc>(context)
                                  .selectedFiter));
                    },
                  ),
                ),
                FilterPage(
                  callback: () {
                    BlocProvider.of<ContractsBidsBloc>(context).add(
                        FetchContractBidsMadeEvent(
                            userType: BlocProvider.of<LoginBloc>(context)
                                .userDTOModel.personalDetails.type,
                            userId: BlocProvider.of<LoginBloc>(context)
                                .userDTOModel.userId,
                            associateName:
                            BlocProvider.of<LandingDashboardBloc>(context)
                                .associateNameController
                                .text,
                            fieldTypeToBeSearched:
                            getSearchType(isFreelancer, context)));
                  },
                ),
              ],
            )),
        Expanded(
          child: BlocBuilder<ContractsBidsBloc, ContractsBidsState>(
            builder: (context, state) {
              if (state is ContractBidsMadeState) {
                if (state.bidModels.isEmpty) return NoDataFound();
                List<BidModel> bids=[];
                bids = isFreelancer
                      ? List.from(state.bidModels.where((e) =>
                  e.isLongTerm &&
                      e.userId !=
                          BlocProvider.of<LoginBloc>(context)
                              .userDTOModel
                              .userId))
                      : List.from(state.bidModels.where((e) =>
                  e.isLongTerm &&
                      e.userId ==
                          BlocProvider.of<LoginBloc>(context)
                              .userDTOModel
                              .userId));

                if (bids.isEmpty) return NoDataFound();
                return AnimationLimiter(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: bids.length,
                    padding: const EdgeInsets.all(10.0),
                    itemBuilder: (context, int index) {
                      BidModel bidModel = bids[index];
                      if (isFreelancer)
                        BlocProvider.of<ProfileBloc>(context)
                            .add(FetchUserProfileEvent(userId: bidModel.userId));
                      updateStatusText(bidModel.status);
                      return AnimateList(
                        index: index,
                        widget: InkWell(
                          onTap: () {
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
                                  getUserDTOModelObject(context).companyId !=
                                      null &&
                                      getUserDTOModelObject(context).userType ==
                                          Constants.ORAGNIZATION
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  )
                                      : Container(),
                                  (getUserDTOModelObject(context)
                                          .userType ==
                                          Constants.ORAGNIZATION) ||
                                      (getUserDTOModelObject(context)
                                          .userType ==
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  )
                                      : Container(),
                                  (getUserDTOModelObject(context)
                                      .userType ==
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
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
                                          future: BlocProvider.of<LoginBloc>(context).loginRepository.getUserByUid(bids[index].freelancerId),
                                          builder: (context,AsyncSnapshot<DocumentSnapshot> snapshot){
                                            switch(snapshot.connectionState){
                                              case ConnectionState.none:
                                              case ConnectionState.waiting:
                                                return Text("Loading",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold),
                                                    textAlign: TextAlign.left);
                                              case ConnectionState.done:
                                              case ConnectionState.active:
                                                UserDTOModel user=UserDTOModel.fromJson(
                                                    snapshot.data!.data() as Map<String,dynamic>,snapshot.data!.id);
                                                return Text("${user.rateDetails.hourlyRate.toString()}/hr",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold),
                                                    textAlign: TextAlign.left);
                                            }
                                          }
                                      ))
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
                                        child: Text(
                                            bidModel.bid[bidModel.bid.length-1].amount.toString()+"/hr",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left),
                                      )
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text("Hours Needed"),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                            bidModel.bid[bidModel.bid.length-1].hoursNeeded.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left),
                                      )
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text("Valid Till"),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                            bidModel.bid[bidModel.bid.length-1]
                                                .validTill.split("T")[0].toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Status",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                                color: statusColor,
                                                borderRadius:
                                                    BorderRadius.circular(10.0)),
                                            child: Center(
                                              child: Text(
                                                status,
                                                style: TextStyle(
                                                    color: statusTextColor),
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      );
                    },
                  ),
                );
              }
              return Center(
                child: Text("Loading"),
              );
            },
          ),
        ),
      ],
    );
  }
}
