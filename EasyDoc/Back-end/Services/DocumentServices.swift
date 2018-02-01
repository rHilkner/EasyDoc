//
//  DocumentServices.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 31/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

class DocumentType {
    static let dict: String = "dict"
}

class DocumentServices {
    
    /// returns number of sections that a field being presented on screen
    static func numberOfSections(fields: [String : [String : Any]]) -> Int {
        
        // If all fields are dictionaries, then they are all sections and their keys are all headers
        for field in fields {
            // Verifying parsing error
            guard let fieldType = field.value["type"] as? String else {
                print("-> WARNING: EasyDocParsingError.document @ DocumentServices.numberOfSections()")
                return 0
            }
            
            if fieldType != DocumentType.dict {
                return 0
            }
        }
        
        return fields.count
    }
}
