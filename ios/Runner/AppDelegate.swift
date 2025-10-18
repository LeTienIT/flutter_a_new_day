import UIKit
import Flutter
import UniformTypeIdentifiers
// Mức Swift cần cho Flutter developer
// Bạn không cần học full SwiftUI, UIKit, AutoLayout… mà chỉ cần:
//
// Cú pháp Swift cơ bản (class, function, optional, if/else…).
//
// Cách viết AppDelegate & UIViewController.
//
// Cách gọi API native (Camera, GPS…).
//
// Cách Flutter ↔ Swift giao tiếp bằng Platform Channel.
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, UIDocumentPickerDelegate {

    var srcPathToCopy: String?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "letienit.a_new_day.saf", binaryMessenger: controller.binaryMessenger)

        channel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "saveLargeFile" {
                if let args = call.arguments as? [String: Any],
                   let srcPath = args["srcPath"] as? String {
                    self?.srcPathToCopy = srcPath
                    self?.openDocumentPicker()
                }
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func openDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(forExporting: [URL(fileURLWithPath: srcPathToCopy!)])
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        window?.rootViewController?.present(documentPicker, animated: true, completion: nil)
    }
}
