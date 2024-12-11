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
