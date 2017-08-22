//
//  ErrorMessage.swift
//  Pods
//
//  Created by Steigerwald, Kris S. on 8/18/17.
//
//

import Foundation

public enum HunkeredError : String, Error {
    case TokenError = "Hunkered: Token Not Set"
    case DirectoryNotSet = "Hunkered: 'MockData' directory not set"
    case JSONReadError = "Hunkered: JSON serializtion failed"
}
