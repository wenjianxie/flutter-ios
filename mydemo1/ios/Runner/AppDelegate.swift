import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    var flutterEngine: FlutterEngine?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: "com.example.flutter",
                                                 binaryMessenger: controller.binaryMessenger)

        methodChannel.setMethodCallHandler { (call, result) in
            switch call.method {
            case "methodToIOS":
                // 处理来自 Flutter 的调用
                if let args = call.arguments as? [String: Any],
                   let value = args["key"] as? String {
                    print("iOS调用 Received from Flutter: \(value)")
                    self.openShortcutsApp2()
                }
                // 返回结果给 Flutter
                result("Response from iOS")
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // 解析 URL，获取参数
        print("url = \(url)")
        
        if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
            for queryItem in queryItems {
                print("\(queryItem.name): \(queryItem.value ?? "")")
            }
        }
        
        return true
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
    
    func openShortcutsApp2() {
        //    https:www.icloud.com/shortcuts/37cb070261f44e2ea13bfe15477065f7
//        guard let url = URL(string: "shortcuts://create-shortcut") else {
//        guard let url = URL(string: "shortcuts://gallery/search?query=[Intent]") else {
//        guard let url = URL(string: "shortcuts://run-shortcut?name=[Intent签到]") else {
        //https://www.icloud.com/shortcuts/15fa3a49274a42ebb9dcbfafafdfc506
        guard let url = URL(string: "https://www.icloud.com/shortcuts/b7c2b0e39ba241b083f52ffcfb00a607") else { ///15fa3a49274a42ebb9dcbfafafdfc506
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    ///这个项目使用的SceneDelegate 不在这里处理
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
            if (userActivity.activityType == NSStringFromClass(PZXBBIntent.self)) {
            

            print("触发了指令")
                

            let vc = ViewController2()
//            getCurrentViewController()?.navigationController?.pushViewController(vc, animated: false)
                
                getCurrentViewController()?.present(vc, animated: true)
            
            return false
        }
        
        
        return true
    }
    
    
    func getCurrentViewController() -> UIViewController? {
        var currentViewController: UIViewController?
        // 获取应用程序的根视图控制器
        if #available(iOS 15.0, *) {
            // 在支持多场景的 iOS 13.0 及更高版本中使用 UIWindowScene
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                currentViewController = windowScene.windows.first?.rootViewController
            }
        } else {
            // 在 iOS 13.0 之前的版本中使用 keyWindow
            currentViewController = UIApplication.shared.windows.first?.rootViewController
        }

        // 进一步处理视图控制器类型...
         if let rootViewController = currentViewController {
             // 如果根视图控制器是 UINavigationController，则获取其可见的视图控制器
             if let navigationController = rootViewController as? UINavigationController {
                 return navigationController.visibleViewController
             }

             // 如果根视图控制器是 UITabBarController，则获取其选中的视图控制器
             if let tabBarController = rootViewController as? UITabBarController {
                 return tabBarController.selectedViewController
             }
         }
        // 其他情况下返回根视图控制器
        return currentViewController
    }
    
}




