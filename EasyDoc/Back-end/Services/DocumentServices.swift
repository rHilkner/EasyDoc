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
    static func multipleSections(fields: [String : [String : Any]]) -> Int {
        
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
    
    static func addTemplateToUserDocuments(_ template: Template, title: String, completionHandler: @escaping (EasyDocError?) -> Void) {
        
        // Creating new document object
        let documentType = template.type
        let documentContent = template.content
        let documentFields = template.fields
        
        let newDocument = Document(autoID: nil, title: title, type: documentType, content: documentContent, fields: documentFields, lastModified: Date())
        
        // Adding new document to user's database
        DatabaseManager.addDocumentToMainUserDB(document: newDocument) {
            addingError in
            
            if let error = addingError {
                completionHandler(error)
                return
            }
            
            // In case of success, add the document to user object
            AppShared.mainUser!.documents.append(newDocument)
            completionHandler(nil)
        }
    }
}
