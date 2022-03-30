import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/wallet/model/transaction_model.dart';
import 'package:flutter_eb/platforms/common/wallet/model/transaction_response.dart';

class WalletRepository{
  final userCollectionInstance=FirebaseFirestore.instance.collection("users");
  Dio dio;

  WalletRepository(this.dio);
  String transactionUrl="https://wz8chtokv5.execute-api.ap-south-1.amazonaws.com/prod/payments/order";
  Future<String> initiateTransaction(String userId,int amount,String currency)async{
    Response response;
    try {
      response = await dio.post(transactionUrl,
          data: {
            "userId":userId,
            "amount":amount,
            "currency":currency
          });
      if (response.statusCode == 200){
        TransactionModel model=TransactionModel.fromMap(response.data() as Map<String,dynamic>);
        createRecordInTransaction(model, userId);
        return model.id;
      }
      return "";
    } on DioError catch (e) {
      print(e.message);
      return "";
    }
  }

  Future<UserDTOModel> updateTransactionDataInTransactionTable(String userId,String transactionId,dynamic transactionResponse)async{
    this.userCollectionInstance.doc(userId).collection("transactions").doc(transactionResponse["id"])
        .set(transactionResponse,new SetOptions(merge: true));
    DocumentSnapshot snapshot=await this.userCollectionInstance.doc(userId).get();
    UserDTOModel dtoModel=UserDTOModel.fromJson(snapshot.data() as Map<String,dynamic>, snapshot.id);
    return dtoModel;
  }

  Future<void> createRecordInTransaction(dynamic transactionModel,String id)async{
    this.userCollectionInstance.doc(id).collection("transactions").doc(transactionModel["id"])
        .set(transactionModel);
  }
}