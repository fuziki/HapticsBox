//
//  ViewController.swift
//  HapticsBox
//
//  Created by fuziki on 2019/11/23.
//  Copyright © 2019 fuziki.factory. All rights reserved.
//

import UIKit
import CoreHaptics

class ViewController: UIViewController {
    
//    var player: CHHapticAdvancedPatternPlayer? = nil
    var player: CHHapticPatternPlayer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        (bundle: .main, name: "Boing", ext: "ahap"),
//        (bundle: .main, name: "Gravel", ext: "ahap"),
//        (bundle: .main, name: "Inflate", ext: "ahap"),
//        (bundle: .main, name: "Oscillate", ext: "ahap"),
//        (bundle: .main, name: "Rumble", ext: "ahap"),
//        (bundle: .main, name: "Sparkle", ext: "ahap")]

        player = HapticsBoxEngine.shared.makePlayer(fileName: "Oscillate")
//        player?.loopEnabled = true
//        player?.loopEnd = 1.0
//        player?.playbackRate = 1
//        HapticsBoxEngine.shared.play2(fileName: "Inflate")
        
//        if let str = FileLoader().loadString(fileName: "Inflate", extension: "ahap"),
//            let pattern = AHAPParser.test(ahapString: str) {
//            do {
//                var sum: TimeInterval = 0
//                for p in pattern.parameters {
//                    try player?.scheduleParameterCurve(p, atTime: sum)
//                    sum += p.relativeTime
//                }
//            } catch { // Engine startup errors
//                print("An error occured playing \(error).")
//            }
//        }
        
        do {
            try player?.start(atTime: 0)
        } catch { // Engine startup errors
            print("An error occured playing \(error).")
        }
    }
}
