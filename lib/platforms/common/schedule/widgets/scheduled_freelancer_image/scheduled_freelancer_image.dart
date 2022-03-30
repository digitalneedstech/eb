import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/listing_page_detail.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_event.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_state.dart';
import 'package:flutter_eb/shared/widgets/eb_circle_avatar/eb_circle_avatar.dart';

class ScheduledFreelancerImageWidget extends StatelessWidget{
  final String userId;
  ScheduledFreelancerImageWidget({required this.userId});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LoginBloc>(context).add(GetUserByIdEvent(userId:userId));
    return BlocBuilder<LoginBloc,LoginState>(
      builder: (context,state){
        if(state is GetUserByIdState){
          return InkWell(
            onTap: (){

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    ListingPageDetail(
                      userDTOModel: state.userDTOModel,
                    )),
              );            },
            child: EbCircleAvatarWidget(
              profileImageUrl: state.userDTOModel.personalDetails.profilePic,
            ),
          );
        }
        return EbCircleAvatarWidget(

        );
      },
    );
  }
}