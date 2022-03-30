import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_eb/platforms/common/ratings/model/rating_model.dart';

class RatingRepository{
  final userCollectionInstance = FirebaseFirestore.instance.collection('users');

 Future<void> addRatings(RatingModel ratingModel,String forUserId,String feedbackType)async{
   if(feedbackType=="call")
    this.userCollectionInstance.doc(forUserId).collection("callFeedbacks")
      .doc(ratingModel.userId)
       .set(ratingModel.toJson());
   else
     this.userCollectionInstance.doc(forUserId).collection("feedbacks")
         .doc(ratingModel.userId)
         .set(ratingModel.toJsonForUser());
 }

 Future<QuerySnapshot> getRatingsForAUser(String userId){
   return this.userCollectionInstance.doc(userId).collection("callFeedbacks").get();
 }
}