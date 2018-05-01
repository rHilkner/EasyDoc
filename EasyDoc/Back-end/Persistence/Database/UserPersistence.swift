//
//  UserPersistence.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 23/02/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserPersistence {
    
    /// Adds new user to DB.
    static func createNewUser(email: String, password: String, completionHandler: @escaping (MainUser?, EasyDocError?) -> Void) {
        
        // Creating reference to user dictionary object on DB
        let userRef = FirebaseManager.databaseReference.child("users").childByAutoId()
        
        // Creating dictionary for the new user with given email and password
        let newUserDict = UserParser.createNewUserDictionary(email: email)
        
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
        let query = FirebaseManager.databaseReference.child("users").queryOrdered(byChild: "profile_information/email").queryEqual(toValue: email)
        
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
            guard let userFetched = UserParser.parseMainUserDictionary(userDict, autoID: userSnapshot.key) else {
                print("-> WARNING: EasyDocParsingError.mainUser @ DatabaseManager.fetchMainUser()")
                completionHandler(nil, EasyDocParsingError.mainUser)
                return
            }
            
            // Returning user object
            completionHandler(userFetched, nil)
        }
    }
    
}
