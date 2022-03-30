// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************


PostModel _$PostModelFromJson(
    Map<String, dynamic> json,String id ) {
  if(json['tenure'] is int){
    return PostModel(
        id: id,
        createdAt: (json['createdAt'] as Timestamp).toString(),
        title: json['title'] as String,
        industry: json['industry'] as String,
        tenure: json['tenure'].toString(),
        skills:List.from(json['skills']) ,
        info: json['info'] as String,
        postedBy: json['postedBy'] as String,
        isActive: json['isActive'] as bool
    );
  }
  return PostModel(
    id: id,
      title: json['title'] as String,
      industry: json['industry'] as String,
      tenure: json['tenure'] as String,
      skills:List.from(json['skills']) ,
      info: json['info'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate().toIso8601String(),
      postedBy: json['postedBy'] as String,
      isActive: json['isActive'] as bool
  );
}

Map<String, dynamic> _$PostModelToJson(
    PostModel instance) =>
    <String, dynamic>{
      'title':instance.title,
      'postedBy':instance.postedBy,
      'createdAt':instance.createdAt==""? DateTime.now():DateTime.parse(instance.createdAt),
      'industry':instance.industry,
      'tenure':instance.tenure,
      'skills':instance.skills,
      'info':instance.info,
      'isActive':instance.isActive
    };
