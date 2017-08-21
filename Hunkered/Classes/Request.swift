//
//  Request.swift
//  Pods
//
//  Created by Steigerwald, Kris S. on 8/18/17.
//
//

import Foundation
import Alamofire

open class HunkeredAccessTokenAdapter: RequestAdapter {
    private let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json;v=1" , forHTTPHeaderField: "accept")
        urlRequest.setValue("application/json" , forHTTPHeaderField: "content-type")
        return urlRequest
    }
}

open class HunkeredToken {
    public static let shared = HunkeredToken()
    
    let gatewayToken:String
    
    public init(_ gatewayToken: String = "") {
        self.gatewayToken = gatewayToken
    }
}

struct HunkeredRequestConfig {
    
    var mock: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [HunkeredURLProtocol.self]
        configuration.httpAdditionalHeaders = ["session-configuration-header": "foo"]
        return configuration
    }
    
    var live: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 8
        configuration.timeoutIntervalForResource = 8
        return configuration
    }
    
    var trustPolices: [String: ServerTrustPolicy] {
        return [
            "api-it.cloud.capitalone.com": .disableEvaluation,
            "localhost:3000": .disableEvaluation]
    }
}

let requestConfig = HunkeredRequestConfig()

open class RequestManager {
    
    public let token:String
    public let liveManager:SessionManager
    public let mockManager:SessionManager
    
    init(_ mockConfig: URLSessionConfiguration = requestConfig.mock,
         _ liveConfig: URLSessionConfiguration = requestConfig.live,
         _ polices: [String: ServerTrustPolicy] = requestConfig.trustPolices,
         token: String) {
        
        self.token = token
        
        let polices = ServerTrustPolicyManager(policies: polices)
        self.liveManager = SessionManager(configuration: liveConfig,
                                          delegate: SessionDelegate(),
                                          serverTrustPolicyManager: polices)
        
        self.liveManager.adapter = HunkeredAccessTokenAdapter(accessToken: token)
        self.mockManager = SessionManager(configuration: mockConfig)
       
        guard token.isEmpty else {
            print("HUNKERED: Token is empty")
            return
        }
    }
    
}


/*
let requestor = RequestManager.shared

enum RequestState {
    case Live
    case Mock
    
    var session:SessionManager {
        switch self {
        case .Live: return requestor.liveManager!
        case .Mock: return requestor.mockManager!
        }
    }
    
}
*/


