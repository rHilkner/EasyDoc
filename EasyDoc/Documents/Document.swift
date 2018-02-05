//
//  Document.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 24/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

class Document {
    var autoID: String?
    var title: String
    var type: String
    var content: String
    var fields: [Field]
    var lastModified: Date
    
    init(autoID: String?, title: String, type: String, content: String, fields: [Field], lastModified: Date) {
        self.autoID = autoID
        self.title = title
        self.type = type
        self.content = content
        self.fields = fields
        self.lastModified = lastModified
    }
}
