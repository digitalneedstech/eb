import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/ratings/model/rating_model.dart';

@immutable
abstract class RatingState extends Equatable {}

class RatingLoadedState extends RatingState {
  @override
  List<Object> get props => [];
}
class RatingAddedState extends RatingState {
  bool isRated;
  RatingAddedState({required this.isRated});
  @override
  List<Object> get props => [];
}

class RatingInitializedState extends RatingState {
  RatingInitializedState();
  @override
  List<Object> get props => [];
}
class FetchRatingState extends RatingState {
  List<RatingModel> ratings;
  FetchRatingState({required this.ratings});
  @override
  List<Object> get props => [];
}

class RatingAddingInProgressState extends RatingState {
  @override
  List<Object> get props => [];
}
