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
    
    var player: CHHapticAdvancedPatternPlayer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        (bundle: .main, name: "Boing", ext: "ahap"),
//        (bundle: .main, name: "Gravel", ext: "ahap"),
//        (bundle: .main, name: "Inflate", ext: "ahap"),
//        (bundle: .main, name: "Oscillate", ext: "ahap"),
//        (bundle: .main, name: "Rumble", ext: "ahap"),
//        (bundle: .main, name: "Sparkle", ext: "ahap")]

//        player = HapticsBoxEngine.shared.makeAdvancedPlayer(withFileName: "Boing")
//        player?.loopEnabled = true
//        player?.loopEnd = 1.0
//        player?.playbackRate = 1
        HapticsBoxEngine.shared.play(fileName: "Boing")
        do {
//            try player?.start(atTime: 0)
        } catch { // Engine startup errors
            print("An error occured playing \(error).")
        }
    }
}
