import Flutter
import UIKit
import AudioToolbox

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    
    let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "ScanFeedbackPlugin")
    if let messenger = registrar?.messenger() {
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
  }

  private func playBeep() {
    AudioServicesPlaySystemSound(1104) // Soft Tock click sound
  }
}
