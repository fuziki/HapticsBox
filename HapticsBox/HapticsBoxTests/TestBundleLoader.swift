//
//  TestBundleLoader.swift
//  HapticsBoxTests
//
//  Created by fuziki on 2019/11/23.
//  Copyright © 2019 fuziki.factory. All rights reserved.
//

import Foundation

class TestBundleLoader {
    func load(name: String, extension ext: String) -> String {
        let testBundle = Bundle(for: type(of: self))
        let url = testBundle.url(forResource: name, withExtension: ext)!
        let data = try! Data(contentsOf: url)
        let str = String(data: data, encoding: .utf8)!
        return str
    }
}
