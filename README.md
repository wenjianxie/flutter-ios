iOS处：
```
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
```

Flutter处
```
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  MyApp.initializeChannel();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const MethodChannel _channel = MethodChannel('com.example.flutter');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter')),
        body: Center(
          child: Text('Listening for iOS calls...'),
        ),
      ),
    );
  }

  static void initializeChannel() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "methodFromIOS":
          String args = call.arguments as String;
          print("调用Received message from iOS: $args");
          return "Response from Flutter";
        default:
          throw PlatformException(
            code: "Unimplemented",
            details: "Method ${call.method} not implemented on Flutter side",
          );
      }
    });
  }
}

```
