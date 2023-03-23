import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraUtil {

  static Future<void> checkPermissionAndInitialize(BuildContext context) async {
    var statusCamera = await Permission.camera.status;
    var statusStorage = await Permission.storage.status;

    if (statusCamera != PermissionStatus.granted) {
      final permissionStatus = await Permission.camera.request();
      if (!permissionStatus.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Akses kamera dibutuhkan bro")));
      }
    }

    if (statusStorage != PermissionStatus.granted) {
      final permissionStatus = await Permission.storage.request();
      if (!permissionStatus.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Akses storage juga dibutuhkan bro")));
      }
    }
  }

}