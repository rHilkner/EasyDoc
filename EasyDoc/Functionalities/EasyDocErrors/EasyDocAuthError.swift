//
//  EasyDocErrors.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 26/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

public enum EasyDocAuthError: EasyDocError {
    
    /******************** AUTH ERRORS ********************/
    
    
    /***** WRONG INPUT *****/
    
    /// Indicates the user account was not found.
    case userNotFound
    /// Indicates the user attempted to sign in with the wrong password.
    case wrongPassword
    /// Indicates the email is invalid.
    case invalidEmail
    /// Indicates the password is invalid.
    case invalidPassword
    /// Indicates the email used to attempt a sign up is already in use.
    case emailAlreadyInUse
    
    
    /***** DATABASE REJECTED SIGN-UP/LOGIN *****/
    
    /// Indicates the user's account is disabled on the server.
    case userDisabled
    /// Indicates the administrator disabled sign in with the specified identity provider.
    case operationNotAllowed
    
    
    /***** DATABASE REJECTED SIGN-UP/LOGIN/LOGOUT *****/
    
    /// Indicates that too many requests were made to a server method.
    case tooManyRequestsToDB
    
    /// Indicates that the database tried to log the user out, but was unsuccessful
    case logoutUnsuccessful
}

extension EasyDocAuthError: LocalizedError {
    public var errorDescription: String {
        switch self {
        case .userNotFound:
            return NSLocalizedString("User account was not found on database.", comment: "")
        case .wrongPassword:
            return NSLocalizedString("Password provided .", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Email provided is in wrong format.", comment: "")
        case .invalidPassword:
            return NSLocalizedString("Password provided is invalid - Must have at least 6 characters.", comment: "")
        case .emailAlreadyInUse:
            return NSLocalizedString("Email provided is already in use.", comment: "")
        case .userDisabled:
            return NSLocalizedString("User's account has been disabled on the server.", comment: "")
        case .operationNotAllowed:
            return NSLocalizedString("User's account doesn't have the permission to sign in with the specified identity provider.", comment: "")
        case .tooManyRequestsToDB:
            return NSLocalizedString("Too many requests were made to a server method.", comment: "")
        case .logoutUnsuccessful:
            return NSLocalizedString("An error occured when trying to logout.", comment: "")
        }
    }
}
