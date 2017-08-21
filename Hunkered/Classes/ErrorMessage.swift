//
//  ErrorMessage.swift
//  Pods
//
//  Created by Steigerwald, Kris S. (CONT) on 8/18/17.
//
//

import Foundation

public enum HunkeredError : String, Error {
    case TokenError = "Token Not Set"
    case DirectoryNotSet = "Hunkered 'MockData' directory not set"
}
