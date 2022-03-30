import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/model/date_filter.dart';

class LandingRepo{
  final collectionInstance = FirebaseFirestore.instance.collection('users');
  final groupCollectionInstance = FirebaseFirestore.instance.collection('groups');

  Future<QuerySnapshot> getCalls(String emailId,bool isOnlyAcceptedCallsNeeded,
      [String associateName="",int dateFilter=3,String fieldTypeToBeSearched=""]){
    Query query=this.collectionInstance.doc(emailId).collection("schedules");
    if(associateName!=""){
      query=fieldTypeToBeSearched=="Client" || fieldTypeToBeSearched=="client"? query.where("userName",isEqualTo: associateName):query.where("freelancerName",isEqualTo: associateName);
    }
    if(dateFilter!=DateFilter.ALL.index){
      DateTime currentDate=DateTime.now();
      switch(dateFilter){
        case 1:
          query=query.where("callScheduled",isGreaterThanOrEqualTo: currentDate.subtract(Duration(days: 7)));
          break;
        case 2:
          query=query.where("callScheduled",isGreaterThanOrEqualTo: currentDate.subtract(Duration(days: 31)));
          break;
        case 0:
          query=query.where("callScheduled",isGreaterThanOrEqualTo: DateTime(currentDate.year,currentDate.month,currentDate.day));
          break;
        default:
          break;
      }
    }
    if(isOnlyAcceptedCallsNeeded) {
      //query = query.where("status", isEqualTo: "accepted");
      query = query.where("status", isEqualTo: "Accepted");
    }
    return query.orderBy("callScheduled",descending: true).get();
   // return query.orderBy("callScheduled",descending: true).get();
  }

  Future<List<QueryDocumentSnapshot>> getCallsForGroup(String emailId,bool isOnlyAcceptedCallsNeeded,
      [String associateName="",int dateFilter=3,String fieldTypeToBeSearched=""])async{
   QuerySnapshot<Map<String,dynamic>> groupSnapshot=await this
       .collectionInstance
       .doc(emailId)
       .collection("groups")
       .get();

   List<QueryDocumentSnapshot> docs=[];
   Map<String,Map<String,dynamic>> groupsDoc={};

   if(groupSnapshot.docs.isNotEmpty){
     for(QueryDocumentSnapshot snapshot in groupSnapshot.docs){
        groupsDoc[snapshot.id]=snapshot.data() as Map<String,dynamic>;
     }
     for(String groupId in groupsDoc.keys){
       Query query=this.groupCollectionInstance
             .doc(emailId)
             .collection("schedules");
         if(associateName!=""){
           query=fieldTypeToBeSearched=="Client" || fieldTypeToBeSearched=="client"? query.where("userName",isEqualTo: associateName):query.where("freelancerName",isEqualTo: associateName);
         }
         if(dateFilter!=DateFilter.ALL.index){
           DateTime currentDate=DateTime.now();
           switch(dateFilter){
             case 1:
               query=query.where("callScheduled",isGreaterThanOrEqualTo: currentDate.subtract(Duration(days: 7)));
               break;
             case 2:
               query=query.where("callScheduled",isGreaterThanOrEqualTo: currentDate.subtract(Duration(days: 31)));
               break;
             case 0:
               query=query.where("callScheduled",isGreaterThanOrEqualTo: DateTime(currentDate.year,currentDate.month,currentDate.day));
               break;
             default:
               break;
           }
         }
         if(isOnlyAcceptedCallsNeeded) {
           //query = query.where("status", isEqualTo: "accepted");
           query = query.where("status", isEqualTo: "Accepted");
         }
         QuerySnapshot val=await query.orderBy("callScheduled",descending: true).get();
         if(val.docs.isNotEmpty)
           docs.addAll(val.docs);

     }

   }
   return docs;
  }

