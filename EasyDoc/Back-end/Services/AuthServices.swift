//
//  SignUpServices.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 24/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthServices {
    
    
    /// Tries to sign up user on database with given email and password. May return the user created object or an error if sign up was unsuccessful.
    static func attemptToSignUp(email: String, password: String, completionHandler: @escaping (EasyDocError?) -> Void) {
        
        // Tries to create user on EasyDoc's Firebase server
        Auth.auth().createUser(withEmail: email, password: password) {
            (_user, signUpError) in
            
            if let error = signUpError {
                completionHandler(ErrorHandling.handlesAuthError(error: error))
                return
            }
            
            // Inputs user on EasyDoc's Database
            DatabaseManager.createNewUser(email: email, password: password) {
                (mainUser, signUpError) in
                
                if let error = signUpError {
                    completionHandler(error)
                    return
                }
                
                // Performing in-app login
                guard self.performInAppLogin(mainUser: mainUser!) else {
                    completionHandler(EasyDocOfflineError.inAppLoginError)
                    return
                }
                
                completionHandler(nil)
            }
        }
    }
    
    
    /// Tries to login user on database with given email and password. May return the user found object or an error if login was unsuccessful.
    static func attemptToLogin(email: String, password: String, completionHandler: @escaping (EasyDocError?) -> Void) {
        
        // Tries to login into EasyDoc's Firebase server
        Auth.auth().signIn(withEmail: email, password: password) {
            (_user, signInError) in
            
            if let error = signInError {
                completionHandler(ErrorHandling.handlesAuthError(error: error))
                return
            }
            
            completionHandler(nil)
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
    
    
    // TODO: perform logout without completionHandler
    static func attemptToLogout(completionHandler: @escaping (EasyDocError?) -> Void) {
        do {
            try Auth.auth().signOut()
            guard self.performInAppLogout() else {
                completionHandler(EasyDocAuthError.logoutUnsuccessful)
                return
            }
            
            completionHandler(nil)
        } catch {
            completionHandler(EasyDocAuthError.logoutUnsuccessful)
        }
    }
    
    
    /// Tries to logout main user of the application. Returns success (true/false) of logout attempt.
    static func performInAppLogout() -> Bool {
        if AppShared.mainUser != nil {
            AppShared.mainUser = nil
            return true
        }
        
        return false
    }
    
    
    /// Verifies if email is in format: "_@_._" .
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: email)
    }
    
    
    /// Verifies if password is in format (has at least 6 characters, no spaces).
    static func isValidPassword(_ password: String) -> Bool {
        return (password.count >= 6)
    }
}
