import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_updation_bloc/bid_updation_event.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_updation_bloc/bid_updation_state.dart';
import 'package:flutter_eb/platforms/common/bids/repo/bid_repository.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/shared/services/notification/model/notification_message.dart';
import 'package:flutter_eb/shared/services/notification/repository/notification_repository.dart';

/*
TODO- Update user model with required new model values instead of null
 */
class BidUpdationBloc extends Bloc<BidUpdationEvent, BidUpdationState> {
  final BidRepository bidRepository;
  final NotificationRepository notificationRepository;
  BidUpdationBloc(this.bidRepository,this.notificationRepository) : super(BidUpdationStateUpdated());
  late String _bid;
  bool _isLongTerm=false;
  late String _hours;
  late DateTime _validTill;


  String get hours => _hours;

  set hours(String value) {
    _hours = value;
  }

  bool get isLongTerm => _isLongTerm;

  set isLongTerm(bool value) {
    _isLongTerm = value;
  }

  String get bid => _bid;

  set bid(String value) {
    _bid = value;
  } //TODO- Make Bloc For this repo and for Patient save
  @override
  Stream<BidUpdationState> mapEventToState(
      BidUpdationEvent event,
      ) async* {
    if (event is CreateOrUpdateBidEvent) {
      yield LoadingBidOperationState();
      createOrUpdateBid(
          event.bidModel, event.userId, event.freelancerId, event.isNewBid,
          event.updatedBy);
      yield CreatedOrUpdatedBidState();
    }
  }

  Future<void> createOrUpdateBid(BidModel bidModel,String userId,
      String freelancerId,bool isNewBid,String updatedBy)async {
    String bidId=await this.bidRepository.createOrUpdateBid(bidModel, userId, freelancerId);
    if(bidModel.id=="") {
      NotificationMessageNotificationModel notificationMessageNotificationModel=NotificationMessageNotificationModel(
          "notification",
          NotificationMessageNotificationPayloadModel(notification:
          NotificationMessageNotificationPayload(
              "Bid Notification",
              "${bidModel.profileName} has sent you a bid amount of ${bidModel.bid[bidModel.bid.length-1].amount}"
          ),data: new NotificationMessageDataPayload(
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

  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }

  DateTime get validTill => _validTill;

  set validTill(DateTime value) {
    _validTill = value;
  }
}
