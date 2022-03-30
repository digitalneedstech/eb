import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/data/login_repository.dart';
import 'package:flutter_eb/platforms/common/login/dto/feedback/user_feedback.dart';
import 'package:flutter_eb/platforms/common/user_feedback/bloc/user_feedback_event.dart';
import 'package:flutter_eb/platforms/common/user_feedback/bloc/user_feedback_state.dart';
/*
TODO- Update user model with required new model values instead of null
 */
class UserFeedbackBloc extends Bloc<UserFeedbackEvent, UserFeedbackState> {
  final LoginRepository loginRepository;
  UserFeedbackBloc(this.loginRepository) : super(UserFeedbackLoadedState());


  @override
  Stream<UserFeedbackState> mapEventToState(UserFeedbackEvent event) async* {
    if (event is AddUserFeedbackEvent) {
      yield FeedbackLoadingState();
      try {
        await loginRepository.addFeedback(
            event.userFeedbackModel, event.userId);
        yield AddFeedbackState();
      }catch(e){
        yield AddFeedbackExceptionState(message: "There was server error");
      }

    }

    if (event is FetchFeedbacksEvent) {
      yield FeedbackLoadingState();
      List<UserFeedbackModel> userFeedbacks=[];
      try {
        QuerySnapshot snapshot=await loginRepository.getFeedbacks(
            event.userId);
        for(DocumentSnapshot documentSnapshot in snapshot.docs){
          userFeedbacks.add(UserFeedbackModel.fromMap(documentSnapshot.data() as Map<String,dynamic>));
        }
        yield FetchFeedbacksState(feedbacks: snapshot.docs.isEmpty ?[]:userFeedbacks);
      }catch(e){
        yield AddFeedbackExceptionState(message: "There was server error");
      }

    }
  }

  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }

}