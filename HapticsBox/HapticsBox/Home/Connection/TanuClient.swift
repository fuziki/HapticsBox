//
//  TanuClient.swift
//  HapticsBox
//
//  Created by fuziki on 2019/12/15.
//  Copyright © 2019 fuziki.factory. All rights reserved.
//

import Foundation
//import Starscream

class TanuClient {
//    private var socket: WebSocket? = nil
    
    public var isConnected: Bool {
//        return socket?.isConnected ?? false
        return false
    }
    
    private var onTextHandler: ((_ text: String) -> ())? = nil
    private var onConnectHandler: (() -> ())? = nil
    private var onDisconnectHandler: ((_ error: Error?) -> ())? = nil

    public init() {
    }
    
    public func connect(url: URL) {
//        let socket = WebSocket(url: url)
//        socket.onText = onTextHandler
//        socket.onConnect = onConnectHandler
//        socket.onDisconnect = onDisconnectHandler
//        socket.connect()
//        self.socket = socket
    }
    
    public func disconnect() {
//        socket?.disconnect()
//        socket = nil
    }
    
    public func on(connect handler: @escaping () -> ()) {
        onConnectHandler = handler
    }
    
    public func on(diconnect handler: @escaping (_ error: Error?) -> ()) {
        onDisconnectHandler = handler
    }
    
    public func on(text handler: @escaping (_ text: String) -> ()) {
        onTextHandler = handler
    }
    
    public func send(text: String) {
//        socket?.write(string: text)
    }
    
}
