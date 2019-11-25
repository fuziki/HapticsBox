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
    
    public func makeAdvancedPlayer(withFileName fileName: String, extension ext: String = "ahap") -> CHHapticAdvancedPatternPlayer? {
        if let str = FileLoader().loadString(fileName: fileName, extension: ext) {
            return self.makeAdvancedPlayer(withAhapString: str)
        }
        return nil
    }
    
    public func makeAdvancedPlayer(withAhapString ahapString: String) -> CHHapticAdvancedPatternPlayer? {
        if let pattern = AHAPParser.parse(ahapString: ahapString) {
            return self.makeAdvancedPlayer(withPattern: pattern)
        }
        return nil
    }
    
    public func makeAdvancedPlayer(withPattern pattern: CHHapticPattern) -> CHHapticAdvancedPatternPlayer? {
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
