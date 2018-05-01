//
//  Document.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 24/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

class Document {
    /// Note: AutoID is only nil at the first time the document is created (because it needs to wait the return of the server with the AutoID string)
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

extension Document: Equatable {
    static func == (lhs: Document, rhs: Document) -> Bool {
        if lhs.autoID == rhs.autoID {
            return true
        }
        
        return false
    }
}
