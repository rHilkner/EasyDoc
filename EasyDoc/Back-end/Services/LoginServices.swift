//
//  LoginServices.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 23/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

class LoginServicesssss {
    /// Fetches user with given email and password. May return the user found object or an error if fetch was unsuccessful.
    static func attemptsToLogin(email: String, password: String, completionHandler: @escaping (EasyDocError?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) {
            (user, signInError) in
            
            if let error = signInError {
                completionHandler(ErrorHandling.handlesAuthError(error: error))
                return
            }
            
            completionHandler(nil)
            
//            DatabaseManager.fetchMainUser(email: email, password: password) {
//                (mainUser, error) in
//                completionHandler(mainUser, error)
//            }
        }
    }
    
    /// Receives a valid MainUser already tested and pulled from DB and tries to log him/her in. Returns success (true/false) of login attempt.
    static func performInAppLogin(mainUser: MainUser) -> Bool {
        if AppShared.mainUser == nil {
            AppShared.mainUser = mainUser
            return true
        }
        
        return false
    }
}
