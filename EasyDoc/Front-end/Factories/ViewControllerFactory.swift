//
//  ViewControllerFactory.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 02/03/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import UIKit

public enum ViewControllerType: String {
    
    case authNavigationController = "AuthNavigationController"
    case login = "LoginViewController"
    case signUp = "SignUpViewController"

    case mainTabBarController = "MainTabBarController"

    case documentsNavigationController = "DocumentsNavigationController"
    case documents = "DocumentsViewController"
    case document = "DocumentTableViewController"
    case documentContents = "DocumentContentsViewController"
    case documentField = "DocumentFieldTableViewController"
    
    case templates = "TemplatesViewController"
    case template = "TemplateTableViewController"
    case templateContents = "TemplateContentsViewController"
    case templateField = "TemplateFieldTableViewController"

    case settingsNavigationController = "SettingsNavigationController"
    case settings = "SettingsTableViewController"

}

class ViewControllerFactory {

    static func instantiateViewController(ofType type: ViewControllerType) -> UIViewController {

        switch type {

        /***** AUTH CONTROLLERS *****/

        case .authNavigationController:
            let storyboard = StoryboardFactory.instantiateStoryboard(type: StoryboardType.auth)
            let viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerType.authNavigationController.rawValue)
            return viewController
            
        case .login:
            let storyboard = StoryboardFactory.instantiateStoryboard(type: StoryboardType.auth)
            let viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerType.login.rawValue) as! LoginViewController
            return viewController
        
        case .signUp:
            let storyboard = StoryboardFactory.instantiateStoryboard(type: StoryboardType.auth)
            let viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerType.signUp.rawValue) as! SignUpViewController
            return viewController

        /***** MAIN TAB BAR CONTROLLER *****/
        
        case .mainTabBarController:
            let storyboard = StoryboardFactory.instantiateStoryboard(type: StoryboardType.main)
            let viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerType.mainTabBarController.rawValue)
            return viewController

        /***** DOCUMENTS CONTROLLERS *****/
        
        case .documentsNavigationController:
            let storyboard = StoryboardFactory.instantiateStoryboard(type: StoryboardType.documents)
            let viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerType.documentsNavigationController.rawValue)
            return viewController
        
        case .documents:
            let storyboard = StoryboardFactory.instantiateStoryboard(type: StoryboardType.documents)
            let viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerType.documents.rawValue) as! DocumentsViewController
            return viewController
        
        case .document:
            let storyboard = StoryboardFactory.instantiateStoryboard(type: StoryboardType.documents)
            let viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerType.document.rawValue) as! DocumentTableViewController
            return viewController

        case .documentField:
            let storyboard = StoryboardFactory.instantiateStoryboard(type: StoryboardType.documents)
            let viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerType.documentField.rawValue) as! DocumentFieldTableViewController
            return viewController
        
        case .documentContents:
            let storyboard = StoryboardFactory.instantiateStoryboard(type: StoryboardType.documents)
            let viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerType.documentContents.rawValue) as! DocumentContentsViewController
            return viewController

        /***** TEMPLATES CONTROLLERS *****/

        case .templates:
            let storyboard = StoryboardFactory.instantiateStoryboard(type: StoryboardType.templates)
            let viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerType.templates.rawValue) as! TemplatesViewController
            return viewController
        
        case .template:
            let storyboard = StoryboardFactory.instantiateStoryboard(type: StoryboardType.templates)
            let viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerType.template.rawValue) as! TemplateTableViewController
            return viewController

        case .templateField:
            let storyboard = StoryboardFactory.instantiateStoryboard(type: StoryboardType.templates)
            let viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerType.templateField.rawValue) as! TemplateFieldTableViewController
            return viewController
        
        case .templateContents:
            let storyboard = StoryboardFactory.instantiateStoryboard(type: StoryboardType.templates)
            let viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerType.templateContents.rawValue) as! TemplateContentsViewController
            return viewController

        /***** SETTINGS CONTROLLERS *****/

        case .settingsNavigationController:
            let storyboard = StoryboardFactory.instantiateStoryboard(type: StoryboardType.settings)
            let viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerType.settingsNavigationController.rawValue)
            return viewController
        
        case .settings:
            let storyboard = StoryboardFactory.instantiateStoryboard(type: StoryboardType.settings)
            let viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerType.settings.rawValue) as! SettingsTableViewController
            return viewController
        }
    }
    
}
