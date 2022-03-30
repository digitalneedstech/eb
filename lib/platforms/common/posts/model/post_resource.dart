class PostByFreelancer{
  String freelancerId,freelancerName,freelancerPic,freelancerDescription,status;
  PostByFreelancer({this.freelancerId="",this.freelancerName="",this.freelancerDescription="",
    this.freelancerPic="",this.status=""});
  factory PostByFreelancer.fromMap(Map<String,dynamic> json){
    return new PostByFreelancer(
      status: json['status'] as String,
      freelancerName: json['freelancerName'] as String,
      freelancerId: json['freelancerId'] as String,
      freelancerPic: json['freelancerName'] as String,
      freelancerDescription: json['freelancerDescription'] as String
    );

  }

  toJson(){
    return{
      "freelancerId":freelancerId,
      "freelancerPic":freelancerPic,
      "freelancerName":freelancerName,
      "createdAt":DateTime.now().toIso8601String(),
      "status":status,
      "freelancerDescription":freelancerDescription
    };
  }
}