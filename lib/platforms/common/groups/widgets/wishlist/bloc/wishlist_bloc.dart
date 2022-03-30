
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/wishlist/bloc/wishlist_event.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/wishlist/bloc/wishlist_state.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/wishlist/model/wishlist_model.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/wishlist/repo/wishlist_repository.dart';
import 'package:flutter_eb/platforms/common/login/data/login_repository.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';

class WishListBloc extends Bloc<WishlistEvent, WishListState> {
  final WishListRepository wishListRepository;
  final LoginRepository loginRepository;
  WishListBloc(this.wishListRepository,this.loginRepository) : super(WishListLoadedState());

  @override
  Stream<WishListState> mapEventToState(
      WishlistEvent event,
      ) async* {
    if(event is AddUserIdToWishListEvent){
      yield LoadingWishListState();
      addUserToGroup(event.userId,event.wishListModel);
      yield AddUserIdToWishListState();
    }

    if(event is RemoveUserIdToWishListEvent){
      yield LoadingWishListState();
      removeUserToGroup(event.userId,event.wishListModel);
      yield RemoveUserIdToWishListState();
    }

    if(event is CheckIfUserIsInWhitelistEvent){
      yield LoadingWishListState();
      bool check=await checkIfUserIsInWhiteList(event.ownerId, event.freelancerId);
      yield CheckIfUserIsInWhitelistState(isUserWhiteListed: check);
    }

    if(event is FetchWishListUsers){
      yield LoadingWishListState();
      List<UserDTOModel> check=await getWishListUsers(event.userId,event.userName);
      yield FetchWishListUsersState(wishListIds: check);
    }

  }

  void addUserToGroup(String userId, WishListModel wishListModel){
    this.wishListRepository.addUserToWishList(userId, wishListModel);
  }

  void removeUserToGroup(String userId, WishListModel wishListModel){
    this.wishListRepository.removeUserToWishList(userId, wishListModel);
  }

  Future<bool> checkIfUserIsInWhiteList(String ownerId,String freelancerId)async{
    return await this.wishListRepository.checkIfUserIsInWhitelist(freelancerId, ownerId);
  }

  Future<List<UserDTOModel>> getWishListUsers(String userId,String userName)async{
    QuerySnapshot snapshot=await this.wishListRepository.getWishListIds(userId);
    List<UserDTOModel> users=[];
    for(DocumentSnapshot userSnapshot in snapshot.docs){
      DocumentSnapshot userDocument=await this.loginRepository.getUserByUid(userSnapshot.id);
      users.add(UserDTOModel.fromJson(userDocument.data() as Map<String,dynamic>, userDocument.id));
    }
    return userName!=""?users.where((element) =>element.personalDetails.displayName==userName).toList():users;
  }


  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}
