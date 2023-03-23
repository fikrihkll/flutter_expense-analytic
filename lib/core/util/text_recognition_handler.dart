import 'package:expense_app/core/util/text_recognition_processor.dart';
import 'package:expense_app/features/domain/entities/text_recognized.dart';
import 'package:flutter/services.dart';


class TextRecognitionHandler {

  final TextRecognitionProcessor _textRecognitionProcessor = TextRecognitionProcessorImpl();

  Future<TextRecognitionResult?> getTextFromImageUrl(String url, {double rotation = 0}) async {
    Uint8List? imageBinary = await _textRecognitionProcessor.getBytesFromUrl(url);
    if (imageBinary?.isEmpty == true) {
      return null;
    }
    var result = await _textRecognitionProcessor.processByteArray(imageBinary!, rotation: rotation);
    return _textRecognitionProcessor.map(result);
  }

  Future<TextRecognitionResult?> getTextFromImageAsset(String assetPath, {double rotation = 0}) async {
    Uint8List? imageBinary = await _textRecognitionProcessor.getBytesFromAsset(assetPath);
    if (imageBinary?.isEmpty == true) {
      return null;
    }
    var result = await _textRecognitionProcessor.processByteArray(imageBinary!, rotation: rotation);
    return _textRecognitionProcessor.map(result);
  }

  Future<TextRecognitionResult?> getTextFromImageBytes(Uint8List bytes, {double rotation = 0}) async {
    var result = await _textRecognitionProcessor.processByteArray(bytes, rotation: rotation);
    return _textRecognitionProcessor.map(result);
  }

}