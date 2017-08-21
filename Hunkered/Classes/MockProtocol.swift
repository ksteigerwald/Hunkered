//
//  MockingProtocole.swift
//  Vela
//
//  Created by Steigerwald, Kris S. (CONT) on 2/8/17.
//  Copyright © 2017 Capital One. All rights reserved.
//

import Foundation
import Alamofire

public class HunkeredURLProtocol: URLProtocol {
    
    public var cannedResponse: NSData?
    public let cannedHeaders = ["Content-Type" : "application/json; charset=utf-8"]
    
    // MARK: Properties
    struct PropertyKeys {
        static let handledByForwarderURLProtocol = "HandledByProxyURLProtocol"
    }
    
    lazy var session: URLSession = {
        
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.ephemeral
            configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            return configuration
        }()
        
        let session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        return session
    }()
    
    var activeTask: URLSessionTask?
    
    // MARK: Class Request Methods
    public override class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: PropertyKeys.handledByForwarderURLProtocol, in: request) != nil {
            return false
        }
        
        return true
    }
    
    
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        if let headers = request.allHTTPHeaderFields {
            do {
                return try URLEncoding.default.encode(request, with: headers)
            } catch {
                return request
            }
        }
        
        return request
    }
    
    
    public override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    // MARK: Loading Methods
    public override func startLoading() {
        
        //let data:NSData = Hunkered.find(request) as! NSData
        let data:NSData = [:] as! NSData
        let client = self.client
        let response = HTTPURLResponse(url: (request.url)!,
                                       statusCode: 200,
                                       httpVersion: "HTTP/1.1",
                                       headerFields: cannedHeaders)
        
        client?.urlProtocol(self, didReceive: response!,
                            cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
        
        cannedResponse = data
        
        client?.urlProtocol(self, didLoad: cannedResponse as! Data)
        client?.urlProtocolDidFinishLoading(self)
        
        activeTask?.resume()
    }
    
    
    public override func stopLoading() {
        activeTask?.cancel()
    }
}

extension HunkeredURLProtocol: URLSessionDelegate {
    
    // MARK: NSURLSessionDelegate
    func URLSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceiveData data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }
    
    func URLSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let response = task.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
}
