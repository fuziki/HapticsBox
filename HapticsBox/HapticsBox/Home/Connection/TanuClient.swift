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
    
    private var socket: WebSocket?
    
    init() {
        if let url = URL(string: "") {
            socket = WebSocket(url: url)
        }
    }
    
}
