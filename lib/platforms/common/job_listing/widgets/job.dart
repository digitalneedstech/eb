import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/job_listing/widgets/info_widget.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/bloc/post_applicant_event.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/bloc/post_applicant_state.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/bloc/post_applications_bloc.dart';
import 'package:flutter_eb/platforms/common/posts/model/post.dart';
import 'package:flutter_eb/shared/widgets/eb_outline_button_widget/eb_outline_button_widget.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';

class JobWidget extends StatelessWidget{
  PostModel postModel;
  Function callback;
  JobWidget({required this.postModel,required this.callback});
  @override
  Widget build(BuildContext context) {
    return BlocListener<PostApplicantBloc, PostApplicantState>(
      listener: (context, state) {
        if (state is ApplyPostState) {
          callback();

        }
      },      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(20.0),
        //padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 2.0,
                  blurRadius: 5.0
              )
            ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
              child: Text(postModel.title,style: TextStyle(fontSize: 18.0),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
              child: Text("${postModel.tenure} days | ${postModel.industry}",style: TextStyle(color: Colors.grey,fontSize: 12.0),),
            ),
            InfoWidget(postModel: postModel),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
              child: Row(
                  children: postModel.skills.map((e) => Container(margin:const EdgeInsets.symmetric(horizontal: 5.0),padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(color: Colors.grey.shade200,borderRadius: BorderRadius.circular(5.0)),child: Center(child: Text(e),),
                  )).toList()
              ),
            ),
            Divider(height: 2.0,color: Colors.grey,),
            FutureBuilder<bool>(builder: (context,AsyncSnapshot<bool> data){
              switch(data.connectionState){
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlineButton(
                          onPressed: () {},
                          child: Center(
                            child: Text("Loading"),
                          ))
                    ],
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: EbRaisedButtonWidget(buttonText:data.data! ? "Applied" : "Apply"
                          ,callback: data.data!
                            ? (){}
                            : () {
                          if (!data.data!) {
                            BlocProvider.of<PostApplicantBloc>(context).add(
                                ApplyPostEvent(
                                  userId: postModel.postedBy,
                                    applicantId:
                                    BlocProvider.of<LoginBloc>(context)
                                        .userDTOModel
                                        .userId,
                                    postId: postModel.id));
                          }
                        }),
                      )],
                    ),
                  );
                default:
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlineButton(
                            onPressed: () {},
                            child: Center(
                              child: Text("Loading"),
                            ))
                      ],
                    ),
                  );
              }
            },future: BlocProvider.of<PostApplicantBloc>(context).postRepository.checkIfUserHasAppliedForPost(postModel.id,
                BlocProvider.of<LoginBloc>(context).userDTOModel.userId),)
      /*      Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
              child: BlocListener<PostApplicantBloc, PostApplicantState>(
                listener: (context, state) {
                  if (state is ApplyPostState) {
                    callback();
                    *//*BlocProvider.of<PostApplicantBloc>(context).add(CheckIfPostIsApplied(
                        postId: postModel.id,
                        applicantId:
                        BlocProvider.of<LoginBloc>(context).userDTOModel.id));*//*
                  }
                },
                child: BlocBuilder<PostApplicantBloc, PostApplicantState>(
                    builder: (context, state) {
                      if (state is CheckIfPostAppliedState) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            EbOutlineButtonWidget(buttonText:state.isApplied ? "Applied" : "Apply"
                              ,callback: state.isApplied
                                  ? null
                                  : () {
                                if (!state.isApplied) {
                                  BlocProvider.of<PostApplicantBloc>(context).add(
                                      ApplyPostEvent(
                                          applicantId:
                                          BlocProvider.of<LoginBloc>(context)
                                              .userDTOModel
                                              .id,
                                          postId: postModel.id));
                                }
                              },),            ],
                        );
                      } else if(state is LoadingPostApplicantState) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlineButton(
                                onPressed: () {},
                                child: Center(
                                  child: Text("Loading"),
                                ))
                          ],
                        );
                      }
                      else{
                        return EbOutlineButtonWidget(callback:(){
                          BlocProvider.of<PostApplicantBloc>(context).add(
                              ApplyPostEvent(
                                  applicantId:
                                  BlocProvider.of<LoginBloc>(context)
                                      .userDTOModel
                                      .id,
                                  postId: postModel.id));
                        },buttonText: "Apply");
                      }
                    }),
              ),
            )*/
          ],
        ),
      ),
    );
  }
}