//
//  EaseDocQueryErrors.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 26/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

public enum EasyDocQueryError: EasyDocError {
    
    /******************** NETWORK CONNECTION ERRORS ********************/
    
    
    /***** NETWORK ERROR *****/
    
    /// Indicates a network error occurred (such as a timeout, interrupted connection, or unreachable host). These types of errors are often recoverable with a retry.
    case networkError
    
    /***** WRITING ERROR *****/
    
    /// Indicates there was an error when setting a value to the database
    case setValue
    
    
    /***** READING ERROR *****/
    
    /// Indicates that the value received is invalid or wrong (ie: fetching should receive 1 user object but 2 where received)
    case invalidValueReceived
    
    /// Indicates that there was an error when removing a value from the database
    case removeValue
    
}


extension EasyDocQueryError: LocalizedError {
    public var errorDescription: String {
        switch self {
        case .networkError:
            return NSLocalizedString("An internet network error occured.", comment: "")
        case .setValue:
            return NSLocalizedString("There was an error when setting a value to the firebase database.", comment: "")
        case .removeValue:
            return NSLocalizedString("There was an error when removing a value from the database.", comment: "")
        case .invalidValueReceived:
            return NSLocalizedString("The value received is in invalid type or format.", comment: "")
        }
    }
}
