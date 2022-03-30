  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';

  class BidRepository {
    final collectionInstance = FirebaseFirestore.instance.collection('bids');
    final userCollectionInstance = FirebaseFirestore.instance.collection(
        'users');

    Future<QuerySnapshot> fetchBidList(String userId, String userType) {
      return this.userCollectionInstance.doc(userId).collection("bids").get();
    }

    Future<String> createOrUpdateBid(BidModel bidModel, String userId,
        String freelancerId) async {
      if (bidModel.id != "") {
        SetOptions options = SetOptions(
            merge: true
        );
        this.userCollectionInstance.doc(
            userId).collection("bids").doc(bidModel.id)
            .set(bidModel.toJson(), options);
        this
            .userCollectionInstance
            .doc(freelancerId)
            .collection("bids")
            .doc(bidModel.id)
            .set(bidModel.toJson(), options);
        return bidModel.id;
      } else {
        DocumentReference reference = await this
            .userCollectionInstance
            .doc(userId)
            .collection("bids")
            .add(bidModel.toJson());
        this
            .userCollectionInstance
            .doc(freelancerId)
            .collection("bids")
            .doc(reference.id)
            .set(bidModel.toJson());
        return reference.id;
      }
      /*this.userCollectionInstance.doc(userId).collection("bids").doc(freelancerId).set(bidModel.toJson());
      this.userCollectionInstance.doc(freelancerId).collection("bids").doc(userId).set(bidModel.toJson());*/

    }

    Future<DocumentSnapshot> getBid(String userId, String bidId) {
      return this.userCollectionInstance.doc(userId).collection("bids").doc(
          bidId).get();
    }

    Future<Map<bool,QueryDocumentSnapshot?>> getBidsBetweenTwoUsers(String ownerId,
        String freelancerId) async {
      try {
        Map<bool,QueryDocumentSnapshot?> snapshotDocumentMap={};
        DateTime currentDateTime = DateTime.now();

        QuerySnapshot shortBidsSnapshot = await this.userCollectionInstance.doc(
            ownerId).collection("bids")
            .where("freelancerId", isEqualTo: freelancerId)
            .where("status", isEqualTo: "accepted")
            .where("isLongTerm", isEqualTo: false)
            .where("validTill", isGreaterThanOrEqualTo: currentDateTime)
        .orderBy("validTill",descending: true)
            .get();
        QuerySnapshot longBidsSnapshot = await this.userCollectionInstance.doc(
            ownerId).collection("bids")
            .where("freelancerId", isEqualTo: freelancerId)
            .where("status", isEqualTo: "accepted")
            .where("isLongTerm", isEqualTo: true)
            .where("validTill", isGreaterThanOrEqualTo: currentDateTime)
            .orderBy("validTill",descending: true)
            .get();

        if (longBidsSnapshot.docs.isNotEmpty) {
          snapshotDocumentMap[true]=longBidsSnapshot.docs[0];
          return snapshotDocumentMap;
        }
        else if (shortBidsSnapshot.docs.isNotEmpty) {
          snapshotDocumentMap[true]=shortBidsSnapshot.docs[0];
          return snapshotDocumentMap;
        }
        return {false:null};
      }catch(e){
        return {false:null};
      }
    }
  }