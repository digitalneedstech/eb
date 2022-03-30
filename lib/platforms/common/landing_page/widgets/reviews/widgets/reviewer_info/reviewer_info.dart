import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/widgets/eb_circle_avatar/eb_circle_avatar.dart';

class ReviewerInfo extends StatelessWidget {
  final String id;
  final double rating;
  ReviewerInfo({required this.id,required this.rating});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: BlocProvider.of<LoginBloc>(context).getUserById(id),
        builder: (context, AsyncSnapshot<dynamic> data) {

          switch (data.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlineButton(
                      onPressed: () {},
                      child: Center(
                        child: Text("Loading User Info."),
                      ))
                ],
              );
            case ConnectionState.active:
            case ConnectionState.done:
              UserDTOModel reviewerModel;
              reviewerModel = UserDTOModel.fromJson2(data.data());

              return Row(
                children: [
                  EbCircleAvatarWidget(
                    profileImageUrl: reviewerModel.personalDetails.profilePic,
                  ),
                  SizedBox(width: 10.0,),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reviewerModel.personalDetails.displayName),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.star,color: Colors.orangeAccent,),
                          SizedBox(width: 10.0,),
                          Text(rating.toString())
                        ],
                      )
                    ],
                  ))
                ],
              );
          }
        });
  }
}
