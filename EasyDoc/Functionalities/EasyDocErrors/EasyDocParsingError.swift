//
//  EaseDocQueryErrors.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 26/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

public enum EasyDocParsingError: EasyDocError {
    
    /******************** NETWORK CONNECTION ERRORS ********************/
    
    
    /***** NETWORK ERROR *****/
    
    /// Indicates that an error occurred when manipulating a FirebaseDatabaseSnapshot
    case snapshot
    /// Indicates that an error occurred when parsing the user's password dictionary
    case password
    /// Indicates that an error occurred when parsing the main user's dictionary
    case mainUser
    /// Indicates that an error occurred when parsing a document template
    case template
    /// Indicates that an error occurred when parsing a document
    case document
    
}

extension EasyDocParsingError {
    public var description: String {
        switch self {
        case .snapshot:
            return NSLocalizedString("An error occurred when parsing a database snapshot.", comment: "")
        case .password:
            return NSLocalizedString("An error occurred when parsing the password dictionary.", comment: "")
        case .mainUser:
            return NSLocalizedString("An error occurred when parsing the main user dictionary.", comment: "")
        case .template:
            return NSLocalizedString("An error occurred when parsing a document template dictionary.", comment: "")
        case .document:
            return NSLocalizedString("An error occurred when parsing a document dictionary.", comment: "")
        }
    }
}

