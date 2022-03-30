import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/post_bloc.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/post_event.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/post_state.dart';
import 'package:flutter_eb/platforms/common/posts/widgets/add_post_button.dart';
import 'package:flutter_eb/platforms/common/posts/widgets/post_tile/post_tile.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';

class PostsPage extends StatelessWidget{
  GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey();
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PostBloc>(context).add(FetchAllMyPosts(userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId));
    return BlocListener<PostBloc,PostState>(
      listener: (context,state){
        if(state is CreatePostState){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Post Added"),backgroundColor: Colors.green,));
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Posts"),

        ),
        body:SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  child: AddPostButton()),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("List Of Posts",style: TextStyle(color: Colors.black,fontSize: 18.0),),
                  ],
                ),
              ),
              Divider(color: Colors.grey,height: 2.0,),
              BlocBuilder<PostBloc,PostState>(
                builder: (context,state){
                  if(state is FetchPostsState){
                    if(state.posts.isEmpty){
                      return NoDataFound();
                    }
                    else{
                      return ListView.builder(padding:const EdgeInsets.all(10.0),shrinkWrap:true,itemCount:state.posts.length,itemBuilder: (context,int index){
                        return PostTileWidget(callback: (bool isDeleted){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isDeleted ?"Post Is Deleted. Refreshing List.":"There was an error while deleting the post."),backgroundColor:
                            isDeleted ? Colors.green :Colors.red,));
                          BlocProvider.of<PostBloc>(context).add(FetchPostsAndFilterMyJobsEvent(
                            dateFilter: 3,jobTitle: "",
                              userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId));
                        },postModel: state.posts[index],);
                      });
                    }
                  }
                  return Center(child: Text("Loading"));
                },
              )
            ],
          ),
        ) ,
      ),
    );
  }
}