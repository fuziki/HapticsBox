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
    
    let sectionName = [["Section1"], ["Section2"], ["Section3"]]
    let data = [["item1", "item2", "item3"], ["item4", "item5", "item6"], ["item7", "item8", "item9", "item9", "item9", "item9", "item9", "item9", "item9", "item9", "item9", "item9", "item9", "item9", "item9", "item9", "item9", "item9", "item9", "item9", "item9", "item9"]]
    
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
        
        let layout = UICollectionViewFlowLayout()
        let collectionView =
            UICollectionView(frame: CGRect(x: 0, y: 0,
                                           width: self.view.frame.size.width,
                                           height: self.view.frame.size.height),
                             collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(CollectionViewCell.self,
                                forCellWithReuseIdentifier: String(describing: CollectionViewCell.self))
        collectionView.register(CollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: String(describing: CollectionReusableView.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
    }
}

extension ViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(data[indexPath.section][indexPath.row])
    }
}

extension ViewController: UICollectionViewDataSource {
    //number of section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.data.count
    }

    //number of cells
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.data[section].count
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
        let headerText = sectionName[indexPath.section][indexPath.item]
        collectionReusableView.set(labelText: headerText)
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
        let cellText = data[indexPath.section][indexPath.item]
        collectionViewCell.set(labelText: cellText)
        return collectionViewCell
    }
}

extension ViewController:  UICollectionViewDelegateFlowLayout {
    //cell size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 100)
    }
    
    //inset size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10)
    }
    
    //secsion size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height:50)
    }
}
