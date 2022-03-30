import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_eb/platforms/common/company/bloc/company_operation/company_operation_bloc.dart';
import 'package:flutter_eb/platforms/common/company/model/resource_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';

class CompanyRepository {
  final companyCollection = FirebaseFirestore.instance.collection("users");
  Future<dynamic> getResources(String userId,String freelancerSearchText) async {
    Map<dynamic, CompanyResource> userCompanyVal = {};
    Map<dynamic, CompanyResource> finalUserCompanyVal = {};
    Map<dynamic,CompanyResource> sortedCompanyVal={};
    QuerySnapshot snapshot = await this
        .companyCollection
        .doc(userId)
        .collection("myResources")
        .get();
    for (DocumentSnapshot documentSnapshot in snapshot.docs) {
      QuerySnapshot userSnapshot = await this
          .companyCollection
          .where("personalDetails.email",
              isEqualTo: documentSnapshot.id)
          .get();
      if (!userSnapshot.docs.isEmpty) {
        UserDTOModel userDTOModel = UserDTOModel.fromJson(
            userSnapshot.docs[0].data() as Map<String,dynamic>,
            userSnapshot.docs[0].id);
        userCompanyVal[userDTOModel] =
            CompanyResource.fromMap(documentSnapshot.data() as Map<String,dynamic>,documentSnapshot.id);
      }
      else{
        userCompanyVal[documentSnapshot.id]=CompanyResource.fromMap(documentSnapshot.data() as Map<String,dynamic>,
        documentSnapshot.id);
      }
      //  users.add(UserDTOModel.fromJson(documentSnapshot.data() as Map<String,dynamic>,documentSnapshot.id));
    }

    if(freelancerSearchText!="") {
      userCompanyVal.forEach((key, value) {
        if(key is UserDTOModel){
          UserDTOModel userDTOModel=key;
          if(userDTOModel.personalDetails.email==freelancerSearchText){
            finalUserCompanyVal[key]=value;
          }
          if(userDTOModel.personalDetails.displayName==freelancerSearchText){
            finalUserCompanyVal[key]=value;
          }
        }
        else {
          if (key == freelancerSearchText)
            finalUserCompanyVal[key] = value;
        }
      });
      return finalUserCompanyVal;
    }
    return userCompanyVal;
  }

  void addResourceToCompany(
      String userId, Map<String, AddResourceModelValidator> companyResources) async {
    for (String resource in companyResources.keys) {
      AddResourceModelValidator value = companyResources[resource]!;
      if (value.toBeAdded) {
        this
            .companyCollection
            .doc(userId)
            .collection("myResources")
            .doc(resource)
            .set({
          "id": resource,
          "status": "pending",
          "createdAt": DateTime.now().toIso8601String()
        });
        if (!value.isNewUser) {
          this
              .companyCollection
              .doc(resource)
              .collection("requestedCompanies")
              .doc(userId)
              .set({
            "companyId": userId,
            "createdAt": DateTime.now().toIso8601String()
          });
        }
      }
    }
  }

  updateResourceInCompany(
      String companyId, String userId, String status) async {
    SetOptions setOptions=new SetOptions(
      merge: true
    );
    this
        .companyCollection
        .doc(companyId)
        .collection("myResources")
        .doc(userId)
        .set({
      "id": userId,
      "status": status,
      "updatedAt": DateTime.now().toIso8601String()
    },setOptions);
  }
}
