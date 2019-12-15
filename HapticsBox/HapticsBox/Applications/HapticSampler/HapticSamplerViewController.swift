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
    let ahapFiles = [(section: "sample haptics sampler",
                      cells:["Boing", "Gravel", "Inflate", "Oscillate", "Rumble", "Sparkle"])]
    
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
    
    internal func play(section: String, ahap: String) {
        switch section {
        case ahapFiles[0].section:
            HapticsBoxEngine.shared.play(fileName: ahap)
        default:
            break
        }
    }
}

extension HapticSamplerViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = ahapFiles[indexPath.section].section, item = ahapFiles[indexPath.section].cells[indexPath.item]
        HBLogger.log("section: \(section), item: \(item)")
        self.play(section: section, ahap: item)
    }
}

extension HapticSamplerViewController: UICollectionViewDataSource {
    //number of section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.ahapFiles.count
    }

    //number of cells
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.ahapFiles[section].cells.count
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
        collectionReusableView.set(labelText: self.ahapFiles[indexPath.section].section)
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
        collectionViewCell.set(labelText: self.ahapFiles[indexPath.section].cells[indexPath.item])
        return collectionViewCell
    }
}

extension HapticSamplerViewController:  UICollectionViewDelegateFlowLayout {
    //cell size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 60)
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
        return CGSize(width: self.view.frame.size.width, height:60)
    }
}
