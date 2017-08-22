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
    
    var liveConfig: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 8
        configuration.timeoutIntervalForResource = 8
        return configuration
    }
    
    var requestor:HunkeredRequestManager?
    var trustPolices:ServerTrustPolicyManager = ServerTrustPolicyManager(policies: [ "httpbin.org": .disableEvaluation ])
    
    override func setUp() {
        let liveManager:SessionManager = SessionManager(configuration: liveConfig,
                                                        delegate: SessionDelegate(),
                                                        serverTrustPolicyManager: trustPolices)
        requestor = HunkeredRequestManager(state: .live, liveManager)
        
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
   
    func testLive() {
        
        let expect = expectation(description: "Get")
        requestor?.setState(state: .live)
        
        requestor?.manager.request("https://httpbin.org/anything").responseJSON { response in
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
    
    func testExample() {
        let expect = expectation(description: "Get")
        requestor?.setState(state: .mock)
        requestor?.manager.request("https://httpbin.org/todos").responseJSON { response in
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
