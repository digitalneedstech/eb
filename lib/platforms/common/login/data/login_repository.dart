import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/company/model/resource_model.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/affiliate_model/affiliate_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/feedback/user_feedback.dart';
import 'package:flutter_eb/platforms/common/login/dto/token_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/skills/skill_info_dto_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final collectionInstance = FirebaseFirestore.instance.collection('users');
  final utilsCollectionInstance = FirebaseFirestore.instance.collection('utils');
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<DocumentSnapshot> addorUpdateRecord(UserDTOModel userDTOModel) async {
    this
        .collectionInstance
        .doc(userDTOModel.userId)
        .set(userDTOModel.toJson());

    /*if (userDTOModel.skills.isNotEmpty) {
      for (SkillInfoDTOModel skill in userDTOModel.skills) {
        List<dynamic> skills = [];
        DocumentSnapshot snapshot =
        await this.utilsCollectionInstance.doc("filters").get();
        if ((snapshot.data() as Map<String,dynamic>)["skills"] != null) {
          skills = (snapshot.data() as Map<String,dynamic>)["skills"] as List<dynamic>;
          List<String> finalSkills = skills.map((e) => e.toString()).toList();
          if (finalSkills.where((element) => element == skill.skill).isEmpty) {
            finalSkills.add(skill.skill);
            (snapshot.data() as Map<String,dynamic>)["skills"]=finalSkills;
            this
                .utilsCollectionInstance
                .doc("filters")
                .set(snapshot.data() as Map<String,dynamic>, SetOptions(merge: true));
          }
        }
      }
    }*/
  /*  if (userDTOModel.skills.isNotEmpty) {
      for (SkillInfoDTOModel skill in userDTOModel.skills) {
        List<dynamic> skills = [];
        DocumentSnapshot snapshot =
        await this.utilsCollectionInstance.doc("filters").get();
        if (snapshot.data() as Map<String,dynamic>["skills"] != null) {
          skills = (snapshot.data() as Map<String,dynamic>["skills"] as List<dynamic>);
          List<String> finalSkills = skills.map((e) => e.toString()).toList();
          if (finalSkills.where((element) => element == skill.skill).isEmpty) {
            finalSkills.add(skill.skill);
            snapshot.data() as Map<String,dynamic>["skills"]=finalSkills;
            this
                .utilsCollectionInstance
                .doc("filters")
                .set(snapshot.data() as Map<String,dynamic>, merge: true);
          }
        }
      }
    }
    if(userDTOModel.languages.isNotEmpty){
      for (String language in userDTOModel.languages) {
        List<dynamic> languages = [];
        DocumentSnapshot snapshot =
        await this.utilsCollectionInstance.doc("filters").get();
        if (snapshot.data() as Map<String,dynamic>["languages"] != null) {
          languages = (snapshot.data() as Map<String,dynamic>["languages"] as List<dynamic>);
          List<String> finalLanguages = languages.map((e) => e.toString()).toList();
          if (finalLanguages.where((element) => element == language).isEmpty) {
            finalLanguages.add(language);
            snapshot.data() as Map<String,dynamic>["languages"]=finalLanguages;
            this
                .utilsCollectionInstance
                .doc("filters")
                .set(snapshot.data() as Map<String,dynamic>, merge: true);
          }
        }
      }
    }*/
    return getUserByUid(userDTOModel.userId);
  }

  updateAffiliateRecord(
      String senderId, String email, String userId, String userName) async {
    QuerySnapshot snapshot = await this
        .collectionInstance
        .doc(senderId)
        .collection("myaffiliates")
        .where("email", isEqualTo: email)
        .get();
    for (DocumentSnapshot documentSnapshot in snapshot.docs) {
      AffiliateModel affiliateModel =
          AffiliateModel.fromMap(documentSnapshot.data() as Map<String,dynamic>);
      affiliateModel.isAccepted = true;
      affiliateModel.userId = email;
      affiliateModel.userName = email;
      this
          .collectionInstance
          .doc(senderId)
          .collection("myaffiliates")
          .doc(documentSnapshot.id)
          .set(affiliateModel.toJson(), SetOptions(merge: true));
    }
  }

  updateMyCompanyRecord(String senderId, String email, String userId) async {
    this
        .collectionInstance
        .doc(senderId)
        .collection("myResources")
        .doc(email)
        .set({
      "status": "accepted",
      "id":userId,
      "createdAt": DateTime.now().toIso8601String()
    },SetOptions(merge: true));
  }

  Future<dynamic> addAffiliateRecord(String affiliateEmail, String senderId) async{
    AffiliateModel affiliateModel = new AffiliateModel(
        isAccepted: false,
        createdAt: DateTime.now().toIso8601String(),
        email: affiliateEmail);
    QuerySnapshot snapshot=await this.collectionInstance
        .doc(senderId)
        .collection("myAffiliates")
        .where("email",isEqualTo: affiliateEmail)
        .get();
    if(snapshot.docs.isNotEmpty){
          return "Already Sent";
    }else {
      return this
          .collectionInstance
          .doc(senderId)
          .collection("myAffiliates")
          .add(affiliateModel.toJsonForInvite());
    }
  }

  Future<void> updateUser(UserDTOModel userDTOModel) async {
    this
        .collectionInstance
        .doc(userDTOModel.userId)
        .set(userDTOModel.toJson());
  }

  Future<QuerySnapshot> getAffiliatesList(String userId) {
    return this
        .collectionInstance
        .doc(userId)
        .collection("myAffiliates")
        .get();
  }

  Future<QuerySnapshot> getAcceptedAffiliatesList(String userId) {
    return this
        .collectionInstance
        .doc(userId)
        .collection("myAffiliates")
        .where("status", isEqualTo: "accepted")
        .get();
  }

  Future<QuerySnapshot> getAcceptedResourcesList(String userId) {
    return this
        .collectionInstance
        .doc(userId)
        .collection("myResources")
        .where("status", isEqualTo: "accepted")
        .get();
  }

  Future<QuerySnapshot> getAffiliateTransactions(String id) {
    return this
        .collectionInstance
        .doc(id)
        .collection("transactions")
        .where("type", isEqualTo: "affiliate")
        .get();
  }

  Future<DocumentSnapshot> getUserByUid(String uId) async {
    return await this.collectionInstance.doc(uId).get();
  }

  Future<QuerySnapshot> getUserByEmail(String email) async {
    return await this
        .collectionInstance
        .where("personalDetails.email", isEqualTo: email)
        .get();
  }

  Future<dynamic> registerUser(String email, String password) async {
    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user!;
      return user;
    }  on FirebaseAuthException catch(e) {
      switch (e.code) {
        case 'weak-password':
          return "Please Use String Passord";
        case 'invalid-email':
          return "Please use valid email";
        case 'email-already-in-use':
          return "Email is already in use";
        default:
          return "Email Account is not valid";
      }
    }
  }

  Future<dynamic> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user!;

      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return "User Not Found";
        case 'wrong-password':
          return "Password is wrong";
        case 'invalid-email':
          return "Email Is Invalid";
        case 'user-disabled':
          return "Email Is Disabled";
        case 'ERROR_TOO_MANY_REQUESTS':
          return "There are too many requests with same EmailID. Try a different One.";
        case 'user-disabled':
          return "Sign In Not allowed for this user";
        default:
          return "There was some error from server side";
      }
    }
  }

  Future<dynamic> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = (await googleSignIn.signIn())!;
    User user;
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        UserCredential authResult = await _auth.signInWithCredential(credential);
        user = authResult.user!;
        return user;
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'invalid-credential':
            return "Invalid Credentials";
          case 'user-disabled':
            return "User is disabled";
          case 'account-exists-with-different-credential':
            return "Account exists in system with different credentials";
          case 'operation-not-allowed':
            return "Google account is not enabled";
          default:
            return "Network is Not Reachable";
        }
      }
    }
  }

  Future<dynamic> sendPasswordResetMail(String emailId) async {
    try {
      await _auth.sendPasswordResetEmail(email: emailId);
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          return "Email Is Invalid";
        case 'ERROR_USER_NOT_FOUND':
          return "User Not Found";
        default:
          return "Invalid Credentials";
      }
    }
  }

  void addTokenToUser(String userId, TokenModel tokenModel) async {
    QuerySnapshot snapshot = await this
        .collectionInstance
        .doc(userId)
        .collection("token")
        .get();
    for (DocumentSnapshot doc in snapshot.docs) {
      this
          .collectionInstance
          .doc(userId)
          .collection("token")
          .doc("token")
          .delete();
    }
    this
        .collectionInstance
        .doc(userId)
        .collection("token")
        .doc("token")
        .set(tokenModel.toJson());
  }

  googleSignOut() {
    googleSignIn.signOut();
  }

  Future<QuerySnapshot> fetchFeaturedFreelancersList() {
    return this
        .collectionInstance
        .where("isFeatured", isEqualTo: true)
        .orderBy("avgRatings", descending: true)
        .get();
  }

  addFeedback(UserFeedbackModel userFeedbackModel, String userId) async {
    await this
        .collectionInstance
        .doc(userId)
        .collection("feedbacks")
        .add(userFeedbackModel.toJson());
  }

  Future<QuerySnapshot> getFeedbacks(String userId) async {
    return this
        .collectionInstance
        .doc(userId)
        .collection("feedbacks")
        .get();
  }
}
