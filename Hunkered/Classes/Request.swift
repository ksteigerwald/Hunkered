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

open class HunkeredManager:SessionManager {
    
    public override init( configuration: URLSessionConfiguration = requestConfig.mock,
        delegate: SessionDelegate = SessionDelegate(),
        serverTrustPolicyManager: ServerTrustPolicyManager? = nil) {
    
        super.init(configuration: configuration,
        delegate: SessionDelegate(),
        serverTrustPolicyManager: serverTrustPolicyManager)
    }
}


/*
let requestor = RequestManager.shared
*/
public enum HunkeredRequestState {
    case live(HunkeredManager)
    case mock(HunkeredManager)
}


