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
    
    class SwiftStreamHandler: NSObject, FlutterStreamHandler {
        public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            print("fuck")
            var a = 1.2
            getAccelerometerValues() { (X, Y, Z) -> () in
            //            gg = String(X)
//                        DispatchQueue.main.async {
//                            self.x.text=String(X)
//                        }
                a=X
//                events()
                        print("hahahhhh",String(format: "%f", X))
            }
            print(a)
//            let a: Double = 1.5
            let b: String = String(format: "%f", a)

            print("b: \(b)") // b: 1.500000
//            events(b)
//            events("truehaggha") // any generic type or more compex dictionary of [String:Any]
            events(FlutterError(code: "ERROR_CODE",
                                 message: "Detailed message",
                                 details: nil)) // in case of errors
            
            events(FlutterEndOfEventStream) // when stream is over
            return nil
        }

        public func onCancel(withArguments arguments: Any?) -> FlutterError? {
            return nil
        }
    }

}

var manager: CMMotionManager=CMMotionManager()

public func getAccelerometerValues (values: ((Double, Double, Double) -> ())? ){
        var valX: Double!
        var valY: Double!
        var valZ: Double!
    if manager.isAccelerometerAvailable {
        manager.accelerometerUpdateInterval = 0.1
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { // Change `2.0` to the desired number of seconds.
           // Code you want to be delayed
            manager.accelerometerUpdateInterval = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) { // Change `2.0` to the desired number of seconds.
           // Code you want to be delayed
            manager.accelerometerUpdateInterval = 0.5
        }
        manager.startAccelerometerUpdates(to: OperationQueue(), withHandler: {
                (data, error) in

//                print("yyy")
                valX = data!.acceleration.x
                valY = data!.acceleration.y
                valZ = data!.acceleration.z
//                print(valX)
//                print("dd",valX ?? "fff")
                if values != nil{
                    values!( valX,valY, valZ)
                }
//                print("startacc")

            })
//            print("avale")
        } else {
            print("The Accelerometer is not available")
        }
    }
