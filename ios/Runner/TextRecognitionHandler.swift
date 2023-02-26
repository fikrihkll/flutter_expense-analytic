//
//  TextRecognitionHandler.swift
//  Runner
//
//  Created by Fikri Haikal on 31/01/23.
//

import Foundation
import MLKit
import CoreGraphics

class TextRecognitionHandler {
    
    let textRecognizer = TextRecognizer.textRecognizer()
    
    func processImage(byteArray:  [UInt8], resulText: @escaping (String?, [String: Any]?) -> Void) {
        let uiImage = UIImage(data: Data(byteArray))!
        let image = VisionImage(image: uiImage)
        textRecognizer.process(image) { result, error in
            guard error == nil, let result = result else {
                resulText(error?.localizedDescription, nil)
              return
            }
            resulText(nil, TextMapper.toMap(text: result))
        }
    }
    
}
