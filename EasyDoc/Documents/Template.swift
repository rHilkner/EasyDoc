//
//  Document.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 24/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

class Template {
    var type: String
    var contents: String
    var fields: [Field]
    
    init(type: String, content: String, fields: [Field]) {
        self.type = type
        self.contents = content
        self.fields = fields
    }
    
}

