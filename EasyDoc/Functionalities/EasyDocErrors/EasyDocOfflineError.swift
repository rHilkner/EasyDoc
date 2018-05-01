//
//  EasyDocOfflineErrors.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 29/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

public enum EasyDocOfflineError: EasyDocError {
    /***** OFFLINE ERROR *****/
    
    /// Indicates that there was an in-app login error.
    case inAppLoginError
    /// Indicates that a nil object was unexpectedly found.
    case foundNil
    /// Indicates there was an error when trying to cast retrieved data to a certain type
    case castingError
}

extension EasyDocOfflineError {
    public var description: String {
        switch self {
        case .inAppLoginError:
            return NSLocalizedString("An error occurred when trying to make in-app login.", comment: "")
        case .foundNil:
            return NSLocalizedString("Unexpectedly found a nil object.", comment: "")
        case .castingError:
            return NSLocalizedString("An error occurred when casting the retrieved data to a certain type.", comment: "")
        }
    }
}
