import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/wishlist/model/wishlist_model.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';

class WishListRepository {
  final userCollectionInstance = FirebaseFirestore.instance.collection("users");
  Future<void> addUserToWishList(String id, WishListModel wishListModel) {
    return this
        .userCollectionInstance
        .doc(id)
        .collection("wishlist")
        .doc(wishListModel.freelancerId)
        .set(wishListModel.toJson());
  }

  void removeUserToWishList(String id, WishListModel wishListModel) {
    this
        .userCollectionInstance
        .doc(id)
        .collection("wishlist")
        .doc(wishListModel.freelancerId)
        .delete();
  }

  Future<bool> checkIfUserIsInWhitelist(
      String freelancerId, String ownerId) async {
    DocumentSnapshot snapshot = await this
        .userCollectionInstance
        .doc(ownerId)
        .collection("wishlist")
        .doc(freelancerId)
        .get();
    return snapshot.exists ?true:false;
  }

  Future<QuerySnapshot> getWishListIds(String userId) async {
    QuerySnapshot snapshot = await this
        .userCollectionInstance
        .doc(userId)
        .collection("wishlist")
        .get();
    return snapshot;
  }
}
