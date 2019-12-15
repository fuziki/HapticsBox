//
//  HomeViewController.swift
//  HapticsBox
//
//  Created by fuziki on 2019/12/15.
//  Copyright © 2019 fuziki.factory. All rights reserved.
//

import Foundation
import UIKit

class AppController {
    public static let shared = AppController()
    private init() {}
    private var goHomeHandler: (() -> Void)? = nil
    fileprivate func set(goHomeHandler: (() -> Void)?) {
        self.goHomeHandler = goHomeHandler
    }
    public func goHome() {
        goHomeHandler?()
    }
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let storyboardNames = [(section: "Applications",
                            cells: ["HapticSampler", "HeartBeats", "Collision"])]
    
    private var audioTransitionStoryboard: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        AppController.shared.set(goHomeHandler: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        })
    }
}
