//
//  TextRecognitionHandler.swift
//  Runner
//
//  Created by Fikri Haikal on 31/01/23.
//

import Foundation
import MLKit
import CoreGraphics
import Alamofire

class TextRecognitionHandler {
    
    let textRecognizer = TextRecognizer.textRecognizer(options: TextRecognizerOptions())
    
    func processImage(byteArray:  [UInt8], rotation: CGFloat, resulText: @escaping (String?, [String: Any]?) -> Void) {
        
        // Convert byte array to UIImage
        guard let originalImage = UIImage(data: Data(byteArray)) else {
            resulText("error", nil)
            return
        }

        // Rotate the image if necessary
        let rotatedImage = rotateImage(image: originalImage, degrees: rotation)

        // Create a VisionImage from the rotated image
        let visionImage = VisionImage(image: rotatedImage)
        visionImage.orientation = .up

        // Process the image with the text recognizer
        textRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result else {
                resulText("error", nil)
                return
            }
            var mappedResult = TextMapper.toMap(text: result)
            // Convert the result to a Flutter map and return it
            resulText(nil, mappedResult)
        }
        
    }
    
    func convertImageToBase64(image: UIImage) -> String? {
        if let imageData = image.jpegData(compressionQuality: 0.1) {
            let base64String = imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
            return base64String
        }
        return nil
    }
    
    func rotateImage(image: UIImage, degrees: CGFloat) -> UIImage {
        // Calculate the radians needed to rotate the image
        let radians = degrees * CGFloat.pi / 180.0
        
        // Set the size of the rotated image
        let rotatedSize = CGRect(origin: .zero, size: image.size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .integral.size
        
        // Create a context with the rotated size
        UIGraphicsBeginImageContext(rotatedSize)
        
        // Rotate the context around the center point
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0)
        context.rotate(by: radians)
        
        // Draw the image in the context
        image.draw(in: CGRect(x: -image.size.width / 2.0, y: -image.size.height / 2.0,
                              width: image.size.width, height: image.size.height))
        
        // Create a new image from the context
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return rotatedImage
    }

    func sendBase64ToAPI(image: UIImage) {
        let base64 = convertImageToBase64(image: image)
        
        let url = "http://103.250.11.69:9000/api/send-dummy"
        let parameters: [String: Any] = [
            "message": base64,
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("API request successful with response: \(value)")
                // Handle the response data here
            case .failure(let error):
                print("API request failed with error: \(error)")
                // Handle the error here
            }
        }
    }

}
