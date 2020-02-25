//
//  TanuClient.swift
//  HapticsBox
//
//  Created by fuziki on 2019/12/15.
//  Copyright © 2019 fuziki.factory. All rights reserved.
//

import Foundation
import Swifter

class WebSocketServer {
    
    private var server: HttpServer
    public init() {
        server = HttpServer()
        server["/haptic"] = websocket(text: { [weak self] (_, t) in
            print("t: \(t)")
            self?.onTextHandler?(t)
        }, binary: { (_, _) in
            
        }, pong: { (_, _) in
            
        }, connected: { (_) in
            print("connected")
        }, disconnected: { (_) in
            print("disconnected")
        })
        try! server.start(8080)
    }
    
    private var onTextHandler: ((String) -> Void)? = nil
    public func on(text handler: @escaping (String) -> Void) {
        onTextHandler = handler
    }
}
