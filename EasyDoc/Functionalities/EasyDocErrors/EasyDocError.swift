//
//  EasyDocError.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 26/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

protocol EasyDocError: Error {
    var errorDescription: String {get}
}
