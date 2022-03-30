
class QueryModel {
  Set<String> languages,skills,profileTitle,industry,countries,experiences,ratings;
  int experienceStartVal,experienceEndVal;
  double ratingStartVal,ratingEndVal;

  QueryModel({this.experienceEndVal=0,
    this.experienceStartVal=0,this.industry=const <String>{},
    this.ratingEndVal=0.0,this.ratingStartVal=0.0,
    this.countries=const <String>{},
    this.profileTitle=const <String>{}, this.languages=const <String>{},
    this.skills=const <String>{},this.experiences=const <String>{},this.ratings=const <String>{}});
}