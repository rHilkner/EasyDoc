//
//  TemplateServices.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 23/02/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

class TemplateServices {
    
    /// Adds a given template with title to the main user in-app and into EasyDoc's database
    static func addTemplateToUserDocuments(_ template: Template, title: String, completionHandler: @escaping (EasyDocError?) -> Void) {
        
        // Creating new document object
        let newDocument = Document(autoID: nil, title: title, template: template, lastModified: Date())
        
        // Adding document to user
        DocumentServices.addDocumentToUser(newDocument) {
            addingError in
            
            if let error = addingError {
                completionHandler(error)
                return
            }
            
            completionHandler(nil)
        }
    }
    
    
    /// Returns the template's contents with blank fields replaced with "_____"
    static func readContents(template: Template) -> String? {
        
        var readableContents = template.contents
        var searchStartIndex = readableContents.startIndex
        
        // Replacing every empty field value with "____"
        while let fieldPathStartRange = readableContents.range(of: "[", range: searchStartIndex..<readableContents.endIndex) {
            
            guard let fieldPathEndRange = readableContents.range(of: "]", range: fieldPathStartRange.upperBound..<readableContents.endIndex) else {
                print("-> WARNING: EasyDocQueryError.databaseObject @ Template.readContents()")
                return nil
            }
            
            // Getting range to be replaced
            let replaceRange = fieldPathStartRange.lowerBound..<fieldPathEndRange.upperBound
            
            // Replacing field path with "_____"
            readableContents.replaceSubrange(replaceRange, with: "_____")
            
            // Reseting search start index
            searchStartIndex = fieldPathEndRange.upperBound
        }
        
        return readableContents
    }
    
}
