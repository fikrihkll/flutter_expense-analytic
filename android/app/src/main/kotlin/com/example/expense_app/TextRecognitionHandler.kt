package com.example.expense_app

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.ImageFormat
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.Text
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.TextRecognizer
import com.google.mlkit.vision.text.latin.TextRecognizerOptions

class TextRecognitionHandler(private val recognizer: TextRecognizer) {

    fun processImage(byteArray: ByteArray, rotation: Int = 0, result: (Exception?, String?) -> Unit) {
        val image = InputImage.fromBitmap(getBitmap(byteArray), rotation)
        recognizer.process(image).addOnSuccessListener {
            result.invoke(null, it.text)
        }.addOnFailureListener {
            result.invoke(it, null)
        }
    }

    private fun getBitmap(byteArray: ByteArray): Bitmap {
        return BitmapFactory.decodeByteArray(byteArray, 0, byteArray.size)
    }

}