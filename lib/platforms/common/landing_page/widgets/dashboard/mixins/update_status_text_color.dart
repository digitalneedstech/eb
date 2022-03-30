import 'package:flutter/material.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
mixin UpdateStatusText{
  String status = "Waiting For Approval";

  Color statusColor = Color(0xFFFFEFC5);
  Color statusTextColor = Color(0xFFC18B09);

  updateStatusText(String statusVal){
    if (status == "Pending" || statusVal=="pending") {
      status = "Waiting For Approval";
      statusColor = Color(0xFFFFEFC5);
      statusTextColor = Color(0xFFC18B09);
    }
    else if (statusVal=="accepted" || statusVal=="Accepted") {
      status = "Accepted";
      statusColor = Color(0xFF1DC39A);
      statusTextColor = Colors.white;
    } else if (statusVal=="Rejected" || statusVal=="rejected") {
      status = "Rejected";
      statusColor = Color(0xFFFFDBD9);
      statusTextColor = Color(0xFFF94646);
    }
  }
}