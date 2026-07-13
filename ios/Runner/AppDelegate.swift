import Flutter
import UIKit
import AudioToolbox

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    
    if let controller = window?.rootViewController as? FlutterViewController {
      registerChannel(with: controller.binaryMessenger)
    }
    
    return result
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    
    let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "ScanFeedbackPlugin")
    if let messenger = registrar?.messenger() {
      registerChannel(with: messenger)
    }
  }

  private func registerChannel(with messenger: FlutterBinaryMessenger) {
    let feedbackChannel = FlutterMethodChannel(name: "com.example.qr_code_scanner/scan_feedback",
                                              binaryMessenger: messenger)
    feedbackChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "playBeep" {
        self.playBeep()
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
  }

  private func playBeep() {
    AudioServicesPlaySystemSound(1104) // Soft Tock click sound
  }
}
