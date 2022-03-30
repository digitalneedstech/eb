import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/wallet/bloc/wallet_event.dart';
import 'package:flutter_eb/platforms/common/wallet/bloc/wallet_state.dart';
import 'package:flutter_eb/platforms/common/wallet/data/wallet_repository.dart';
import 'package:flutter_eb/platforms/common/wallet/model/transaction_response.dart';
import 'package:flutter_eb/shared/services/notification/model/notification_message.dart';
import 'package:flutter_eb/shared/services/notification/repository/notification_repository.dart';

/*
TODO- Update user model with required new model values instead of null
 */
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository walletRepository;
  final NotificationRepository notificationRepository;
  WalletBloc(this.walletRepository,this.notificationRepository) : super(WalletLoadedState());
  @override
  Stream<WalletState> mapEventToState(
      WalletEvent event,
      ) async* {
    if(event is InitiateTransactionEvent){
      yield LoadingWalletState();
      String transactionId=await initiateTransaction(event.userId, event.currency, event.amount);
      yield InitiateTransactionEventState(transactionId: transactionId);
    }

    /*if(event is UpdateTransactionEvent){
      yield LoadingWalletState();
      UserDTOModel userDTOModel=await updateTransaction(event.userId, event.transactionId, event.transactionResponse);
      yield UpdateTransactionState(userDTOModel: userDTOModel);
    }*/

  }

  Future<String> initiateTransaction(String userId,String currency,int amount) async {
    return walletRepository.initiateTransaction(userId, amount, currency);
  }
/*
  Future<UserDTOModel> updateTransaction(String userId,String transactionId,dynamic transactionResponse) async {
    UserDTOModel userDTOModel=await this.walletRepository.updateTransactionDataInTransactionTable(userId, transactionId, transactionResponse);
    if(transactionResponse.status==1) {
      NotificationMessage notificationMessage = new NotificationMessage(
          type: "notification",
          payload: NotificationMessagePayload(
              false,
              new NotificationMessageNotificationPayload(
                  "Wallet Notification",
                  "${userDTOModel.personalDetails.displayName}"
                      " have successfully added amount ${transactionResponse.amount} in your wallet"
              ),
              new NotificationMessageDataPayload(
                  userDTOModel.userId,
                  "wallet"
              )

          )
      );
      this.notificationRepository.sendNotification(notificationMessage);
      NotificationMessage mailNotificationMessage = new NotificationMessage(
          type: "mail",
          payload: NotificationMessageEmailPayload(
              userDTOModel.personalDetails.email,
              "Money Added In Wallet",
              "Money Has been added in your wallet"
          )
      );
      this.notificationRepository.sendNotification(mailNotificationMessage);
      NotificationMessage smsNotificationMessage = new NotificationMessage(
          type: "sms",
          payload: NotificationMessageSMSPayload(
              userDTOModel.personalDetails.mobileData.mobile,
              "Money Has been added in your wallet"
          )
      );
      this.notificationRepository.sendNotification(mailNotificationMessage);
    }
    return userDTOModel;
  }*/

  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}
