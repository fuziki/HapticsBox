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
            HBLogger.log("An error occured playing \(error).")
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
            HBLogger.log("error: \(error)")
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
            HBLogger.log("error: \(error)")
        }
        return nil
    }
    
    private func startEngine() {
        do {
            engine = try CHHapticEngine()
        } catch let error {
            HBLogger.log("Engine Creation Error: \(error)")
        }
        
        engine?.stoppedHandler = { reason in
            HBLogger.log("The engine stopped for reason: \(reason.rawValue)")
            switch reason {
            case .audioSessionInterrupt: HBLogger.log("Audio session interrupt")
            case .applicationSuspended: HBLogger.log("Application suspended")
            case .idleTimeout: HBLogger.log("Idle timeout")
            case .systemError: HBLogger.log("System error")
            case .notifyWhenFinished: HBLogger.log("Playback finished")
            @unknown default:
                HBLogger.log("Unknown error")
            }
        }
        
        do {
            try engine?.start()
        } catch { // Engine startup errors
            HBLogger.log("An error occured playing \(error).")
        }

        // The reset handler provides an opportunity for your app to restart the engine in case of failure.
        engine?.resetHandler = {
            // Try restarting the engine.
            HBLogger.log("The engine reset --> Restarting now!")
            do {
                try self.engine?.start()
            } catch {
                HBLogger.log("Failed to restart the engine: \(error)")
            }
        }
    }
}
