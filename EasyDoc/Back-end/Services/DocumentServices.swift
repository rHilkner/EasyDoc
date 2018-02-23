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
    
    /// Returns number of sections that a field being presented on screen
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
    
    
    /// Adds a given document to the main user in-app and into the EasyDoc's database
    static func addDocumentToUser(_ newDocument: Document, completionHandler: @escaping (EasyDocError?) -> Void) {
        
        // Adding new document to user's database
        DocumentPersistence.addDocumentToMainUserDB(document: newDocument) {
            addingError in
            
            if let error = addingError {
                print("-> WARNING: EasyDocQueryError.setValue @ DocumentServices.addDocumentToUser()")
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
        DocumentPersistence.setValueToField(path: field.path, value: value) {
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
        DocumentPersistence.setTitleToDocument(path: document.autoID! + "/title", title: title) {
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
        DocumentPersistence.deleteDocument(autoID: autoID) {
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
    
    
    /// Replace fields of the document's contents with it's value or with "_____" if value is nil.
    static func readContentsWithValues(document: Document) -> String? {
        
        var readableContents = document.template.contents
        var searchStartIndex = readableContents.startIndex
        
        // Keep advancing the search range until can't find any more fields
        while let fieldPathStartRange = readableContents.range(of: "[", range: searchStartIndex..<readableContents.endIndex) {
            
            guard let fieldPathEndRange = readableContents.range(of: "]", range: fieldPathStartRange.upperBound..<readableContents.endIndex) else {
                print("-> WARNING: EasyDocQueryError.databaseObject @ Document.readContentsWithValues()")
                return nil
            }
            
            // Getting field path string
            let path = String(readableContents[fieldPathStartRange.upperBound..<fieldPathEndRange.lowerBound])
            
            // Getting the field value
            guard let value = self.fieldValue(document: document, path: path) else {
                print("-> WARNING: EasyDocQueryError.databaseObject @ Document.readContentsWithValues()")
                return nil
            }
            
            // Getting range to be replaced
            let replaceRange = fieldPathStartRange.lowerBound..<fieldPathEndRange.upperBound
            
            let valueToReplace = (value == "") ? "_____" : value
            
            // Replacing field with value
            readableContents.replaceSubrange(replaceRange, with: valueToReplace)
            
            // Reseting search start index
            searchStartIndex = readableContents.index(fieldPathStartRange.lowerBound, offsetBy: valueToReplace.count)
        }
        
        return readableContents
    }
    
    
    /// Finds the value of a document's field with given path.
    static func fieldValue(document: Document, path: String) -> String? {
        
        // Getting range of first "/" occurence
        guard var fieldKeyStartRange = path.range(of: "/", range: path.startIndex..<path.endIndex) else {
            print("-> WARNING: EasyDocQueryError.databaseObject @ Template.readContents()")
            return nil
        }
        
        var fields = document.template.fields
        
        // Keep advancing the search range until can't find any more "/"
        while let fieldKeyEndRange = path.range(of: "/", range: fieldKeyStartRange.upperBound..<path.endIndex) {
            
            // Getting next key of the path
            let fieldKey = String(path[fieldKeyStartRange.upperBound..<fieldKeyEndRange.lowerBound])
            
            // Getting fields of the field with correspondent key
            for field in fields {
                if field.key == fieldKey {
                    // Reseting fields array
                    fields = field.value as! [Field]
                    break
                }
            }
            
            fieldKeyStartRange = fieldKeyEndRange
        }
        
        // Getting value of the last field of the path
        let fieldKey = String(path[fieldKeyStartRange.upperBound...])
        
        // Finding field with determined key
        for field in fields {
            if field.key == fieldKey {
                return (field.value as! String)
            }
        }
        
        // If no correspondent field key is found, returns nil
        return nil
    }
}
