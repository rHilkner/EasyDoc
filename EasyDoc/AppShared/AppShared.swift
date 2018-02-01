//
//  AppShared.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 24/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation


/// Central class of the app, with all attributes and functions static and, therefore, shared between all classes of the app
class AppShared {
    /// User logged in the application
    static var mainUser: MainUser?
    /// All document templates loaded from the database
    static var templates: [Template]?
    /// Struct to indicate if the user session is being loaded and to call method on delegate to tell when loading has ended
    static var isLoadingUser = IsLoadingUser()
    /// Struct to indicate if the templates is being loaded and to call method on delegate to tell when loading has ended
    static var isLoadingTemplates = IsLoadingTemplates()
}


/***** IS LOADING USER *****/

/// Struct to indicate if the user session is being loaded and to call method on delegate to tell when loading has ended
struct IsLoadingUser {
    /// Indicates if the user session is being loaded
    var value: Bool = false {
        willSet (newValue) {
            if newValue == false && self.delegate != nil {
                self.delegate!.loadingEnded()
                self.delegate = nil
            }
        }
    }
    
    /// Sets a view controller as delegate of isLoadingUser.
    var delegate: IsLoadingUserDelegate? = nil
}

/// Protocol whose methods may be called when user session loading has ended
protocol IsLoadingUserDelegate {
    /// Called when user session loading has ended
    func loadingEnded()
}


/***** IS LOADING TEMPLATES *****/

/// Struct to indicate if the user session is being loaded and to call method on delegate to tell when loading has ended
struct IsLoadingTemplates {
    /// Indicates if the user session is being loaded
    var value: Bool = false {
        willSet (newValue) {
            if newValue == false && self.delegate != nil {
                self.delegate!.loadingEnded()
                self.delegate = nil
            }
        }
    }
    
    /// Sets a view controller as delegate of isLoadingUser.
    var delegate: IsLoadingTemplatesDelegate? = nil
}

/// Protocol whose methods may be called when templates loading has ended.
protocol IsLoadingTemplatesDelegate {
    /// Called when templates loading has ended
    func loadingEnded()
}

