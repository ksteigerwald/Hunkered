//
//  IO.swift
//  Pods
//
//  Created by Steigerwald, Kris S. (CONT) on 8/21/17.
//
//

import Foundation

public struct HunkeredIO {
   
    public init() {}
    
    public func directoryExistsAtPath(_ path: String) -> Bool {
//        let fileManager = FileManager.default
//        print(fileManager.currentDirectoryPath)
        try? ls()
        
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
   
    private func hasMockDataDirectory() -> Bool {
        let dir = Bundle.main.url(forResource: "MockData", withExtension: nil)
        return dir != nil
    }
    
    private func ls() throws {
        guard hasMockDataDirectory() else {
            print("HUNKERED:", HunkeredError.DirectoryNotSet.rawValue)
            throw HunkeredError.DirectoryNotSet
        }
        let paths:[String] = Bundle.main.paths(forResourcesOfType: "json", inDirectory: "foo")
        paths.forEach {path in
            do {
                let contents = try String(contentsOfFile: path) 
                print(contents)
            } catch {
            }
        }
        
//        let filemanager:FileManager = FileManager()
//        let files = filemanager.enumerator(atPath: NSHomeDirectory())
//        while let file = files?.nextObject() {
//            print(file)
//        } 
    }
}
