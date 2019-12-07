//
//  HeartBeatsViewController.swift
//  HapticsBox
//
//  Created by fuziki on 2019/12/07.
//  Copyright © 2019 fuziki.factory. All rights reserved.
//


import UIKit
import CoreHaptics
import ARKit

class HeartBeatsViewController: UIViewController {
    
    private var heartBeatsPlayer: CHHapticAdvancedPatternPlayer!
    private var arSession: ARSession!
    
    @IBOutlet weak var imageView: UIImageView!

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
            print("An error occured playing \(error).")
        }
        
        arSession = ARSession()
        arSession.delegate = self
        let conf = ARFaceTrackingConfiguration()
        arSession.run(conf, options: [])
        
        updateImage(number: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        try? heartBeatsPlayer.stop(atTime: 0)
        arSession.pause()
    }
    
    func updateFaceAnchor(anchor: ARFaceAnchor) {
        var len = anchor.transform.columns.3.y
        let min: Float = 0.1
        let max: Float = 0.3
        len = simd_clamp(len, min, max)
        len = (len - min) / (max - min)
        updateImage(len: len)
        let rate = 2 - len
        heartBeatsPlayer.playbackRate = rate
        print("face: \(anchor.transform.columns.3.y), rate: \(rate)")
    }

    func updateImage(len: Float) {
        let num: Int
        switch len {
        case let l where l >= 1:
            num = 1
        case let l where l > 0.5:
            num = 2
        case let l where l > 0.2:
            num = 3
        default:
            num = 4
        }
        updateImage(number: num)
    }

    func updateImage(number: Int) {
        let num = min(max(number, 1), 4)
        imageView.image = UIImage(named: "HeartBeats00\(num).PNG")
    }

    
    @IBAction func closeView(_ sender: Any) {
        AppController.shared.goHome()
    }
    
}

extension HeartBeatsViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        anchors.compactMap({$0 as? ARFaceAnchor}).forEach({ [weak self] in
            self?.updateFaceAnchor(anchor: $0)
        })
    }
}
