import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/job_listing/widgets/job.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/post_bloc.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/post_state.dart';
import 'package:flutter_eb/platforms/common/posts/model/post.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';

class JobListWidget extends StatelessWidget {
  Function callback;
  JobListWidget({required this.callback});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is FetchPostsState) {
          if (state.posts.isEmpty) {
            return NoDataFound();
          }
          else {
            return Container(
                margin: getScreenWidth(context)>800 ?EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width*0.05,
                    vertical: MediaQuery.of(context).size.height*0.05
                ):EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width*0.8,
              height: MediaQuery.of(context).size.height*0.8,
              child: ListView.builder(shrinkWrap:true,itemBuilder: (context, int index) {
                PostModel postModel = state.posts[index];
                return new JobWidget(callback: callback, postModel: postModel,);
              }, itemCount: state.posts.length,),
            );
          }
        }
        else if (state is LoadingPostState) {
          return Center(child: Text("Loading"),);
        }
        return Center(child: Text("Loading"),);
      },
    );
  }
}