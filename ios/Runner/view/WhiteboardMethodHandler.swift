//
//  WhiteboardPugin.swift
//  Runner
//
//  Created by Giang Vĩ Sơn Nguyễn on 09/03/2023.
//

import Flutter
import UIKit
import Whiteboard

public class WhiteBoardMethodHandler: NSObject, WhiteRoomCallbackDelegate {
   var whiteSdk: WhiteSDK?
   var room: WhiteRoom?
   var uuid: String?
   var factory: WhiteBoardViewFactory?
   var evenHandler: WhiteBoardEventHandler = WhiteBoardEventHandler()
   var colors: [Int] = [58, 206, 133]
   var scalePpt: NSNumber = 1.0
   var fontSize: NSNumber = 28.0
   var strokeSize: NSNumber = 4.0
   var cannotJoin = false

   init(factory: WhiteBoardViewFactory, messenger: FlutterBinaryMessenger) {
       super.init()
       self.factory = factory
       self.evenHandler.startListening(messenger: messenger)
       let channel = FlutterMethodChannel(name: "whiteboard", binaryMessenger: messenger)
       channel.setMethodCallHandler(handle)
   }


   public func handle(call: FlutterMethodCall, result: FlutterResult) {
       let method = call.method
       switch method {
       case "init":
           guard let arg = call.arguments else {
               print("Invalid argument")
               result(nil)
               return
           }
           if let myArgs = arg as? [String: Any] {
               if let appIdentifier = myArgs[ConstantKeys.APP_IDENTIFIER] as? String {
                   let configuration = WhiteSdkConfiguration.init(app: appIdentifier)
                   configuration.deviceType = .touch
                   configuration.userCursor = true
                   configuration.region = parseWhiteboardRegion(region: myArgs[ConstantKeys.REGION] as! String)
                   self.whiteSdk = WhiteSDK.init(whiteBoardView: self.factory?.renderView as! WhiteBoardView, config: configuration, commonCallbackDelegate: nil)
               }
           }
           break;
       case "joinRoom":
           guard let arg = call.arguments else {
               print("Invalid argument")
               result(nil)
               return
           }
           if let myArgs = arg as? [String: Any] {
               joinRoom(myArgs: myArgs, result: result)
           }
           result(nil)
           break
       case "leaveRoom":
           self.room?.disconnect({})
           self.whiteSdk = nil
           self.room = nil
           self.cannotJoin = false
           break
       case "insertImageUrl":
           guard let arg = call.arguments else {
               print("Invalid argument")
               result(nil)
               return
           }
           if let myArgs = arg as? [String: Any] {
               if let url = myArgs[ConstantKeys.URL] as? String {
                   if let width = myArgs[ConstantKeys.WIDTH] as? CGFloat, let height = myArgs[ConstantKeys.HEIGHT] as? CGFloat, let roomUuid = self.uuid {
                       let imageInformation = WhiteImageInformation()
                       imageInformation.centerX = 0.0
                       imageInformation.centerY = 0.0
                       imageInformation.width = width
                       imageInformation.height = height
                       imageInformation.uuid = roomUuid
                       self.room?.insertImage(imageInformation, src: url)
                   }
               }
           }
           break
       case "cleanScene":
           if let room = self.room {
               room.cleanScene(true)
           }
           break
       case "switchToolTeaching":
           guard let arg = call.arguments else {
               print("Invalid argument")
               result(nil)
               return
           }
           if let myArgs = arg as? [String: Any] {
               if let tool = myArgs[ConstantKeys.TOOL] as? String {
                   self.room?.getMemberState(result: { (memberState) in
                       memberState.currentApplianceName = WhiteApplianceNameKey(rawValue: tool)
                       self.room?.setMemberState(memberState)
                   })
               }
               result(nil)
           }
           break
       case "setViewMode":
           guard let arg = call.arguments else {
               print("Invalid argument")
               result(nil)
               return
           }
           if let myArgs = arg as? [String: Any] {
               if let mode = myArgs[ConstantKeys.MODE] as? String {
                   self.room?.setViewMode(parseViewMode(mode: mode))
                   self.room?.moveCamera(toContainer: WhiteRectangleConfig.init())
               }
           }
           result(nil)
           break
       case "disableCameraTransform":
           guard let arg = call.arguments else {
               print("Invalid argument")
               result(nil)
               return
           }
           if let myArgs = arg as? [String: Any] {
               if let disable = myArgs[ConstantKeys.DISABLE] as? Bool {
                   self.room?.disableCameraTransform(disable)
               }
           }
           result(nil)
           break
       case "insertPptUrl":
           guard let arg = call.arguments else {
               print("Invalid argument")
               result(nil)
               return
           }
           if let myArgs = arg as? [String: Any], let room = self.room {
               let dir = myArgs[ConstantKeys.DIRECTORY] as! String
               let url = myArgs[ConstantKeys.URL] as! String
               let index = myArgs[ConstantKeys.INDEX] as! Int
               if let myArgs = arg as? [String: Any], let width = myArgs[ConstantKeys.WIDTH] as? Double, let height = myArgs[ConstantKeys.HEIGHT] as? Double  {
                   let sc = WhiteScene.init(name: ConstantKeys.SCENE, ppt: WhitePptPage.init(src: url, size: CGSize.init(width: width, height: height)))
                   room.putScenes(dir, scenes: [sc], index: UInt(index))
                   room.setScenePath(dir + "/" + ConstantKeys.SCENE + String.init(index))
               }
           }
           result(nil)
           break
       case "jumpToPage":
           guard let arg = call.arguments else {
               print("Invalid argument")
               result(nil)
               return
           }
           if let myArgs = arg as? [String: Any] {
               let dir = myArgs[ConstantKeys.DIRECTORY] as! String
               let index = myArgs[ConstantKeys.INDEX] as! Int
               self.room?.setScenePath(dir + "/" + ConstantKeys.SCENE + String.init(index))
           }
           result(nil)
           break
       case "disableDeviceInputs":
           guard let arg = call.arguments else {
               print("Invalid argument")
               result(nil)
               return
           }
           if let myArgs = arg as? [String: Any]{
               let disable = myArgs[ConstantKeys.DISABLE] as! Bool
               (self.factory?.renderView as? WhiteBoardView)?.isUserInteractionEnabled = !disable
           }
           result(nil)
           break
       case "setPencilColor":
           guard let arg = call.arguments else {
               print("Invalid argument")
               result(nil)
               return
           }
           if let myArgs = arg as? [String: Any] {
               self.colors = myArgs[ConstantKeys.COLOR] as! [Int]
               setPencilColor(colors: colors)
           }
           result(nil)
           break
       case "scalePptToFit":
           self.room?.scalePpt(toFit: WhiteAnimationMode.immediately)
           result(nil)
           break
       case "refreshViewSize":
           self.room?.refreshViewSize()
           break
       case "updateScalePpt":
           guard let arg = call.arguments else {
               print("Invalid argument")
               result(nil)
               return
           }
           if let myArgs = arg as? [String: Any] {
               self.scalePpt = myArgs[ConstantKeys.SCALE_PPT] as! NSNumber
               updateScalePpt()
           }
           result(nil)
           break
       case "setStrokeWidth":
           guard let arg = call.arguments else {
               print("Invalid argument")
               result(nil)
               return
           }
           if let myArgs = arg as? [String: Any] {
               self.strokeSize = myArgs[ConstantKeys.STROKE_WIDTH] as! NSNumber
               setStrokeSize(size: strokeSize)
           }
           result(nil)
           break
       case "setTextSize":
           guard let arg = call.arguments else {
               print("Invalid argument")
               result(nil)
               return
           }
           if let myArgs = arg as? [String: Any] {
               self.fontSize = myArgs[ConstantKeys.FONT_SIZE] as! NSNumber
               setFontSize(size: fontSize)
           }
           result(nil)
           break
       case "redo":
           self.room?.redo()
           result(nil)
           break
       case "undo":
           self.room?.undo()
           result(nil)
           break
       case "getScenePreviewImage":
           guard let arg = call.arguments else {
               print("Invalid argument")
               result(nil)
               return
           }

           if let myArgs = arg as? [String: Any] {
               let dir = myArgs[ConstantKeys.DIRECTORY] as! String
               let sceneName = myArgs[ConstantKeys.SCENE_NAME] as! String
               let imagePath = myArgs[ConstantKeys.IMAGE_PATH] as! String
               let defaultMap: [String: Any] = [ConstantKeys.RESULT: false,
                                                ConstantKeys.PLACE_HOLDER: imagePath]
               self.room?.getEntireScenes({ [weak self] result in
                   if let currentScenes = result[dir] {
                       if currentScenes.contains(where: {$0.name == sceneName}) {
                           self?.getScenePreviewImage(scenePath: "\(dir)/\(sceneName)",
                                                      imagePath: imagePath)
                       } else {
                           self?.evenHandler.sendEvent(eventName: "onGetScenePreviewImage",
                                                       map: defaultMap)
                       }
                   } else {
                       self?.evenHandler.sendEvent(eventName: "onGetScenePreviewImage",
                                                   map: defaultMap)
                   }
               })
           }
           result(nil)
           break
       case "moveCamera":
           guard let arg = call.arguments else {
               print("Invalid argument")
               result(nil)
               return
           }
           if let myArgs = arg as? [String: Any] {
               let scale = myArgs[ConstantKeys.SCALE_PPT] as? NSNumber
               let centerX = myArgs[ConstantKeys.CENTER_X] as! NSNumber
               let centerY = myArgs[ConstantKeys.CENTER_Y] as! NSNumber
               let cameraConfig = WhiteCameraConfig.init();
               cameraConfig.scale = scale
               cameraConfig.centerX = centerX
               cameraConfig.centerY = centerY
               cameraConfig.animationMode = WhiteAnimationMode.continuous
               self.room?.moveCamera(cameraConfig)
           }
           result(nil)
           break
       case "getCurrentSceneSizeWhiteboardAction":
           if (room != nil) {
               if let currentSceneIndex = room?.sceneState.index as NSInteger?, let width = room?.sceneState.scenes[currentSceneIndex].ppt?.width as NSNumber?, let height = room?.sceneState.scenes[currentSceneIndex].ppt?.height as NSNumber? {
                   var map: [String: Any] = [:]
                   map[ConstantKeys.WIDTH] = width
                   map[ConstantKeys.HEIGHT] = height
                   result(map)
               } else {
                   result(nil)
               }
           } else {
               result(nil)
           }
       case "setWhiteboardViewBackgroundColor":
           guard let arg = call.arguments, let myArgs = arg as? [String: Any], self.factory?.renderView != nil else {
               print("Invalid argument")
               result(nil)
               return
           }
           self.colors = myArgs[ConstantKeys.COLOR] as! [Int]
           let red = Double(colors[0])
           let green = Double(colors[1])
           let blue = Double(colors[2])
           (self.factory?.renderView as? WhiteBoardView)?.backgroundColor = UIColor.init(red: CGFloat.init(red / 225.0), green: CGFloat.init(green / 225.0), blue: CGFloat.init(blue / 225.0), alpha: CGFloat.init(1.0))
           result(nil)
           break
       default:
           break
       }
   }

