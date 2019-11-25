//
//  TestBundleLoader.swift
//  HapticsBoxTests
//
//  Created by fuziki on 2019/11/23.
//  Copyright © 2019 fuziki.factory. All rights reserved.
//

import Foundation

class TestBundleLoader {
    public enum BundlePosition {
        case main
        case `self`
    }
    func load(bundle bundlePosition: BundlePosition, name: String, extension ext: String) -> String {
        let bundle: Bundle
        switch bundlePosition {
        case .main:
            bundle = Bundle.main
        case .`self`:
            bundle = Bundle(for: type(of: self))
        }
        let url = bundle.url(forResource: name, withExtension: ext)!
        let data = try! Data(contentsOf: url)
        let str = String(data: data, encoding: .utf8)!
        return str
    }
}
