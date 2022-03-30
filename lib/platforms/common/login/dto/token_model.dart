class TokenModel{
  String token,createdAt;
  TokenModel({this.token="",this.createdAt=""});
  factory TokenModel.fromMap(Map<String,dynamic> json){
    return new TokenModel(
      createdAt: json['createdAt'] as String,
      token: json['token'] as String
    );
  }

  toJson(){
    return {
      "createdAt":DateTime.now().toIso8601String(),
      "token":token
    };
  }
}