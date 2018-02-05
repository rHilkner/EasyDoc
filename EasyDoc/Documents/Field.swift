//
//  Fields.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 31/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

class Field {
    
    let key: String
    var value: Any
    let type: String
    let order: Int
    
    init(key: String, value: Any, type: String, order: Int) {
        self.key = key
        self.value = value
        self.type = type
        self.order = order
    }
}
