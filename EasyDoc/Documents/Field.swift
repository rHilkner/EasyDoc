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
    let type: FieldType
    let order: Int
    let path: String
    
    init(key: String, value: Any, type: FieldType, order: Int, path: String) {
        self.key = key
        self.value = value
        self.type = type
        self.order = order
        self.path = path
    }
}
