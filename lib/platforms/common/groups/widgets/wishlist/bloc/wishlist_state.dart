import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
@immutable
abstract class WishListState extends Equatable {}
class WishListLoadedState extends WishListState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddUserIdToWishListState extends WishListState{
  AddUserIdToWishListState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class RemoveUserIdToWishListState extends WishListState{
  RemoveUserIdToWishListState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CheckIfUserIsInWhitelistState extends WishListState {
  final bool isUserWhiteListed;
  CheckIfUserIsInWhitelistState({required this.isUserWhiteListed});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadingWishListState extends WishListState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchWishListUsersState extends WishListState{
  final List<UserDTOModel> wishListIds;
  FetchWishListUsersState({this.wishListIds=const <UserDTOModel>[]});

  @override
  // TODO: implement props
  List<Object> get props => [];
}