import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void handleInvalidPermissions(
  PermissionStatus cameraPermissionStatus,
  PermissionStatus microphonePermissionStatus,
) {
  if (cameraPermissionStatus == PermissionStatus.denied &&
      microphonePermissionStatus == PermissionStatus.denied) {
    throw new PlatformException(
        code: "PERMISSION_DENIED",
        message: "Access to camera and microphone denied",
        details: null);
  } else if (cameraPermissionStatus == PermissionStatus.restricted ||
      microphonePermissionStatus == PermissionStatus.restricted) {
    throw new PlatformException(
        code: "PERMISSION_DISABLED",
        message: "Location data is not available on device",
        details: null);
  }
}
