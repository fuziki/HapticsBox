//
//  TanuClient.swift
//  HapticsBox
//
//  Created by fuziki on 2019/12/15.
//  Copyright © 2019 fuziki.factory. All rights reserved.
//

import Foundation
import Starscream

class TanuClient {
    private var socket: WebSocket? = nil
    
    public var isConnected: Bool {
        return socket?.isConnected ?? false
    }
    
    private var onTextHandler: ((String) -> ())? = nil
    
    public init() {
    }
    
    public func connect(url: URL) {
        let socket = WebSocket(url: url)
        socket.onText = onTextHandler
        socket.connect()
        self.socket = socket
    }
    
    public func disconnect() {
        socket?.disconnect()
        socket = nil
    }
    
    public func on(text handler: @escaping (String) -> ()) {
        onTextHandler = handler
    }
    
    public func send(text: String) {
        socket?.write(string: text)
    }
    
}
