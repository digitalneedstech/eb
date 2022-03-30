import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/reviews/widgets/feedback_widget/feedback_widget.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/reviews/widgets/reviewer_info/reviewer_info.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/feedback/user_feedback.dart';
import 'package:flutter_eb/platforms/common/user_feedback/bloc/user_feedback_bloc.dart';
import 'package:flutter_eb/platforms/common/user_feedback/bloc/user_feedback_event.dart';
import 'package:flutter_eb/platforms/common/user_feedback/bloc/user_feedback_state.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewsList extends StatelessWidget {
  final String feedbackForUserId;
  final Function callback;
  ReviewsList({required this.callback,required this.feedbackForUserId});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<UserFeedbackBloc>(context).add(FetchFeedbacksEvent(
        userId: feedbackForUserId));
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(/*boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],*/ borderRadius: BorderRadius.circular(10.0), color: Colors.white),
     // padding: const EdgeInsets.all(10.0),
      child: BlocBuilder<UserFeedbackBloc, UserFeedbackState>(
        builder: (context, state) {
          if (state is FeedbackLoadingState) {
            return Center(
              child: Text("Loading"),
            );
          }
          if (state is AddFeedbackExceptionState) {
            return Center(child: Text(state.message));
          }
          if (state is FetchFeedbacksState) {
            return state.feedbacks.isEmpty
                ? Center(
                    child: InkWell(
                      onTap: ()async{
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return FeedbackWidgetDialog(callback: (bool isAdded){
                                callback(isAdded);
                              },feedbackForUserId: feedbackForUserId,);
                            },
                            barrierDismissible: false);
                        //Navigator.pop(context);
                      },
                        child: Text(
                      "Please Write a Review",
                      style: TextStyle(color: Colors.blue,fontSize: 16.0),
                    )),
                  )
                : ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Reviews"),
                      InkWell(
                        onTap: ()async{
                          await showDialog(
                              context: context,
                              builder: (context) {
                            return FeedbackWidgetDialog(callback: (bool isAdded){
                              callback(isAdded);
                            },feedbackForUserId: feedbackForUserId,);
                          },
                          barrierDismissible: false);
                          //Navigator.pop(context);
                        },
                        child: Text("Add A Review",style: TextStyle(
                          color: Colors.blue
                        ),),
                      )
                    ],
                  ),
                ),
                ListView.builder(
              padding: const EdgeInsets.all(0.0),
                      itemBuilder: (context, index) {
                        UserFeedbackModel userFeedbackModel =
                            state.feedbacks[index];
                        return Container(
                          child: Column(
                            children: [
                              ReviewerInfo(id: userFeedbackModel.userId,rating: userFeedbackModel.rating,),
                              Text(userFeedbackModel.review)
                            ],
                          ),
                        );
                      },
                      itemCount: state.feedbacks.length,
                      shrinkWrap: true,
                    )],
                );
          }
          return Container();
        },
      ),
    );
  }
}
