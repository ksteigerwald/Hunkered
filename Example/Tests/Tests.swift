import UIKit
import XCTest
import Hunkered
import Alamofire

enum Handler {
    case live, mock
    var session: SessionManager {
        
        switch self {
        case .mock: return HunkeredManager()
        case .live: return HunkeredManager(configuration: URLSessionConfiguration.default, delegate: SessionDelegate(), serverTrustPolicyManager: ServerTrustPolicyManager(policies: [ "localhost:3000": .disableEvaluation]))
        }
        
    }
}

@testable import Hunkered
class Tests: XCTestCase {
    
    var requestor: Handler = .live
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        print("-----")
        
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