   func getScenePreviewImage(scenePath: String, imagePath: String) {
       self.room?.getSceneSnapshotImage(scenePath, completion: { [weak self] (image) in
           var map: [String: Any] = [:]
           if let validImage = image, let data = validImage.jpegData(compressionQuality: 1.0) {
               map[ConstantKeys.RESULT] = true
               map[ConstantKeys.IMAGE_DATA] = data
           } else {
               map[ConstantKeys.RESULT] = false
           }
           map[ConstantKeys.PLACE_HOLDER] = imagePath
           self?.evenHandler.sendEvent(eventName: "onGetScenePreviewImage", map: map)
       })
   }

   func setPencilColor(colors: [Int]) {
       let state: WhiteMemberState = WhiteMemberState.init()
       var strokeColor: [NSNumber] = []
       strokeColor.append(NSNumber.init(integerLiteral: colors[0]))
       strokeColor.append(NSNumber.init(integerLiteral: colors[1]))
       strokeColor.append(NSNumber.init(integerLiteral: colors[2]))
       state.strokeColor = strokeColor
       self.room?.setMemberState(state)
   }

   func updateScalePpt() {
       setStrokeSize(size: self.strokeSize)
       setFontSize(size: self.fontSize)
   }

   func setStrokeSize(size: NSNumber) {
       let state: WhiteMemberState = WhiteMemberState.init()
       state.strokeWidth = NSNumber(value: size.doubleValue / self.scalePpt.doubleValue)
       self.room?.setMemberState(state)
   }