  Future<QuerySnapshot> getMadeCalls(String emailId,[String associateName="",
    int dateFilter=3,String fieldTypeToBeSearched=""]){
    Query query=this.collectionInstance.doc(emailId).collection("calls");
    if(associateName!=""){
      query=fieldTypeToBeSearched=="Client" || fieldTypeToBeSearched=="client"? query.where("userName",isEqualTo: associateName):query.where("receiverName",isEqualTo: associateName);
    }
    if(dateFilter!=DateFilter.ALL.index){
      DateTime currentDate=DateTime.now();
      switch(dateFilter){
        case 1:
          query=query.where("createdAt",isGreaterThanOrEqualTo: currentDate.subtract(Duration(days: 7)));
          break;
        case 2:
          query=query.where("createdAt",isGreaterThanOrEqualTo: currentDate.subtract(Duration(days: 31)));
          break;
        case 0:
          query=query.where("createdAt",isGreaterThanOrEqualTo: DateTime(currentDate.year,currentDate.month,currentDate.day));
          break;
        default:
          break;
      }
    }
    return query.orderBy("createdAt",descending: true).get();
  }

  Future<QuerySnapshot> getScheduledPassedCalls(String emailId,bool isOnlyAcceptedCallsNeeded,[String associateName="",
    int dateFilter=3,String fieldTypeToBeSearched=""]){
    Query query=this.collectionInstance.doc(emailId).collection("calls");
    return query.get();
  }

  Future<QuerySnapshot> getUpcomingCalls(String emailId,String status,[String associateName="",
      int dateFilter=3,
    String fieldTypeToBeSearched=""]){
    Query query=this.collectionInstance.doc(emailId).collection("schedules");
    if(status=="accepted"){
      query=query.where("status",isEqualTo:status);
      query=query.where("status",isEqualTo: "Accepted");
    }else if(status=="pending"){
      query=query.where("status",isEqualTo: status);
      query=query.where("status",isEqualTo: "Pending");
    }
    else{
      query=query.where("status",isEqualTo: status);
    }

    return query.get();
  }

  Future<QuerySnapshot> getBids(String emailId,
  [String associateName="",
    String fieldTypeToBeSearched="",int dateFilter=2]){
    Query query=this.collectionInstance.doc(emailId).collection("bids");
    if(associateName!=""){
      query=fieldTypeToBeSearched=="Client"? query.where("profileName",isEqualTo: associateName):
      query.where("clientName",isEqualTo: associateName);
    }
    if(dateFilter!=DateFilter.ALL.index){
      DateTime currentDate=DateTime.now();
      switch(dateFilter){
        case 1:
          query=query
              .where("createdAt",isGreaterThanOrEqualTo: currentDate.subtract(Duration(days: 7)));
          break;
        case 2:
          query=query.where("createdAt",isGreaterThanOrEqualTo: currentDate.subtract(Duration(days: 31)));
          break;
        case 0:
          query=query.where("createdAt",isGreaterThanOrEqualTo: DateTime(currentDate.year,currentDate.month,currentDate.day));
          break;
        default:
          break;
      }
    }
    return query
    .orderBy("createdAt",descending: true)
        .get();
  }

  updateBid(String bidId,String userId,String freelancerId,String type){
    if(type=="delete") {
      this.collectionInstance.doc(userId).collection("bids").doc(
          bidId).set({
        "status":"deleted"
      },new SetOptions(merge: true));
      this.collectionInstance.doc(freelancerId)
          .collection("bids")
          .doc(bidId)
        .set({
          "status":"deleted"
        },new SetOptions(merge: true));
    }

    else if(type=="accept") {
      this.collectionInstance.doc(userId).collection("bids").doc(
          bidId).set({
        "status":"accepted"
      },new SetOptions(merge: true));
      this.collectionInstance.doc(freelancerId)
          .collection("bids")
          .doc(bidId)
          .set({
            "status":"accepted"
          },new SetOptions(merge: true));
    }

    else if(type=="reject") {
      this.collectionInstance.doc(userId).collection("bids").doc(
          bidId).set({
        "status":"rejected"
      },new SetOptions(merge: true));
      this.collectionInstance.doc(freelancerId)
          .collection("bids")
          .doc(bidId)
        .set({
          "status":"rejected"
        },new SetOptions(merge: true));
    }
  }}