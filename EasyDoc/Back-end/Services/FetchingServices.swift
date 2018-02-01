//
//  FetchingServices.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 29/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Firebase

class FetchingServices {
    
    /// Loads MainUser object fetched from database into AppShared.mainUser
    static func loadMainUser(email: String, completionHandler: @escaping (EasyDocError?) -> Void) {
        // Setting loading user as true
        AppShared.isLoadingUser.value = true
        
        // Tries to fetch main user object from EasyDoc's Database
        DatabaseManager.fetchMainUser(email: email) {
            (mainUser, fetchUserError) in
            
            if fetchUserError != nil {
                AppShared.isLoadingUser.value = false
                completionHandler(fetchUserError)
                return
            }
            
            
            
            guard AuthServices.performInAppLogin(mainUser: mainUser!) else {
                AppShared.isLoadingUser.value = false
                completionHandler(EasyDocOfflineError.inAppLoginError)
                return
            }
            
            AppShared.isLoadingUser.value = false
            completionHandler(nil)
        }
    }
    
    
    /// Loads Template list fetched from database into AppShared.templates
    static func loadTemplates(completionHandler: @escaping (EasyDocError?) -> Void) {
        // Setting loading user as true
        AppShared.isLoadingTemplates.value = true
        
        // Tries to fetch main user object from EasyDoc's Database
        DatabaseManager.fetchTemplates() {
            (templatesFetched, fetchingError) in
            
            // Verifying possible errors
            if let error = fetchingError {
                AppShared.isLoadingTemplates.value = false
                completionHandler(error)
                return
            }
            
            // Gettings templates
            guard let templates = templatesFetched else {
                AppShared.isLoadingTemplates.value = false
                completionHandler(EasyDocGeneralError.unexpectedError)
                return
            }
            
            // Setting templates
            AppShared.templates = templates
            AppShared.isLoadingTemplates.value = false
            
            completionHandler(nil)
        }
    }
    
    
    /// Reloads main user object by user object signed into EasyDoc's Firebase Server
    static func reloadMainUser(completionHandler: @escaping (EasyDocError?) -> Void) {
        // Veryfying if user is logged in firebase
        guard let user = Auth.auth().currentUser else {
            completionHandler(EasyDocOfflineError.foundNil)
            return
        }
        
        guard let userEmail = user.email else {
            completionHandler(EasyDocOfflineError.foundNil)
            return
        }
        
        self.loadMainUser(email: userEmail) {
            loadingError in
            
            if let error = loadingError {
                completionHandler(error)
                return
            }
            
            completionHandler(nil)
        }
    }
    
}
