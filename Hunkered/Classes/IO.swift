//
//  IO.swift
//  Pods
//
//  Created by Steigerwald, Kris S. (CONT) on 8/21/17.
//
//

import Foundation
fileprivate class BundleTargetingClass {}


public struct HunkeredIO {
   
    public init() {}
    private let jsonDir:String = "MockData"
    
    public func loadJSON(_ path: String) -> Bool {
        try? ls()
        return true
    }
   
    private func hasMockDataDirectory() -> Bool {
        let dir = Bundle.main.url(forResource: jsonDir, withExtension: nil)
        return dir != nil
    }
  
   
    func serialize(path: String) throws -> String {
        let url = URL(fileURLWithPath: path)
        do {
            let data:Data = try Data(contentsOf: url)
            let JSON = try JSONSerialization.jsonObject(with: data, options: [])
            print(data, JSON)
        }
        catch {
            print(HunkeredError.JSONReadError.rawValue)
            throw HunkeredError.JSONReadError
        }
        return path
    }
    
    private func ls() throws {
        guard hasMockDataDirectory() else {
            print(HunkeredError.DirectoryNotSet.rawValue)
            throw HunkeredError.DirectoryNotSet
        }
        
        let paths:[String] = Bundle.main.paths(forResourcesOfType: "json", inDirectory: jsonDir)
        let foo = try paths.map(serialize)
        
        print(foo)
        
    }
}
