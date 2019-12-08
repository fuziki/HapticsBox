//
//  HapticsBoxLogger.swift
//  HapticsBox
//
//  Created by fuziki on 2019/11/24.
//  Copyright © 2019 fuziki.factory. All rights reserved.
//

import Foundation

public class HBLogger {
    static func assert(_ msg: String, file: String = #file, function: String = #function, line: Int = #line) {
        HBLogger.log("asset: \(msg), file: \(file.components(separatedBy: "/").last ?? ""), line: \(line), func: \(function)")
    }
    static func log(_ msg: String, file: String = #file, function: String = #function, line: Int = #line) {
        HBLogger.log("log: \(msg), file: \(file.components(separatedBy: "/").last ?? ""), line: \(line), func: \(function)")
    }
}
