import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/widgets/eb_circle_avatar/eb_circle_avatar.dart';


class GroupFreelancerIndividualStatus extends StatelessWidget{
  UserDTOModel freelancerModel;
  final String status;
  final Function callback;
  GroupFreelancerIndividualStatus({required this.status,required this.freelancerModel,
    required this.callback});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              EbCircleAvatarWidget(profileImageUrl: freelancerModel.personalDetails.profilePic),
              SizedBox(width: 10.0,),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(freelancerModel.personalDetails.displayName),


                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (val){

                },
                itemBuilder: (BuildContext context) {
                  return {'1','2'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              )
            ],
          ),
          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text("\$ ${freelancerModel.rateDetails.hourlyRate} /hr",textAlign: TextAlign.right,),

              ),
              SizedBox(width: 10.0,),
              Expanded(
                child: Text(status[0].toUpperCase()+status.substring(1),textAlign: TextAlign.left,style: TextStyle(color: Colors.blue),),

              )

            ],
          )
        ],
      ),
    );
  }
}