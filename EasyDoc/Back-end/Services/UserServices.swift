//
//  FetchingServices.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 29/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Firebase

class UserServices {
    
    /// Loads MainUser object fetched from database into AppShared.mainUser.
    /// Note: It is extremely important for the developer to set AppShared.isLoadingUser.value = true before calling this method.
    static func loadMainUser(email: String, completionHandler: @escaping (EasyDocError?) -> Void) {
        
        // Tries to fetch main user object from EasyDoc's Database
        UserPersistence.fetchMainUser(email: email) {
            (mainUser, fetchUserError) in
        
            
            if fetchUserError != nil {
                DispatchQueue.main.async {
                    // Not loading user anymore
                    AppShared.isLoadingUser.value = false
                }
                
                completionHandler(fetchUserError)
                return
            }
            
            guard AuthServices.performInAppLogin(mainUser: mainUser!) else {
                DispatchQueue.main.async {
                    // Not loading user anymore
                    AppShared.isLoadingUser.value = false
                }
                
                completionHandler(EasyDocOfflineError.inAppLoginError)
                return
            }

            DispatchQueue.main.async {
                // Not loading user anymore
                AppShared.isLoadingUser.value = false
            }

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
