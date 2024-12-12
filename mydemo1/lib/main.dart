import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  // 初始化通道处理器
                  MyApp.initializeChannel();
                },
                child: Text("点击开启快捷指令"),
              ),
              TextButton(
                onPressed: () async {
                  // 调用原生方法
                  await MyApp.invokeNativeMethod();
                },
                child: Text("调用原生方法"),
              ),
            ],
          ),
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

  static Future<void> invokeNativeMethod() async {
    try {
      final String result = await _channel.invokeMethod("methodToIOS", {"key": "value哈哈哈"});
    } on PlatformException catch (e) {
      print("Failed to invoke method: ${e.message}");
    }
  }
}
