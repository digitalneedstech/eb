
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_state.dart';
import 'package:flutter_eb/shared/widgets/eb_circle_avatar/eb_circle_avatar.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
class SchedulerInfo extends StatelessWidget {
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
            return Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
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
                    Text(profileState.userDTOModel.profileOverview.profileTitle)
                  ])
                ]);
          }
          else
            return Container();
        });
  }
}
