import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/rate.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/shared/bidder_info.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_state.dart';
import 'package:flutter_eb/shared/constants/routes.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';

class BidUserInfoWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: MediaQuery.of(context).size.height * 0.3,
      margin: getScreenWidth(context)>800 ?EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width*0.1,
      ):const EdgeInsets.all(20.0),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
        // border: Border.all(color: Colors.grey.shade500,width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Bid Offered To:"),
          SizedBox(
            height: 20.0,
          ),
          BidderInfo(),
          SizedBox(
            height: 20.0,
          ),
          Text(
            "Current Rate",
            style: TextStyle(color: Colors.grey.shade500),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, profileState) {
                  if (profileState is LoadingState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("Loading")],
                      ),
                    );
                  } else if (profileState is FetchUserProfileState) {
                    return RichText(
                        text: TextSpan(
                            text:
                            "\$ ${profileState.userDTOModel.rateDetails.hourlyRate}",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: " /hr",
                                  style: TextStyle(
                                      color: Colors.grey.shade500))
                            ]));
                  }
                  return Container();
                })
              ],
            ),
          )
        ],
      ),
    );
  }
}
