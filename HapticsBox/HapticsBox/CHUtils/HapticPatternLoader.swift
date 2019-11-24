//
//  CodableHapticPattern.swift
//  HapticsBox
//
//  Created by fuziki on 2019/11/24.
//  Copyright © 2019 fuziki.factory. All rights reserved.
//

import CoreHaptics

//Apple Haptic and Audio Pattern (AHAP) file parser
public class AHAPParser {
    public static func parse(ahapString: String) -> CHHapticPattern? {
        do {
            guard let data = ahapString.data(using: .utf8) else { return nil }
            let hapticPattern = try JSONDecoder().decode( CodableHapticPattern.self, from: data)
            return hapticPattern
        } catch let error {
            print("error: \(error)")
            return nil
        }
    }
}

fileprivate class CodableHapticPattern: CHHapticPattern, Decodable {
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        struct tmp : Decodable {
            public var Event: CodableHapticEvent
        }
        let pattern = try container.decode([tmp].self, forKey: .pattern)
        try self.init(events: pattern.map({$0.Event}), parameters: [])
    }
    private enum CodingKeys: String, CodingKey {
        case pattern = "Pattern"
    }
}

fileprivate class CodableHapticEvent: CHHapticEvent, Decodable {
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let time = try container.decode(Float.self, forKey: .time)
        let event = try container.decode(String.self, forKey: .eventType)
        let param = try container.decode([CodableHapticEventParameter].self, forKey: .eventParameters)
        self.init(eventType: CHHapticEvent.EventType(rawValue: event), parameters: param, relativeTime: TimeInterval(time))
    }
    private enum CodingKeys: String, CodingKey {
        case time = "Time"
        case eventType = "EventType"
        case eventParameters = "EventParameters"
    }
}

fileprivate class CodableHapticEventParameter: CHHapticEventParameter, Decodable {
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

