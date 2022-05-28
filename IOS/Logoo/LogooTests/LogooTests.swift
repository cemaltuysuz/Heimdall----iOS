//
//  LogooTests.swift
//  LogooTests
//
//  Created by cemal tüysüz on 20.01.2022.
//

import XCTest
@testable import Logoo

class LogooTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        XCTAssertTrue("cemal" == getOtherUserIDFromConnectionKey("tuysuz"))
    }
    
    func getOtherUserIDFromConnectionKey(_ firstUserID:String) -> String {
        let seperator = "."
        
        let key = "cemal.tuysuz"
        let removedSeperator = key.replacingOccurrences(of: seperator, with: "")
        let removedOtherUserId = removedSeperator.replacingOccurrences(of: firstUserID, with: "")
        
        return removedOtherUserId
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
