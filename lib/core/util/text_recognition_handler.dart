
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class TextRecognitionHandler {

  static const platform = MethodChannel('com.teamdagger.expenseApp/text_recognition');

  Future<LinkedHashMap<dynamic, dynamic>?> getTextFromImageUrl(String url) async {
    Uint8List? imageBinary = await _getBytesFromUrl(url);
    if (imageBinary?.isEmpty == true) {
      return null;
    }
    return await processByteArray(imageBinary!);
  }

  Future<LinkedHashMap<dynamic, dynamic>?> getTextFromImageAsset(String assetPath) async {
    Uint8List? imageBinary = await _getBytesFromAsset(assetPath);
    if (imageBinary?.isEmpty == true) {
      return null;
    }
    return await processByteArray(imageBinary!);
  }

  Future<LinkedHashMap<dynamic, dynamic>?> processByteArray(Uint8List byteArray) async {
    try {
      var result = await platform.invokeMethod("processImage", {"process_image_byte_array" : byteArray});
      debugPrint(byteArray.toString());
      return (result as LinkedHashMap<dynamic, dynamic>);
    } catch(e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Uint8List?> _getBytesFromUrl(String url) async {
    try {
      var response = await http.get(
          Uri.parse(url)
      );
      return response.bodyBytes;
    } catch(e) {
      return null;
    }
  }

  Future<Uint8List?> _getBytesFromAsset(String path) async {
    ByteData data = await rootBundle.load("assets/$path");
    return data.buffer.asUint8List();
  }

}