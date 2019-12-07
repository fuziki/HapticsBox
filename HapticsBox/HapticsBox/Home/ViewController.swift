//
//  ViewController.swift
//  HapticsBox
//
//  Created by fuziki on 2019/11/23.
//  Copyright © 2019 fuziki.factory. All rights reserved.
//

import UIKit
import CoreHaptics

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

class ViewController: UIViewController {
    
    let storyboardNames = [(section: "Applications", cells: ["HapticSampler", "HeartBeats"])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        
        AppController.shared.set(goHomeHandler: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        })
    }
    
    private func setupUI() {
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
        let name = self.storyboardNames[indexPath.section].cells[indexPath.item]
        let storyboard: UIStoryboard = UIStoryboard(name: name, bundle: nil)
        let nextView = storyboard.instantiateInitialViewController()
        self.present(nextView!, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDataSource {
    //number of section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return storyboardNames.count
    }

    //number of cells
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.storyboardNames[section].cells.count
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
        collectionReusableView.set(labelText: self.storyboardNames[indexPath.section].section)
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
        collectionViewCell.set(labelText: self.storyboardNames[indexPath.section].cells[indexPath.item])
        return collectionViewCell
    }
}

extension ViewController:  UICollectionViewDelegateFlowLayout {
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
