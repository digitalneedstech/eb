
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/ratings/bloc/rating_event.dart';
import 'package:flutter_eb/platforms/common/ratings/bloc/rating_state.dart';
import 'package:flutter_eb/platforms/common/ratings/model/rating_model.dart';
import 'package:flutter_eb/platforms/common/ratings/repo/rating_repo.dart';

/*
TODO- Update user model with required new model values instead of null
 */
class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RatingRepository ratingRepository;

  RatingBloc(this.ratingRepository) : super(RatingLoadedState());

  double _rating=0.0;
  String _review="";
  String _description="";

  get review => _review;

  set review(value) {
    _review = value;
  }

  double get rating => _rating;

  set rating(double value) {
    _rating = value;
  }

  @override
  Stream<RatingState> mapEventToState(RatingEvent event,) async* {
    if (event is AddRatingEvent) {
      yield RatingAddingInProgressState();
      try {
        RatingModel ratingModel=new RatingModel(
          rating: rating,
          userId: event.ratingModel.userId,
          review: review,
          createdAt: DateTime.now().toIso8601String(),

        );
        await ratingRepository.addRatings(
            ratingModel, event.forUserId,event.feedbackType);
        yield RatingAddedState(isRated: true);
      } catch (e) {
        yield RatingAddedState(isRated: false);
      }
    }

    if(event is FetchRatingsEvent){
      yield RatingAddingInProgressState();
      QuerySnapshot snapshot=await ratingRepository.getRatingsForAUser(event.userId);
      if(snapshot.docs.isNotEmpty){
        List<RatingModel> ratings=snapshot.docs.map((e){
          return new RatingModel.fromMap(e.data() as Map<String,dynamic>);
        }).toList();
        yield FetchRatingState(ratings: ratings);
      }
      else{
        yield FetchRatingState(ratings: []);
      }
    }
    if(event is InitializeRatingEvent){
      yield RatingInitializedState();
    }
  }


  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }

  get description => _description;

  set description(value) {
    _description = value;
  }
}