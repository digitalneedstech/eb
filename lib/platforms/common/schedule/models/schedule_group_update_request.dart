class ScheduleUpdateGroupRequest{
  String id,groupId,freelancerId,status,freelancerName;
  ScheduleUpdateGroupRequest({this.id="",this.groupId="",this.freelancerId="",
    this.status="",this.freelancerName=""});
  toJson(){
    return{
      "id":id,
      "freelancerId":freelancerId,
      "groupId":groupId,
      "status":status
    };
  }
}