class ScheduleUpdateRequest{
  String id,userId,status;
  ScheduleUpdateRequest({this.id="",this.userId="",this.status=""});
  toJson(){
    return{
      "id":id,
      "userId":userId,
      "status":status
    };
  }
}