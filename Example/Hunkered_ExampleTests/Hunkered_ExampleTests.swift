//
//  Hunkered_ExampleTests.swift
//  Hunkered_ExampleTests
//
//  Created by Steigerwald, Kris S. (CONT) on 8/22/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Hunkered
import Alamofire

class Hunkered_ExampleTests: XCTestCase {
    
    var requestor:HunkeredRequestState = .live
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let expect = expectation(description: "Get")
        requestor = .mock
        requestor.session.request("https://httpbin.org/todos").responseJSON { response in
            print(response)
            print("----------------------")
            switch response.result {
            case .success(let value):
                let val = value as AnyObject?
                print("Mock DATA", val as Any)
            case .failure(let error):
                print("Error: Handle failure", error)
            }
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    
    
}
