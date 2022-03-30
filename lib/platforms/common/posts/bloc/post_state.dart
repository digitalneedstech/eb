import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/posts/model/post.dart';

@immutable
abstract class PostState extends Equatable {}


class PostLoadedState extends PostState {
  @override
  List<Object> get props => [];
}

class FetchPostsState extends PostState {
  List<PostModel> posts;
  FetchPostsState({required this.posts});
  @override
  List<Object> get props => [];
}

class CreatePostState extends PostState {
  CreatePostState();
  @override
  List<Object> get props => [];
}

class LoadingPostState extends PostState {
  @override
  List<Object> get props => [];
}

class ClosePostInProgressState extends PostState {
  @override
  List<Object> get props => [];
}

class ClosePostState extends PostState{
  final bool isPostClosed;
  ClosePostState({required this.isPostClosed});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

