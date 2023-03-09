//
//  WhiteboardView.swift
//  Runner
//
//  Created by Giang Vĩ Sơn Nguyễn on 09/03/2023.
//

import Foundation
import Whiteboard
import Flutter

class FlutterWhiteBoardView: NSObject, FlutterPlatformView{
    private var whiteBoard: WhiteBoardView?
    private var viewId: Int64 = 0
    
    init(frame: CGRect, viewIdentifier viewId: Int64) {
        self.whiteBoard = WhiteBoardView(frame: frame)
        self.whiteBoard?.isUserInteractionEnabled = true
        self.whiteBoard?.backgroundColor = UIColor.init(red: CGFloat.init(0.14), green: CGFloat.init(0.16), blue: CGFloat.init(0.24), alpha: CGFloat.init(1.0))
        self.viewId = viewId
    }
    
    func view() -> UIView {
        return whiteBoard!
    }
}

