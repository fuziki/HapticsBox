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
        
        player = HapticsBoxEngine.shared.makeAdvancedPlayer(withFileName: "OnceHeartbeat")
        player?.loopEnabled = true
        player?.loopEnd = 1.0
        player?.playbackRate = 2
        do {
            try player?.start(atTime: 0)
        } catch { // Engine startup errors
            print("An error occured playing \(error).")
        }
    }
}
