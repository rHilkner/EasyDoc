//
//  DatabaseManager.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 24/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DatabaseManager {
    
    /// FIRDatabaseReference for the root of Guarded's Firebase Database
    static var ref = Database.database().reference()
    
    
    /// Adds new user to DB.
    static func createNewUser(email: String, password: String, completionHandler: @escaping (MainUser?, EasyDocError?) -> Void) {
        
        // Creating reference to user dictionary object on DB
        let userRef = ref.child("users").childByAutoId()
        
        // Creating dictionary for the new user with given email and password
        let newUserDict = ParseObjects.createNewUserDictionary(email: email)
        
        // Inputing user object's dictionary on EasyDoc's Database
        userRef.setValue(newUserDict) {
            (error, _) in
            
            if error != nil {
                completionHandler(nil, EasyDocQueryError.setValue)
                return
            }
            
            // Returning created new main user on completionHandler
            completionHandler(MainUser(autoID: userRef.key, email: email, documents: []), nil)
        }
    }
    
    
    /// Fetches user complete information (email and documents) and returns the main user object (xor an error) by calling the completionHandler().
    static func fetchMainUser(email: String, completionHandler: @escaping (MainUser?, EasyDocError?) -> Void) {
        
        // Making query for user object by given email
        let query = self.ref.child("users").queryOrdered(byChild: "profile_information/email").queryEqual(toValue: email)
        
        // Observing query made to get user object
        query.observeSingleEvent(of: .value) {
            (usersSnapshot) in
            
            // Handling possible errors
            guard let usersSnapshotList = usersSnapshot.children.allObjects as? [DataSnapshot] else {
                completionHandler(nil, EasyDocOfflineError.castingError)
                return
            }
            
            if (usersSnapshotList.count == 0) {
                completionHandler(nil, EasyDocAuthError.userNotFound)
                return
            } else if (usersSnapshotList.count != 1) {
                print("-> WARNING: More than 1 user with same email found on DB.")
                completionHandler(nil, EasyDocQueryError.invalidValueReceived)
                return
            }
            
            let userSnapshot = usersSnapshotList[0]
            
            // Getting user's dictionary
            guard let userDict = userSnapshot.value as? [String : [String : Any]] else {
                completionHandler(nil, EasyDocOfflineError.castingError)
                return
            }
            
            // Parsing user's dictionary
            guard let userFetched = ParseObjects.parseMainUserDictionary(userDict, autoID: userSnapshot.key) else {
                print("-> WARNING: EasyDocParsingError.mainUser @ DatabaseManager.fetchMainUser()")
                completionHandler(nil, EasyDocParsingError.mainUser)
                return
            }
            
            // Returning user object
            completionHandler(userFetched, nil)
        }
    }
    
    
    /// Fetches all document templates existent on the database
    static func fetchTemplates(completionHandler: @escaping ([Template]?, EasyDocError?) -> Void) {
        
        // Making query to get all templates of the database
        let query = self.ref.child("templates").queryOrdered(byChild: "type")
        
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
    
    
    // Adds a document to the main user's database
    static func addDocumentToMainUserDB(document: Document, completionHandler: @escaping (EasyDocError?) -> Void) {
        
        // Creating reference to user dictionary object on DB
        let userRef = ref.child("users").child(AppShared.mainUser!.autoID).child("documents").childByAutoId()
        
        // Creating document dictionary
        let documentDict = ParseObjects.createDocumentDictionary(document)
        
        // Adding dictionary to user's database
        userRef.setValue(documentDict) {
            (error, _) in
            
            if error != nil {
                completionHandler(EasyDocQueryError.setValue)
                return
            }
            
            document.autoID = userRef.key
            
            // Returning created new main user on completionHandler
            completionHandler(nil)
        }
        
    }
    
    /// Sets value to field of given path in the database
    static func setValueToField(path: String, value: Any, completionHandler: @escaping (EasyDocError?) -> Void) {
        
        let valueRef = self.ref.child("users/\(AppShared.mainUser!.autoID)/documents/" + path)
        
        valueRef.setValue(value) {
            (error, _) in
            
            if error != nil {
                print("-> WARNING: EasyDocQueryError.setValue @ DatabaseManager.setValueToField()")
                completionHandler(EasyDocQueryError.setValue)
                return
            }
            
            completionHandler(nil)
        }
        
    }
    
    
    /// Sets title to given document in the database
    static func setTitleToDocument(path: String, title: String, completionHandler: @escaping (EasyDocError?) -> Void) {
        
        let titleRef = self.ref.child("users/\(AppShared.mainUser!.autoID)/documents/" + path)
        
        titleRef.setValue(title) {
            (error, _) in
            
            if error != nil {
                print("-> WARNING: EasyDocQueryError.setValue @ DatabaseManager.setValueToField()")
                completionHandler(EasyDocQueryError.setValue)
                return
            }
            
            completionHandler(nil)
        }
    }
    
    
    /// Deletes a document from the user's database
    static func deleteDocument(autoID: String, completionHandler: @escaping (EasyDocError?) -> Void) {
        
        let documentRef = self.ref.child("users/\(AppShared.mainUser!.autoID)/documents/" + autoID)
        
        documentRef.removeValue() {
            error, _ in
            
            if error != nil {
                print("-> WARNING: EasyDocQueryError.removeValue @ DatabaseManager.deleteDocument()")
                completionHandler(EasyDocQueryError.removeValue)
                return
            }
            
            completionHandler(nil)
        }
    }
}
