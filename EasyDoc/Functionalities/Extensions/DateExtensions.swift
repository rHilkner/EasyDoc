//
//  DateExtensions.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 29/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import Foundation

extension Date {
    
    /// Returns string of the date in the format: "HH:mm - dd/MM/yyyy"
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm - dd/MM/yyyy"
        
        return dateFormatter.string(from: self)
    }
}
