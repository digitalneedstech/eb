import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_freelancer_model.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/wishlist/model/wishlist_model.dart';

class WishlistEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddUserIdToWishListEvent extends WishlistEvent{
  final String userId;
  final WishListModel wishListModel;
  AddUserIdToWishListEvent({required this.userId,required this.wishListModel});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class RemoveUserIdToWishListEvent extends WishlistEvent{
  final String userId;
  final WishListModel wishListModel;
  RemoveUserIdToWishListEvent({required this.userId,required this.wishListModel});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CheckIfUserIsInWhitelistEvent extends WishlistEvent{
  final String ownerId,freelancerId;
  CheckIfUserIsInWhitelistEvent({required this.ownerId,this.freelancerId=""});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchWishListUsers extends WishlistEvent{
  final String userId,userName;
  FetchWishListUsers({this.userId="",this.userName=""});
}