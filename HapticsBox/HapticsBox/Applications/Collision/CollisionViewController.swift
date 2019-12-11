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
    private var ballPosition: SIMD2<Float> = SIMD2<Float>(0, 0)
    private var ballVelocity: SIMD2<Float> = SIMD2<Float>(0, 0)
    private var motionMgr: CMMotionManager!
    private let motionQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ballSize = Float(ballView.frame.width)
        let x = Float(ballView.frame.origin.x), y = Float(ballView.frame.origin.y)
        ballPosition = SIMD2<Float>(x + ballSize / 2, y + ballSize / 2)

        
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
        calcBallPosition(gravity: g)
        calcCollision()
        setBall(position: ballPosition)
    }
    
    private func calcBallPosition(gravity: SIMD2<Float>) {
        ballVelocity += gravity * 0.35
        func dampVelocity(v: Float, f: Float) -> Float {
            if abs(v) < f { return 0 }
            return (abs(v) - f) * (v > 0 ? 1 : -1)
        }
        let sf: Float = 0.03
        ballVelocity = SIMD2<Float>(dampVelocity(v: ballVelocity.x, f: sf), dampVelocity(v: ballVelocity.y, f: sf))
        let p = ballPosition + ballVelocity
        print("g: \(gravity), v: \(ballVelocity)")
        ballPosition = p
    }
    
    private func calcCollision() {
        var x = ballPosition.x
        if x < ballSize / 2 {
            x = ballSize / 2
            ballVelocity.x = 0
        } else if x > Float(self.view.frame.width) - ballSize / 2 {
            x = Float(self.view.frame.width) - ballSize / 2
            ballVelocity.x = 0
        }
        var y = ballPosition.y
        if y < ballSize / 2 {
            y = ballSize / 2
            ballVelocity.y = 0
        } else if y > Float(self.view.frame.height) - ballSize / 2 {
            y = Float(self.view.frame.height) - ballSize / 2
            ballVelocity.y = 0
        }
        ballPosition = SIMD2<Float>(x, y)
    }
    
    private func setBall(position: SIMD2<Float>) {
        DispatchQueue.main.async { [weak self] in
            let ballSize = self?.ballSize ?? 0
            self?.ballView.frame.origin = CGPoint(x: CGFloat(position.x - ballSize / 2), y: CGFloat(position.y - ballSize / 2))
        }
    }
    
    
}
