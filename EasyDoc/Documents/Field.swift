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
    let value: Any
    let type: String
    let order: Int
    
    init(key: String, value: Any, type: String, order: Int) {
        self.key = key
        self.value = value
        self.type = type
        self.order = order
    }
    
    convenience init?(dictKey: String, dictValue: [String : Any]) {
        
        let key = dictKey
        
        guard let value = dictValue["value"],
            let type = dictValue["type"] as? String,
            let order = dictValue["order"] as? Int else {
            
            print("-> WARNING: EasyDocParsingError.field @ Field.init()")
            return nil
        }
        
        self.init(key: key, value: value, type: type, order: order)
    }
}
