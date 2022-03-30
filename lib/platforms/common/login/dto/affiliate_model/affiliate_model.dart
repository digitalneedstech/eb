class AffiliateModel{
  String email,createdAt,userId,userName;
  bool isAccepted;

  AffiliateModel({this.email="",this.createdAt="",this.userId="",this.userName="",this.isAccepted=false});
  factory AffiliateModel.fromMap(Map<String,dynamic> json){
    return new AffiliateModel(
      email: json['email'] as String,
      //userName: json['userName'] as String,
      //userId: json['userId'] as String,
      createdAt: json['createdAt'] as String,
      isAccepted: json['isAccepted']as bool
    );
  }

  toJsonForInvite(){
    return {
      "email":email,
      "createdAt":DateTime.now().toString(),
      "isAccepted":false
    };
  }
  toJson(){
    return{
      "email":email,
      "createdAt":DateTime.now().toString(),
      "isAccepted":false,
      "userName":userName,
      "userId":userId
    };
  }
}