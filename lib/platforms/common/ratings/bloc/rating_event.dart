
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eb/platforms/common/ratings/model/rating_model.dart';

class RatingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddRatingEvent extends RatingEvent{
  RatingModel ratingModel;
  String forUserId;
  final String feedbackType;
  AddRatingEvent({required this.ratingModel,required this.feedbackType,required this.forUserId});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}

class InitializeRatingEvent extends RatingEvent{
  InitializeRatingEvent();
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}
class FetchRatingsEvent extends RatingEvent{
  final String userId;
  FetchRatingsEvent({required this.userId});
}
