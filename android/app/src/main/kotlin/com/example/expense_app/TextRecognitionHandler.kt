package com.example.expense_app

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.ImageFormat
import android.graphics.Matrix
import android.util.Base64
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.Text
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.TextRecognizer
import com.google.mlkit.vision.text.latin.TextRecognizerOptions

class TextRecognitionHandler(private val recognizer: TextRecognizer) {

    fun processImage(byteArray: ByteArray, rotation: Int = 0, result: (Exception?, Map<String, Any>?) -> Unit) {
        val image = InputImage.fromBitmap(getBitmap(byteArray, rotation), 0)
        recognizer.process(image).addOnSuccessListener {
            result.invoke(null, TextMapper.toMap(it))
        }.addOnFailureListener {
            result.invoke(it, null)
        }
    }

    private fun getBitmap(byteArray: ByteArray, rotation: Int): Bitmap {
        return rotateBitmap(BitmapFactory.decodeByteArray(byteArray, 0, byteArray.size), rotation)
    }

    private fun rotateBitmap(bitmap: Bitmap, rotation: Int): Bitmap {
        val matrix = Matrix()
        matrix.postRotate(rotation.toFloat())
        return Bitmap.createBitmap(bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true)
    }

}