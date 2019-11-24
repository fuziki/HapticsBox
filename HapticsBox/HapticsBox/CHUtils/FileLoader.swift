//
//  FileLoader.swift
//  HapticsBox
//
//  Created by fuziki on 2019/11/24.
//  Copyright © 2019 fuziki.factory. All rights reserved.
//

import Foundation

public class FileLoader {
    public func loadString(fileName: String, extension ext: String) -> String? {
        let testBundle = Bundle(for: type(of: self))
        guard let url = testBundle.url(forResource: fileName, withExtension: ext),
            let data = try? Data(contentsOf: url),
            let str = String(data: data, encoding: .utf8) else {
                print("failed load string file, file name: \(fileName), ext: \(ext)")
                return nil
        }
        return str
    }
}
