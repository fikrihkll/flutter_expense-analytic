package com.example.expense_app

import com.google.mlkit.vision.text.Text

object TextMapper {

    const val KEY_TEXT = "text"
    const val KEY_TEXT_BLOCKS = "text_blocks"
    const val KEY_LINES = "lines"
    const val KEY_ELEMENTS = "elements"
    const val KEY_SYMBOLS = "symbols"
    const val KEY_CONFIDENCE = "confidence"
    const val KEY_RECOGNIZED_LANGUAGE = "recognized_language"
    
    fun toMap(text: Text): MutableMap<String, Any> {
        val textBlockArray = mutableListOf<Any>()
        text.textBlocks.forEach { textBlock ->
            textBlockArray.add(TextBlockMapper.toMap(textBlock))
        }
        return mutableMapOf(
            KEY_TEXT to text.text,
            KEY_TEXT_BLOCKS to textBlockArray
        )
    }
}

object TextBlockMapper {
    fun toMap(block: Text.TextBlock): MutableMap<String, Any> {
        val linesArray = mutableListOf<MutableMap<String, Any>>()
        block.lines.forEach { line ->
            linesArray.add(LineMapper.toMap(line))
        }

        return mutableMapOf(
            TextMapper.KEY_TEXT to block.text,
            TextMapper.KEY_RECOGNIZED_LANGUAGE to block.recognizedLanguage,
            TextMapper.KEY_LINES to linesArray,
        )
    }
}

object LineMapper {
    fun toMap(line: Text.Line): MutableMap<String, Any> {
        val elementsArray = mutableListOf<Any>()
        line.elements.forEach { element ->
            elementsArray.add(ElementMapper.toMap(element))
        }
        return mutableMapOf(
            TextMapper.KEY_TEXT to line.text,
            TextMapper.KEY_RECOGNIZED_LANGUAGE to line.recognizedLanguage,
            TextMapper.KEY_ELEMENTS to elementsArray,
            TextMapper.KEY_CONFIDENCE to line.confidence
        )
    }
}

object ElementMapper {
    fun toMap(element: Text.Element): MutableMap<String, Any> {
        val symbolsArray = mutableListOf<Any>()
        element.symbols.forEach { symbol ->
            symbolsArray.add(SymbolMapper.toMap(symbol))
        }
        return mutableMapOf(
            TextMapper.KEY_TEXT to element.text,
            TextMapper.KEY_RECOGNIZED_LANGUAGE to element.recognizedLanguage,
            TextMapper.KEY_SYMBOLS to symbolsArray,
            TextMapper.KEY_CONFIDENCE to element.confidence
        )
    }
}

object SymbolMapper {
    fun toMap(symbol: Text.Symbol): Map<String, Any> {
        return mapOf(
            TextMapper.KEY_TEXT to symbol.text,
            TextMapper.KEY_RECOGNIZED_LANGUAGE to symbol.recognizedLanguage,
            TextMapper.KEY_CONFIDENCE to symbol.confidence
        )
    }
}
