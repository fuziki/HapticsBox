//
//  HapticSamplerViewController.swift
//  HapticsBox
//
//  Created by fuziki on 2019/12/07.
//  Copyright © 2019 fuziki.factory. All rights reserved.
//

import UIKit
import CoreHaptics

class HapticSamplerViewController: UIViewController {
    
    let sectionNames = ["play", "nomal player", "advance player"]
    let ahapFiles = ["Boing", "Gravel", "Inflate", "Oscillate", "Rumble", "Sparkle"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.register(CollectionViewCell.self,
                                forCellWithReuseIdentifier: String(describing: CollectionViewCell.self))
        collectionView.register(CollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: String(describing: CollectionReusableView.self))
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func closeViewController(_ sender: Any) {
        AppController.shared.goHome()
    }
    
    private var adPlayer: CHHapticAdvancedPatternPlayer?
    private var lastAdPlayerAHAP: String?
    internal func play(section: String, ahap: String) {
        if let adPlayer = self.adPlayer, let lastAdPlayerAHAP = self.lastAdPlayerAHAP {
            try? adPlayer.stop(atTime: 0)
            self.adPlayer = nil
            self.lastAdPlayerAHAP = nil
            if section == sectionNames[2], lastAdPlayerAHAP == ahap {
                return
            }
        }
        if lastAdPlayerAHAP == ahap {
            return
        }
        switch section {
        case sectionNames[0]:   //play
            HapticsBoxEngine.shared.play(fileName: ahap)
        case sectionNames[1]:   //nomal player
            let player = HapticsBoxEngine.shared.makePlayer(fileName: ahap)
            do {
                try player?.start(atTime: 0)
            } catch { // Engine startup errors
                HBLogger.log("An error occured playing \(error).")
            }
        case sectionNames[2]:   //advance player
            lastAdPlayerAHAP = ahap
            adPlayer = HapticsBoxEngine.shared.makeAdvancedPlayer(fileName: ahap)
            adPlayer?.loopEnabled = true
            adPlayer?.playbackRate = 2
            adPlayer?.loopEnd = 2
            do {
                try adPlayer?.start(atTime: 0)
            } catch { // Engine startup errors
                HBLogger.log("An error occured playing \(error).")
            }
        default:
            break
        }
    }
}

extension HapticSamplerViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sectionNames[indexPath.section], item = ahapFiles[indexPath.item]
        HBLogger.log("section: \(section), item: \(item)")
        self.play(section: section, ahap: item)
    }
}

extension HapticSamplerViewController: UICollectionViewDataSource {
    //number of section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionNames.count
    }

    //number of cells
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.ahapFiles.count
    }
    
    //section
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView: UICollectionReusableView = collectionView
            .dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                              withReuseIdentifier: String(describing: CollectionReusableView.self),
                                              for: indexPath)
        guard let collectionReusableView = reusableView as? CollectionReusableView else {
            return reusableView
        }
        collectionReusableView.set(labelText: self.sectionNames[indexPath.section])
        return collectionReusableView
    }

    //cell
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView
            .dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self),
                                 for: indexPath)
        guard let collectionViewCell = cell as? CollectionViewCell else {
            return cell
        }
        collectionViewCell.set(labelText: self.ahapFiles[indexPath.item])
        return collectionViewCell
    }
}

extension HapticSamplerViewController:  UICollectionViewDelegateFlowLayout {
    //cell size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 40)
    }
    
    //inset size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //secsion size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height:40)
    }
}
