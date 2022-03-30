import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/post_bloc.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/post_event.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/post_state.dart';
import 'package:flutter_eb/platforms/common/posts/model/post.dart';
import 'package:flutter_eb/platforms/common/posts/widgets/post_applications_list.dart';

class PostDetailPage extends StatelessWidget{
  PostModel postModel;
  PostDetailPage({required this.postModel});
  GlobalKey<ScaffoldState> _scaffoldKey=new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc,PostState>(
      listener: (context,state){
        if(state is ClosePostState){
          if(state.isPostClosed)
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Post is Closed. Thanks"),backgroundColor: Colors.green,));
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text("Job Details"),),
        backgroundColor: Colors.grey.shade200,
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(postModel.title,style: TextStyle(fontSize: 18.0),),
                  SizedBox(height: 5.0,),
                  Text("${postModel.tenure} days | ${postModel.industry}",style: TextStyle(color: Colors.grey,fontSize: 16.0),),
                  SizedBox(height: 5.0,),
                  Container(
                    height: MediaQuery.of(context).size.height*0.1,
                    child: Text(postModel.info,style: TextStyle(color: Colors.grey,fontSize: 14.0),overflow: TextOverflow.ellipsis,),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BlocBuilder<PostBloc,PostState>(
                      builder: (context,state){
                        if(state is ClosePostInProgressState){
                          return InkWell(onTap:null,child: Text("Closing",style: TextStyle(color: Colors.blue),));
                        }
                        if(state is ClosePostState){
                          return InkWell(onTap:null,child:Text(state.isPostClosed ? "Closed":"Error In Closing",style: TextStyle(color: Colors.blue),));
                        }
                        return InkWell(onTap:postModel.isActive ?(){
                          postModel.isActive=false;
                        BlocProvider.of<PostBloc>(context).add(ClosePostEvent(postModel: postModel));

                        }:null,child: Text(!postModel.isActive ?"Closed":"Close The Requirement",style:TextStyle(color: Colors.blue),));
                      })
                    ],
                  )
                ],
              ),
            ),
            PostApplicantsList(postId: postModel.id)
          ],
        ),
      ),
    );
  }
}