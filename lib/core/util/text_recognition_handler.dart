
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class TextRecognitionHandler {

  static const platform = MethodChannel('com.teamdagger.expenseApp/text_recognition');

  Future<String?> getTextFromImageUrl(String url) async {
    Uint8List? imageBinary = await _getBytesFromUrl(url);
    if (imageBinary?.isEmpty == true) {
      return null;
    }
    return await processByteArray(imageBinary!);
  }

  Future<String?> getTextFromImageAsset(String assetPath) async {
    Uint8List? imageBinary = await _getBytesFromAsset(assetPath);
    if (imageBinary?.isEmpty == true) {
      return null;
    }
    return await processByteArray(imageBinary!);
  }

  Future<String?> processByteArray(Uint8List byteArray) async {
    try {
      return await platform.invokeMethod("processImage", {"process_image_byte_array" : byteArray});
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