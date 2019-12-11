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
import CoreMotion
import simd

class CollisionViewController: UIViewController {
    
    @IBOutlet weak var ballView: UIView!
        
    private var ballSize: Float!
    private var ballPosition: SIMD2<Float> {
        let x = Float(ballView.frame.origin.x), y = Float(ballView.frame.origin.y)
        return SIMD2<Float>(x + ballSize / 2, y + ballSize / 2)
    }
    private var ballVelocity: SIMD2<Float> = SIMD2<Float>(0, 0)
    private var motionMgr: CMMotionManager!
    private let motionQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ballSize = Float(ballView.frame.width)
        
        motionMgr = CMMotionManager()
        motionMgr.startDeviceMotionUpdates(to: motionQueue,
                                           withHandler: { (motion: CMDeviceMotion?, error: Error?) in
            if let e = error {
                HBLogger.assert("failed to get motion, error: \(e)")
            } else if let m = motion {
                DispatchQueue.main.async { [weak self] in
                    self?.update(motion: m)
                }
            }
        })
    }
    
    @IBAction func closeView(_ sender: Any) {
        AppController.shared.goHome()
    }
    
    private func update(motion: CMDeviceMotion) {
        let g: SIMD2<Float> = SIMD2<Float>(Float(motion.gravity.x), Float(-motion.gravity.y))
        ballVelocity += g * 0.1
        let p = ballPosition + ballVelocity
        setBall(position: p)
    }
    
    private func setBall(position: SIMD2<Float>) {
        DispatchQueue.main.async { [weak self] in
            let ballSize = self?.ballSize ?? 0
            self?.ballView.frame.origin = CGPoint(x: CGFloat(position.x - ballSize / 2), y: CGFloat(position.y - ballSize / 2))
        }
    }
    
    
}
