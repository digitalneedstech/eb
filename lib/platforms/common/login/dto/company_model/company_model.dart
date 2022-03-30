class CompanyModel{
  String companyName,web,overview,industry,companyPic;
  CompanyModel({this.companyName="",this.web="",this.overview="",this.companyPic="",this.industry=""});

  factory CompanyModel.fromMap(Map<String,dynamic> json){
    return new CompanyModel(
        industry: json['industry'] ?? "",
        companyPic: json['companyPic'] ?? "",
        web: json['web'] ?? "",
        overview: json['overview'] ?? "",
      companyName: json['companyName'] ?? ""
    );
  }

  toJson(){
    return {
      "industry":industry,
      "companyPic":companyPic,
      "companyName":companyName,
      "companyOverview":overview,
      "web":web
    };
  }
}