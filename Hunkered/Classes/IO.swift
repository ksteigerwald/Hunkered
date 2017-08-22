//
//  IO.swift
//  Pods
//
//  Created by Steigerwald, Kris S. on 8/21/17.
//
//

import Foundation

public struct HunkeredIO {
   
    private let jsonDir:String = "MockData"
    
    public init() {
        do {
            let test = try loadJSON()
        } catch {}
    }
    
    public func data() -> [[String : AnyObject]] {
        do {
            return try loadJSON()
        }
        catch {
            return []
        }
    }
    
    private func loadJSON() throws -> [[String: AnyObject]] {
        
        guard hasMockDataDirectory() else {
            print(HunkeredError.DirectoryNotSet.rawValue)
            throw HunkeredError.DirectoryNotSet
        }
        
        let paths:[String] = Bundle.main.paths(forResourcesOfType: "json", inDirectory: jsonDir)
        
        do {
            let dictionary = try paths.map(serialize)
            return dictionary
        } catch {
            throw HunkeredError.JSONReadError
        }
        
    }
   
    private func hasMockDataDirectory() -> Bool {
        let dir = Bundle.main.url(forResource: jsonDir, withExtension: nil)
        return dir != nil
    }
   
    func serialize(path: String) throws -> [String : AnyObject] {
        let key:String = (path.components(separatedBy: "/").last?.components(separatedBy: ".").first)!
        let url = URL(fileURLWithPath: path)
        do {
            let data:Data = try Data(contentsOf: url)
            let JSON = try JSONSerialization.jsonObject(with: data, options: []) as! [String : AnyObject]
            return [key : JSON as AnyObject]
        }
        catch {
            print(HunkeredError.JSONReadError.rawValue)
            throw HunkeredError.JSONReadError
        }
    }
    
}
