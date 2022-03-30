
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_state.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/listing_page_detail.dart';
import 'package:flutter_eb/shared/widgets/eb_circle_avatar/eb_circle_avatar.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
class BidderInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          if (profileState is LoadingState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Loading")],
              ),
            );
          } else if (profileState is FetchUserProfileState) {
            return InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      ListingPageDetail(
                        userDTOModel: profileState.userDTOModel,
                      )),
                );
              },
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    EbCircleAvatarWidget(profileImageUrl: profileState.userDTOModel.personalDetails.profilePic,),
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        profileState.userDTOModel.personalDetails.displayName,
                        style: TextStyle(
                          color: Color(0xFF1787E0),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(profileState.userDTOModel.profileOverview.profileTitle==""?
                      Constants.UNTITLED:profileState.userDTOModel.profileOverview.profileTitle)
                    ])
                  ]),
            );
          }
          return Container();
        });
  }
}