   func setFontSize(size: NSNumber) {
       let state: WhiteMemberState = WhiteMemberState.init()
       state.textSize = NSNumber(value: size.doubleValue / self.scalePpt.doubleValue)
       self.room?.setMemberState(state)
   }

   func parseViewMode(mode: String) -> WhiteViewMode {
       switch mode {
       case "broadcaster":
           return WhiteViewMode.broadcaster
       case "follower":
           return WhiteViewMode.follower
       default:
           return WhiteViewMode.freedom
       }
   }

   func joinRoomCallback(result: Bool, room: WhiteRoom?, error: Error?) {
       self.room = room
   }

   func joinRoomResult(delegate: WhiteRoomCallbackDelegate?) {

   }

   func onRoomCreated(uuid: String, roomToken: String) -> Void {

   }

   func onRoomJoined(roomToken: String) -> Void {

   }

   func onReceiveJoinRoomResult(success: Bool, room: WhiteRoom?, error: Error?) -> Void {

   }

   public func firePhaseChanged(_ roomPhase: WhiteRoomPhase) {
       var map: [String: Any] = [:]
       map[ConstantKeys.ROOM_PHASE] = parseWhiteboardRoomPhase(roomPhase: roomPhase)
       self.evenHandler.sendEvent(eventName: "onPhaseChanged", map: map)
   }

