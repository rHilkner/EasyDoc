//
//  ParseUser.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 02/03/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

class UserParser {
    
    /// Create new user dictionary from given email and password.
    static func createNewUserDictionary(email: String) -> [String : AnyObject] {
        // Creating user's profile dictionary
        let newUserProfileDict : [String : AnyObject] = [
            "email" : email as AnyObject
        ]
        
        // Creating user's object dictionary
        let newUserDict : [String : AnyObject] = [
            "profile_information": newUserProfileDict as AnyObject,
            "documents": NSNull()
        ]
        
        // Returns new user dictionary
        return newUserDict
    }
    
    
    /// Parse given dictionary to create main user object. Returns nil if parse gone wrong.
    static func parseMainUserDictionary(_ userDict: [String : [String : Any]], autoID: String) -> MainUser? {
        
        // Getting user's email
        guard let profileDict = userDict["profile_information"] else {
            return nil
        }
        
        guard let userEmail = profileDict["email"] as? String else {
            return nil
        }
        
        // Getting user's documents
        var userDocuments: [Document] = []
        
        let documentsDict = userDict["documents"] as? [String : [String : Any]] ?? [:]
        
        for documentDict in documentsDict {
            guard let document = DocumentParser.parseDocumentDictionary(documentDict.value, autoID: documentDict.key) else {
                return nil
            }
            
            userDocuments.append(document)
        }
        
        // Sorting documents by date of last modification
        userDocuments.sort() {
            (document1, document2) in
            
            return document1.lastModified > document2.lastModified
        }
        
        // Returns main user object
        return MainUser(autoID: autoID, email: userEmail, documents: userDocuments)
    }
    
}
