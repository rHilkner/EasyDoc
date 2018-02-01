//
//  DateExtensions.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 29/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

extension Date {
    
    /// Returns string of the date in the format: "yyyy-MM-dd HH:mm:ss"
    func toString() -> String {
        return DateFormatter().string(from: self)
    }
}
