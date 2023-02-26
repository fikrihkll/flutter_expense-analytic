import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    let ARG_KEY_PROCESS_IMAGE_BYTE_ARRAY = "process_image_byte_array"
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let channel = FlutterMethodChannel(name: "com.teamdagger.expenseApp/text_recognition", binaryMessenger: controller.binaryMessenger)
      
      channel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          if call.method == "processImage" {
              let data = call.arguments as? Dictionary<String, Any>
              let argByteArray = data?[self.ARG_KEY_PROCESS_IMAGE_BYTE_ARRAY] as? FlutterStandardTypedData
              
              var byteArray = [UInt8]()
              argByteArray?.data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
                  byteArray = [UInt8](bytes)
              }

              guard byteArray.count > 0 else {
                  result(FlutterError(code: "MLKit-TextRecognition", message: "Failed to process image", details: nil))
                  return
              }
              
              self.processImageToText(byteArray: byteArray, result: result)
          } else {
              result(FlutterMethodNotImplemented)
          }
      })

      
      
      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func processImageToText(byteArray: [UInt8], result: @escaping FlutterResult) {
        let textRecognition = TextRecognitionHandler()
        textRecognition.processImage(byteArray: byteArray, resulText: {(errorMessage, textResult) in
            guard errorMessage == nil else {
                result(FlutterError(code: "MLKit-TextRecognition", message: errorMessage, details: nil))
                return
            }
            result(textResult ?? [String: Any]())
        })
    }
    
}
