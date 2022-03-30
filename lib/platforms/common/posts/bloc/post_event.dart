
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/posts/model/post.dart';

class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPostsAndFilterMyJobsEvent extends PostEvent{
  String userId;
  String jobTitle;
  final int dateFilter;
  FetchPostsAndFilterMyJobsEvent({required this.userId,required this.jobTitle,required this.dateFilter});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}

class FetchAllMyPosts extends PostEvent{
  String userId;
  FetchAllMyPosts({required this.userId});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class CreatePostEvent extends PostEvent{
  PostModel postModel;
  CreatePostEvent({required this.postModel});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}

class ClosePostEvent extends PostEvent{
  final PostModel postModel;
  ClosePostEvent({required this.postModel});
  @override
  // TODO: implement props
  List<Object> get props => [];
}
