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
@main
@objc class AppDelegate: FlutterAppDelegate, UIDocumentPickerDelegate {

    var srcPathToCopy: String?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let controller = window?.rootViewController as! FlutterViewController

        let channel = FlutterMethodChannel(
            name: "letienit.a_new_day.saf",
            binaryMessenger: controller.binaryMessenger
        )

        channel.setMethodCallHandler { [weak self] call, result in

            if call.method == "openSafAndSave" {

                guard let args = call.arguments as? [String: Any],
                      let srcPath = args["srcPath"] as? String else {
                    result(FlutterError(code: "INVALID_ARGS", message: "srcPath missing", details: nil))
                    return
                }

                self?.srcPathToCopy = srcPath
                self?.openDocumentPicker(controller: controller)

                result(true)

            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func openDocumentPicker(controller: FlutterViewController) {

        guard let srcPath = srcPathToCopy else { return }

        let fileURL = URL(fileURLWithPath: srcPath)

        let picker = UIDocumentPickerViewController(
            forExporting: [fileURL],
            asCopy: true
        )

        picker.delegate = self
        picker.modalPresentationStyle = .formSheet

        controller.present(picker, animated: true)
    }
}
