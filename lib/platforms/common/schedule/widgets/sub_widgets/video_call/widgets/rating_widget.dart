import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/ratings/bloc/rating_event.dart';
import 'package:flutter_eb/platforms/common/ratings/bloc/rating_state.dart';
import 'package:flutter_eb/platforms/common/ratings/bloc/ratings_bloc.dart';
import 'package:flutter_eb/platforms/common/ratings/model/rating_model.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';

class RatingButtonWidget extends StatelessWidget {
  final Function callback;
  RatingModel ratingModel;
  final String feedbackType;
  final String forUserId;
  RatingButtonWidget(
      {this.feedbackType = "call",
      required this.callback,
      required this.forUserId,
      required this.ratingModel});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<RatingBloc>(context).add(InitializeRatingEvent());
    return BlocListener<RatingBloc,RatingState>(
      listener: (context,state){
        if (state is RatingAddedState) {
          callback(true);
        }
      },
      child: BlocBuilder<RatingBloc, RatingState>(builder: (context, state) {
        if (state is RatingAddingInProgressState) {
          return EbRaisedButtonWidget(
            callback: () {},
            disabledButtontext: "Processing",
            buttonText: "Submit",
          );
        }
        return EbRaisedButtonWidget(
          buttonText: "Submit",
          callback: () {
            BlocProvider.of<RatingBloc>(context).add(AddRatingEvent(
                feedbackType: feedbackType,
                ratingModel: ratingModel,
                forUserId: forUserId));
          },
          disabledButtontext: "Submitting",
          textColor: Colors.white,
        );
      }),
    );
  }
}
