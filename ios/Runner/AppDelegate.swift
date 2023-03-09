import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      guard let controller = window?.rootViewController as? FlutterViewController else {
        fatalError("rootViewController is not type FlutterViewController")
      }
      let batteryChannel = FlutterMethodChannel(name: "whiteboard",
                                                    binaryMessenger: controller.binaryMessenger)
      GeneratedPluginRegistrant.register(with: self)
      weak var registrar = self.registrar(forPlugin: "whiteboard")
      let factory = WhiteBoardViewFactory(messenger: registrar!.messenger())
      self.registrar(forPlugin: "whiteboard_view")!.register(factory, withId: "whiteboard")
      let handler = WhiteBoardMethodHandler.init(factory: factory, messenger: registrar!.messenger())
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
