import 'dart:collection';

import 'package:expense_app/features/presentation/entities/text_recognized.dart';

class TextMapper {
  
  static const String keyText = "text";
  static const String keyTextBlocks = "text_blocks";
  static const String keyLines = "lines";
  static const String keyElements = "elements";
  static const String keySymbols = "symbols";
  static const String keyConfidence = "confidence";
  static const String keyRecognizedLanguage = "recognized_language";

  static TextRecognitionResult fromMap(LinkedHashMap<dynamic, dynamic> map) {
    List<TextBlock> textBlocks = [];
    for (var element in (map[keyTextBlocks] as List<dynamic>)) {
      textBlocks.add(TextBlockMapper.fromMap(element));
    }
    return TextRecognitionResult(
      text: map[keyText],
      textBlocks: textBlocks,
    );
  }
}

class TextBlockMapper {
  static TextBlock fromMap(LinkedHashMap<dynamic, dynamic> map) {
    List<Line> lines = [];
    for (var element in (map[TextMapper.keyLines] as List<dynamic>)) {
      lines.add(LineMapper.fromMap(element));
    }
    return TextBlock(
      text: map[TextMapper.keyText],
      recognizedLanguage: map[TextMapper.keyRecognizedLanguage],
      lines: lines,
    );
  }
}

class LineMapper {
  static Line fromMap(LinkedHashMap<dynamic, dynamic> map) {
    List<Element> elements = [];
    for (var element in (map[TextMapper.keyElements] as List<dynamic>)) {
      elements.add(ElementMapper.fromMap(element));
    }
    return Line(
      text: map[TextMapper.keyText],
      recognizedLanguage: map[TextMapper.keyRecognizedLanguage],
      elements: elements,
      confidence: map[TextMapper.keyConfidence],
    );
  }
}

class ElementMapper {
  static Element fromMap(LinkedHashMap<dynamic, dynamic> map) {
    List<Symbol> symbols = [];
    for (var element in (map[TextMapper.keySymbols] as List<dynamic>)) {
      symbols.add(SymbolMapper.fromMap(element));
    }
    return Element(
      text: map[TextMapper.keyText],
      recognizedLanguage: map[TextMapper.keyRecognizedLanguage],
      symbols: symbols,
      confidence: map[TextMapper.keyConfidence],
    );
  }
}

class SymbolMapper {
  static Symbol fromMap(LinkedHashMap<dynamic, dynamic> map) {
    return Symbol(
      text: map[TextMapper.keyText],
      recognizedLanguage: map[TextMapper.keyRecognizedLanguage],
      confidence: map[TextMapper.keyConfidence],
    );
  }
}
