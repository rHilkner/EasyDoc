//
//  EasyDocGeneralError.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 29/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

public enum EasyDocGeneralError: EasyDocError {
    
    /***** UNEXPECTED ERROR *****/
    
    /// Indicates an unspecified auth error occured.
    case unexpectedError
}

extension EasyDocGeneralError {
    public var description: String {
        switch self {
        case .unexpectedError:
            return NSLocalizedString("An unexpected error occurred.", comment: "")
        }
    }
}
