import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

class ProfileRepository{
  final collectionInstance = FirebaseFirestore.instance.collection('users');
  Dio dio;
  ProfileRepository(this.dio);
  final String sendOtpPostUrl="https://fr73vheuyh.execute-api.ap-south-1.amazonaws.com/prod/auth/send-otp";
  final String verifyOTPPostUrl="https://fr73vheuyh.execute-api.ap-south-1.amazonaws.com/prod/auth/verify";
  Future<bool> sendOTP(String mobileNumber) async{
    // TODO: implement getRequest

    Response response;
    try {
      response = await dio.post(sendOtpPostUrl,
      data: {
        "mobile_number":mobileNumber
      });
      return true;
    } on DioError catch (e) {
      /*print(e.message);
      throw Exception(e.message);*/
      return false;
    }
  }

  Future<bool> verifyOtp(String mobileNumber,String otp) async{
    Response response;
    try {
      response = await dio.patch(verifyOTPPostUrl,
          data: {
            "mobile_number":mobileNumber,
            "otp":otp
          });
      return true;
    } on DioError catch (e) {
      return false;
    }
  }

  Future<DocumentSnapshot> getUserByEmail(String emailId){
    return this.collectionInstance.doc(emailId).get();
  }
}