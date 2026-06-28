package com.example.uas_mobile_lanjut 
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.fitri.uas/nim_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "reverseNIM") {
                val nim = call.argument<String>("nim")
                
                if (nim != null) {
                    // TANTANGAN ANTI-AI: Membalikkan urutan String NIM (Contoh: 20123020 -> 02032102)
                    val reversedNIM = nim.reversed()
                    
                    // Menampilkan hasil pembalikan lewat Native Toast Android
                    Toast.makeText(this, "NIM Dibalik: $reversedNIM", Toast.LENGTH_LONG).show()
                    
                    // Kembalikan hasilnya ke sisi Dart/Flutter
                    result.success(reversedNIM)
                } else {
                    result.error("INVALID_ARGUMENT", "NIM berstatus null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}