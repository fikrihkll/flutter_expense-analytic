package com.example.expense_app

import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.latin.TextRecognizerOptions
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.teamdagger.expenseApp/text_recognition"
    private val ACTION_PROCESS_IMAGE = "processImage"
    private val ARG_KEY_PROCESS_IMAGE_BYTE_ARRAY = "process_image_byte_array"
    private val ARG_KEY_PROCESS_IMAGE_ROTATION = "process_image_rotation"
    private val textRecognitionHandler = TextRecognitionHandler(
        TextRecognition.getClient(
            TextRecognizerOptions.DEFAULT_OPTIONS))
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if(call.method == ACTION_PROCESS_IMAGE) {
                val data = call.arguments as HashMap<*, *>
                val byteArrayArg = data[ARG_KEY_PROCESS_IMAGE_BYTE_ARRAY] as ByteArray?
                val rotationArg = data[ARG_KEY_PROCESS_IMAGE_ROTATION] as Double?
                byteArrayArg?.let { byteArray ->
                    textRecognitionHandler.processImage(
                        byteArray = byteArray,
                        rotation = rotationArg?.toInt() ?: 0
                    ) { exception, text ->
                        if (exception != null) {
                            result.error(exception::class.java.name, exception.message, exception)
                        } else {
                            result.success(text)
                        }
                    }
                } ?: result.error(KotlinNullPointerException::class.simpleName ?: "NPE", "Your image can't be decoded", null)
            } else {
                result.notImplemented()
            }
        }
    }
}
