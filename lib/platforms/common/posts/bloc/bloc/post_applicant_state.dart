import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/posts/model/post.dart';
import 'package:flutter_eb/platforms/common/posts/model/post_resource.dart';

@immutable
abstract class PostApplicantState extends Equatable {}


class PostApplicantLoadedState extends PostApplicantState {
  @override
  List<Object> get props => [];
}

class FetchPostsApplicantState extends PostApplicantState {
  List<UserDTOModel> applicants;
  FetchPostsApplicantState({required this.applicants});
  @override
  List<Object> get props => [];
}

class LoadingPostApplicantState extends PostApplicantState {
  @override
  List<Object> get props => [];
}

class CheckIfPostAppliedState extends PostApplicantState {
  final bool isApplied;
  CheckIfPostAppliedState({required this.isApplied});
  @override
  List<Object> get props => [];
}

class ApplyPostState extends PostApplicantState {
  @override
  List<Object> get props => [];
}

class LoadingPostApplyState extends PostApplicantState {
  @override
  List<Object> get props => [];
}
