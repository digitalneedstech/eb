import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/utils.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/bids_bloc/bids_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/bids_bloc/bids_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/bids_bloc/bids_state.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/bids/widget/bid_tile.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/filter/filter.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/search_associate/search_associate.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/shared/widgets/animate_list/animate_list.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';
import '../../mixins/update_status_text_color.dart';

class BidsMade extends StatelessWidget with UpdateStatusText {
  bool isFreelancer;
  final Function callback;
  BidsMade({this.isFreelancer = false,required this.callback});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LandingDashboardBloc>(context)
        .selectedFiter=0;
    _getBids(context);
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
                      _getBids(context);
                    },
                  ),
                ),
                FilterPage(
                  callback: () {
                    _getBids(context);
                  },
                ),
              ],
            )),

          Expanded(
            child: BlocBuilder<BidsDashboardBloc, BidsDashboardState>(
              builder: (context, state) {
                if (state is FetchBidsMadeState) {
                  if (state.bidModels.isEmpty) return NoDataFound();
                  List<BidModel> bids=[];
                  bids = isFreelancer
                        ? List.from(state.bidModels.where((e) =>
                    !e.isLongTerm &&
                        e.userId !=
                            BlocProvider
                                .of<LoginBloc>(context)
                                .userDTOModel
                                .userId))
                        : List.from(state.bidModels.where((e) =>
                    !e.isLongTerm &&
                        e.userId ==
                            BlocProvider
                                .of<LoginBloc>(context)
                                .userDTOModel
                                .userId));
                  if (bids.isEmpty) return NoDataFound();
                  return AnimationLimiter(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: bids.length,
                      padding: const EdgeInsets.all(10.0),
                      itemBuilder: (context, int index) {
                        BidModel model = bids[index];
                        if (isFreelancer)
                          BlocProvider.of<ProfileBloc>(context)
                              .add(FetchUserProfileEvent(userId: model.userId));
                        updateStatusText(model.status);
                        return AnimateList(
                          index: index,
                          widget: BidTile(
                            bidModel: bids[index],
                            isFreelancer: isFreelancer,
                            callback: (bool isUpdated){
                              if(isUpdated)
                                _getBids(context);
                              else
                                callback(false,"The Bid Could not be updated");
                            },
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

  void _getBids(BuildContext context) {
    BlocProvider.of<BidsDashboardBloc>(context).add(FetchBidsMadeEvent(
      userId: BlocProvider.of<LoginBloc>(context)
          .userDTOModel.userId,
      userType: BlocProvider.of<LoginBloc>(context)
          .userDTOModel.personalDetails.type,
      associateName: BlocProvider.of<LandingDashboardBloc>(context)
          .associateNameController
          .text,
      fieldTypeToBeSearched: getSearchType(isFreelancer, context),
      dateFilter:
      BlocProvider.of<LandingDashboardBloc>(context)
          .selectedFiter));
  }
}
