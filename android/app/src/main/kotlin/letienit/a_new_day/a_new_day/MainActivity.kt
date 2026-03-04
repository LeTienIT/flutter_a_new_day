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

import java.io.File
import java.io.FileOutputStream

import java.util.zip.ZipInputStream
import java.io.BufferedInputStream

import java.util.zip.ZipOutputStream
import java.util.zip.ZipEntry

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "letienit.a_new_day.saf"
    private var pendingSrcPath: String? = null
    private var pendingResult: MethodChannel.Result? = null
    private val CREATE_FILE_REQUEST_CODE = 9999
    private val PICK_ZIP_REQUEST_CODE = 10001

    private fun clearAppData() {
        val appDir = filesDir.parentFile!!

        // Xoá File
        File(appDir, "files").deleteRecursively()

        // Xoá file database
        File(appDir, "databases").deleteRecursively()

        // Xoá shared prefs
        File(appDir, "shared_prefs").deleteRecursively()

        // Xoá Flutter data
        File(appDir, "app_flutter").deleteRecursively()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "openSafAndSave") {
                    pendingSrcPath = call.argument<String>("srcPath")!!
                    pendingResult = result

                    val fileName = call.argument<String>("fileName") ?: "backup.zip"

                    val intent = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
                        addCategory(Intent.CATEGORY_OPENABLE)
                        type = "application/zip"
                        putExtra(Intent.EXTRA_TITLE, fileName)
                    }
                    startActivityForResult(intent, CREATE_FILE_REQUEST_CODE)
                }
                else if (call.method == "createBackupNative"){
                    val destPath = call.argument<String>("destPath")!!
                    val methodResult = result

                    Thread {
                        try {
                            zipAppData(destPath)
                            runOnUiThread { methodResult.success(true) }
                        } catch (e: Exception) {
                            runOnUiThread { methodResult.error("BACKUP_FAIL", e.message, null) }
                        }
                    }.start()
                }
                else if (call.method == "pickBackupZip"){
                    pendingResult = result

                    val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                        addCategory(Intent.CATEGORY_OPENABLE)
                        type = "*/*"
                        putExtra(Intent.EXTRA_MIME_TYPES, arrayOf("application/zip"))
                    }
                    startActivityForResult(intent, PICK_ZIP_REQUEST_CODE)
                }
                else if (call.method == "restoreBackupNative"){
                    val zipPath = call.argument<String>("zipPath")!!
                    val methodResult = result

                    Thread {
                        try {
                            clearAppData()
                            unzipToApp(zipPath)
                            File(zipPath).delete()
                            runOnUiThread { methodResult.success(true) }
                        } catch (e: Exception) {
                            runOnUiThread { methodResult.error("RESTORE_FAIL", e.message, null) }
                        }
                    }.start()
                }
                else {
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

        // ===== PICK ZIP RESTORE ===== ⭐ thêm
        if (requestCode == PICK_ZIP_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
            val uri: Uri? = data?.data
            if (uri != null) {
                try {
                    contentResolver.takePersistableUriPermission(
                        uri,
                        Intent.FLAG_GRANT_READ_URI_PERMISSION
                    )

                    val inputStream = contentResolver.openInputStream(uri)

                    val destFile = File(cacheDir, "restore.zip")
                    val outputStream = FileOutputStream(destFile)

                    inputStream!!.copyTo(outputStream)

                    inputStream.close()
                    outputStream.close()

                    pendingResult?.success(destFile.absolutePath)

                } catch (e: Exception) {
                    pendingResult?.error("PICK_ERROR", e.message, null)
                }
            } else {
                pendingResult?.error("NO_FILE", "User cancelled", null)
            }

            pendingResult = null
        }
    }

    private fun zipAppData(destPath: String) {
        val appDir = filesDir.parentFile!!
        val zipFile = File(destPath)

        ZipOutputStream(FileOutputStream(zipFile)).use { zos ->
            appDir.walkTopDown().forEach { file ->

                if (file.absolutePath == zipFile.absolutePath) return@forEach

                if (file.isFile) {
                    val entryName = file.relativeTo(appDir).path
                    zos.putNextEntry(ZipEntry(entryName))

                    FileInputStream(file).use { fis ->
                        fis.copyTo(zos)
                    }

                    zos.closeEntry()
                }
            }
        }
    }

    private fun unzipToApp(zipPath: String) {
        val appDir = filesDir.parentFile!!

        ZipInputStream(BufferedInputStream(FileInputStream(zipPath))).use { zis ->
            var entry = zis.nextEntry

            while (entry != null) {
                val outFile = File(appDir, entry.name)

                if (entry.isDirectory) {
                    outFile.mkdirs()
                } else {
                    outFile.parentFile?.mkdirs()

                    FileOutputStream(outFile).use { fos ->
                        zis.copyTo(fos)
                    }
                }

                zis.closeEntry()
                entry = zis.nextEntry
            }
        }
    }
//    Bản cú - trong back-up chỉ có 1 foldel backup_copy
//    private fun unzipToApp(zipPath: String) {
//
//        val appFlutterDir = File(filesDir.parentFile, "app_flutter")
//
//        ZipInputStream(BufferedInputStream(FileInputStream(zipPath))).use { zis ->
//
//            var entry = zis.nextEntry
//
//            while (entry != null) {
//
//                // Chỉ xử lý file trong backup_copy/
//                if (entry.name.startsWith("backup_copy/")) {
//
//                    val relativePath = entry.name.removePrefix("backup_copy/")
//                    val outFile = File(appFlutterDir, relativePath)
//
//                    if (entry.isDirectory) {
//                        outFile.mkdirs()
//                    } else {
//                        outFile.parentFile?.mkdirs()
//
//                        FileOutputStream(outFile).use { fos ->
//                            zis.copyTo(fos)
//                        }
//                    }
//                }
//
//                zis.closeEntry()
//                entry = zis.nextEntry
//            }
//        }
//    }
}
