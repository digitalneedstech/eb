
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/data/login_repository.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/post_event.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/post_state.dart';
import 'package:flutter_eb/platforms/common/posts/model/post.dart';
import 'package:flutter_eb/platforms/common/posts/repo/post_repository.dart';
import 'package:flutter_eb/shared/services/notification/repository/notification_repository.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;
  final NotificationRepository notificationRepository;
  final LoginRepository loginRepository;

  PostBloc(
      this.postRepository, this.loginRepository, this.notificationRepository)
      : super(PostLoadedState());

  @override
  Stream<PostState> mapEventToState(
      PostEvent event,
      ) async* {
    if (event is FetchPostsAndFilterMyJobsEvent) {
      yield LoadingPostState();
      List<dynamic> snapshot = await getAllPosts(event.jobTitle,
          event.dateFilter
          ,event.userId);
      List<PostModel> posts = [];
      if(snapshot.isNotEmpty && snapshot is List<DocumentSnapshot>){
        posts = snapshot.isEmpty ? []:snapshot
        .map((e) => PostModel.fromJson(e.data() as Map<String,dynamic>, e.id))
        .where((element) => element.postedBy != event.userId && element.isActive)
        .toList();
      }else if(snapshot.isNotEmpty && snapshot is List<QueryDocumentSnapshot>){

    posts = snapshot.isEmpty ? []:snapshot
        .map((e) => PostModel.fromJson(e.data() as Map<String,dynamic>, e.id))
        .where((element) => element.postedBy != event.userId && element.isActive)
        .toList();
    }
    yield FetchPostsState(posts: posts);
    }

    if (event is FetchAllMyPosts) {
    yield LoadingPostState();
    QuerySnapshot snapshot = await getPosts(event.userId);
    List<PostModel> posts = [];
    posts = snapshot.docs
        .map((e) => PostModel.fromJson(e.data() as Map<String,dynamic>, e.id))
        .where((element) => element.postedBy == event.userId)
        .toList();

    yield FetchPostsState(posts: posts);
    }

    if (event is CreatePostEvent) {
    yield LoadingPostState();
    createOrUpdateBid(event.postModel);
    yield CreatePostState();
    }

    if(event is ClosePostEvent){
    yield ClosePostInProgressState();
    try {
    closePost(event.postModel);
    yield ClosePostState(isPostClosed: true);
    }catch(e){
    yield ClosePostState(isPostClosed: false);
    }
    }
  }

  createOrUpdateBid(PostModel postModel) {
    this.postRepository.addPost(postModel);
  }

  Future<QuerySnapshot> getPosts(String userId) {
    return this.postRepository.getPosts(userId);
  }

  Future<List<dynamic>> getAllPosts(String search,int dateFilter,String userId) {
    return this.postRepository.getAllPosts(search,dateFilter,userId);
  }

  closePost(PostModel postModel){
    this.postRepository.closePost(postModel);
  }

  Future<bool> checkIfUserHasAppliedPost(String postId, String applicantId) {
    return this
        .postRepository
        .checkIfUserHasAppliedForPost(postId, applicantId);
  }

  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}
