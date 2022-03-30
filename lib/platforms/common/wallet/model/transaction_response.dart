import 'package:date_format/date_format.dart';

class TransactionResponse{
  String orderId,paymentId,message,signature;
  int code;
  int status,amount;//1- success,0-fail,2-pending

  TransactionResponse({this.code=2,this.status=0,this.amount=0,
      this.orderId="", this.paymentId="", this.message="", this.signature=""});
  factory TransactionResponse.fromMap(Map<String,dynamic> json){
    return new TransactionResponse(
        orderId: json['orderId'] as String,
      paymentId: json['paymentId'] as String,
      message: json['message'] as String,
      code: json['code'] as int,
      signature: json['signature'] as String,
      status:json['status'] as int,
      amount: json['amount'] as int
    );
  }

  toJson(){
    return {
      "ordeId":orderId,
      "paymentId":paymentId,
      "message":message,
      "code":code,
      "signature":signature,
      "status":status,
      "amount":amount
    };
  }
}