   public func fireRoomStateChanged(_ modifyState: WhiteRoomState!) {
       if let sceneState = modifyState.sceneState as WhiteSceneState? {
           let path: String = sceneState.scenePath
           var index: Int = 0
           if let tempIndex = Int.init(sceneState.scenes[sceneState.index].name.replacingOccurrences(of: ConstantKeys.SCENE, with: "")) {
               index = tempIndex
           }
           let dir: String = path.components(separatedBy: "/")[1]
           var map: [String: Any] = [:]
           map[ConstantKeys.DIRECTORY] = dir
           map[ConstantKeys.INDEX] = index
           self.evenHandler.sendEvent(eventName: "onLoadedCurrentScene", map: map)
       }

       if let cameraState = modifyState.cameraState as WhiteCameraState? {
           var map: [String: Any] = [:]
           map[ConstantKeys.CENTER_X] = cameraState.centerX.doubleValue
           map[ConstantKeys.CENTER_Y] = cameraState.centerY.doubleValue
           map[ConstantKeys.SCALE_PPT] = cameraState.scale.doubleValue
           self.evenHandler.sendEvent(eventName: "onCameraStateChanged", map: map)
       }
   }

   func joinRoom(myArgs: [String: Any], result: FlutterResult) {
       self.evenHandler.onStart()
       if self.whiteSdk == nil {
           if let appIdentifier = myArgs[ConstantKeys.APP_IDENTIFIER] as? String {
               let configuration = WhiteSdkConfiguration.init(app: appIdentifier)
               configuration.deviceType = .touch
               configuration.userCursor = true
               configuration.region = parseWhiteboardRegion(region: myArgs[ConstantKeys.REGION] as! String)
               self.whiteSdk = WhiteSDK.init(whiteBoardView: self.factory?.renderView as! WhiteBoardView, config: configuration, commonCallbackDelegate: nil)
               joinRoom(myArgs: myArgs, result: result)
           }
           return
       }

       if let roomUuid = myArgs[ConstantKeys.UUID] as? String, let roomToken = myArgs[ConstantKeys.ROOM_TOKEN] as? String, let mode = myArgs[ConstantKeys.MODE] as? String, let uid = myArgs[ConstantKeys.UID] as? String, let userName = myArgs[ConstantKeys.USER_NAME] as? String, let region = myArgs[ConstantKeys.REGION] as? String, let count = myArgs[ConstantKeys.COUNT] as? Int,let disableCameraTransform = myArgs[ConstantKeys.DISABLE_CAMERA_TRANSFORM] as? Bool {
           self.uuid = roomUuid
           let writable = myArgs[ConstantKeys.WRITABLE] as? Bool ?? true
           handleJoinRoom(uuid: roomUuid, roomToken: roomToken, uid: uid, mode: mode, writable: writable, userName: userName, region: region, count: count, disableCameraTransform: disableCameraTransform)
       } else {
           result("Missing data")
       }
   }

