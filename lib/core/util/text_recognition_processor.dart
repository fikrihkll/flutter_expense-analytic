import 'dart:collection';
import 'package:expense_app/features/domain/entities/text_recognized.dart';
import 'package:expense_app/features/domain/entities/text_recognized_mapper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

abstract class TextRecognitionProcessor {

  Future<LinkedHashMap<dynamic, dynamic>?> processByteArray(Uint8List byteArray, {double rotation = 0});
  Future<Uint8List?> getBytesFromUrl(String url);
  Future<Uint8List?> getBytesFromAsset(String path);
  TextRecognitionResult? map(LinkedHashMap<dynamic, dynamic>? map);

}

class TextRecognitionProcessorImpl implements TextRecognitionProcessor {

  final platform = const MethodChannel('com.teamdagger.expenseApp/text_recognition');

  @override
  Future<Uint8List?> getBytesFromAsset(String path) async {
    try {
      ByteData data = await rootBundle.load(path);
      return data.buffer.asUint8List();
    } catch(e) {
      if (kDebugMode) {
        print("ImageAssetParserException: ${e.toString()}");
      }
      return null;
    }
  }

  @override
  Future<Uint8List?> getBytesFromUrl(String url) async {
    try {
      var response = await http.get(
          Uri.parse(url)
      );
      return response.bodyBytes;
    } catch(e) {
      if (kDebugMode) {
        print("ImageUrlFetchException: ${e.toString()}");
      }
      return null;
    }
  }

  @override
  Future<LinkedHashMap?> processByteArray(Uint8List byteArray, {double rotation = 0}) async {
    try {
      var result = await platform.invokeMethod("processImage", {"process_image_byte_array" : byteArray, "process_image_rotation": rotation});
      return (result as LinkedHashMap<dynamic, dynamic>);
    } catch(e) {
      if (kDebugMode) {
        print("ImageToTextException: ${e.toString()}");
      }
      return null;
    }
  }

  @override
  TextRecognitionResult? map(LinkedHashMap? map) {
    if (map != null) {
      return TextMapper.fromMap(map);
    } else {
      return null;
    }
  }

}