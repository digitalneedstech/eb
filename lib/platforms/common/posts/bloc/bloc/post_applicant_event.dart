
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/posts/model/post.dart';

class PostApplicantEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class FetchApplicants extends PostApplicantEvent{
  final String postId;
  FetchApplicants({required this.postId});
}


class CheckIfPostIsApplied extends PostApplicantEvent{
  final String postId,applicantId;
  CheckIfPostIsApplied({required this.postId,required this.applicantId});
}

class ApplyPostEvent extends PostApplicantEvent{
  final String postId,applicantId,userId;

  ApplyPostEvent({required this.postId,required this.applicantId,required this.userId});
}