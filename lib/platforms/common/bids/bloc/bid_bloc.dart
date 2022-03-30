
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_event.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_state.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/bids/repo/bid_repository.dart';
import 'package:flutter_eb/shared/services/notification/model/notification_message.dart';
import 'package:flutter_eb/shared/services/notification/repository/notification_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
TODO- Update user model with required new model values instead of null
 */
class BidBloc extends Bloc<BidEvent, BidState> {
  final BidRepository bidRepository;
  final NotificationRepository notificationRepository;
  BidBloc(this.bidRepository,this.notificationRepository) : super(BidLoadedState());
  late String _bid;
  late String _hours;
  bool isButtonEnabled = false;

  bool isLongTerm = false;
  DateTime selectedValidDate = DateTime.now().add(Duration(days: 2));
  late DateTime _validTill;
  TextEditingController messageController = TextEditingController();
  TextEditingController validDateController = TextEditingController(text: "");
  TextEditingController hoursController = TextEditingController(text: "0");
  TextEditingController bidController = TextEditingController(text: "0");

  String get hours => _hours;

  set hours(String value) {
    _hours = value;
  }

  String get bid => _bid;

  set bid(String value) {
    _bid = value;
  } //TODO- Make Bloc For this repo and for Patient save
  @override
  Stream<BidState> mapEventToState(
      BidEvent event,
      ) async* {
    if(event is SwitchBidTypeEvent){
      isLongTerm=event.bidType;
      yield SwitchBidState(bidType: event.bidType);
    }
    if(event is FetchBidListEvent){
      yield LoadingBidState();
      QuerySnapshot snapshot=await getBidsList(event.userId);
      if(snapshot.docs.isEmpty)
        yield BidListState();
      else {
        List<BidModel> bids = snapshot.docs.map((e) =>
            BidModel.fromJson(e.data() as Map<String, dynamic>, e.id)).toList();
        yield BidListState(bidModels: bids);
      }
    }

    if(event is FetchBidInfoEvent){
      yield LoadingBidState();
      DocumentSnapshot snapshot=await getBid(event.userId,event.bidId);
      if(snapshot.exists) {
        yield BidInfoState(
            bidModel: BidModel.fromJson(
                snapshot.data() as Map<String, dynamic>, snapshot.id)
                );
      }
      yield BidInfoState(bidModel: new BidModel());
    }
    if(event is FetchBidInfoInPopUpEvent){
      yield LoadingBidInPopupState();
      DocumentSnapshot snapshot=await getBid(event.userId,event.bidId);
      if(snapshot.exists) {
        yield BidInfoInPopupState(
            bidModel: BidModel.fromJson(
                snapshot.data() as Map<String, dynamic>, snapshot.id)
        );
      }
      yield BidInfoInPopupState(bidModel: new BidModel());
    }

    if(event is CreateOrUpdateBidEvent){
      yield LoadingBidOperationState();
      createOrUpdateBid(event.bidModel, event.userId, event.freelancerId,event.isNewBid,event.updatedBy);
      yield CreatedOrUpdatedBidState();
    }

    if(event is ClearBidModel){
      yield BidInfoState(bidModel: new BidModel());
    }
  }

  Future<QuerySnapshot> getBidsList(String userId)async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var type;
    if(preferences.containsKey("type")){
      type=preferences.getString("type");
    }

    return await this.bidRepository.fetchBidList(userId, type);

  }

  Future<void> createOrUpdateBid(BidModel bidModel,String userId,
      String freelancerId,bool isNewBid,String updatedBy)async {
    String bidId=await this.bidRepository.createOrUpdateBid(bidModel, userId, freelancerId);
    if(bidModel.id=="") {
      NotificationMessageNotificationModel notificationMessageNotificationModel=NotificationMessageNotificationModel(
        "notification",
        NotificationMessageNotificationPayloadModel(notification: NotificationMessageNotificationPayload(
            "Bid Notification",
            "${bidModel.profileName} has sent you a bid amount of ${bidModel.bid[bidModel.bid.length-1].amount}"
        ),data:  new NotificationMessageDataPayload(
            bidId,
            bidModel.companyId==""?bidModel.freelancerId:bidModel.companyId,
            "bid","freelancer",bidModel.userId
        )),

      );
      this.notificationRepository.sendNotification(notificationMessageNotificationModel);
    }
    else{
      String statusMessage="";
      if(updatedBy=="user"){

        if(bidModel.status=="accepted"){
          statusMessage="${bidModel.profileName} has accepted your negotiated bid";
        }
        else if(bidModel.status=="rejected"){
          statusMessage="${bidModel.profileName} has rejected your negotiated bid";
        }
        else{
          statusMessage="${bidModel.profileName} re-negotiated the bid for "
              "${bidModel.bid[bidModel.bid.length-1].amount}";
        }
        NotificationMessageNotificationModel notificationMessage=NotificationMessageNotificationModel(
            "notification",
            NotificationMessageNotificationPayloadModel(notification: NotificationMessageNotificationPayload(
                "Bid Notification",
                statusMessage
            ),data: new NotificationMessageDataPayload(
                bidId,
                bidModel.companyId==""?bidModel.freelancerId:bidModel.companyId,
                "bid","freelancer",bidModel.userId
            )),

        );
        this.notificationRepository.sendNotification(notificationMessage);
      }
      else{
        if(bidModel.status=="accepted"){
          statusMessage="${bidModel.clientName} has accepted your bid";
        }
        else if(bidModel.status=="rejected"){
          statusMessage="${bidModel.clientName} has rejected your negotiated bid";
        }
        else{
          statusMessage="${bidModel.clientName} re-negotiated the bid for "
              "${bidModel.bid[bidModel.bid.length-1].amount}";
        }
        NotificationMessageNotificationModel notificationMessage=NotificationMessageNotificationModel(
            "notification",
            NotificationMessageNotificationPayloadModel(notification: NotificationMessageNotificationPayload(
                "Bid Notification",
                statusMessage
            ),data: new NotificationMessageDataPayload(
                bidId,
                bidModel.userId,
                "bid","user",bidModel.freelancerId
            )),


        );
        this.notificationRepository.sendNotification(notificationMessage);
      }
    }
  }

  Future<DocumentSnapshot> getBid(String userId,String bidId){
    return this.bidRepository.getBid(userId,bidId);
  }

  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }

  DateTime get validTill => _validTill;

  set validTill(DateTime value) {
    _validTill = value;
  }
}
