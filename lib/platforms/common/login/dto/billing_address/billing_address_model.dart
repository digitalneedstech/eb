class BillingAddressModel{
  String address1,address2,city,state,country,gstNo;
  int zipCode;
  BillingAddressModel({this.address1="",this.address2="",this.country="",this.city="",
    this.state="",this.gstNo="0",this.zipCode=0});
  factory BillingAddressModel.fromMap(Map<String,dynamic> json){
    return new BillingAddressModel(
      address1: json['address1'],
      address2: json['address2'],
      city: json['city'],
      country: json['country'],
      gstNo: json['gstNo'],
      state: json['state'],
      zipCode: json['zip_code']
    );
  }
  toJson(){
    return{
      "address1":address1,
      "address2":address2,
      "city":city,
      "state":state,
      "gstNo":gstNo,
      "zip_code":zipCode,
      "country":country
    };
  }
}