class ScheduleMessage{
  String id,message,createdAt,userId,freelancerId;

  ScheduleMessage({this.id="",this.message="", this.createdAt="", this.userId="", this.freelancerId=""});

  factory ScheduleMessage.fromJson(Map<String,dynamic> json){
    if(json['freelancerId']==null){
      return new ScheduleMessage(message:json['message'] as String,createdAt: json['createdAt'] as String,
          userId:json['userId']=="" ?"":json['userId'] as String);
    }else {
      return new ScheduleMessage(message: json['message'] as String,
          createdAt: json['createdAt'] as String,
          userId: json['userId'] == ""||json['userId']==null ? "" : json['userId'] as String,
        freelancerId: json['freelancerId'] == ""||json['freelancerId']==null ? "" : json['freelancerId'] as String,
         );
    }
  }
}