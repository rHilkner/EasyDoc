//
//  StoryboardFactory.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 02/03/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation
import UIKit

public enum StoryboardType: String {
    
    case main = "Main"
    case auth = "Auth"
    case documents = "Documents"
    case templates = "Templates"
    case settings = "Settings"
    
}

class StoryboardFactory {
    
    static func instantiateStoryboard(type: StoryboardType) -> UIStoryboard {
        switch type {
            
        case .main:
            return UIStoryboard(name: StoryboardType.main.rawValue, bundle: nil)
        case .auth:
            return UIStoryboard(name: StoryboardType.auth.rawValue, bundle: nil)
        case .documents:
            return UIStoryboard(name: StoryboardType.documents.rawValue, bundle: nil)
        case .templates:
            return UIStoryboard(name: StoryboardType.templates.rawValue, bundle: nil)
        case .settings:
            return UIStoryboard(name: StoryboardType.settings.rawValue, bundle: nil)
            
        }
    }
    
}
