//
//  HapticsBoxEngine.swift
//  HapticsBox
//
//  Created by fuziki on 2019/11/24.
//  Copyright © 2019 fuziki.factory. All rights reserved.
//

import CoreHaptics

public class HapticsBoxEngine {
    public static var shared = HapticsBoxEngine()
    
    var engine: CHHapticEngine? = nil
    private init() {
        startEngine()
    }
    
    public func play(fileName: String, extension ext: String = "ahap") {
        guard let path = Bundle.main.path(forResource: fileName, ofType: ext) else {
            return
        }
        do {
            try engine?.playPattern(from: URL(fileURLWithPath: path))
        } catch let error {
            print("An error occured playing \(error).")
        }
    }
    
    public func play2(fileName: String, extension ext: String = "ahap") {
        if let str = FileLoader().loadString(fileName: fileName, extension: ext),
            let pattern:CHHapticPattern = AHAPParser.parse(ahapString: str) {
            do {
                let dic: [CHHapticPattern.Key : Any] = try pattern.exportDictionary()
                let data = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
                
                try engine?.playPattern(from: data)
            } catch let error {
                print("An error occured playing \(error).")
            }
        }
    }
    
    public func makePlayer(fileName: String, extension ext: String = "ahap") -> CHHapticPatternPlayer? {
        if let str = FileLoader().loadString(fileName: fileName, extension: ext) {
            return self.makePlayer(ahapString: str)
        }
        return nil
    }
    
    public func makePlayer(ahapString: String) -> CHHapticPatternPlayer? {
        if let pattern: CHHapticPattern = AHAPParser.parse(ahapString: ahapString) {
            return self.makePlayer(pattern: pattern)
        }
        return nil
    }
    
    public func makePlayer(pattern: CHHapticPattern) -> CHHapticPatternPlayer? {
        do {
            let player = try engine?.makePlayer(with: pattern)
            return player
        } catch let error {
            print("error: \(error)")
        }
        return nil
    }

    public func makeAdvancedPlayer(fileName: String, extension ext: String = "ahap") -> CHHapticAdvancedPatternPlayer? {
        if let str = FileLoader().loadString(fileName: fileName, extension: ext) {
            return self.makeAdvancedPlayer(ahapString: str)
        }
        return nil
    }
    
    public func makeAdvancedPlayer(ahapString: String) -> CHHapticAdvancedPatternPlayer? {
        if let pattern: CHHapticPattern = AHAPParser.parse(ahapString: ahapString) {
            return self.makeAdvancedPlayer(pattern: pattern)
        }
        return nil
    }
    
    public func makeAdvancedPlayer(pattern: CHHapticPattern) -> CHHapticAdvancedPatternPlayer? {
        do {
            let player = try engine?.makeAdvancedPlayer(with: pattern)
            return player
        } catch let error {
            print("error: \(error)")
        }
        return nil
    }
    
    private func startEngine() {
        do {
            engine = try CHHapticEngine()
        } catch let error {
            print("Engine Creation Error: \(error)")
        }
        
        engine?.stoppedHandler = { reason in
            print("The engine stopped for reason: \(reason.rawValue)")
            switch reason {
            case .audioSessionInterrupt: print("Audio session interrupt")
            case .applicationSuspended: print("Application suspended")
            case .idleTimeout: print("Idle timeout")
            case .systemError: print("System error")
            case .notifyWhenFinished: print("Playback finished")
            @unknown default:
                print("Unknown error")
            }
        }
        
        do {
            try engine?.start()
        } catch { // Engine startup errors
            print("An error occured playing \(error).")
        }

        // The reset handler provides an opportunity for your app to restart the engine in case of failure.
        engine?.resetHandler = {
            // Try restarting the engine.
            print("The engine reset --> Restarting now!")
            do {
                try self.engine?.start()
            } catch {
                print("Failed to restart the engine: \(error)")
            }
        }
    }
}
