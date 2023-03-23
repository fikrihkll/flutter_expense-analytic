//
//  TextRecognitionMapper.swift
//  Runner
//
//  Created by Fikri Haikal on 26/02/23.
//

import MLKit

class TextMapper {
    static let KEY_TEXT = "text"
    static let KEY_TEXT_BLOCKS = "text_blocks"
    static let KEY_LINES = "lines"
    static let KEY_ELEMENTS = "elements"
    static let KEY_SYMBOLS = "symbols"
    static let KEY_CONFIDENCE = "confidence"
    static let KEY_RECOGNIZED_LANGUAGE = "recognized_language"

    static func toMap(text: Text) -> [String: Any] {
        var textBlockArray = [Any]()
        text.blocks.forEach { textBlock in
            textBlockArray.append(TextBlockMapper.toMap(block: textBlock))
        }
        return [
            KEY_TEXT: text.text,
            KEY_TEXT_BLOCKS: textBlockArray
        ]
    }
}

class TextBlockMapper {
    static func toMap(block: TextBlock) -> [String: Any] {
        var linesArray = [[String: Any]]()
        block.lines.forEach { line in
            linesArray.append(LineMapper.toMap(line: line))
        }

        return [
            TextMapper.KEY_TEXT: block.text,
            TextMapper.KEY_RECOGNIZED_LANGUAGE: block.recognizedLanguages.map({obj in
                obj.languageCode ?? "und"
            }).joined(separator: ", "),
            TextMapper.KEY_LINES: linesArray
        ]
    }
}

class LineMapper {
    static func toMap(line: TextLine) -> [String: Any] {
        var elementsArray = [Any]()
        line.elements.forEach { element in
            elementsArray.append(ElementMapper.toMap(element: element))
        }
        return [
            TextMapper.KEY_TEXT: line.text,
            TextMapper.KEY_RECOGNIZED_LANGUAGE: line.recognizedLanguages.map{ $0.languageCode ?? "und" }.joined(separator: ","),
            TextMapper.KEY_ELEMENTS: elementsArray,
            TextMapper.KEY_CONFIDENCE: 0.0
        ]
    }
}

class ElementMapper {
    static func toMap(element: TextElement) -> [String: Any] {
        var symbolsArray = [Any]()
    
        return [
            TextMapper.KEY_TEXT: element.text,
            TextMapper.KEY_RECOGNIZED_LANGUAGE: element.recognizedLanguages.map{ $0.languageCode ?? "und" }.joined(separator: ","),
            TextMapper.KEY_SYMBOLS: symbolsArray,
            TextMapper.KEY_CONFIDENCE: 0.0
        ]
    }
}

