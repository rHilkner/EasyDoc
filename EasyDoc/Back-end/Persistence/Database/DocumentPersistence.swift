//
//  DocumentPersistence.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 23/02/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DocumentPersistence {
    
    // Adds a document to the main user's database
    static func addDocumentToMainUserDB(document: Document, completionHandler: @escaping (EasyDocError?) -> Void) {
        
        // Creating reference to user dictionary object on DB
        let userRef = FirebaseManager.databaseReference.child("users").child(AppShared.mainUser!.autoID).child("documents").childByAutoId()
        
        // Creating document dictionary
        let documentDict = DocumentParser.createDocumentDictionary(document)
        
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
        
        let valueRef = FirebaseManager.databaseReference.child("users/\(AppShared.mainUser!.autoID)/documents/" + path)
        
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
        
        let titleRef = FirebaseManager.databaseReference.child("users/\(AppShared.mainUser!.autoID)/documents/" + path)
        
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
    static func deleteDocument(_ document: Document, completionHandler: @escaping (EasyDocError?) -> Void) {
        
        let documentRef = FirebaseManager.databaseReference.child("users/\(AppShared.mainUser!.autoID)/documents/" + document.autoID!)
        
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
