//
//  WhiteboardViewFactory.swift
//  Runner
//
//  Created by Giang Vĩ Sơn Nguyễn on 09/03/2023.
//

import Foundation
import Flutter
import Whiteboard

class WhiteBoardViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    var renderView: UIView?

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        let rendererView = FlutterWhiteBoardView(frame: frame, viewIdentifier: viewId)
        self.renderView = rendererView.view()
        return rendererView
    }
}

