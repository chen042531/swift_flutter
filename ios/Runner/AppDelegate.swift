import UIKit
import Flutter
import CoreMotion
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(name: "samples.flutter.dev/battery",
                                              binaryMessenger: controller.binaryMessenger)
    let eventChannel = FlutterEventChannel(name: "samples.flutter.io/sensor", binaryMessenger: controller.binaryMessenger)
    eventChannel.setStreamHandler(SwiftStreamHandler())
    
    batteryChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
      // Note: this method is invoked on the UI thread.
      guard call.method == "getBatteryLevel" else {
        result(FlutterMethodNotImplemented)
        return
      }
      self?.receiveBatteryLevel(result: result)
    })


    GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    private func receiveBatteryLevel(result: FlutterResult) {
      let device = UIDevice.current
      device.isBatteryMonitoringEnabled = true
      if device.batteryState == UIDevice.BatteryState.unknown {
        result(FlutterError(code: "UNAVAILABLE",
                            message: "Battery info unavailable",
                            details: nil))
      } else {
        result(Int(device.batteryLevel * 100))
      }
    }
    static func send(x:Double,sink: FlutterEventSink)->(){
        print("ggg",x)
//        let data = String(format: "%f", x)
        sink(Int(x))
    }
    class SwiftStreamHandler: NSObject, FlutterStreamHandler {
        let senInfo = sensorInfo()
         let manager: CMMotionManager = CMMotionManager()
        public func onListen(withArguments arguments: Any?, eventSink events:  @escaping FlutterEventSink) -> FlutterError? {
            print("fuck")
            
            manager.accelerometerUpdateInterval = 0.5
//            events("dd")
                        manager.startAccelerometerUpdates(to: OperationQueue(), withHandler: {
                                (data, error) in
                                var g=data!.acceleration.x
                            print(g)
                            events(String(g))
//                            send(x: g, sink: events)
//                                valX =
//                                valY = data!.acceleration.y
//                                valZ = data!.acceleration.z
         
            //                        sensorInfo.notify(X: valX, ev: self.eve)
                                }
                            
            //                    self.delegate?.retrieveAccelerometerValues(x: valX, y: valY, z: valZ)
        )
//            print(events)
//            senInfo.getAccelerometerValues() { (X, Y, Z) -> () in
//            //            gg = String(X)
//                        DispatchQueue.main.async {
//
//                        }
////                events(X)
//                send(x: X,sink: events)
//                        print("hahahhhh",X)
//            }
//
            
//
                    
//            events("bgbg")
            
//            events(String(0.32442323))
//            events(FlutterError(code: "ERROR_CODE",
//                                 message: "Detailed message",
//                                 details: nil)) // in case of errors
//
//            events(FlutterEndOfEventStream) // when stream is over
            return nil
        }

        public func onCancel(withArguments arguments: Any?) -> FlutterError? {
            return nil
        }
    }

}

