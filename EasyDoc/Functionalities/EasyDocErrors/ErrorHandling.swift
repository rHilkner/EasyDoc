//
//  ErrorHandling.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 26/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import FirebaseAuth

class ErrorHandling {
    
    /// Verifies if email is in format: "_@_._" .
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    
    /// Verifies if password is in format (has at least 6 characters).
    static func isValidPassword(_ password: String) -> Bool {
        return (password.count >= 6)
    }
    
    
    /// Handles error occurred on login or sign up.
    static func handlesAuthError(error: Error) -> EasyDocError {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            return self.handleFirebaseAuthError(errorCode: errorCode)
        } else {
            return EasyDocGeneralError.unexpectedError
        }
    }
    
    
    /// Transform Firebase AuthErrorCode to EasyDocAuthError.
    static func handleFirebaseAuthError(errorCode: AuthErrorCode) -> EasyDocError {
        switch errorCode {
        case .networkError:
            return EasyDocQueryError.networkError
        case .userNotFound:
            return EasyDocAuthError.userNotFound
        case .invalidEmail:
            return EasyDocAuthError.invalidEmail
        case .wrongPassword:
            return EasyDocAuthError.wrongPassword
        case .emailAlreadyInUse:
            return EasyDocAuthError.emailAlreadyInUse
        case .userDisabled:
            return EasyDocAuthError.userDisabled
        case .operationNotAllowed:
            return EasyDocAuthError.operationNotAllowed
        case .tooManyRequests:
            return EasyDocAuthError.tooManyRequestsToDB
        default:
            return EasyDocGeneralError.unexpectedError
        }
    }
}
