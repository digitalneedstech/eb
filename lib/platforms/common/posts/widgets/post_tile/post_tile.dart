import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/bloc/post_operations/post_operations_bloc.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/bloc/post_operations/post_operations_event.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/bloc/post_operations/post_operations_state.dart';
import 'package:flutter_eb/platforms/common/posts/model/post.dart';
import 'package:flutter_eb/platforms/common/posts/widgets/posts_detail.dart';

class PostTileWidget extends StatelessWidget{
  final PostModel postModel;
  final Function callback;
  PostTileWidget({required this.postModel,required this.callback});
  @override
  Widget build(BuildContext context) {
    return BlocListener<PostOperationsBloc,PostOperationsState>(
      listener: (context,state){
        if(state is DeletePostOperationsState){
          callback(state.isDeleted);
        }
      },
      child: BlocBuilder<PostOperationsBloc,PostOperationsState>(
        builder: (context,state){
          Widget trailingWidget=Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(postModel.isActive ? "Active":"Inactive",style: TextStyle(
                  color: postModel.isActive ? Colors.green:Colors.red
              ),),
              IconButton(icon: Icon(Icons.delete),
                  onPressed: (){
                    BlocProvider.of<PostOperationsBloc>(context).add(DeletePostEvent(postId: postModel.id));
                  }),
              SizedBox(width: 5.0,)
            ],mainAxisSize: MainAxisSize.min,);
          if(state is LoadingPostDeleteOperationsState){
            trailingWidget=Text("Deleting",style: TextStyle(color: Colors.red),);
          }
          return ListTile(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostDetailPage(postModel: postModel)),
              );
            },
            title: Text(postModel.title,style: TextStyle(color: Colors.black),),
            trailing: trailingWidget,
          );
        },
      ),
    );
  }
}