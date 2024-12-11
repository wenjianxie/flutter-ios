import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    var flutterEngine: FlutterEngine?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // 初始化 Flutter Engine
        flutterEngine = FlutterEngine(name: "my_engine")
        flutterEngine?.run()
        GeneratedPluginRegistrant.register(with: flutterEngine!)

        
        DispatchQueue.global().asyncAfter(deadline: .now() + 3.0) {
            print("This message is printed after 2 seconds on a background thread.")
            self.callFlutterMethod()
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func callFlutterMethod() {
        guard let flutterEngine = flutterEngine else {
            print("FlutterEngine not initialized")
            return
        }

        let methodChannel = FlutterMethodChannel(name: "com.example.flutter", binaryMessenger: flutterEngine.binaryMessenger)

        // 调用 Flutter 方法
        methodChannel.invokeMethod("methodFromIOS", arguments: "Hello from iOS!") { result in
            if let response = result as? String {
                print("哈哈哈哈Received response from Flutter: \(response)")
            } else {
                print("No response or an error occurred.")
            }
        }
    }
}




