//
//  TemplatePersistence.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 23/02/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import FirebaseDatabase

class TemplatePersistence {
    
    /// Fetches all document templates existent on the database
    static func fetchTemplates(completionHandler: @escaping ([Template]?, EasyDocError?) -> Void) {
        
        // Making query to get all templates of the database
        let query = FirebaseManager.databaseReference.child("templates").queryOrdered(byChild: "type")
        
        // Observing query made to get template object
        query.observeSingleEvent(of: .value, with: {
            (templatesSnapshot) in
            
            // Handling possible errors
            guard let templatesSnapshotList = templatesSnapshot.children.allObjects as? [DataSnapshot] else {
                print("-> WARNING: EasyDocOfflineError.castingError @ DatabaseManager.fetchTemplates()")
                completionHandler(nil, EasyDocOfflineError.castingError)
                return
            }
            
            var templates: [Template] = []
            
            // Parsing each of the templates gotten from the database
            for templateSnapshot in templatesSnapshotList {
                // Getting template dictionary
                guard let templateDict = templateSnapshot.value as? [String : Any] else {
                    print("-> WARNING: EasyDocParsingError.snapshot @ DatabaseManager.fetchTemplates()")
                    completionHandler(nil, EasyDocParsingError.snapshot)
                    return
                }
                
                // Parsing template object
                guard let templateObject = ParseObjects.parseTemplateDictionary(templateDict, autoID: templateSnapshot.key) else {
                    print("-> WARNING: EasyDocParsingError.template @ DatabaseManager.fetchTemplates()")
                    completionHandler(nil, EasyDocParsingError.template)
                    return
                }
                
                // Adding template parsed to list
                templates.append(templateObject)
            }
            
            // Return templates fetched
            completionHandler(templates, nil)
        }) {
            error in
            
            print("-> WARNING: EasyDocQueryError.observeValue @ DatabaseManager.fetchTemplates()")
            completionHandler(nil, EasyDocQueryError.observeValue)
        }
    }
    
}
