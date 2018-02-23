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
    var template: Template
    var lastModified: Date
    
    init(autoID: String?, title: String, template: Template, lastModified: Date) {
        self.autoID = autoID
        self.title = title
        self.template = template
        self.lastModified = lastModified
    }
    
}
