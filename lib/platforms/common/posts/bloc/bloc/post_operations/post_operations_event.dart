
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/posts/model/post.dart';

class PostOperationsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class DeletePostEvent extends PostOperationsEvent{
  String postId;
  DeletePostEvent({required this.postId});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}