   func handleJoinRoom(uuid: String, roomToken: String, uid: String, mode: String, writable: Bool, userName: String, region: String, count: Int, disableCameraTransform: Bool) {
       self.evenHandler.onJoining(count: count)
       let roomConfig = WhiteRoomConfig.init(uuid: uuid, roomToken: roomToken, uid: uid)
       roomConfig.timeout = NSNumber.init(value: 20000)
       roomConfig.isWritable = writable
       roomConfig.disableNewPencil = false;
       roomConfig.userPayload = ["cursorName": userName]
       roomConfig.region = parseWhiteboardRegion(region: region)
       self.whiteSdk?.joinRoom(with: roomConfig, callbacks: self, completionHandler: { (joinResult: Bool, room: WhiteRoom?, error: Error?) in
           if (error) != nil {
               // Join room error
               self.evenHandler.onJoinRoomResult(result: false, message: error.debugDescription, count: count)
               self.cannotJoin = false
           } else {
               self.cannotJoin = false
               self.room = room
               self.room?.setViewMode(self.parseViewMode(mode: mode))
               self.setWritable(writable: writable)
               if writable {
                   let memberState = WhiteMemberState.init()
                   memberState.currentApplianceName = WhiteApplianceNameKey.init(rawValue: ConstantKeys.SELECTOR)
                   self.room?.setMemberState(memberState)
               }
               self.room?.disableCameraTransform(disableCameraTransform)
               self.room?.disableSerialization(false)
               self.room?.scalePpt(toFit: .immediately)

               self.setPencilColor(colors: self.colors)
               self.setStrokeSize(size: self.strokeSize)
               self.setFontSize(size: self.fontSize)

               self.evenHandler.onJoinRoomResult(result: joinResult, message: "", count: count)
               if let sceneState = room?.sceneState as WhiteSceneState? {
                   let path: String = sceneState.scenePath
                   let dir: String = path.components(separatedBy: "/")[1]
                   var map: [String: Any] = [:]
                   map[ConstantKeys.DIRECTORY] = dir
                   var index: Int = 0
                   if let tempIndex = Int.init(sceneState.scenes[sceneState.index].name.replacingOccurrences(of: ConstantKeys.SCENE, with: "")) {
                       index = tempIndex
                   }
                   map[ConstantKeys.INDEX] = index
                   self.evenHandler.sendEvent(eventName: "onLoadedCurrentScene", map: map)
               }
           }
       })
   }

   func setWritable(writable: Bool) {
       self.room?.setWritable(writable, completionHandler: {(writableResult: Bool, error: Error?) in
           if (error != nil) {
               DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                   /// retry set writable
                   self.setWritable(writable: writable)
               }
           }
       })
   }

   func parseWhiteboardRoomPhase(roomPhase: WhiteRoomPhase) -> String {
       switch (roomPhase) {
       case WhiteRoomPhase.connecting:
           return "connecting";
       case WhiteRoomPhase.connected:
           return "connected";
       case WhiteRoomPhase.disconnecting:
           return "disconnecting";
       case WhiteRoomPhase.disconnected:
           return "disconnected";
       case WhiteRoomPhase.reconnecting:
           return "reconnecting";
       default:
           return "";
       }
   }

   func parseWhiteboardRegion(region: String) -> WhiteRegionKey? {
       switch (region) {
       case "cn-hz":
           return WhiteRegionKey.CN
       case "us-sv":
           return WhiteRegionKey.US
       case "in-mum":
           return WhiteRegionKey.IN
       case "sg":
           return WhiteRegionKey.SG
       case "gb-lon":
           return WhiteRegionKey.GB
       default:
           return nil;
       }
   }
}
