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
//            let pattern1 = CHHapticPattern(events: <#T##[CHHapticEvent]#>, parameterCurves: <#T##[CHHapticParameterCurve]#>)
//            let pattern2 = CHHapticPattern(events: <#T##[CHHapticEvent]#>, parameters: <#T##[CHHapticDynamicParameter]#>)
            return nil
        } catch let error {
            print("error: \(error)")
            return nil
        }
    }

    internal static func test(ahapString: String) -> Bool {
        struct pattern: Decodable {
            public var Event: CodableHapticEvent?
            public var ParameterCurve: CodableHapticParameterCurve?
        }
        struct ahap: Decodable {
            public var Pattern: [pattern]
        }
        do {
            _ = try JSONDecoder().decode(ahap.self, from: ahapString.data(using: .utf8)!)
            return true
        } catch let error {
            print("failed: \(error)")
        }
        return false
    }
}

fileprivate class CodableHapticPattern: Decodable {
    public var events: [CHHapticEvent] = []
    public var parameters: [CHHapticDynamicParameter]? = nil
    public var parameterCurves: [CHHapticParameterCurve]? = nil
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let elements = try container.decode([CodableHapticPatternElement].self, forKey: .pattern)
        self.events = elements.compactMap({$0.event})
        let parameters = elements.compactMap({$0.parameter})
        if parameters.count > 0 {
            self.parameters = parameters
        }
        let parameterCurves = elements.compactMap({$0.parameterCurve})
        if parameterCurves.count > 0 {
            self.parameterCurves = parameterCurves
        }
    }
    private enum CodingKeys: String, CodingKey {
        case pattern = "Pattern"
    }
}

fileprivate struct CodableHapticPatternElement: Decodable {
    public var event: CodableHapticEvent?
    public var parameter: CocableHapticDynamicParameter?
    public var parameterCurve: CodableHapticParameterCurve?
    enum CodingKeys: String, CodingKey {
        case event = "Event"
        case parameter = "Parameter"
        case parameterCurve = "ParameterCurve"
    }
}

fileprivate class CocableHapticDynamicParameter: CHHapticDynamicParameter, Decodable {
    required convenience public init(from decoder: Decoder) throws {
        self.init(parameterID: CHHapticDynamicParameter.ID(rawValue: ""),
                  value: 0,
                  relativeTime: 0)
    }
}

fileprivate class CodableHapticParameterCurve: CHHapticParameterCurve, Decodable {
    private class CodableControlPoint: CHHapticParameterCurve.ControlPoint, Decodable {
        required convenience public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let time = try container.decode(Float.self, forKey: .time)
            let value = try container.decode(Float.self, forKey: .parameterValue)
            self.init(relativeTime: TimeInterval(time), value: value)
        }
        private enum CodingKeys: String, CodingKey {
            case time = "Time"
            case parameterValue = "ParameterValue"
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .parameterId)
        let points = try container.decode(CodableControlPoint.self, forKey: .parameterCurveControlPoints)
        let time = try container.decode(Float.self, forKey: .time)
        self.init(parameterID: CHHapticDynamicParameter.ID(rawValue: id),
                  controlPoints: [points],
                  relativeTime: TimeInterval(time))
    }
    private enum CodingKeys: String, CodingKey {
        case parameterId = "ParameterID"
        case parameterCurveControlPoints = "ParameterCurveControlPoints"
        case time = "Time"
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

