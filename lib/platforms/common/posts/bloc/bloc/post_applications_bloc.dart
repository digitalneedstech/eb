import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/data/login_repository.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/bloc/post_applicant_event.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/bloc/post_applicant_state.dart';
import 'package:flutter_eb/platforms/common/posts/model/post.dart';
import 'package:flutter_eb/platforms/common/posts/model/post_resource.dart';
import 'package:flutter_eb/platforms/common/posts/repo/post_repository.dart';
import 'package:flutter_eb/shared/services/notification/model/notification_message.dart';
import 'package:flutter_eb/shared/services/notification/repository/notification_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
TODO- Update user model with required new model values instead of null
 */
class PostApplicantBloc extends Bloc<PostApplicantEvent, PostApplicantState> {
  final PostRepository postRepository;
  final LoginRepository loginRepository;
  final NotificationRepository notificationRepository;

  PostApplicantBloc(this.postRepository,this.loginRepository,this.notificationRepository) : super(PostApplicantLoadedState());

  @override
  Stream<PostApplicantState> mapEventToState(
      PostApplicantEvent event,
      ) async* {
    if(event is FetchApplicants){
      yield LoadingPostApplicantState();
      List<UserDTOModel> snapshot=await getApplicantsForAPost(event.postId);
      yield FetchPostsApplicantState(applicants: snapshot);
    }

    if(event is CheckIfPostIsApplied){
      yield LoadingPostApplicantState();
      bool isApplied=await checkIfUserHasAppliedPost(event.postId, event.applicantId);
      yield CheckIfPostAppliedState(isApplied:isApplied);
    }

    if(event is ApplyPostEvent){
      yield LoadingPostApplyState();
      await applyPost(event.postId, event.applicantId,event.userId);
      yield ApplyPostState();
    }
  }

  Future<List<UserDTOModel>> getApplicantsForAPost(String postId)async{
    List<UserDTOModel> applicants=[];
    List<String> users=await this.postRepository.getApplicantsForAPost(postId);
    for(int i=0;i<users.length;i++){
      DocumentSnapshot snapshot=await loginRepository.getUserByUid(users[i]);
      UserDTOModel userDTOModel=UserDTOModel.fromJson(snapshot.data() as Map<String,dynamic>, snapshot.id);
      applicants.add(userDTOModel);
    }
    return applicants;
  }

  Future<bool> checkIfUserHasAppliedPost(String postId,String applicantId){
    return this.postRepository.checkIfUserHasAppliedForPost(postId, applicantId);
  }

  Future<void> applyPost(String postId,String applicantId,String userId)async{
    this.postRepository.applyPost(postId, applicantId);
    DocumentSnapshot snapshot=await this.loginRepository.getUserByUid(applicantId);
    UserDTOModel userDTOModel=UserDTOModel.fromJson(snapshot.data() as Map<String,dynamic>, snapshot.id);
    NotificationMessageNotificationModel notificationMessage=NotificationMessageNotificationModel(
        "notification",
        NotificationMessageNotificationPayloadModel(notification: NotificationMessageNotificationPayload(
            "Job Notification",
            "${userDTOModel.personalDetails.displayName} Has Applied For Job"
        ),data: new NotificationMessageDataPayload(
            postId,
            userId,
            "job","user",
            userDTOModel.userId
        )),

    );
    NotificationMessage mailNotificationMessage = new NotificationMessage(
        type: "mail",
        payload: NotificationMessageEmailPayload(
            userDTOModel.personalDetails.email,
            "Job Applied",
            "${userDTOModel.personalDetails.displayName} Has Applied For Job"
        )
    );
    await this.notificationRepository.sendNotification(notificationMessage);
    await this.notificationRepository.sendNotification(mailNotificationMessage);
  }

  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}
