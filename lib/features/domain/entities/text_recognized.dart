class BaseTextRecognitionEntity {
  String text;
  String recognizedLanguage;

  BaseTextRecognitionEntity(this.text, this.recognizedLanguage);
}

class TextRecognitionResult {
  List<TextBlock> textBlocks;
  String text;

  TextRecognitionResult({
    required this.text,
    required this.textBlocks,
  });
}

class TextBlock extends BaseTextRecognitionEntity {

  List<Line> lines;

  TextBlock({
    required String text,
    required String recognizedLanguage,
    required this.lines,
  }) : super(text, recognizedLanguage);
}

class Line extends BaseTextRecognitionEntity {
  List<Element> elements;
  double confidence;

  Line({
    required String text,
    required String recognizedLanguage,
    required this.elements,
    required this.confidence,
  }) : super(text, recognizedLanguage);
}

class Element extends BaseTextRecognitionEntity {
  List<Symbol> symbols;
  double confidence;

  Element({
    required String text,
    required String recognizedLanguage,
    required this.symbols,
    required this.confidence,
  }) : super(text, recognizedLanguage);
}

class Symbol extends BaseTextRecognitionEntity {
  double confidence;

  Symbol({
    required String text,
    required String recognizedLanguage,
    required this.confidence,
  }) : super(text, recognizedLanguage);
}

