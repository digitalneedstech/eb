
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_event.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_state.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/bids/repo/bid_repository.dart';
import 'package:flutter_eb/platforms/common/invite/bloc/affiliate_event.dart';
import 'package:flutter_eb/platforms/common/invite/bloc/affiliate_state.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/data/login_repository.dart';
import 'package:flutter_eb/shared/services/notification/model/notification_message.dart';
import 'package:flutter_eb/shared/services/notification/repository/notification_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';

/*
TODO- Update user model with required new model values instead of null
 */
class AffiliateBloc extends Bloc<AffiliateEvent, AffiliateState> {
  final NotificationRepository notificationRepository;
  final LoginRepository loginRepository;
  AffiliateBloc(this.notificationRepository,this.loginRepository) : super(AffiliateLoadedState());

  String notificationContent="Hello %s \n You have been invited by %s to be a service provider / user in \n "
      "ExpertBunch.com which is a platform for professionals from various industries. This "
      "will enable you to provide service through this app/portal and earn on time basis. \n"
      "Click the link to join ExpertBunch service providers platform \n "
      "%s \n"
      "In case of any trouble in connecting, contact support@expertbunch.com"
  "Best Regards, \n"
  "EXPERT BUNCH Managment Team \n"
  "Email: ebteam@expertbunch.com";
  @override
  Stream<AffiliateState> mapEventToState(AffiliateEvent event) async* {
    if (event is SendAffiliateLinkEvent) {
      yield SendAffiliateLinkInProgressState();
      try {
        bool response=await saveDataInAffiliateCollectionAndShareLinkViaMail(event.email,
            event.shareLink,event.senderName,event.senderId,event.isResend);
        yield SendAffiliateLinkState(isSent: response);
      }catch(e){
        yield SendAffiliateLinkState(isSent: false,errorMessage: e.toString());
      }
    }
  }

  Future<bool> saveDataInAffiliateCollectionAndShareLinkViaMail(String emailAddress,
      String shareLink,String userName,String senderId,bool isResend)async {
    bool isSent=false;
    dynamic response=isResend ?"Already Sent":loginRepository.addAffiliateRecord(emailAddress, senderId);
    if(response is DocumentReference<Map<String,dynamic>> || isResend){
      NotificationMessage notificationMessageEmailPayload = new NotificationMessage(
          type:"mail",
          payload: NotificationMessageEmailPayload(
              emailAddress,
              "$userName invited you to ExpertBunch platform",
              sprintf(notificationContent,[emailAddress,userName,shareLink])
          ));
      isSent=await this.notificationRepository.sendNotification(notificationMessageEmailPayload);
    }

    return isSent;
  }

  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }

}
