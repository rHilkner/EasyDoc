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
        let documentContent = template.contents
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
    
    
    /// Sets value to field of given path in the database and in-app
    static func setValueToField(field: Field, value: Any, completionHandler: @escaping (EasyDocError?) -> Void) {
        
        // Trying to save value to database
        DatabaseManager.setValueToField(path: field.path, value: value) {
            setValueError in
            
            if let error = setValueError {
                print("-> WARNING: EasyDocQueryError.setValue @ DocumentServices.setValueToField()")
                completionHandler(error)
                return
            }
            
            // In case of success set value in-app
            field.value = value
            
            completionHandler(nil)
        }
    }
    
    
    /// Sets title of given document in the database and in-app
    static func setTitleToDocument(document: Document, title: String, completionHandler: @escaping (EasyDocError?) -> Void) {
        
        // Trying to save title to database
        DatabaseManager.setTitleToDocument(path: document.autoID! + "/title", title: title) {
            setValueError in
            
            if let error = setValueError {
                print("-> WARNING: EasyDocQueryError.setValue @ DocumentServices.setValueToField()")
                completionHandler(error)
                return
            }
            
            // In case of success set title in-app
            document.title = title
            
            completionHandler(nil)
        }
    }
    
    
    /// Deletes a document from the user's database and in-app
    static func deleteDocument(autoID: String, completionHandler: @escaping (EasyDocError?) -> Void) {
        
        // Deleting the document from the database
        DatabaseManager.deleteDocument(autoID: autoID) {
            _error in
            
            if let error = _error {
                print("-> WARNING: EasyDocQueryError.removeValue @ DocumentServices.deleteDocument()")
                completionHandler(error)
                return
            }
            
            // Deleting the document in-app
            for i in 0 ..< AppShared.mainUser!.documents.count {
                
                if AppShared.mainUser!.documents[i].autoID == autoID {
                    AppShared.mainUser!.documents.remove(at: i)
                }
            }
            
            completionHandler(nil)
        }
    }
    
}
