package letienit.a_new_day.a_new_day

import android.app.Activity
import android.content.ContentResolver
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.FileInputStream
import java.io.OutputStream

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "letienit.a_new_day.saf"
    private var pendingSrcPath: String? = null
    private var pendingResult: MethodChannel.Result? = null
    private val CREATE_FILE_REQUEST_CODE = 9999

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "openSafAndSave") {
                    pendingSrcPath = call.argument<String>("srcPath")!!
                    pendingResult = result
                    val intent = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
                        addCategory(Intent.CATEGORY_OPENABLE)
                        type = "application/zip"
                        putExtra(Intent.EXTRA_TITLE, "backup.zip")
                    }
                    startActivityForResult(intent, CREATE_FILE_REQUEST_CODE)
                } else {
                    result.notImplemented()
                }
            }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == CREATE_FILE_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
            val destUri: Uri? = data?.data
            if (destUri != null && pendingSrcPath != null) {
                try {
                    val resolver: ContentResolver = applicationContext.contentResolver
                    resolver.openOutputStream(destUri)?.use { output: OutputStream ->
                        FileInputStream(pendingSrcPath!!).use { input ->
                            val buffer = ByteArray(1024 * 64)
                            var bytesRead: Int
                            while (input.read(buffer).also { bytesRead = it } != -1) {
                                output.write(buffer, 0, bytesRead)
                            }
                            output.flush()
                        }
                    }
                    pendingResult?.success(true)
                } catch (e: Exception) {
                    pendingResult?.error("SAVE_ERROR", e.message, null)
                }
            } else {
                pendingResult?.error("NO_URI", "Người dùng hủy chọn file", null)
            }
            pendingSrcPath = null
            pendingResult = null
        }
    }
}
