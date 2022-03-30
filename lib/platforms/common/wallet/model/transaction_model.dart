class TransactionModel{
  String id,entity,currency,receipt,offerId,status,createdAt;
  int amount,amountPaid,attempts;

  TransactionModel({
      this.id="",
      this.entity="",
      this.currency="",
      this.receipt="",
      this.offerId="",
      this.status="",
      this.amount=0,
      this.amountPaid=0,
      this.attempts=0,
      this.createdAt=""});

  factory TransactionModel.fromMap(Map<String,dynamic> json){
    return new TransactionModel(
      id: json['id'] as String,
      currency: json['currency'] as String,
      entity: json['entity'] as String,
      receipt: json['receipt'] as String,
      status: json['status'] as String,
      attempts: json['attempts'] as int,
      amount: json['amount'] as int,
      amountPaid: json['amount_paid'] as int,
      offerId: json['offer_id'] as String
    );
  }

  toJson(){
    return {
      "id":id,
      "currency":currency,
      "entity":entity,
      "receipt":receipt,
      "status":status,
      "attempts":attempts,
      "amount":amount,
      "amountPaid":amountPaid,
      "offerId":offerId
    };
  }
}