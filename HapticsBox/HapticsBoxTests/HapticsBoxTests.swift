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
        
        let str = TestBundleLoader().load(name: "EventParameter", extension: "ahap")
        let ptrn = try! JSONDecoder().decode( [String: [CodableCHHapticEventParameter]].self, from: str.data(using: .utf8)!)
        print("str: \n\(ptrn["EventParameters"]!)")

        let eventStr = TestBundleLoader().load(name: "Event", extension: "ahap")
        let event = try! JSONDecoder().decode( [String: CodableCHHapticEvent].self, from: eventStr.data(using: .utf8)!)
        print("str: \n\(event["Event"]!)")

        let hbStr = TestBundleLoader().load(name: "Full", extension: "ahap")
        do {
            let hb = try JSONDecoder().decode( CodableCHHapticPattern.self, from: hbStr.data(using: .utf8)!)
            print("str: \n\(hb)")
        } catch let error {
            print("error: \(error)")
        }

        XCTAssertEqual("", "")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
