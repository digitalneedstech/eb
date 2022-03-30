class NotificationMessageNotificationModel{
  String type;
  NotificationMessageNotificationPayloadModel payload;

  NotificationMessageNotificationModel(this.type,
      this.payload);
  factory NotificationMessageNotificationModel.fromMap(Map<String,dynamic> json){
    return new NotificationMessageNotificationModel(json["type"],
        NotificationMessageNotificationPayloadModel.fromMap(json['payload']));
  }

  toJson(){
    var obj= {
      "type":type,
      "payload":payload.toJson()
    };
    return obj;
  }
}

class NotificationMessageNotificationPayloadModel{
  bool isRead;

  NotificationMessageNotificationPayload notification;
  NotificationMessageDataPayload data;
  String userName,userPic;
  NotificationMessageNotificationPayloadModel({this.isRead=false,required this.notification,required this.data,
  this.userName="",this.userPic=""});
  factory NotificationMessageNotificationPayloadModel.fromMap(Map<String,dynamic> json){
    return new NotificationMessageNotificationPayloadModel(isRead:json["isRead"],notification:
    NotificationMessageNotificationPayload.fromMap(json['notification']),
    data: NotificationMessageDataPayload.fromMap(json['data']),
        userName: json['userName'],
        userPic: json['userPic']);
  }

  toJson(){
    return {
      "isRead":isRead,
      "notification":notification.toJson(),
      "data":data.toJson(),
    "userName":userName==""?"test":userName,
    "userPic":userPic=="" ?"test":userPic
    };
  }
}
class NotificationMessage{
  String type;
  dynamic payload;

  NotificationMessage({this.type="", this.payload=""});
  factory NotificationMessage.fromMap(Map<String,dynamic> json){
    if(json["type"]=="sms"){
      return new NotificationMessage(
          payload: NotificationMessageSMSPayload.fromMap(json["payload"]),
          type: json["type"]
      );
    }
    else if(json["type"]=="email"){
      return new NotificationMessage(
          payload: NotificationMessageEmailPayload.fromMap(json["payload"]),
          type: json["type"]
      );
    }
    return new NotificationMessage(
      payload: NotificationMessagePayload.fromMap(json["payload"]),
      type: json["type"]
    );
  }

  toJson(){
    return {
        "type":type,
        "payload":payload.toJson()
      };

  }
}

class NotificationMessageSMSPayload{
  String mobileNumber,text;

  NotificationMessageSMSPayload(this.mobileNumber, this.text);
  factory NotificationMessageSMSPayload.fromMap(Map<String,dynamic> json){
    return new NotificationMessageSMSPayload(json["mobile_number"], json["text"]);
  }

  toJson(){
    return {
      "mobile_number":mobileNumber,
      "text":text
    };
  }

}

class NotificationMessageEmailPayload{
  String email,text,sub;

  NotificationMessageEmailPayload(this.email, this.sub,this.text);
  factory NotificationMessageEmailPayload.fromMap(Map<String,dynamic> json){
    return new NotificationMessageEmailPayload(json["email"], json["sub"],json["text"]);
  }

  toJson(){
    return {
      "email":email,
      "sub":sub,
      "text":text
    };
  }

}

class NotificationMessagePayload{
  bool isRead;
  NotificationMessageNotificationPayload notification;
  NotificationMessageDataPayload data;
  String userName,userPic;
  NotificationMessagePayload(this.isRead,this.notification,this.data,{this.userName="",this.userPic=""});
  factory NotificationMessagePayload.fromMap(Map<String,dynamic> json){
    return new NotificationMessagePayload(json["isRead"],
        NotificationMessageNotificationPayload.fromMap(json['notification']),
        NotificationMessageDataPayload.fromMap(json['data']),userName: json['userName'],
    userPic: json['userPic']);
  }

  toJson(){
    return {
      "isRead":isRead,
      "notification":notification.toJson(),
      "data":data.toJson(),
      "userName":userName,
      "userPic":userPic
    };
  }

}

class NotificationMessageDataPayload{
  String refId,userId,type,forKeyword,additionalId,callType,click_action,sound;

  NotificationMessageDataPayload(this.refId,this.userId,this.type,this.forKeyword,this.additionalId,
      {this.callType="video",this.click_action="FLUTTER_NOTIFICATION_CLICK",this.sound="sound"});
  factory NotificationMessageDataPayload.fromMap(Map<String,dynamic> json){
    return new NotificationMessageDataPayload(json['refId'],json["userId"],json["type"],
    json['for'],json['additionalId'],callType:json['callType'],click_action: json['click_action'],sound: json['sound']);
  }

  toJson(){
    return {
      "refId":refId,
      "additionalId":additionalId,
      "userId":userId,
      "type":type,
      "for":forKeyword,
      //"callType":callType,
      "click_action":click_action,
      "sound":sound
    };
  }

}

class NotificationMessageNotificationPayload{
  String title,body;

  NotificationMessageNotificationPayload(this.title,this.body);
  factory NotificationMessageNotificationPayload.fromMap(Map<String,dynamic> json){
    return new NotificationMessageNotificationPayload(json["title"],json["body"]);
  }

  toJson(){
    return {
      "title":title,
      "body":body
    };
  }

}