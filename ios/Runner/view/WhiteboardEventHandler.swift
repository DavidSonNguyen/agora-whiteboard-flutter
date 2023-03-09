//
//  WhiteboardEventHandler.swift
//  Runner
//
//  Created by Giang Vĩ Sơn Nguyễn on 09/03/2023.
//

import Foundation

public class WhiteBoardEventHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    private var eventChannel: FlutterEventChannel?
    
    
    public func startListening(messenger: FlutterBinaryMessenger) {
        if eventChannel != nil {
            stopListening()
        }
        eventChannel = FlutterEventChannel.init(name: "whiteboard_event_channel", binaryMessenger: messenger)
        eventChannel?.setStreamHandler(self)
    }
    
    public func stopListening() {
        if eventChannel == nil {
            return
        }
        eventChannel?.setStreamHandler(nil)
        eventChannel = nil
    }
    
    public func sendEvent(eventName: String, map: [String: Any]?) {
        if (eventSink != nil) {
            var eventData = map
            if (eventData == nil) {
                eventData = [:]
            }
            eventData?["event"] = eventName
            eventSink!(eventData)
        }
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
    public func onJoinRoomResult(result: Bool, message: String, count: Int) {
        var map: [String: Any] = [:]
        map[ConstantKeys.RESULT] = result
        map[ConstantKeys.MESSAGE] = message
        map[ConstantKeys.COUNT] = count
        sendEvent(eventName: "onJoinRoomResult", map: map)
    }
    
    public func onStart() {
        let map: [String: Any] = [:]
        sendEvent(eventName: "onStart", map: map)
    }
    
    public func onJoining(count: Int) {
        var map: [String: Any] = [:]
        map[ConstantKeys.COUNT] = count
        sendEvent(eventName: "onJoining", map: map)
    }
}
