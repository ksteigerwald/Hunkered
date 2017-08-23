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
    static let shared = HunkeredRequestConfig()
    
    var mock: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [HunkeredURLProtocol.self]
        return configuration
    }
    
    var live: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 8
        configuration.timeoutIntervalForResource = 8
        return configuration
    }
}

public enum HunkeredRequestState {
    case live
    case mock
    
}

public protocol Hunkered {
    associatedtype RequestState
    var liveManager: SessionManager { get set }
    var mockManager: SessionManager { get set }
    var manager: SessionManager { get set }
}

public extension Hunkered where Self: Any {
}


open class HunkeredRequestManager: Hunkered {

    public typealias RequestState = HunkeredRequestState

    public var manager: SessionManager
    public var liveManager: SessionManager
    public var mockManager: SessionManager
    
    let configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [HunkeredURLProtocol.self]
        return configuration
    }()
   
    
    public init(state: RequestState = .live,
                _ live: SessionManager? = SessionManager.default,
                _ mock: SessionManager? = SessionManager(configuration: HunkeredRequestConfig.shared.mock)) {
        
        self.manager = SessionManager.default
        self.liveManager = SessionManager.default
        self.mockManager = SessionManager(configuration: configuration)
        self.setState(state: state)
    }
    
    public func setState(state: RequestState) {
        switch state {
        case .live:
            self.manager = self.liveManager
        case .mock:
            self.manager = self.mockManager
        }
    }
}

