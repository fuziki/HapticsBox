//
//  HapticsBoxTests.swift
//  HapticsBoxTests
//
//  Created by fuziki on 2019/11/23.
//  Copyright © 2019 fuziki.factory. All rights reserved.
//

import XCTest
import CoreHaptics
@testable import HapticsBox

class HapticsBoxTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let ahaps: [(bundle: TestBundleLoader.BundlePosition, name: String, ext: String)] =
            [(bundle: .`self`, name: "Full", ext: "ahap"),
             (bundle: .main, name: "Boing", ext: "ahap"),
             (bundle: .main, name: "Gravel", ext: "ahap"),
             (bundle: .main, name: "Inflate", ext: "ahap"),
             (bundle: .main, name: "Oscillate", ext: "ahap"),
             (bundle: .main, name: "Rumble", ext: "ahap"),
             (bundle: .main, name: "Sparkle", ext: "ahap")]
        
        for ahap in ahaps {
            HBLogger.log("test: \(ahap)")
            let str = TestBundleLoader().load(bundle: ahap.bundle, name: ahap.name, extension: ahap.ext)
            let success = AHAPParser.test(ahapString: str)
            XCTAssertEqual(success != nil, true)
        }
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
