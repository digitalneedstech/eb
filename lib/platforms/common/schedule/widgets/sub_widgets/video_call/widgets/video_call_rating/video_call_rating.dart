import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/ratings/bloc/ratings_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/ratings/bloc/rating_state.dart';
import 'package:flutter_eb/platforms/common/ratings/model/rating_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_model.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/schedule_detail.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/sub_widgets/video_call/widgets/rating_widget.dart';
import 'package:flutter_eb/shared/widgets/eb_outline_button_widget/eb_outline_button_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewDescriptionWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return           Card(
        margin:
        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        color: Colors.white,
        elevation: 2.0,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (String val) {
              BlocProvider.of<RatingBloc>(context).description = val.trim();
            },
            maxLines: 3,
            decoration: InputDecoration.collapsed(
                hintText: "Please Share About experience"),
          ),
        ));
  }
}

class RatingBuilder extends StatefulWidget {
  RatingBuilderState createState() => RatingBuilderState();
}

class RatingBuilderState extends State<RatingBuilder> {
  double ratingVal = 0.0;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<RatingBloc>(context).rating = ratingVal;
    return RatingBar.builder(
      initialRating: ratingVal,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          ratingVal = rating;
        });
        BlocProvider.of<RatingBloc>(context).rating = ratingVal;
      },
    );
  }
}
