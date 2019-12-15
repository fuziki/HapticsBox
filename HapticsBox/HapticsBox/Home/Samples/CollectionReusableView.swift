//
//  CollectionReusableView.swift
//  HapticsBox
//
//  Created by fuziki on 2019/12/05.
//  Copyright © 2019 fuziki.factory. All rights reserved.
//

import Foundation
import UIKit

class CollectionReusableView: UICollectionReusableView {
    private var label: UILabel!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        label.font = .systemFont(ofSize: 14, weight: UIFont.Weight(rawValue: 1))
        label.textColor = UIColor.black
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        self.addSubview(label)

        self.backgroundColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    public func set(labelText: String) {
        label.text = labelText
    }
}
