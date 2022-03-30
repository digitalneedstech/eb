import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_eb/shared/services/notification/model/notification_message.dart';

class NotificationRepository {
  Dio dio;
  NotificationRepository(this.dio);
  final String TRIGGER_API =
      "https://46mbjojgi3.execute-api.ap-south-1.amazonaws.com/prod/event-listner";
  final userCollectionInstance = FirebaseFirestore.instance.collection('users');
  Future<bool> sendNotification(dynamic notificationMessage) async {
    var object={};
    if(notificationMessage is NotificationMessage){
      object=notificationMessage.toJson();
    }
    else if(notificationMessage is NotificationMessageNotificationModel) {
      object = notificationMessage.toJson();
      print(object);
    }
    try {
      Response response =
          await dio.post(TRIGGER_API, data: object);
      return true;
    } on DioError catch (e) {
      return false;
    }
  }

  Future<void> sendMultipleNotifications(
      List<NotificationMessage> notificationMessages) async {
    for (NotificationMessage notificationMessage in notificationMessages) {
      sendNotification(notificationMessage);
    }
  }

  Future<QuerySnapshot> fetchNotifications(String id) async {
    return this
        .userCollectionInstance
        .doc(id)
        .collection("notifications")
        .orderBy("createdAt",descending: true)
        .get();
  }
}
