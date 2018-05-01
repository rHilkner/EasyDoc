//
//  EasyDocError.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 26/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

protocol EasyDocError: Error {
    /// Description of the occurred error
    var description: String {get}
}

extension EasyDocError {
    // Setting a default error description
    var description: String {
        get {
            return NSLocalizedString("An unidentified error occurred.", comment: "")
        }
    }
}
