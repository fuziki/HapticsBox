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
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.white
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(CollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.view.addSubview(collectionView)
    }
}

extension ViewController: UICollectionViewDelegate {
    // セル選択時の処理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(data[indexPath.section][indexPath.row])
    }
}

extension ViewController: UICollectionViewDataSource {
    // セルの数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data[section].count
    }
    
    // ヘッダーの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.data.count
    }
    
    // セルの設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",for: indexPath as IndexPath) as! CollectionViewCell
        let cellText = data[indexPath.section][indexPath.item]
        cell.set(labelText: cellText)
        return cell
    }
    
    // ヘッダーの設定
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let collectionViewHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! CollectionReusableView
        let headerText = sectionName[indexPath.section][indexPath.item]
        collectionViewHeader.set(labelText: headerText)
        return collectionViewHeader
    }
}

extension ViewController:  UICollectionViewDelegateFlowLayout {
    // セルの大きさ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 100)
    }
    
    // セルの余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    // ヘッダーのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height:50)
    }
}
