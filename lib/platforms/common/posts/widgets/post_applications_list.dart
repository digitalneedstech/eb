import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/listing_page_detail.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/bloc/post_applicant_event.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/bloc/post_applicant_state.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/bloc/post_applications_bloc.dart';
import 'package:flutter_eb/platforms/common/posts/model/post_resource.dart';
import 'package:flutter_eb/shared/widgets/eb_circle_avatar/eb_circle_avatar.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';

class PostApplicantsList extends StatelessWidget{
  final String postId;
  PostApplicantsList({required this.postId});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PostApplicantBloc>(context).add(FetchApplicants(postId: postId));
    return BlocBuilder<PostApplicantBloc,PostApplicantState>(
      builder: (context,state){
        if(state is FetchPostsApplicantState){
          if(state.applicants.isEmpty){
            return NoDataFound(message: "No Applicants Found",);
          }
          else{
            List<UserDTOModel> list=state.applicants;
            return ListView.builder(itemCount:list.length,shrinkWrap:true,itemBuilder: (context,int index){
              return InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ListingPageDetail(
                              userDTOModel: list[index],
                            )),
                  );
                },
                child: Container(
                  //height: MediaQuery.of(context).size.height*0.1,
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),

                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      EbCircleAvatarWidget(profileImageUrl: list[index].personalDetails.profilePic),
                      SizedBox(width: 10.0,),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(list[index].personalDetails.displayName,style: TextStyle(color: Colors.blue,fontSize: 12.0),),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                width: 10.0,
                                height: 10.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle
                                ),
                              ),
                              Text(list[index].personalDetails.country==""?Constants.UNNAMED:list[index].personalDetails.country ,style: TextStyle(color: Colors.grey,fontSize: 12.0),),
                            ],
                          ),
                          Text(list[index].profileOverview.profileTitle==""?Constants.UNNAMED:list[index].profileOverview.profileTitle ,overflow:TextOverflow.ellipsis,style: TextStyle(color: Colors.grey,fontSize: 12.0),),
                          SizedBox(height: 10.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text("\$ ${list[index].rateDetails.hourlyRate} /hr",textAlign: TextAlign.left,),

                              ),

                            ],
                          )
                        ],
                      )),

                      SizedBox(width: 10.0,),
                      //Expanded(child: Text(list[index].,style: TextStyle(color: Colors.grey,fontSize: 16.0),))
                    ],),
                ),
              );
            });
          }

        }
        return Center(child: Text("Loading"),);
      },
    );
  }
}