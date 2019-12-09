//
//  CollisionViewController.swift
//  HapticsBox
//
//  Created by fuziki on 2019/12/09.
//  Copyright © 2019 fuziki.factory. All rights reserved.
//

import UIKit
import CoreHaptics
import ARKit

class CollisionViewController: UIViewController {
    
    private var heartBeatsPlayer: CHHapticAdvancedPatternPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        heartBeatsPlayer = HapticsBoxEngine.shared.makeAdvancedPlayer(fileName: "OnceHeartbeat")
        heartBeatsPlayer.loopEnabled = true
        heartBeatsPlayer.playbackRate = 1
        heartBeatsPlayer.loopEnd = 1
        do {
            try heartBeatsPlayer?.start(atTime: 0)
        } catch { // Engine startup errors
            HBLogger.log("An error occured playing \(error).")
        }

    }
    
    @IBAction func closeView(_ sender: Any) {
        AppController.shared.goHome()
    }
    
}
