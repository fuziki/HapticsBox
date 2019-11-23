//
//  ViewController.swift
//  HapticsBox
//
//  Created by fuziki on 2019/11/23.
//  Copyright © 2019 fuziki.factory. All rights reserved.
//

import UIKit
import CoreHaptics

class AHAPLoader {
    func load(name: String, extension ext: String) -> String {
        let testBundle = Bundle(for: type(of: self))
        let url = testBundle.url(forResource: name, withExtension: ext)!
        let data = try! Data(contentsOf: url)
        let str = String(data: data, encoding: .utf8)!
        return str
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let hbStr = AHAPLoader().load(name: "Heartbeats", extension: "ahap")
        do {
            let hb = try JSONDecoder().decode( CodableCHHapticPattern.self, from: hbStr.data(using: .utf8)!)
            print("str: \n\(hb)")
        } catch let error {
            print("error: \(error)")
        }
    }
}

class CodableCHHapticPattern: CHHapticPattern, Decodable {
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        struct tmp : Decodable{
            public var Event: CodableCHHapticEvent
        }
        let pattern = try container.decode([tmp].self, forKey: .pattern)
        try self.init(events: pattern.map({$0.Event}), parameters: [])
    }
    private enum CodingKeys: String, CodingKey {
        case pattern = "Pattern"
    }
}

class CodableCHHapticEvent: CHHapticEvent, Decodable {
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let time = try container.decode(Float.self, forKey: .time)
        let event = try container.decode(String.self, forKey: .eventType)
        let param = try container.decode([CodableCHHapticEventParameter].self, forKey: .eventParameters)
        self.init(eventType: CHHapticEvent.EventType(rawValue: event), parameters: param, relativeTime: TimeInterval(time))
    }
    private enum CodingKeys: String, CodingKey {
        case time = "Time"
        case eventType = "EventType"
        case eventParameters = "EventParameters"
    }
}

class CodableCHHapticEventParameter: CHHapticEventParameter, Decodable {
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idStr = try container.decode(String.self, forKey: .parameterId)
        let value = try container.decode(Float.self, forKey: .parameterValue)
        self.init(parameterID: CHHapticEvent.ParameterID(rawValue: idStr), value: value)
    }
    private enum CodingKeys: String, CodingKey {
        case parameterId = "ParameterID"
        case parameterValue = "ParameterValue"
    }
}

