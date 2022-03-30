class TransactionModel{
  String type,senderId,senderName,description,amountType;
  int amount;
  TransactionModel({this.type="",this.senderName="",this.senderId="",
    this.description="",this.amount=0,this.amountType=""});
  factory TransactionModel.fromMap(Map<String,dynamic> json){
    return new TransactionModel(
      senderName: json['payerOrPayeeName'],
      senderId: json['paidRcvdUserId'],
      type: json['type'],
      description: json['description'],
      amount: json['amount'],
      amountType: json['amountType']
    );
  }
}