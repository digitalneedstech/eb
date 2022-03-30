class CompanyResource{
  String id,companyName,status;
  int hourlyRate,minBid;
  bool isNegotiable,active;

  CompanyResource({
      this.id="", this.companyName="",this.status="pending",this.hourlyRate=0,
    this.minBid=0, this.isNegotiable=false, this.active=false});
  factory CompanyResource.fromMap(Map<String,dynamic> json,String id){
    return CompanyResource(
      companyName: json['companyName']==null ? "":json['companyName'] as String,
      id: id,
      status: json['status'] as String,
      active: json['active']==null?false: json['active'] as bool,
      hourlyRate: json['hourlyRate']==null ? 0:json['hourlyRate'] as int,
      isNegotiable: json['isNegotiable']==null ? false:json['isNegotiable'] as bool,
      minBid: json['minBid']==null ?0:json['minBid'] as int
    );
  }
  toJson(){
    return{
      "id":id,
      "companyName":companyName,
      "status":status,
      "active":active,
      "hourlyRate":hourlyRate,
      "isNegotiable":isNegotiable,
      "minBid":minBid,
    };
  }
}