import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/posts/model/post.dart';

@immutable
abstract class PostOperationsState extends Equatable {}

class PostOperationsLoadedState extends PostOperationsState {
  @override
  List<Object> get props => [];
}

class DeletePostOperationsState extends PostOperationsState {
  final bool isDeleted;
  DeletePostOperationsState({required this.isDeleted});
  @override
  List<Object> get props => [];
}

class LoadingPostDeleteOperationsState extends PostOperationsState {
  @override
  List<Object> get props => [];
}
