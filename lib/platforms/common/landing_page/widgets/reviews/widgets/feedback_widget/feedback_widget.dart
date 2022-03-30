import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/ratings/bloc/rating_state.dart';
import 'package:flutter_eb/platforms/common/ratings/bloc/rating_event.dart';
import 'package:flutter_eb/platforms/common/ratings/bloc/ratings_bloc.dart';
import 'package:flutter_eb/platforms/common/ratings/model/rating_model.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/sub_widgets/video_call/widgets/rating_widget.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/sub_widgets/video_call/widgets/video_call_rating/video_call_rating.dart';
import 'package:flutter_eb/shared/widgets/eb_outline_button_widget/eb_outline_button_widget.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
class FeedbackWidgetDialog extends StatelessWidget{
  final String feedbackForUserId;
  final Function callback;
  FeedbackWidgetDialog({required this.callback,required this.feedbackForUserId});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<RatingBloc>(context).add(InitializeRatingEvent());
    return BlocListener<RatingBloc,RatingState>(
      listener: (context,state){
        if(state is RatingAddedState){
          callback(state.isRated);

        }
      },
      child: AlertDialog(
        title: Text("Rate your Experience"),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(child: RatingBuilder()),
              ReviewDescriptionWidget(),
            ],
          ),
        ),
        contentPadding: const EdgeInsets.all(10.0),
        actions: [
          EbOutlineButtonWidget(
            callback: () {
              Navigator.pop(context, false);
            },
            buttonText: "Cancel",
          ),
          RatingButtonWidget(
            feedbackType: "profile",
            callback: (bool isAdded) {
              Navigator.pop(context, true);
            },
            forUserId: feedbackForUserId,
            ratingModel: new RatingModel(
                review: BlocProvider.of<RatingBloc>(context).review,
                rating: BlocProvider.of<RatingBloc>(context).rating,
                userId: getUserDTOModelObject(context).userId),
          )
        ],
      ),
    );
  }
}